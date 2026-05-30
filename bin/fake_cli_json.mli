(** JSON helpers private to the fake executable. *)

val escape_string : string -> string
(** [escape_string value] returns the contents of a JSON string literal for
    [value], escaping quotation marks, backslashes, common control characters,
    and other ASCII control bytes. *)
