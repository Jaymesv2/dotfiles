let mapleader = ","

let g:vimtex_view_method = 'zathura'

set number relativenumber

syntax on
filetype plugin indent on
map <leader>o :setlocal spell! spelllang=en_us<CR>

set wildmode=longest,list,full
set splitbelow splitright

map <leader>n :NERDTreeToggle<CR>

noremap <Leader>y "*y
noremap <Leader>p "*p
noremap <Leader>Y "+y
noremap <Leader>P "+p

nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>



set tabstop=4
set shiftwidth=4
set expandtab

let g:vimspector_enable_mappings = 'HUMAN'
nnoremap <Leader>dd :call vimspector#Launch()<CR>

autocmd VimLeave \lc %
