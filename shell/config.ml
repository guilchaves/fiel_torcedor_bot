let telegram () =
  match
    (Sys.getenv_opt "TELEGRAM_BOT_TOKEN", Sys.getenv_opt "TELEGRAM_CHAT_ID")
  with
  | Some token, Some chat_id -> Some (token, chat_id)
  | _ -> None
