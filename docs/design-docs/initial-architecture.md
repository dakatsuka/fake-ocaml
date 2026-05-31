# Initial Architecture

## Status

Accepted

## Context

fake-ocaml starts as a small OCaml 5.x library for generating locale-aware fake
data. The project favors explicit state, compiled locale data, and narrow public
APIs.

## Goals

- Establish a minimal Dune/opam project structure.
- Keep runtime dependencies out of the first implementation.
- Make locale data type-checked OCaml code.
- Keep random generation reproducible for tests through explicit generator
  values.
- Provide enough provider surface to validate library and locale design.

## Non-Goals

- PPX derive support.
- Large locale datasets.
- Runtime loading of external locale files.

## Proposed Design

The project contains one public library, `fake`.

The library is organized around small modules:

- `Generator` wraps `Random.State.t` and stores the original seed.
- `Locale` defines opaque supported locale identifiers and string conversion.
- `Locale_data` stores typed OCaml data for each locale behind a shared module
  signature.
- `Name`, `Internet`, and `Lorem` expose provider functions that consume
  explicit `generator` and `locale` arguments.

Provider functions advance the supplied generator. Creating a new generator with
the same seed recreates the same sequence for the current implementation.

Public callers do not pattern match on `Locale.t`; they use `Locale.en`,
`Locale.ja_jp`, `Locale.all`, `Locale.to_string`, and `Locale.of_string`.
Internally, locale dispatch stays behind `Locale_data` and locale helper
functions so adding a locale does not require provider modules to expose or
rely on public constructors.

Locale-specific formatting belongs in compiled locale data when the rule varies
by locale. The first such rules are:

- `Name.full_name`: given-name/family-name order and separator.
- `Lorem.sentence`: word joining, capitalization, and terminal punctuation.
- `Lorem.paragraph`: sentence joining.

The minimal internal locale data shape for this pass is:

```ocaml
type name = {
  first_names : string array;
  last_names : string array;
  format_full_name : first:string -> last:string -> string;
}

type internet = {
  usernames : string array;
  domains : string array;
}

type lorem = {
  words : string array;
  format_sentence : string list -> string;
  format_paragraph : string list -> string;
}
```

Provider modules remain responsible for provider-generic composition. For
example, `Internet.email` combines a username and domain because the initial
product contract does not define locale-specific email formatting.

`Generator.t` is intentionally narrow. It is mutable and suitable for
single-owner sequential use. The first API does not expose copy, split, jump, or
thread/domain-safe sharing operations. Callers that need independent streams
create separate generators with explicit seeds. Sharing one generator
concurrently across OCaml domains or system threads is outside the public
contract.

## Contracts

Public contracts are defined in `.mli` files before implementation. Public
functions include block comments that describe arguments, return values, and
important failure modes.

Locale data uses arrays for compact constant data and direct indexed selection,
plus small formatting functions or templates for locale-specific composition.
Empty provider arrays are invalid shipped data and cause `Generator.choose` to
raise `Invalid_argument` if encountered.

The hardened public contracts are:

- `Locale.t` is abstract in `locale.mli`.
- `Locale.all` returns `[Locale.en; Locale.ja_jp]` for the initial release.
- `Locale.of_string` accepts exactly `en` and `ja_jp` and returns a concise
  error for any other value.
- `Generator.int` raises `Invalid_argument` for non-positive bounds.
- `Generator.choose` raises `Invalid_argument` for empty arrays.
- Provider modules do not pattern match on public locale constructors.

## Alternatives Considered

- Global default generator: rejected for the first version because it makes
  tests and concurrent usage harder to reason about.
- YAML/TOML locale files: rejected because the initial requirement prefers pure
  OCaml locale definitions and minimal dependencies.
- Initial PPX package: deferred to avoid widening the first API before the core
  provider model is proven.
- Public locale variants: rejected before release because adding locales would
  change a public variant type and encourage caller-side locale branching.
- Generator copy/split operations: deferred because they require stronger
  sequence-stability and independence guarantees than the first API needs.
- Public program surface: rejected for the initial package because the primary
  product surface is the OCaml library and provider behavior can be validated
  directly through library tests.

## Third-Party Review

A context-free sub-agent reviewed the design direction before implementation.
The review requested fixed provider scope, explicit test dependency policy,
concrete API signatures, and CI commands. Those points are incorporated in this
design.

## Validation

- Alcotest unit tests cover generator reproducibility, locale parsing, and
  provider behavior.
- CI runs build, test, format, static, install, and opam lint checks on OCaml
  5.0.x and 5.4.x.

## Future Work

- Opam publication and registry naming are release-packaging work outside this
  initial architecture.
- PPX derive API shape requires a later product spec and design document.
- Broad provider domains and additional locales require later product specs and,
  where module boundaries change, design updates.
