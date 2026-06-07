# Future Product Work

## Status

Draft

## Problem

fake-ocaml needs a clear place to record likely product directions without
silently widening the accepted initial API.

## Goals

- Keep accepted behavior in focused specs.
- Record deferred feature areas so future implementation can start with an
  explicit product decision.
- Separate release-packaging work from library API work.

## Non-Goals

- This document does not approve implementation of any listed feature.
- This document does not define stable public contracts.

## Candidate Work

- Additional provider domains: phone, company, payment, and similar broad
  Faker-style areas.
- Additional locales beyond `en` and `ja_jp`.
- Larger compiled locale datasets for existing providers.
- Address provider follow-up APIs such as country, region abbreviations,
  postal-code aliases, coordinates, and time zones.
- PPX derive support and any related package boundaries.
- Release packaging and publication, including final opam registry naming.

## Requirements For Promotion

Before implementation, each candidate that affects user-visible behavior should
move into its own product spec with:

- public API signatures;
- locale behavior and supported identifiers;
- examples;
- compatibility expectations;
- open questions resolved or explicitly scoped out.

## Open Questions

- Which provider domain should be the next post-Company expansion: phone,
  payment, or another Faker-style area?
- Should additional locales be prioritized before adding broad provider domains?
