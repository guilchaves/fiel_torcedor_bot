open Fiel_bot

let game ?(title = "Corinthians x Palmeiras") ?(kickoff = "01/01 16:00")
    ?(status = Game.OnSale) () : Game.game =
  {
    title;
    kickoff;
    venue = "Neo Química Arena";
    status;
    competition = "Brasileirão";
    link = None;
  }

let check name cond = if cond then () else failwith ("FAILED: " ^ name)

let () =
  let g = game () in
  let out = Decision.decide ~seen:[] ~games:[ g ] in
  check "alert present" (out.alert <> None);
  check "one newly_seen" (out.newly_seen = [ Game.game_id g ])

let () =
  let g = game () in
  let out = Decision.decide ~seen:[ Game.game_id g ] ~games:[ g ] in
  check "no alert for seen" (out.alert = None);
  check "nothing new" (out.newly_seen = [])

let () =
  let g = game ~status:Game.SoldOut () in
  let out = Decision.decide ~seen:[] ~games:[ g ] in
  check "no alert for sold out" (out.alert = None);
  check "nothing new for sold out" (out.newly_seen = [])

let () = print_endline "all tests passed"
