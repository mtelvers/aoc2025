let input =
  In_channel.with_open_text "input" @@ fun ic -> In_channel.input_lines ic

module Outputs = Set.Make (String)
module Racks = Map.Make (String)

let racks =
  List.fold_left
    (fun acc line ->
      String.split_on_char ' ' line |> function
      | hd :: tl ->
          let m = String.sub hd 0 (String.length hd - 1) in
          Racks.add m (Outputs.of_list tl) acc
      | _ -> acc)
    Racks.empty input

let rec dfs = function
  | "out" -> 1
  | r -> Outputs.fold (fun o acc -> acc + dfs o) (Racks.find r racks) 0

let () = dfs "you" |> Printf.printf "Part 1: %i\n"
let memo = Hashtbl.create 1000

let rec dfs ~target r =
  match Hashtbl.find_opt memo r with
  | Some v -> v
  | None ->
      if r = target then 1
      else if r = "out" then 0
      else
        let res =
          Outputs.fold (fun o acc -> acc + dfs ~target o) (Racks.find r racks) 0
        in
        Hashtbl.add memo r res;
        res

let () = Hashtbl.clear memo
let dac_fft = dfs ~target:"fft" "dac"
let () = Hashtbl.clear memo
let fft_dac = dfs ~target:"dac" "fft"
let () = Hashtbl.clear memo
let svr_fft = dfs ~target:"fft" "svr"
let () = Hashtbl.clear memo
let svr_dac = dfs ~target:"dac" "svr"
let () = Hashtbl.clear memo
let fft_out = dfs ~target:"out" "fft"
let () = Hashtbl.clear memo
let dac_out = dfs ~target:"out" "dac"

let () =
  Printf.printf "Part 2: %i\n%!"
    ((svr_dac * dac_fft * fft_out) + (svr_fft * fft_dac * dac_out))
