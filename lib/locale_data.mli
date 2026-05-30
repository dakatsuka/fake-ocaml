(** Internal typed locale data used by provider modules.

    This module is private to the [fake] library. It defines the compiled OCaml
    data shape shared by all locale-specific data modules and exposes lookup by
    supported locale. Public callers should use provider modules such as
    {!Name}, {!Internet}, and {!Lorem} instead of depending on these records. *)

type name = Locale_data_types.name = {
  first_names : string array;  (** Given names available for name providers. *)
  last_names : string array;  (** Family names available for name providers. *)
}
(** Locale-specific data for person name providers. *)

type internet = Locale_data_types.internet = {
  usernames : string array;
      (** Username stems available for internet providers. *)
  domains : string array;  (** Domain names available for internet providers. *)
}
(** Locale-specific data for internet providers. *)

type lorem = Locale_data_types.lorem = { words : string array }
(** Locale-specific words used by lorem providers. *)

type t = Locale_data_types.t = {
  name : name;  (** Data consumed by {!Name}. *)
  internet : internet;  (** Data consumed by {!Internet}. *)
  lorem : lorem;  (** Data consumed by {!Lorem}. *)
}
(** Complete data bundle for one locale. *)

val get : Locale.t -> t
(** [get locale] returns the compiled data bundle for [locale]. *)
