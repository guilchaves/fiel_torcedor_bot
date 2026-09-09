let send ~token ~chat_id ~text =
  let url = Printf.sprintf "https://api.telegram.org/bot%s/sendMessage" token in
  let body =
    `Assoc [ ("chat_id", `String chat_id); ("text", `String text) ]
    |> Yojson.Safe.to_string
  in
  Http.post_json ~url ~body

let send_alert text =
  match Config.telegram () with
  | Some (token, chat_id) ->
      if send ~token ~chat_id ~text then print_endline "Alert sent successfully."
      else print_endline "Failed to send alert."
  | None ->
      print_endline
        "Telegram bot token or chat ID not set in environment variables."
