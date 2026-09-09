open Soup

type availability = OnSale | ComingSoon | SoldOut

type game = {
  title : string;
  kickoff : string;
  venue : string;
  status : availability;
  competition : string;
}

let describe a =
  match a with
  | OnSale -> "This item is currently on sale."
  | ComingSoon -> "This item will be available."
  | SoldOut -> "This item is currently sold out."

let should_notify a =
  match a with OnSale -> true | ComingSoon -> true | SoldOut -> false

let summary g =
  g.title ^ " — " ^ g.kickoff ^ " at " ^ g.venue ^ " | " ^ g.competition ^ " ("
  ^ describe g.status ^ ")"

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

let parse_card card =
  {
    title = pick card "h2";
    kickoff = pick card "p.font20";
    venue = pick card "p.font16";
    status = card_status card;
    competition = pick card "p.font18";
  }

let parse_games html =
  Soup.parse html $$ "article.tab_event" |> to_list |> List.map parse_card

let next_buyable games = List.find_opt is_buyable games
