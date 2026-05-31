# Review-Driven API Hardening

## Status

Completed

## Objective

Address the third-party review findings from the initial foundation before the
public API grows. The work should improve locale extensibility, generator
semantics, and contract coverage without broadening provider scope.

The next implementation task is contract hardening, not provider expansion.
Start by making the public locale and generator contracts explicit in docs and
interfaces, then change the smallest implementation surface needed to satisfy
those contracts.

## Context

- Product spec: `docs/product-specs/initial-public-api.md`
- Design doc: `docs/design-docs/initial-architecture.md`
- Completed plan: `docs/exec-plans/completed/initial-project-foundation.md`

## Clarifications

- The primary user experience is OCaml library usage.
- The previous program surface is secondary and is later superseded by ADR 0001.
- Locale extensibility is the main architectural risk identified by independent
  review.
- Improvements should preserve the initial provider scope: `Name`, `Internet`,
  and `Lorem`.

## Plan Assessment

This is the right next plan to execute. The completed foundation already has a
usable library, program surface, tests, and private locale data modules, but the
public locale type still exposes constructors and provider modules still contain
locale-specific formatting branches. Those choices are acceptable for a first
foundation, but they become compatibility liabilities once callers depend on the
API.

The next work item is therefore:

1. Harden public contracts before adding providers.
2. Make locale extension an internal data change instead of a public variant
   change.
3. Add tests for documented failure modes and program edge cases that are
   currently under-specified.

The plan intentionally defers broader generator features and new provider
domains. Adding split/copy semantics or address/company/payment providers would
increase API surface before the current contracts are stable.

## Contract First

The product spec and design doc now choose the following direction for the
hardening pass:

- `Locale.t` becomes abstract in the public API before release. Public callers
  use `Locale.en`, `Locale.ja_jp`, `Locale.all`, `Locale.to_string`, and
  `Locale.of_string` rather than constructors.
- `Locale.all` has stable initial ordering: `[Locale.en; Locale.ja_jp]`.
- Locale-specific formatting belongs in compiled locale data when the rule
  varies by locale. For the initial scope, that means `Name.full_name` order and
  separator plus `Lorem.sentence` joining, capitalization, and punctuation.
- `Generator.t` remains mutable and sequential. The public contract does not
  include copy, split, jump, or domain/thread-safe sharing operations in this
  pass. Callers create separate generators with explicit seeds for independent
  streams.
- Provider scope remains fixed at `Name`, `Internet`, and `Lorem`.

Before internal implementation, update public `.mli` comments to match those
decisions and keep the exported signatures narrow:

```ocaml
module Locale : sig
  type t

  val en : t
  val ja_jp : t
  val all : t list
  val to_string : t -> string
  val of_string : string -> (t, string) result
end
```

## Design Notes

Recommended implementation shape:

- Hide locale constructors in `locale.mli`; if the implementation keeps private
  variants internally, do not expose them through the interface.
- Dispatch from `Locale_data.get` through the narrow public locale contract,
  currently `Locale.to_string`, so provider modules and locale data lookup do
  not depend on public constructors.
- Move provider formatting branches out of provider modules. `Locale_data`
  should expose only the minimal locale-owned formatting functions needed by
  providers:
  - `name.format_full_name : first:string -> last:string -> string`
  - `lorem.format_sentence : string list -> string`
- Keep `Internet.email` provider-owned for now because the current product
  contract defines no locale-specific email formatting.
- Avoid turning program JSON rendering into public library API. If direct
  escaping tests are needed, move the escaping helper into a private testable
  module owned by the program.
- Do not add generator splitting or copying in this plan. Those operations need
  a separate product decision because they create stronger reproducibility
  promises.
- Treat source-level locale opacity and provider constructor references as
  static contract checks. The behavior tests remain black-box, while a focused
  shell check verifies `locale.mli` exposes `type t` without constructors and
  provider modules no longer mention `Locale.En` or `Locale.Ja_jp`.

## Steps

- [x] Explore: inspect current public API, locale data flow, tests, and docs.
- [x] Design review: request sub-agent review for the revised locale and
      generator design before implementation.
- [x] Red: add focused tests for:
      - public locale opacity by checking that `lib/locale.mli` exposes
        `type t` without constructors, plus a black-box test using only
        `Fake.Locale.en`, `Fake.Locale.ja_jp`, `Fake.Locale.all`,
        `Fake.Locale.to_string`, and `Fake.Locale.of_string`;
      - stable `Locale.all` ordering;
      - `Locale.of_string` accepted and rejected identifiers;
      - `Generator.int` and `Generator.choose` documented exceptions;
      - same-seed generator reproducibility and state advancement;
      - locale-owned formatting for English and Japanese full names;
      - locale-owned formatting for English and Japanese lorem sentences;
      - program JSONL schema and string escaping;
      - program negative paths for missing provider, unknown provider, unknown
        locale, invalid format, non-positive count, and unexpected positional
        arguments.
- [x] Green: implement the smallest API/design changes that satisfy the updated
      contracts.
- [x] Refactor: keep locale data maintainable by locale while avoiding public
      exposure of internal data representation or provider-side locale
      branching.
- [x] Static checks: run formatting and static checks, then fix findings.
- [x] Code review: request sub-agent review after implementation.
- [x] Re-review: fix review findings and repeat review until it passes.

## Decisions

- Public `Locale.t` is abstract. The implementation may keep private
  constructors, but callers use `Locale.en`, `Locale.ja_jp`, `Locale.all`,
  `Locale.to_string`, and `Locale.of_string`.
- `Locale_data.get` dispatches through `Locale.to_string` so locale data lookup
  does not require public constructors.
- Locale-specific full-name and lorem sentence formatting now lives in compiled
  locale data records through `format_full_name` and `format_sentence`.
- `Generator.t` remains mutable and sequential. The API still does not expose
  copy, split, jump, or domain-safe sharing operations.
- JSON escaping remains private to the program through a small helper library
  used for focused tests. This decision is no longer current after ADR 0001.
- The initial product spec and design doc remained `Draft` after this plan.
  They were accepted later during documentation maintenance after the initial
  public API had settled.

## Verification

- `dune build @all`: passed.
- `dune runtest --force`: passed.
- `dune build @fmt`: passed.
- `dune build @check`: passed.
- `dune build @install`: passed.
- `opam lint fake.opam`: passed.
- `git diff --check`: passed.

## Completion Notes

- Hardened the public locale contract by making `Locale.t` abstract in
  `locale.mli`.
- Moved locale-varying provider formatting from `Name` and `Lorem` into
  compiled locale data.
- Added black-box locale tests, generator contract tests, provider formatting
  tests, program JSON escaping tests, program negative-path tests, and
  source-level static contract checks.
- Added `*.install` to `.gitignore` because `dune build @install` generates a
  package install file in the repository root.
- A context-free implementation review found no blocking issues. Residual risks
  are that JSON escaping is tested through the private helper rather than an
  end-to-end generated value, and the static provider check is grep-based.
- The program surface from this plan is removed by ADR 0001 and the
  `Remove Program Surface` execution plan.

## Commit

`a5e62de feat: harden initial public API contracts`
