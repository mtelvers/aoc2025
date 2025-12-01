let input =
  In_channel.with_open_text "input" @@ fun ic -> In_channel.input_lines ic

type dir = Left of int | Right of int

let input =
  List.map
    (fun line ->
      Scanf.sscanf line " %c%i " @@ fun c i ->
      match c with 'L' -> Left i | 'R' -> Right i | _ -> assert false)
    input

type foo = { sum : int; zero : int; passing : int }

let r =
  List.fold_left
    (fun acc t ->
      match t with
      | Left x ->
          let y = x / 100 in
          let x = x mod 100 in
          let sum = acc.sum - x in
          let passing =
            if sum < 0 && acc.sum > 0 then acc.passing + y + 1
            else acc.passing + y
          in
          let sum = if sum < 0 then sum + 100 else sum in
          let zero = if sum = 0 then acc.zero + 1 else acc.zero in
          { sum; zero; passing }
      | Right x ->
          let y = x / 100 in
          let x = x mod 100 in
          let sum = acc.sum + x in
          let passing =
            if sum > 100 then acc.passing + y + 1 else acc.passing + y
          in
          let sum = if sum >= 100 then sum - 100 else sum in
          let zero = if sum = 0 then acc.zero + 1 else acc.zero in
          { sum; zero; passing })
    { sum = 50; zero = 0; passing = 0 }
    input

let () = Printf.printf "part 1: %i\n" r.zero
let () = Printf.printf "part 2: %i\n" (r.zero + r.passing)
