vim.keymap.set('n', '<leader>xq', '<cmd>TroubleToggle quickfix<CR>',
    { silent = true, noremap = true })

require('trouble').setup {
	icons = false
}

