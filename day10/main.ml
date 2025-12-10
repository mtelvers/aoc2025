let input =
  In_channel.with_open_text "input" @@ fun ic -> In_channel.input_lines ic

let trim_brackets s = String.sub s 1 (String.length s - 2)

type machine = { lights : int; buttons : int list; joltage : float list }

let machines =
  List.map
    (fun line ->
      let split = String.split_on_char ' ' line in
      let lights =
        List.hd split |> trim_brackets |> fun s ->
        String.fold_right
          (fun ch x -> (x lsl 1) lor if ch = '#' then 1 else 0)
          s 0
      in
      let rev = List.rev (List.tl split) in
      let joltage =
        List.hd rev |> trim_brackets |> String.split_on_char ','
        |> List.map float_of_string
      in
      let buttons =
        List.rev (List.tl rev)
        |> List.map (fun s ->
               trim_brackets s |> String.split_on_char ','
               |> List.map int_of_string
               |> List.fold_left (fun x b -> x lor (1 lsl b)) 0)
      in
      { lights; buttons; joltage })
    input

module IntSet = Set.Make (Int)

let rec bfs m acc =
  let new_set =
    IntSet.fold
      (fun v set ->
        List.fold_left (fun set b -> IntSet.add (v lxor b) set) set m.buttons)
      acc IntSet.empty
  in
  if IntSet.mem m.lights new_set then 1 else 1 + bfs m new_set

let () =
  List.fold_left (fun acc m -> acc + bfs m (IntSet.singleton 0)) 0 machines
  |> Printf.printf "Part 1: %i\n%!"

let () =
  List.fold_left
    (fun total m ->
      let open Lp in
      let v =
        Array.init (List.length m.buttons) (fun i ->
            var ~integer:true (Printf.sprintf "button%d" i))
      in
      let sum indices =
        List.fold_left (fun acc i -> acc ++ v.(i)) (c 0.0) indices
      in
      let obj = minimize (sum (List.init (Array.length v) (fun i -> i))) in
      let constraints =
        List.mapi
          (fun i y ->
            let indicies =
              List.mapi
                (fun j x ->
                  if x land (1 lsl i) > 0 then
                    Some (List.length m.buttons - j - 1)
                  else None)
                m.buttons
              |> List.filter_map (fun v -> v)
            in
            sum indicies =~ c y)
          m.joltage
      in
      let problem = make obj constraints in
      match Lp_glpk.solve problem with
      | Ok (obj_val, _) ->
          total +. obj_val
      | Error msg ->
          print_endline msg;
          total)
    0. machines
  |> Printf.printf "Part 2: %.0f\n"
