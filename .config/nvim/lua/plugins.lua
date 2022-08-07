local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
local packer_bootstrap = nil

if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
end

vim.cmd [[
augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile | PackerInstall
augroup end
]]

return require('packer').startup(function(use)

    use 'wbthomason/packer.nvim'

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

    use {
        'kyazdani42/nvim-tree.lua',
        requires = {
            'kyazdani42/nvim-web-devicons', -- optional, for file icons
        },
        tag = 'nightly', -- optional, updated every week. (see issue #1193)
        cmd = { 'NvimTreeToggle', 'NvimTreeFocus', 'NvimTreeFindFile', 'NvimTreeCollapse' },
        config = function ()
            require('nvim-tree').setup()
        end
    }

    use 'lervag/vimtex'
    use 'SirVer/ultisnips'
    use 'quangnguyen30192/cmp-nvim-ultisnips'

    use 'christoomey/vim-tmux-navigator'
    use 'tpope/vim-surround'
    use 'tpope/vim-repeat'

    use 'jiangmiao/auto-pairs'
    use 'tpope/vim-endwise'

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require('packer').sync()
    end
end)
