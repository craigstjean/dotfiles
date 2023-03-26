vim.cmd.packadd('packer.nvim')

return require('packer').startup(function(use)
	use 'wbthomason/packer.nvim'

	use {
		'nvim-telescope/telescope.nvim', tag = '0.1.1',
		requires = { { 'nvim-lua/plenary.nvim' } }
	}

	use({
		'rose-pine/neovim',
		as = 'rose-pine',
		config = function()
			vim.cmd('colorscheme rose-pine')
		end
	})

	use({
		'folke/trouble.nvim',
		config = function()
			require('trouble').setup {
				icons = false
			}
		end
	})

	use({'nvim-treesitter/nvim-treesitter', run = ":TSUpdate"})
	use('nvim-treesitter/playground')
	use('theprimeagen/harpoon')
	use('theprimeagen/refactoring.nvim')
	use('mbbill/undotree')
	use('tpope/vim-fugitive')
	use('nvim-treesitter/nvim-treesitter-context')

	use {
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v1.x',
		requires = {
			{'neovim/nvim-lspconfig'},

			{'hrsh7th/nvim-cmp'},
			{'hrsh7th/cmp-buffer'},
			{'hrsh7th/cmp-path'},
			{'saadparwaiz1/cmp_luasnip'},
			{'hrsh7th/cmp-nvim-lsp'},
			{'hrsh7th/cmp-nvim-lua'},

			{'L3MON4D3/LuaSnip'},
			{'rafamadriz/friendly-snippets'},
		}
	}

	use('folke/zen-mode.nvim')
	use('github/copilot.vim')
	use('laytan/cloak.nvim')
end)

