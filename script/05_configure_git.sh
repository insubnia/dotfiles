#!/bin/bash

git config --global user.name   "sis"
git config --global user.email  "sis06232@gmail.com"

git config --global core.editor $(which nvim)
git config --global core.autocrlf input  # https://director-joe.kr/89
git config --global core.eol lf
git config --global core.safecrlf false
git config --global core.excludesfile "~/workspace/dotfiles/conf/gitignore"
git config --global core.ignorecase false

git config --global rebase.false

git config --global credential.helper store

git config --global diff.tool vimdiff
git config --global difftool.prompt true
git config --global merge.tool vimdiff2     # tool: vimdiff, vimdiff2, vimdiff3
git config --global mergetool.prompt true
git config --global merge.conflictstyle diff3   # confilctstyle: merge, diff3

git config --global alias.cp      "cherry-pick"
git config --global alias.df      "diff --color-words"
git config --global alias.rst     "reset"
git config --global alias.unstage "reset HEAD --"
