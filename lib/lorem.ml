let word ~generator ~locale =
  let data = Locale_data.(get locale).lorem in
  Generator.choose generator data.words

let sentence ~generator ~locale =
  let length = 4 + Generator.int generator ~bound:5 in
  let words = List.init length (fun _ -> word ~generator ~locale) in
  match locale with
  | Locale.En -> (
      match words with
      | [] -> "."
      | first :: rest ->
          String.capitalize_ascii first ^ " " ^ String.concat " " rest ^ ".")
  | Locale.Ja_jp -> String.concat "" words ^ "。"
