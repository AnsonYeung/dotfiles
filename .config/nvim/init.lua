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

vim.g.tex_flavor = 'latex'
vim.g.tex_conceal = 'abdmg'

if vim.env.WSL_INTEROP then
    vim.g.vimtex_view_general_viewer = 'sumatra'
    vim.g.vimtex_view_general_options = '-reuse-instance -forward-search @tex @line `wslpath -w @pdf`'
end

-- Altho it looks cool, it often messed up snippets
vim.g.vimtex_quickfix_mode = 0

vim.o.spelllang = 'en_us'

vim.cmd([[

augroup texAutocmd
    autocmd!
    autocmd FileType tex setlocal spell
    autocmd FileType tex setlocal conceallevel=2
    autocmd FileType tex inoremap <buffer> <C-l> <C-g>u<ESC>[s1z=A<C-g>u
    autocmd FileType tex let b:AutoPairs = {}
    autocmd FileType tex autocmd TextChanged,InsertLeave <buffer> if &readonly == 0 | silent write | endif
    autocmd FileType tex nnoremap <buffer> <leader>le <cmd>e ~/.config/nvim/UltiSnips/tex.snippets<CR>
    autocmd FileType tex let b:airline_whitespace_disabled = 1
    autocmd FileType snippets hi snipLeadingSpaces None
augroup END

set clipboard=unnamedplus
if exists('+termguicolors')
    set termguicolors
endif

set undofile
set number relativenumber
set tabstop=4
set softtabstop=0
set expandtab
set shiftwidth=4
set smarttab
set autowrite
set splitright
set notimeout ttimeout
set scrolloff=3
set signcolumn=yes

let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

" write all on tmux switch
let g:tmux_navigator_save_on_switch = 2

set background=dark
set noshowmatch

set mouse=a
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
let mapleader=" "
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
