let mapleader = ","

let g:vimtex_view_method = 'zathura'

set number relativenumber

syntax on
filetype plugin indent on

set wildmode=longest,list,full
set splitbelow splitright
set tabstop=4
set shiftwidth=4
set expandtab

map <leader>h :noh<CR>

map <leader>o :setlocal spell! spelllang=en_us<CR>

map <leader>n :NERDTreeToggle<CR>

noremap <Leader>y "*y
noremap <Leader>p "*p
noremap <Leader>Y "+y
noremap <Leader>P "+p

nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>



let g:vimspector_enable_mappings = 'HUMAN'
nnoremap <Leader>dd :call vimspector#Launch()<CR>

" Telescope binds
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
nnoremap <leader>fc <cmd>lua require('telescope.builtin').tags()<cr>

autocmd VimLeave \lc %
