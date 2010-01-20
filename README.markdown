Mynock
======

This is an interpreter for C. Guy Yarvin's [Nock][1] language, written in
Haskell.  (For a longer explanation of Yarvin's rationale for Nock, see
[Urbit: functional programming from scratch][2].)

For a simple Nock REPL, just load the Parser module in ghci:

    ghci Parser.hs

and then use the "eval" function to parse and reduce Nock formulas:

    > eval "=[1 *[3 1 1]]"
    0
    > eval "*[[4 5 6] 0 3]"
    [5 6]

That's it!  Enjoy.

Copyright
---------

To the extent possible under law, [Matt Brubeck][3] has [waived][4] all copyright
and related or neighboring rights to Mynock. This work is published from the
United States.

[1]: http://moronlab.blogspot.com/2010/01/nock-maxwells-equations-of-software.html
[2]: http://moronlab.blogspot.com/2010/01/urbit-functional-programming-from.html
[3]: http://limpet.net/mbrubeck/
[4]: http://creativecommons.org/publicdomain/zero/1.0/
