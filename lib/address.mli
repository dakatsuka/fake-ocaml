(** Postal address providers.

    Provider functions may raise [Invalid_argument] if compiled locale data is
    invalid, although shipped address arrays are expected to be non-empty. *)

val region : generator:Generator.t -> locale:Locale.t -> string
(** [region ~generator ~locale] returns a locale-specific administrative area.
*)

val city : generator:Generator.t -> locale:Locale.t -> string
(** [city ~generator ~locale] returns a locale-specific city. *)

val community : generator:Generator.t -> locale:Locale.t -> string
(** [community ~generator ~locale] returns a locale-specific neighborhood,
    district, or community. *)

val street_name : generator:Generator.t -> locale:Locale.t -> string
(** [street_name ~generator ~locale] returns a locale-specific street or area
    name. *)

val building_number : generator:Generator.t -> locale:Locale.t -> string
(** [building_number ~generator ~locale] returns a locale-specific building or
    block number. *)

val secondary_address : generator:Generator.t -> locale:Locale.t -> string
(** [secondary_address ~generator ~locale] returns a locale-specific apartment,
    suite, room, or building-unit value. *)

val postal_code : generator:Generator.t -> locale:Locale.t -> string
(** [postal_code ~generator ~locale] returns a locale-specific postal-code-like
    value. *)

val street_address : generator:Generator.t -> locale:Locale.t -> string
(** [street_address ~generator ~locale] returns a locale-specific street
    address. *)

val full_address : generator:Generator.t -> locale:Locale.t -> string
(** [full_address ~generator ~locale] returns a locale-specific full address. *)
