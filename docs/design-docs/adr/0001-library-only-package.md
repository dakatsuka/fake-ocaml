# ADR 0001: Library-Only Package

## Status

Accepted

## Context

fake-ocaml's primary value is an OCaml library for reproducible, locale-aware
fixture data. Keeping the first product surface limited to library modules makes
the API boundary smaller and keeps provider behavior specified in one place.

The package previously included an additional public program surface. That
surface duplicated provider selection and output behavior outside the library
contract, which increased documentation and testing scope without improving the
primary OCaml use case.

## Decision

Ship the initial package as the `fake` OCaml library only. The public product
surface is the library API documented in `docs/product-specs/initial-public-api.md`.

Build files, tests, package metadata, and design documents should avoid adding a
public program surface until a later product spec explicitly reintroduces one.

## Consequences

- The package has one public artifact: the `fake` library.
- Provider behavior is validated through OCaml tests rather than a second public
  invocation layer.
- Output encoding behavior outside OCaml values is not part of the initial
  contract.
- A future public program would require a new product spec, design update, and
  execution plan.

## Alternatives Considered

- Keep both a library and public program surface: rejected because it expands
  the first release contract beyond the primary OCaml use case.
- Keep a private helper program only for manual testing: rejected because the
  library tests already cover the current provider behavior.
