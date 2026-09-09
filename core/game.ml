open Soup

type availability = OnSale | ComingSoon | SoldOut

type game = {
  title : string;
  kickoff : string;
  venue : string;
  status : availability;
  competition : string;
  link : string option;
}

let base_url = "https://www.fieltorcedor.com.br"

let describe a =
  match a with
  | OnSale -> "Compre aqui:"
  | ComingSoon -> "Disponível em breve."
  | SoldOut -> "Esgotado."

let should_notify a =
  match a with OnSale -> true | ComingSoon -> true | SoldOut -> false

let summary g =
  g.title ^ " — " ^ g.kickoff ^ " at " ^ g.venue ^ " | " ^ g.competition ^ " ("
  ^ describe g.status
  ^ match g.link with Some l -> l | None -> "" ^ ")"

let game_id g = g.title ^ " | " ^ g.kickoff
let is_buyable g = match g.status with OnSale -> true | _ -> false

let availability_of_label label =
  match label with
  | "Disponível para: Público Geral" -> Some OnSale
  | "Disponível em breve" -> Some ComingSoon
  | "Esgotado" -> Some SoldOut
  | _ -> None

let show label =
  match availability_of_label label with
  | Some a -> describe a
  | None -> "unrecognised status: " ^ label

let label_is_buyable s =
  match availability_of_label s with
  | Some OnSale -> true
  | Some ComingSoon -> false
  | Some SoldOut -> false
  | None -> false

let buyable_summaries games =
  games |> List.filter is_buyable |> List.map summary

let buyable_count games = games |> buyable_summaries |> List.length
let text_of node = String.concat " " (Soup.trimmed_texts node)

let match_titles html =
  Soup.parse html $$ "article.tab_event" |> to_list
  |> List.map (fun card ->
      match card $? "h2" with Some h2 -> text_of h2 | None -> "(sem titulo)")

let pick card sel =
  match card $? sel with Some node -> text_of node | None -> ""

let card_status card =
  match card $? "button" with Some _ -> OnSale | None -> ComingSoon

let make_absolute href =
  if String.length href > 0 && href.[0] = '/' then base_url ^ href else href

let card_link card =
  match card $? "a" with
  | None -> None
  | Some a -> Soup.attribute "href" a |> Option.map make_absolute

let parse_card card =
  {
    title = pick card "h2";
    kickoff = pick card "p.font20";
    venue = pick card "p.font16";
    status = card_status card;
    competition = pick card "p.font18";
    link = card_link card;
  }

let parse_games html =
  Soup.parse html $$ "article.tab_event" |> to_list |> List.map parse_card

let next_buyable games = List.find_opt is_buyable games

let new_buyable ~seen games =
  games |> List.filter is_buyable
  |> List.filter (fun g -> not (List.mem (game_id g) seen))

let alert_message games =
  let lines = buyable_summaries games in
  match lines with
  | [] -> None
  | _ ->
      Some ("Ingressos à venda no Fiel Torcedor!\n\n" ^ String.concat "\n" lines)
