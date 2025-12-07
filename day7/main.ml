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

let print x b =
  let _ =
    CoordMap.fold
      (fun p c lasty ->
        if p.y <> lasty then Printf.printf "\n";
        let c = match CoordMap.find_opt p b with Some c -> c | None -> c in
        Printf.printf "%c" c;
        p.y)
      x 0
  in
  Printf.printf "\n"

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
  match CoordMap.is_empty beams with
  | true -> ()
  | false ->
      let () = print manifold beams in
      flow beams

let () = flow beams
let () = Printf.printf "part 1: %i\n" !count
