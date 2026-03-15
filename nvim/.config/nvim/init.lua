-- =============================================================================
-- ~/.config/nvim/init.lua
-- Neovim configuration — structured for growth, not complexity
--
-- STRUCTURE:
--   Options   — sane defaults, line numbers, indentation, etc.
--   Keymaps   — essential remaps only, no plugin keymaps yet
--   lazy.nvim — plugin manager bootstrapped, zero plugins loaded
--               add plugins in the plugins table when ready
--               see 10.neovim.md for first plugins to add
-- =============================================================================


-- =============================================================================
-- OPTIONS
-- =============================================================================

local opt = vim.opt

-- Line numbers
opt.number         = true   -- absolute line number on current line
opt.relativenumber = true   -- relative numbers on all other lines
                            -- together: hybrid mode — best of both

-- Indentation
opt.tabstop        = 4      -- a Tab character displays as 4 spaces
opt.shiftwidth     = 4      -- >> and << shift by 4 spaces
opt.expandtab      = true   -- insert spaces instead of tab characters
opt.smartindent    = true   -- auto-indent new lines based on context

-- Search
opt.ignorecase     = true   -- case-insensitive search by default
opt.smartcase      = true   -- override: case-sensitive if query has uppercase
opt.hlsearch       = false  -- don't keep all matches highlighted after search
opt.incsearch      = true   -- show matches as you type

-- Appearance
opt.termguicolors  = true   -- enable 24-bit RGB colour (required by most themes)
opt.signcolumn     = "yes"  -- always show the sign column (prevents layout jump)
opt.cursorline     = true   -- highlight the line the cursor is on
opt.scrolloff      = 8      -- always keep 8 lines visible above/below cursor
opt.wrap           = false  -- don't wrap long lines — scroll horizontally

-- Splits
opt.splitright     = true   -- vertical splits open to the right
opt.splitbelow     = true   -- horizontal splits open below

-- Behaviour
opt.clipboard      = "unnamedplus"  -- sync with system clipboard
opt.undofile       = true           -- persist undo history across sessions
opt.swapfile       = false          -- no swap files (undo history is enough)
opt.updatetime     = 250            -- ms before CursorHold fires (faster diagnostics)
opt.timeoutlen     = 300            -- ms to wait for a key sequence to complete

-- File encoding
opt.encoding       = "utf-8"
opt.fileencoding   = "utf-8"

-- =============================================================================
-- KEYMAPS
-- =============================================================================

local map = vim.keymap.set

-- Leader key — space bar. Must be set before any plugin keymaps.
vim.g.mapleader      = " "
vim.g.maplocalleader = " "

-- Better escape
map("i", "jk", "<Esc>", { desc = "Exit insert mode" })

-- Move between windows with CTRL + hjkl (no need for CTRL+W prefix)
map("n", "<C-h>", "<C-w>h", { desc = "Focus left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Focus window below" })
map("n", "<C-k>", "<C-w>k", { desc = "Focus window above" })
map("n", "<C-l>", "<C-w>l", { desc = "Focus right window" })

-- Move selected lines up/down in visual mode
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Keep cursor centred when jumping
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down, keep cursor centred" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up, keep cursor centred" })
map("n", "n",     "nzzzv",   { desc = "Next search result, keep centred" })
map("n", "N",     "Nzzzv",   { desc = "Prev search result, keep centred" })

-- Paste over selection without losing the register
map("v", "p", '"_dP', { desc = "Paste without overwriting register" })

-- Clear search highlight
map("n", "<leader>h", ":nohlsearch<CR>", { desc = "Clear search highlight" })

-- Save and quit shortcuts
map("n", "<leader>w", ":w<CR>",  { desc = "Write (save)" })
map("n", "<leader>q", ":q<CR>",  { desc = "Quit" })
map("n", "<leader>Q", ":qa<CR>", { desc = "Quit all" })

-- Split windows
map("n", "<leader>v", ":vsplit<CR>", { desc = "Vertical split" })
map("n", "<leader>s", ":split<CR>",  { desc = "Horizontal split" })

-- =============================================================================
-- LAZY.NVIM — Plugin Manager
-- =============================================================================
-- lazy.nvim is bootstrapped automatically on first launch.
-- If ~/.local/share/nvim/lazy/lazy.nvim does not exist, it will be cloned.
-- No internet connection = no plugins. Everything else above still works.

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end

vim.opt.rtp:prepend(lazypath)

-- Plugin list — empty for now. Add entries here when ready.
-- See 10.neovim.md for first plugins to add.
--
-- Example structure (do not uncomment until you want it):
--
-- require("lazy").setup({
--     { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
--     { "neovim/nvim-lspconfig" },
--     { "ibhagwan/fzf-lua" },
-- })

require("lazy").setup({
    -- empty — neovim runs clean until you add plugins here
})
