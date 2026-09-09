open Soup

let base_url = "https://www.fieltorcedor.com.br"
let text_of node = String.concat " " (Soup.trimmed_texts node)

let pick card sel =
  match card $? sel with Some node -> text_of node | None -> ""

let card_status card =
  match card $? "button" with
  | Some _ -> Game.OnSale
  | None -> Game.ComingSoon

let make_absolute href =
  if String.length href > 0 && href.[0] = '/' then base_url ^ href else href

let card_link card =
  match card $? "a" with
  | None -> None
  | Some a -> Soup.attribute "href" a |> Option.map make_absolute

let parse_card card : Game.game =
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
