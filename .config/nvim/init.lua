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
vim.api.nvim_create_autocmd('FileType snippets', {
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
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.smarttab = true
vim.o.autowrite = true
vim.o.splitright = true
vim.o.timeout = false
vim.o.ttimeout = true
vim.o.scrolloff = 3
vim.o.signcolumn = 'yes'
vim.o.background = 'dark'
vim.o.showmatch = false
vim.o.mouse = 'a'

vim.g['airline#extensions#tabline#enabled'] = 1
vim.g.airline_powerline_fonts = 1

-- Write all on tmux switch
vim.g.tmux_navigator_save_on_switch = 2

vim.cmd([[

augroup sageFiletype
    autocmd!
    autocmd BufRead,BufNewFile *.sage set filetype=python
augroup END

augroup restoreCursorPos
    autocmd!
    autocmd BufReadPost *
      \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
      \ |   exe "normal! g`\""
      \ | endif
augroup END

" My own keymaps
augroup languageAutocmd
    autocmd!
    autocmd FileType cpp nnoremap <buffer> <leader>m <cmd>make! -j run<CR>
    autocmd FileType rust nnoremap <buffer> <leader>m <cmd>!cargo test<CR>
    autocmd FileType rust let b:AutoPairs = {'(':')', '[':']', '{':'}', '"':'"', '"""':'"""', "'''":"'''", "<":">"}
    autocmd FileType rust vmap <buffer> D S)idbg!<ESC>
augroup END
nnoremap <leader>nn <cmd>NvimTreeToggle<CR>
nnoremap <leader>vv <cmd>e $MYVIMRC<CR>
nnoremap <leader>vr <cmd>source $MYVIMRC<CR>
nnoremap <leader>vt :vsplit\|term<CR>A
nnoremap <leader>b <cmd>bp\|bd #<CR>
nnoremap <leader>h :tab help<SPACE>

]])
