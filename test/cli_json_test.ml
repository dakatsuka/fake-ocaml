let test_escape_string () =
  Alcotest.(check string)
    "json escapes strings"
    "\\\"quote\\\" \\\\backslash\\\\ \\b\\f\\n\\r\\t \\u0001"
    (Fake_cli_json.escape_string "\"quote\" \\backslash\\ \b\012\n\r\t \001")

let () =
  Alcotest.run "fake.cli_json"
    [
      ( "cli_json",
        [ Alcotest.test_case "escape string" `Quick test_escape_string ] );
    ]
