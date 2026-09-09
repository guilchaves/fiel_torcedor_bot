open Fiel_bot.Game

let () =
  let html =
    In_channel.with_open_text "samples/fieltorcedor.html" In_channel.input_all
  in
  let games = parse_games html in
  print_endline "-- all matches --";
  games |> List.iter (fun g -> print_endline (summary g));
  print_endline "-- buyable matches --";
  games |> buyable_summaries |> List.iter print_endline;
  print_endline "-- next buyable match --";
  match next_buyable games with
  | Some g -> print_endline ("next buyable: " ^ summary g)
  | None -> print_endline "nothing on sale right now"
