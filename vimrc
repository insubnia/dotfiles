" vim: set foldmethod=manual:
" ============================================================================
" INTRO {{{
" Get OS informaion (:help feature-list)
if has('win32') || has('win32unix')
    let g:os='Windows'
else
    let g:os=substitute(system('uname'), '\n', '', '')
endif
" }}}
" ============================================================================
" PLUGINS {{{
if has('nvim')
    call plug#begin((has('win32') ? '~/AppData/Local/nvim' : '~/.config/nvim') . '/plugged')
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
    Plug 'arakashic/chromatica.nvim', has('unix') ? {} : {'on': []}
else
    call plug#begin((has('win32') ? '~/vimfiles' : '~/.vim') . '/plugged')
    Plug 'valloric/youcompleteme', has('unix') ? {} : {'on': []}
    Plug 'chiel92/vim-autoformat', {'on': ['Autoformat']}
    " Plug 'jeaye/color_coded', has('unix') ? {} : {'on': []}
endif
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
Plug 'jiangmiao/auto-pairs'
Plug 'sirver/ultisnips'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'blueyed/vim-diminactive'
Plug 'godlygeek/tabular'
Plug 'mileszs/ack.vim'
Plug 'romainl/vim-qf'
Plug 'majutsushi/tagbar', {'on': ['TagbarToggle']}
Plug 'ctrlpvim/ctrlp.vim'
Plug 'dense-analysis/ale'
Plug 'tpope/vim-dispatch', {'on': ['Dispatch']}
Plug 'tpope/vim-surround'
Plug 'tpope/vim-sensible'
Plug 'sheerun/vim-polyglot'
Plug 'junegunn/vim-peekaboo'
Plug 'iamcco/markdown-preview.nvim', { 'do': ':call mkdp#util#install()', 'for': 'markdown', 'on': 'MarkdownPreview' }
Plug 'ryanoasis/vim-devicons'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'xuyuanp/nerdtree-git-plugin', has('unix') ? {} : {'on': []}
" ---------- colorschemes ----------
" Best
Plug 'dracula/vim'
Plug 'ayu-theme/ayu-vim' " light, dark, mirage
Plug 'ajmwagar/vim-deus'
Plug 'joshdick/onedark.vim'
" Dark
Plug 'nanotech/jellybeans.vim'
Plug 'dikiaap/minimalist'
Plug 'ashfinal/vim-colors-violet'
Plug 'w0ng/vim-hybrid'
Plug 'tomasiser/vim-code-dark'
" Vivid
Plug 'josuegaleas/jay'
Plug 'tomasr/molokai'
Plug 'sjl/badwolf'
Plug 'NLKNguyen/papercolor-theme'
" Low contrast
Plug 'morhetz/gruvbox'
Plug 'freeo/vim-kalisi'
" Pastel
Plug 'crucerucalin/peaksea.vim'
Plug 'sheerun/vim-wombat-scheme'
" Cynical
Plug 'cocopon/iceberg.vim'
Plug 'fxn/vim-monochrome'
" Retro
Plug 'bdesham/biogoo'
Plug 'tssm/fairyfloss.vim'
" Others
Plug 'ajh17/spacegray.vim'
Plug 'chriskempson/base16-vim'
call plug#end()
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
set hlsearch incsearch "nowrapscan
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
set wildignore+=.git,.gitmodules,.gitignore,.svn
set wildignore+=*.doc*,*.xls*,*.ppt*
set wildignore+=*.png,*.jpg,*.zip,*.tar,*.gz
set wildignore+=*.exe,*.elf,*.bin,*.hex,*.o,*.so,*.a,*.dll,*.lib
set wildignore+=*.pyc,*.pyo,__pycache__
set wildignore+=tags,.DS_Store,*.stackdump

if has('nvim')
    if has('win32') " Windows nvim-qt
        let g:python3_host_prog = 'C:/Python39/python'
    endif
endif

if has('gui_win32') " Windows vim
    set omnifunc=syntaxcomplete#Complete
    set guifont=Consolas_NF:h10,D2Coding:h10
    set guioptions+=k guioptions+=r
    set guioptions-=L guioptions-=T guioptions-=m
    set pythonthreehome=C:\Python39
    set pythonthreedll=C:\Python39\python39.dll
endif

let &grepprg='grep -Irin --exclude={tags,"*".{log,bak}} --exclude-dir={.git,.svn} $* .'
let &makeprg='clear && make $*'
set grepformat=%f:%l:%c:%m,%f:%l:%m
set errorformat=%f:%l:%c:%serror:%m

if &term =~ 'xterm'
    let &t_SI="\e[5 q"
    let &t_SR="\e[3 q"
    let &t_EI="\e[0 q"
endif

let c_syntax_for_h = 1
" }}}
" ============================================================================
" KEY MAPPINGS {{{
let mapleader=' '
nnoremap Q @q
nnoremap W @w
nnoremap Y y$
nnoremap j gj
nnoremap k gk
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
" nnoremap ? :ts /
nnoremap + >
nnoremap _ <
nnoremap 0 <C-i>zz
nnoremap R :GitGutterEn<cr>:GitGutterAll<cr>
nnoremap T :TagbarToggle<cr>
nnoremap cw ciw
nnoremap dw diw
nnoremap yw yiw
nnoremap ZX :xa<cr>
nnoremap <C-c> :Close<cr>
nnoremap <C-h> :GitGutterStageHunk<cr>
nnoremap <C-n> :NERDTreeToggle<cr>
nnoremap <C-o> <C-o>zz
nnoremap <C-t> :JumpBack<cr>zz
nnoremap <C-q> :copen<cr>n
nnoremap <C-]> :GoTo<cr>
" nnoremap <C-w>] :vert stj <cr>
nnoremap <C-w>] :vs<cr>:GoTo<cr>
nnoremap <tab> gt
nnoremap <S-tab> gT
nnoremap <M-Up> kddpk
nnoremap <M-Down> ddp
nnoremap <M-Right> <C-i>zz
nnoremap <M-Left> <C-o>zz
nnoremap <bs> :noh<cr>
nnoremap <leader>d :Diff<cr>
nnoremap <leader>e :Trim<cr>
nnoremap <leader>f :Ack!<space>
nnoremap <leader>m :marks<cr>
" nnoremap <leader>q
nnoremap <leader>r :Run<cr>
nnoremap <leader>u :Build<cr>
nnoremap <leader>w :IgnoreSpaceChange<cr>
nnoremap <leader><space> :wa<cr>
" nnoremap <leader>E
" nnoremap <leader>F
" nnoremap <leader>R
nnoremap <leader><cr> o<esc>
vnoremap < <gv
vnoremap > >gv
vnoremap t :Tab /
vnoremap vw viw
vnoremap "" s""<esc>P
vnoremap '' s''<esc>P
vnoremap () s()<esc>P
vnoremap <> s<><esc>P
vnoremap [] s[]<esc>P
vnoremap {} s{}<esc>P
vnoremap <leader>/ :Tab /\/\/<cr>
vnoremap <leader>= :Tab /=<cr>
vnoremap <leader>, :call MyFormat()<cr>gv :Tab /,\zs/l0r1<cr>
vnoremap <leader>: :call MyFormat()<cr>gv :Tab /:\zs/l0r1<cr>
vnoremap <leader><space> :retab<cr>gv :Tab /\s\zs\S/l1r0<cr>
inoremap <C-a> <esc>I
inoremap <C-e> <end>
inoremap <C-k> <C-o>D
inoremap <C-v> <F19>*<F19>
cnoremap <C-a> <home>
cnoremap <C-v> <C-r>*
noremap! <C-b> <left>
noremap! <C-f> <right>
noremap! <C-j> <del>
noremap! <C-y> <C-v>
noremap! <F15> <nop>
noremap <F15> <nop>
noremap \1 :diffget LO<cr>
noremap \2 :diffget BA<cr>
noremap \3 :diffget RE<cr>
noremap <C-/> :call NERDComment(0, "toggle")<cr>
noremap <expr> <leader>g &diff ? ":diffget<cr>" : ":Gdiff<space>"
noremap <expr> <leader>p &diff ? ":diffput<cr>" : ":PlugAction<cr>"
noremap <expr> <leader>h (mode()=='n' ? ":%" : ":") . "s//g<left><left>"
noremap <expr> <leader>; (mode()=='n' ? "V" : "") . ":call MyFormat()<cr>"
nmap ]t :tabmove +<cr>
nmap [t :tabmove -<cr>
nmap <C-j> <plug>(GitGutterNextHunk)<bar>zz
nmap <C-k> <plug>(GitGutterPrevHunk)<bar>zz
nmap <C-q> <plug>(qf_qf_toggle)
nmap <leader>l <plug>(ale_fix)
nmap <leader>j <Plug>(qf_qf_next)zz
nmap <leader>k <Plug>(qf_qf_previous)zz
nmap <C-w><C-]> <C-w>]
imap <S-tab> <C-d>

if has('nvim')
    nnoremap ; :call CocAction('doHover')<cr>
    nnoremap ? :CocList -I symbols<cr>

    nmap J <plug>(coc-diagnostic-next)
    nmap K <plug>(coc-diagnostic-prev)
    nmap gd <plug>(coc-definition)
    nmap gl <plug>(coc-codeaction)
    nmap gr <plug>(coc-rename)
    " nmap <leader>l <plug>(coc-format)
    vmap <leader>l <plug>(coc-format-selected)
    " Terminal keymappings
    nnoremap <leader>t :topleft vs<bar>term<cr>:set nonumber<cr>i
    tnoremap <esc> <C-\><C-n>
else
    nmap J <plug>(ale_next_wrap)zz
    nmap K <plug>(ale_previous_wrap)zz
    vnoremap <leader>l :Autoformat<cr>
endif

" Keymap emulation
map <C-_> <C-/>
if has('gui_win32') " Windows vim
    map <C-space> <C-/>
endif

" Fast yank & paste
noremap <expr> 1y mode()=='n' ? '"1yiw' : '"1y'
noremap <expr> 2y mode()=='n' ? '"2yiw' : '"2y'
noremap <expr> 3y mode()=='n' ? '"3yiw' : '"3y'
noremap <expr> 4y mode()=='n' ? '"4yiw' : '"4y'
noremap <expr> 5y mode()=='n' ? '"5yiw' : '"5y'
noremap <expr> 6y mode()=='n' ? '"6yiw' : '"6y'
noremap <expr> 7y mode()=='n' ? '"7yiw' : '"7y'
noremap <expr> 8y mode()=='n' ? '"8yiw' : '"8y'
noremap <expr> 9y mode()=='n' ? '"9yiw' : '"9y'
noremap <expr> 0y mode()=='n' ? '"0yiw' : '"0y'
noremap 1p "1p
noremap 2p "2p
noremap 3p "3p
noremap 4p "4p
noremap 5p "5p
noremap 6p "6p
noremap 7p "7p
noremap 8p "8p
noremap 9p "9p
noremap 0p "0p

if !has('clipboard')
    noremap \d :del<bar>silent call system("xclip -i -selection clipboard", getreg("\""))<cr>
    noremap \y :yank<bar>silent call system("xclip -i -selection clipboard", getreg("\""))<cr>
    noremap \p :call setreg("\"",system("xclip -o -selection clipboard"))<cr>o<esc>p
endif
" }}}
" ============================================================================
" ABBREVIATIONS {{{
" <C-o> is dummy to invalidate inserting space

" Timestamp
iabbrev xdate <C-r>=strftime("%m/%d/%Y")<cr><C-o>

" Fix typo
abbrev hlep help
abbrev slef self
abbrev ture true
abbrev Ture True
abbrev flase false
abbrev Flase False
abbrev pirnt print
abbrev celan clean
abbrev lamda lambda
abbrev swtich switch
abbrev sturct struct
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
autocmd FileType xml,json setlocal tabstop=2 softtabstop=2 shiftwidth=2

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
    nnoremap <Right> :set foldlevel+=1<cr>:echo "Fold Level:" &foldlevel<cr>
    nnoremap <Left> :set foldlevel-=1<cr>:echo "Fold Level:" &foldlevel<cr>
augroup END

function! AUTOSAR()
    syn keyword cType boolean
    syn keyword cType sint8 sint16 sint32
    syn keyword cType uint8 uint16 uint32
    syn keyword cType float32 float64
endfunction
autocmd Syntax c,cpp call AUTOSAR()

autocmd BufRead,BufNewFile *.arxml set filetype=xml
autocmd BufRead,BufNewFile *.sre,*.sb1 set filetype=srec
autocmd BufRead,BufNewFile *.cmm set filetype=cmm
autocmd BufRead,BufNewFile CMakeLists* set filetype=cmake

function! NewHeader()
    if 1
        let name = "_" . toupper(substitute(expand("%:t"), "\\.", "_", "g")) . "_"
        exe "norm! i#ifndef " . name . "\n#define " . name . "\n\n\n\n#endif /* ". name . " */\e4G"
    else
        exe "norm! i#pragma once\n\n\e"
    endif
endfunction

function! NewPy()
    if g:os != 'Windows'
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
command! -nargs=1 Silent execute 'silent !' . <q-args> | execute 'redraw!'

command! Font set guifont=*
command! Clear noh | cexpr []
command! JumpBack try | pop | catch | exe "norm " | endtry
command! Diff exe "windo " . (&diff ? "diffoff" : "diffthis")
command! SyntaxToggle exe "syn " . (exists("g:syntax_on") ? "off" : "on")

command! TS set expandtab | %retab
command! ST set noexpandtab | %retab!
command! Trim set expandtab | %retab | %s/\s\+$//e | %s/$//e
command! RO set ro
command! RW set noro

command! Preproc Silent gcc -E % | less

command! Close call Close()
function! Close()
    cclose
    pclose
    helpclose
    NERDTreeClose
    try | exe 'TagbarClose' | catch | endtry
endfunction

command! IgnoreSpaceChange call IgnoreSpaceChange()
function! IgnoreSpaceChange()
    if &diffopt !~ 'iwhite'
        set diffopt+=iwhite
        let g:gitgutter_diff_args='-b'
        echo "Ignore space change"
    else
        set diffopt-=iwhite
        let g:gitgutter_diff_args=''
        echo "Check space change"
    endif
    GitGutterAll
endfunction

command! GoTo call GoTo()
function! GoTo()
    try
        exe "tjump " . expand("<cword>")
    catch /E426:\|E433:/
        if has('nvim')
            call CocAction('jumpDefinition')
        else
            try
                YcmCompleter GoTo
            catch /E492:/
                echohl WarningMsg | echo "No youcompleteme" | echohl None
            endtry
        endif
    endtry
endfunction

command! Build call Build()
function! Build()
    if &filetype == 'c' || &filetype == 'cpp'
        exe has('nvim') ? '!make all' : 'make all'
    endif
endfunction

if !exists('*Run')
    command! Run call Run()
    function! Run()
        if !has('win32') | silent !clear
        endif

        if &filetype == 'vim'
            source %
        elseif &filetype == 'sh'
            !source %
        elseif &filetype == 'c' || &filetype == 'cpp'
            exe has('nvim') ? '!make all run' : 'make all run'
        elseif &filetype == 'python'
            exe has('win32') ? '!python %' : '!python3 %'
        elseif &filetype == 'markdown'
            MarkdownPreview
        else
            echom "There's nothing to do"
        endif
    endfunction
endif

command! PlugAction call PlugAction()
function! PlugAction()
    echo "Select mode [i,c,u]: "
    let l:cin = nr2char(getchar())

    if l:cin == ''
        redraw!
    elseif l:cin == 'i'
        PlugInstall
    elseif l:cin == 'c'
        PlugClean
    elseif l:cin == 'u'
        PlugUpdate
    else
        echo "Invalid input"
    endif
endfunction

function! MyFormat()
    silent '<,'>retab
    silent exe "'<,'>" . 's/\([({[]\) */\1/ge'
    silent exe "'<,'>" . 's/\S\zs *\([)}\];]\)/\1/ge'
    silent exe "'<,'>" . 's/ *\([,:]\) */\1 /ge'
    silent exe "'<,'>" . 's/ *\([=!~&|^+\-*/%<>]\{1,3}\) */ \1 /ge'
    silent '<,'>s/ *-> */->/ge
    silent '<,'>s/ *++ */++/ge
    silent '<,'>s/ *-- */--/ge
    silent '<,'>s/\(\S\)\s\+/\1 /ge
    silent '<,'>s/\s\+$//e
endfunction

if !exists('*HV')
    command HV call HV()
    let b:hex_view = 0
    function! HV()
        if (b:hex_view == 0)
            let b:hex_view = 1
            exe "%!xxd"
            set filetype=xxd
            set readonly
        else
            let b:hex_view = 0
            exe "%!xxd -r"
            set noreadonly
        endif
    endfunc
endif

command! -nargs=+ FL call FL(<f-args>)
function! FL(...)
    try
        exe "set foldlevel=" . a:1
    catch
        echo "Fold Level:" &foldlevel
    endtry
endfunction
" }}}
" ============================================================================
" PLUGIN SETTINGS {{{
" youcompleteme
let g:ycm_confirm_extra_conf = 0
let g:ycm_global_ycm_extra_conf = '~/workspace/dotfiles/vim/ycm_extra_conf.py'
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_disable_for_files_larger_than_kb = 1024
let g:ycm_key_list_select_completion = ['<down>']
let g:ycm_key_list_previous_completion = ['<up>']
let g:ycm_key_list_stop_completion = []
let g:ycm_show_diagnostics_ui = 0

" coc
let g:coc_global_extensions = [
            \'coc-clangd',
            \'coc-cmake',
            \'coc-json',
            \'coc-prettier',
            \'coc-python',
            \'coc-snippets',
            \'coc-ultisnips',
            \'coc-tsserver',
            \'coc-xml',
            \]
let g:coc_config_home = '~/workspace/dotfiles/vim'
if has('nvim')
    inoremap <silent><expr> <c-space> coc#refresh()
    inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<CR>"
    inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
    inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
endif

" chromatica
let g:chromatica#enable_at_startup = 1
if g:os == 'Darwin'
    let g:chromatica#libclang_path = '/Library/Developer/CommandLineTools/usr/lib/libclang.dylib'
elseif g:os == 'Linux'
    let g:chromatica#libclang_path = '/usr/lib/x86_64-linux-gnu/libclang-10.so'
endif
let g:chromatica#global_args = []
let g:chromatica#responsive_mode = 1
let g:chromatica#delay_ms = 500

" gitgutter
set updatetime=100
set signcolumn=yes
let g:gitgutter_map_keys = 0
let g:gitgutter_max_signs = 1024
let g:gitgutter_enabled = (has('gui_win32') ? 0 : 1)

" airline
set laststatus=2
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#tab_nr_type = 1
function! AirlineInit()
    if g:os == 'Darwin'
        let g:airline_section_c .= ' 🧿 %#__accent_bold#%{$USER}'
    elseif g:os == 'Linux'
        let g:airline_section_c .= ' 👻 %#__accent_bold#%{$USER}'
    elseif has('win32')
        let g:airline_section_c .= ' 🚗 %#__accent_bold#%{$USERNAME} from MANDO'
    endif
endfunction
autocmd User AirlineAfterInit call AirlineInit()
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
autocmd StdinReadPre * let s:std_in = 1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
let g:NERDTreeMapOpenVSplit = 'v'
let g:NERDTreeQuitOnOpen = 0
let g:NERDTreeRespectWildIgnore = 1
let g:NERDTreeShowHidden = 1
let g:NERDTreeDirArrowExpandable = ''
let g:NERDTreeDirArrowCollapsible = ''

" NERDCommenter
let g:NERDCommentEmptyLines = 1
let g:NERDDefaultAlign = 'left'
let g:NERDSpaceDelims = 1
let g:NERDTrimTrailingWhitespace = 1
let g:NERDCustomDelimiters = {
            \'python': {'left': '#'},
            \'c': {'left': '//', 'leftAlt': '/*', 'rightAlt': '*/'},
            \'json': {'left': '/*', 'right': '*/'},
            \'cmm': {'left': ';'},
            \'lsl': {'left': '//', 'leftAlt': '/*', 'rightAlt': '*/'}
            \}

" AutoPairs
let g:AutoPairsFlyMode = 0
let g:AutoPairsShortcutFastWrap = '<C-l>'
autocmd FileType vim if has_key(g:AutoPairs, '"') | unlet g:AutoPairs['"'] | endif
autocmd FileType c,cpp let g:AutoPairs['/*'] = '*/'
autocmd FileType python inoremap f' f''<left>

" UltiSnips
let g:UltiSnipsExpandTrigger = "<C-s>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<S-tab>"
let g:UltiSnipsEditSplit = "vertical"
let g:UltiSnipsSnippetDirectories = ['~/workspace/dotfiles/vim/UltiSnips']

" indent-guides
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_guide_size = 1
let g:indent_guides_exclude_filetypes =  ['help', 'nerdtree', 'tagbar', 'text']

" ack
autocmd VimEnter * if g:os=='Windows' | let g:ackprg = 'ack -His --smart-case --column --nocolor --nogroup' | endif
let g:ack_apply_qmappings = 0
let g:ack_qhandler = 'botright cwindow'
let g:ackhighlight = 1

" qf
let g:qf_auto_resize = 0
let g:qf_mapping_ack_style = 1

" tagbar
let g:tagbar_autofocus = 1
let g:tagbar_sort = 0

" CtrlP
let g:ctrlp_by_filename = 1
let g:ctrlp_show_hidden = 1
let g:ctrlp_match_window = 'results:100'
if has('win32')
    let g:ctrlp_user_command = 'dir %s /-n /b /s /a-d | findstr /v /l ".git .xls .ppt .doc"'
else
    let g:ctrlp_user_command = 'find %s -type f | grep -v -e .git -e .o\$ -e .xls -e .ppt -e .doc'
endif

" ale
let g:ale_linters = {
            \'python': ['flake8'],
            \}
let g:ale_fixers = {
            \'*': ['remove_trailing_lines', 'trim_whitespace'],
            \'c': ['clang-format'],
            \'cpp': ['clang-format'],
            \'python': ['autopep8'],
            \'xml': ['xmllint'],
            \'cmake': ['cmakeformat'],
            \'json': ['jq']
            \}
let g:ale_xml_xmllint_options = '--format'
let g:ale_sign_error = '✘'
let g:ale_sign_warning = ''

" peekaboo
let g:peekaboo_window = 'vert botright 40new'

" devicon
let g:webdevicons_enable = 1
let g:WebDevIconsNerdTreeBeforeGlyphPadding = ' '
let g:WebDevIconsNerdTreeAfterGlyphPadding = (has("gui_running") ? '' : ' ')
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:DevIconsEnableFoldersOpenClose = 1
let g:WebDevIconsUnicodeDecorateFolderNodesDefaultSymbol = ''
let g:DevIconsDefaultFolderOpenSymbol = ''
let g:DevIconsEnableNERDTreeRedraw = 1

" nerdtree-syntax-highlight
let g:NERDTreeHighlightFolders = 1
let g:NERDTreeHighlightFoldersFullName = 1
let g:NERDTreeFileExtensionHighlightFullName = 1
let g:NERDTreeExactMatchHighlightFullName = 1
let g:NERDTreePatternMatchHighlightFullName = 1
" }}}
" ============================================================================
" OUTRO {{{
if g:os == "Darwin"
    colo dracula
    let g:airline_theme = 'dracula'
elseif g:os == "Linux"
    let ayucolor='mirage'
    colo ayu
    let g:airline_theme = 'ayu_mirage'
elseif has("win32")
    colo jellybeans
    let g:airline_theme = 'jellybeans'
elseif has("win32unix")
    colo iceberg
    let g:airline_theme = 'iceberg'
endif
" }}}
" ============================================================================
