vim.g.mapleader = " "
vim.g.maplocalleader = " "

--------------- LAZY ---------------

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

--------------- LAZY PLUGINS ---------------

require("lazy").setup({
	-- gruvbox
	{ "ellisonleao/gruvbox.nvim", priority = 1000, config = true, opts = ... },

	-- fzf
	{ "ibhagwan/fzf-lua", opts = {} },

	-- utils
	{ "tpope/vim-sleuth" },
	{ "sbdchd/neoformat" },
	{ "windwp/nvim-autopairs", event = "InsertEnter", config = true, opts = {} },

	-- kulala
	{ "mistweaverco/kulala.nvim", opts = { global_keymaps = true } },

	-- lsp, treesitter & blink.cmp
	{ "neovim/nvim-lspconfig", dependencies = { "saghen/blink.cmp" } },
	{ "nvim-treesitter/nvim-treesitter" },
	{ "saghen/blink.cmp", version = "1.*" },
})

--------------- PLUGINS CONFIG ---------------

-- gruvbox
vim.o.background = "dark"
vim.cmd([[colorscheme gruvbox]])

-- fzf
require("fzf-lua").setup({
	winopts = { height = 0.95, width = 0.95 },
	keymap = {
		builtin = { ["<C-d>"] = "preview-half-page-down", ["<C-u>"] = "preview-half-page-up" },
		fzf = { ["ctrl-d"] = "preview-half-page-down", ["ctrl-u"] = "preview-half-page-up" },
	},
})

-- treesitter
require("nvim-treesitter.configs").setup({
	ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },
	auto_install = true,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
})

-- blink.cmp
require("blink.cmp").setup({
	keymap = {
		preset = "enter",
		["<C-k>"] = { "select_prev", "fallback" },
		["<C-j>"] = { "select_next", "fallback" },
	},
	completion = {
		documentation = { auto_show = true },
		menu = { draw = { columns = { { "label", "source_name", "kind", gap = 1 } } } },
	},
	fuzzy = { implementation = "prefer_rust_with_warning" },
	cmdline = { completion = { menu = { auto_show = true } } },
})

-- lsp
vim.diagnostic.config({ virtual_text = true })
require("lspconfig")["cssls"].setup({})
require("lspconfig")["html"].setup({})
require("lspconfig")["ts_ls"].setup({})

--------------- KEYS ---------------

-- fzf
vim.keymap.set("n", "<leader>p", ":FzfLua files<CR>", { silent = true })
vim.keymap.set("n", "<leader>f", ":FzfLua live_grep<CR>", { silent = true })
vim.keymap.set("n", "<leader>g", ":FzfLua git_status<CR>", { silent = true })
vim.keymap.set("n", "<leader>h", ":FzfLua git_bcommits<CR>", { silent = true })

-- neoformat
vim.keymap.set("n", "<leader>i", ":Neoformat<CR>", { silent = true })

-- lsp
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "gi", vim.lsp.buf.implementation)
vim.keymap.set("n", "K", vim.diagnostic.open_float)

-- netrw
vim.keymap.set("n", "-", ":Ex<CR>", { silent = true })

--------------- SETS ---------------

vim.o.backup = false
vim.o.clipboard = "unnamedplus"
vim.o.expandtab = true
vim.o.ignorecase = true
vim.o.mouse = ""
vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = "yes"
vim.o.smartcase = true
vim.o.swapfile = false
vim.o.updatetime = 50
vim.o.wrap = false
vim.g.netrw_banner = false
