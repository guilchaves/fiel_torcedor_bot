open Fiel_bot.Game

let () =
  match Ezcurl.get ~url:"https://www.fieltorcedor.com.br/" () with
  | Error (_, msg) -> print_endline ("HTTP request failed: " ^ msg)
  | Ok resp ->
      Printf.printf "HTTP %d, %d bytes\n" resp.code (String.length resp.body);
      resp.body |> parse_games |> buyable_summaries |> List.iter print_endline

let send_message ~token ~chat_id ~text =
  let url = Printf.sprintf "https://api.telegram.org/bot%s/sendMessage" token in
  let body =
    `Assoc [ ("chat_id", `String chat_id); ("text", `String text) ]
    |> Yojson.Safe.to_string
  in
  Ezcurl.post ~params:[] ~content:(`String body)
    ~headers:[ ("Content-Type", "application/json") ]
    ~url ()

let () =
  match
    (Sys.getenv_opt "FIEL_BOT_TOKEN", Sys.getenv_opt "FIEL_BOT_CHAT_ID")
  with
  | Some token, Some chat_id -> (
      match send_message ~token ~chat_id ~text:"Olá do fiel_bot! 🦅" with
      | Error (_, msg) -> print_endline ("network error: " ^ msg)
      | Ok resp ->
          if resp.code = 200 then print_endline "message sent"
          else
            Printf.printf "Telegram rejected it (HTTP %d): %s\n" resp.code
              resp.body)
  | _ -> print_endline "Set FIEL_BOT_TOKEN and FIEL_BOT_CHAT_ID first."
