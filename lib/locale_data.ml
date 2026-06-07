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
  format_paragraph : string list -> string;
}

type address = Locale_data_types.address = {
  regions : string array;
  cities : string array;
  communities : string array;
  street_names : string array;
  building_numbers : string array;
  secondary_addresses : string array;
  postal_codes : string array;
  format_street_address :
    building_number:string -> street_name:string -> string;
  format_full_address :
    postal_code:string ->
    region:string ->
    city:string ->
    street_address:string ->
    string;
}

type name_pattern = Locale_data_types.name_pattern

type company = Locale_data_types.company = {
  suffixes : string array;
  buzzwords : string array;
  catch_phrase_words : string array array;
  buzz_phrase_words : string array array;
  name_patterns : name_pattern array;
  format_company_name :
    pattern:int -> last_names:string list -> suffix:string -> string;
  format_catch_phrase : string list -> string;
  format_buzz_phrase : string list -> string;
}

type t = Locale_data_types.t = {
  name : name;
  internet : internet;
  lorem : lorem;
  address : address;
  company : company;
}

let get locale =
  match Locale.to_string locale with
  | "en" -> Locale_data_en.data
  | "ja_jp" -> Locale_data_ja_jp.data
  | value -> invalid_arg ("Fake.Locale_data.get: unsupported locale " ^ value)
