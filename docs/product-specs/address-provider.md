# Address Provider

## Status

Draft

## Problem

Users need locale-aware address fixture data after the initial name, internet,
and lorem providers. Address data has visible locale-specific ordering and
separator rules, so it is a good next provider domain for validating provider
growth without adding runtime dependencies or external locale files.

## Goals

- Add a focused `Fake.Address` provider module.
- Keep provider APIs consistent with the accepted initial API: explicit
  `generator` and `locale` arguments.
- Support the existing `en` and `ja_jp` locales.
- Keep locale data compiled as OCaml modules.
- Keep runtime dependencies limited to the OCaml standard library and Dune.

## Non-Goals

- Globally accurate postal addressing is out of scope.
- Country selection, geocoding, coordinates, and validation are out of scope.
- Long-term byte-for-byte sequence compatibility remains out of scope.
- Runtime loading of external address datasets is out of scope.
- Real place-name datasets are out of scope for the first Address provider.

## Requirements

- `Address` is exposed from the public `Fake` module.
- Provider functions require explicit `generator` and `locale` arguments.
- Shipped address locale data uses fictional sample place names and
  postal-code-like strings. The data should look plausible enough for fixtures
  but must not claim real-world postal correctness.
- `region` returns a locale-specific administrative area string. For `en`, this
  is state-like sample data. For `ja_jp`, this is prefecture-like sample data.
- `city` returns a locale-specific city string.
- `community` returns a locale-specific neighborhood, district, or community
  string.
- `street_name` returns a locale-specific street or area name string.
- `building_number` returns a locale-specific building or block number string.
- `secondary_address` returns a locale-specific apartment, suite, room, or
  building-unit string.
- `postal_code` returns a locale-specific postal-code-like string.
- `street_address` composes one building number and one street name using
  locale-owned formatting.
- `full_address` composes one postal code, region, city, and street address
  using locale-owned formatting.
- `en` formatting:
  - `street_address`: `"<building_number> <street_name>"`
  - `full_address`: `"<street_address>, <city>, <region> <postal_code>"`
- `ja_jp` formatting:
  - `street_address`: `"<street_name><building_number>"`
  - `full_address`: `"〒<postal_code> <region><city><street_address>"`

## Public Contracts

```ocaml
module Address : sig
  val region : generator:Generator.t -> locale:Locale.t -> string
  val city : generator:Generator.t -> locale:Locale.t -> string
  val community : generator:Generator.t -> locale:Locale.t -> string
  val street_name : generator:Generator.t -> locale:Locale.t -> string
  val building_number : generator:Generator.t -> locale:Locale.t -> string
  val secondary_address : generator:Generator.t -> locale:Locale.t -> string
  val postal_code : generator:Generator.t -> locale:Locale.t -> string
  val street_address : generator:Generator.t -> locale:Locale.t -> string
  val full_address : generator:Generator.t -> locale:Locale.t -> string
end
```

Provider functions may surface `Invalid_argument` from `Generator.choose` if
compiled locale data is invalid, although shipped address arrays must not be
empty.

## Examples

```ocaml
let generator = Fake.Generator.make ~seed:42

let address =
  Fake.Address.full_address ~generator ~locale:Fake.Locale.en
```

```ocaml
let postal_code =
  Fake.Address.postal_code ~generator ~locale:Fake.Locale.ja_jp
```

## Open Questions

- Should a later API expose `country` once more locales exist?
- Should postal code generation eventually use templates instead of compiled
  sample strings?
- Should a later API compose `secondary_address` into `full_address`, or should
  it remain an independent field for callers that need unit-level detail?
- Should a later API expose aliases such as `zip` or `postcode`, or keep one
  canonical `postal_code` function?
