let first_name ~generator ~locale =
  let data = Locale_data.(get locale).name in
  Generator.choose generator data.first_names

let last_name ~generator ~locale =
  let data = Locale_data.(get locale).name in
  Generator.choose generator data.last_names

let full_name ~generator ~locale =
  let data = Locale_data.(get locale).name in
  let first = first_name ~generator ~locale in
  let last = last_name ~generator ~locale in
  data.format_full_name ~first ~last
