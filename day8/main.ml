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

let () =
  List.iter
    (fun ((v1, v2), d) ->
      Printf.printf "(%.0f,%.0f,%.0f) -> (%.0f,%.0f,%.0f) = %.2f\n" v1.x v1.y
        v1.z v2.x v2.y v2.z d)
    sorted

module VectorSet = Set.Make (struct
  type t = vector

  let compare = compare
end)

module VectorSetSet = Set.Make (VectorSet)

(*
let print x =
        Printf.printf "=====\n";
  VectorSetSet.iter
    (fun vs ->
      VectorSet.iter (fun v -> Printf.printf "(%.0f,%.0f,%.0f)," v.x v.y v.z) vs;
      Printf.printf "\n") x;
        Printf.printf "=====\n"
        *)

let rec take n lst =
  match lst with
  | [] -> []
  | x :: xs -> if n <= 0 then [] else x :: take (n - 1) xs

let r =
  sorted |> take 1000
  |> List.fold_left
       (fun acc ((v1, v2), _) ->
         (*     print acc; *)
         let s1, s2 =
           VectorSetSet.partition
             (fun vs -> VectorSet.mem v1 vs || VectorSet.mem v2 vs)
             acc
         in
         VectorSetSet.singleton
           (match VectorSetSet.cardinal s1 with
           | 0 -> VectorSet.(empty |> add v1 |> add v2)
           | 1 -> VectorSetSet.choose s1 |> VectorSet.add v1 |> VectorSet.add v2
           | 2 ->
               VectorSetSet.fold
                 (fun vs acc -> VectorSet.union acc vs)
                 s1 VectorSet.empty
           | _ -> assert false)
         |> VectorSetSet.union s2)
       VectorSetSet.empty

let () =
  VectorSetSet.fold (fun vs acc -> VectorSet.cardinal vs :: acc) r []
  |> List.sort compare |> List.rev |> List.take 3 |> List.fold_left Int.mul 1
  |> Printf.printf "part 1: %i\n"

