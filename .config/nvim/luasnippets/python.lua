local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt
return {}, {
    s({ trig = 'ctfpwn' },
        fmt([[
#!/usr/bin/env python3
from pwn import *
context.terminal = ["tmux", "splitw", "-h"]
name = "./{}"
e = context.binary = ELF(name)
if args["REMOTE"]:
	p = remote("{}", {})
else:
	p = process(name)
	if args["GDB"]:
		gdb.attach(p, "c")

        ]], { i(1), i(2), i(3) })
    ),

    s({ trig = 'ctflibc' },
        fmt([[
if args["REMOTE"]:
	libc = ELF("./{}")
else:
	libc = p.libc
    libc.address = 0

        ]], { i(1, 'libc.so.6') })
    ),
}
