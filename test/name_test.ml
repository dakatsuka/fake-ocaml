let expected_full_name ~seed ~locale ~format =
  let generator = Fake.Generator.make ~seed in
  let first = Fake.Name.first_name ~generator ~locale in
  let last = Fake.Name.last_name ~generator ~locale in
  format ~first ~last

let test_values_are_generated () =
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

let test_full_name_formatting () =
  let seed = 7 in
  let en_generator = Fake.Generator.make ~seed in
  let ja_generator = Fake.Generator.make ~seed in
  let en_name =
    Fake.Name.full_name ~generator:en_generator ~locale:Fake.Locale.en
  in
  let ja_name =
    Fake.Name.full_name ~generator:ja_generator ~locale:Fake.Locale.ja_jp
  in
  Alcotest.(check string)
    "english full name"
    (expected_full_name ~seed ~locale:Fake.Locale.en
       ~format:(fun ~first ~last -> first ^ " " ^ last))
    en_name;
  Alcotest.(check string)
    "japanese full name"
    (expected_full_name ~seed ~locale:Fake.Locale.ja_jp
       ~format:(fun ~first ~last -> last ^ " " ^ first))
    ja_name

let () =
  Alcotest.run "fake.name"
    [
      ( "name",
        [
          Alcotest.test_case "values are generated" `Quick
            test_values_are_generated;
          Alcotest.test_case "full name formatting" `Quick
            test_full_name_formatting;
        ] );
    ]
