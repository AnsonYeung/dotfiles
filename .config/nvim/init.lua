require("plugins")

vim.cmd([[

set completeopt=menu,menuone,noselect

" Trigger configuration. You need to change this to something other than <tab> if you use one of the following:
" - https://github.com/Valloric/YouCompleteMe
" - https://github.com/nvim-lua/completion-nvim
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

" If you want :UltiSnipsEdit to split your window.
" let g:UltiSnipsEditSplit="vertical"

let g:tex_flavor='latex'
let g:tex_conceal='abdmg'

if !empty($WSL_INTEROP)
    let g:vimtex_view_general_viewer = 'sumatra'
    let g:vimtex_view_general_options = '-reuse-instance -forward-search @tex @line `wslpath -w @pdf`'
endif

" Altho it looks cool, it often messed up snippets
let g:vimtex_quickfix_mode=0

set spelllang=en_us
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

let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

" write all on tmux switch
let g:tmux_navigator_save_on_switch = 2

set background=dark
colorscheme codedark
let g:airline_theme='codedark'
set noshowmatch

set mouse=a
augroup sageFiletype
    autocmd!
    autocmd BufRead,BufNewFile *.sage set filetype=python
augroup END

augroup restoreCursor
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
augroup END
nnoremap <leader>nn <cmd>NERDTreeToggle<CR>
nnoremap <leader>vv <cmd>e $MYVIMRC<CR>
nnoremap <leader>vr <cmd>source $MYVIMRC<CR>
nnoremap <leader>vt :vsplit\|term<CR>A
nnoremap <leader>b <cmd>bp\|bd #<CR>
nnoremap <leader>h :tab help<SPACE>

]])
