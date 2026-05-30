let test_parse () =
  Alcotest.(check (result pass string))
    "en parses" (Ok Fake.Locale.en)
    (Fake.Locale.of_string "en");
  Alcotest.(check (result pass string))
    "ja_jp parses" (Ok Fake.Locale.ja_jp)
    (Fake.Locale.of_string "ja_jp");
  Alcotest.(check bool)
    "unknown locale fails" true
    (Result.is_error (Fake.Locale.of_string "fr"))

let () =
  Alcotest.run "fake.locale"
    [ ("locale", [ Alcotest.test_case "parse" `Quick test_parse ]) ]
