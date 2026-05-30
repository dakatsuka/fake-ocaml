type name = Locale_data_types.name = {
  first_names : string array;
  last_names : string array;
  format_full_name : first:string -> last:string -> string;
}

type internet = Locale_data_types.internet = {
  usernames : string array;
  domains : string array;
}

type lorem = Locale_data_types.lorem = {
  words : string array;
  format_sentence : string list -> string;
}

type t = Locale_data_types.t = {
  name : name;
  internet : internet;
  lorem : lorem;
}

let get locale =
  match Locale.to_string locale with
  | "en" -> Locale_data_en.data
  | "ja_jp" -> Locale_data_ja_jp.data
  | value -> invalid_arg ("Fake.Locale_data.get: unsupported locale " ^ value)
