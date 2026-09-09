type availability = OnSale | ComingSoon | SoldOut

type game = {
  title : string;
  kickoff : string;
  venue : string;
  status : availability;
  competition : string;
  link : string option;
}

val describe : availability -> string
val summary : game -> string
val game_id : game -> string
val is_buyable : game -> bool
val buyable_summaries : game list -> string list
val new_buyable : seen:string list -> game list -> game list
val alert_message : game list -> string option
