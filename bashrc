# use $(job_indicator)\$ $(tput sgr0) 
function job_indicator() {
    if [ -n "$(jobs)" ]; then
        echo "$(tput setaf 1)"
    fi
}

alias python='usr/bin/python3'
alias grep='grep --color=auto --exclude={tags,*.lst,*.map,*.d} --exclude-dir={.git,.svn}'
alias ssh='ssh -X'
