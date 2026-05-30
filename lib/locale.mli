(** Locale identifiers supported by fake data providers. *)

type t
(** Opaque supported locale identifier.

    Callers create locale values through {!en}, {!ja_jp}, {!all}, or
    {!of_string}. Constructors are intentionally not exposed so adding a locale
    does not require callers to update pattern matches. *)

val en : t
(** English locale. *)

val ja_jp : t
(** Japanese locale for Japan. *)

val all : t list
(** All supported locales in stable identifier order. *)

val to_string : t -> string
(** [to_string locale] returns the stable CLI/API identifier for [locale]. *)

val of_string : string -> (t, string) result
(** [of_string value] parses a locale identifier.

    Supported identifiers are ["en"] and ["ja_jp"]. *)
