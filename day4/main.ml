let input =
  In_channel.with_open_text "input" @@ fun ic -> In_channel.input_lines ic

type coord = { y : int; x : int }

module CoordSet = Set.Make (struct
  type t = coord

  let compare = compare
end)

let warehouse =
  input
  |> List.mapi (fun y line ->
         List.init (String.length line) (String.get line)
         |> List.mapi (fun x ch -> ({ y; x }, ch)))
  |> List.flatten
  |> List.filter_map (fun (k, ch) -> match ch with '@' -> Some k | _ -> None)
  |> CoordSet.of_list

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

let is_free_bales w k =
  List.fold_left
    (fun acc d ->
      CoordSet.mem { y = k.y + d.y; x = k.x + d.x } w |> function
      | true -> acc + 1
      | false -> acc)
    0 neighbours
  |> fun bales -> bales < 4

let part1 =
  CoordSet.fold
    (fun k acc -> if is_free_bales warehouse k then acc + 1 else acc)
    warehouse 0

let () = Printf.printf "part 1: %i\n" part1

let rec part2 w =
  CoordSet.fold
    (fun k acc -> if is_free_bales w k then CoordSet.add k acc else acc)
    w CoordSet.empty
  |> fun free_bales ->
  if CoordSet.is_empty free_bales then CoordSet.cardinal w
  else CoordSet.diff w free_bales |> part2

let () =
  Printf.printf "part 2: %i\n" (CoordSet.cardinal warehouse - part2 warehouse)
