module Nock (Formula(..), show, reduce) where

-- 1 Context

--  This spec defines one function, Nock. 

-- 2 Structures

--  A noun is an atom or a cell.  
--  An atom is any unsigned integer.  
--  A cell is an ordered pair of any two nouns.

data Formula = Atom Integer | Formula :- Formula | Var String
          | What Formula | S Formula | Eq Formula | Slash Formula | Nock Formula

infixr :- -- Infix notation for cells, like (:) for lists.

-- 3 Pseudocode

instance Show Formula where
    show (Atom a)   = show a
    --  Brackets enclose cells.  [a b c] is [a [b c]].
    show (a :- b)   = "[" ++ showTail (a :- b) ++ "]"
        where showTail (a :- b)   = show a ++ " " ++ showTail b
              showTail a          = show a
    show (What a)   = "?" ++ show a
    show (S a)      = "^" ++ show a
    show (Eq a)     = "=" ++ show a
    show (Slash a)  = "/" ++ show a
    show (Nock a)   = "*" ++ show a
    show (Var s)    = s

-- 4 Reductions

reduce :: Formula -> Formula

--  ?[a b]           => 0
--  ?a               => 1
reduce (What e) = case reduce e of
    (a :- b)         -> Atom 0
    _                -> Atom 1

--  ^[a b]           => ^[a b]
--  ^a               => (a + 1)
reduce (S e) = case reduce e of
    Atom a           -> Atom (a + 1)
    a                -> S a

--  =[a a]           => 0
--  =[a b]           => 1
--  =a               => =a
reduce (Eq e) = case reduce e of
    Atom a :- Atom b -> if a == b then Atom 0 else Atom 1
    a                -> Eq a

--  /[1 a]           => a
--  /[2 a b]         => a
--  /[3 a b]         => b
--  /[(a + a) b]     => /[2 /[a b]]
--  /[(a + a + 1) b] => /[3 /[a b]]
--  /a               => /a
reduce (Slash e) = case reduce e of
    Atom 1 :- a         -> a
    Atom 2 :- a :- b    -> a
    Atom 3 :- a :- b    -> b
    Atom x :- b
      | x > 3 && even x -> reduce (Slash (Atom 2 :- Slash (Atom a :- b)))
      | x > 3 && odd  x -> reduce (Slash (Atom 3 :- Slash (Atom a :- b)))
      where a = div x 2
    a                   -> Slash a

--  *[a 0 b]         => /[b a]
--  *[a 1 b]         => b
--  *[a 2 b c d]     => *[a 3 [0 1] 3 [1 c d] 
--                          [1 0] 3 [1 2 3] [1 0] 5 5 b]
--  *[a 3 b]         => **[a b]
--  *[a 4 b]         => ?*[a b]
--  *[a 5 b]         => ^*[a b]
--  *[a 6 b]         => =*[a b]
--  *[a [b c] d]     => [*[a b c] *[a d]]
--  *a               => *a

reduce (Nock e) = case reduce e of
    a :- Atom 0 :- b   -> reduce (Slash (b :- a))
    a :- Atom 1 :- b   -> b
    a :- Atom 2 :- b :- c :- d
                       -> reduce (Nock (a :- Atom 3 :- (Atom 0 :- Atom 1)
                                          :- Atom 3 :- (Atom 1 :- c :- d)
                                          :- (Atom 1 :- Atom 0) :- Atom 3
                                          :- (Atom 1 :- Atom 2 :- Atom 3)
                                          :- (Atom 1 :- Atom 0)
                                          :- Atom 5 :- Atom 5 :- b))
    a :- Atom 3 :- b   -> reduce (Nock (Nock (a :- b)))
    a :- Atom 4 :- b   -> reduce (What (Nock (a :- b)))
    a :- Atom 5 :- b   -> reduce (S    (Nock (a :- b)))
    a :- Atom 6 :- b   -> reduce (Eq   (Nock (a :- b)))
    a :- (b :- c) :- d -> reduce (Nock (a :- b :- c) :- Nock (a :- d))
    a                  -> Nock a

reduce (a :- b) = reduce a :- reduce b
reduce a        = a
