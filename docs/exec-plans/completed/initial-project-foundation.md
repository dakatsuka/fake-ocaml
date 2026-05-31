# Initial Project Foundation

## Status

Completed

## Objective

Create the first usable OCaml 5.x project foundation for fake-ocaml, including
the public library API, initial program surface, tests, CI, and governing
documentation.

## Context

- Product spec: `docs/product-specs/initial-public-api.md`
- Design doc: `docs/design-docs/initial-architecture.md`
- Repository workflow: `AGENTS.md`

## Clarifications

- Initial API shape is core library first; PPX is future work.
- Random generation uses explicit `Fake.Generator.t`.
- Initial program surface supports locale, seed, provider, count, and text or
  JSONL output. This surface is later superseded by ADR 0001.
- Initial providers are `Name`, `Internet`, and `Lorem`.
- Alcotest is accepted as a test-only dependency.

## Contract First

Define public `.mli` contracts for:

- `Fake.Generator`
- `Fake.Locale`
- `Fake.Name`
- `Fake.Internet`
- `Fake.Lorem`

## Steps

- [x] Explore: inspect existing code, specs, design docs, and tests.
- [x] Design review: request sub-agent review and incorporate feedback.
- [x] Red: define behavior-focused tests for generator, locale, providers, and
      the initial program surface.
- [x] Green: implement the smallest library and program surface that satisfy
      the tests.
- [x] Refactor: improve structure while keeping tests green.
- [x] Static checks: run formatting and static checks, then fix findings.
- [x] Code review: request sub-agent review after implementation.
- [x] Re-review: fix review findings and repeat review until it passes.

## Decisions

- Runtime dependencies stay limited to stdlib and Dune.
- Locale data is OCaml source, not external data files.
- Initial provider identifiers use dotted names in the program surface. This
  decision is no longer current after ADR 0001.
- JSONL is produced manually to avoid a runtime JSON dependency. This decision
  is no longer current after ADR 0001.

## Verification

- `dune build @all`
- `dune runtest`
- `dune build @fmt`
- `dune build @check`
- `dune build @install`
- `opam lint fake.opam`

## Completion Notes

- Added the initial Dune/opam project, public library, program surface, tests,
  CI, product spec, and design doc.
- Code review findings were addressed by hiding internal locale data, splitting
- unit tests by module, and expanding negative-path coverage.
- Final verification passed locally.
- The program surface from this plan is removed by ADR 0001 and the
  `Remove Program Surface` execution plan.

## Commit

`44f569b feat: scaffold initial fake data library`
