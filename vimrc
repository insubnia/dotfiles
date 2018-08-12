" sis vim runtime configuration

" Get OS informaion
if has("win32") || has("win32unix")
    let os="Windows"
else
    let os=substitute(system("uname"), "\n", "", "")
endif

" Plugin
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/nerdcommenter'
Plugin 'jiangmiao/auto-pairs'
Plugin 'Yggdroot/indentLine'
Plugin 'mileszs/ack.vim'
Plugin 'sheerun/vim-polyglot'
Plugin 'junegunn/vim-peekaboo'
Plugin 'majutsushi/tagbar'
Plugin 'TagHighlight'
Plugin 'kien/ctrlp.vim'
Plugin 'godlygeek/tabular'
if os != "Windows"
    Plugin 'valloric/youcompleteme'
endif
" ---------- colorschemes ----------
Plugin 'dracula/vim'
Plugin 'joshdick/onedark.vim'
Plugin 'nanotech/jellybeans.vim'
Plugin 'NLKNguyen/papercolor-theme'
Plugin 'cocopon/iceberg.vim'
Plugin 'w0ng/vim-hybrid'
Plugin 'tomasr/molokai'
Plugin 'morhetz/gruvbox'
Plugin 'chriskempson/base16-vim'
call vundle#end()
filetype plugin indent on

" Basic options
syntax on
set nocp
set noswf nobk noudf
set autoread autowrite
set hidden          " Keep current buffer as hidden, when opening a new file
set path+=**        " add subdirectories in working path
set title           " set window's title, reflecting the file currently being edited
set visualbell noerrorbells
set number cursorline ruler
set splitright splitbelow
set mouse=a         " enalbe cursor move with mouse
set termguicolors   " use gui colors instead of terminal colors
set hlsearch incsearch
set ignorecase smartcase
set autoindent smartindent cindent
set smarttab expandtab
set tabstop=4 softtabstop=4 shiftwidth=4
set timeoutlen=500 ttimeoutlen=0
set wildmenu        " enhanced command-line completion
set backspace=2     " make backspace work like most other programs
set tags=tags       " echo tagfiles() to check tag files
set diffopt+=vertical
set completeopt=menuone,noselect
set clipboard^=unnamed,unnamedplus

set wildignore+=*.zip,*.tar,*.gz,*.png,*.jpg,.DS_Store
set wildignore+=*.doc*,*.xls*,*.ppt*
set wildignore+=*.exe,*.elf,*.bin,*.hex,*.o,*.so,*.a,*.dll,*.lib
set wildignore+=tags,*.log,*.bak,*.taghl,*.d,*.map,*.lst
set wildignore+=*.pyc,*.pyo,__pycache__
set wildignore+=.git,.gitmodules,.svn

" Cursor settings
if &term =~ "xterm"
    let &t_SI = "\e[5 q"    " Start insert mode
    let &t_SR = "\e[3 q"    " Start replace mode
    let &t_EI = "\e[0 q"    " End insert & replace mode
endif

" Key mappings
let mapleader=" "
nnoremap Q  <nop>
nnoremap J  <nop>
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
nnoremap ?  :ts /
nnoremap ZA :wqa<CR>
nnoremap R  :reg<CR>
nnoremap T  :TagbarToggle<CR><C-w>=
nnoremap <C-]>  g<C-]>
nnoremap <C-t>  <C-t>zz
nnoremap <C-o>  <C-o>zz
nnoremap <C-i>  <C-i>zz
nnoremap <C-l>  :e<CR><C-l><C-w>=
nnoremap <C-n>  :NERDTreeToggle<CR><C-w>=
nnoremap <C-w>]     <C-w>]:wincmd L<CR>zz
nnoremap <C-w><CR>  <C-w><CR>:wincmd L<CR>zz
vnoremap <  <gv
vnoremap >  >gv
inoremap <C-b>  <Left>
inoremap <C-f>  <Right>
inoremap <C-a>  <Esc>I
inoremap <C-e>  <End>
inoremap <C-k>  <C-o>D
cnoremap <C-b>  <Left>
cnoremap <C-f>  <Right>
cnoremap <C-v>  <C-r>"
cnoremap <C-g>  s//g<Left><Left>
nmap     <C-j>  ]czz
nmap     <C-k>  [czz
noremap  <C-_>  :call NERDComment(0, "toggle")<CR>
noremap  <expr> <leader>g  &diff ? ":diffget<CR>" : ""
noremap  <expr> <leader>p  &diff ? ":diffput<CR>" : ""
noremap  <expr> <leader>1  &diff ? ":diffget LO<CR>" : ""
noremap  <expr> <leader>2  &diff ? ":diffget BA<CR>" : ""
noremap  <expr> <leader>3  &diff ? ":diffget RE<CR>" : ""

" Clipboard
if !has("clipboard")
    nnoremap \d  dd:call system("xclip -i -selection clipboard", getreg("\""))<CR>
    nnoremap \y  yy:call system("xclip -i -selection clipboard", getreg("\""))<CR>
    vnoremap \d  d:call system("xclip -i -selection clipboard", getreg("\""))<CR>
    vnoremap \y  y:call system("xclip -i -selection clipboard", getreg("\""))<CR>
    nnoremap \p  :call setreg("\"",system("xclip -o -selection clipboard"))<CR>o<ESC>p
endif

" Abbreviations
cabbrev grep    silent grep!
cabbrev make    make!
cabbrev <silent> pyrun  !python3 %
cabbrev <silent> ctags  call system("ctags -R .")
cabbrev <silent> copen  copen \| wincmd L
abbrev  celan   clean
abbrev  slef    self

" External program settings
let &grepprg='grep -Irin --exclude={tags,"*".{log,bak,map,lst,d,taghl}} --exclude-dir={.git,.svn} $* .'
let &makeprg='make $*'
set errorformat=%f:%l:%c:%serror:%m
" autocmd QuickFixCmdPost grep,make
"             \ cwindow |
"             \ if &buftype == "quickfix" | wincmd L | endif |
"             \ redraw!

autocmd FileType help wincmd L
autocmd VimResized * wincmd =
autocmd FilterWritePre * if &diff | 1 | redraw! | endif

" Remember last position
autocmd BufReadPost *
            \ if line("'\"") > 0 && line("'\"") <= line("$") |
            \ exe "norm! g`\"zz" |
            \ endif

" C/C++ formatting
function! MyC()
    let name = "__".toupper(substitute(expand("%:t"), "\\.", "_", "g"))."__"
    exe "norm! i#ifndef ". name "\n#define ". name "\n\n\n\n#endif\t//". name "\ekk"
endfunction

" Python formatting
function! MyPy()
    exe "norm! i\n\nif __name__ == \"__main__\":\npass\n\egg"
endfunction

augroup NewFileFormat
    autocmd!
    autocmd BufNewFile *.{h,hpp} call MyC()
    autocmd BufNewFile *.py call MyPy()
augroup END

" Highlight function
function! MyHighlight()
    hi link Global  Function
    hi link Defined Tag
    hi link Member  String
    hi link Proto   Number

    hi link DefinedName         Defined
    hi link EnumerationValue    Defined
    hi link GlobalVariable      Global
    hi link CTagsConstant       Global
    hi link CTagsStructure      Proto
    hi link CTagsClass          Proto
    hi link CTagsUnion          Proto
    hi link EnumeratorName      Proto
endfunction
autocmd ColorScheme * call MyHighlight()

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
let g:ycm_global_ycm_extra_conf='~/.vim/.ycm_extra_conf.py'
let g:ycm_python_binary_path=substitute(system("which python3"), "\n", "", "")
let g:ycm_collect_identifiers_from_tags_files=1

" gitgutter
set updatetime=100
set signcolumn=yes
let g:gitgutter_max_signs=1024

" airline
set laststatus=2
let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#branch#enabled=1
let g:airline#extensions#tagbar#enabled=1

" NERDTree
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
let g:NERDTreeDirArrowExpandable='+'
let g:NERDTreeDirArrowCollapsible='~'
let g:NERDTreeShowHidden=1
let g:NERDTreeRespectWildIgnore=1

" NERDCommenter
let g:NERDSpaceDelims=1
let g:NERDCompactSexyComs=1
let g:NERDDefaultAlign='left'
let g:NERDCommentEmptyLines=1
let g:NERDTrimTrailingWhitespace=1
let g:NERDCustomDelimiters={'python': {'left': '#'},
            \ 'c': {'left': '//', 'leftAlt': '/*', 'rightAlt': '*/'}}

" indentLine
let g:indentLine_showFirstIndentLevel=1
let g:indentLine_leadingSpaceEnabled=0
let g:indentLine_leadingSpaceChar='.'

" ack
nnoremap <leader>a :Ack!<space>
let g:ack_default_options=" -s -H --nocolor --nogroup --column -i --smart-case"
let g:ack_qhandler="botright cwindow"
let g:ackhighlight=1

" CtrlP
let g:ctrlp_by_filename=1
let g:ctrlp_show_hidden=1
let g:ctrlp_wildignore=1

" tagbar
let g:tagbar_autofocus=1
let g:tagbar_sort=1

if has("gui_running")
    set guioptions+=k
    set guioptions-=L
    set guioptions-=T
    set guioptions-=m
endif

if os == "Darwin"
    let g:airline_theme='dracula'
    colo dracula
elseif os == "Linux"
    let g:airline_theme='jellybeans'
    colo jellybeans
elseif has("win32")
    let g:airline_theme='base16_google'
    colo base16-google-dark
elseif has("win32unix")
    let g:airline_theme='onedark'
    colo onedark
endif
