local ls = require("luasnip")
local s = ls.snippet
local f = ls.function_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

local function math()
    return vim.api.nvim_eval('vimtex#syntax#in_mathzone()') == 1
end

local function last_paren_match(s)
    local count = 0
    for i = #s, 1, -1 do
        local c = s:sub(i, i)
        if c == '(' then
            count = count - 1
            if count == 0 then
                return i
            end
        elseif c == ')' then
            count = count + 1
        end
    end
    return 0
end

return {
    ls.parser.parse_snippet({ trig = 'template' }, [[
\documentclass[a4paper]{article}

\usepackage[utf8]{inputenc}
\usepackage[T1]{fontenc}
\usepackage{textcomp}
\usepackage{amsmath, amssymb, physics}
\usepackage{array}
\usepackage{import}
\usepackage{xifthen}
\usepackage{pdfpages}
\usepackage{transparent}
\pdfminorversion=7
\pdfsuppresswarningpagegroup=1

\begin{document}
$0
\end{document}
    ]]),
}, {
    ls.parser.parse_snippet({ trig = 'mk' }, '$$1$'),
    ls.parser.parse_snippet({ trig = 'dm' }, '\\[\n$1\n.\\]'),
    ls.parser.parse_snippet({ trig = 'beg' }, '\\begin{$1}\n$2\n\\end{$1}\n'),
    ls.parser.parse_snippet({ trig = 'ali' }, '\\begin{align*}\n$1\n\\end{align*}\n'),
    ls.parser.parse_snippet({ trig = 'enum' }, '\\begin{enumerate}\n$1\n\\end{enumerate}\n'),
    ls.parser.parse_snippet({ trig = 'sr', wordTrig = false }, '^2', { condition = math }),
    ls.parser.parse_snippet({ trig = 'cb', wordTrig = false }, '^3', { condition = math }),
    ls.parser.parse_snippet({ trig = 'td', wordTrig = false }, '^{$1}', { condition = math }),
    ls.parser.parse_snippet({ trig = 'sq' }, '\\sqrt{$1}', { condition = math }),
    ls.parser.parse_snippet({ trig = 'vec' }, '\\vec{$1}', { condition = math }),

    s({ trig = '([%d%a\\_]+)/', regTrig = true },
        fmt([[\frac{<>}{<>}]], { f(
            function(_, snip)
                return snip.captures[1]
            end
        ), i(1) }, { delimiters = '<>' }),
        { condition = math }),

    s({ trig = '(%(.*%))/', regTrig = true },
        fmt([[<>{<>}]], { f(
            function(_, snip)
                local match = snip.captures[1]
                local pos = last_paren_match(match)
                return match:sub(1, pos - 1) .. "\\frac{" .. match:sub(pos + 1, #match - 1) .. "}"
            end
        ), i(1) }, { delimiters = '<>' }),
        { condition = function(_, _, captures)
            return last_paren_match(captures[1]) ~= 0
        end }),

    s({ trig = '(%a)(%d)', regTrig = true },
        fmt('{}_{}', { f(function(_, snip)
            return snip.captures[1]
        end), f(function(_, snip)
            return snip.captures[2]
        end) }),
        { condition = math }),

    s({ trig = '(%a)_(%d%d)', regTrig = true },
        fmt('{}_{{{}}}', { f(function(_, snip)
            return snip.captures[1]
        end), f(function(_, snip)
            return snip.captures[2]
        end) }),
        { condition = math }),
}
