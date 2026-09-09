open Fiel_bot.Game

let site_url = base_url ^ "/"
let state_file = "seen.txt"

let read_seen () =
  if Sys.file_exists state_file then
    In_channel.with_open_text state_file In_channel.input_all
    |> String.split_on_char '\n'
    |> List.filter (fun s -> s <> "")
  else []

let write_seen ids =
  Out_channel.with_open_text state_file (fun oc ->
      List.iter (fun id -> Out_channel.output_string oc (id ^ "\n")) ids)

let fetch_html () =
  match Ezcurl.get ~url:site_url () with
  | Ok resp when resp.code = 200 -> Some resp.body
  | Ok resp ->
      Printf.eprintf "site returned HTTP %d\n" resp.code;
      None
  | Error (_, msg) ->
      Printf.eprintf "error fetching site: %s\n" msg;
      None

let send_message ~token ~chat_id ~text =
  let url = Printf.sprintf "https://api.telegram.org/bot%s/sendMessage" token in
  let body =
    `Assoc [ ("chat_id", `String chat_id); ("text", `String text) ]
    |> Yojson.Safe.to_string
  in
  Ezcurl.post ~params:[] ~content:(`String body)
    ~headers:[ ("Content-Type", "application/json") ]
    ~url ()

let notify ~token ~chat_id text =
  match send_message ~token ~chat_id ~text with
  | Ok resp -> resp.code = 200
  | Error _ -> false

let send_alert msg =
  match
    (Sys.getenv_opt "TELEGRAM_BOT_TOKEN", Sys.getenv_opt "TELEGRAM_CHAT_ID")
  with
  | Some token, Some chat_id ->
      if notify ~token ~chat_id msg then
        print_endline "Alert sent successfully."
      else print_endline "Failed to send alert."
  | _ ->
      print_endline
        "Telegram bot token or chat ID not set in environment variables."

let process html =
  match alert_message (parse_games html) with
  | None -> print_endline "Nothing on sale right now. No alert."
  | Some msg -> send_alert msg

let handle games =
  let seen = read_seen () in
  let fresh = new_buyable ~seen games in
  match alert_message fresh with
  | None -> print_endline "No new matches on sale."
  | Some msg ->
      send_alert msg;
      write_seen (seen @ List.map game_id fresh);
      Printf.printf "alerted %d new match(es)\n" (List.length fresh)

let () =
  match fetch_html () with
  | None -> print_endline "Failed to fetch HTML from the site."
  | Some html -> handle (parse_games html)
