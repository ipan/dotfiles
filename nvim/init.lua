-- Neovim configuration managed by lazy.nvim.

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.termguicolors = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = "split"
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.completeopt = { "menu", "menuone", "noselect" }

vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })
vim.keymap.set("n", "<leader>y", '"+y', { desc = "Yank to clipboard" })
vim.keymap.set("v", "<leader>y", '"+y', { desc = "Yank to clipboard" })
vim.keymap.set("n", "<F5>", [[:let _s=@/ <Bar> %s/\s\+$//e <Bar> let @/=_s <Bar> nohl<CR>]], { silent = true })

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Modern replacements for the previous Vim-Plug plugins.
  { "folke/tokyonight.nvim", priority = 1000, opts = { style = "night" } },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = { options = { theme = "tokyonight" } },
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },
  {
    "stevearc/oil.nvim",
    keys = { { "<C-n>", "<cmd>Oil<cr>", desc = "Open file explorer" } },
    opts = { view_options = { show_hidden = true } },
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = function()
      local fd = vim.fn.executable("fd") == 1 and "fd" or "fdfind"
      return {
        pickers = {
          find_files = {
            find_command = { fd, "--type", "f", "--hidden", "--follow", "--exclude", ".git" },
          },
        },
      }
    end,
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Search text" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find buffers" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
      { "<leader>gf", "<cmd>Telescope git_files<cr>", desc = "Git files" },
      { "<leader>/", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Search buffer" },
      { "<leader>fd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
      { "<leader>fc", "<cmd>Telescope commands<cr>", desc = "Commands" },
      { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
    },
  },
  {
    "stevearc/aerial.nvim",
    cmd = "AerialToggle",
    keys = {
      { "<leader>rt", "<cmd>AerialToggle!<cr>", desc = "Toggle symbols" },
      { "<leader>ao", "<cmd>AerialToggle!<cr>", desc = "Toggle symbols" },
      { "[s", "<cmd>AerialPrev<cr>", desc = "Previous symbol" },
      { "]s", "<cmd>AerialNext<cr>", desc = "Next symbol" },
    },
    opts = {},
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
    },
  },
  { "tpope/vim-fugitive", cmd = { "Git", "G" } },
}, {
  change_detection = { notify = false },
  checker = { enabled = false },
})

vim.cmd.colorscheme("tokyonight-night")
