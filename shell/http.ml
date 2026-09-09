let get ~url =
  match Ezcurl.get ~url () with
  | Ok resp when resp.code = 200 -> Some resp.body
  | Ok resp ->
      Printf.eprintf "site returned HTTP %d\n" resp.code;
      None
  | Error (_, msg) ->
      Printf.eprintf "error fetching site: %s\n" msg;
      None

let post_json ~url ~body =
  match
    Ezcurl.post ~params:[] ~content:(`String body)
      ~headers:[ ("Content-Type", "application/json") ]
      ~url ()
  with
  | Ok resp -> resp.code = 200
  | Error _ -> false
