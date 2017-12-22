#!/bin/bash

BASHRC=~/.bashrc
MY_TAG="# sis bashrc"
TAG_FLAG=0

chmod a+rwx $BASHRC

function get_ps1() {
    FIND='\\\$ '
    REPLACE='$(job_indicator)\$$(tput sgr0) '
    RESULT=${PS1//$FIND/$REPLACE}
    echo "PS1='$RESULT'"
}

my_config=$(cat << EOF
$MY_TAG
export DISPLAY=:0

alias python='python3'
alias grep='grep --color=auto --exclude={tags,*.lst,*.map,*.d} --exclude-dir={.git,.svn}'
alias ssh='ssh -X'

function job_indicator() { if [ -n "\$(jobs)" ]; then echo "\$(tput setaf 1)"; fi }

$(get_ps1)
EOF
)

function clear_config() {
    line_num="$(grep -nh "$MY_TAG" $BASHRC | cut -d: -f1)"

    if [ -n "$line_num" ]; then
        sed -ie ''${line_num}',$d' $BASHRC > /dev/null
    fi

    source $BASHRC
}

function set_config() {
    if [ $TAG_FLAG -ne 1 ]; then
        echo "$my_config" >> $BASHRC
    fi
}

echo MODE
echo 1. Append configuration
echo 2. Rmove configuration
echo 3. Do nothing
read -p "Select mode: " mode
echo

if (grep -q "$MY_TAG" $BASHRC); then TAG_FLAG=1; fi

case "$mode" in
    1)
        $(clear_config)
        $(set_config)
        ;;
    2)
        $(clear_config)
        ;;
    *)
        echo Exit
        ;;
esac

