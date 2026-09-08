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

let games = [
    {home="Corinthians"; away="Pinheiros"; kickoff="08/09"; venue="Ginásio Wlamir Marques"; status=OnSale};
    {home="Corinthians"; away="Estudiantes"; kickoff="16/09"; venue="Neo Química Arena"; status=OnSale};
    {home="Corinthians"; away="Flamengo"; kickoff="20/09"; venue="Maracanã"; status=ComingSoon};
]

let () = games |> buyable_summaries |> List.iter print_endline
let () = print_endline (string_of_int(games |> buyable_count))

let () = games |> List.iter (fun g -> print_endline (g.away))
