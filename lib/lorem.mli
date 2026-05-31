(** Placeholder text providers. *)

val word : generator:Generator.t -> locale:Locale.t -> string
(** [word ~generator ~locale] returns one locale-specific placeholder word. *)

val sentence : generator:Generator.t -> locale:Locale.t -> string
(** [sentence ~generator ~locale] returns a short locale-specific sentence. *)

val paragraph : generator:Generator.t -> locale:Locale.t -> string
(** [paragraph ~generator ~locale] returns a short locale-specific placeholder
    paragraph. *)
