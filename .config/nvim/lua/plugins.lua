local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
end

return require('packer').startup(function(use)
    -- My plugins here
    -- use 'foo1/bar1.nvim'
    -- use 'foo2/bar2.nvim'
    use {'neovim/nvim-lspconfig', config = 'require[[config.nvim-lspconfig]]'}
    use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate', config = 'require[[config.nvim-treesitter]]'}

    use {'hrsh7th/cmp-nvim-lsp', config = function() require'cmp_nvim_lsp'.update_capabilities(vim.lsp.protocol.make_client_capabilities()) end}
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'
    use {'hrsh7th/nvim-cmp', config = 'require[[config.nvim-cmp]]'}

    if not vim.env.TERMUX_VERSION then
        use 'vim-airline/vim-airline'
        use 'vim-airline/vim-airline-themes'
    end

    use 'tomasiser/vim-code-dark'

    use {'preservim/nerdtree', cmd = 'NERDTreeToggle'}

    use 'lervag/vimtex'
    use 'SirVer/ultisnips'
    use 'quangnguyen30192/cmp-nvim-ultisnips'

    use 'christoomey/vim-tmux-navigator'
    use 'tpope/vim-surround'
    use 'tpope/vim-repeat'

    use 'jiangmiao/auto-pairs'


    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require('packer').sync()
    end
end)
