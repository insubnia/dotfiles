#!/bin/bash

BASHRC=~/.bashrc

MY_TAG="# sis bashrc"
TAG_FLAG=0

chmod a+rwx $BASHRC

while read line; do
    if [[ $line =~ $MY_TAG ]]; then
        TAG_FLAG=1
    fi
done < $BASHRC

echo $TAG_FLAG


# Append custom configuration, when there is no tag
if [ $TAG_FLAG -eq 0 ]; then
    echo $MY_TAG
    FIND="\$ "
    REPLACE="\$(job_indicator)\\\$\$(tput sgr0) "
    RESULT=${PS1//$FIND/$REPLACE}

    echo $PS1
    echo PS1=\'$RESULT\'
fi
# fi >> $BASHRC

while read line; do
    echo $line
done < <(cat << EOF
    alias python='usr/bin/python3'
    alias grep='grep --color=auto --exclude={tags,*.lst,*.map,*.d} --exclude-dir={.git,.svn}'
    alias ssh='ssh -X'
    function job_indicator() {
        if [ -n "\$(jobs)" ]; then
            echo "\$(tput setaf 1)"
        fi
    }
EOF
)


