let first_name ~generator ~locale =
  let data = Locale_data.(get locale).name in
  Generator.choose generator data.first_names

let last_name ~generator ~locale =
  let data = Locale_data.(get locale).name in
  Generator.choose generator data.last_names

let full_name ~generator ~locale =
  let first = first_name ~generator ~locale in
  let last = last_name ~generator ~locale in
  match locale with
  | Locale.En -> first ^ " " ^ last
  | Locale.Ja_jp -> last ^ " " ^ first
