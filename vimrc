" sis vim runtime configuration

" Get OS informaion
if has("win32") || has("win32unix")
    let os = "Windows"
else
    let os = substitute(system('uname'), '\n', '', '')
endif

" Plugin
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/nerdcommenter'
Plugin 'jiangmiao/auto-pairs'
Plugin 'Yggdroot/indentLine'
Plugin 'kien/ctrlp.vim'
Plugin 'junegunn/vim-peekaboo'
Plugin 'majutsushi/tagbar'
Plugin 'TagHighlight'
Plugin 'godlygeek/tabular'
if !has("win32unix")
    Plugin 'tpope/vim-fugitive'
endif
if os == "Darwin" || os == "Linux"
    Plugin 'airblade/vim-gitgutter'
    Plugin 'valloric/youcompleteme'
endif
" ---------- colorschemes ----------
Plugin 'dracula/vim'
Plugin 'nanotech/jellybeans.vim'
Plugin 'chriskempson/base16-vim'
Plugin 'tomasr/molokai'
Plugin 'NLKNguyen/papercolor-theme'
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
set path+=**        " add subdirectories in working path
set spr sb          " split right & below
set title           " set window's title, reflecting the file currently being edited
set noswf nobk      " noswapfile & nobackupfile
set backspace=2     " make backspace work like most other programs
set tags=tags       " echo tagfiles() to check tag files
set updatetime=100
set diffopt+=vertical,iwhite
set completeopt=menuone,noselect

set wildignore+=*.exe,*.elf,*.bin,*.hex,*.o,*.so,*.a,*.dll,*.lib
set wildignore+=*.d,*.map,*.lst
set wildignore+=*.pyc,*.pyo,__pycache__
set wildignore+=*.zip,*.tar,*.gz,*.png,*.jpg
set wildignore+=.git,.svn,tags,*.log,*.bak,*.taghl

" Cursor settings
if &term=~'xterm'
    let &t_SI = "\e[5 q"    " Start insert mode
    let &t_SR = "\e[3 q"    " Start replace mode
    let &t_EI = "\e[0 q"    " End insert & replace mode
endif

" Key mappings
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
nnoremap // :ts /
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
nnoremap <leader>1  :diffget LOCAL<CR>
nnoremap <leader>2  :diffget BASE<CR>
nnoremap <leader>3  :diffget REMOTE<CR>
vnoremap <  <gv
vnoremap >  >gv
inoremap <C-b>  <Left>
inoremap <C-f>  <Right>
inoremap <C-a>  <Esc>I
inoremap <C-e>  <End>
inoremap <C-k>  <C-o>D
cnoremap <C-b>  <Left>
cnoremap <C-f>  <Right>
cnoremap <C-g>  s//g<Left><Left>
nmap     <C-j>  ]c
nmap     <C-k>  [c
noremap  <C-_>  :call NERDComment(0, "toggle")<CR>

" Clipboard
if os == "Linux"
    nnoremap <leader>d  dd:call system("xclip -i -selection clipboard", getreg("\""))<CR>
    nnoremap <leader>y  yy:call system("xclip -i -selection clipboard", getreg("\""))<CR>
    vnoremap <leader>d  d:call system("xclip -i -selection clipboard", getreg("\""))<CR>
    vnoremap <leader>y  y:call system("xclip -i -selection clipboard", getreg("\""))<CR>
    nnoremap <leader>p  :call setreg("\"",system("xclip -o -selection clipboard"))<CR>o<ESC>p
else
    noremap <leader>d   "+d
    noremap <leader>y   "+y
    noremap <leader>p   "+p
endif

" Abbreviations
cabbrev grep    silent grep!
cabbrev make    make!
cabbrev pyrun   !python3 %
cabbrev ctags   call system("ctags -R .")
abbrev  celan   clean
abbrev  slef    self

" External program settings
let &grepprg='grep -Irin --exclude={tags,"*".{log,bak,map,lst,d,taghl}} --exclude-dir={.git,.svn} $* .'
let &makeprg='make $*'
set errorformat=%f:%l:%c:%serror:%m
function! QuickfixOpen()
    cwindow
    if &buftype == "quickfix" | wincmd L | endif
    redraw!
endfunction
autocmd QuickFixCmdPost grep,make call QuickfixOpen()

autocmd FileType help wincmd L
autocmd VimResized * wincmd =

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

" Remember last position
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"zz" |
     \ endif

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
let g:ycm_python_binary_path=system("which python3")
let g:ycm_collect_identifiers_from_tags_files=1

" airline settings
let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#branch#enabled=1
let g:airline#extensions#tagbar#enabled=1

" gitgutter
let g:gitgutter_max_signs=999

" NERDTree settings
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
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
let g:NERDAltDelims_c=1
let g:NERDCustomDelimiters={'python': {'left': '#'}}

" CtrlP settings
let g:ctrlp_by_filename=0
let g:ctrlp_show_hidden=1
let g:ctrlp_wildignore=1

" tagbar settings
let g:tagbar_autofocus=1
let g:tagbar_sort=1

" indentLine
let g:indentLine_showFirstIndentLevel=1
let g:indentLine_leadingSpaceEnabled=0
let g:indentLine_leadingSpaceChar='.'

if has("termguicolors")
    set termguicolors
endif
set background=dark
let g:airline_theme='dracula'
colo dracula
