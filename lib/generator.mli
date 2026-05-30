(** Stateful pseudo-random generator for fake data providers.

    Generators are mutable. Reusing a generator advances its internal state;
    creating a new generator with the same seed recreates the same sequence for
    this implementation. The library does not promise byte-for-byte random
    sequence compatibility across future implementation or runtime changes. *)

type t
(** Opaque generator state. *)

val make : seed:int -> t
(** [make ~seed] creates a new generator initialized from [seed]. *)

val seed : t -> int
(** [seed generator] returns the seed used to create [generator]. *)

val int : t -> bound:int -> int
(** [int generator ~bound] returns an integer greater than or equal to zero and
    less than [bound].

    @raise Invalid_argument if [bound] is not positive. *)

val choose : t -> 'a array -> 'a
(** [choose generator values] returns one element from [values].

    @raise Invalid_argument if [values] is empty. *)
