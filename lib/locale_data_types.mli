(** Shared record types for compiled locale data.

    This module is private to the [fake] library. Locale-specific data modules
    use these types directly so data can be split by locale without creating
    dependency cycles through {!Locale_data}. *)

type name = {
  first_names : string array;
  last_names : string array;
  format_full_name : first:string -> last:string -> string;
}
(** Raw data and locale-owned formatting required by person name providers. *)

type internet = { usernames : string array; domains : string array }
(** Raw data required by internet providers. *)

type lorem = { words : string array; format_sentence : string list -> string }
(** Raw data and locale-owned formatting required by lorem providers. *)

type t = { name : name; internet : internet; lorem : lorem }
(** Complete compiled data bundle for one locale. *)
