# Review-Driven API Hardening

## Status

Active

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

- The primary user experience is OCaml library usage; the CLI remains a
  secondary interface.
- Locale extensibility is the main architectural risk identified by independent
  review.
- Improvements should preserve the initial provider scope: `Name`, `Internet`,
  and `Lorem`.

## Plan Assessment

This is the right next plan to execute. The completed foundation already has a
usable library, CLI, tests, and private locale data modules, but the public
locale type still exposes constructors and provider modules still contain
locale-specific formatting branches. Those choices are acceptable for a first
foundation, but they become compatibility liabilities once callers depend on
the API.

The next work item is therefore:

1. Harden public contracts before adding providers.
2. Make locale extension an internal data change instead of a public variant
   change.
3. Add tests for documented failure modes and CLI edge cases that are currently
   under-specified.

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
- Move provider formatting branches out of provider modules. `Locale_data`
  should expose only the minimal locale-owned formatting functions needed by
  providers:
  - `name.format_full_name : first:string -> last:string -> string`
  - `lorem.format_sentence : string list -> string`
- Keep `Internet.email` provider-owned for now because the current product
  contract defines no locale-specific email formatting.
- Avoid turning CLI JSON rendering into public library API. If direct escaping
  tests are needed, move the escaping helper into a private testable module
  owned by the executable.
- Do not add generator splitting or copying in this plan. Those operations need
  a separate product decision because they create stronger reproducibility
  promises.

## Steps

- [ ] Explore: inspect current public API, locale data flow, tests, and docs.
- [ ] Design review: request sub-agent review for the revised locale and
      generator design before implementation.
- [ ] Red: add focused tests for:
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
      - CLI JSONL schema and string escaping;
      - CLI negative paths for missing provider, unknown provider, unknown
        locale, invalid format, non-positive count, and unexpected positional
        arguments.
- [ ] Green: implement the smallest API/design changes that satisfy the updated
      contracts.
- [ ] Refactor: keep locale data maintainable by locale while avoiding public
      exposure of internal data representation or provider-side locale
      branching.
- [ ] Static checks: run formatting and static checks, then fix findings.
- [ ] Code review: request sub-agent review after implementation.
- [ ] Re-review: fix review findings and repeat review until it passes.

## Decisions

Record final decisions during this task for:

- Locale type abstraction and extension strategy. Current planned decision:
  public `Locale.t` is abstract before release.
- Locale-owned formatting templates or functions. Current planned decision:
  move full-name and lorem-sentence locale branches into compiled locale data.
- Generator state sharing and reproducibility semantics. Current planned
  decision: mutable sequential generators only; no copy/split/domain-safe
  sharing contract.
- Documentation status: keep the initial product spec and design doc in `Draft`
  until implementation and verification pass, then consider moving them to
  `Accepted`.

## Verification

- `dune build @all`
- `dune runtest`
- `dune build @fmt`
- `dune build @check`
- `dune build @install`
- `opam lint fake.opam`

## Completion Notes

To be filled when implementation finishes.

## Commit

To be filled when committed.
