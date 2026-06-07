(** Fake data generation for OCaml.

    The public API is locale-aware and uses explicit generator values so callers
    can make generated data reproducible in tests and fixtures. *)

module Generator = Generator
(** Stateful pseudo-random generator used by provider functions. *)

module Locale = Locale
(** Supported locale identifiers. *)

module Name = Name
(** Person name providers. *)

module Internet = Internet
(** Internet-related providers. *)

module Lorem = Lorem
(** Placeholder text providers. *)

module Address = Address
(** Postal address providers. *)

module Company = Company
(** Company providers. *)
