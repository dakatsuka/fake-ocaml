let parse_to_string value =
  Result.map Fake.Locale.to_string (Fake.Locale.of_string value)

let test_public_values () =
  Alcotest.(check string)
    "en identifier" "en"
    (Fake.Locale.to_string Fake.Locale.en);
  Alcotest.(check string)
    "ja_jp identifier" "ja_jp"
    (Fake.Locale.to_string Fake.Locale.ja_jp);
  Alcotest.(check (list string))
    "stable all ordering" [ "en"; "ja_jp" ]
    (List.map Fake.Locale.to_string Fake.Locale.all)

let test_parse () =
  Alcotest.(check (result string string))
    "en parses" (Ok "en") (parse_to_string "en");
  Alcotest.(check (result string string))
    "ja_jp parses" (Ok "ja_jp") (parse_to_string "ja_jp");
  Alcotest.(check (result string string))
    "unknown locale fails" (Error "unknown locale: fr") (parse_to_string "fr")

let () =
  Alcotest.run "fake.locale"
    [
      ( "locale",
        [
          Alcotest.test_case "public values" `Quick test_public_values;
          Alcotest.test_case "parse" `Quick test_parse;
        ] );
    ]
