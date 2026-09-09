let state_file = "seen.txt"

let read_seen () =
  if Sys.file_exists state_file then
    In_channel.with_open_text state_file In_channel.input_all
    |> String.split_on_char '\n'
    |> List.filter (fun s -> s <> "")
  else []

let append_seen ids =
  if ids <> [] then
    Out_channel.with_open_gen
      [ Open_append; Open_creat ]
      0o644 state_file
      (fun oc ->
        List.iter (fun id -> Out_channel.output_string oc (id ^ "\n")) ids)
