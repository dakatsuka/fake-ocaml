# Company Provider Design

## Status

Accepted

## Context

The accepted initial architecture defines a library-only package with explicit
generators, opaque locales, and compiled locale data. The accepted Address
provider extended that model with primitive selectors, composed values, and
locale-owned formatting functions. Company is the next broad provider domain and
should follow the same boundaries.

## Goals

- Add `Fake.Company` without changing `Generator` or `Locale` public contracts.
- Keep company data in compiled OCaml locale modules.
- Keep locale-specific company-name patterns and phrase formatting in locale
  data.
- Keep provider modules responsible for provider-generic composition.
- Preserve one unit test file per source file under test.

## Non-Goals

- Real business registration correctness.
- Runtime data files or third-party company datasets.
- Country-specific registration numbers, tax identifiers, or logo URLs.
- Industry, department, profession, and company-type selectors in the first
  pass.
- Public compatibility aliases such as `bs`.

## Proposed Design

Add a public `Company` module beside `Name`, `Internet`, `Lorem`, and
`Address`.

The first data uses fictional, locale-shaped sample values. Company names reuse
`Fake.Name.last_name` for name parts in this pass so the provider stays narrow
and consistent with other Faker implementations that compose company names from
person-name data.

The provider exposes two primitive selectors and three composed values:

- `suffix`
- `buzzword`
- `name`
- `catch_phrase`
- `buzz_phrase`

Primitive selectors choose one value from locale data arrays. Composed functions
choose their required parts by calling public provider functions, or
`Fake.Name.last_name` where appropriate, with the same generator and locale,
then pass the chosen values to locale-owned formatters.

The internal locale data shape grows by one record:

```ocaml
type name_pattern = {
  last_name_count : int;
  uses_suffix : bool;
}

type company = {
  suffixes : string array;
  buzzwords : string array;
  catch_phrase_words : string array array;
  buzz_phrase_words : string array array;
  name_patterns : name_pattern array;
  format_company_name :
    pattern:int -> last_names:string list -> suffix:string -> string;
  format_catch_phrase : string list -> string;
  format_buzz_phrase : string list -> string;
}

type t = {
  name : name;
  internet : internet;
  lorem : lorem;
  address : address;
  company : company;
}
```

`catch_phrase_words` and `buzz_phrase_words` each contain exactly three
non-empty arrays in the first provider. `name_patterns` must be non-empty.
Each `name_pattern` declares how many `Fake.Name.last_name` values
`Fake.Company.name` draws for that pattern and whether it draws
`Fake.Company.suffix` before calling `format_company_name`. Locale modules must
keep `name_patterns` consistent with `format_company_name` pattern indices.

English `name_patterns`:

- pattern 0: `{ last_name_count = 1; uses_suffix = true }`
- pattern 1: `{ last_name_count = 2; uses_suffix = false }`
- pattern 2: `{ last_name_count = 3; uses_suffix = false }`

Japanese `name_patterns`:

- pattern 0: `{ last_name_count = 1; uses_suffix = false }`
- pattern 1: `{ last_name_count = 1; uses_suffix = false }`
- pattern 2: `{ last_name_count = 2; uses_suffix = false }`

`format_company_name` receives the selected pattern index, the already-drawn
last names for that pattern, and a suffix string. When `uses_suffix` is false,
`Fake.Company.name` must not draw `suffix` and must pass `""` to
`format_company_name`.

English formatting:

- `format_company_name 0 [last] suffix`: `"<last> <suffix>"`
- `format_company_name 1 [left; right] _suffix`: `"<left>-<right>"`
- `format_company_name 2 [first; second; third] _suffix`:
  `"<first>, <second> and <third>"`
- `format_catch_phrase`: capitalize the first list element with
  `String.capitalize_ascii`, join all elements with single spaces, and leave
  other elements unchanged (same rule as `format_sentence` in `locale_data_en.ml`)
- `format_buzz_phrase`: map each element with `String.lowercase_ascii`, then join
  with single spaces

Japanese formatting:

- `format_company_name 0 [last] _suffix`: `"株式会社<last>"`
- `format_company_name 1 [last] _suffix`: `"<last>株式会社"`
- `format_company_name 2 [left; right] _suffix`: `"<left><right>グループ"`
- `format_catch_phrase`: join with no spaces
- `format_buzz_phrase`: join with no spaces

`ja_jp` `name` patterns embed `株式会社` or `グループ` literally; they do not
use the `suffixes` array. This differs from Faker Ruby `ja`, which inserts a
`category` segment between name parts.

`Fake.Company.name` should draw component values in this order:

1. pattern index in `0 .. Array.length name_patterns - 1` via `Generator.int`
2. `last_name_count` calls to `Fake.Name.last_name` for the selected pattern
3. `Fake.Company.suffix` only when `name_patterns.(pattern).uses_suffix`
4. locale-owned `format_company_name`

`Fake.Company.catch_phrase` should draw component values in this order:

1. one word from `catch_phrase_words.(0)`
2. one word from `catch_phrase_words.(1)`
3. one word from `catch_phrase_words.(2)`

`Fake.Company.buzz_phrase` should draw component values in this order:

1. one word from `buzz_phrase_words.(0)`
2. one word from `buzz_phrase_words.(1)`
3. one word from `buzz_phrase_words.(2)`

`Fake.Company.suffix` and `Fake.Company.buzzword` are independent primitive
selectors.

This order keeps composed-provider behavior deterministic and straightforward
to test. The project still does not promise long-term byte-for-byte sequence
compatibility across future implementation or runtime changes.

## Contracts

Public interface:

```ocaml
val suffix : generator:Generator.t -> locale:Locale.t -> string
val buzzword : generator:Generator.t -> locale:Locale.t -> string
val name : generator:Generator.t -> locale:Locale.t -> string
val catch_phrase : generator:Generator.t -> locale:Locale.t -> string
val buzz_phrase : generator:Generator.t -> locale:Locale.t -> string
```

Public comments in `company.mli` should document the locale-aware return value
for each function and note that invalid shipped data may surface
`Invalid_argument` through `Generator.choose` or `Generator.int`.

`fake.mli` and `fake.ml` should re-export `Company`.

## Alternatives Considered

- `bs` instead of `buzz_phrase`: rejected because faker.js has moved toward
  `buzzPhrase` and fake-ocaml should use one canonical snake_case name.
- Only `name`: rejected because fixture builders often need suffixes and
  marketing phrases independently.
- Dedicated `company_name_roots` instead of `Fake.Name.last_name`: deferred to
  keep the first provider narrow; locale-owned patterns still allow later
  migration without changing the public function set.
- Fine-grained public part selectors such as `buzz_verb`: deferred because the
  first pass only needs composed phrases plus one-word `buzzword`.
- `industry` and `department` in Company: deferred because they fit better in
  a later Job or metadata provider.
- Country-specific registration numbers: rejected because they require separate
  formatting contracts beyond fixture selection.

## Third-Party Review

A context-free sub-agent reviewed this draft before implementation. The review
requested explicit per-pattern metadata (`name_patterns`), a mandatory rule that
`suffix` is drawn only when `uses_suffix` is true, precise English phrase
formatting rules, and an explicit data policy for `ja_jp` suffix/name coupling.
Those changes were incorporated before implementation.

## Validation

- `test/company_test.ml` should cover primitive values being non-empty for both
  locales.
- `test/company_test.ml` should cover English and Japanese `name` formatting
  patterns.
- `test/company_test.ml` should cover English and Japanese `catch_phrase` and
  `buzz_phrase` formatting.
- `test/company_test.ml` should cover `name` draw order for at least one seed
  per pattern in each locale by replaying `Generator.int`, `last_name`, and
  optional `suffix` draws.
- `test/company_test.ml` should assert each `catch_phrase_words` and
  `buzz_phrase_words` group is non-empty for shipped locales.
- Static contract tests should include `lib/company.ml` so provider modules do
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
- Should `name` stop depending on `Fake.Name.last_name` once dedicated
  company-name roots exist?
