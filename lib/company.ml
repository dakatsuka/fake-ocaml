let suffix ~generator ~locale =
  let data = Locale_data.(get locale).company in
  Generator.choose generator data.suffixes

let buzzword ~generator ~locale =
  let data = Locale_data.(get locale).company in
  Generator.choose generator data.buzzwords

let choose_phrase_word generator words index =
  Generator.choose generator words.(index)

let catch_phrase ~generator ~locale =
  let data = Locale_data.(get locale).company in
  let words =
    [
      choose_phrase_word generator data.catch_phrase_words 0;
      choose_phrase_word generator data.catch_phrase_words 1;
      choose_phrase_word generator data.catch_phrase_words 2;
    ]
  in
  data.format_catch_phrase words

let buzz_phrase ~generator ~locale =
  let data = Locale_data.(get locale).company in
  let words =
    [
      choose_phrase_word generator data.buzz_phrase_words 0;
      choose_phrase_word generator data.buzz_phrase_words 1;
      choose_phrase_word generator data.buzz_phrase_words 2;
    ]
  in
  data.format_buzz_phrase words

let draw_last_names ~generator ~locale ~count =
  List.init count (fun _ -> Name.last_name ~generator ~locale)

let name ~generator ~locale =
  let data = Locale_data.(get locale).company in
  let pattern =
    Generator.int generator ~bound:(Array.length data.name_patterns)
  in
  let pattern_spec = data.name_patterns.(pattern) in
  let last_name_count = pattern_spec.last_name_count in
  let uses_suffix = pattern_spec.uses_suffix in
  let last_names = draw_last_names ~generator ~locale ~count:last_name_count in
  let suffix_value = if uses_suffix then suffix ~generator ~locale else "" in
  data.format_company_name ~pattern ~last_names ~suffix:suffix_value
