#!/usr/bin/env bash
set -eu

locale_mli="$1"
shift

fail() {
  echo "static contract test failed: $1" >&2
  exit 1
}

grep -Eq '^type t[[:space:]]*$' "$locale_mli" ||
  fail "Locale.t must be abstract in locale.mli"

if grep -Eq '^type t[[:space:]]*=|[|][[:space:]]*En|[|][[:space:]]*Ja_jp' "$locale_mli"; then
  fail "locale.mli must not expose locale constructors"
fi

if grep -n -E 'Locale\.(En|Ja_jp)' "$@" >&2; then
  fail "provider modules must not reference locale constructors"
fi
