# Company Provider Implementation

## Status

Completed

## Objective

Implement `Fake.Company` according to the accepted Company provider product
spec and design. The provider exposes primitive company selectors and composed
name and phrase functions for the existing `en` and `ja_jp` locales.

## Context

- Product spec: `docs/product-specs/company-provider.md`
- Design doc: `docs/design-docs/company-provider.md`
- Reference: `docs/references/faker-ruby-company.md`
- Accepted initial API: `docs/product-specs/initial-public-api.md`

## Clarifications

- The design review completed before implementation and found no remaining
  implementation-blocking ambiguity after adding `name_patterns` metadata.
- Initial company data uses fictional, locale-shaped sample values.
- `name` reuses `Fake.Name.last_name` for name parts in this pass.
- `ja_jp` `name` patterns embed `株式会社` or `グループ` directly and do not
  draw `suffix`.

## Contract First

Add:

```ocaml
module Company : sig
  val suffix : generator:Generator.t -> locale:Locale.t -> string
  val buzzword : generator:Generator.t -> locale:Locale.t -> string
  val name : generator:Generator.t -> locale:Locale.t -> string
  val catch_phrase : generator:Generator.t -> locale:Locale.t -> string
  val buzz_phrase : generator:Generator.t -> locale:Locale.t -> string
end
```

## Steps

- [x] Explore: inspect Company specs, existing provider modules, locale data,
      and tests.
- [x] Design review: request context-free review and incorporate feedback.
- [x] Red: add `company.mli`, expose `Fake.Company`, and add failing tests.
- [x] Green: implement company locale data and provider functions.
- [x] Refactor: keep locale-owned formatting in locale data and provider-generic
      composition in `Company`.
- [x] Static checks: run formatting and static analysis, then fix findings.
- [x] Code review: request context-free review after implementation.
- [x] Re-review: fix review findings and repeat review until it passes.

## Decisions

- `name` draws pattern index, required `last_name` values, optional `suffix`,
  then `format_company_name`.
- `catch_phrase` and `buzz_phrase` each draw three phrase parts in order.
- Static contract checks include `lib/company.ml`.
- Company tests cover each locale-owned name pattern with seed replay.

## Verification

- `dune build @all`: passed.
- `dune runtest --force`: passed.
- `dune build @fmt`: passed.
- `dune build @check`: passed.
- `dune build @install`: passed.
- `opam lint fake.opam`: passed.
- `git diff --check`: passed.

## Completion Notes

- Added `Fake.Company` with `suffix`, `buzzword`, `name`, `catch_phrase`, and
  `buzz_phrase`.
- Added fictional English and Japanese company locale data with locale-owned
  name patterns and phrase formatting.
- Added `name_patterns` metadata so `suffix` is drawn only when required.
- Added Company tests for primitives, per-pattern name formatting, phrase
  repeatability, and locale-specific phrase formatting.
- Updated README provider list and initial-public-api future-work notes.
- A context-free code review found no blocking issues. Per-pattern name tests
  and `company.mli` exception documentation were added after review.

## Commit

Record the Conventional Commits-compliant commit message used for the work.
