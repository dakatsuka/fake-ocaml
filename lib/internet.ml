let username ~generator ~locale =
  let data = Locale_data.(get locale).internet in
  Generator.choose generator data.usernames

let domain ~generator ~locale =
  let data = Locale_data.(get locale).internet in
  Generator.choose generator data.domains

let email ~generator ~locale =
  username ~generator ~locale ^ "@" ^ domain ~generator ~locale
