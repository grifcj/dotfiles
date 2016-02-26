" This vimrc was created using Doug Black's as a starting point.

" Use Vim settings only, i.e not 'Vi' compatible. Needs to be first as it
" changes the way following settings are interpreted.
set nocompatible

filetype plugin on   " Turns on filetype detection and enables file-type specific plugin

" Colors {{{

set t_Co=256
syntax on
colorscheme desert

" Mark column 110 to guide line sizing
set colorcolumn=110
highlight ColorColumn ctermbg=darkgrey

" }}}
" Whitespace / Indentation {{{

set tabstop=3        " Tab is equivalent to 3 spaces
set expandtab        " Always expand tabs to spaces
set softtabstop=3    " Use 3 spaces when pressing tab in insert mode
set shiftwidth=3     " Shifting/indenting text inserts 3 spaces

set listchars=tab:>-,eol:<

filetype indent on   " Use filetype specific indentation
set autoindent       " Copy indent from current line when creating new line

" }}}
" UI Config {{{

set ttyfast          " Speed redrawing by transferring more characters to redraw
set lazyredraw       " Don't auto redraw screen when executing macros, improves performance
set number           " Show line numbers
set relativenumber   " Always show line numbers as relative
set showcmd          " Show command as typed in status bar
set hidden           " No error/warnings when navigating away from edited file
set splitbelow       " Split below by default
set autowrite        " Save all buffers when commands like 'make' called

set statusline="%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P"

set noswapfile       " No swap files, we have version control for pete's sake

" For GVim
set guioptions-=T    " No toolbar
set guioptions-=r    " No scrollbar

" When opening vimdiff always split vertical and show filler lines
" for missing text
set diffopt=vertical,filler

" }}}
" Editing {{{

set backspace=indent,eol,start
set fileformat=unix
set fileformats=unix,dos

" }}}
" Searching, Wildmode {{{

set smartcase
set ignorecase
set hlsearch
set incsearch

set wildmenu      " Use wildmenu for tab completion
set wildmode=longest:full
set wildignore=*.o,*.bak,*.swp,*~
set wildignorecase

" Use Ag for grep
if executable('ag')
   set grepprg=ag\ --nogroup\ --nocolor
endif

" Use gnome-open to handle url's
let g:netrw_browsex_viewer= "gnome-open"

" }}}
" Folding {{{

" Ensure that modeline at bottom of file will enable folding in vimrc if
" it is opened later for editing
set modelines=2

set foldenable             " Use folding
set foldmethod=syntax      " Use language syntax for folding
set foldlevelstart=10      " Don't fold anything when opening file
set foldnestmax=10         " Don't fold anything when opening file

" }}}
" AutoGroups {{{
  " Put these in an autocmd group, so that we can delete them easily.
  augroup configgroup
  autocmd!

     " Always strip trailing whitespace when editing a file
     autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

     " When editing a file, always jump to the last known cursor position.
     " Don't do it when the position is invalid or when inside an event handler
     " (happens when dropping a file on gvim).
     " Also don't do it when the mark is in the first line, that is the default
     " position when opening a file.
     autocmd BufReadPost *
       \ if line("'\"") > 1 && line("'\"") <= line("$") |
       \   exe "normal! g`\"" |
       \ endif

     " " Can't say I edit a lot of modula2. Force markdown for *.md files
     autocmd BufNewFile,BufReadPost *.md set filetype=markdown
     autocmd FileType markdown setlocal sw=4 ts=4 sts=4

  augroup END
" }}}
" Custom Functions {{{

" Strips trailing whitespace at the end of files. This
" is called on buffer write in the autogroup above.
function! <SID>StripTrailingWhitespaces()
    " save last search & cursor position
    let _s=@/
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    let @/=_s
    call cursor(l, c)
endfunction

" }}}
" Vundle {{{
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
if has('win32')
   set rtp+=$VIM/vimfiles/bundle/Vundle.vim
   call vundle#begin('$VIM/vimfiles/bundle/')
else
   set rtp+=~/.vim/bundle/Vundle.vim
   call vundle#begin()
endif

" Let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" Plugins
Plugin 'airblade/vim-gitgutter'
Plugin 'bling/vim-airline'
Plugin 'bronson/vim-visual-star-search'
Plugin 'derekwyatt/vim-fswitch'
Plugin 'drmikehenry/vim-headerguard'
Plugin 'godlygeek/tabular'
Plugin 'henrik/vim-qargs'
Plugin 'honza/vim-snippets'
Plugin 'kien/ctrlp.vim'
Plugin 'majutsushi/tagbar'
Plugin 'rdnetto/YCM-Generator'
Plugin 'rking/ag.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'shime/vim-livedown'
Plugin 'SirVer/ultisnips'
Plugin 'sjl/gundo.vim'
Plugin 'tommcdo/vim-exchange'
Plugin 'tomtom/tcomment_vim'
Plugin 'ton/vim-bufsurf'
Plugin 'tpope/vim-abolish'
Plugin 'tpope/vim-dispatch'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-markdown'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-unimpaired'
Plugin 'Valloric/YouCompleteMe'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

"-------------------------------------------------------------------------------
" Airline
" Always show status line otherwise won't show up until split
"-------------------------------------------------------------------------------

set laststatus=2

"-------------------------------------------------------------------------------
" YouCompleteMe
" Set default config AND don't require prompt for configuration
"-------------------------------------------------------------------------------

if has('win32')
   let g:ycm_global_ycm_extra_conf = '$VIM/vimfiles/bundle/YouCompleteMe/.ycm_extra_conf.py'
else
   let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/.ycm_extra_conf.py'
endif
let g:ycm_confirm_extra_conf = 0

"-------------------------------------------------------------------------------
" Use Ag for search and CtrlP
"-------------------------------------------------------------------------------

if executable('ag')
   let g:ctrlp_user_command = 'ag -i --nocolor --nogroup --hidden -g "" %s'
   let g:ctrlp_working_path_mode = 0
endif

"-------------------------------------------------------------------------------
" This is best way to prevent ultisnips from interfering with ycm
"-------------------------------------------------------------------------------

let g:UltiSnipsExpandTrigger = '<C-l>'

"-------------------------------------------------------------------------------
" Define functions for header include guards
"-------------------------------------------------------------------------------

" Use python for random number generation
function! <SID>RandomNumber(digits)

python << EOF
import random, vim
powStart = vim.bindeval('a:digits')
powEnd = powStart+1;
vim.command("let number = '%s'" %
         \ random.randrange(10**powStart,10**powEnd))
EOF

   return number
endfunction

" Header name defined to be filename, with incompatible characters
" converted to underscores and appended with 10-digit random number
function! g:HeaderguardName()
   let g:headerGuardName = toupper(expand('%:t:gs/[^0-9a-zA-Z_]/_/'))
            \ . '_' . <SID>RandomNumber(10)
   return g:headerGuardName
endfunction

function! g:HeaderguardLine1()
   return "#ifndef " . g:headerGuardName
endfunction

function! g:HeaderguardLine2()
   return "#define " . g:headerGuardName
endfunction

function! g:HeaderguardLine3()
   return "#endif"
endfunction

"-------------------------------------------------------------------------------
" Livedown preview
"-------------------------------------------------------------------------------
nnoremap <leader>lp :LivedownPreview<CR>

" }}}
" Custom Mappings {{{

" Map window movement
nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-l> <C-w><C-l>
nnoremap <C-h> <C-w><C-h>

" Treat wrapped lines the same as regular lines for various movements
noremap j gj
noremap k gk
noremap $ g$
noremap ^ g^

" Resize windows
nnoremap <leader>wi :vertical resize +20<CR>
nnoremap <leader>wd :vertical resize -20<CR>
nnoremap <leader>hi :resize +20<CR>
nnoremap <leader>hd :resize -20<CR>

" Sort
vnoremap <leader>s :sort i<CR>

" Remap space to fold/unfold section
nnoremap <space> za

" History sensitive buffer jumping
nnoremap <leader><C-o>  :BufSurfBack<CR>
nnoremap <leader><C-i>  :BufSurfForward<CR>

" Mappings for vim-fugitive
nnoremap <leader>gs :Gstatus<CR><C-w>K<CR>
nnoremap <leader>gl :Git! loggraph<CR>
nnoremap <leader>gdi :Gdiff :<CR>
nnoremap <leader>gdh :Gdiff HEAD<CR>
nnoremap <leader>* :let @/=expand("<cword>")<CR>
         \:execute 'silent Ggrep!' . shellescape(@/)<CR>
         \:copen<CR><C-w>J<C-w><C-p>
vnoremap <leader>* :<C-u>call VisualStarSearchSet('/', 'raw')<CR>
         \:execute 'silent Ggrep!' . shellescape(@/)<CR>
         \:copen<CR><C-w>J<C-w><C-p>

" Open/close quickfix
nnoremap <leader>qo :copen<CR>
nnoremap <leader>qc :cclose<CR>

" File switch
nnoremap <leader>fs :FSHere<CR>

" Open ctrlp
let g:ctrlp_map = '<leader>fo'

" Tagbar toggle for viewing organized tag list of current buffer
nnoremap <leader>tj :TagbarOpen fj<CR>
nnoremap <leader>tb :TagbarToggle<CR>
nnoremap <leader>tp :TagbarTogglePause<CR>

" Buffer surfing to jump between window buffers
nnoremap <leader><C-o> :BufSurfBack<CR>
nnoremap <leader><C-i> :BufSurfForward<CR>

" Gundo toggle
nnoremap <leader>gt :GundoToggle<CR>

" Visual ag start search
nnoremap <leader>a* :call ag#Ag('grep', '--literal ' . shellescape(expand("<cword>")))<CR>
vnoremap <leader>a* :<C-u>call VisualStarSearchSet('/', 'raw')<CR>:call ag#Ag('grep', '--literal ' . shellescape(@/))<CR>

" }}}

" Allow loading 'project' specific settings from working directory config
" files
set exrc

" vim: tabstop=3 softtabstop=3 shiftwidth=3 expandtab :
" vim: foldmethod=marker foldmarker={{{,}}} foldmethod=marker foldlevel=0 :
