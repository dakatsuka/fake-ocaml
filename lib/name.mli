(** Person name providers. *)

val first_name : generator:Generator.t -> locale:Locale.t -> string
(** [first_name ~generator ~locale] returns a locale-specific given name. *)

val last_name : generator:Generator.t -> locale:Locale.t -> string
(** [last_name ~generator ~locale] returns a locale-specific family name. *)

val full_name : generator:Generator.t -> locale:Locale.t -> string
(** [full_name ~generator ~locale] returns a locale-specific full name. *)
