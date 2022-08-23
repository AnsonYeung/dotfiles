require 'plugins'

local function lspSymbol(name, icon)
    vim.fn.sign_define(
        'DiagnosticSign' .. name,
        { texthl = 'DiagnosticSign' .. name, text = icon, numhl = 'Diagnostic' .. name }
    )
end

lspSymbol('Error', '')
lspSymbol('Warning', '')
lspSymbol('Hint', '')
lspSymbol('Info', '')

vim.o.completeopt = 'menu,menuone,noselect'
vim.g.mapleader = ' '

-- latex configuration
vim.g.tex_flavor = 'latex'
vim.g.tex_conceal = 'abdmg'

if vim.env.WSL_INTEROP then
    vim.g.vimtex_view_general_viewer = 'sumatra'
    vim.g.vimtex_view_general_options = '-reuse-instance -forward-search @tex @line `wslpath -w @pdf`'
end

-- Altho it looks cool, it often messed up snippets
vim.g.vimtex_quickfix_mode = 0

vim.o.spelllang = 'en_us'

local texGp = vim.api.nvim_create_augroup('tex-autocmd', { clear = true })

vim.api.nvim_create_autocmd('FileType', {
    pattern = 'tex',
    callback = function(autocmd)
        vim.wo.spell = true
        vim.wo.conceallevel = 2
        vim.api.nvim_buf_set_keymap(autocmd.buf, 'i', '<C-l>', '<C-g>u<ESC>[s1z=A<C-g>u', {})
        vim.api.nvim_buf_set_keymap(autocmd.buf, 'n', '<leader>le', '<cmd>e ~/.config/nvim/UltiSnips/tex.snippets<CR>',
            {})
        if not vim.bo.readonly then
            vim.api.nvim_create_autocmd({ 'TextChanged', 'InsertLeave' }, {
                callback = function()
                    vim.cmd("silent! write")
                end
            })
        end
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
vim.o.ttimeout = true
vim.o.scrolloff = 3
vim.o.signcolumn = 'yes'
vim.o.background = 'dark'
vim.o.showmatch = false
vim.o.mouse = 'a'

vim.keymap.set('n', '<leader>nn', '<cmd>NvimTreeToggle<CR>', {})
vim.keymap.set('n', '<leader>vv', '<cmd>e $MYVIMRC<CR>', {})
vim.keymap.set('n', '<leader>vr', '<cmd>source $MYVIMRC<CR>', {})
vim.keymap.set('n', '<leader>vt', ':vsplit|term<CR>A', {})
vim.keymap.set('n', '<leader>b', '<cmd>bp|bd #<CR>', {})
vim.keymap.set('n', '<leader>h', ':tab help ', {})

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
