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




# use $(job_indicator)\$ $(tput sgr0) 
# function job_indicator() {
#     if [ -n "$(jobs)" ]; then
#         echo "$(tput setaf 1)"
#     fi
# }
# alias python='usr/bin/python3'
# alias grep='grep --color=auto --exclude={tags,*.lst,*.map,*.d} --exclude-dir={.git,.svn}'
# alias ssh='ssh -X'

function job_indicator() {
    if [ -n "$(jobs)" ]; then
        echo "$(tput setaf 1)"
    fi
}

# Append custom configuration, when there is no tag
# if [ $TAG_FLAG -eq 0 ]; then
if [ $TAG_FLAG -eq 1 ]; then

    echo $PS1
    FIND="\$ "
    REPLACE="\$(job_indicator)\$\$(tput sgr0) "
    RESULT=${PS1//$FIND/$REPLACE}
    echo $RESULT

    # echo $RESULT >> $BASHRC
fi

