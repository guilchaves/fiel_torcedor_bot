type outcome = { alert : string option; newly_seen : string list }

let decide ~seen ~games =
  let fresh = Game.new_buyable ~seen games in
  { alert = Game.alert_message fresh; newly_seen = List.map Game.game_id fresh }
