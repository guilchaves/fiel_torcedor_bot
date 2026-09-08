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
