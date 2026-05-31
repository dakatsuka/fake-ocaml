let word ~generator ~locale =
  let data = Locale_data.(get locale).lorem in
  Generator.choose generator data.words

let sentence ~generator ~locale =
  let data = Locale_data.(get locale).lorem in
  let length = 4 + Generator.int generator ~bound:5 in
  let words = List.init length (fun _ -> word ~generator ~locale) in
  data.format_sentence words

let paragraph ~generator ~locale =
  let data = Locale_data.(get locale).lorem in
  let length = 3 + Generator.int generator ~bound:3 in
  let sentences = List.init length (fun _ -> sentence ~generator ~locale) in
  data.format_paragraph sentences
