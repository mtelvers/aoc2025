# Day 11 - Reactor

Count the number of paths to traverse a graph.

# Part 1

```
aaa: you hhh
you: bbb ccc
bbb: ddd eee
ccc: ddd eee fff
ddd: ggg
eee: out
fff: out
ggg: out
hhh: ccc fff iii
iii: out
```

In the first part, the task was to count the number of many ways to get from `you` to `out`. There aren't many, so a simple depth-first search worked out of the box.

```ocaml
module Outputs = Set.Make (String)
module Racks = Map.Make (String)

let rec dfs = function
  | "out" -> 1
  | r -> Outputs.fold (fun o acc -> acc + dfs o) (Racks.find r racks) 0

let () = dfs "you" |> Printf.printf "Part 1: %i\n"
```

# Part 2

The examples for the second part unusually gave new data. However, the puzzle input was the same. The new example data removed the `you` node and added an `svr` node. The question is now, how many ways from `svr` to `out`, but passing through `fft` and `dac`?

```
svr: aaa bbb
aaa: fft
fft: ccc
bbb: tty
tty: ccc
ccc: ddd eee
ddd: hub
hub: fff
eee: dac
dac: fff
fff: ggg hhh
ggg: out
hhh: out
```

On my actual dataset, the number of ways from `svr` to `out` was vast (45 quadrillion), so we definitely need memoisation. The key here was to realise that it was a DAG and so either `dac` to `fft` was possible or `fft` to `dac` was possible, but not both.

Using a DFS I calculated the number of paths between the key components and simplied the graph to four nodes. Since `dac` to `fft` has zero paths, the path must be `svr` to `fft` to `dac` to `out`. Thus the solution is `1 * 1 * 2 = 2`.

```
                   ┌─────┐
                   │ svr │
                   └──┬──┘
            ┌─────────┴─────────┐
            │                   │
          2 │                   │ 1
            │                   │
            ▼         0         ▼
         ┌─────┐ ──────────► ┌─────┐
         │ dac │      1      │ fft │
         └──┬──┘ ◄────────── └──┬──┘
            │                   │
          2 │                   │ 4
            │                   │
            │      ┌─────┐      │
            └────► │ out │ ◄────┘
                   └─────┘
```

