let input =
  In_channel.with_open_text "input" @@ fun ic -> In_channel.input_lines ic

let pair_of_list = function [ a; b ] -> (a, b) | _ -> assert false

let problems, tiles =
  List.partition (fun line -> String.index_opt line 'x' |> Option.is_some) input

let tiles =
  let rec loop = function
    | [] -> []
    | a :: b :: c :: tl ->
        String.fold_left
          (fun acc ch -> if ch = '#' then acc + 1 else acc)
          0
          (a ^ b ^ c)
        :: loop tl
    | _ -> assert false
  in
  List.partition (fun line -> String.length line = 3) tiles |> fun (g, _) ->
  loop g |> Array.of_list

let () =
  List.fold_left
    (fun acc problem ->
      let chunks = String.split_on_char ' ' problem in
      let hd = List.hd chunks in
      let w, h =
        String.sub hd 0 (String.length hd - 1)
        |> String.split_on_char 'x' |> List.map int_of_string |> pair_of_list
      in
      let area = w * h in
      let tile_area =
        List.tl chunks
        |> List.mapi (fun i n -> tiles.(i) * int_of_string n)
        |> List.fold_left (fun sum x -> sum + x) 0
      in
      if area >= tile_area then acc + 1 else acc)
    0 problems
  |> Printf.printf "Part 1: %i\n"
