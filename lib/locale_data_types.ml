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

type t = { name : name; internet : internet; lorem : lorem }
