#!/bin/bash
#
# @author PixelTutorials
#
set -eo pipefail
check_is_utils_initialized
source_utils "mediawiki"
source_utils "lamp"
source_utils "file"


# Gets copied to the actual folder at the end. Contains the built LocalSettings.php-File (see below) and 2 sub-folders ("extensions" and "skins")
export MW_EXTENSIONS_AND_SKINS_TEMP_DIR="${TEMP_DIR}mediawiki-exts_and_skins"
# The content of this file mostly contains instructions on enabling extensions and making some settings on them. See ask_for_webinstall_file_and_copy_and_append_script_generated_content
export MW_TEMP_LOCALSETTINGS_FILE="${TEMP_DIR}TODO_ADD_TO_LocalSettings_AFTER_WEB_INSTALL.php"

export MW_DIR_TO_INSTALL_IN="${MW_DEFAULT_INSTALL_DIR}"

#   1 - Name of the Extension
#   2 - URL to the download-link (mostly extdist.wmflabs.org)
_mw_download_and_move_and_add_extension(){
  mkdir -p "${MW_EXTENSIONS_AND_SKINS_TEMP_DIR}/extensions"
  log_info "== Start Extension ${1}."

  log_info "=== Downloading from '${2}' to '${TEMP_DIR}${1}-REL1_34.tar.gz'..."
  wget "${2}" --output-document "${TEMP_DIR}${1}-REL1_34.tar.gz" | log_debug_output

  log_info "=== Unpacking from '${TEMP_DIR}${1}-REL1_34.tar.gz' to '${MW_EXTENSIONS_AND_SKINS_TEMP_DIR}/extensions'..."
  tar -xzf "${TEMP_DIR}${1}-REL1_34.tar.gz" -C "${MW_EXTENSIONS_AND_SKINS_TEMP_DIR}/extensions" | log_debug_output

  log_info "=== Adding line 'wfLoadExtension( '${1}' );' to file '${MW_TEMP_LOCALSETTINGS_FILE}'..."
  echo "wfLoadExtension( '${1}' );" \
          >> "${MW_TEMP_LOCALSETTINGS_FILE}"
}

#   1 - Name of the Skin
#   2 - URL to the download-link (mostly extdist.wmflabs.org)
_mw_download_and_move_and_add_skin(){
  mkdir -p "${MW_EXTENSIONS_AND_SKINS_TEMP_DIR}/skins"
  log_info "== Start Skin ${1}."

  log_info "=== Downloading from '${2}' to '${TEMP_DIR}${1}.tar.gz'..."
  wget "${2}" --output-document "${TEMP_DIR}${1}.tar.gz" | log_debug_output

  log_info "=== Unpacking from '${TEMP_DIR}${1}.tar.gz' to '${MW_EXTENSIONS_AND_SKINS_TEMP_DIR}/skins'..."
  tar -xzf "${TEMP_DIR}${1}.tar.gz" -C "${MW_EXTENSIONS_AND_SKINS_TEMP_DIR}/skins"

  log_info "=== Adding line 'wfLoadSkin( '${1}' );' to file '${MW_TEMP_LOCALSETTINGS_FILE}'..."
  echo "wfLoadSkin( '${1}' );"  \
          >> "${MW_TEMP_LOCALSETTINGS_FILE}"
}






prepare_php(){
  #
  # https://www.mediawiki.org/wiki/Manual:Running_MediaWiki_on_Debian_or_Ubuntu#lamp_install_Stack
  #
  # Ubuntu 16.04.2 LTS (Xenial) and Debian Stretch include PHP 7.0, and renamed many packages from "php5" to plain "php". In addition, some PHP modules are now in separate packages (xml, mbstring).
  log_info "== (Unattended) Installing required PHP-Mods..."
  apt_get_without_interaction "install" "php-mysql libapache2-mod-php php-xml php-mbstring" | log_debug_output

  #
  # https://www.mediawiki.org/wiki/Manual:Running_MediaWiki_on_Debian_or_Ubuntu#Optional_useful_packages
  #
  # Alternative PHP Cache         php-apcu or php5-apcu	    Modern MediaWiki versions will automatically take advantage of this being installed for improved performance.
  # PHP Unicode normalization     php-intl or php5-intl	    MediaWiki will fallback to a slower PHP implementation if not available.
  # ImageMagick                   imagemagick	              Image thumbnailing.
  # Inkscape	  q                 inkscape	                Alternative means of SVG thumbnailing, than ImageMagick. Sometimes it will render SVGs better if originally created in Inkscape.
  # PHP GD library	              php-gd or php5-gd	        Alternative to ImageMagick for image thumbnailing.
  # PHP command-line	            php-cli or php5-cli	      Ability to run PHP commands from the command line, which is useful for debugging and running maintenance scripts.
  # PHP cURL	                    php-curl or php5-curl	    Required by some extensions such as Extension:Math. See Manual:cURL
  # git source control version	  git	                      If not present config script will tell you that it is not installed
  log_info "== (Unattended) Installing optional but useful PHP-Mods..."
  apt_get_without_interaction "install" "php-apcu php-intl imagemagick inkscape php-gd php-cli php-curl git" | log_debug_output

  log_info "=== Making sure mod 'apcu' is enabled..."
  phpenmod "apcu" | log_debug_output

  # As noticed in the offical mediawiki-link about the installation-process above:
  # "If you install php-apcu you will have to reload your apache configuration in order to avoid a warning message when running configuration script:"
  log_info "== Reloading Apache2..."
  service apache2 reload | log_debug_output
}

download_and_install_mediawiki() {
  log_info "== Downloading the official mediawiki-tarball to '${TEMP_DIR}'..."
  wget "https://releases.wikimedia.org/mediawiki/1.34/mediawiki-1.34.1.tar.gz" \
          --output-document "${TEMP_DIR}mediawiki-1.34.1.tar.gz" | log_debug_output

  log_info "== Extracting tarball into web-directory at '${MW_DIR_TO_INSTALL_IN}'..."
  tar -xzf "${TEMP_DIR}mediawiki-1.34.1.tar.gz" -C "${TEMP_DIR}" | log_debug_output
  mkdir -p "${MW_DIR_TO_INSTALL_IN}" | log_debug_output
  mv ${TEMP_DIR}mediawiki-1.34.1/* "${MW_DIR_TO_INSTALL_IN}" | log_debug_output

  log_info "=== Creating symbolic link at \"/var/www/html/mediawiki\"..."
  ln -s "${MW_DIR_TO_INSTALL_IN}" "/var/www/html/mediawiki" | log_debug_output

  log_info "=== Giving target directory proper permissions..."
  chown -R www-data:www-data "${MW_DIR_TO_INSTALL_IN}" | log_debug_output
}

ask_create_needed_sql(){
  log_info "== Start Pre-Creation of mysql."
  # TODO Untested

  set +e # Do NOT quit if the following EXIT-CODE is other than 0
  dialog --backtitle "${SCRIPT_NAME}" --title "Create new SQL-User and grant all privileges?" \
    --yesno "Should this script create a new SQL-User with a chosen username, a custom/generated password and a table with his-exact-name on which he has all privileges on?" 0 0
  local -r dialog_response=$?
  set -e

  if [[ "${dialog_response}" -ne 0 ]]; then # no or ESC
    log_debug "=== User chose skip step create_needed_sql..."
    return
  else
    log_debug "=== User chose to create_needed_sql..."
    local sql_username="mediawiki"
    until ! sql_does_user_exist "${sql_username}"; do
      read -s "*** Please enter an AVAILABLE SQL-Username to create (A database with the same name will be created, and this user will be granted all privileges on it!): " sql_username
      echo
    done

    log_info "== Generating password for given SQL-User '${sql_username}'..."
    local -r generated_sql_password="$(rand_generate_password_without_symbols 20)"

    echo "*** Generated password for SQL-User '${sql_username}': ${generated_sql_password}"
    log_info "PLEASE NOTE/WRITE/REMEMBER THE ABOVE MENTIONED PASSWORD!"

    read -p "*** Warning! The database '${sql_username}' will now be dropped if it exists! Press enter to continue..."

    log_info "== Dropping Database '${sql_username}'..."
    sql_make_query_and_echo "DROP DATABASE IF EXISTS '${sql_username}'" |& log_debug_output

    log_info "=== Creating SQL-User '${sql_username}' and granting all privileges on new Database '${sql_username}'."
    sql_create_user_and_same_name_database_and_grant_privileges "${sql_username}" "${generated_sql_password}"
  fi
}

install_extensions(){
  #
  # Renameuser - provides a special page which allows authorized users to rename user accounts. (This will cause page histories, etc. to be updated)
  # https://www.mediawiki.org/wiki/Extension:Renameuser
  # Snapshot for MediaWiki 1.34 as of 25.04.2020 from: https://www.mediawiki.org/wiki/Special:ExtensionDistributor?extdistname=Renameuser&extdistversion=REL1_34
  _mw_download_and_move_and_add_extension "Renameuser" "https://extdist.wmflabs.org/dist/extensions/Renameuser-REL1_34-5fae241.tar.gz"


  #
  # ReplaceText - provides a special page, as well as a command-line script, to allow administrators to do a global string find-and-replace on both the text and titles of the wiki's content pages.
  # https://www.mediawiki.org/wiki/Extension:Replace_Text
  # Snapshot for MediaWiki 1.34 as of 25.04.2020 from: https://www.mediawiki.org/wiki/Special:ExtensionDistributor?extdistname=ReplaceText&extdistversion=REL1_34
  _mw_download_and_move_and_add_extension "ReplaceText" "https://extdist.wmflabs.org/dist/extensions/ReplaceText-REL1_34-bd08cbd.tar.gz"


  #
  # WikiEditor - provides an improved interface for editing wikitext.
  # https://www.mediawiki.org/wiki/Extension:WikiEditor
  # Snapshot for MediaWiki 1.34 as of 25.04.2020 from: https://www.mediawiki.org/wiki/Special:ExtensionDistributor?extdistname=WikiEditor&extdistversion=REL1_34
  _mw_download_and_move_and_add_extension "WikiEditor" "https://extdist.wmflabs.org/dist/extensions/WikiEditor-REL1_34-57eb9ad.tar.gz"

  # Set to be enabled by default
  echo "\$wgDefaultUserOptions['usebetatoolbar'] = 1; // user option provided by WikiEditor extension" \
          >> "${MW_TEMP_LOCALSETTINGS_FILE}"


  #
  # (Depends on WikiEditor)
  # CodeEditor - extends the WikiEditor advanced editing toolbar with an embedded Ace editor widget, providing some handy features for user/site JS, CSS pages.
  # https://www.mediawiki.org/wiki/Extension:CodeEditor
  # Snapshot for MediaWiki 1.34 as of 25.04.2020 from: https://www.mediawiki.org/wiki/Special:ExtensionDistributor?extdistname=CodeEditor&extdistversion=REL1_34
  _mw_download_and_move_and_add_extension "CodeEditor" "https://extdist.wmflabs.org/dist/extensions/CodeEditor-REL1_34-b3fb04b.tar.gz"


  #
  # (Depends on WikiEditor / VisualEditor)
  # CodeMirror - provides syntax highlighting in MediaWiki's wikitext editor. (It adds a button to the editing toolbar to switch)
  # https://www.mediawiki.org/wiki/Extension:CodeMirror
  # Snapshot for MediaWiki 1.34 as of 25.04.2020 from: https://www.mediawiki.org/wiki/Special:ExtensionDistributor?extdistname=CodeMirror&extdistversion=REL1_34
  _mw_download_and_move_and_add_extension "CodeMirror" "https://extdist.wmflabs.org/dist/extensions/CodeMirror-REL1_34-81ce8b3.tar.gz"
  # Set to be enabled by default
  echo "\$wgDefaultUserOptions['usecodemirror'] = 1; // Enables use of CodeMirror by default but still allow users to disable it" \
          >> "${MW_TEMP_LOCALSETTINGS_FILE}"


  #
  # AdvancedSearch - enhances Special:Search by providing an advanced parameters form and improving how namespaces for a search query are selected.
  # https://www.mediawiki.org/wiki/Extension:AdvancedSearch
  # Snapshot for MediaWiki 1.34 as of 25.04.2020 from: https://www.mediawiki.org/wiki/Special:ExtensionDistributor?extdistname=AdvancedSearch&extdistversion=REL1_34
  _mw_download_and_move_and_add_extension "AdvancedSearch" "https://extdist.wmflabs.org/dist/extensions/AdvancedSearch-REL1_34-4affc9c.tar.gz"


  #
  # CategoryTree - provides a dynamic view of the wiki's category structure as a tree.
  # https://www.mediawiki.org/wiki/Extension:CategoryTree
  # Snapshot for MediaWiki 1.34 as of 25.04.2020 from: https://www.mediawiki.org/wiki/Special:ExtensionDistributor?extdistname=CategoryTree&extdistversion=REL1_34
  _mw_download_and_move_and_add_extension "CategoryTree" "https://extdist.wmflabs.org/dist/extensions/CategoryTree-REL1_34-b8ad728.tar.gz"


  #
  # Cite - allows a user to create references as footnotes on a page. It adds two parser hooks to MediaWiki, <ref> and <references />;
  # https://www.mediawiki.org/wiki/Extension:Cite
  # Snapshot for MediaWiki 1.34 as of 25.04.2020 from: https://www.mediawiki.org/wiki/Special:ExtensionDistributor?extdistname=Cite&extdistversion=REL1_34
  _mw_download_and_move_and_add_extension "Cite" "https://extdist.wmflabs.org/dist/extensions/Cite-REL1_34-db87fdc.tar.gz"


  #
  # InputBox - adds already created HTML forms to wiki pages.
  # https://www.mediawiki.org/wiki/Extension:InputBox
  # Snapshot for MediaWiki 1.34 as of 25.04.2020 from: https://www.mediawiki.org/wiki/Special:ExtensionDistributor?extdistname=InputBox&extdistversion=REL1_34
  _mw_download_and_move_and_add_extension "InputBox" "https://extdist.wmflabs.org/dist/extensions/InputBox-REL1_34-e99dc4f.tar.gz"


  #
  # SyntaxHighlight - provides rich formatting of source code using the <syntaxhighlight> tag. (powered by the "Pygments" library - formerly it used "GeSHi"'s)
  # https://www.mediawiki.org/wiki/Extension:SyntaxHighlight
  # Snapshot for MediaWiki 1.34 as of 25.04.2020 from: https://www.mediawiki.org/wiki/Special:ExtensionDistributor?extdistname=SyntaxHighlight_GeSHi&extdistversion=REL1_34
  _mw_download_and_move_and_add_extension "SyntaxHighlight_GeSHi" "https://extdist.wmflabs.org/dist/extensions/SyntaxHighlight_GeSHi-REL1_34-d45d04f.tar.gz"

  # "In Linux, set execute permissions for the pygmentize binary.":
  chmod a+x "${MW_DIR_TO_INSTALL_IN}/extensions/SyntaxHighlight_GeSHi/pygments/pygmentize"

  #
  # PdfHandler - shows uploaded pdf files in a multipage preview layout.
  # https://www.mediawiki.org/wiki/Extension:PdfHandler
  # Snapshot for MediaWiki 1.34 as of 25.04.2020 from: https://www.mediawiki.org/wiki/Special:ExtensionDistributor?extdistname=PdfHandler&extdistversion=REL1_34
  _mw_download_and_move_and_add_extension "PdfHandler" "https://extdist.wmflabs.org/dist/extensions/PdfHandler-REL1_34-23aad38.tar.gz"

  # Install Pre-requisites for PdfHandler
  apt_get_without_interaction "install" "ghostscript xpdf-utils"

  #TODO is configuration needed? https://www.mediawiki.org/wiki/Extension:PdfHandler#Debian


  #
  # ConfirmEdit - lets you use various different CAPTCHA techniques, to try to prevent spambots and other automated tools from editing your wiki, as well as to foil automated login attempts that try to guess passwords.
  # https://www.mediawiki.org/wiki/Extension:ConfirmEdit
  # Snapshot for MediaWiki 1.34 as of 25.04.2020 from: https://www.mediawiki.org/wiki/Special:ExtensionDistributor?extdistname=ConfirmEdit&extdistversion=REL1_34
  _mw_download_and_move_and_add_extension "ConfirmEdit" "https://extdist.wmflabs.org/dist/extensions/ConfirmEdit-REL1_34-45ca059.tar.gz"

  # TODO use/configure hCaptcha when upgrading script to 1.35. The Effectiveness of the "SimpleCaptcha" (simple Text Math problem) is extremely low.
  # I would use ReCaptcha, but it doesn't work with VisualEditor as noted in the above page.
  echo "\$wgCaptchaClass = 'SimpleCaptcha';" \
          >> "${MW_TEMP_LOCALSETTINGS_FILE}"


  #
  # (It's recommended to also install BetaFeatures when installing MultimediaViewer)
  # BetaFeatures - allows other MediaWiki extensions to register beta features with the list of user preferences on the wiki.
  # https://www.mediawiki.org/wiki/Extension:BetaFeatures
  # Snapshot for MediaWiki 1.34 as of 25.04.2020 from: https://www.mediawiki.org/wiki/Special:ExtensionDistributor?extdistname=BetaFeatures&extdistversion=REL1_34
  _mw_download_and_move_and_add_extension "BetaFeatures" "https://extdist.wmflabs.org/dist/extensions/BetaFeatures-REL1_34-d911612.tar.gz"


  #
  # MultimediaViewer - gives the user of a wiki a different interface for viewing full-size, or nearly full-size, images in their browser without extraneous page loads or confusing interstitial pages.
  # https://www.mediawiki.org/wiki/Extension:MultimediaViewer
  # Snapshot for MediaWiki 1.34 as of 25.04.2020 from: https://www.mediawiki.org/wiki/Special:ExtensionDistributor?extdistname=MultimediaViewer&extdistversion=REL1_34
  _mw_download_and_move_and_add_extension "MultimediaViewer" "https://extdist.wmflabs.org/dist/extensions/MultimediaViewer-REL1_34-30ea768.tar.gz"


  #
  # TreeAndMenu - makes bullet lists into folder trees or dynamic drop-down menus.
  # https://www.mediawiki.org/wiki/Extension:TreeAndMenu
  # Download URL as of 25.04.2020 from: https://gitlab.com/Aranad/TreeAndMenu/-/archive/master/TreeAndMenu-master.tar.gz
  _mw_download_and_move_and_add_extension "TreeAndMenu" "https://gitlab.com/Aranad/TreeAndMenu/-/archive/master/TreeAndMenu-master.tar.gz"
   mv "${MW_EXTENSIONS_AND_SKINS_TEMP_DIR}/extensions/TreeAndMenu-master" "${MW_EXTENSIONS_AND_SKINS_TEMP_DIR}/extensions/TreeAndMenu"


  # TODO this step seems to cause problems
  # EmbedVideo - adds a parser function called #ev for embedding video clips from over 24 popular video sharing services
  # https://www.mediawiki.org/wiki/Extension:EmbedVideo
  # Download URL as of 25.04.2020 from: https://gitlab.com/hydrawiki/extensions/EmbedVideo/-/archive/v2.8.0/EmbedVideo-v2.8.0.zip
  # mw_download_and_move_and_add_extension "EmbedVideo" "https://gitlab.com/hydrawiki/extensions/EmbedVideo/-/archive/v2.8.0/EmbedVideo-v2.8.0.zip"


  #
  # Math - provides support for rendering mathematical formulae.
  # https://www.mediawiki.org/wiki/Extension:Math
  # Snapshot for MediaWiki 1.34 as of 25.04.2020 from: https://www.mediawiki.org/wiki/Special:ExtensionDistributor?extdistname=Math&extdistversion=REL1_34
  _mw_download_and_move_and_add_extension "Math" "https://extdist.wmflabs.org/dist/extensions/Math-REL1_34-b1a022f.tar.gz"
  # TODO see how to properly setup/install/configure Mathoid https://www.mediawiki.org/wiki/Extension:Math#Math_output_modes + also configure Math to use mathoid and mathml etc..


  #
  # MobileFrontend - creates a separate mobile site for your mobile traffic (provides various content transformations to make your content more friendly, simplifies things, ...)
  # https://www.mediawiki.org/wiki/Extension:MobileFrontend
  # Snapshot for MediaWiki 1.34 as of 25.04.2020 from: https://www.mediawiki.org/wiki/Special:ExtensionDistributor?extdistname=MobileFrontend&extdistversion=REL1_34
  _mw_download_and_move_and_add_extension "MobileFrontend" "https://extdist.wmflabs.org/dist/extensions/MobileFrontend-REL1_34-383273b.tar.gz"


  #
  # MinervaNeue - skin that serves mobile traffic for Wikimedia projects across the world. Compared to other skins e.g. Vector it provides a much more simplistic user interface and is much more aggressive about optimising for performance so that it can cater for mobile users.
  # https://www.mediawiki.org/wiki/Extension:MinervaNeue
  # Snapshot for MediaWiki 1.34 as of 25.04.2020 from: https://www.mediawiki.org/wiki/Special:SkinDistributor?extdistname=MinervaNeue&extdistversion=REL1_34
  _mw_download_and_move_and_add_skin "MinervaNeue" "https://extdist.wmflabs.org/dist/skins/MinervaNeue-REL1_34-d0be74a.tar.gz"

  echo "\$wgMFDefaultSkinClass = 'SkinMinerva'; // Use Skin 'Minerva' for MobileFrontend-Traffic" \
          >> "${MW_TEMP_LOCALSETTINGS_FILE}"

  #
  # TemplateData - introduces a <templatedata> tag and an API which together allow editors to specify how templates should be invoked. This information is available as a nicely-formatted table for end-users, and as a JSON API, which enables other systems (e.g. VisualEditor) to build interfaces for working with templates and their parameters.
  # https://www.mediawiki.org/wiki/Extension:TemplateData
  # Snapshot for MediaWiki 1.34 as of 25.04.2020 from: https://www.mediawiki.org/wiki/Special:ExtensionDistributor?extdistname=TemplateData&extdistversion=REL1_34
  _mw_download_and_move_and_add_extension "TemplateData" "https://extdist.wmflabs.org/dist/extensions/TemplateData-REL1_34-b9ccaf6.tar.gz"


  #
  # (Depends on TemplateData and WikiEditor.)
  # TemplateWizard - adds a popup dialog box for adding template code to wikitext.
  # https://www.mediawiki.org/wiki/Extension:TemplateWizard
  # Snapshot for MediaWiki 1.34 as of 25.04.2020 from: https://www.mediawiki.org/wiki/Special:ExtensionDistributor?extdistname=TemplateWizard&extdistversion=REL1_34
  _mw_download_and_move_and_add_extension "TemplateWizard" "https://extdist.wmflabs.org/dist/extensions/TemplateWizard-REL1_34-b898897.tar.gz"


  #
  # RevisionSlider - adds a slider interface to the diff view, so that you can easily move between revisions.
  # https://www.mediawiki.org/wiki/Extension:RevisionSlider
  # Snapshot for MediaWiki 1.34 as of 25.04.2020 from: https://www.mediawiki.org/wiki/Special:ExtensionDistributor?extdistname=RevisionSlider&extdistversion=REL1_34
  _mw_download_and_move_and_add_extension "RevisionSlider" "https://extdist.wmflabs.org/dist/extensions/RevisionSlider-REL1_34-7842cdf.tar.gz"


  #
  # JsonConfig - allows other extensions to store their configuration data as a JSON blob in a wiki page.
  # https://www.mediawiki.org/wiki/Extension:JsonConfig
  # Snapshot for MediaWiki 1.34 as of 25.04.2020 from: https://www.mediawiki.org/wiki/Special:ExtensionDistributor?extdistname=JsonConfig&extdistversion=REL1_34
  _mw_download_and_move_and_add_extension "JsonConfig" "https://extdist.wmflabs.org/dist/extensions/JsonConfig-REL1_34-f877d87.tar.gz"


  #
  # (Requires JsonConfig)
  # Graph - allows a <graph> tag to describe data visualizations such as bar charts, pie charts, timelines, and histograms in a JSON format that renders a Vega-based graph.
  # https://www.mediawiki.org/wiki/Extension:Graph
  # Snapshot for MediaWiki 1.34 as of 25.04.2020 from: https://www.mediawiki.org/wiki/Special:ExtensionDistributor?extdistname=Graph&extdistversion=REL1_34
  _mw_download_and_move_and_add_extension "Graph" "https://extdist.wmflabs.org/dist/extensions/Graph-REL1_34-eb3412d.tar.gz"
  # TODO configuration needed?


  #
  # (Requires Graph extension if you want to see the fancy graphs)
  # PageViewInfo - provides API modules to access pageview-related data and adds fancy looking graphs to the "Page information" interface.
  # https://www.mediawiki.org/wiki/Extension:PageViewInfo
  # Snapshot for MediaWiki 1.34 as of 25.04.2020 from: https://www.mediawiki.org/wiki/Special:ExtensionDistributor?extdistname=PageViewInfo&extdistversion=REL1_34
  _mw_download_and_move_and_add_extension "PageViewInfo" "https://extdist.wmflabs.org/dist/extensions/PageViewInfo-REL1_34-6b65f3c.tar.gz"


  #
  # Echo - provides an in-wiki notification system that can be used by other extensions.
  # https://www.mediawiki.org/wiki/Extension:Echo
  # Snapshot for MediaWiki 1.34 as of 25.04.2020 from: https://www.mediawiki.org/wiki/Special:ExtensionDistributor?extdistname=Echo&extdistversion=REL1_34
  _mw_download_and_move_and_add_extension "Echo" "https://extdist.wmflabs.org/dist/extensions/Echo-REL1_34-bf9195d.tar.gz"


  #
  # (Depends on Echo)
  # LoginNotify - notifies you when someone logs into your account. It can be configured to give warnings after a certain number of failed login attempts
  # https://www.mediawiki.org/wiki/Extension:LoginNotify
  # Snapshot for MediaWiki 1.34 as of 25.04.2020 from: https://www.mediawiki.org/wiki/Special:ExtensionDistributor?extdistname=LoginNotify&extdistversion=REL1_34
  _mw_download_and_move_and_add_extension "LoginNotify" "https://extdist.wmflabs.org/dist/extensions/LoginNotify-REL1_34-0f04847.tar.gz"


  #
  # TextExtracts - provides an API which allows to retrieve plain-text or limited HTML (HTML with content for some CSS classes removed) extracts of page content.
  # https://www.mediawiki.org/wiki/Extension:TextExtracts
  # Snapshot for MediaWiki 1.34 as of 25.04.2020 from: https://www.mediawiki.org/wiki/Special:ExtensionDistributor?extdistname=TextExtracts&extdistversion=REL1_34
  _mw_download_and_move_and_add_extension "TextExtracts" "https://extdist.wmflabs.org/dist/extensions/TextExtracts-REL1_34-17e82b0.tar.gz"


  #
  # PageImages - collects information about images used on a page to return the single most appropriate thumbnail associated with an article.
  # https://www.mediawiki.org/wiki/Extension:PageImages
  # Snapshot for MediaWiki 1.34 as of 25.04.2020 from: https://www.mediawiki.org/wiki/Special:ExtensionDistributor?extdistname=PageImages&extdistversion=REL1_34
  _mw_download_and_move_and_add_extension "PageImages" "https://extdist.wmflabs.org/dist/extensions/PageImages-REL1_34-3e3ccd8.tar.gz"


  #
  # (Depends on TextExtracts and PageImages) (Can use EventLogging and WikimediaEvents)
  # Popups - displays page and reference previews when hovering over a link to an article or respectively to a reference. The former consists of summaries of an article's content, the latter shows the full content of the reference.
  # https://www.mediawiki.org/wiki/Extension:Popups
  # Snapshot for MediaWiki 1.34 as of 25.04.2020 from: https://www.mediawiki.org/wiki/Special:ExtensionDistributor?extdistname=Popups&extdistversion=REL1_34
  _mw_download_and_move_and_add_extension "Popups" "https://extdist.wmflabs.org/dist/extensions/Popups-REL1_34-375d27b.tar.gz"

cat << EOF >> "${MW_TEMP_LOCALSETTINGS_FILE}"
\$wgPopupsHideOptInOnPreferencesPage = true;
\$wgPopupsOptInDefaultState = '1';
\$wgPopupsReferencePreviewsBetaFeature = true;
EOF


  #
  # XXX - YYY
  # https://www.mediawiki.org/wiki/Extension:XXX
  # Snapshot for MediaWiki 1.34 as of 25.04.2020 from:
#  _mw_download_and_move_and_add_extension "XXX" "ZZZ"
}

install_parsoid() {
  log_info "= Start installation/configuration of Parsoid"

  # Steps originally from https://www.youtube.com/watch?v=G3FjP2PkApg
  cd "${TEMP_DIR}"
  log_info "== Starting NodeJS-v10 debian setup-Script..."
  curl -sL https://deb.nodesource.com/setup_10.x | bash -
  ## "You may also need development tools to build native addons:"
  log_info "== Installing development tools to build native addons..."
  apt_get_without_interaction "install" "gcc g++ make" | log_debug_output
  ## "To install the Yarn package manager, run:"
  log_info "== Start Install Yarn package manager"
  log_info "=== Adding debian pubkey..."
  curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
  log_info "=== Adding sourcefile 'yarn.list'..."
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
  log_info "=== Updating sources and installing yarn..."
  apt_get_without_interaction "update" | log_debug_output
  apt_get_without_interaction "install" "yarn" | log_debug_output

  log_info "== Creating directory '/var/lib/parsoid' for parsoid to live in..."
  mkdir -p "/var/lib/parsoid" | log_debug_output
  cd "/var/lib/parsoid"
  log_info "=== Installing parsoid at '/var/lib/parsoid/'..."
  npm install parsoid

  log_info "=== Copying parsoid's 'config.example.yaml' to 'config.yaml'..."
  cp -f "/var/lib/parsoid/node_modules/parsoid/config.example.yaml" \
        "/var/lib/parsoid/node_modules/parsoid/config.yaml" | log_debug_output

  log_info "*** "
  log_info "*** Please adjust parsoid's config, located at '/var/lib/parsoid/node_modules/parsoid/config.yaml'."
  log_info "*** Values that need to be changed: 'services.conf.mwApis.uri' and 'services.conf.mwApis.domain'. (2nd-one can be commented)"
#  log_info "*** Note for myself: Set 'strictSSL' to 'false' if this is only a testing-environment. "
  log_info "*** "
  read -p "Press Enter to run the text-editor '${EDITOR:-nano}' on this file..."
  "${EDITOR:-nano}"  "/var/lib/parsoid/node_modules/parsoid/config.yaml"

  log_info "*** "
  log_info "*** Please make sure the following line is in crontab:"
  log_info "@reboot bash -c \"cd /var/lib/parsoid/node_modules/parsoid && npm start &\""
  log_info "*** "
  read -p "Press Enter to run the text-editor open the crontab-file..."
  crontab -e

  # TODO It seems to work pretty fine. Except when page includes a math formula, i get HTTP 500 error. Maybe proper configuration of the math extension needs to be done? (Mathoid,....)
  # TODO on one random post i was on it said that something got solved after moving things around: first do visualeditor and then math in localsettings
  # TODO without changing anything in this regard it seems to be working, at least in my latest test-installation?! (26.04.2020)
}

install_visualeditor_extension(){
  log_info "= Start installation/configuration of VisualEditor"
  #
  # VisualEditor -
  # https://www.mediawiki.org/wiki/Extension:VisualEditor
  # Snapshot for MediaWiki 1.34 as of 25.04.2020 from: https://www.mediawiki.org/wiki/Special:ExtensionDistributor?extdistname=VisualEditor&extdistversion=REL1_34
  _mw_download_and_move_and_add_extension "VisualEditor" "https://extdist.wmflabs.org/dist/extensions/VisualEditor-REL1_34-74116a7.tar.gz"

  # Snippet from
  cat << EOF >> "${MW_TEMP_LOCALSETTINGS_FILE}"
///~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/// START VISUALEDITOR-CONFIGURATION (See https://www.mediawiki.org/wiki/Extension:VisualEditor#Basic_configuration_for_MediaWiki-VisualEditor)

// Enable by default for everybody
\$wgDefaultUserOptions['visualeditor-enable'] = 1;

// Optional: Set VisualEditor as the default for anonymous users
// otherwise they will have to switch to VE
// \$wgDefaultUserOptions['visualeditor-editor'] = "visualeditor";

// Don't allow users to disable it
// \$wgHiddenPrefs[] = 'visualeditor-enable';

// OPTIONAL: Enable VisualEditor's experimental code features
\$wgDefaultUserOptions['visualeditor-enable-experimental'] = 1;

/// END VISUALEDITOR-CONFIGURATION
///~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
EOF

  cat << EOF >> "${MW_TEMP_LOCALSETTINGS_FILE}"
/// START VISUALEDITOR-LINK TO PARSOID (See https://www.mediawiki.org/wiki/Extension:VisualEditor#Linking_with_Parsoid)

\$wgVirtualRestConfig['modules']['parsoid'] = array(
    // URL to the Parsoid instance
    // Use port 8142 if you use the Debian package
    'url' => 'http://localhost:8000',
    // Parsoid "domain", see below (optional)
    // CHANGED:
    'domain' => 'TODO CHANGE ME TO EITHER THE INSTANCES IP ADRESS OR DOMAIN-NAME',
    // Parsoid "prefix", see below (optional)
    'prefix' => 'localhost'
);

/// END VISUALEDITOR-LINK TO PARSOID
///~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
EOF

  cd "${SCRIPT_DIR}"
}

copy_extsions_and_skins_to_installation_dir(){
  log_info "Force-Copying downloaded & decompressed extensions and skins from temporary directory '${MW_EXTENSIONS_AND_SKINS_TEMP_DIR}' to installation-directory '${MW_DIR_TO_INSTALL_IN}'..."
  cp -rf "${MW_EXTENSIONS_AND_SKINS_TEMP_DIR}/"* "${MW_DIR_TO_INSTALL_IN}/"
}

ask_for_webinstall_file_and_copy_and_append_script_generated_content(){
  log_info "*** "
  log_info "*** Please perform intial web-based setup (Don't choose any extensions in the last step!!)."
  log_info "*** "
  log_info "*** If you have finished the web-based installation, the last step will give you access to download the main-configuration File 'LocalSettings.php'."
  log_info "*** Please transfer this file to any place on this server (only for temporary purposes)! "
  log_info "*** Press enter to input the location of where the transferred file. (e.G. '${HOME}/LocalSettings.php')"
  log_info "*** "
  read -p ".."

  local path_to_original_generated_localsettings=""
  # Keep asking until the user chose a file-path with the pattern of "*LocalSettings*.php"
  while [[ -z "$path_to_original_generated_localsettings" ]]  && \
        [[ "$path_to_original_generated_localsettings" != *"LocalSettings"*".php" ]]; do

    dialog --backtitle "${SCRIPT_NAME}" --title "Please choose the Location of where you put the generated LocalSettings.php-File." \
      --fselect "${HOME}" 10 0 0 \
      2>"${TEMP_DIR}/mediawiki-intial_generated_localsettings.choice"
    path_to_original_generated_localsettings=$(cat "${TEMP_DIR}/mediawiki-intial_generated_localsettings.choice")
  done

  log_info "== Force-Copying given file '${path_to_original_generated_localsettings}' to '${MW_DIR_TO_INSTALL_IN}/LocalSettings.php'..."
  backup_file_if_not_already_backed_up "${MW_DIR_TO_INSTALL_IN}/LocalSettings.php"
  cp -rf "${path_to_original_generated_localsettings}" "${MW_DIR_TO_INSTALL_IN}/LocalSettings.php"

  log_info "== chown'ing File '${MW_DIR_TO_INSTALL_IN}/LocalSettings.php' to 'www-data'"
  chown www-data:www-data "${MW_DIR_TO_INSTALL_IN}/LocalSettings.php"

  log_info "== Appending content generated by this script (see '${MW_TEMP_LOCALSETTINGS_FILE}') to the mentioned '${MW_DIR_TO_INSTALL_IN}/LocalSettings.php'-File..."
  echo " " >> "${MW_DIR_TO_INSTALL_IN}/LocalSettings.php"
  cat "${MW_TEMP_LOCALSETTINGS_FILE}" >> "${MW_DIR_TO_INSTALL_IN}/LocalSettings.php"
}

run_maintenance_update_script(){
  log_info "== Running script '${MW_DIR_TO_INSTALL_IN}/maintenance/update.php', which will automatically create the necessary database tables that some extension need."
  php "${MW_DIR_TO_INSTALL_IN}/maintenance/update.php"
}

call_module(){
  # Make sure LAMP is installed. Defined in lamp-utils
  lamp_install

  # Keep asking until user chose a path that is a directory which also is empty
  while [[ -z "${MW_DIR_TO_INSTALL_IN}" ]] \
        || [[ ! -d "${MW_DIR_TO_INSTALL_IN}" ]] \
        || [[ "$(ls -A "${MW_DIR_TO_INSTALL_IN}")" ]]; do
    dialog --backtitle "${SCRIPT_NAME}" --title "Choose Destination-Folder of MediaWiki Installation. (Needs to be empty)" \
          --fselect "${MW_DEFAULT_INSTALL_DIR}" 10 0 0 \
          2>"${TEMP_DIR}/mediawiki_install-install_location.choice"
    MW_DIR_TO_INSTALL_IN=$(cat "${TEMP_DIR}/mediawiki_restore-install_location.choice")
  done

  log_info "= Start installation of MediaWiki in '${MW_DIR_TO_INSTALL_IN}'"
  prepare_php
  download_and_install_mediawiki
  ask_create_needed_sql

  rm "${MW_TEMP_LOCALSETTINGS_FILE}" || true
  touch "${MW_TEMP_LOCALSETTINGS_FILE}"

  # See https://www.mediawiki.org/wiki/InstantCommons
  log_info "== Adding wgUseInstantCommons"
  echo "\$wgUseInstantCommons = true;" >> "${MW_TEMP_LOCALSETTINGS_FILE}"

  install_extensions
  install_parsoid
  install_visualeditor_extension
  copy_extsions_and_skins_to_installation_dir

  ask_for_webinstall_file_and_copy_and_append_script_generated_content

  run_maintenance_update_script
}