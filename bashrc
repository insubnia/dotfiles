# use $(job_indicator) \$ $(tput sgr0) 
function job_indicator() {
    if [ -n "$(jobs)" ]; then
        echo "$(tput setaf 1)"
    fi
}

