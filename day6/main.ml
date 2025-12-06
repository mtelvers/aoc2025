let input =
  In_channel.with_open_text "input" @@ fun ic -> In_channel.input_lines ic

let input =
  List.map
    (fun line ->
      String.split_on_char ' ' line
      |> List.filter_map (function "" -> None | s -> Some s))
    input

let rec transpose = function
  | [] | [] :: _ -> []
  | rows -> List.map List.hd rows :: transpose (List.map List.tl rows)

let normal_lines = transpose input

let part1 =
  List.fold_left
    (fun acc calculation ->
      let calc = List.rev calculation in
      let initial, operator =
        match List.hd calc with
        | "*" -> (1, Int.mul)
        | "+" -> (0, Int.add)
        | _ -> assert false
      in
      acc
      + List.fold_left
          (fun acc num -> operator acc (int_of_string num))
          initial (List.tl calc))
    0 normal_lines

let () = Printf.printf "part 1: %i\n" part1
