# fake-ocaml

An OCaml library for generating fake data in different languages.

## Status
Active development. The accepted initial API is intentionally small: a
library-only package with explicit generators, locale-aware providers, and
compiled OCaml locale data.

## Usage
Library usage:

```ocaml
let generator = Fake.Generator.make ~seed:42
let name = Fake.Name.full_name ~generator ~locale:Fake.Locale.en
```

Supported locales:

- `en`
- `ja_jp`

Available providers:

- `Fake.Address.region`
- `Fake.Address.city`
- `Fake.Address.community`
- `Fake.Address.street_name`
- `Fake.Address.building_number`
- `Fake.Address.secondary_address`
- `Fake.Address.postal_code`
- `Fake.Address.street_address`
- `Fake.Address.full_address`
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
- [Address Provider](docs/product-specs/address-provider.md)
- [Future Product Work](docs/product-specs/future-work.md)

Key design documents:
- [Initial Architecture](docs/design-docs/initial-architecture.md)
