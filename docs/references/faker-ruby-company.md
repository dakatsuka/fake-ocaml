# Faker Ruby Company Provider

## Source

- URL: https://github.com/faker-ruby/faker/blob/main/doc/default/company.md
- Implementation: https://github.com/faker-ruby/faker/blob/main/lib/faker/default/company.rb
- Locale data: https://github.com/faker-ruby/faker/blob/main/lib/locales/en/company.yml
- Accessed: 2026-06-07

## Summary

Faker Ruby's default Company provider documents:

- `name`: parsed from locale templates such as company-name patterns
- `suffix`: legal-entity or organizational suffix strings
- `industry`: industry label chosen from a compiled list
- `catch_phrase`: three buzzword groups joined with spaces
- `buzzword`: one random entry from the flattened buzzword groups
- `bs`: three business-jargon groups joined with spaces

The provider also documents many country-specific registration identifiers,
`logo`, `department`, `profession`, `type`, and `duns_number`. Those APIs mix
fixture selection with country-specific formatting rules or external URLs.

English `catch_phrase` and `bs` both use multi-list composition. `name` is
template-driven and commonly reuses person-name parts plus `suffix` values.

## Implications

fake-ocaml should not copy the full Ruby API. The first Company provider should
adopt only APIs that fit the existing locale-aware fixture model:

- `suffix`
- `buzzword`
- `name`
- `catch_phrase`
- `buzz_phrase` as the canonical name for Ruby's `bs`

Deferred areas are:

- `industry`, `department`, `profession`, and `type` because they overlap with
  future Job or metadata providers;
- `logo` because it depends on external URLs;
- country-specific registration numbers and tax identifiers because they require
  separate locale-specific formatting contracts;
- fine-grained buzzword part selectors such as `buzzVerb` unless a later spec
  needs composable fixture builders.

Locale-owned company-name patterns and phrase formatting should live in
compiled locale data so `en` and `ja_jp` can diverge without provider-side
branching.

- Ruby `Company.buzzword` flattens all `buzzwords` groups; fake-ocaml keeps a
  separate flat `buzzwords` array in compiled locale data.
- Ruby `ja` company `name` uses a `category` kanji segment; fake-ocaml's first
  `ja_jp` provider omits `category` and uses three fixed patterns documented in
  the Company product spec.
