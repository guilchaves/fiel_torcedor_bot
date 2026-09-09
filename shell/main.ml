open Fiel_bot

let site_url = Scrape.base_url ^ "/"

let () =
  match Http.get ~url:site_url with
  | None -> print_endline "Failed to fetch HTML from the site."
  | Some html -> (
      let games = Scrape.parse_games html in
      let seen = Store.read_seen () in
      let { Decision.alert; newly_seen } = Decision.decide ~seen ~games in
      match alert with
      | None -> print_endline "No new matches on sale."
      | Some msg ->
          Telegram.send_alert msg;
          Store.append_seen newly_seen;
          Printf.printf "alerted %d new match(es)\n" (List.length newly_seen))
