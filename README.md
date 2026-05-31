# fake-ocaml

An Ocaml library for generating fake data in different languages.

## Status
Initial development. The first API surface is intentionally small while the
project establishes provider, locale, and CI conventions.

## Usage
Library usage:

```ocaml
let generator = Fake.Generator.make ~seed:42
let name = Fake.Name.full_name ~generator ~locale:Fake.Locale.en
```

Initial locales:

- `en`
- `ja_jp`

Initial providers:

- `Fake.Name.first_name`
- `Fake.Name.last_name`
- `Fake.Name.full_name`
- `Fake.Internet.username`
- `Fake.Internet.domain`
- `Fake.Internet.email`
- `Fake.Lorem.word`
- `Fake.Lorem.sentence`
- `Fake.Lorem.paragraph`

## Development
Expected local checks:

```
dune build @all
dune runtest
dune build @fmt
dune build @check
dune build @install
opam lint fake.opam
```

The project uses:
- dune for build orchestration
- Alcotest for unit tests
- ocamlformat for formatting

## Documentation
Start with [AGENTS.md](AGENTS.md) for agent-facing workflow guidance.

Key product spec documents:
- [Initial Public API](docs/product-specs/initial-public-api.md)

Key design documents:
- [Initial Architecture](docs/design-docs/initial-architecture.md)
