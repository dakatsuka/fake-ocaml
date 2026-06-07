# Company Provider

## Status

Accepted

## Problem

Users need locale-aware company fixture data after the accepted initial
providers and Address provider. Company names, legal-entity suffixes, and
marketing-style phrases have visible locale-specific formatting rules, so Company
is a good next provider domain for extending the compiled-locale model without
adding runtime dependencies or external locale files.

## Goals

- Add a focused `Fake.Company` provider module.
- Keep provider APIs consistent with the accepted initial API: explicit
  `generator` and `locale` arguments.
- Support the existing `en` and `ja_jp` locales.
- Keep locale data compiled as OCaml modules.
- Keep runtime dependencies limited to the OCaml standard library and Dune.
- Keep locale-specific company-name patterns and phrase formatting in compiled
  locale data.

## Data Policy

- Shipped company locale data uses fictional marketing and legal-entity sample
  strings shaped for fixtures. Values must not imply real-world business
  registration correctness.
- `name` composes values from `Fake.Name.last_name` in the first provider.
  Japanese last-name arrays contain common surname forms; they are reused as
  company-name roots for fixture plausibility, not as claims about real brands.
- `ja_jp` `name` patterns embed `株式会社` or `グループ` directly. The `suffix`
  selector returns independent organizational suffix samples and is not always
  the same suffix used inside `name`.

## Non-Goals

- Real company registries, tax identifiers, or legally valid registration
  numbers are out of scope.
- Industry, department, profession, company type, logos, and country-specific
  registration APIs are out of scope for the first Company provider.
- Long-term byte-for-byte sequence compatibility remains out of scope.
- Runtime loading of external company datasets is out of scope.
- Compatibility aliases such as `bs` are out of scope; `buzz_phrase` is the
  canonical public name.

## Requirements

- `Company` is exposed from the public `Fake` module.
- Provider functions require explicit `generator` and `locale` arguments.
- Shipped company locale data uses fictional, locale-shaped sample values that
  look plausible for fixtures but must not claim real-world business correctness.
- `suffix` returns a locale-specific legal-entity or organizational suffix
  string. For `en`, examples include `Inc` and `LLC`. For `ja_jp`, examples
  include `株式会社` and `合同会社`.
- `buzzword` returns one locale-specific marketing or business-jargon word.
- `name` composes one or more person-style name parts and an optional suffix
  using locale-owned company-name patterns.
- `catch_phrase` composes three locale-specific phrase parts using locale-owned
  formatting.
- `buzz_phrase` composes three locale-specific business-jargon parts using
  locale-owned formatting.
- `name` may reuse `Fake.Name.last_name` for name parts in the first provider,
  but locale-owned patterns decide how many parts are drawn and how they are
  ordered relative to suffixes.
- `en` company-name patterns:
  - `"<last_name> <suffix>"`
  - `"<last_name>-<last_name>"`
  - `"<last_name>, <last_name> and <last_name>"`
- `ja_jp` company-name patterns:
  - `"株式会社<last_name>"`
  - `"<last_name>株式会社"`
  - `"<last_name><last_name>グループ"`
- `en` phrase formatting:
  - `catch_phrase`: space-separated words; capitalize the first list element
    only
  - `buzz_phrase`: space-separated words; lowercase each element before joining
- `ja_jp` phrase formatting:
  - `catch_phrase`: locale-specific words joined with no spaces
  - `buzz_phrase`: locale-specific words joined with no spaces
- `ja_jp` company-name patterns are a first-pass shape. They intentionally omit
  Faker Ruby's `category` segment and differ from Ruby `ja` templates.

## Public Contracts

```ocaml
module Company : sig
  val suffix : generator:Generator.t -> locale:Locale.t -> string
  val buzzword : generator:Generator.t -> locale:Locale.t -> string
  val name : generator:Generator.t -> locale:Locale.t -> string
  val catch_phrase : generator:Generator.t -> locale:Locale.t -> string
  val buzz_phrase : generator:Generator.t -> locale:Locale.t -> string
end
```

Provider functions may surface `Invalid_argument` from `Generator.choose` or
`Generator.int` if compiled locale data is invalid. Shipped `suffixes`,
`buzzwords`, and each nested phrase-word group must be non-empty; shipped
`name_patterns` must be non-empty.

## Examples

```ocaml
let generator = Fake.Generator.make ~seed:42

let company_name =
  Fake.Company.name ~generator ~locale:Fake.Locale.en
```

```ocaml
let catch_phrase =
  Fake.Company.catch_phrase ~generator ~locale:Fake.Locale.ja_jp
```

## Open Questions

- Should a later API expose `industry` or `department`, or should those belong
  to a separate Job provider?
- Should `name` eventually stop reusing `Fake.Name.last_name` and use dedicated
  company-name roots per locale?
- Should a later compatibility-oriented layer expose `bs` as an alias for
  `buzz_phrase`?
