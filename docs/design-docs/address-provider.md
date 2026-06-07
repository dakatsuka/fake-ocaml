# Address Provider Design

## Status

Accepted

## Context

The accepted initial architecture defines a library-only package with explicit
generators, opaque locales, and compiled locale data. The Address provider is
the first broad provider domain proposed after the accepted initial API, so it
should extend the existing boundaries rather than introduce new loading,
formatting, or random-generation mechanisms.

## Goals

- Add `Fake.Address` without changing `Generator` or `Locale` public contracts.
- Keep address data in compiled OCaml locale modules.
- Keep locale-specific address ordering and separators in locale data.
- Keep provider modules responsible for provider-generic composition.
- Preserve one unit test file per source file under test.

## Non-Goals

- Postal-address correctness for real-world mailing.
- Runtime data files or third-party address datasets.
- Postal-code parsing or validation.
- Country-aware formatting beyond the existing `en` and `ja_jp` locales.
- Real place-name datasets in the first Address provider, except the complete
  `ja_jp` prefecture list.

## Proposed Design

Add a public `Address` module beside `Name`, `Internet`, and `Lorem`.

The first data arrays use fictional sample values for English regions and all
cities, communities, street names, building numbers, secondary addresses, and
postal codes. Japanese regions are an exception: `ja_jp` uses all 47 real
prefecture names because downstream systems often validate prefecture values.
Values should be locale-shaped and plausible enough for test fixtures, but they
should not use copied real postal datasets or imply deliverability.

The provider exposes primitive selectors and two composed values:

- `region`
- `city`
- `community`
- `street_name`
- `building_number`
- `secondary_address`
- `postal_code`
- `street_address`
- `full_address`

Primitive selectors choose one value from the locale data arrays. Composed
functions choose their required primitive parts by calling the public provider
functions with the same generator and locale, then pass the chosen values to
locale-owned formatters.

The internal locale data shape grows by one record:

```ocaml
type address = {
  regions : string array;
  cities : string array;
  communities : string array;
  street_names : string array;
  building_numbers : string array;
  secondary_addresses : string array;
  postal_codes : string array;
  format_street_address : building_number:string -> street_name:string -> string;
  format_full_address :
    postal_code:string ->
    region:string ->
    city:string ->
    street_address:string ->
    string;
}

type t = {
  name : name;
  internet : internet;
  lorem : lorem;
  address : address;
}
```

English formatting:

- `format_street_address`: `"<building_number> <street_name>"`
- `format_full_address`: `"<street_address>, <city>, <region> <postal_code>"`

Japanese formatting:

- `format_street_address`: `"<street_name><building_number>"`
- `format_full_address`: `"〒<postal_code> <region><city><street_address>"`

`Fake.Address.full_address` should draw component values in this order:

1. `postal_code`
2. `region`
3. `city`
4. `street_address`

`Fake.Address.street_address` should draw component values in this order:

1. `building_number`
2. `street_name`

This order keeps composed-provider behavior deterministic and straightforward
to test. The project still does not promise long-term byte-for-byte sequence
compatibility across future implementation or runtime changes.

## Contracts

Public interface:

```ocaml
val region : generator:Generator.t -> locale:Locale.t -> string
val city : generator:Generator.t -> locale:Locale.t -> string
val community : generator:Generator.t -> locale:Locale.t -> string
val street_name : generator:Generator.t -> locale:Locale.t -> string
val building_number : generator:Generator.t -> locale:Locale.t -> string
val secondary_address : generator:Generator.t -> locale:Locale.t -> string
val postal_code : generator:Generator.t -> locale:Locale.t -> string
val street_address : generator:Generator.t -> locale:Locale.t -> string
val full_address : generator:Generator.t -> locale:Locale.t -> string
```

Public comments in `address.mli` should document the locale-aware return value
for each function and note that invalid shipped data may surface
`Invalid_argument` through `Generator.choose`.

`fake.mli` and `fake.ml` should re-export `Address`.

## Alternatives Considered

- `state` instead of `region`: rejected because it is too specific to
  English-style address systems.
- `region_abbr` or `state_abbr`: deferred because abbreviation semantics differ
  by locale and are not needed for the first composed address formatting.
- Only `full_address`: rejected because fixture builders often need individual
  address fields.
- Generated postal-code templates in the first pass: deferred because compiled
  sample strings are simpler and consistent with the existing provider data
  model.
- Postal-code aliases such as `zip` and `postcode`: deferred to avoid adding
  duplicate public names before broader compatibility goals exist.
- Adding country now: deferred until additional locales make the contract more
  meaningful.
- Adding latitude, longitude, and time zone now: rejected because they imply
  geospatial semantics beyond the first address fixture provider.
- Adding country-code lookup functions now: rejected because they are
  conversion APIs rather than random fixture selectors and would need separate
  normalization rules.

## Third-Party Review

A context-free sub-agent reviewed the Address provider design before
implementation. The review found `community` and `secondary_address` coherent
with the compiled-locale architecture, requested an explicit data policy, and
requested explicit deferral for Faker Ruby-compatible aliases such as
`state_abbr`, `zip`, and `postcode`. Those changes were incorporated before
implementation. The data policy was later refined so `ja_jp` regions use the
complete real Japanese prefecture list while the rest of the first Address data
remains fictional.

## Validation

- `test/address_test.ml` should cover primitive values being non-empty for both
  locales.
- `test/address_test.ml` should cover `community` and `secondary_address` as
  independent primitive selectors.
- `test/address_test.ml` should cover English and Japanese street-address
  formatting.
- `test/address_test.ml` should cover English and Japanese full-address
  formatting.
- Static contract tests should include `lib/address.ml` so provider modules do
  not reference public locale constructors.
- Standard verification before completion:
  - `dune build @all`
  - `dune runtest --force`
  - `dune build @fmt`
  - `dune build @check`
  - `dune build @install`
  - `opam lint fake.opam`
  - `git diff --check`

## Open Questions

- Should a later compatibility-oriented provider layer include aliases for
  terminology used by other Faker libraries?
