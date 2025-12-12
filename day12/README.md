# Day 12 - Christmas Tree Farm

```
0:
###
##.
##.

1:
###
##.
.##

2:
.##
###
##.

3:
##.
###
##.

4:
###
#..
###

5:
###
.#.
###

4x4: 0 0 0 0 2 0
12x5: 1 0 1 0 2 2
12x5: 1 0 1 0 3 2
```

This is a packing problem. Given this input, `12x5: 1 0 1 0 2 2`, take a 12x5 grid and try to place 1 copy of shape 0, 1 copy of shape 2, 2 copies each of shapes 4 and 5.

On face value, this is a variation on the pentominoes problem, and the packing does not need to be complete. Fortunately, I looked at the real dataset before coding up a depth-first search to place the objects.

My first line of actual input is `45x41: 52 43 45 41 47 59`, still with 3x3 shapes to be placed. This is a massive problem space. Google has shown that Knuth's Dancing Links is a common approach for this, and OCaml/opam has a [combine](https://opam.ocaml.org/packages/combine/) package that implements this. I read the input data and passed it to the library to solve. However, the problem was too large.

As there are so many ways to pack the shapes, may there always be a solution at this scale? I used a simplistic area calculation to try this. I calculated the area of each shape, multiplied it by the number of copies and compared it to the area of the grid. Rightly or wrongly, this gave the correct answer to the problem on the real dataset (but not on the test input)

