Mynock
======

This is an interpreter for C. Guy Yarvin's [Nock][1] language.  (For a longer
explanation of Yarvin's rationale for Nock, see [Urbit: functional programming
from scratch][2].)

I haven't written a parser for Nock pseudocode yet, so at the moment you'll
need to enter Nock formulas as Haskell code.  Load the Nock module into ghci:

    ghci Nock.hs

and then enter and evaluate Nock formulas at the prompt:

    > let x = (Nock (Atom 2 :- Atom 0 :- Atom 1))
    > x
    *[2 0 1]
    > reduce x                                   
    2

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
