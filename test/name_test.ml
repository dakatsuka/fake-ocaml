let test_locale_order () =
  let en = Fake.Generator.make ~seed:1 in
  let ja = Fake.Generator.make ~seed:1 in
  let en_name = Fake.Name.full_name ~generator:en ~locale:Fake.Locale.en in
  let ja_name = Fake.Name.full_name ~generator:ja ~locale:Fake.Locale.ja_jp in
  Alcotest.(check bool)
    "english name is not empty" true
    (String.length en_name > 0);
  Alcotest.(check bool)
    "japanese name is not empty" true
    (String.length ja_name > 0);
  Alcotest.(check bool)
    "locales differ" true
    (not (String.equal en_name ja_name))

let () =
  Alcotest.run "fake.name"
    [ ("name", [ Alcotest.test_case "locale order" `Quick test_locale_order ]) ]
