let input =
  In_channel.with_open_text "input" @@ fun ic -> In_channel.input_lines ic

let pairs =
  String.concat "" input |> String.split_on_char ','
  |> List.map (fun pair ->
         String.split_on_char '-' pair |> List.map int_of_string |> function
         | a :: b :: _ -> (a, b)
         | _ -> assert false)

let is_odd x = x land 1 = 1

let rec pow a = function
  | 0 -> 1
  | 1 -> a
  | n ->
      let b = pow a (n / 2) in
      b * b * if is_odd n then a else 1

let factors n =
  let root = int_of_float (sqrt (float_of_int n)) in
  let rec loop x =
    if x > root then []
    else if n mod x > 0 then loop (x + 1)
    else if x = n / x || x = 1 then x :: loop (x + 1)
    else x :: (n / x) :: loop (x + 1)
  in
  loop 1

let factors2 n = if is_odd n then [] else [ n / 2 ]

let check fn l h =
  let rec loop x =
    if x > h then 0
    else
      let len = 1 + int_of_float (log10 (float_of_int x)) in
      let fl = fn len in
      List.fold_left
        (fun acc f ->
          let base = pow 10 f in
          let modulo = x mod base in
          let rec loop2 v =
            if v = 0 then true
            else if v mod base = modulo then loop2 (v / base)
            else false
          in
          acc || loop2 (x / base))
        false fl
      |> function
      | false -> loop (x + 1)
      | true -> x + loop (x + 1)
  in
  loop (max l 10)

let part1 = List.fold_left (fun sum (l, h) -> sum + check factors2 l h) 0 pairs
let () = Printf.printf "part 1: %i\n" part1
let part2 = List.fold_left (fun sum (l, h) -> sum + check factors l h) 0 pairs
let () = Printf.printf "part 2: %i\n" part2
