type name = Locale_data_types.name = {
  first_names : string array;
  last_names : string array;
}

type internet = Locale_data_types.internet = {
  usernames : string array;
  domains : string array;
}

type lorem = Locale_data_types.lorem = { words : string array }

type t = Locale_data_types.t = {
  name : name;
  internet : internet;
  lorem : lorem;
}

let get = function
  | Locale.En -> Locale_data_en.data
  | Locale.Ja_jp -> Locale_data_ja_jp.data
