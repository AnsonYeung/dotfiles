local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
local packer_bootstrap = nil

if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim',
        install_path })
    vim.cmd [[packadd packer.nvim]]
end

local packerGp = vim.api.nvim_create_augroup('packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
    pattern = 'plugins.lua',
    command = 'source <afile> | PackerCompile',
    group = packerGp
})

return require('packer').startup(function(use)

    use 'wbthomason/packer.nvim'

    use {
        'neovim/nvim-lspconfig',
        requires = {
            'hrsh7th/cmp-nvim-lsp',
            'lukas-reineke/lsp-format.nvim'
        },
    }

    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
    }

    use {
        "hrsh7th/nvim-cmp",
        requires = {
            { "saadparwaiz1/cmp_luasnip" },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'hrsh7th/cmp-cmdline' },
        },
    }

    use {
        'akinsho/bufferline.nvim',
        requires = 'kyazdani42/nvim-web-devicons',
        config = function()
            require 'bufferline'.setup {}
        end
    }

    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true },
        config = function()
            require('lualine').setup {
                options = {
                    theme = 'codedark'
                }
            }
        end
    }

    vim.g.gitgutter_map_keys = false
    use {
        'airblade/vim-gitgutter',
        config = function()
            vim.o.updatetime = 100
        end
    }

    use {
        'joshdick/onedark.vim',
        config = function()
            vim.cmd 'colorscheme onedark'
        end
    }

    --[[
    use {
        'tomasiser/vim-code-dark',
        config = function()
            vim.cmd 'colorscheme codedark'
        end
    }
    --]]

    --[[
    use({
        "glepnir/lspsaga.nvim",
        branch = "main",
        config = function()
            local saga = require("lspsaga")

            saga.init_lsp_saga({
                -- your configuration
            })
        end,
    })
    --]]

    use({
        "nvim-telescope/telescope.nvim",
        requires = { { "nvim-lua/plenary.nvim" }, { "kdheepak/lazygit.nvim" } },
        config = function()
            local telescope = require("telescope")
            telescope.load_extension("lazygit")

            local lgGrp = vim.api.nvim_create_augroup("lazygit", { clear = true })
            vim.api.nvim_create_autocmd("BufEnter", {
                command = "silent! lua require('lazygit.utils').project_root_dir()",
                group = lgGrp
            })

            vim.keymap.set('n', '<leader>ff', require('telescope.builtin').git_files, {})
            vim.keymap.set('n', '<leader>f*', require('telescope.builtin').grep_string, {})
            vim.keymap.set('n', '<leader>fg', require('telescope.builtin').live_grep, {})
            vim.keymap.set('n', '<leader>fs', require('telescope.builtin').treesitter, {})
            vim.keymap.set('n', '<leader>g', require('telescope').extensions.lazygit.lazygit, {})

            local actions = require("telescope.actions")
            require("telescope").setup {
                defaults = {
                    mappings = {
                        i = {
                            ["<esc>"] = actions.close
                        },
                    },
                }
            }

        end,
    })

    use {
        'kyazdani42/nvim-web-devicons',
        config = function()
            require('nvim-web-devicons').setup {
                default = true
            }
        end
    }

    use {
        'kyazdani42/nvim-tree.lua',
        requires = {
            'kyazdani42/nvim-web-devicons', -- optional, for file icons
        },
        tag = 'nightly', -- optional, updated every week. (see issue #1193)
        cmd = { 'NvimTreeToggle', 'NvimTreeFocus', 'NvimTreeFindFile', 'NvimTreeCollapse' },
        config = function()
            require('nvim-tree').setup {
                filters = {
                    custom = { "^.git$" }
                }
            }
        end
    }

    use {
        'folke/trouble.nvim',
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

    use {
        'lervag/vimtex',
        config = function()
            vim.g.vimtex_mappings_disable = { i = { ']]' } }
        end
    }

    use 'L3MON4D3/LuaSnip'
    use 'christoomey/vim-tmux-navigator'
    use 'tpope/vim-surround'
    use 'tpope/vim-repeat'
    use 'tpope/vim-endwise'
    use {
        'jiangmiao/auto-pairs',
        config = function()
            vim.g.AutoPairsMultilineClose = false
            local autopairGp = vim.api.nvim_create_augroup('auto-pairs', { clear = true })
            vim.api.nvim_create_autocmd('FileType', {
                pattern = 'rust',
                command = "let b:AutoPairs = {'(':')', '[':']', '{':'}', '\"':'\"', '`':'`', '```':'```', 'r#\"':'\"#', 'r##\"':'\"##', '\\w\\zs<': '>'}",
                group = autopairGp
            })

            vim.api.nvim_create_autocmd('FileType', {
                pattern = 'tex',
                command = "let b:autopairs_enabled = 0",
                group = autopairGp
            })
        end
    }

    use {
        '907th/vim-auto-save',
        config = function()
            local autosaveGp = vim.api.nvim_create_augroup('auto-save', { clear = true })
            vim.cmd [[ let g:auto_save_events = ["BufModifiedSet"] ]]
            vim.api.nvim_create_autocmd('FileType', {
                pattern = 'tex',
                command = 'let b:auto_save = 1',
                group = autosaveGp
            })
            vim.keymap.set('n', '<leader>ts', function()
                vim.b.auto_save = (vim.b.auto_save == 0) and 1 or 0
            end, {})
        end
    }

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require('packer').sync()
    end
end)
