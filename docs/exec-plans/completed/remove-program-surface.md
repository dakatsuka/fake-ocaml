# Remove Program Surface

## Status

Completed

## Objective

Remove the extra public program surface and all related implementation, tests,
and documentation. The project should present only the OCaml library API as its
initial product surface.

## Context

- Product spec: `docs/product-specs/initial-public-api.md`
- Design doc: `docs/design-docs/initial-architecture.md`
- ADR: `docs/design-docs/adr/0001-library-only-package.md`
- README: `README.md`
- Repository workflow: `AGENTS.md`

## Clarifications

- The public package should expose the `fake` OCaml library only.
- Existing program implementation, helper modules, and program-focused tests can
  be deleted.
- Historical execution plans should preserve facts from completed work while
  marking the program surface as superseded by ADR 0001.

## Contract First

No new public OCaml API is introduced. The existing library contract remains:

```ocaml
module Generator : sig
  type t

  val make : seed:int -> t
  val seed : t -> int
  val int : t -> bound:int -> int
  val choose : t -> 'a array -> 'a
end

module Locale : sig
  type t

  val en : t
  val ja_jp : t
  val all : t list
  val to_string : t -> string
  val of_string : string -> (t, string) result
end
```

Provider modules remain `Name`, `Internet`, and `Lorem`.

## Steps

- [x] Explore: locate all program references in docs, build files, source,
      and tests.
- [x] Design update: update product spec, architecture, and ADRs for the
      library-only package boundary, and update the README public usage docs.
- [x] Design review: request context-free review before implementation.
- [x] Red: verify the current tree still contains program references and
      program tests that must be removed.
- [x] Green: delete program source, helper modules, and tests; update Dune
      stanzas and package descriptions.
- [x] Refactor: remove stale documentation from completed execution plans while
      preserving library history and verification notes.
- [x] Static checks: run formatting and static checks, then fix findings.
- [x] Code review: request context-free review after implementation.
- [x] Re-review: fix review findings and repeat review until it passes.

## Decisions

- The package is library-only for the initial product surface. Reintroducing a
  public program requires a new product spec, design update, and execution plan.
- The historical completed execution plans preserve the fact that a program
  surface existed during earlier work, but mark it as superseded by ADR 0001.
- README and package metadata describe only the library.

## Verification

- Repository grep for removed program-surface tokens: passed.
- Verify `_build/default/fake.install` contains no `bin` entries after
  `dune build @install`: passed.
- Verify no Dune stanza declares a public program form: passed.
- `dune build @all`: passed.
- `dune runtest --force`: passed.
- `dune build @fmt`: passed.
- `dune build @check`: passed.
- `dune build @install`: passed.
- `opam lint fake.opam`: passed.
- `git diff --check`: passed.

## Completion Notes

- Removed the `bin/` program implementation and private JSON helper library.
- Removed program-focused tests and Dune stanzas, leaving library unit tests and
  static contract checks.
- Updated README, product spec, architecture, package metadata, ADR index, and
  completed plans for the library-only package boundary.
- A context-free implementation review found no blocking issues. Historical
  completed plans intentionally mention the old program surface as superseded
  context.

## Commit

`b1c4f5f refactor: remove public program surface`
