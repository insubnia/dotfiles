" vim: set foldmethod=marker:
" ============================================================================
" .vimrc of sis {{{

" Get OS informaion
if has("win32") || has("win32unix")
    let os="Windows"
else
    let os=substitute(system("uname"), "\n", "", "")
endif
" }}}
" ============================================================================
" PLUGINS {{{
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
Plugin 'tpope/vim-surround'
Plugin 'Yggdroot/indentLine'
Plugin 'tpope/vim-dispatch'
Plugin 'mileszs/ack.vim'
Plugin 'romainl/vim-qf'
Plugin 'sheerun/vim-polyglot'
Plugin 'junegunn/vim-peekaboo'
Plugin 'majutsushi/tagbar'
Plugin 'TagHighlight'
Plugin 'kien/ctrlp.vim'
Plugin 'godlygeek/tabular'
Plugin 'shime/vim-livedown'
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
" }}}
" ============================================================================
" BASIC SETTINGS {{{
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
set foldmethod=marker
set wildignore+=*.zip,*.tar,*.gz,*.png,*.jpg,.DS_Store,*.stackdump
set wildignore+=*.doc*,*.xls*,*.ppt*
set wildignore+=*.exe,*.elf,*.bin,*.hex,*.o,*.so,*.a,*.dll,*.lib
set wildignore+=tags,*.log,*.bak,*.taghl,*.d,*.map,*.lst
set wildignore+=*.pyc,*.pyo,__pycache__
set wildignore+=.git,.gitmodules,.svn

if has("gui_running")
    set guioptions+=k
    set guioptions-=L guioptions-=T guioptions-=m
endif

let &grepprg='grep -Irin --exclude={tags,"*".{log,bak,map,lst,d,taghl}} --exclude-dir={.git,.svn} $* .'
let &makeprg='make $*'
set grepformat=%f:%l:%c:%m,%f:%l:%m
set errorformat=%f:%l:%c:%serror:%m

if &term =~ "xterm"
    let &t_SI = "\e[5 q"    " Start Insert mode
    let &t_SR = "\e[3 q"    " Start Replace mode
    let &t_EI = "\e[0 q"    " End Insert & replace mode
endif
" }}}
" ============================================================================
" MAPPINGS & ABBREVIATIONS {{{
let mapleader=" "
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
nnoremap +  <C-w>>
nnoremap _  <C-w><
nnoremap 0  <C-i>zz
nnoremap ZA :wqa<cr>
nnoremap R  :GitGutterAll<cr>
nnoremap T  :TagbarToggle<cr>
nnoremap <C-]>  g<C-]>
nnoremap <C-t>  <C-t>zz
nnoremap <C-o>  <C-o>zz
nnoremap <C-c>  :Close<cr>
nnoremap <C-h>  :%s//g<left><left>
nnoremap <C-n>  :NERDTreeToggle<cr>
nnoremap <C-w><C-]> <C-w>]<C-w>Lzz
nnoremap <leader>h  K
nnoremap <leader>f  :Ack!<space>
nnoremap <leader>r  :Run<cr>
nnoremap <leader>t  :Dispatch ctags -R .<cr>
nnoremap <Tab>      gt
nnoremap <S-Tab>    gT
nnoremap <BS>       :noh<bar>cexpr []<cr>
vnoremap <  <gv
vnoremap >  >gv
vnoremap <C-h>  :s//g<left><left>
inoremap <C-b>  <left>
inoremap <C-f>  <right>
inoremap <C-a>  <esc>I
inoremap <C-e>  <end>
inoremap <C-k>  <C-o>D
cnoremap <C-b>  <left>
cnoremap <C-f>  <right>
cnoremap <C-v>  <C-r>"
noremap  <C-_>  :call NERDComment(0, "toggle")<cr>
noremap  <expr> <leader>g  &diff ? ":diffget<cr>" : ":silent grep! "
noremap  <expr> <leader>p  &diff ? ":diffput<cr>" : ""
noremap  <expr> <leader>1  &diff ? ":diffget LO<cr>" : ""
noremap  <expr> <leader>2  &diff ? ":diffget BA<cr>" : ""
noremap  <expr> <leader>3  &diff ? ":diffget RE<cr>" : ""
nmap Q  <plug>(qf_qf_toggle)
nmap ]q <plug>(qf_qf_next)zz
nmap [q <plug>(qf_qf_previous)zz
nmap <C-j>  <plug>GitGutterNextHunk<bar>zz
nmap <C-k>  <plug>GitGutterPrevHunk<bar>zz

if !has("clipboard")
    noremap \d  :del  \| silent call system("xclip -i -selection clipboard", getreg("\""))<cr>
    noremap \y  :yank \| silent call system("xclip -i -selection clipboard", getreg("\""))<cr>
    noremap \p  :call setreg("\"",system("xclip -o -selection clipboard"))<cr>o<esc>p
endif

abbrev  celan   clean
abbrev  slef    self
cabbrev Noh     noh
" }}}
" ============================================================================
" AUTOCMD {{{
autocmd VimResized * wincmd =
autocmd FileType help wincmd L
autocmd QuickFixCmdPost grep,make cwindow | redraw!
autocmd FilterWritePre * if &diff | 1 | redraw! | endif
autocmd BufReadPost *
            \ if line("'\"") > 0 && line("'\"") <= line("$") |
            \ exe "norm! g`\"zz" |
            \ endif

function! NewHeader()
    let name = "__".toupper(substitute(expand("%:t"), "\\.", "_", "g"))."__"
    exe "norm! i#ifndef ". name "\n#define ". name "\n\n\n\n#endif\t//". name "\ekk"
endfunction

function! NewPy()
    exe "norm! i\n\nif __name__ == \"__main__\":\npass\n\egg"
endfunction

augroup NewFile
    autocmd!
    autocmd BufNewFile *.{h,hpp} call NewHeader()
    autocmd BufNewFile *.py call NewPy()
augroup END
" }}}
" ============================================================================
" FUNCTIONS & COMMANDS {{{
command! Close  ccl<bar>NERDTreeClose<bar>TagbarClose

if !exists("*Run")
    command! Run call Run()
    function! Run()
        if &filetype=="vim"
            source %
        elseif &filetype=="c" || &filetype=="cpp"
            make run
        elseif &filetype=="python"
            !python3 %
        elseif &filetype=="markdown"
            LivedownPreview
        elseif &filetype=="swift"
            !swift %
        else
            echom "There's nothing to do"
        endif
    endfunction
endif

function! Highlight()
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
autocmd ColorScheme * call Highlight()

command! TS call TabToSpace()
function! TabToSpace()
    set expandtab
    %retab
endfunction

command! ST call SpaceToTab()
function! SpaceToTab()
    set noexpandtab
    %retab!
endfunction
" }}}
" ============================================================================
" PLUGIN SETTINGS {{{
" youcompleteme
let g:ycm_confirm_extra_conf=0
let g:ycm_global_ycm_extra_conf='$HOME/workspace/dotfiles/ycm_extra_conf.py'
let g:ycm_python_binary_path=substitute(system("which python3"), "\n", "", "")
let g:ycm_collect_identifiers_from_tags_files=1
let g:ycm_disable_for_files_larger_than_kb=1024

" gitgutter
set updatetime=100
set signcolumn=yes
let g:gitgutter_map_keys=0
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
let g:NERDTreeMapOpenVSplit='v'
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
let g:indentLine_fileTypeExclude=['help', 'nerdtree', 'tagbar', 'text']

" ack
let g:ack_qhandler="botright cwindow"
let g:ack_apply_qmappings=0
let g:ackhighlight=1

" qf
let g:qf_mapping_ack_style=1
let g:qf_auto_resize=0

" CtrlP
let g:ctrlp_by_filename=1
let g:ctrlp_show_hidden=1
let g:ctrlp_wildignore=1

" tagbar
let g:tagbar_autofocus=1
let g:tagbar_sort=1

" peekaboo
let g:peekaboo_window="vert botright 40new"

" livedown
let g:livedown_browser=(os=="Darwin" ? "safari" : "chrome")
" }}}
" ============================================================================
" FINISH {{{
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
" }}}
" ============================================================================
