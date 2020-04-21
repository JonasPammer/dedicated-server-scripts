The directory structure of a template is:

templates/
    /templatename/          - Root template directory
        /files/             - Files to be copied (optional)
        template.conf       - Template configuration (optional)
        initialize.sh       - Initialize script (optional)
        beforeDelete.sh     - Before delete script (optional)
        afterDelete.sh      - After delete script (optional)
        beforeSetup.sh      - Before setup script (optional)
        afterSetup.sh       - After setup script (optional)

OR:

templates/
    templatename.zip - Same contents as /templatename/ above.

Root template directory
=======================
The directory name "templatename" is a unique name for this template. All files
 for this template are put in this directory.

The "files" directory
=====================
The files in this directory will be copied to the server base directory during
the setup. This directory is optional.

Template configuration file
===========================
The "template.conf" file contains the template configuration, this file is
optional. If it does not exist all configuration options will use the
default values and the template name will be the same as the directory name.
See the template.conf of the provided default template for the full
documentation of available settings.

Template script files
=====================
If these files exist and no alternative command is configured in the
template.conf file they will be run at the appropriate time during the setup
process. All of these files are optional.
The setup steps at which scripts can be run are:
initialize
    Before anything else is done this script will be run
beforeDelete
    If the user wants to have all server files deleted (or if this is enforced
    in the template.conf) this will be run before deleting the server files.
    Here you can save certain information to a temporary location for example.
afterDelete
    Analogous to "beforeDelete" this will be run right after the server files
    have been deleted. The beforeDelete/afterDelete scripts are not run if the
    server files are not deleted.
beforeSetup
    This is run right before the files from the "files" directory are copied to
    the server base directory.
afterSetup
    This is run right after the files have been copied.
