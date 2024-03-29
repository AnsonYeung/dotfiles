require 'plugins'

local function lspSymbol(name, icon)
    vim.fn.sign_define(
        'DiagnosticSign' .. name,
        { texthl = 'DiagnosticSign' .. name, text = icon, numhl = 'Diagnostic' .. name }
    )
end

lspSymbol('Error', '')
lspSymbol('Warn', '')
lspSymbol('Hint', '')
lspSymbol('Info', '')

vim.o.completeopt = 'menu,menuone,noselect'
vim.g.mapleader = ' '

-- latex configuration
vim.g.tex_flavor = 'latex'
vim.g.tex_conceal = 'abdmg'

-- Altho it looks cool, it often messed up snippets
vim.g.vimtex_quickfix_mode = 0

local texGp = vim.api.nvim_create_augroup('tex-autocmd', { clear = true })

vim.api.nvim_create_autocmd('FileType', {
    pattern = 'tex',
    callback = function(autocmd)
        vim.o.spelllang = 'en_us'
        vim.wo.spell = true
        vim.wo.conceallevel = 2
        vim.api.nvim_buf_set_keymap(autocmd.buf, 'i', '<C-l>', '<C-g>u<ESC>[s1z=A<C-g>u', {})
        vim.b.airline_whitespace_disabled = 1
    end,
    group = texGp
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = 'snippets',
    command = 'hi snipLeadingSpaces None',
    group = texGp
})

-- General configuration
if vim.fn.exists('+termguicolors') then
    vim.o.termguicolors = true
end

vim.o.clipboard = 'unnamedplus'
vim.o.undofile = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.tabstop = 4
vim.o.softtabstop = 0
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.smarttab = true
vim.o.autowrite = true -- not autosave, save on :make or similar commands
vim.o.splitright = true
vim.o.timeout = false
-- vim.o.timeoutlen = 1000
vim.o.ttimeout = true
vim.o.scrolloff = 3
vim.o.signcolumn = 'yes:2'
vim.o.background = 'dark'
vim.o.showmatch = false
vim.o.mouse = 'a'
vim.o.nrformats = vim.o.nrformats .. ',alpha'

vim.keymap.set('n', '<leader>nn', '<cmd>NvimTreeToggle<CR>', {})
vim.keymap.set('n', '<leader>vv', '<cmd>e $MYVIMRC<CR>', {})
vim.keymap.set('n', '<leader>vr', '<cmd>source $MYVIMRC<CR>', {})
vim.keymap.set('n', '<leader>vt', ':vsplit|term<CR>A', {})
vim.keymap.set('n', '<leader>b', '<cmd>bp|bd #<CR>', {})
vim.keymap.set('n', '<leader>h', ':Help ')
vim.keymap.set('n', '<leader>tf', function()
    local fmt = require('lsp-format')
    fmt.disabled = not fmt.disabled
end)
vim.api.nvim_create_user_command('Help', 'enew | set buftype=help | help <args>', { nargs = 1, complete = 'help' })

vim.g['airline#extensions#tabline#enabled'] = 1
vim.g.airline_powerline_fonts = 1

-- Write all on tmux switch
vim.g.tmux_navigator_save_on_switch = 2

-- Misc language config
local miscGp = vim.api.nvim_create_augroup('misc-autocmd', { clear = true })

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = '*.sage',
    callback = function(_)
        vim.bo.filetype = 'python'
    end,
    group = miscGp
})

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = '*.tpp',
    callback = function(_)
        vim.bo.filetype = 'cpp'
    end,
    group = miscGp
})

vim.api.nvim_create_autocmd('BufReadPost', {
    command = [[
        if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
           exe "normal! g`\""
        endif
    ]],
    group = miscGp
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = 'cpp',
    callback = function(autocmd)
        vim.keymap.set('n', '<leader>m', '<cmd>make! -j run<CR>', { buffer = autocmd.buf })
    end,
    group = miscGp
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = 'rust',
    callback = function(autocmd)
        vim.keymap.set('n', '<leader>m', '<cmd>!cargo test<CR>', { buffer = autocmd.buf })
        vim.keymap.set('v', 'D', 'S)idbg!<ESC>', { buffer = autocmd.buf, remap = true })
    end,
    group = miscGp
})
