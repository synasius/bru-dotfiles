" vim:foldmethod=marker:foldlevel=0

" vim-plug {{{
call plug#begin()

" color scheme
Plug 'mhartington/oceanic-next'
Plug 'haishanh/night-owl.vim'

" syntax highlighting
Plug 'rhysd/vim-clang-format'
Plug 'fedorenchik/qt-support.vim'
Plug 'sheerun/vim-polyglot'

" python
Plug 'psf/black', { 'tag': '19.10b0' }  " the tag is needed until https://github.com/psf/black/issues/1293is solved

" auto complete
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'autozimu/LanguageClient-neovim', {
            \ 'branch': 'next',
            \ 'do': 'bash install.sh',
            \ }
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" navigation/search file
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" editing
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-surround'
Plug 'godlygeek/tabular'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-abolish'
Plug 'easymotion/vim-easymotion'
Plug 'machakann/vim-highlightedyank'

" better statusline
Plug 'itchyny/lightline.vim'
Plug 'mengelbrecht/lightline-bufferline'
"Plug 'vim-airline/vim-airline'
"Plug 'vim-airline/vim-airline-themes'

" git management plugin
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" tmux
Plug 'christoomey/vim-tmux-navigator'

" icons
Plug 'ryanoasis/vim-devicons'

function! BuildComposer(info)
    if a:info.status != 'unchanged' || a:info.force
        !cargo build --release
    endif
endfunction

Plug 'euclio/vim-markdown-composer', { 'do': function('BuildComposer') }

call plug#end()
" }}} vim-plug

" Neovim {{{
"let g:python_host_prog = '/usr/bin/python2'
let g:python3_host_prog = '/home/sinasio/.vim/neovim/bin/python'
" }}}

" Completion {{{
set completeopt-=preview
set completeopt+=menuone,noselect,noinsert
set shortmess+=c
set belloff+=ctrlg

" To enable logging on the  python language server:
" 'python': ['pyls', '-vv', '--log-file', '~/.pyls.log'],
let g:LanguageClient_serverCommands = {
            \ 'cpp': ['/usr/bin/clangd'],
            \ 'python': ['pyls', '-vvvv', '--log-file', '~/.pyls.log'],
            \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
            \ 'typescript': ['typescript-language-server', '--stdio'],
            \ 'javascript': ['javascript-typescript-stdio'],
            \ 'javascript.jsx': ['javascript-typescript-stdio'],
            \ }
let g:LanguageClient_loggingFile = expand('~/.LanguageClient.log')

let g:deoplete#enable_at_startup = 1

inoremap <silent><expr> <TAB>
        \ pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ deoplete#manual_complete()
inoremap <silent><expr> <C-Space> deoplete#manual_complete()

inoremap <silent><expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"

function! s:check_back_space() abort "{{{
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction"}}}
" }}}

" Colors {{{
set termguicolors
syntax enable
colorscheme night-owl
" }}} Colors

" Spaces & Tabs {{{
set tabstop=4       " number of visual spaces per TAB
set softtabstop=4   " number of spaces in tab when editing
set shiftwidth=4    " number of spaces to use for autoindent
set expandtab       " tabs are space
set autoindent
set copyindent      " copy indent from the previous line
" }}} Spaces & Tabs

" Clipboard {{{
set clipboard+=unnamedplus
" }}} Clipboard

" UI Config {{{
set noshowmode
set hidden
set lcs=trail:·,tab:»·
set list
set number                   " show line number
set showcmd                  " show command in bottom bar
set cursorline               " highlight current line
set wildmenu                 " visual autocomplete for command menu
set showmatch                " highlight matching brace
set laststatus=2             " window will always have a status line
set showtabline=2
set nobackup
set noswapfile
set mouse=a
let &colorcolumn="".join(range(90,999),",")

set guifont=SauceCodePro\ Nerd\ Font\ 13
" }}} UI Config

" Search {{{
set incsearch       " search as characters are entered
set hlsearch        " highlight matche
set ignorecase      " ignore case when searching
set smartcase       " ignore case if search pattern is lower case
" case-sensitive otherwise

" set ripgrep as the grep command
if executable('rg')
    set grepprg=rg\ --vimgrep
endif

" }}} Search

" Folding {{{
set foldenable
set foldlevelstart=10  " default folding level when buffer is opened
set foldnestmax=10     " maximum nested fold
set foldmethod=syntax  " fold based on indentation
" }}} Folding

" Leader & Mappings {{{
let mapleader=","   " leader is comma

" edit/reload vimrc
nmap <leader>ev :e $MYVIMRC<CR>
nmap <leader>sv :so $MYVIMRC<CR>

" better ESC
inoremap jj <esc>

" fast save and close
nmap <leader>w :w<CR>
nmap <leader>x :x<CR>
nmap <leader>q :q<CR>

" insert blank line before current line without leaving insert mode
imap <leader>o <c-o><s-o>

" move up/down consider wrapped lines
nnoremap j gj
nnoremap k gk

" fix indentation
nnoremap <leader>i mzgg=G`z<CR>

" turn off search highlights
nnoremap <leader><space> :nohlsearch<CR>

" move through grep results
nmap <silent> <right> :cnext<CR>
nmap <silent> <left> :cprev<CR>

" buffers
nnoremap <tab> :bn<CR>
nnoremap <s-tab> :bp<CR>
nnoremap <leader>bd :bd<CR>

" fast header source switch
map <F4> :e %:p:s,.h$,.X123X,:s,.cpp$,.h,:s,.X123X$,.cpp,<CR>

" fzf
nnoremap <c-p> :FZF<CR>

" NERDTree mappings
map <C-n> :NERDTreeToggle<CR>

" map to <Leader>cf in C++ code
autocmd FileType c,cpp,objc nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
autocmd FileType c,cpp,objc vnoremap <buffer><Leader>cf :ClangFormat<CR>

" LanguageClient mappings
nnoremap <silent> <leader>m :call LanguageClient_contextMenu()<CR>
nnoremap <silent> <leader>g :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> <leader>r :call LanguageClient#textDocument_rename()<CR>
nnoremap <silent> <leader>h :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> <leader>ls :call LanguageClient#textDocument_documentSymbol()<CR>

" }}}

" FZF {{{
let g:fzf_history_dir = '~/.local/share/fzf-history'
" }}}

" NERDTree {{{
let NERDTreeShowHidden=1
let NERDTreeIgnore = ['\.pyc$', '__pycache__']

let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:WebDevIconsNerdTreeAfterGlyphPadding = ' '
" }}}

" Cpp Enhanced Highlighting {{{
let g:cpp_class_scope_highlight = 1
" }}}

" Airline && Lightline {{{
let g:lightline = {
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
    \             [ 'fugitive', 'readonly', 'filename', 'modified' ] ]
    \ },
    \ 'colorscheme': 'nightowl',
    \ 'component': {
    \   'lineinfo': ' %3l:%-2v',
    \ },
    \ 'component_function': {
    \   'readonly': 'LightlineReadonly',
    \   'fugitive': 'LightlineFugitive'
    \ },
    \ 'component_expand': {'buffers': 'lightline#bufferline#buffers'},
    \ 'component_type': {'buffers': 'tabsel'},
    \ 'tabline': {
    \   'left': [ [ 'buffers' ] ],
    \   'right': [ [ ] ],
    \ },
    \ }

function! LightlineReadonly()
    return &readonly ? '' : ''
endfunction

function! LightlineFugitive()
    if exists('*FugitiveHead')
        let branch = FugitiveHead()
        return branch !=# '' ? ''.branch : ''
    endif
    return ''
endfunction


let g:airline_theme = 'oceanicnext'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
" }}}

" Prettier {{{
let g:prettier#config#single_quote = 'false'
let g:prettier#config#bracket_spacing = 'true'
let g:prettier#config#jsx_bracket_same_line = 'false'
let g:prettier#config#arrow_parens = 'avoid'
let g:prettier#config#trailing_comma = 'none'
let g:prettier#config#parser = 'babylon'
" }}}

" UltiSnips {{{
let g:UltiSnipsExpandTrigger       = "<c-j>"
let g:UltiSnipsJumpForwardTrigger  = "<c-b>"
let g:UltiSnipsJumpBackwardTrigger = "<c-p>"
let g:UltiSnipsListSnippets        = "<c-k>" "List possible snippets based on current file
" }}}

" Functions and autos {{{
" trailing whitespace
match ErrorMsg '\s\+$'
function! TrimWhiteSpace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfunction

augroup stuff
    autocmd!
    autocmd BufWritePre * :call TrimWhiteSpace()
    autocmd BufWritePre *.py execute ':Black'
    autocmd BufRead,BufNewFile *.scss set filetype=scss.css
augroup END

" }}}
