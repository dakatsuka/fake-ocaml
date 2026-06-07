(** Company providers.

    Provider functions may raise [Invalid_argument] from {!Generator.choose} or
    {!Generator.int} if compiled locale data is invalid, although shipped
    company arrays are expected to be non-empty. *)

val suffix : generator:Generator.t -> locale:Locale.t -> string
(** [suffix ~generator ~locale] returns a locale-specific legal-entity or
    organizational suffix. *)

val buzzword : generator:Generator.t -> locale:Locale.t -> string
(** [buzzword ~generator ~locale] returns a locale-specific marketing or
    business-jargon word. *)

val name : generator:Generator.t -> locale:Locale.t -> string
(** [name ~generator ~locale] returns a locale-specific company name. *)

val catch_phrase : generator:Generator.t -> locale:Locale.t -> string
(** [catch_phrase ~generator ~locale] returns a locale-specific company catch
    phrase. *)

val buzz_phrase : generator:Generator.t -> locale:Locale.t -> string
(** [buzz_phrase ~generator ~locale] returns a locale-specific business-jargon
    phrase. *)
