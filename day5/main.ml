let input =
  In_channel.with_open_text "input" @@ fun ic -> In_channel.input_lines ic

let fresh, ingredients =
  List.fold_left
    (fun (f, i) line ->
      match String.split_on_char '-' line with
      | l :: h :: _ -> ((int_of_string l, int_of_string h) :: f, i)
      | "" :: _ -> (f, i)
      | v :: _ -> (f, int_of_string v :: i)
      | _ -> (f, i))
    ([], []) input

let part1 =
  List.fold_left
    (fun f i ->
      List.find_opt (fun (l, h) -> i >= l && i <= h) fresh |> function
      | Some _ -> f + 1
      | _ -> f)
    0 ingredients

let () = Printf.printf "part 1: %i\n" part1

let add (low, high) t =
  let rec loop acc (low, high) = function
    | [] -> List.rev ((low, high) :: acc)
    | (l, h) :: tl when h + 1 < low -> loop ((l, h) :: acc) (low, high) tl
    | (l, h) :: tl when high + 1 < l ->
        List.rev_append acc ((low, high) :: (l, h) :: tl)
    | (l, h) :: tl -> loop acc (min l low, max h high) tl
  in
  loop [] (low, high) t

let part2 =
  List.fold_left (fun acc (l, h) -> add (l, h) acc) [] fresh
  |> List.fold_left (fun acc (l, h) -> acc + (h - l + 1)) 0

let () = Printf.printf "part 2: %i\n" part2
