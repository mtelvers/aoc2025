# Day 8 - Playground

Compute the distance between vectors in 3D space and build them into a graph by linking the closest pairs.

```
162,817,812
57,618,57
906,360,560
592,479,940
352,342,300
466,668,158
542,29,236
431,825,988
739,650,466
52,470,668
216,146,977
819,987,18
117,168,530
805,96,715
346,949,466
970,615,88
941,993,340
862,61,35
984,92,344
425,690,689
```

I read the input in as a list of vectors `type vector = { x : float; y : float; z : float }`. Next, I computed a list of distances between all the pairs, resulting in a `((vector * vector) * float) list`. A network is a set of vectors, and overall, there is a set of networks. I couldn't decide on the best way to store this, so for expediency, I went with sets.

```ocaml
module Network = Set.Make (struct
  type t = vector

  let compare = compare
end)

module NetworkSet = Set.Make (Network) 
```

With this, I wrote a function to join two nodes together. This first checks if either node already existed in any network. If neither node exists, create a new network with those two nodes. If one node exists in any network, then add the other node. If both nodes exist, then union the two networks together. As adding a value to a set is idempotent, it is not necessary to distinguish which value needs to be added: `|> Network.add v1 |> Network.add v2`

```ocaml
let join v1 v2 acc =
  let s1, s2 =
    NetworkSet.partition (fun vs -> Network.mem v1 vs || Network.mem v2 vs) acc
  in  
  NetworkSet.singleton
    (match NetworkSet.cardinal s1 with
    | 0 -> Network.(singleton v1 |> add v2)
    | 1 -> NetworkSet.choose s1 |> Network.add v1 |> Network.add v2
    | 2 -> NetworkSet.fold (fun vs acc -> Network.union acc vs) s1 Network.empty
    | _ -> assert false)
  |> NetworkSet.union s2

```

# Part 1

Take the first 1000 vector pairs and add them to the `NetworkSet`, then convert the `NetworkSet` into a list of the size of each network, sort the list, take the first three and fold over them to get the answer.

# Part 2

Continue adding vector pairs until all the vectors are connected then find the produce of the x coordinate of the final two vectors. I used a recursive function to repeatedly add pairs until the size of the network equalled the total number of vectors.
