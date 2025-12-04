# Day 4 - Paper Bale Warehouse

Find the number of `@` which have fewer than four `@` as neighbours.

```
..@@.@@@@.
@@@.@.@.@@
@@@@@.@.@@
@.@@@@..@.
@@.@@@@.@@
.@@@@@@@.@
.@.@.@.@@@
@.@@@.@@@@
.@@@@@@@@.
@.@.@@@.@.
```

I chose	to read the input into a Map, which I have used several times before, so I copied my implementation from AoC 2024 Day 10.

```ocaml
type coord = { y : int; x : int }

module CoordMap = Map.Make (struct
  type t = coord

  let compare = compare
end)
```

I set up a list of directions around the centre point.

```ocaml
let neighbours =
  [
    { y = 1; x = -1 };
    { y = 1; x = 0 };
    { y = 1; x = 1 };
    { y = 0; x = -1 };
    { y = 0; x = 1 };
    { y = -1; x = -1 };
    { y = -1; x = 0 };
    { y = -1; x = 1 };
  ]
```

## Part 1

Fold over the map, and where there is an `@`, I folded over the list of neighbours, counting the number with bales, which could then be summed in the outer fold.

## Part 2

For the second part, the free bales needed to be removed, and then the calculation was repeated, trying again until no more bales could be removed.

At this point, I realised that the map could be simplified to a set, as there is no need to distinguish between the boundary and an empty square.

Therefore, rather than just counting the free bales, I added these to a set which could be subtracted from the original set and iterated.

```ocaml
let rec part2 w =
  CoordSet.fold
    (fun k acc -> if is_free_bales w k then CoordSet.add k acc else acc)
    w CoordSet.empty
  |> fun free_bales ->
  if CoordSet.is_empty free_bales then CoordSet.cardinal w
  else CoordSet.diff w free_bales |> part2

let () =
  Printf.printf "part 2: %i\n" (CoordSet.cardinal warehouse - part2 warehouse)
```
