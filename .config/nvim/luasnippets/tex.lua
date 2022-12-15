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
            c(1, { i(nil, 'i'), i(nil, 'j'), i(nil, 'k'), i(nil, 'n') }),
            c(2, { i(nil, '0'), i(nil, '1') }),
            c(3, { i(nil, '\\infty'), i(nil, 'n') }),
            dl(4, 'a_' .. l._1 .. ' z^' .. l._1, 1),
        }, { delimiters = '<>' }),
        { show_condition = math, condition = math }
    ),

    s({ trig = 'taylor' },
        fmt('\\sum_{<>=<>}^{<>} <> (<>-<>)^<>', {
            c(1, { i(nil, 'i'), i(nil, 'j'), i(nil, 'k'), i(nil, 'n') }),
            c(2, { i(nil, '0'), i(nil, '1') }),
            c(3, { i(nil, '\\infty'), i(nil, 'n') }),
            dl(4, 'c_' .. l._1, 1),
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
    ls.parser.parse_snippet({ trig = '__' }, '_{$1}', { condition = math }),
    ls.parser.parse_snippet({ trig = 'sq', wordTrig = false }, '\\sqrt{$1}', { condition = math }),
    ls.parser.parse_snippet({ trig = 'vec', wordTrig = false }, '\\vec{$1}', { condition = math }),
    ls.parser.parse_snippet({ trig = 'tt', wordTrig = false }, '\\text{$1}', { condition = math }),

    s({ trig = '...' }, t('\\dots')),
    s({ trig = '=>' }, t('\\implies'), { condition = math }),
    s({ trig = '=<' }, t('\\impliesby'), { condition = math }),
    s({ trig = '\\le=' }, t('\\impliesby'), { condition = math }),
    s({ trig = '\\le>' }, t('\\iff'), { condition = math }),
    s({ trig = 'iff' }, t('\\iff'), { condition = math }),
    s({ trig = '!=' }, t('\\neq'), { condition = math }),
    s({ trig = '>=' }, t('\\ge'), { condition = math }),
    s({ trig = '<=' }, t('\\le'), { condition = math }),
    s({ trig = 'ooo' }, t('\\infty'), { condition = math }),
    s({ trig = 'EE' }, t('\\exists'), { condition = math }),
    s({ trig = 'AA' }, t('\\forall'), { condition = math }),
    s({ trig = '->' }, t('\\to'), { condition = math }),
    s({ trig = '<->' }, t('\\leftrightarrow'), { condition = math }),
    s({ trig = '!>' }, t('\\mapsto'), { condition = math }),
    s({ trig = 'inv', wordTrig = false }, t('^{-1}'), { condition = math }),
    s({ trig = 'compl', wordTrig = false }, t('^{c}'), { condition = math }),
    s({ trig = '---' }, t('\\setminus'), { condition = math }),
    s({ trig = '>>' }, t('\\gg'), { condition = math }),
    s({ trig = '<<' }, t('\\ll'), { condition = math }),
    s({ trig = '~~' }, t('\\sim'), { condition = math }),
    s({ trig = '||' }, t('\\mid'), { condition = math }),
    s({ trig = '<!' }, t('\\triangleleft'), { condition = math }),
    s({ trig = '<>' }, t('\\diamond'), { condition = math }),
    s({ trig = 'CC' }, t('\\subset'), { condition = math }),
    s({ trig = 'inn' }, t('\\in'), { condition = math }),
    s({ trig = 'notin' }, t('\\not\\in'), { condition = math }),
    s({ trig = 'Nn' }, t('\\cap'), { condition = math }),
    s({ trig = 'UU' }, t('\\cup'), { condition = math }),
    s({ trig = 'star' }, t('\\star'), { condition = math }),
    s({ trig = 'perp' }, t('\\perp'), { condition = math }),
    s({ trig = 'OO' }, t('\\emptyset'), { condition = math }),
    s({ trig = 'int' }, t('\\int'), { condition = math }),
    s({ trig = 'pi', wordTrig = false }, t('\\pi'), { condition = math }),
    s({ trig = 'zeta', wordTrig = false }, t('\\zeta'), { condition = math }),
    s({ trig = 'lll', wordTrig = false }, t('\\ell'), { condition = math }),
    s({ trig = 'nabl', wordTrig = false }, t('\\nabla'), { condition = math }),

    ls.parser.parse_snippet({ trig = '()' }, '\\left($1\\right)', { condition = math }),
    ls.parser.parse_snippet({ trig = 'lr(', wordTrig = false }, '\\left($1\\right)', { condition = math }),
    ls.parser.parse_snippet({ trig = 'lr[', wordTrig = false }, '\\left[$1\\right]', { condition = math }),
    ls.parser.parse_snippet({ trig = 'lr{', wordTrig = false }, '\\left\\{$1\\right\\}', { condition = math }),
    ls.parser.parse_snippet({ trig = 'lrb', wordTrig = false }, '\\left\\{$1\\right\\}', { condition = math }),
    ls.parser.parse_snippet({ trig = 'lr|', wordTrig = false }, '\\left|$1\\right|', { condition = math }),
    ls.parser.parse_snippet({ trig = 'norm', wordTrig = false }, '\\left|$1\\right|', { condition = math }),
    ls.parser.parse_snippet({ trig = 'lr<', wordTrig = false }, '\\left< $1 \\right>', { condition = math }),
    ls.parser.parse_snippet({ trig = 'lra', wordTrig = false }, '\\left\\langle $1 \\right\\rangle', { condition = math }),
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
        fmt('\\begin{enumerate}<>\n\\end{enumerate}\n', { d(1, dyn_item_list, {}) }, { delimiters = '<>' })),
    s({ trig = 'itemize' },
        fmt('\\begin{itemize}<>\n\\end{itemize}\n', { d(1, dyn_item_list, {}) }, { delimiters = '<>' })),

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
