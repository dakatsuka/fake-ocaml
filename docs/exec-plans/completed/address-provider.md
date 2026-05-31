# Address Provider Implementation

## Status

Completed

## Objective

Implement `Fake.Address` according to the draft Address provider product spec
and design. The provider exposes primitive address selectors and composed
street/full address functions for the existing `en` and `ja_jp` locales.

## Context

- Product spec: `docs/product-specs/address-provider.md`
- Design doc: `docs/design-docs/address-provider.md`
- Reference: `docs/references/faker-ruby-address.md`
- Accepted initial API: `docs/product-specs/initial-public-api.md`

## Clarifications

- The design review completed before implementation and found no remaining
  implementation-blocking ambiguity.
- Initial address data uses fictional, locale-shaped sample values.
- `community` and `secondary_address` are primitive selectors, not components
  of `full_address` in this pass.

## Contract First

Add:

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

## Steps

- [x] Explore: inspect Address specs, existing provider modules, locale data,
      and tests.
- [x] Design review: request context-free review and incorporate feedback.
- [x] Red: add `address.mli`, expose `Fake.Address`, and add failing tests.
- [x] Green: implement address locale data and provider functions.
- [x] Refactor: keep locale-owned formatting in locale data and provider-generic
      composition in `Address`.
- [x] Static checks: run formatting and static analysis, then fix findings.
- [x] Code review: request context-free review after implementation.
- [x] Re-review: fix review findings and repeat review until it passes.

## Decisions

- `street_address` draws `building_number` before `street_name`.
- `full_address` draws `postal_code`, `region`, `city`, then
  `street_address`.
- `secondary_address` is independent and not included in `full_address`.
- Static contract checks include `lib/address.ml`.

## Verification

- `dune runtest`: failed before implementation because `address.mli` and
  `Fake.Address` were present without `address.ml`.
- `dune build @fmt`: passed.
- `dune build @all`: passed.
- `dune runtest --force`: passed.
- `dune build @check`: passed.
- `dune build @install`: passed.
- `opam lint fake.opam`: passed.
- `git diff --check`: passed.

## Completion Notes

- Added `Fake.Address` with primitive selectors, `street_address`, and
  `full_address`.
- Added fictional English and Japanese address locale data.
- Added locale-owned street/full address formatting.
- Added Address tests for primitive generation and locale-specific formatting.
- Updated README provider list and future-work notes.
- A context-free code review found no blocking issues. Low-severity findings
  about interface exception documentation, design-review status, and README
  wording were fixed.

## Commit

Not committed yet.
