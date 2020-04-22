#!/bin/bash
#
# @author PixelTutorials
#
set -eo pipefail
check_is_utils_initialized



#######################################
# Params:
#   1 - The identifier of the config-variable
#   2 - Default-value
#   3 - Message to ask. (Gets evaluated. Before evaluation, a variable "def" (see $2) gets injected)
#   4 - Message to dispaly if given variable already exists. (Gets evaluated. Before evaluation, a variable "def" (see $2) gets injected)
#######################################
function ask {
    if [ ! "`eval echo \\$$1`" = "" ]; then
        var="`eval echo \\$$1`"
        eval echo $4
        return
    fi
    def=$2
    if [ "$1" = "MC_DAEMON_PW" -o "$1" = "MC_DB_PASS" ]; then
        extra="s"
    else
	extra=""
    fi
    eval read -r$extra -p '"'$3' "'
    if [ "$REPLY" = "" ]; then
        export "$1"="$def"
    else
        export "$1"="$REPLY"
    fi
}

function askSave {
    read -p "Save entered settings? ([y]/n) "
    if [[ "$REPLY" != "n" ]]; then
        save
    fi
}

#######################################
# Saves every exported variable that starts with `MC_` to the mentioned file, to be source'd at a later point.
# Warning: Entered passwords also are included (in plain text!). (The function makes sure using chmod that only the user/its group can access the file)
#
# Globals used:
#   CFG_FILE  -  Path of the file to save the variables to.
#######################################
function save {
    echo -n "Saving settings to '${CFG_FILE}'... "
    export | grep ' MC_'  > "${CFG_FILE}"
    chmod o-rwx "${CFG_FILE}"
    echo "done"
    echo "IMPORTANT: Make sure this file is not accessible by unauthorized users."
    echo
}

function quit {
  askSave
  end_gracefully
  return
}

function repl {
  LINE="${SETTING} = `echo $1 | sed "s/['\\&,]/\\\\&/g"`"
}