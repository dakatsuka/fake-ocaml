# Initial Architecture

## Status

Draft

## Context

fake-ocaml starts as a small OCaml 5.x library and CLI for generating
locale-aware fake data. The project favors explicit state, compiled locale data,
and narrow public APIs.

## Goals

- Establish a minimal Dune/opam project structure.
- Keep runtime dependencies out of the first implementation.
- Make locale data type-checked OCaml code.
- Keep random generation reproducible for tests through explicit generator
  values.
- Provide enough provider surface to validate library, locale, and CLI design.

## Non-Goals

- PPX derive support.
- Large locale datasets.
- Runtime loading of external locale files.

## Proposed Design

The project contains one public library, `fake`, and one public executable,
`fake`.

The library is organized around small modules:

- `Generator` wraps `Random.State.t` and stores the original seed.
- `Locale` defines supported locale identifiers and string conversion.
- `Locale_data` stores typed OCaml data for each locale behind a shared module
  signature.
- `Name`, `Internet`, and `Lorem` expose provider functions that consume
  explicit `generator` and `locale` arguments.

Provider functions advance the supplied generator. Creating a new generator with
the same seed recreates the same sequence for the current implementation.

The CLI maps stable provider identifiers such as `name.full_name` to public
provider functions. It supports text and JSON Lines output without adding a JSON
library dependency.

## Contracts

Public contracts are defined in `.mli` files before implementation. Public
functions include block comments that describe arguments, return values, and
important failure modes.

Locale data uses arrays for compact constant data and direct indexed selection.
Empty provider arrays are invalid and cause `Generator.choose` to raise
`Invalid_argument`.

## Alternatives Considered

- Global default generator: rejected for the first version because it makes
  tests and concurrent usage harder to reason about.
- YAML/TOML locale files: rejected because the initial requirement prefers pure
  OCaml locale definitions and minimal dependencies.
- Initial PPX package: deferred to avoid widening the first API before the core
  provider model is proven.

## Third-Party Review

A context-free sub-agent reviewed the design direction before implementation.
The review requested fixed provider scope, explicit test dependency policy,
concrete API signatures, stable CLI provider identifiers, JSONL schema, and CI
commands. Those points are incorporated in this design.

## Validation

- Alcotest unit tests cover generator reproducibility, locale parsing, and
  provider behavior.
- CLI tests cover text output, JSONL output, deterministic seeds, and invalid
  locale handling.
- CI runs build, test, format, static, install, and opam lint checks on OCaml
  5.0.x and 5.4.x.

## Open Questions

- Final opam package naming must be confirmed before publication.
- PPX derive API shape requires a later product spec and design document.
