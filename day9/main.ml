let input =
  In_channel.with_open_text "input" @@ fun ic -> In_channel.input_lines ic

type vertex = { x : int; y : int }

let area v1 v2 = (1 + abs (v2.x - v1.x)) * (1 + abs (v2.y - v1.y))

let rec calc = function
  | _ :: [] -> []
  | v1 :: rest -> List.map (fun v2 -> ((v1, v2), area v1 v2)) rest @ calc rest
  | _ -> assert false

let red_tiles =
  input
  |> List.map (fun line ->
         String.split_on_char ',' line |> function
         | x :: y :: _ -> { x = int_of_string x; y = int_of_string y }
         | _ -> assert false)

let sorted = calc red_tiles |> List.sort (fun (_, d1) (_, d2) -> compare d2 d1)
let () = Printf.printf "Part 1: %i\n" (List.hd sorted |> snd)

let edges polygon =
  match polygon with
  | [] -> []
  | _ ->
      let last = List.(hd (rev polygon)) in
      let edges, _ =
        List.fold_left
          (fun (acc, v1) v2 -> ((v1, v2) :: acc, v2))
          ([], last) polygon
      in
      edges

let cross a b c = ((b.x - a.x) * (c.y - a.y)) - ((b.y - a.y) * (c.x - a.x))

type point_status = On_edge | Crossings of int

let point_in_polygon p edges =
  List.fold_left
    (fun state (v1, v2) ->
      match state with
      | On_edge -> On_edge
      | Crossings count ->
          let on_segment =
            cross v1 p v2 = 0
            && p.x >= min v1.x v2.x
            && p.x <= max v1.x v2.x
            && p.y >= min v1.y v2.y
            && p.y <= max v1.y v2.y
          in
          if on_segment then On_edge
          else if v1.y > p.y <> (v2.y > p.y) then
            let dx = v2.x - v1.x in
            let dy = v2.y - v1.y in
            let lhs = (p.x - v1.x) * dy in
            let rhs = (p.y - v1.y) * dx in
            let crosses = if dy > 0 then lhs < rhs else lhs > rhs in
            Crossings (if crosses then count + 1 else count)
          else state)
    (Crossings 0) edges
  |> function
  | On_edge -> true
  | Crossings n -> n mod 2 = 1

let segments_properly_intersect a b c d =
  let sign n = compare n 0 in
  let d1 = sign (cross c a d) in
  let d2 = sign (cross c b d) in
  let d3 = sign (cross a c b) in
  let d4 = sign (cross a d b) in
  d1 <> d2 && d1 <> 0 && d2 <> 0 && d3 <> d4 && d3 <> 0 && d4 <> 0

let polygon_within outer inner =
  let outer_edges = edges outer in
  let inner_edges = edges inner in
  List.for_all (fun p -> point_in_polygon p outer_edges) inner
  && not
       (List.exists
          (fun (a, b) ->
            List.exists
              (fun (c, d) -> segments_properly_intersect a b c d)
              inner_edges)
          outer_edges)

let rec calc = function
  | _ :: [] -> []
  | v1 :: rest ->
      List.filter_map
        (fun v2 ->
          [
            { x = min v1.x v2.x; y = min v1.y v2.y };
            { x = min v1.x v2.x; y = max v1.y v2.y };
            { x = max v1.x v2.x; y = max v1.y v2.y };
            { x = max v1.x v2.x; y = min v1.y v2.y };
          ]
          |> polygon_within red_tiles
          |> function
          | true -> Some ((v1, v2), area v1 v2)
          | false -> None)
        rest
      @ calc rest
  | _ -> assert false

let sorted = calc red_tiles |> List.sort (fun (_, d1) (_, d2) -> compare d2 d1)
let () = Printf.printf "Part 2: %i\n" (List.hd sorted |> snd)
