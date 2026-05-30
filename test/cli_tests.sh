#!/usr/bin/env bash
set -eu

bin="$1"

fail() {
  echo "cli test failed: $1" >&2
  exit 1
}

text_output="$("$bin" --locale en --seed 42 --provider name.full_name --count 2 --format text)"
line_count="$(printf "%s\n" "$text_output" | wc -l | tr -d ' ')"
[ "$line_count" = "2" ] || fail "expected 2 text lines, got $line_count"

first_run="$("$bin" --locale ja_jp --seed 42 --provider lorem.sentence --count 2 --format text)"
second_run="$("$bin" --locale ja_jp --seed 42 --provider lorem.sentence --count 2 --format text)"
[ "$first_run" = "$second_run" ] || fail "same seed produced different output"

json_output="$("$bin" --locale en --seed 42 --provider internet.email --count 1 --format jsonl)"
case "$json_output" in
  *'"locale":"en"'*'"provider":"internet.email"'*'"seed":42'*'"value":"'*) ;;
  *) fail "jsonl output did not include expected fields: $json_output" ;;
esac

if "$bin" --locale unknown --provider name.full_name >/tmp/fake_cli_out 2>/tmp/fake_cli_err; then
  fail "unknown locale unexpectedly succeeded"
fi
grep -q "unknown locale" /tmp/fake_cli_err || fail "unknown locale error was not reported"

if "$bin" --locale en >/tmp/fake_cli_out 2>/tmp/fake_cli_err; then
  fail "missing provider unexpectedly succeeded"
fi
grep -q -- "missing --provider" /tmp/fake_cli_err || fail "missing provider error was not reported"

if "$bin" --locale en --provider unknown.provider >/tmp/fake_cli_out 2>/tmp/fake_cli_err; then
  fail "unknown provider unexpectedly succeeded"
fi
grep -q "unknown provider" /tmp/fake_cli_err || fail "unknown provider error was not reported"

if "$bin" --locale en --provider name.full_name --format xml >/tmp/fake_cli_out 2>/tmp/fake_cli_err; then
  fail "unknown format unexpectedly succeeded"
fi
grep -q "unknown format" /tmp/fake_cli_err || fail "unknown format error was not reported"

if "$bin" --locale en --provider name.full_name --count 0 >/tmp/fake_cli_out 2>/tmp/fake_cli_err; then
  fail "invalid count unexpectedly succeeded"
fi
grep -q "count must be positive" /tmp/fake_cli_err || fail "invalid count error was not reported"

if "$bin" --locale en --provider name.full_name extra >/tmp/fake_cli_out 2>/tmp/fake_cli_err; then
  fail "unexpected positional argument unexpectedly succeeded"
fi
grep -q "unexpected argument: extra" /tmp/fake_cli_err ||
  fail "unexpected positional argument error was not reported"
