#!/bin/bash

BASHRC=~/.bashrc

MY_TAG="# sis bashrc"
TAG_FLAG=0

chmod a+rwx $BASHRC

# echo MODE
# echo 1. Append configuration
# echo 2. Rmove configuration
# read -p "Select mode: " mode
# echo

if (grep -q "$MY_TAG" $BASHRC); then TAG_FLAG=1; fi
echo $TAG_FLAG

while read line; do
    echo $line
done < <(cat << EOF

    $MY_TAG
    alias python='usr/bin/python3'
    alias grep='grep --color=auto --exclude={tags,*.lst,*.map,*.d} --exclude-dir={.git,.svn}'
    alias ssh='ssh -X'

    function job_indicator() {
        if [ -n "\$(jobs)" ]; then
            echo "\$(tput setaf 1)"
        fi
    }
EOF
# ) >> $BASHRC
)

# Append custom configuration, when there is no tag
if [ $TAG_FLAG -eq 0 ]; then
    FIND='\\\$ '
    REPLACE='$(job_indicator)\$$(tput sgr0) '
    RESULT=${PS1//$FIND/$REPLACE}

    echo "PS1='$RESULT'"
# fi >> $BASHRC
fi

