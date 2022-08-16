local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
local packer_bootstrap = nil

if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim',
        install_path })
    vim.cmd [[packadd packer.nvim]]
end

vim.cmd [[
augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
augroup end
]]

return require('packer').startup(function(use)

    use 'wbthomason/packer.nvim'

    use {
        'neovim/nvim-lspconfig',
        requires = {
            'hrsh7th/cmp-nvim-lsp'
        },
        config = function()
            require 'config.nvim-lspconfig'
        end
    }

    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = function()
            require 'config.nvim-treesitter'
        end
    }

    use {
        "hrsh7th/nvim-cmp",
        requires = {
            {
                "quangnguyen30192/cmp-nvim-ultisnips",
                config = function()
                    -- optional call to setup (see customization section)
                    require("cmp_nvim_ultisnips").setup {}
                end,
                -- If you want to enable filetype detection based on treesitter:
                requires = { "nvim-treesitter/nvim-treesitter" },
            },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'hrsh7th/cmp-cmdline' },
        },
        config = function()
            require 'config.nvim-cmp'
        end,
    }

    if not vim.env.TERMUX_VERSION then
        use 'vim-airline/vim-airline'
        use 'vim-airline/vim-airline-themes'
    end

    use {
        'tomasiser/vim-code-dark',
        config = function()
            vim.cmd 'colorscheme codedark'
            vim.g.airline_theme = 'codedark'
        end
    }

    --[[
    use 'morhetz/gruvbox'
    use 'folke/lsp-colors.nvim'
    --]]

    --[[
    use({
        "glepnir/lspsaga.nvim",
        branch = "main",
        config = function()
            local saga = require("lspsaga")

            saga.init_lsp_saga({
                -- your configuration
                diagnostic_header = { " ", " ", " ", "ﴞ " },
                code_action_icon = "💡",
            })
        end,
    })
    --]]

    use {
        'kyazdani42/nvim-tree.lua',
        requires = {
            'kyazdani42/nvim-web-devicons', -- optional, for file icons
        },
        tag = 'nightly', -- optional, updated every week. (see issue #1193)
        cmd = { 'NvimTreeToggle', 'NvimTreeFocus', 'NvimTreeFindFile', 'NvimTreeCollapse' },
        config = function()
            require('nvim-tree').setup({
                filters = {
                    custom = { "^.git$" }
                }
            })
        end
    }

    use {
        "folke/trouble.nvim",
        requires = "kyazdani42/nvim-web-devicons",
        config = function()
            require("trouble").setup {
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
                vim.api.nvim_set_keymap('n', '<leader>ct', '<cmd>TroubleToggle<cr>', { noremap = true, silent = true })
            }
        end
    }

    use 'lervag/vimtex'
    use {
        'SirVer/ultisnips',
        config = function()
            vim.g.UltiSnipsExpandTrigger = '<Plug>(ultisnips_expand)'
            vim.g.UltiSnipsJumpForwardTrigger = '<Plug>(ultisnips_jump_forward)'
            vim.g.UltiSnipsJumpBackwardTrigger = '<Plug>(ultisnips_jump_backward)'
            vim.g.UltiSnipsListSnippets = '<c-x><c-s>'
            vim.g.UltiSnipsRemoveSelectModeMappings = 0

            -- If you want :UltiSnipsEdit to split your window.
            -- let g:UltiSnipsEditSplit="vertical"
        end
    }

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
