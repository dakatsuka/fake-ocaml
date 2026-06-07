type name = {
  first_names : string array;
  last_names : string array;
  format_full_name : first:string -> last:string -> string;
}

type internet = { usernames : string array; domains : string array }

type lorem = {
  words : string array;
  format_sentence : string list -> string;
  format_paragraph : string list -> string;
}

type address = {
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

type name_pattern = { last_name_count : int; uses_suffix : bool }

type company = {
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

type t = {
  name : name;
  internet : internet;
  lorem : lorem;
  address : address;
  company : company;
}
