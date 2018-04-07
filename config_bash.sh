#!/bin/bash

BASHRC=~/.bashrc
MY_TAG="# sis bashrc"

chmod a+rwx $BASHRC

function get_ps1() {
    FIND='\\\$ '
    REPLACE='$(job_indicator)\$$(tput sgr0) '
    RESULT=${PS1//$FIND/$REPLACE}
    echo "PS1='$RESULT'"
}

# Script to be appended.
# $ should be repaced with \$
my_config=$(cat << EOF
$MY_TAG
export DISPLAY=:0

alias python='python3'
alias grep='grep --color=auto --exclude={tags,*.log,*.bak} --exclude-dir={.git,.svn}'
alias ssh='ssh -X'

git config --global diff.tool vimdiff
git config --global difftool.prompt true

# merge.tool: vimdiff, vimdiff2, vimdiff3
# conflictstyle: merge, diff3
git config --global merge.tool vimdiff2
git config --global mergetool.prompt true
git config --global merge.conflictstyle diff3

git config --global alias.mylog     "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all"

# function job_indicator() { if [ -n "\$(jobs)" ]; then echo "\$(tput setaf 1)"; fi }
function job_indicator() {
    if [ -n "\$(jobs)" ]; then
        num=\$(echo "\$(jobs)" | tail -n 1 | grep -oP "\[\d+\]" | grep -oP "\d+")
        echo "\$(tput setaf \$num)"
    fi
}

$(get_ps1)
EOF
)

function clear_config() {
    line_num="$(grep -nh "$MY_TAG" $BASHRC | cut -d: -f1)"
    if [ -n "$line_num" ]; then
        sed -ie ''${line_num}',$d' $BASHRC
    fi
    source $BASHRC
}

function append_config() {
    if ! grep -q "$MY_TAG" $BASHRC; then
        echo "$my_config" >> $BASHRC
    fi
    source $BASHRC
}

echo MODE
echo 1. Append configuration
echo 2. Rmove configuration
echo 3. Do nothing
read -p "Select mode: " mode
echo

case "$mode" in
    1)
        $(clear_config)
        $(append_config)
        ;;
    2)
        $(clear_config)
        ;;
    *)
        echo Exit
        ;;
esac

