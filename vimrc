" vim: set foldmethod=manual:
" ============================================================================
" INTRO {{{
" Get OS informaion
if has("win32") || has("win32unix")
    let g:os="Windows"
else
    let g:os=substitute(system("uname"), "\n", "", "")
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
Plugin 'yggdroot/indentLine'
Plugin 'godlygeek/tabular'
Plugin 'kien/ctrlp.vim'
Plugin 'majutsushi/tagbar'
Plugin 'mileszs/ack.vim'
Plugin 'romainl/vim-qf'
Plugin 'w0rp/ale'
Plugin 'tpope/vim-dispatch'
Plugin 'tpope/vim-surround'
Plugin 'sheerun/vim-polyglot'
Plugin 'junegunn/vim-peekaboo'
Plugin 'shime/vim-livedown'
Plugin 'ryanoasis/vim-devicons'
Plugin 'valloric/matchtagalways'
Plugin 'rhysd/vim-clang-format'
if !has("win32unix")
    Plugin 'valloric/youcompleteme'
endif
" ---------- colorschemes ----------
Plugin 'dracula/vim'
Plugin 'joshdick/onedark.vim'
Plugin 'nanotech/jellybeans.vim'
Plugin 'tomasr/molokai'
Plugin 'cocopon/iceberg.vim'
Plugin 'morhetz/gruvbox'
Plugin 'w0ng/vim-hybrid'
Plugin 'NLKNguyen/papercolor-theme'
Plugin 'tssm/fairyfloss.vim'
Plugin 'sjl/badwolf'
Plugin 'freeo/vim-kalisi'
Plugin 'dikiaap/minimalist'
Plugin 'ajh17/spacegray.vim'
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
set backspace=2
set encoding=utf-8
set title hidden mouse=a
set visualbell noerrorbells
set number cursorline ruler
set splitright splitbelow
set hlsearch incsearch
set ignorecase smartcase
set autoindent smartindent cindent
set smarttab expandtab
set tabstop=4 softtabstop=4 shiftwidth=4
set timeoutlen=500 ttimeoutlen=0
set diffopt+=vertical
set wildmenu completeopt=menuone,noselect
set clipboard^=unnamed,unnamedplus
set nopaste pastetoggle=<F19>
set lazyredraw termguicolors
set path+=**    " add subdirectories in working path
set tags=tags   " echo tagfiles() to check tag files
set wildignore+=.git,.gitmodules,.svn
set wildignore+=*.doc*,*.xls*,*.ppt*
set wildignore+=*.png,*.jpg,*.zip,*.tar,*.gz
set wildignore+=*.exe,*.elf,*.bin,*.hex,*.o,*.so,*.a,*.dll,*.lib
set wildignore+=*.pyc,*.pyo,__pycache__
set wildignore+=tags,.DS_Store,*.stackdump

if has("gui_running")
    set guifont=Consolas_NF:h10,MesloLGM_Nerd_Font_Mono:h9,D2Coding:h10
    set guioptions+=k
    set guioptions-=L guioptions-=T guioptions-=m
endif

let &grepprg='grep -Irin --exclude={tags,"*".{log,bak}} --exclude-dir={.git,.svn} $* .'
let &makeprg='clear && make $*'
set grepformat=%f:%l:%c:%m,%f:%l:%m
set errorformat=%f:%l:%c:%serror:%m

if &term =~ "xterm"
    let &t_SI="\e[5 q"
    let &t_SR="\e[3 q"
    let &t_EI="\e[0 q"
endif
" }}}
" ============================================================================
" MAPPINGS & ABBREVIATIONS {{{
let mapleader=" "
nnoremap Q @q
nnoremap W @w
nnoremap Y y$
nnoremap j gj
nnoremap k gk
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap J ddp
nnoremap K kddpk
nnoremap ? :ts /
nnoremap + >
nnoremap _ <
nnoremap 0 <C-i>zz
nnoremap R :GitGutterAll<cr>
nnoremap T :TagbarToggle<cr>
nnoremap dw diw
nnoremap yw yiw
nnoremap ZA :wa<cr>
nnoremap ZX :xa<cr>
nnoremap <C-c> :Close<cr>
nnoremap <C-h> :GitGutterStageHunk<cr>
nnoremap <C-n> :NERDTreeToggle<cr>
nnoremap <C-o> <C-o>zz
nnoremap <C-t> :JumpBack<cr>zz
nnoremap <C-]> :call GoTo()<cr>
nnoremap <C-w>] :vert stj <cr>
nnoremap <tab> gt
nnoremap <S-tab> gT
nnoremap <bs> :noh<cr>
nnoremap <leader>a :ALEToggle<cr>
nnoremap <leader>b :make all<cr>
nnoremap <leader>d :Gdiff<space>
nnoremap <leader>e :Ack!  %<cr>
nnoremap <leader>f :Ack!<space>
nnoremap <leader>l :ALEFix<cr>
nnoremap <leader>r :Run<cr>
nnoremap <leader>s :SynToggle<cr>
nnoremap <leader>t :!ctags -R .<cr>
nnoremap <leader>w :WhiteSpace<cr>
nnoremap <leader><space> :wa<cr>
vnoremap < <gv
vnoremap > >gv
vnoremap t :Tab /
vnoremap "" s""<esc>P
vnoremap '' s''<esc>P
vnoremap () s()<esc>P
vnoremap <> s<><esc>P
vnoremap [] s[]<esc>P
vnoremap {} s{}<esc>P
vnoremap <leader>/ :Tab /\/\/<cr>
vnoremap <leader>= :Tab /=<cr>
vnoremap <leader>, :call Trim()<cr>gv :Tab /,\zs/l0r1<cr>
vnoremap <leader>: :call Trim()<cr>gv :Tab /:\zs/l0r1<cr>
vnoremap <leader><space> :retab<cr>gv :Tab /\s\zs\S/l1r0<cr>
inoremap <C-a> <esc>I
inoremap <C-e> <end>
inoremap <C-k> <C-o>D
inoremap <C-y> <F19>*<F19>
cnoremap <C-a> <home>
cnoremap <C-y> <C-r>*
noremap! <C-b> <left>
noremap! <C-f> <right>
noremap \1: diffget LO<cr>
noremap \2: diffget BA<cr>
noremap \3: diffget RE<cr>
noremap <C-_> :call NERDComment(0, "toggle")<cr>
noremap <expr> <leader>g &diff ? ":diffget<cr>" : ":GitGutterToggle<cr>"
noremap <expr> <leader>p &diff ? ":diffput<cr>" : ":PluginAction<cr>"
noremap <expr> <leader>h (mode()=='n' ? ":%" : ":") . "s//g<left><left>"
noremap <expr> <leader>; (mode()=='n' ? "V" : "") . ":call Trim()<cr>"
nmap ]t :tabmove +<cr>
nmap [t :tabmove -<cr>
nmap ]q <plug>(qf_qf_next)zz
nmap [q <plug>(qf_qf_previous)zz
nmap <C-j> <plug>GitGutterNextHunk<bar>zz
nmap <C-k> <plug>GitGutterPrevHunk<bar>zz
nmap <leader>j <plug>(ale_next_wrap)zz
nmap <leader>k <plug>(ale_previous_wrap)zz
nmap <leader>q <Plug>(qf_qf_toggle)
nmap <C-w><C-]> <C-w>]
map <C-space> <C-_>

if !has("clipboard")
    noremap \d :del<bar>silent call system("xclip -i -selection clipboard", getreg("\""))<cr>
    noremap \y :yank<bar>silent call system("xclip -i -selection clipboard", getreg("\""))<cr>
    noremap \p :call setreg("\"",system("xclip -o -selection clipboard"))<cr>o<esc>p
endif

abbrev slef self
abbrev ture true
abbrev Ture True
abbrev celan clean
abbrev lamda lambda
abbrev swtich switch
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

" after ftplugin
autocmd FileType * setlocal formatoptions-=o | setlocal formatoptions-=r
autocmd FileType c,cpp setlocal cinoptions=:0,g0
autocmd FileType python setlocal tabstop=4

function! OperatorHL()
    syn match OperatorChars /[+\-*%=~&|^!?.,:;\<>(){}[\]]\|\/[/*]\@!/
    exe "hi OperatorChars guifg=" . (&bg=="dark" ? "cyan" : "red")
endfunction
autocmd ColorScheme c,cpp,python call OperatorHL()
autocmd Syntax c,cpp,python call OperatorHL()

augroup XML
    autocmd!
    autocmd FileType xml setlocal fdm=indent
    autocmd FileType xml setlocal fdl=2
augroup END

function! AUTOSAR()
    syn keyword cType boolean
    syn keyword cType sint8 sint16 sint32
    syn keyword cType uint8 uint16 uint32
    syn keyword cType float32 float64
endfunction
autocmd Syntax c,cpp call AUTOSAR()
autocmd BufRead,BufNewFile *.arxml set filetype=xml

function! NewHeader()
    if 1
        exe "norm! i#pragma once\n\n\e"
    else
        let name = toupper(substitute(expand("%:t"), "\\.", "_", "g"))
        exe "norm! i#ifndef ". name "\n#define ". name "\n\n\n\n#endif  /* ". name " */\e4G"
    endif
endfunction

function! NewPy()
    if g:os != "Windows"
        exe "norm! i#!".system("which python3")
    endif
    exe "norm! i\n\nif __name__ == \"__main__\":\npass\ekkk"
endfunction

augroup NewFile
    autocmd!
    autocmd BufNewFile *.{h,hpp} call NewHeader()
    autocmd BufNewFile *.py call NewPy()
augroup END
" }}}
" ============================================================================
" FUNCTIONS & COMMANDS {{{
command! Font set guifont=*
command! Clear noh | cexpr []
command! JumpBack try | pop | catch | exe "norm " | endtry
command! Diff exe "windo " . (&diff ? "diffoff" : "diffthis")
command! SynToggle exe "syn " . (exists("g:syntax_on") ? "off" : "on")

command! RemoveTrailingWS %s/\s\+$//e
command! TS set expandtab | %retab
command! ST set noexpandtab | %retab!

command! Close call Close()
function! Close()
    cclose
    pclose
    helpclose
    NERDTreeClose
    TagbarClose
endfunction

command! WhiteSpace call WhiteSpace()
function! WhiteSpace()
    if &diffopt !~ "iwhite"
        set diffopt+=iwhite
        let g:gitgutter_diff_args='-b'
        echo "Ignore white space"
    else
        set diffopt-=iwhite
        let g:gitgutter_diff_args=''
        echo "Check white space"
    endif
    GitGutterAll
endfunction

function! GoTo()
    try
        exe "tjump " . expand("<cword>")
    catch
        YcmCompleter GoTo
    endtry
endfunction

if !exists("*Run")
    command! Run call Run()
    function! Run()
        if !has("win32") | silent !clear
        endif

        if &filetype == "vim"
            source %
        elseif &filetype == "sh"
            !source %
        elseif &filetype == "c" || &filetype == "cpp"
            make run
        elseif &filetype == "python"
            exe has("win32") ? "!python %" : "!python3 %"
        elseif &filetype == "markdown"
            LivedownPreview
        elseif &filetype == "swift"
            !swift %
        else
            echom "There's nothing to do"
        endif
    endfunction
endif

command! PluginAction call PluginAction()
function! PluginAction()
    echo "Select mode [i,c,u]: "
    let l:cin = nr2char(getchar())

    if l:cin == 'i'
        PluginInstall
    elseif l:cin == 'c'
        PluginClean
    elseif l:cin == 'u'
        PluginUpdate
    else
        echo "Invalid input"
    endif
endfunction

function! Trim()
    silent '<,'>retab
    silent exe "'<,'>" . 's/\([({[]\) */\1/ge'
    silent exe "'<,'>" . 's/\S\zs *\([)}\];]\)/\1/ge'
    silent exe "'<,'>" . 's/ *\([,:]\) */\1 /ge'
    silent exe "'<,'>" . 's/ *\([=!~&|^+\-*/%<>]\{1,3}\) */ \1 /ge'
    silent exe "'<,'>" . 's/ *-> */->/ge'
    silent '<,'>s/\(\S\)\s\+/\1 /ge
    silent '<,'>s/\s\+$//e
endfunction
" }}}
" ============================================================================
" PLUGIN SETTINGS {{{
" youcompleteme
let g:ycm_confirm_extra_conf=0
let g:ycm_global_ycm_extra_conf='~/workspace/dotfiles/conf/ycm_extra_conf.py'
let g:ycm_collect_identifiers_from_tags_files=1
let g:ycm_disable_for_files_larger_than_kb=1024
let g:ycm_key_list_select_completion=['<down>']
let g:ycm_key_list_previous_completion=['<up>']
let g:ycm_key_list_stop_completion=[]

" gitgutter
set updatetime=100
set signcolumn=yes
let g:gitgutter_map_keys=0
let g:gitgutter_max_signs=1024
let g:gitgutter_enabled=(has("gui_win32") ? 0 : 1)

" airline
set laststatus=2
let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#formatter='unique_tail'
let g:airline#extensions#tabline#show_buffers=0
let g:airline#extensions#tabline#tab_nr_type=1
nnoremap <leader>1 1gt
nnoremap <leader>2 2gt
nnoremap <leader>3 3gt
nnoremap <leader>4 4gt
nnoremap <leader>5 5gt
nnoremap <leader>6 6gt
nnoremap <leader>7 7gt
nnoremap <leader>8 8gt
nnoremap <leader>9 9gt

" NERDTree
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
let g:NERDTreeMapOpenVSplit='v'
let g:NERDTreeQuitOnOpen=1
let g:NERDTreeRespectWildIgnore=1
let g:NERDTreeShowHidden=1

" NERDCommenter
let g:NERDCommentEmptyLines=1
let g:NERDDefaultAlign='left'
let g:NERDSpaceDelims=1
let g:NERDTrimTrailingWhitespace=1
let g:NERDCustomDelimiters={'python': {'left': '#'},
            \ 'c': {'left': '//', 'leftAlt': '/*', 'rightAlt': '*/'}}

" AutoPairs
let g:AutoPairsFlyMode=0
let g:AutoPairsShortcutFastWrap="<C-l>"

" indentLine
let g:indentLine_leadingSpaceChar='.'
let g:indentLine_leadingSpaceEnabled=0
let g:indentLine_showFirstIndentLevel=1
let g:indentLine_fileTypeExclude=['help', 'nerdtree', 'tagbar', 'text']

" CtrlP
let g:ctrlp_by_filename=1
let g:ctrlp_show_hidden=1
let g:ctrlp_match_window='results:100'
if has("win32")
    let g:ctrlp_user_command='dir %s /-n /b /s /a-d | findstr /v /l ".git .xls .ppt .doc"'
else
    let g:ctrlp_user_command='find %s -type f | grep -v -e .git -e .o\$ -e .xls -e .ppt -e .doc'
endif

" tagbar
let g:tagbar_autofocus=1
let g:tagbar_sort=0

" ack
autocmd VimEnter * if g:os=="Windows" | let g:ackprg="ack -His --smart-case --column --nocolor --nogroup" | endif
let g:ack_apply_qmappings=0
let g:ack_qhandler="botright cwindow"
let g:ackhighlight=1

" qf
let g:qf_auto_resize=0
let g:qf_mapping_ack_style=1

" ale
let g:ale_linters={
            \'python': ['flake8'],
            \}
let g:ale_fixers={
            \'c': ['clang-format'],
            \'cpp': ['clang-format'],
            \'python': ['autopep8'],
            \'xml': ['xmllint'],
            \}
let g:ale_xml_xmllint_options="--format"

" peekaboo
let g:peekaboo_window="vert botright 40new"

" livedown
let g:livedown_browser=(g:os=="Darwin" ? "safari" : "chrome")

" devicon
" let g:webdevicons_enable=(os=="Darwin" ? 1 : 0)
let g:WebDevIconsUnicodeDecorateFolderNodes=1
let g:DevIconsEnableFoldersOpenClose=1

" clang-format
autocmd FileType c,cpp vnoremap <leader>l :ClangFormat<cr>gv=
" }}}
" ============================================================================
" OUTRO {{{
if g:os == "Darwin"
    colo dracula
    let g:airline_theme='dracula'
elseif g:os == "Linux"
    colo jellybeans
    let g:airline_theme='jellybeans'
elseif has("win32")
    colo hybrid
    let g:airline_theme='hybrid'
elseif has("win32unix")
    colo onedark
    let g:airline_theme='onedark'
endif
" }}}
" ============================================================================
