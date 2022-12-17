local ls = require("luasnip")

ls.setup({
    history = true,
    enable_autosnippets = true,
    ft_func = require("luasnip.extras.filetype_functions").from_cursor
})

require("luasnip.loaders.from_lua").load({ paths = "./luasnippets" })
