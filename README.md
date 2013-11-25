Readme
======


This is software which finds the generating function of a data structure. For example, [see here]([http://math.ucr.edu/home/baez/week144.html) (Ctrl-F for "To figure out a formula").

I wrote it to accompany my [talk](http://www.youtube.com/watch?v=OB73WLf1k9c) at CompCon about the algebraic behaviour of data structures. I use this package about halfway through that talk.

## Dependencies

I use the GHC parser. You have to install the Language.Haskell.Exts library to use it. Apart from that, only dependencies are GHC, Python 2, and bash.

You need to run setup.sh once before you use the code.

## Usage

1. Edit dataExamples.hs
2. python generatingFunctions.py
