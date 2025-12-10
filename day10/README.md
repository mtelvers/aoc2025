# Day 10 - Factory

The input is a pattern of lights, followed by a list of buttons and which lights they turn on and finally a list of counter values.

```
[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
[...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}
[.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}
```

# Part 1

Press the buttons to toggle the lights on/off until you achieve the target pattern. The lights are a target bit pattern (but in reverse order), and the button positions are bit positions. So, `(1,3)` means toggle bits 1 and 3. The problem then becomes a breadth-first search through all the possible options. Starting at 0, xor that once for each button, then xor each of those with all the buttons again. This width grows quickly, but there aren't many bit positions, so it only takes a few iterations to cover all the possible values. I used a set of integers to store the values at each iteration.

# Part 2

In part two, there are n counters set to zero; you need to increment the counters until you get to the values specified in the final field of the input data. Pressing button `(1,3)` increments counters 1 and 3 by one. You might view this as an extension of the first problem, but since the counter target values range from 1 to 300, the problem depth is too great to be solved naively using a BFS.

Looking at the first example in more detail, I rewrote it like this:

```
btn | 0 1 2 3 | index
----+---------+----
3   | 0 0 0 1 | 5
1,3 | 0 1 0 1 | 4
2   | 0 0 1 0 | 3
2,3 | 0 0 1 1 | 2
0,2 | 1 0 1 0 | 1
0,1 | 1 1 0 0 | 0
----+---------+----
    | 3 5 4 7
```

From that matrix, a set of equations can be written as

```
v0 + v1 = 3
v0 + v4 = 5
v1 + v2 + v3 = 4
v2 + v4 + v5 = 7
```

These linear equations need to be solved, and the minimum sum solution found. I used the package [lp](https://opam.ocaml.org/packages/lp/) to do this.

```ocaml
#require "lp";;
#require "lp-glpk";;
open Lp

let v = Array.init 6 (fun i -> var ~integer:true (Printf.sprintf "v%d" i))
  
let sum indices = 
  List.fold_left (fun acc i -> acc ++ v.(i)) (c 0.0) indices 
  
let obj = minimize (sum [0; 1; 2; 3; 4; 5])   (* sum of all variables *)

let constraints = [
  sum [0; 1] =~ c 3.0;       (* v0 + v1 = 3 *)
  sum [0; 4] =~ c 5.0;       (* v0 + v4 = 5 *)
  sum [1; 2; 3] =~ c 4.0;    (* v1 + v2 + v3 = 4 *)
  sum [2; 4; 5] =~ c 7.0;    (* v2 + v4 + v5 = 7 *)
]
  
let problem = make obj constraints

let () =
  match Lp_glpk.solve problem with
  | Ok (obj_val, xs) ->
      Printf.printf "Minimum: %.2f\n" obj_val;
      Array.iteri (fun i var ->
        Printf.printf "v%d = %.2f\n" i (PMap.find var xs)
      ) v
  | Error msg ->
      print_endline msg
```

This gives the solution as 10.

```
GLPK Simplex Optimizer 5.0
4 rows, 6 columns, 10 non-zeros
      0: obj =   0.000000000e+00 inf =   1.900e+01 (4)
      4: obj =   1.000000000e+01 inf =   0.000e+00 (0)
OPTIMAL LP SOLUTION FOUND
GLPK Integer Optimizer 5.0
4 rows, 6 columns, 10 non-zeros
6 integer variables, none of which are binary
Integer optimization begins...
Long-step dual simplex will be used
+     4: mip =     not found yet >=              -inf        (1; 0)
+     4: >>>>>   1.000000000e+01 >=   1.000000000e+01   0.0% (1; 0)
+     4: mip =   1.000000000e+01 >=     tree is empty   0.0% (0; 1)
INTEGER OPTIMAL SOLUTION FOUND
Minimum: 10.00
v0 = 3.00
v1 = 0.00
v2 = 4.00
v3 = 0.00
v4 = 2.00
v5 = 1.00
```

All that is left is to sum the answer for each line of input.
