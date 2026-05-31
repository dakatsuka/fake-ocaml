# Faker Ruby Address Provider

## Source

- URL: https://github.com/faker-ruby/faker/blob/main/doc/default/address.md
- Accessed: 2026-05-31

## Summary

Faker Ruby's default Address provider documents primitive address values such as
city, street name, street address, secondary address, building number, mail box,
community, postal-code variants, street and city affixes, state, state
abbreviation, country, country-code helpers, latitude, longitude, time zone, and
full address.

## Implications

fake-ocaml should not copy the full API. The first Address provider should adopt
only APIs that fit the existing locale-aware fixture model and do not require
geospatial semantics, country-code lookup rules, or broad compatibility with
real postal systems.

The adopted API additions are:

- `community`
- `secondary_address`

Deferred areas are:

- mail boxes;
- country and country-code lookup;
- latitude and longitude;
- time zones;
- state or region abbreviations;
- postal-code aliases such as `zip` and `postcode`;
- street and city affix internals;
- generated postal-code templates.
