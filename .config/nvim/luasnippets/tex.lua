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
    s({ trig = 'template' }, fmt([[
\documentclass[a4paper]{{article}}

\usepackage[T1]{{fontenc}}
\usepackage[english]{{babel}}
\usepackage{{amsmath, amssymb, physics}}
\usepackage{{array}}
\pdfminorversion=7

\begin{{document}}
{}
\end{{document}}
    ]], { i(0) })),
    s({ trig = 'pac' }, fmt('\\usepackage[{}]{{{}}}', { i(1, 'options'), i(2, 'package') })),
    s({ trig = 'lr' }, fmt('\\left({}\\right)', { i(1) }), { show_condition = math, condition = math }),
    s({ trig = 'sum' },
        fmt('\\sum_{<>=<>}^{<>} ', {
            c(1, { i(nil, 'i'), i(nil, 'j'), i(nil, 'k'), i(nil, 'n') }),
            c(2, { i(nil, '0'), i(nil, '1') }),
            c(3, { i(nil, '\\infty'), i(nil, 'n') }),
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
    s({ trig = 'mk' }, fmt('${}$', { i(1) })),
    s({ trig = 'dm' }, fmt('\\[\n{}\n.\\]', { i(1) })),
    s({ trig = 'beg' }, fmt('\\begin{{{}}}\n{}\n\\end{{{}}}\n', { i(1), i(2), rep(1) })),
    s({ trig = 'ali' }, fmt('\\begin{{align*}}\n{}\n\\end{{align*}}\n', { i(1) })),
    s({ trig = 'case' }, fmt('\\begin{{cases}}\n{}\n\\end{{cases}}\n', { i(1) }), { condition = math }),
    s({ trig = 'sr', wordTrig = false }, t('^2'), { condition = math }),
    s({ trig = 'cb', wordTrig = false }, t('^3'), { condition = math }),
    s({ trig = 'td', wordTrig = false }, fmt('^{{{}}}', { i(1) }), { condition = math }),
    s({ trig = '__', wordTrig = false }, fmt('_{{{}}}', { i(1) }), { condition = math }),
    s({ trig = 'sq', wordTrig = false }, fmt('\\sqrt{{{}}}', { i(1) }), { condition = math }),
    s({ trig = 'rt', wordTrig = false }, fmt('\\sqrt[{}]{{{}}}', { i(1), i(2) }), { condition = math }),
    s({ trig = 'vec', wordTrig = false }, fmt('\\vec{{{}}}', { i(1) }), { condition = math }),
    s({ trig = 'tt' }, fmt('\\text{{{}}}', { i(1) }), { condition = math }),

    s({ trig = '...' }, t('\\dots')),
    s({ trig = '=>' }, t('\\implies'), { condition = math }),
    s({ trig = '=<' }, t('\\impliesby'), { condition = math }),
    s({ trig = '\\le=', wordTrig = false }, t('\\impliesby'), { condition = math }),
    s({ trig = '\\le>', wordTrig = false }, t('\\iff'), { condition = math }),
    s({ trig = 'iff' }, t('\\iff'), { condition = math }),
    s({ trig = '!=', wordTrig = false }, t('\\neq'), { condition = math }),
    s({ trig = '>=', wordTrig = false }, t('\\ge'), { condition = math }),
    s({ trig = '<=', wordTrig = false }, t('\\le'), { condition = math }),
    s({ trig = 'ooo' }, t('\\infty'), { condition = math }),
    s({ trig = 'EE' }, t('\\exists'), { condition = math }),
    s({ trig = 'AA' }, t('\\forall'), { condition = math }),
    s({ trig = '->', wordTrig = false }, t('\\to'), { condition = math }),
    s({ trig = '<->' }, t('\\leftrightarrow'), { condition = math }),
    s({ trig = '!>', wordTrig = false }, t('\\mapsto'), { condition = math }),
    s({ trig = 'inv', wordTrig = false }, t('^{-1}'), { condition = math }),
    s({ trig = 'compl', wordTrig = false }, t('^{c}'), { condition = math }),
    s({ trig = '---' }, t('\\setminus'), { condition = math }),
    s({ trig = '>>' }, t('\\gg'), { condition = math }),
    s({ trig = '<<' }, t('\\ll'), { condition = math }),
    s({ trig = '~~' }, t('\\sim'), { condition = math }),
    s({ trig = '||' }, t('\\mid'), { condition = math }),
    s({ trig = '<!' }, t('\\triangleleft'), { condition = math }),
    s({ trig = '<>' }, t('\\diamond'), { condition = math }),
    s({ trig = 'cc' }, t('\\subset'), { condition = math }),
    s({ trig = 'inn' }, t('\\in'), { condition = math }),
    s({ trig = 'notin' }, t('\\not\\in'), { condition = math }),
    s({ trig = 'Nn' }, t('\\cap'), { condition = math }),
    s({ trig = 'UU' }, t('\\cup'), { condition = math }),
    s({ trig = 'star' }, t('\\star'), { condition = math }),
    s({ trig = 'perp' }, t('\\perp'), { condition = math }),
    s({ trig = 'OO' }, t('\\emptyset'), { condition = math }),
    s({ trig = 'int' }, t('\\int'), { condition = math }),
    s({ trig = 'pi', wordTrig = false }, t('\\pi'), { condition = math }),
    s({ trig = 'eps', wordTrig = false }, t('\\epsilon'), { condition = math }),
    s({ trig = 'ga', wordTrig = false }, t('\\gamma'), { condition = math }),
    s({ trig = 'zeta', wordTrig = false }, t('\\zeta'), { condition = math }),
    s({ trig = 'lll', wordTrig = false }, t('\\ell'), { condition = math }),
    s({ trig = 'nabl', wordTrig = false }, t('\\nabla'), { condition = math }),
    s({ trig = '()', wordTrig = false }, fmt('\\left({}\\right)', { i(1) }), { condition = math }),
    s({ trig = 'lr(', wordTrig = false }, fmt('\\left({}\\right)', { i(1) }), { condition = math }),
    s({ trig = 'lr[', wordTrig = false }, fmt('\\left[{}\\right]', { i(1) }), { condition = math }),
    s({ trig = 'lr{', wordTrig = false }, fmt('\\left\\{{{}\\right\\}}', { i(1) }), { condition = math }),
    s({ trig = 'lrb', wordTrig = false }, fmt('\\left\\{{{}\\right\\}}', { i(1) }), { condition = math }),
    s({ trig = 'lr|', wordTrig = false }, fmt('\\left|{}\\right|', { i(1) }), { condition = math }),
    s({ trig = 'norm', wordTrig = false }, fmt('\\left\\|{}\\right\\|', { i(1) }), { condition = math }),
    s({ trig = 'lr<', wordTrig = false }, fmt('\\left< {} \\right>', { i(1) }), { condition = math }),
    s({ trig = 'lra', wordTrig = false }, fmt('\\left\\langle {} \\right\\rangle', { i(1) }), { condition = math }),
    s({ trig = 'ceil', wordTrig = false }, fmt('\\left\\lceil {} \\right\\rceil', { i(1) }), { condition = math }),
    s({ trig = 'floor', wordTrig = false }, fmt('\\left\\lfloor {} \\right\\rfloor', { i(1) }),
        { condition = math }),
    s({ trig = 'conj', wordTrig = false }, fmt('\\overline{{{}}}', { i(1) }), { condition = math }),
    s({ trig = 'pmat', wordTrig = false }, fmt('\\begin{{pmatrix}}{}\\end{{pmatrix}}', { i(1) }), { condition = math }),
    s({ trig = 'bmat', wordTrig = false }, fmt('\\begin{{bmatrix}}{}\\end{{bmatrix}}', { i(1) }), { condition = math }),
    s({ trig = 'mcal', wordTrig = false }, fmt('\\mathcal{{{}}}', { i(1) }), { condition = math }),
    s({ trig = 'xx', wordTrig = false }, t('\\times'), { condition = math }),
    s({ trig = '**', wordTrig = false }, t('\\cdot'), { condition = math }),
    s({ trig = 'sin' }, t('\\sin'), { condition = math }),
    s({ trig = 'cos' }, t('\\cos'), { condition = math }),
    s({ trig = 'arccot' }, t('\\arccot'), { condition = math }),
    s({ trig = 'cot' }, t('\\cot'), { condition = math }),
    s({ trig = 'csc' }, t('\\csc'), { condition = math }),
    s({ trig = 'ln' }, t('\\ln'), { condition = math }),
    s({ trig = 'log' }, t('\\log'), { condition = math }),
    s({ trig = 'exp' }, { t('\\exp{'), i(1), t('}') }, { condition = math }),
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
        fmt('\\bigcup_{{{}}} ',
            { sn(1, { i(1, 'i'), c(2, { sn(nil, { t(' \\in '), i(1, 'I') }), sn(nil, { t('='), i(1, '1') }), t('') }) }) })
        ,
        { condition = math }),
    s({ trig = 'nnn' },
        fmt('\\bigcap_{{{}}} ',
            { sn(1, { i(1, 'i'), c(2, { sn(nil, { t(' \\in '), i(1, 'I') }), sn(nil, { t('='), i(1, '1') }), t('') }) }) })
        ,
        { condition = math }),

    s({ trig = 'enum' },
        fmt('\\begin{enumerate}<>\n\\end{enumerate}\n', { d(1, dyn_item_list, {}) }, { delimiters = '<>' })),
    s({ trig = 'itemize' },
        fmt('\\begin{itemize}<>\n\\end{itemize}\n', { d(1, dyn_item_list, {}) }, { delimiters = '<>' })),
    s({ trig = '([%d%a\\_]+)/', regTrig = true, wordTrig = false },
        fmt([[\frac{<>}{<>}]], { l(l.CAPTURE1), i(1) }, { delimiters = '<>' })
        , { condition = math }),
    s({ trig = '(.*%))/', regTrig = true, wordTrig = false },
        fmt([[<>{<>}]], { f(
            function(_, snip)
                local match = snip.captures[1]
                local pos = last_paren_match(match)
                return match:sub(1, pos - 1) .. "\\frac{" .. match:sub(pos + 1, #match - 1) .. "}"
            end
        ), i(1) }, { delimiters = '<>' }),
        {
            condition = function(_, _, captures)
                return last_paren_match(captures[1]) ~= 0
            end
        }),

    s({ trig = '([xyzva])([ijkmn])%2', regTrig = true, wordTrig = false },
        fmt('{}_{{{}}}', { l(l.CAPTURE1), l(l.CAPTURE2) }),
        { condition = math }),
    s({ trig = '(%a)(%d)', regTrig = true, wordTrig = false }, fmt('{}_{}', { l(l.CAPTURE1), l(l.CAPTURE2) }),
        { condition = math }),
    s({ trig = '(%a)_(%d%d)', regTrig = true, wordTrig = false }, fmt('{}_{{{}}}', { l(l.CAPTURE1), l(l.CAPTURE2) }),
        { condition = math }),

    s({ trig = '<([^ ]*)|', regTrig = true },
        fmt('\\bra{{{}}}', { l(l.CAPTURE1:gsub('q', '\\psi'):gsub('f', '\\phi')) })
        ,
        { condition = math }),
    s({ trig = '|([^ ]*)>', regTrig = true },
        fmt('\\ket{{{}}}', { l(l.CAPTURE1:gsub('q', '\\psi'):gsub('f', '\\phi')) }),
        { condition = math }),
    s({ trig = '\\bra{([^ ]*)}([^\\|]*)>', regTrig = true },
        fmt('\\braket{{{}}}{{{}}}', {
            l(l.CAPTURE1:gsub('q', '\\psi'):gsub('f', '\\phi')),
            l(l.CAPTURE2:gsub('q', '\\psi'):gsub('f', '\\phi'))
        }), { condition = math }),

}
