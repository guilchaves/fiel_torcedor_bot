type availability = 
    | OnSale
    | ComingSoon
    | SoldOut

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
