#!/bin/bash
#
# @author PixelTutorials
# Originally Code from:
# https://github.com/samwilson/MediaWiki_Backup/blob/master/backup.sh,
# https://gist.github.com/pklaus/737577 and
# https://www.mediawiki.org/wiki/Manual:Backing_up_a_wiki/de
#
# Note: "MW[B][R]_" is an abbreviation of "MediaWiki[Backup][Restore]_".
# If a variable gets used in both cases it should have both "B" and "R". Otherwise only the one its being used in.
#
set -eo pipefail
check_is_utils_initialized
source_utils "mediawiki"

MWBR_INSTALL_DIR=""
MWB_DEREFERENCE_IMG=true
MWB_COMPLETE=true
MWB_COMBINE_ARCHIVES=true

# Dynamically generated Date
MWB_PREFIX=""
# Dynamically generated Path with the syntax of ${MWBR_PARENT_FOLDER}${name_of_wiki_instance_folder}
MWB_BACKUP_DIR=""
# Dynamically generated Path with the syntax of ${MWB_BACKUP_DIR}/${MWB_PREFIX}
# Used to get the name of the actual backup, like: ${MWBR_BACKUP_PREFIX}"-images.tar.gz"
MWBR_BACKUP_PREFIX=""

# Each 'export_'-function appends the path (seperated by a blank-space) to the file created by the mentioned function
# Used to/by mwb_combine_archives
MWB_RUNNING_FILES=""

#######################################
# Asks the user for the MWBR_INSTALL_DIR
# and dynamically generates the location of the Backup (MWB_PREFIX, MWB_BACKUP_DIR, MWBR_BACKUP_PREFIX)
#######################################
mwb_ask_instance_and_choose_backup_dir(){
  log_info "= Ask user for location of wiki-instance to backup..."
  # Keep asking until the user chose a file-path that at-least contains a LocalSettings.php
  while [[ -z "${MWBR_INSTALL_DIR}" ]] || [[ ! -e "${MWBR_INSTALL_DIR}/LocalSettings.php" ]]; do
    dialog --backtitle "${SCRIPT_NAME}" --title "Please choose the wiki installation directory." \
        --fselect "${MW_DEFAULT_INSTALL_DIR}" 10 0 0 \
        2>"${TEMP_DIR}/mediawiki_backup-instance_location.choice"
    MWBR_INSTALL_DIR=$(cat "${TEMP_DIR}/mediawiki_backup-instance_location.choice")
  done

  # Avoid symlink. Get actual path.
  MWBR_INSTALL_DIR=$(cd "${MWBR_INSTALL_DIR}"; pwd -P)
  log_info "== User chose path to wiki-installation: '${MWBR_INSTALL_DIR}'"

  local -r name_of_wiki_instance_folder="${MWBR_INSTALL_DIR##*/}"

  MWB_PREFIX=$(date +'%Y-%m-%dT%H-%M-%S')
  MWB_BACKUP_DIR="${MWBR_PARENT_FOLDER}${name_of_wiki_instance_folder}"
  mkdir -p "${MWB_BACKUP_DIR}"

  # Avoid symlink. Get actual path.
  MWB_BACKUP_DIR=$(cd "${MWB_BACKUP_DIR}"; pwd -P)

  MWBR_BACKUP_PREFIX="${MWB_BACKUP_DIR}/${MWB_PREFIX}"
}

#######################################
# Dump database to SQL
# Kudos to https://github.com/milkmiruku/backup-mediawiki
#######################################
mwb_export_sql() {
  sql_dump_file=${MWBR_BACKUP_PREFIX}"-database_${MWBR_DB_CHARSET}.sql.gz"
  log_info "= Export SQL to '$sql_dump_file'"
  log_info "== Running mysqldump with high-priority using nice.."
  nice -n 19 mysqfldump --single-transaction \
      --default-character-set=${MWBR_DB_CHARSET} \
      --host=${MWBR_DB_HOST} \
      --user=${MWBR_DB_USER} \
      --password=${MWBR_DB_PASS} \
      ${MWBR_DB_NAME} | gzip -9 > ${sql_dump_file}

  # Ensure dump worked
  MySQL_RET_CODE=$?
  if [[ ${MySQL_RET_CODE} -ne 0 ]]; then
      ERR_NUM=3
      log_error "=== MySQL Dump failed! (return code of MySQL: $MySQL_RET_CODE)"
      exit ${ERR_NUM}
  fi
  MWB_RUNNING_FILES="${MWB_RUNNING_FILES} ${sql_dump_file}"
}

#######################################
# Kudos to http://brightbyte.de/page/MediaWiki_backup
#######################################
mwb_export_xml() {
  xml_dump_file=${MWBR_BACKUP_PREFIX}"-pages.xml.gz"
  log_info "= Export XML to '$xml_dump_file'"
  cd "${MWBR_INSTALL_DIR}/maintenance"
  ## Make sure PHP is found.
  if hash php 2>/dev/null; then
    log_info "== Running MediaWiki's Maintenance-Script 'dumpBackup.php' in '${MWBR_INSTALL_DIR}/maintenance'.."
    php -d error_reporting=E_ERROR dumpBackup.php \
        --conf="${MWBR_INSTALL_DIR}/LocalSettings.php" \
        --quiet --full --logs --uploads \
        | gzip -9 > "${xml_dump_file}"

    MWB_RUNNING_FILES="${MWB_RUNNING_FILES} $xml_dump_file"
  else
    log_error "== Unable to find PHP; Skipping this Step..."
  fi
}

#######################################
# Export the "images" directory
#######################################
mwb_export_images() {
  images_backup_file=${MWBR_BACKUP_PREFIX}"-images.tar.gz"
  log_info "= Export images to '$images_backup_file'"
  if [[ -z "${MWB_DEREFERENCE_IMG}" && -h "${MWBR_INSTALL_DIR}/images" ]]; then
      log_error "== Warning: images directory is a symlink, but you have not selected to follow symlinks"
  fi

  local optional_tar_option=""
  if [[ "${MWBR_INSTALL_DIR}" = true ]]; then
      optional_tar_option="--dereference"
  fi
  cd "${MWBR_INSTALL_DIR}"
  log_info "== Starting compression..."
  tar --create --exclude-vcs ${optional_tar_option} --gzip --file "$images_backup_file" images
  MWB_RUNNING_FILES="${MWB_RUNNING_FILES} $images_backup_file"
}

#######################################
# Export the complete install-directory
#######################################
mwb_export_filesystem() {
    local -r fs_backup_file=${MWBR_BACKUP_PREFIX}"-filesystem.tar.gz"
    log_info "= Compressing COMPLETE mediawiki directory to '$fs_backup_file'..."
    tar --exclude-vcs -czhvf "$fs_backup_file" -C "${MWBR_INSTALL_DIR}" .
    MWB_RUNNING_FILES="${MWB_RUNNING_FILES} $fs_backup_file"
}

#######################################
## Consolidate to one archive
#######################################
mwb_combine_archives() {
    local -r full_archive_file=${MWBR_BACKUP_PREFIX}"-mediawiki_backup.tar.gz"
    log_info "= Consolidating/Combining exports (${MWB_RUNNING_FILES}) into one single archive-file '$full_archive_file' and removing original/temporary/running files in the process...."
    # The --transform option is responsible for keeping the basename only
    tar -zcf "$full_archive_file" ${MWB_RUNNING_FILES} --remove-files --transform='s|.*/||'
}

call_module(){
  # Preparation
  mwb_ask_instance_and_choose_backup_dir
  mwbr_fetch_localsettings_vars
  mwbr_toggle_read_only "ON"

  mwb_export_sql
  mwb_export_xml

  # Exports files from the installation directory.
  if [[ "$MWB_COMPLETE" = true ]]; then
      mwb_export_filesystem
  else
      mwb_export_images
  fi

  if [[ "$MWB_COMBINE_ARCHIVES" = true ]]; then
    mwb_combine_archives
  fi

  mwbr_toggle_read_only "OFF"
}