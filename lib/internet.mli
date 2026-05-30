(** Internet-related providers. *)

val username : generator:Generator.t -> locale:Locale.t -> string
(** [username ~generator ~locale] returns a username-like identifier. *)

val domain : generator:Generator.t -> locale:Locale.t -> string
(** [domain ~generator ~locale] returns a domain name. *)

val email : generator:Generator.t -> locale:Locale.t -> string
(** [email ~generator ~locale] returns an email address. *)
