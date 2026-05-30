# Review-Driven API Hardening

## Status

Active

## Objective

Address the third-party review findings from the initial foundation before the
public API grows. The work should improve locale extensibility, generator
semantics, and contract coverage without broadening provider scope.

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

## Contract First

Before implementation, update the product spec and design doc to decide:

- Whether `Locale.t` should become abstract before the API is released.
- Which locale-specific formatting rules belong in compiled locale data.
- What `Generator.t` promises for mutation, sharing across domains/threads,
  copying, splitting, and deterministic composition.
- Which contract tests are required for documented exceptions, locale parsing,
  provider formatting, and CLI JSON escaping.

## Steps

- [ ] Explore: inspect current public API, locale data flow, tests, and docs.
- [ ] Design review: request sub-agent review for the revised locale and
      generator design before implementation.
- [ ] Red: add focused tests for locale extensibility decisions, generator
      exception contracts, locale parsing, provider formatting, CLI JSON
      escaping, and CLI negative paths.
- [ ] Green: implement the smallest API/design changes that satisfy the updated
      contracts.
- [ ] Refactor: keep locale data maintainable by locale while avoiding public
      exposure of internal data representation.
- [ ] Static checks: run formatting and static checks, then fix findings.
- [ ] Code review: request sub-agent review after implementation.
- [ ] Re-review: fix review findings and repeat review until it passes.

## Decisions

Record final decisions during this task for:

- Locale type abstraction and extension strategy.
- Locale-owned formatting templates or functions.
- Generator state sharing and reproducibility semantics.
- Documentation status: whether the initial product spec and design doc should
  move from `Draft` to `Accepted`.

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
