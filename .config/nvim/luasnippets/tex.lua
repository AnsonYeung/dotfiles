local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local c = ls.choice_node
local t = ls.text_node
local d = ls.dynamic_node
local f = ls.function_node
local i = ls.insert_node
local l = require("luasnip.extras").lambda
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

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

local dyn_item_list
dyn_item_list = function()
    return sn(
        nil,
        c(1, {
            -- Order is important, sn(...) first would cause infinite loop of expansion.
            t(""),
            sn(nil, { t({ "", "\t\\item " }), i(1), d(2, dyn_item_list, {}) }),
        })
    )
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
    ls.parser.parse_snippet({ trig = 'pac' }, '\\usepackage[${1:options}]{${2:package}}'),
    ls.parser.parse_snippet({ trig = 'lr' }, '\\left($1\\right)', { show_condition = math, condition = math }),

    s({ trig = 'sum' },
        fmt('\\sum_{<>=<>}^{<>} <>', {
            c(1, { t('i'), t('j'), t('k'), t('n'), i(1) }),
            c(2, { t('0'), t('1'), i(2) }),
            c(3, { t('\\infty'), t('n'), i(3) }),
            dl(4, 'a_' .. l._1 .. ' z^' .. l._1, 1),
        }, { delimiters = '<>' }),
        { show_condition = math, condition = math }
    ),

    s({ trig = 'taylor' },
        fmt('\\sum_{<>=<>}^{<>} <> (<>-<>)^<>', {
            c(1, { t('i'), t('j'), t('k'), t('n'), i(1) }),
            c(2, { t('0'), t('1'), i(2) }),
            c(3, { t('\\infty'), t('n'), i(3) }),
            dl(4, 'c_'..l._1, 1),
            i(5, 'x'),
            i(6, 'a'),
            rep(1)
        }, { delimiters = '<>' }),
        { show_condition = math, condition = math }
    ),
}, {
    ls.parser.parse_snippet({ trig = 'mk' }, '$$1$'),
    ls.parser.parse_snippet({ trig = 'dm' }, '\\[\n$1\n.\\]'),
    ls.parser.parse_snippet({ trig = 'beg' }, '\\begin{$1}\n$2\n\\end{$1}\n'),
    ls.parser.parse_snippet({ trig = 'ali' }, '\\begin{align*}\n$1\n\\end{align*}\n'),
    ls.parser.parse_snippet({ trig = 'case' }, '\\begin{cases}\n$1\n\\end{cases}\n'),
    ls.parser.parse_snippet({ trig = 'sr', wordTrig = false }, '^2', { condition = math }),
    ls.parser.parse_snippet({ trig = 'cb', wordTrig = false }, '^3', { condition = math }),
    ls.parser.parse_snippet({ trig = 'td', wordTrig = false }, '^{$1}', { condition = math }),
    ls.parser.parse_snippet({ trig = 'sq', wordTrig = false }, '\\sqrt{$1}', { condition = math }),
    ls.parser.parse_snippet({ trig = 'vec', wordTrig = false }, '\\vec{$1}', { condition = math }),
    ls.parser.parse_snippet({ trig = 'tt', wordTrig = false }, '\\text{$1}', { condition = math }),

    ls.parser.parse_snippet({ trig = '...' }, '\\ldots'),
    ls.parser.parse_snippet({ trig = '=>' }, '\\implies', { condition = math }),
    ls.parser.parse_snippet({ trig = '=<' }, '\\impliesby', { condition = math }),
    ls.parser.parse_snippet({ trig = '\\le=' }, '\\impliesby', { condition = math }),
    ls.parser.parse_snippet({ trig = '\\le>' }, '\\iff', { condition = math }),
    ls.parser.parse_snippet({ trig = 'iff' }, '\\iff', { condition = math }),
    ls.parser.parse_snippet({ trig = '!=' }, '\\neq', { condition = math }),
    ls.parser.parse_snippet({ trig = '>=' }, '\\ge', { condition = math }),
    ls.parser.parse_snippet({ trig = '<=' }, '\\le', { condition = math }),
    ls.parser.parse_snippet({ trig = 'ooo' }, '\\infty', { condition = math }),
    ls.parser.parse_snippet({ trig = 'EE' }, '\\exists', { condition = math }),
    ls.parser.parse_snippet({ trig = 'AA' }, '\\forall', { condition = math }),
    ls.parser.parse_snippet({ trig = '->' }, '\\to', { condition = math }),
    ls.parser.parse_snippet({ trig = '<->' }, '\\leftrightarrow', { condition = math }),
    ls.parser.parse_snippet({ trig = '!>' }, '\\mapsto', { condition = math }),
    ls.parser.parse_snippet({ trig = 'invs', wordTrig = false }, '^{-1}', { condition = math }),
    ls.parser.parse_snippet({ trig = 'compl', wordTrig = false }, '^{c}', { condition = math }),
    ls.parser.parse_snippet({ trig = '---' }, '\\setminus', { condition = math }),
    ls.parser.parse_snippet({ trig = '>>' }, '\\gg', { condition = math }),
    ls.parser.parse_snippet({ trig = '<<' }, '\\ll', { condition = math }),
    ls.parser.parse_snippet({ trig = '~~' }, '\\sim', { condition = math }),
    ls.parser.parse_snippet({ trig = '||' }, '\\mid', { condition = math }),
    ls.parser.parse_snippet({ trig = '<!' }, '\\triangleleft', { condition = math }),
    ls.parser.parse_snippet({ trig = '<>' }, '\\diamond', { condition = math }),
    ls.parser.parse_snippet({ trig = 'cc' }, '\\subset', { condition = math }),
    ls.parser.parse_snippet({ trig = 'inn' }, '\\in', { condition = math }),
    ls.parser.parse_snippet({ trig = 'notin' }, '\\not\\in', { condition = math }),
    ls.parser.parse_snippet({ trig = 'Nn' }, '\\cap', { condition = math }),
    ls.parser.parse_snippet({ trig = 'UU' }, '\\cup', { condition = math }),
    ls.parser.parse_snippet({ trig = 'star' }, '\\star', { condition = math }),
    ls.parser.parse_snippet({ trig = 'perp' }, '\\perp', { condition = math }),
    ls.parser.parse_snippet({ trig = 'OO' }, '\\emptyset', { condition = math }),
    ls.parser.parse_snippet({ trig = 'int' }, '\\int', { condition = math }),
    ls.parser.parse_snippet({ trig = 'pi', wordTrig = false }, '\\pi', { condition = math }),
    ls.parser.parse_snippet({ trig = 'zeta', wordTrig = false }, '\\zeta', { condition = math }),
    ls.parser.parse_snippet({ trig = 'lll', wordTrig = false }, '\\ell', { condition = math }),
    ls.parser.parse_snippet({ trig = 'nabl', wordTrig = false }, '\\nabla', { condition = math }),

    ls.parser.parse_snippet({ trig = '()' }, '\\left($1\\right)', { condition = math }),
    ls.parser.parse_snippet({ trig = 'lr(', wordTrig = false }, '\\left($1\\right)', { condition = math }),
    ls.parser.parse_snippet({ trig = 'lr[', wordTrig = false }, '\\left[$1\\right]', { condition = math }),
    ls.parser.parse_snippet({ trig = 'lr{', wordTrig = false }, '\\left\\{$1\\right\\}', { condition = math }),
    ls.parser.parse_snippet({ trig = 'lrb', wordTrig = false }, '\\left\\{$1\\right\\}', { condition = math }),
    ls.parser.parse_snippet({ trig = 'lr|', wordTrig = false }, '\\left|$1\\right|', { condition = math }),
    ls.parser.parse_snippet({ trig = 'norm', wordTrig = false }, '\\left|$1\\right|', { condition = math }),
    ls.parser.parse_snippet({ trig = 'lr<', wordTrig = false }, '\\left<$1\\right>', { condition = math }),
    ls.parser.parse_snippet({ trig = 'lra', wordTrig = false }, '\\left<$1\\right>', { condition = math }),
    ls.parser.parse_snippet({ trig = 'ceil', wordTrig = false }, '\\left\\lceil $1 \\right\\rceil', { condition = math }),
    ls.parser.parse_snippet({ trig = 'floor', wordTrig = false }, '\\left\\lfloor $1 \\right\\rfloor',
        { condition = math }),
    ls.parser.parse_snippet({ trig = 'conj', wordTrig = false }, '\\overline{$1}', { condition = math }),
    ls.parser.parse_snippet({ trig = 'pmat', wordTrig = false }, '\\begin{pmatrix}$1\\end{pmatrix}', { condition = math }),
    ls.parser.parse_snippet({ trig = 'bmat', wordTrig = false }, '\\begin{bmatrix}$1\\end{bmatrix}', { condition = math }),
    ls.parser.parse_snippet({ trig = 'mcal', wordTrig = false }, '\\mathcal{$1}', { condition = math }),
    ls.parser.parse_snippet({ trig = 'xx', wordTrig = false }, '\\times', { condition = math }),
    ls.parser.parse_snippet({ trig = '**', wordTrig = false }, '\\cdots', { condition = math }),

    s({ trig = 'sin' }, t('\\sin'), { condition = math }),
    s({ trig = 'cos' }, t('\\cos'), { condition = math }),
    s({ trig = 'arccot' }, t('\\arccot'), { condition = math }),
    s({ trig = 'cot' }, t('\\cot'), { condition = math }),
    s({ trig = 'csc' }, t('\\csc'), { condition = math }),
    s({ trig = 'ln' }, t('\\ln'), { condition = math }),
    s({ trig = 'log' }, t('\\log'), { condition = math }),
    s({ trig = 'exp' }, t('\\exp'), { condition = math }),
    s({ trig = 'mod' }, t('\\mod'), { condition = math }),
    s({ trig = 'gcd' }, t('\\gcd'), { condition = math }),
    s({ trig = 'det' }, t('\\det'), { condition = math }),
    s({ trig = 'arcsin' }, t('\\arcsin'), { condition = math }),
    s({ trig = 'arccos' }, t('\\arccos'), { condition = math }),
    s({ trig = 'arctan' }, t('\\arctan'), { condition = math }),
    s({ trig = 'arccot' }, t('\\arccot'), { condition = math }),
    s({ trig = 'arccsc' }, t('\\arccsc'), { condition = math }),
    s({ trig = 'arcsec' }, t('\\arcsec'), { condition = math }),

    s({ trig = '([NZQRC])%1', regTrig = true }, { t('\\mathbb{'), l(l.CAPTURE1), t('}') }, { condition = math }),

    s({ trig = 'dint' }, fmt('\\int_{{{}}}^{{{}}} ', { i(1, '-\\infty'), i(2, '\\infty') }), { condition = math }),
    s({ trig = 'uuu' },
        fmt('\\bigcup_{{{}}} ', { sn(1, { i(1, 'i'), c(2, { sn(nil, { t(' \\in '), i(1, 'I') }), t('') }) }) }),
        { condition = math }),
    s({ trig = 'nnn' },
        fmt('\\bigcap{{{}}} ', { sn(1, { i(1, 'i'), c(2, { sn(nil, { t(' \\in '), i(1, 'I') }), t('') }) }) }),
        { condition = math }),

    s({ trig = 'enum' },
        fmt('\\begin{enumerate}<>\n\\end{enumerate}\n', { d(2, dyn_item_list, {}) }, { delimiters = '<>' })),
    s({ trig = 'item' }, fmt('\\begin{itemize}<>\n\\end{itemize}\n', { d(2, dyn_item_list, {}) }, { delimiters = '<>' })),

    s({ trig = '([%d%a\\_]+)/', regTrig = true }, fmt([[\frac{<>}{<>}]], { l(l.CAPTURE1), i(1) }, { delimiters = '<>' })
        , { condition = math }),
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

    s({ trig = '([xyzva])([ijkmn])%2', regTrig = true }, fmt('{}_{{{}}}', { l(l.CAPTURE1), l(l.CAPTURE2) }),
        { condition = math }),
    s({ trig = '(%a)(%d)', regTrig = true }, fmt('{}_{}', { l(l.CAPTURE1), l(l.CAPTURE2) }), { condition = math }),
    s({ trig = '(%a)_(%d%d)', regTrig = true }, fmt('{}_{{{}}}', { l(l.CAPTURE1), l(l.CAPTURE2) }), { condition = math }),

    s({ trig = '<(.*)|', regTrig = true }, fmt('\\bra{{{}}}', { l(l.CAPTURE1:gsub('q', '\\psi'):gsub('f', '\\phi')) }),
        { condition = math }),
    s({ trig = '|(.*)>', regTrig = true }, fmt('\\ket{{{}}}', { l(l.CAPTURE1:gsub('q', '\\psi'):gsub('f', '\\phi')) }),
        { condition = math }),
    s({ trig = '\\bra{(.*)}([^\\|]*)>', regTrig = true },
        fmt('\\braket{{{}}}{{{}}}', {
            l(l.CAPTURE1:gsub('q', '\\psi'):gsub('f', '\\phi')),
            l(l.CAPTURE2:gsub('q', '\\psi'):gsub('f', '\\phi'))
        }), { condition = math }),

}
