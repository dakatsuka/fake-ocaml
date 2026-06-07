# Initial Public API

## Status

Accepted

## Problem

OCaml users need a small, reproducible fake data library that can generate
locale-aware fixture data from OCaml code.

## Goals

- Target OCaml 5.0 and newer.
- Provide an idiomatic OCaml API with explicit generator state.
- Support English (`en`) and Japanese for Japan (`ja_jp`) as the initial
  locales.
- Compile locale data as OCaml modules, not external YAML or TOML files.
- Keep runtime dependencies limited to the OCaml standard library and Dune.

## Non-Goals

- PPX derive support is not part of the first implementation.
- Address, phone, company, payment, or other broad Faker-style providers are not
  part of the first implementation.
- The library does not promise long-term byte-for-byte compatibility of random
  sequences across future implementation or runtime changes.

## Requirements

- The public library is named `fake`.
- Provider APIs require explicit `generator` and `locale` arguments.
- The initial providers are `Name`, `Internet`, and `Lorem`.
- Supported locale identifiers are exactly `en` and `ja_jp`.
- `Locale.of_string` accepts exactly `en` and `ja_jp` and returns `Error` for
  unknown identifiers.
- The primary user experience is using the library from OCaml code.
- `Locale.t` is opaque to public callers. Callers create locale values through
  `Locale.en`, `Locale.ja_jp`, `Locale.all`, or `Locale.of_string`.
- `Locale.all` returns supported locales in stable identifier order:
  `[Locale.en; Locale.ja_jp]`.
- Locale-specific provider formatting is part of compiled locale behavior. The
  initial locale-specific formatting rules are full-name order/separator and
  lorem sentence joining/capitalization/punctuation plus paragraph sentence
  joining.
- `Generator.t` is mutable. Sequential reuse of one generator advances its
  state; creating a fresh generator with the same seed recreates the same
  sequence for the same library/runtime implementation.
- The first API does not provide generator copy, split, jump, or domain-safe
  sharing operations. Callers that need independent generation streams create
  separate generators with explicit seeds.
- Sharing one generator concurrently across OCaml domains or system threads is
  outside the public contract.

## Public Contracts

```ocaml
module Generator : sig
  type t

  val make : seed:int -> t
  val seed : t -> int
  val int : t -> bound:int -> int
  val choose : t -> 'a array -> 'a
end

module Locale : sig
  type t

  val en : t
  val ja_jp : t
  val all : t list
  val to_string : t -> string
  val of_string : string -> (t, string) result
end

module Name : sig
  val first_name : generator:Generator.t -> locale:Locale.t -> string
  val last_name : generator:Generator.t -> locale:Locale.t -> string
  val full_name : generator:Generator.t -> locale:Locale.t -> string
end

module Internet : sig
  val username : generator:Generator.t -> locale:Locale.t -> string
  val domain : generator:Generator.t -> locale:Locale.t -> string
  val email : generator:Generator.t -> locale:Locale.t -> string
end

module Lorem : sig
  val word : generator:Generator.t -> locale:Locale.t -> string
  val sentence : generator:Generator.t -> locale:Locale.t -> string
  val paragraph : generator:Generator.t -> locale:Locale.t -> string
end
```

`Generator.int` raises `Invalid_argument` when `bound <= 0`.
`Generator.choose` raises `Invalid_argument` when passed an empty array.
Provider functions may surface these exceptions if compiled locale data is
invalid, although shipped locale data must not contain empty provider arrays.

## OCaml Usage Examples

The main usage pattern is to create an explicit generator and pass it to provider
functions with a locale:

```ocaml
let generator = Fake.Generator.make ~seed:42

let full_name =
  Fake.Name.full_name ~generator ~locale:Fake.Locale.en

let email =
  Fake.Internet.email ~generator ~locale:Fake.Locale.en
```

Reusing the same generator advances its state, which is useful when creating a
fixture record with multiple fields:

```ocaml
type user_fixture = {
  name : string;
  email : string;
  bio : string;
}

let user_fixture ~seed ~locale =
  let generator = Fake.Generator.make ~seed in
  {
    name = Fake.Name.full_name ~generator ~locale;
    email = Fake.Internet.email ~generator ~locale;
    bio = Fake.Lorem.paragraph ~generator ~locale;
  }
```

Creating a new generator with the same seed recreates the same sequence for this
implementation, which supports repeatable tests:

```ocaml
let test_fixture_is_repeatable () =
  let left = user_fixture ~seed:123 ~locale:Fake.Locale.ja_jp in
  let right = user_fixture ~seed:123 ~locale:Fake.Locale.ja_jp in
  assert (left = right)
```

Locale values can be parsed from configuration or test parameters:

```ocaml
let locale =
  match Fake.Locale.of_string "ja_jp" with
  | Ok locale -> locale
  | Error message -> invalid_arg message
```

## Future Work

- Opam publication and registry naming are release-packaging work, not a
  blocker for this accepted library API.
- PPX derive syntax and package boundaries require a later product spec and
  design document.
- The Address provider has an accepted product spec and design document. Other
  broad provider domains such as phone, company, and payment still require later
  product specs before implementation.
