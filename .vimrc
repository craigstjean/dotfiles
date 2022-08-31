call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-sensible'
Plug 'junegunn/vim-easy-align'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'crusoexia/vim-monokai'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
let g:airline_theme='deus'

Plug 'SirVer/ultisnips'
let g:UltiSnipsExpandTrigger="<c-s>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

Plug 'jlanzarotta/bufexplorer'

call plug#end()

syntax on
colorscheme monokai
" set t_Co=256
set t_ti= t_te=

" Spaces not tabs!
set shiftwidth=4
set tabstop=4
set expandtab

" Close vim if NERDTree is the only buffer open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

map <F4> :NERDTreeToggle<CR>

" Switch between buffers with C-N and C-P
set hidden
nnoremap <C-N> :bnext<CR>
nnoremap <C-P> :bprev<CR>
nnoremap <leader>m <C-^>

" Remap leader
let mapleader=","
map <leader>b :BufExplorer<CR>

" Enable mouse
set mouse=a

" Search how I want to
set incsearch
set hlsearch
function! MapCR()
    nnoremap <CR> :nohlsearch<CR>
endfunction
call MapCR()

autocmd! CmdwinEnter * :unmap <cr>
autocmd! CmdwinLeave * :call MapCR()

" Don't make backups at all
set nobackup
set nowritebackup

