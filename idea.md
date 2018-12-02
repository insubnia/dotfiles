# Idea
Ultimate goal is standalone IDE with only VIM

## To do
    **:py3f %** command
    **:pyxf %** command

    vnoremap [] s[]<esc>P
    nmap Q  <plug>(qf_qf_toggle)

    function! DiffKeymap(mode)
        if a:mode
            noremap <leader>g :diffget<CR>
            noremap <leader>p :diffput<CR>
            noremap <leader>1 :diffget LO<CR>
            noremap <leader>2 :diffget BA<CR>
            noremap <leader>3 :diffget RE<CR>
        else
            nnoremap <leader>g  :silent grep!<space>
        endif
    endfunction

    autocmd BufEnter * if &diff | call DiffKeymap(1) | endif
    autocmd BufWinLeave * if &diff | call DiffKeymap(0) | endif
***

## Remember
gx : open URL under cursor
(command mode) <C-r><C-w> : insert word under cursor
***

## Colors
base16-dracula / violet
candy          / base16_default
gruit          / fairyfloss
PaperColor     / ravenpower
***

## Reference
### Shell date & time format
https://www.ibm.com/support/knowledgecenter/ko/ssw_ibm_i_73/rtref/strfti.htm

### Nerd fonts
https://medium.com/the-code-review/nerd-fonts-how-to-install-configure-and-remove-programming-fonts-on-a-mac-178833b9daf3
