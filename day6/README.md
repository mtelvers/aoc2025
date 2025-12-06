# Day 6 - Trash Compactor

Sum the cryptically presented equations.

```
123 328  51 64 
 45 64  387 23 
  6 98  215 314
*   +   *   +  
```

# Part 1

Apply the operator at the bottom of the column to the numbers above it and sum the results.

This was a straightforward case of reading a list of lines, then splitting it up into a list of lists of numbers, resulting in a kind of matrix. Use a transpose function and then apply the operator on each list using a fold operation. Note that it's just addition and multiplication, both of which are commutative.

```ocaml
let rec transpose = function
  | [] | [] :: _ -> []
  | rows -> List.map List.hd rows :: transpose (List.map List.tl rows)
```

# Part 2

It was odd in the original input that sometimes there was one space between the numbers, while other times there were two. This all became clear in part 2, as the problem was reframed that the numbers themselves were also transposed. Thus, the far right column was actually `4 + 431 + 623`.

Reading the input as characters and transposing it resulted in, what is in effect, the part 1 problem, but the data structure isn't pretty.

```
1  *
24  
356 
    
369+
248 
8   
    
 32*
581 
175 
    
623+
431 
  4 
```

I can see that you could write a conversion function for both the part 1 and the transposed part 2 structure into a standard format and use the same processing function to sum both datasets, but I didn't!

I created a `split_last` function to from the last element from each row (list).

```ocaml
let rec split_last = function
  | [] -> assert false
  | [ x ] -> ([], x)
  | x :: xs ->
      let init, last = split_last xs in
      (x :: init, last)
```

This gives me the operator plus a list of characters. The list of characters can be concatenated, trimmed and converted into a number. Then, using an inelegant fold which threads the operator, the intermediate sum and the overall sum, you can calculate the answer.
