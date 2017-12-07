" SIS vim runtime configuration
syntax on 
set nocp        " no compatibility with VI
set nu          " line number
set cursorline  " highlight current cursorline
set ruler       " display cursor position information at status line
set ic          " case insensitive search
set smartcase   " don't use ic when there is Capital letter
set hlsearch    " hilight search
set incsearch   " show search matches as type
set mouse=a     " enalbe cursor move with mouse
set ts=4        " size of \t character (tab stop)
set sw=4        " tab size, when use <<, >>
set sts=4       " how many spaces, when type tab (soft tab stop)
set et sta      " set expandtab, smarttab
" set list listchars=tab:\|\ ,
set list listchars=tab:>-,
set ai si cindent   " set autoindent, smartindent, cindent
set tm=1000 ttm=0   " to leave insert mode without delay
set ls=2        " last window's status line option
set autowrite   " Automatically :write before running commands
set autoread    " Auto read when a file is changed on disk
set vb noeb     " visual bell instead of beep
set encoding=utf8
set wildignore=*.exe,*.swp,*.zip,*.pyc,*.pyo,*.bin,*.hex,*.o,*.d,*.elf,*.lst,.git,.svn,*.png,*.jpg
set noswapfile
set nobackup

" Autocompletion
set completeopt=menuone,noselect

" Cursor shape
let &t_SI = "\e[5 q"    " Start Insert mode
let &t_EI = "\e[0 q"    " End Insert mode

" Key mapping
noremap  <C-_>  :call NERDComment(0, "toggle")<CR>
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
nnoremap <C-]>  g<C-]>
inoremap <C-b>  <Left>
inoremap <C-f>  <Right>
inoremap <C-a>  <Esc>I
inoremap <C-e>  <End>
inoremap <C-@>  <C-x><C-o>
vnoremap <leader>y  y:call system("xclip -i -selection clipboard", getreg("\""))<CR>
nnoremap <leader>p  :call setreg("\"",system("xclip -o -selection clipboard"))<CR>p

" Save and load former states
autocmd BufWinLeave ?* mkview
autocmd BufWinEnter ?* silent loadview

" C/C++ formatting
function! s:header()
    let name = "__".toupper(substitute(expand("%:t"), "\\.", "_", "g"))."__"
    exe "norm! i#ifndef ". name "\n#define ". name "\n\n\n\n#endif\t//". name "\ekk"
endfunction
autocmd BufNewFile *.{h,hpp} call <SID>header()
autocmd FileType c,h,cpp,hpp inoremap {<ENTER>      {}<Left><ENTER><ENTER><UP><TAB>

" Python formatting
function! s:py_init()
    exe "norm! i\n\n\ndef main():\npass\n\n\eIif __name__ == \"__main__\":\n\tmain()\n\egg"
endfunction
autocmd BufNewFile *.py call <SID>py_init()

" Highlight function (type :help highlight to see color list)
function! s:myhighlight()
    hi linenr       ctermfg=brown ctermbg=NONE
    hi cursorlinenr ctermfg=green ctermbg=NONE
    hi cursorline   cterm=underline
    if (g:easytags_include_members == 1)
        hi cMemberTag   ctermfg=darkcyan
    endif
endfunction
autocmd ColorScheme * call <SID>myhighlight()

autocmd FileType help wincmd L

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
Plugin 'nanotech/jellybeans.vim'
Plugin 'tomasr/molokai'
Plugin 'dracula/vim'

call vundle#end()
filetype plugin indent on

" airline settings
set laststatus=2
let g:airline#extensions#tabline#enabled=1    " turn on buffer list
let g:airline_theme='murmur'
let g:airline_powerline_fonts=1
let g:airline#extensions#branch#enabled=1

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
let g:NERDAltDelims_c=1

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
let g:easytags_opt=['-R --extra=+q --fields=+l']
let g:easytags_events=[]
au BufWinEnter ?* call xolox#easytags#highlight()

" Color settings with bundle theme 
" if has("gui_running")
"     colo industry   " industry, torte, koehler
" else
"     colo slate      " slate, koehler, ron, elflord, pablo
" endif
colo molokai

