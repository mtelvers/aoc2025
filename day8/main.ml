let input =
  In_channel.with_open_text "input" @@ fun ic -> In_channel.input_lines ic

type vector = { x : float; y : float; z : float }

let junctions =
  input
  |> List.map (fun line ->
         String.split_on_char ',' line |> function
         | x :: y :: z :: _ ->
             {
               x = float_of_string x;
               y = float_of_string y;
               z = float_of_string z;
             }
         | _ -> assert false)

let njunctions = List.length junctions

let distance v1 v2 =
  Float.sqrt
    (Float.pow (v2.x -. v1.x) 2.
    +. Float.pow (v2.y -. v1.y) 2.
    +. Float.pow (v2.z -. v1.z) 2.)

let rec calc = function
  | _ :: [] -> []
  | v1 :: rest ->
      List.map (fun v2 -> ((v1, v2), distance v1 v2)) rest @ calc rest
  | _ -> assert false

let sorted = calc junctions |> List.sort (fun (_, d1) (_, d2) -> compare d1 d2)

module Network = Set.Make (struct
  type t = vector

  let compare = compare
end)

module NetworkSet = Set.Make (Network)

let rec take n lst =
  match lst with
  | [] -> []
  | x :: xs -> if n <= 0 then [] else x :: take (n - 1) xs

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

let () =
  sorted |> take 10
  |> List.fold_left (fun acc ((v1, v2), _) -> join v1 v2 acc) NetworkSet.empty
  |> fun vss ->
  NetworkSet.fold (fun vs acc -> Network.cardinal vs :: acc) vss []
  |> List.sort compare |> List.rev |> List.take 3 |> List.fold_left Int.mul 1
  |> Printf.printf "part 1: %i\n"

let rec loop acc = function
  | ((v1, v2), _) :: tl ->
      let acc = join v1 v2 acc in
      let size = Network.cardinal (NetworkSet.choose acc) in
      if size = njunctions then v1.x *. v2.x else loop acc tl
  | _ -> assert false

let () = loop NetworkSet.empty sorted |> Printf.printf "part 2: %.0f\n"
