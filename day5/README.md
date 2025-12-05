# Day 5 - Cafeteria

Count the number of elements from the second list which appear in the list of (inclusive) ranges.

```
3-5
10-14
16-20
12-18

1
5
8
11
17
32
```

## Part 1

I read the input data into two variables, `fresh` as a list of pairs for the ranges and `ingredients` as an int list. For part one, it's just a case of summing values where the ingredient falls within the range:

```ocaml
let part1 =
  List.fold_left
    (fun f i ->
      List.find_opt (fun (l, h) -> i >= l && i <= h) fresh |> function
      | Some _ -> f + 1
      | _ -> f)
    0 ingredients
```

## Part 2

Ignoring the second list, count the values represented by the list of ranges. `3-5,10-14` would be a `3 + 5 = 8`. I didn't verify this, but it is likely that the actual input ranges aren't as tidy as the example data. We are told that ranges overlap, but I expect there will be ranges that entirely encompass other ranges, as well as ranges that are immediately adjacent, and so on. I wrote an `add` function to add a range to a list of ranges. I think it would have looked better using `type range = { low: int; high: int }`, but I'd come this far using pairs.

```ocaml
let add (low, high) t =
  let rec loop acc (low, high) = function
    | [] -> List.rev ((low, high) :: acc)
    | (l, h) :: tl when h + 1 < low -> loop ((l, h) :: acc) (low, high) tl
    | (l, h) :: tl when high + 1 < l ->
        List.rev_append acc ((low, high) :: (l, h) :: tl)
    | (l, h) :: tl -> loop acc (min l low, max h high) tl
  in
  loop [] (low, high) t
```

I wrote some test cases to cover the weird cases not present in the example data.

```ocaml
[] |> add (2, 5) |> add (7, 9);;                 # simple [(2, 5); (7, 9)]
[] |> add (2, 5) |> add (7, 9) |> add (4, 8);;   # join [(2, 9)]
[] |> add (2, 5) |> add (7, 9) |> add (1, 10);;  # encompass [(1, 10)]
[] |> add (2, 5) |> add (6, 9);;                 # adjacent [(2, 9)]
```

With the code tested, part 2 used the `add` function to create a combined list, and then summed the difference between the high and low values + 1. 

```ocaml
let part2 =
  List.fold_left (fun acc (l, h) -> add (l, h) acc) [] fresh
  |> List.fold_left (fun acc (l, h) -> acc + (h - l + 1)) 0
```
