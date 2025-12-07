let input =
  In_channel.with_open_text "input" @@ fun ic -> In_channel.input_lines ic

type coord = { y : int; x : int }

module CoordMap = Map.Make (struct
  type t = coord

  let compare = compare
end)

let manifold =
  input
  |> List.mapi (fun y line ->
         List.init (String.length line) (String.get line)
         |> List.mapi (fun x ch -> ({ y; x }, ch)))
  |> List.flatten |> CoordMap.of_list

let beams = CoordMap.filter (fun _ ch -> ch = 'S') manifold
let count = ref 0

let rec flow beams =
  let beams =
    CoordMap.fold
      (fun b _ acc ->
        let t = { b with y = b.y + 1 } in
        CoordMap.find_opt t manifold |> function
        | Some '.' -> CoordMap.add t '|' acc
        | Some '^' ->
            incr count;
            acc
            |> CoordMap.add { t with x = t.x + 1 } '|'
            |> CoordMap.add { t with x = t.x - 1 } '|'
        | _ -> acc)
      beams CoordMap.empty
  in
  match CoordMap.is_empty beams with true -> () | false -> flow beams

let () = flow beams
let () = Printf.printf "part 1: %i\n" !count
let memo = Hashtbl.create 1000

let rec dfs b =
  match Hashtbl.find_opt memo b with
  | Some v -> v
  | None -> (
      let t = { b with y = b.y + 1 } in
      CoordMap.find_opt t manifold |> function
      | Some '.' ->
          let r = dfs t in
          Hashtbl.add memo t r;
          r
      | Some '^' ->
          let r = dfs { t with x = t.x + 1 } + dfs { t with x = t.x - 1 } in
          Hashtbl.add memo t r;
          r
      | _ -> 1)

let start, _ =
  CoordMap.filter (fun _ ch -> ch = 'S') manifold |> CoordMap.choose

let part2 = dfs start
let () = Printf.printf "part 2: %i\n" part2
