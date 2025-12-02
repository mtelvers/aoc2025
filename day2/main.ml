let input =
  In_channel.with_open_text "input" @@ fun ic -> In_channel.input_lines ic

let pairs =
  String.concat "" input |> String.split_on_char ','
  |> List.map (fun pair ->
         String.split_on_char '-' pair |> List.map int_of_string)

let is_odd x = x land 1 = 1

let rec pow a = function
  | 0 -> 1
  | 1 -> a
  | n ->
      let b = pow a (n / 2) in
      b * b * if is_odd n then a else 1

let check l h =
  let rec loop x =
    if x > h then 0
    else
      let len = 1 + int_of_float (log10 (float_of_int x)) in
      if is_odd len then loop (x + 1)
      else
        let base = pow 10 (len / 2) in
        if x / base = x mod base then x + loop (x + 1) else loop (x + 1)
  in
  loop l

let part1 =
  List.fold_left
    (fun sum pair ->
      match pair with l :: h :: _ -> sum + check l h | _ -> assert false)
    0 pairs

let () = Printf.printf "part 1: %i\n" part1
