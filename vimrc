" sis vim runtime configuration

" Plugin
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'valloric/youcompleteme'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'tpope/vim-fugitive'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/nerdcommenter'
Plugin 'kien/ctrlp.vim'
Plugin 'majutsushi/tagbar'
Plugin 'TagHighlight'
Plugin 'Yggdroot/indentLine'
Plugin 'godlygeek/tabular'
Plugin 'jiangmiao/auto-pairs'
" ---------- colorschemes ----------
Plugin 'dracula/vim'
Plugin 'nanotech/jellybeans.vim'
Plugin 'tomasr/molokai'
Plugin 'NLKNguyen/papercolor-theme'
Plugin 'altercation/vim-colors-solarized'
Plugin 'junegunn/seoul256.vim'
call vundle#end()
filetype plugin indent on

" Basic options
syntax on
set nocp            " no compatibility with VI
set nu              " line number
set cursorline      " highlight current cursorline
set ruler           " display cursor position information at status line
set ic              " case insensitive search
set smartcase       " don't use ic when there is Capital letter
set hlsearch        " highlight search
set incsearch       " show search matches as type
set mouse=a         " enalbe cursor move with mouse
set smarttab        " insert tabs on the start of a line according to shiftwidth, not tabstop
set expandtab       " replace tab to space
set ai si cin       " set autoindent, smartindent, cindent
set ls=2            " statusline option (set to 2 for using airline)
set ts=4 sw=4 sts=4 " tab size
set tm=500 ttm=0    " to leave insert mode without delay
set autowrite       " Automatically :write before running commands
set autoread        " Auto read when a file is changed on disk
set hidden          " Keep current buffer as hidden, when opening a new file
set vb noeb         " visual bell instead of beep
set wildmenu        " enhanced command-line completion
set diffopt+=iwhite " ignore white spaces in diff mode
set path+=**        " add subdirectories in working path
set spr sb          " split right & below
set title           " set window's title, reflecting the file currently being edited
set noswf nobk      " noswapfile & nobackupfile
set termguicolors   " use hi-guifg and hi-guibg in the terminal
set encoding=utf8
set completeopt=menuone,noselect
set wildignore=*.exe,*.zip,*.bin,*.hex,*.o,*.d,*.elf,*.pyc,*.pyo,__pycache__,
            \*.lst,*.map,.git,.svn,tags,*.taghl,*.png,*.jpg,*.log

" Cursor settings
if &term=~'xterm'
    let &t_SI = "\e[5 q"    " Start insert mode
    let &t_SR = "\e[3 q"    " Start replace mode
    let &t_EI = "\e[0 q"    " End insert & replace mode
endif

" Key mappings
noremap <C-_>   :call NERDComment(0, "toggle")<CR>
nnoremap <F2>   :UpdateTypesFile<CR>
nnoremap <F3>   :NERDTreeToggle<CR><C-w>=
nnoremap <F4>   :TagbarToggle<CR><C-w>=
nnoremap <F5>   :e<CR><C-w>=
nnoremap Q  <nop>
nnoremap J  <nop>
vnoremap J  <nop>
nnoremap K  <nop>
nnoremap Y  y$
nnoremap j  gj
nnoremap k  gk
nnoremap n  nzz
nnoremap N  Nzz
nnoremap *  *zz
nnoremap #  #zz
nnoremap dw diw
nnoremap yw yiw
nnoremap // :ts /
nnoremap ZA :wqa<CR>
vnoremap <  <gv
vnoremap >  >gv
nnoremap <C-]>  g<C-]>
nnoremap <C-t>  <C-t>zz
nnoremap <C-o>  <C-o>zz
nnoremap <C-i>  <C-i>zz
nnoremap <C-j>  :cn<CR>
nnoremap <C-k>  :cp<CR>
inoremap <C-_>  <nop>
inoremap <C-b>  <Left>
inoremap <C-f>  <Right>
inoremap <C-a>  <Esc>I
inoremap <C-e>  <End>
cnoremap <C-b>  <Left>
cnoremap <C-f>  <Right>
cnoremap <C-t>  Tabularize /
cnoremap <C-g>  s//g<Left><Left>
nnoremap <C-w>]     <C-w>]:wincmd L<CR>zz
nnoremap <C-w><CR>  <C-w><CR>:wincmd L<CR>zz
nnoremap <leader>d  dd:call system("xclip -i -selection clipboard", getreg("\""))<CR>
nnoremap <leader>y  yy:call system("xclip -i -selection clipboard", getreg("\""))<CR>
vnoremap <leader>d  d:call system("xclip -i -selection clipboard", getreg("\""))<CR>
vnoremap <leader>y  y:call system("xclip -i -selection clipboard", getreg("\""))<CR>
nnoremap <leader>p  :call setreg("\"",system("xclip -o -selection clipboard"))<CR>o<ESC>p
if &diff
    noremap <leader>1   :diffget LOCAL<CR>
    noremap <leader>2   :diffget BASE<CR>
    noremap <leader>3   :diffget REMOTE<CR>
    nnoremap <C-j>  ]czz
    nnoremap <C-k>  [czz
endif

" Abbreviations
cabbrev grep    silent grep!
cabbrev make    make!
cabbrev python  !python3
cabbrev pyrun   !python3 %
cabbrev celan   clean

" External program settings
let &grepprg='grep -Irin --exclude={*.lst,*.map,*.d,tags,*.taghl} --exclude-dir={.git,.svn} $*'
let &makeprg='make $*'
set errorformat=%f:%l:%c:%serror:%m
function! QuickfixOpen()
    cwindow
    if &buftype == "quickfix" | wincmd L | endif
    redraw!
endfunction
autocmd QuickFixCmdPost grep,make call QuickfixOpen()

" C/C++ formatting
function! MyC()
    let name = "__".toupper(substitute(expand("%:t"), "\\.", "_", "g"))."__"
    exe "norm! i#ifndef ". name "\n#define ". name "\n\n\n\n#endif\t//". name "\ekk"
endfunction
autocmd BufNewFile *.{h,hpp} call MyC()

" Python formatting
function! MyPy()
    exe "norm! i\n\nif __name__ == \"__main__\":\npass\n\egg"
endfunction
autocmd BufNewFile *.py call MyPy()

" Highlight function
function! MyHighlight()
    if &background == "dark"
        hi Function         guifg=lightgreen
        hi GlobalVariable   guifg=seagreen
        hi DefinedName      guifg=darkcyan
        hi EnumerationValue guifg=maroon
        hi ProtoType        guifg=steelblue
        hi Member           guifg=lightcoral
    else
        hi Function         guifg=olivedrab
        hi GlobalVariable   guifg=forestgreen
        hi DefinedName      guifg=darkcyan
        hi EnumerationValue guifg=maroon
        hi ProtoType        guifg=navy
        hi Member           guifg=brown
    endif

    hi link CTagsConstant   GlobalVariable
    hi link CTagsStructure  ProtoType
    hi link CTagsClass      ProtoType
    hi link CTagsUnion      ProtoType
    hi link EnumeratorName  ProtoType
endfunction
autocmd ColorScheme * call MyHighlight()

" Initial settings
function! MyInit()
    " Jump to the last position
    if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
    " if &modifiable | :retab | endif
endfunction
autocmd BufReadPost * call MyInit()

autocmd FileType help wincmd L

function! TS()      " Tab to space
    set expandtab
    %retab
endfunction

function! ST()      " Space to tab
    set noexpandtab
    %retab!
endfunction

" youcompleteme
let g:ycm_confirm_extra_conf=0

" airline settings
let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#branch#enabled=1
let g:airline#extensions#tagbar#enabled=1

" NERDTree settings
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
let g:NERDTreeDirArrowExpandable='+'
let g:NERDTreeDirArrowCollapsible='~'
let g:NERDTreeShowHidden=1
let g:NERDTreeQuitOnOpen=1
let g:NERDTreeRespectWildIgnore=1

" NERDCommenter settings
let g:NERDSpaceDelims=1
let g:NERDCompactSexyComs=1
let g:NERDDefaultAlign='left'
let g:NERDCommentEmptyLines=1
let g:NERDTrimTrailingWhitespace=1
let g:NERDCustomDelimiters={
            \'c': {'left': '//', 'leftAlt': '/*', 'rightAlt': '*/'},
            \'python': {'left': '#'},
            \}

" CtrlP settings
let g:ctrlp_by_filename=0
let g:ctrlp_show_hidden=1
let g:ctrlp_wildignore=1

" tagbar settings
let g:tagbar_autofocus=1
let g:tagbar_sort=1

" indentLine
let g:indentLine_char='│'
let g:indentLine_first_char='│'
let g:indentLine_showFirstIndentLevel=1
let g:indentLine_leadingSpaceEnabled=0
let g:indentLine_leadingSpaceChar='.'

set background=dark
let g:airline_theme='dracula'
colo dracula

