# Initial Public API

## Status

Draft

## Problem

OCaml users need a small, reproducible fake data library that can generate
locale-aware fixture data from OCaml code and from a command-line interface.

## Goals

- Target OCaml 5.0 and newer.
- Provide an idiomatic OCaml API with explicit generator state.
- Support English (`en`) and Japanese for Japan (`ja_jp`) as the initial
  locales.
- Compile locale data as OCaml modules, not external YAML or TOML files.
- Keep runtime dependencies limited to the OCaml standard library and Dune.
- Provide a minimal CLI for scripted fake data generation.

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
- Unknown locale and provider identifiers fail with concise errors.
- The primary user experience is using the library from OCaml code.
- The CLI executable is named `fake` and is a secondary convenience interface
  for scripts and shell workflows.

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
  type t = En | Ja_jp

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
end
```

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
    bio = Fake.Lorem.sentence ~generator ~locale;
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

## CLI Examples

```sh
fake --locale en --seed 42 --provider name.full_name --count 3 --format text
fake --locale ja_jp --seed 42 --provider lorem.sentence --count 2 --format jsonl
```

Text output prints one generated value per line.

JSON Lines output prints one object per generated value:

```json
{"locale":"en","provider":"name.full_name","seed":42,"value":"Alice Taylor"}
```

Initial provider identifiers:

- `name.first_name`
- `name.last_name`
- `name.full_name`
- `internet.username`
- `internet.domain`
- `internet.email`
- `lorem.word`
- `lorem.sentence`

## Open Questions

- The final opam package name must be checked before publication.
- PPX derive syntax and package boundaries remain future design work.
