type availability = 
    | OnSale
    | ComingSoon
    | SoldOut

type game = {
    home: string;
    away: string;
    kickoff: string;
    venue: string;
    status: availability;
}

let describe a =
    match a with
    | OnSale -> "This item is currently on sale."
    | ComingSoon -> "This item will be available."
    | SoldOut -> "This item is currently sold out."

let should_notify a = 
    match a with
    | OnSale -> true
    | ComingSoon -> true
    | SoldOut -> false

let summary g =
    g.home ^ " x " ^ g.away ^ " — " ^ g.kickoff ^ " at " ^ g.venue ^ " (" ^ describe g.status ^ ")"

let is_buyable g = 
    match g.status with
    | OnSale -> true
    | _ -> false
