(** Internal typed locale data used by provider modules.

    This module is private to the [fake] library. It defines the compiled OCaml
    data shape shared by all locale-specific data modules and exposes lookup by
    supported locale. Public callers should use provider modules such as
    {!Name}, {!Internet}, and {!Lorem} instead of depending on these records. *)

type name = Locale_data_types.name = {
  first_names : string array;  (** Given names available for name providers. *)
  last_names : string array;  (** Family names available for name providers. *)
  format_full_name : first:string -> last:string -> string;
      (** Locale-owned full-name formatter. *)
}
(** Locale-specific data and formatting for person name providers. *)

type internet = Locale_data_types.internet = {
  usernames : string array;
      (** Username stems available for internet providers. *)
  domains : string array;  (** Domain names available for internet providers. *)
}
(** Locale-specific data for internet providers. *)

type lorem = Locale_data_types.lorem = {
  words : string array;
  format_sentence : string list -> string;
      (** Locale-owned sentence formatter. *)
  format_paragraph : string list -> string;
      (** Locale-owned paragraph formatter. *)
}
(** Locale-specific words and formatting used by lorem providers. *)

type address = Locale_data_types.address = {
  regions : string array;  (** Administrative areas available for addresses. *)
  cities : string array;  (** City names available for addresses. *)
  communities : string array;
      (** Neighborhood, district, or community names available for addresses. *)
  street_names : string array;
      (** Street or area names available for addresses. *)
  building_numbers : string array;
      (** Building or block numbers available for addresses. *)
  secondary_addresses : string array;
      (** Apartment, suite, room, or building-unit values available for
          addresses. *)
  postal_codes : string array;  (** Postal-code-like values for addresses. *)
  format_street_address :
    building_number:string -> street_name:string -> string;
      (** Locale-owned street-address formatter. *)
  format_full_address :
    postal_code:string ->
    region:string ->
    city:string ->
    street_address:string ->
    string;
      (** Locale-owned full-address formatter. *)
}
(** Locale-specific data and formatting used by address providers. *)

type name_pattern = Locale_data_types.name_pattern
(** Metadata for one locale-owned company-name pattern. *)

type company = Locale_data_types.company = {
  suffixes : string array;
      (** Legal-entity or organizational suffixes available for company
          providers. *)
  buzzwords : string array;
      (** Single-word marketing or business-jargon terms. *)
  catch_phrase_words : string array array;
      (** Three phrase-part groups used by catch-phrase composition. *)
  buzz_phrase_words : string array array;
      (** Three phrase-part groups used by buzz-phrase composition. *)
  name_patterns : name_pattern array;
      (** Metadata for locale-owned company-name patterns. *)
  format_company_name :
    pattern:int -> last_names:string list -> suffix:string -> string;
      (** Locale-owned company-name formatter. *)
  format_catch_phrase : string list -> string;
      (** Locale-owned catch-phrase formatter. *)
  format_buzz_phrase : string list -> string;
      (** Locale-owned buzz-phrase formatter. *)
}
(** Locale-specific data and formatting used by company providers. *)

type t = Locale_data_types.t = {
  name : name;  (** Data consumed by {!Name}. *)
  internet : internet;  (** Data consumed by {!Internet}. *)
  lorem : lorem;  (** Data consumed by {!Lorem}. *)
  address : address;  (** Data consumed by {!Address}. *)
  company : company;  (** Data consumed by {!Company}. *)
}
(** Complete data bundle for one locale. *)

val get : Locale.t -> t
(** [get locale] returns the compiled data bundle for [locale]. *)
