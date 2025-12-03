let input =
  In_channel.with_open_text "input" @@ fun ic -> In_channel.input_lines ic

let banks =
  List.map
    (fun line ->
      List.init (String.length line) (fun i ->
          String.get line i |> String.make 1 |> int_of_string))
    input

let part1 =
  List.fold_left
    (fun acc bank ->
      let rec loop max_left max_right lst =
        match lst with
        | l :: r :: tl ->
            if l > max_left then loop l r (r :: tl)
            else if r > max_right then loop max_left r (r :: tl)
            else loop max_left max_right (r :: tl)
        | _ -> (max_left, max_right)
      in
      let l, r = loop 0 0 bank in
      acc + (10 * l) + r)
    0 banks

let () = Printf.printf "part 1: %i\n" part1
