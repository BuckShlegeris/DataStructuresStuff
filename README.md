DataStructureMagicThing
======


This is software which finds the generating function of a data structure. For example, [see here]([http://math.ucr.edu/home/baez/week144.html) (Ctrl-F for "To figure out a formula").

I wrote it to accompany my [talk](http://www.youtube.com/watch?v=OB73WLf1k9c) at CompCon about the algebraic behaviour of data structures. I use this package about halfway through that talk.

## Dependencies

I use the GHC parser. You have to install the Language.Haskell.Exts library to use it. Apart from that, only dependencies are GHC, Python 2, and bash.

You need to run setup.sh once before you use the code.

## Usage

1. Edit dataExamples.hs
2. python generatingFunctions.py

## Example

```bash
$ python generatingFunctions.py
Analysing Maybe:
Equation solution:
a + 1
Power series expansion:
a + 1

Analysing List:
Equation solution:
-1/(a - 1)
Power series expansion:
1 + a + a**2 + a**3 + a**4 + a**5 + a**6 + a**7 + a**8 + a**9 + a**10 + a**11 + O(a**12)

Analysing BTree:
Equation solution:
(-sqrt(-4*a + 1) + 1)/(2*a)
Power series expansion:
1 + a + 2*a**2 + 5*a**3 + 14*a**4 + 42*a**5 + 132*a**6 + 429*a**7 + 1430*a**8 + 4862*a**9 + 16796*a**10 + 58786*a**11 + O(a**12)
```

## "Application" to combinatorics

Suppose we have two bigger bins and two smaller bins, and four basketballs. The bigger bins fit up to two basketballs, but the smaller bins only fit one. We want to know how many different ways we can put all the basketballs in bins. Take a look at this ~~shitty drawing~~ useful illustration:

![shitty drawing](http://i.imgur.com/STnv04c.png)

We can represent a big bin like this:

```haskell
data BigBin a = BigBinWithTwoThings a a | BigBinWithOneThing a | EmptyBigBin
```

Let's stick that in the `dataExamples.hs` file:

```
$ python generatingFunctions.py
Analysing BigBin:
Equation solution:
a**2 + a + 1
Power series expansion:
a**2 + a + 1
```

That's looking good: a `BigBin` has 0, 1, or 2 things.

Similarly, a little bin can be defined as:

```haskell
data LittleBin a = LittleBinWithOneThing a | EmptyLittleBin
```

This is isomorphic to the `Maybe` type.

Now, the entire system of two little bins and one big bin can be represented like this:

```haskell
data Containers a = Containers (BigBin a) (BigBin a) (LittleBin a) (LittleBin a)
```

So let's run the program again:

```
$ python generatingFunctions.py
Analysing BigBin:
Equation solution:
a**2 + a + 1
Power series expansion:
a**2 + a + 1

Analysing LittleBin:
Equation solution:
a + 1
Power series expansion:
a + 1

Analysing Containers:
Equation solution:
(a + 1)**2*(a**2 + a + 1)**2
Power series expansion:
a**6 + 4*a**5 + 8*a**4 + 10*a**3 + 8*a**2 + 4*a + 1
```

This tells us that there's 1 way to fit 6 balls in these containers, 4 ways to fit 5, 8 ways to fit 4, and so on. We read the answer to our question straight off that power series: there are eight different ways to fit four balls in those containers.
