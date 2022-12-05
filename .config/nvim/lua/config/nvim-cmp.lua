-- Setup nvim-cmp.
local luasnip = require('luasnip')
local cmp = require('cmp')

local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    sources = {
        { name = "nvim_lsp" },
        { name = "luasnip", option = { use_show_condition = true } },
        { name = "buffer" },
        -- more sources
    },
    -- recommended configuration for <Tab> people:
    mapping = {
        ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 's', 'c' }),
        ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 's', 'c' }),
        ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
        ['<C-e>'] = cmp.mapping(cmp.mapping.abort(), { 'i', 'c' }),
        ["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's', 'c' }),
        ["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 's', 'c' }),
        ["<C-h>"] = cmp.mapping(
            function(fallback)
                if luasnip.choice_active() then
                    luasnip.change_choice(-1)
                else
                    fallback()
                end
            end,
            { 'i', 's' }
        ),
        ["<C-l>"] = cmp.mapping(
            function(fallback)
                if luasnip.choice_active() then
                    luasnip.change_choice(1)
                else
                    fallback()
                end
            end,
            { 'i', 's' }
        ),
        ["<Tab>"] = cmp.mapping({
            i = function(fallback)
                if cmp.visible() and cmp.get_selected_entry() then
                    cmp.select_next_item()
                elseif luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                elseif cmp.visible() then
                    cmp.select_next_item()
                elseif has_words_before() then
                    cmp.complete()
                else
                    fallback()
                end
            end,
            s = function(fallback)
                if luasnip.jumpable(1) then
                    luasnip.jump(1)
                else
                    fallback()
                end
            end,
            c = function(fallback)
                cmp.select_next_item()
            end
        }),
        ["<S-Tab>"] = cmp.mapping({
            i = function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end,
            s = function(fallback)
                if luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end,
            c = function(fallback)
                cmp.select_prev_item()
            end
        }),
        ["<CR>"] = cmp.mapping.confirm({ select = false }),
        ["<A-CR>"] = cmp.mapping.confirm({ select = true })
    },
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
        { name = 'path' },
        { name = 'cmdline' }
    })
})
