let input =
  In_channel.with_open_text "input" @@ fun ic -> In_channel.input_lines ic

let banks =
  List.map
    (fun line ->
      Array.init (String.length line) (fun i ->
          String.get line i |> String.make 1 |> int_of_string))
    input

let calc len =
  List.fold_left
    (fun acc bank ->
      let () = Array.iter (Printf.printf "%i") bank in
      let () = Printf.printf "\n" in
      (List.init len (fun i -> i + 1)
      |> List.rev
      |> List.fold_left_map
           (fun acc size ->
             let chunk =
               Array.sub bank acc (Array.length bank - size - acc + 1)
             in
             let () = Array.iter (Printf.printf "%i") chunk in
             let _, i =
               Array.fold_left
                 (fun (i, max_i) x ->
                   if x > chunk.(max_i) then (i + 1, i) else (i + 1, max_i))
                 (0, 0) chunk
             in
             let () = Printf.printf " -> i=%i [i]=%i\n" i chunk.(i) in
             (i + acc + 1, chunk.(i)))
           0
      |> snd
      |> List.fold_left (fun acc x -> (acc * 10) + x) 0)
      + acc)
    0 banks

let () = Printf.printf "part 1: %i\n" (calc 2)
let () = Printf.printf "part 2: %i\n" (calc 12)
