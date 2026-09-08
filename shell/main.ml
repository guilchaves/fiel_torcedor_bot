open Fiel_bot.Game

let cpb26 = {
    home = "Corinthians";
    away = "Pinheiros";
    kickoff = "08/09/2026 20:00";
    venue = "Ginásio Wlamir Marques";
    status = OnSale;
}

let cl26 = {
    home = "Corinthians";
    away = "Estudiantes";
    kickoff = "16/09/2026 21:30";
    venue = "Neo Química Arena";
    status = ComingSoon;
}

let cpb26_onsale = { cpb26 with status = OnSale }

let () = print_endline (
    string_of_bool (label_is_buyable "Disponível para: ") )
