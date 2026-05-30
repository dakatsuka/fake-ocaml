(** Locale identifiers supported by fake data providers. *)

(** Supported locales.

    [En] is English. [Ja_jp] is Japanese as used in Japan. *)
type t = En | Ja_jp

val en : t
(** English locale. *)

val ja_jp : t
(** Japanese locale for Japan. *)

val all : t list
(** All supported locales. *)

val to_string : t -> string
(** [to_string locale] returns the stable CLI/API identifier for [locale]. *)

val of_string : string -> (t, string) result
(** [of_string value] parses a locale identifier.

    Supported identifiers are ["en"] and ["ja_jp"]. *)
