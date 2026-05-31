# Lorem Paragraph Provider

## Status

Completed

## Objective

Add `Fake.Lorem.paragraph` as the next narrow public provider extension. The
function generates a short locale-aware paragraph using the existing explicit
generator and locale model.

## Context

- Product spec: `docs/product-specs/initial-public-api.md`
- Design doc: `docs/design-docs/initial-architecture.md`
- ADR: `docs/design-docs/adr/0001-library-only-package.md`

## Clarifications

- The provider belongs to the existing `Lorem` module rather than introducing a
  new broad provider domain.
- Paragraph formatting is locale-specific behavior and lives in compiled locale
  data.
- The generated paragraph is short and fixture-oriented, not a large text
  generation API.

## Contract First

Extend the public `Lorem` contract:

```ocaml
val paragraph : generator:Generator.t -> locale:Locale.t -> string
(** [paragraph ~generator ~locale] returns a short locale-specific placeholder
    paragraph. *)
```

## Steps

- [x] Explore: inspect existing `Lorem`, locale data, specs, and tests.
- [x] Design review: request context-free review and incorporate feedback.
- [x] Red: add behavior-focused tests for English and Japanese paragraph
      formatting before implementation.
- [x] Green: implement the smallest changes that satisfy the tests:
      `lorem.mli`, `lorem.ml`, `locale_data_types.ml`,
      `locale_data_types.mli`, `locale_data.ml`, `locale_data.mli`, and each
      locale data module.
- [x] Refactor: keep locale formatting owned by locale data and provider
      composition owned by `Lorem`.
- [x] Static checks: run formatting and static analysis, then fix findings.
- [x] Code review: request context-free review after implementation.
- [x] Re-review: fix review findings and repeat review until it passes.

## Decisions

- Paragraphs contain three to five generated sentences.
- `Lorem.paragraph` draws the paragraph sentence count before generating the
  component sentences.
- English paragraphs join sentences with a single space.
- Japanese paragraphs join sentences without an extra separator.
- Context-free design review found the provider addition and locale-owned
  formatting boundary consistent with the repository direction. It requested
  more explicit product-spec coverage for paragraph sentence joining, more
  explicit locale-data implementation scope in this plan, and a recorded
  generator consumption order; those changes were incorporated.

## Verification

- `dune runtest`: failed before implementation because `Lorem.paragraph` was
  declared in `lorem.mli` but missing from `lorem.ml`.
- `dune build @all`: passed.
- `dune runtest --force`: passed.
- `dune build @fmt`: passed.
- `dune build @check`: passed.
- `dune build @install`: passed.
- `opam lint fake.opam`: passed.
- `git diff --check`: passed.

## Completion Notes

- Added `Fake.Lorem.paragraph` to the public API.
- Added locale-owned paragraph formatting to compiled English and Japanese
  locale data.
- Added tests for paragraph formatting and the three-to-five sentence range.
- Updated product spec, architecture, README, and execution plan index.
- Context-free implementation review found no blocking issues. Low-severity
  documentation and plan-index drift findings were fixed.

## Commit

Not committed yet.
