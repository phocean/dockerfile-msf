filetype plugin indent on
syntax on

if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
endif

"set laststatus=2                    " Always show status line
"set statusline=%f\                  " Show filename
"set statusline+=%h%w%m%r\           " Show flags
"set statusline+=%=                  " Align right
"set statusline+=%(%l,%c%V\ %=\ %P%) " Show ruler

set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
"set mouse=a

set undofile                 "turn on the feature  
set undodir=$HOME/.vim/undo  "directory where the undo files will be stored
set noswapfile

call plug#begin('~/.vim/plugged')
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'nordtheme/vim'
call plug#end()

if !exists('g:airline_symbols')
	  let g:airline_symbols = {}
endif

let g:airline_theme='minimalist'
" powerline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = '☰ '
let g:airline_symbols.maxlinenr = ' '
let g:airline_symbols.dirty='⚡'
" remove the filetype part
let g:airline_section_x=''
let g:airline_section_warning=''
" " remove separators for empty sections
let g:airline_skip_empty_sections = 1
au User AirlineAfterInit  :let g:airline_section_z = airline#section#create(['%l:%L'])

let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

" reset the cursor on start (for older versions of vim, usually not required)
augroup myCmds
au!
autocmd VimEnter * silent !echo -ne "\e[2 q"
augroup END
