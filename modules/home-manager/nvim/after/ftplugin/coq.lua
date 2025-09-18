
vim.keymap.set('n', '<localeader>j', ':CoqNext<CR>', { desc = "Coq Next" } )
vim.keymap.set('n', '<C-n>', ':CoqNext<CR>', { desc = "Coq Next" } )

vim.keymap.set({'n', 'i'}, '<C-Down>', '<Plug>CoqNext', { desc = "" } )
vim.keymap.set({'n', 'i'}, '<C-Left>', '<Plug>CoqToLine', { desc = "" } )
vim.keymap.set({'n', 'i'}, '<C-Up>', '<Plug>CoqUndo', { desc = "" } )
  -- imap <buffer> <S-Down> <Plug>CoqNext
  -- imap <buffer> <S-Left> <Plug>CoqToLine
  -- imap <buffer> <S-Up> <Plug>CoqUndo
  -- nmap <buffer> <S-Down> <Plug>CoqNext
  -- nmap <buffer> <S-Left> <Plug>CoqToLine
  -- nmap <buffer> <S-Up> <Plug>CoqUndo
