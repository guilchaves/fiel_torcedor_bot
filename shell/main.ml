open Fiel_bot.Game

let () =
  match Ezcurl.get ~url:"https://www.fieltorcedor.com.br/" () with
  | Error (_, msg) -> print_endline ("HTTP request failed: " ^ msg)
  | Ok resp ->
      Printf.printf "HTTP %d, %d bytes\n" resp.code (String.length resp.body);
      resp.body |> parse_games |> buyable_summaries |> List.iter print_endline
