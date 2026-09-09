type outcome = { alert : string option; newly_seen : string list }

val decide : seen:string list -> games:Game.game list -> outcome
