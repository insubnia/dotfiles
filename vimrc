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
set mouse=a		" enalbe cursor move with mouse
set ts=4        " size of \t character (tab stop)
set sw=4		" tab size, when use <<, >>
set sts=4		" how many spaces, when type tab (soft tab stop)
set ls=2		" last window's status line option
set expandtab smarttab
set autowrite	" Automatically :write before running commands
set autoread    " Auto read when a file is changed on disk
set autoindent
set smartindent
set cindent
set vb noeb     " visual bell instead of beep
set tm=1000 ttm=0    " to leave insert mode without delay
set encoding=utf8
set wildignore=tags,*.exe,*.swp,*.zip,*.pyc,*.pyo,*.bin,*.hex,*.o,*.d,*.elf,*.lst

" Autocompletion
set completeopt=longest,noselect,menuone

" Cursor shape
let &t_SI = "\e[5 q"    " Start Insert mode
let &t_EI = "\e[0 q"    " End Insert mode

" Key mapping
noremap  <C-_>  :call NERDComment(0, "toggle")<CR>
nnoremap <F2>   :!ctags -R -I --languages=C,C++ --c++-kinds=+p --fields=+iaS --extra=+q .<CR>
nnoremap <F3>   :NERDTreeToggle<CR><C-w>=
nnoremap <F4>   :TlistToggle<CR><C-w>=
nnoremap <F5>   <C-w>=
nnoremap <F8>   :!grep --color=auto -Irin --exclude={tags,*.lst,*.map,*.d} --exclude-dir={.git,.svn} 
nnoremap Y  y$
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
autocmd FileType c,h,cpp,hpp inoremap {<ENTER>		{}<Left><ENTER><ENTER><UP><TAB>

" Save and load former states
autocmd BufWinLeave ?* mkview
autocmd BufWinEnter ?* silent loadview

" C/C++ header
function! s:header()
	let name = "__".toupper(substitute(expand("%:t"), "\\.", "_", "g"))."__"
	exe "norm! i#ifndef ". name "\n#define ". name "\n\n\n\n#endif\t//". name "\ekk"
endfunction
autocmd BufNewFile *.{h,hpp} call <SID>header()

" Python header
function! s:py_init()
    exe "norm! i\n\n\ndef main():\npass\n\n\eIif __name__ == \"__main__\":\n\tmain()\n\egg"
endfunction
autocmd BufNewFile *.py call <SID>py_init()


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
Plugin 'taglist-plus'
Plugin 'nanotech/jellybeans.vim'

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

" CtrlP settings
let g:ctrlp_by_filename=0
let g:ctrlp_show_hidden=1
" let g:ctrlp_wildignore=1

" taglist settings
let Tlist_Use_Right_Window=1

" Color settings with bundle theme (type help highlight in order to see color list)
if has("gui_running")
	colo industry   " industry, torte, koehler
else
	colo slate      " slate, koehler, ron, elflord, pablo
endif
colo jellybeans
highlight linenr        ctermfg=brown ctermbg=NONE
highlight cursorlinenr  ctermfg=green ctermbg=NONE
highlight cursorline    cterm=underline

