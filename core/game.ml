type availability = OnSale | ComingSoon | SoldOut

type game = {
  title : string;
  kickoff : string;
  venue : string;
  status : availability;
  competition : string;
  link : string option;
}

let describe a =
  match a with
  | OnSale -> "Compre aqui:"
  | ComingSoon -> "Disponível em breve."
  | SoldOut -> "Esgotado."

let summary g =
  g.title ^ " — " ^ g.kickoff ^ " at " ^ g.venue ^ " | " ^ g.competition ^ " ("
  ^ describe g.status
  ^ match g.link with Some l -> l | None -> "" ^ ")"

let game_id g = g.title ^ " | " ^ g.kickoff
let is_buyable g = match g.status with OnSale -> true | _ -> false

let buyable_summaries games =
  games |> List.filter is_buyable |> List.map summary

let new_buyable ~seen games =
  games |> List.filter is_buyable
  |> List.filter (fun g -> not (List.mem (game_id g) seen))

let alert_message games =
  let lines = buyable_summaries games in
  match lines with
  | [] -> None
  | _ ->
      Some ("Ingressos à venda no Fiel Torcedor!\n\n" ^ String.concat "\n" lines)
