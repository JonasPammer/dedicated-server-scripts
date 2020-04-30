#!/bin/bash
#
# @author PixelTutorials
# Originally Code from:
# https://github.com/samwilson/MediaWiki_Backup/blob/master/restore.sh
#
# Note: "MW[B][R]_" is an abbreviation of "MediaWiki[Backup][Restore]_".
# If a variable gets used in both cases it should have both "B" and "R". Otherwise only the one its being used in.
#
set -eo pipefail
check_is_utils_initialized
source_utils "mediawiki"
source_utils "mysql"

# User-chosen path to backup-file to apply (tar.gz). Gets expanded in 'mwr_expand_single_archive'
MWR_ARCHIVE_FILE=""
# 'basename' of the above 'MWR_ARCHIVE_FILE'
MWR_ARCHIVE_BASENAME=""
# Dynamically created, temporary directory with the same name as MWR_ARCHIVE_BASENAME but without it's extension (${%%.*}})
MWR_TMP_DIR=""

# If present, mwr_restore_database will also be called
RESTORE_DB=true
# If present, mwr_restore_user will also be called
RESTORE_USER=true

## see 'mwr_retrieve_archive_info' for the following 3 variables:
MWR_FS_BACKUP=""
MWR_IMG_BACKUP=""
MWR_PAGESXML_BACKUP=""
MWR_SQLFILE=""

mwr_ask_backup_and_destination(){
  log_info "= Ask user for location of backup-file to apply..."
  # Keep asking until the user chose a backup-file
  while [[ -z "${MWR_ARCHIVE_FILE}" ]] || [[ ! -f "${MWR_ARCHIVE_FILE}" ]]; do
    dialog --backtitle "${SCRIPT_NAME}" --title "Please choose the backup file to apply." \
        --fselect "${MWBR_PARENT_FOLDER}" 10 0 0 \
        2>"${TEMP_DIR}/mediawiki_restore-backup_location.choice"
    MWR_ARCHIVE_FILE=$(cat "${TEMP_DIR}/mediawiki_restore-backup_location.choice")
  done
  log_info "== User chose archive-file: '${MWR_ARCHIVE_FILE}'"

  log_info "= Ask user for location of destination to restore in..."
  # Keep asking until the user chose a destination-dir
  while [[ -z "${MWBR_INSTALL_DIR}" ]]; do
    dialog --backtitle "${SCRIPT_NAME}" --title "Please choose the destination-directory." \
        --fselect "${MW_DEFAULT_INSTALL_DIR}" 10 0 0 \
        2>"${TEMP_DIR}/mediawiki_restore-destination_location.choice"
    MWBR_INSTALL_DIR=$(cat "${TEMP_DIR}/mediawiki_restore-destination_location.choice")
  done
  log_info "== User chose destination: '${MWBR_INSTALL_DIR}'"

  if [[ ! -d "${MWBR_INSTALL_DIR}" ]]; then
    log_info "== '${MWBR_INSTALL_DIR}' does not exist! Creating directory..."
    mkdir --parents "${MWBR_INSTALL_DIR}";
    if [[ ! -d "${MWBR_INSTALL_DIR}" ]]; then
        log_error "=== Given wiki installation directory does not exist and cannot be created"
        exit 1;
    fi
  fi
}

## Archive expansion
mwr_expand_single_archive() {
  MWR_ARCHIVE_BASENAME=$(basename ${MWR_ARCHIVE_FILE})
  MWR_TMP_DIR="/tmp/"${MWR_ARCHIVE_BASENAME%%.*}
  mkdir -p ${MWR_TMP_DIR}
  log_info "= (Expanding single-archive '$MWR_ARCHIVE_FILE' to '${MWR_TMP_DIR}'..."
  tar -xzf "$MWR_ARCHIVE_FILE" -C ${MWR_TMP_DIR}
}

## Getting the archive date
mwr_retrieve_archive_info() {
  local -r archive_date=${MWR_ARCHIVE_BASENAME%-*}
  MWBR_BACKUP_PREFIX=${MWR_TMP_DIR}/${archive_date}
  log_info "= Restoring archive '${MWR_ARCHIVE_BASENAME}' dated of $archive_date."


  # Analyze the filesystem restoration options
  ## A filesystem backup-folder has the following syntax: ${MWBR_BACKUP_PREFIX}"-filesystem.tar.gz"
  MWR_FS_BACKUP=${MWBR_BACKUP_PREFIX}"-filesystem.tar.gz"
  if [[ ! -e ${MWR_FS_BACKUP} ]]; then
    MWR_FS_BACKUP=
  fi


  # Analyze the images restoration options
  ## A images backup-folder has the following syntax: ${MWBR_BACKUP_PREFIX}"-images.tar.gz"
  MWR_IMG_BACKUP=${MWBR_BACKUP_PREFIX}"-images.tar.gz"
  if [[ ! -e ${MWR_IMG_BACKUP} ]]; then
    MWR_IMG_BACKUP=
  fi


  # Analyze DB restoration options
  ## A database backup-file has the following syntax: ${MWBR_BACKUP_PREFIX}"-database_${MWBR_DB_CHARSET}.sql.gz"
  MWR_SQLFILE=${MWR_TMP_DIR}/$(ls ${MWR_TMP_DIR} |grep "database"|head -1)
  local -r _end_sql=${MWR_SQLFILE##*_}
  ARCHIVE_DB_CHARSET=${_end_sql%%.*}
  log_info "== SQL dump '$(basename ${MWR_SQLFILE})' found, with charset '$ARCHIVE_DB_CHARSET'."


  # Analyze Pages restoration options
  ## A database backup-file has the following syntax: ${MWBR_BACKUP_PREFIX}"-pages.xml.gz"
  MWR_PAGESXML_BACKUP=${MWBR_BACKUP_PREFIX}"-pages.tar.gz"
  if [[ ! -e ${MWR_PAGESXML_BACKUP} ]]; then
    MWR_PAGESXML_BACKUP=
  fi
}

mwr_restore_database() {
  sql_make_query_and_return_exitcode "CREATE DATABASE ${MWBR_DB_NAME};"
}

#Information taken from here http://www.mediawiki.org/wiki/Manual:Installation/Creating_system_accounts
#Compared to show grants for '$user'@host, which showed that 'WITH GRANT OPTION' was not set by the original installation in version 1.17
# \note the % system is any IP, but does not work for localhost ! see http://stackoverflow.com/questions/10823854/using-for-host-when-creating-a-mysql-user
mwr_restore_user() {
  log_info "= Granting user '${MWBR_DB_USER}' all privileges on \`${MWBR_DB_NAME}.*\`..."
  sql_make_query_and_return_exitcode "GRANT ALL PRIVILEGES ON \`${MWBR_DB_NAME}\`.* TO '${MWBR_DB_USER}'@'localhost' IDENTIFIED BY '${MWBR_DB_PASS}';"
}

# Database restoration
mwr_restore_database_content() {
  log_info "= Start Restore Database Content"
  if [[ -z ${MWBR_DB_NAME} ]]; then
    log_error "== No database was found, cannot restore sql dump. Aborting..."
    return 1
  fi

  log_info "== Restoring database '${MWBR_DB_NAME}' using queries from file '${MWR_SQLFILE}'..."
  gunzip -c "${MWR_SQLFILE}" | mysql --host=${MWBR_DB_HOST} ${MWBR_DB_NAME}
}

# Filesystem restoration
mwr_restore_filesystem() {
  log_info "= Extracting filesystem from '$MWR_FS_BACKUP' to '${MWBR_INSTALL_DIR}'..."
  tar -xzf "$MWR_FS_BACKUP" -C ${MWBR_INSTALL_DIR}
}

# Images restoration
mwr_restore_images() {
    log_info "= Extracting images from '$MWR_IMG_BACKUP' to '${MWBR_INSTALL_DIR}'..."
    tar -xzf "$MWR_IMG_BACKUP" -C ${MWBR_INSTALL_DIR}
}

# UNUSED / UNTESTED (yet). See https://www.mediawiki.org/wiki/Manual:Importing_XML_dumps
mwr_restore_pagecontents() {
    log_info "= Running MediaWiki's Maintenance-Script 'importDump.php' in '${MWBR_INSTALL_DIR}/maintenance'.."

    # "If the file is compressed and that has a .gz or .bz2 file extension, it is decompressed automatically."
    php -d error_reporting=E_ERROR importDump.php \
        --conf="${MWBR_INSTALL_DIR}/LocalSettings.php" "$MWR_PAGESXML_BACKUP" \
        --quiet --full --logs
}

# Archive clean-up
mwr_cleanup_archive_expansion() {
  log_info "= (Removing temporary file '${MWR_TMP_DIR}'..."
  rm -r ${MWR_TMP_DIR}
}



call_module(){
  mwr_ask_backup_and_destination
  mwr_expand_single_archive
  mwr_retrieve_archive_info

  if [[ ! -z ${MWR_FS_BACKUP} ]]; then
    mwr_restore_filesystem
  else
    log_error "= No filesystem-archive was found. Seeing if there's at least an image-archive..."
    if [[ ! -z ${MWR_IMG_BACKUP} ]]; then
        mwr_restore_images
    else
        log_error "== No image archive was found."
    fi
  fi

  mwbr_fetch_localsettings_vars

  if [[ ! -z ${RESTORE_DB} ]];then
    mwr_restore_database
  fi
  if [[ ! -z ${RESTORE_USER} ]];then
    mwr_restore_user
  fi

  mwr_restore_database_content

  # The backup procedure would save LocalSettings in read-only mode
  mwbr_toggle_read_only "OFF"

  mwr_cleanup_archive_expansion
}