" SIS vim runtime configuration
syntax on
set nocp            " no compatibility with VI
set nu              " line number
set cursorline      " highlight current cursorline
set ruler           " display cursor position information at status line
set ic              " case insensitive search
set smartcase       " don't use ic when there is Capital letter
set hlsearch        " hilight search
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
set vb noeb         " visual bell instead of beep
set wildmenu        " enhanced command-line completion
set diffopt+=iwhite " ignore white spaces in diff mode
set encoding=utf8
set noswapfile nobackup
set wildignore=*.exe,*.swp,*.zip,*.pyc,*.pyo,*.bin,*.hex,*.o,*.d,*.elf,*.lst,.git,.svn,*.png,*.jpg,__pycache__
set completeopt=menuone,noselect

" Cursor shape
let &t_SI = "\e[5 q"    " Start Insert mode
let &t_EI = "\e[0 q"    " End Insert mode

" Key mapping
noremap <C-_>   :call NERDComment(0, "toggle")<CR>
nnoremap <F2>   :UpdateTags<CR>
nnoremap <F3>   :NERDTreeToggle<CR><C-w>=
nnoremap <F4>   :TagbarToggle<CR><C-w>=
nnoremap <F5>   <C-w>=
nnoremap <F8>   :!grep --color=auto -Irin --exclude={tags,*.lst,*.map,*.d} --exclude-dir={.git,.svn} 
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
nnoremap <C-]>  g<C-]>
inoremap <C-b>  <Left>
inoremap <C-f>  <Right>
inoremap <C-a>  <Esc>I
inoremap <C-e>  <End>
inoremap <C-@>  <C-x><C-o>
cnoremap <C-b>  <Left>
cnoremap <C-f>  <Right>
cnoremap <C-t>  Tabularize /
cnoremap %s/    %s///g<Left><Left><Left>
vnoremap :s/    :s///g<Left><Left><Left>
nnoremap <leader>d  dd:call system("xclip -i -selection clipboard", getreg("\""))<CR>
nnoremap <leader>y  yy:call system("xclip -i -selection clipboard", getreg("\""))<CR>
vnoremap <leader>d  d:call system("xclip -i -selection clipboard", getreg("\""))<CR>
vnoremap <leader>y  y:call system("xclip -i -selection clipboard", getreg("\""))<CR>
nnoremap <leader>p  :call setreg("\"",system("xclip -o -selection clipboard"))<CR>o<ESC>p
if &diff
    noremap <leader>1   :diffget LOCAL<CR>
    noremap <leader>2   :diffget BASE<CR>
    noremap <leader>3   :diffget REMOTE<CR>
    nnoremap <C-k>  [czz
    nnoremap <C-j>  ]czz
endif

" C/C++ formatting
function! MyC()
    let name = "__".toupper(substitute(expand("%:t"), "\\.", "_", "g"))."__"
    exe "norm! i#ifndef ". name "\n#define ". name "\n\n\n\n#endif\t//". name "\ekk"
endfunction
autocmd BufNewFile *.{h,hpp} call MyC()
autocmd FileType c,cpp inoremap {<ENTER>      {<ENTER>}<UP><END><ENTER>

" Python formatting
function! MyPy()
    exe "norm! i\n\n\ndef main():\npass\n\n\eIif __name__ == \"__main__\":\n\tmain()\n\egg"
endfunction
autocmd BufNewFile *.py call MyPy()

" Highlight function (type :help highlight to see color list)
function! MyHighlight()
    " hi linenr       ctermfg=brown ctermbg=NONE
    " hi cursorlinenr ctermfg=green ctermbg=NONE
    hi cursorline   cterm=underline
    if (g:easytags_include_members == 1)
        hi cMemberTag   ctermfg=darkcyan
    endif
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

" Plugin settings using Vundle
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'tpope/vim-fugitive'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/nerdcommenter'
Plugin 'kien/ctrlp.vim'
Plugin 'majutsushi/tagbar'
Plugin 'xolox/vim-misc'
Plugin 'xolox/vim-easytags'
Plugin 'Yggdroot/indentLine'
Plugin 'godlygeek/tabular'
Plugin 'nanotech/jellybeans.vim'
Plugin 'tomasr/molokai'
Plugin 'dracula/vim'

call vundle#end()
filetype plugin indent on

" airline settings
let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#branch#enabled=1
let g:airline#extensions#tagbar#enabled=1

" NERDTree settings
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
let g:NERDTreeDirArrowExpandable='+'
let g:NERDTreeDirArrowCollapsible='~'
let g:NERDTreeRespectWildIgnore=1
let g:NERDTreeShowHidden=1
set splitright

" NERDCommenter settings
let g:NERDSpaceDelims=1
let g:NERDCompactSexyComs=1
let g:NERDDefaultAlign='left'
let g:NERDCommentEmptyLines=1
let g:NERDTrimTrailingWhitespace=1
" let g:NERDAltDelims_c=0
let g:NERDCustomDelimiters = {
            \'c': {'left': '//', 'leftAlt': '/*', 'rightAlt': '*/'},
            \'python': {'left': '#'},
            \}

" CtrlP settings
let g:ctrlp_by_filename=0
let g:ctrlp_show_hidden=1
" let g:ctrlp_wildignore=1

" tagbar settings
let g:tagbar_autofocus=1
let g:tagbar_sort=1

" easytags settings
set cpoptions+=d
set tags=./tags
let g:easytags_autorecurse=1
let g:easytags_dynamic_files=2
let g:easytags_auto_highlight=1
let g:easytags_include_members=0
let g:easytags_opts=[
            \'-R', '--sort=yes',
            \'--fields=+iaS', '--extra=+q',
            \'--c-kinds=+p',
            \]
let g:easytags_events=[]
au BufWinEnter * call xolox#easytags#highlight()

" indentLine
let g:indentLine_char='│'
let g:indentLine_first_char='│'
let g:indentLine_showFirstIndentLevel=1
let g:indentLine_leadingSpaceEnabled=0
let g:indentLine_leadingSpaceChar='.'

let g:airline_theme='jellybeans'
colo jellybeans

