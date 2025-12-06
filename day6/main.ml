let input =
  In_channel.with_open_text "input" @@ fun ic -> In_channel.input_lines ic

let rec transpose = function
  | [] | [] :: _ -> []
  | rows -> List.map List.hd rows :: transpose (List.map List.tl rows)

let () =
  input
  |> List.map (fun line ->
         String.split_on_char ' ' line
         |> List.filter_map (function "" -> None | s -> Some s))
  |> transpose
  |> List.fold_left
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
       0
  |> Printf.printf "part 1: %i\n"

let rec split_last = function
  | [] -> assert false
  | [ x ] -> ([], x)
  | x :: xs ->
      let init, last = split_last xs in
      (x :: init, last)

let () =
  input
  |> List.map (fun line ->
         List.init (String.length line) (fun i -> String.sub line i 1))
  |> transpose
  |> List.fold_left
       (fun (acc, last_operator, v) line ->
         let line, operator = split_last line in
         let v, op =
           match operator with
           | "*" -> (1, Int.mul)
           | "+" -> (0, Int.add)
           | _ -> (v, Option.get last_operator)
         in
         String.concat "" line |> String.trim |> function
         | "" -> (acc + v, Some op, v)
         | s -> (acc, Some op, op v (int_of_string s)))
       (0, None, 0)
  |> fun (sum, _, v) -> Printf.printf "part 2: %i\n" (sum + v)
