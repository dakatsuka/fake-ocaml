let check_non_empty name value =
  Alcotest.(check bool) name true (String.length value > 0)

let test_primitive_values_are_generated () =
  List.iter
    (fun locale ->
      let generator = Fake.Generator.make ~seed:3 in
      check_non_empty "region" (Fake.Address.region ~generator ~locale);
      check_non_empty "city" (Fake.Address.city ~generator ~locale);
      check_non_empty "community" (Fake.Address.community ~generator ~locale);
      check_non_empty "street name"
        (Fake.Address.street_name ~generator ~locale);
      check_non_empty "building number"
        (Fake.Address.building_number ~generator ~locale);
      check_non_empty "secondary address"
        (Fake.Address.secondary_address ~generator ~locale);
      check_non_empty "postal code"
        (Fake.Address.postal_code ~generator ~locale))
    Fake.Locale.all

let expected_street_address ~seed ~locale ~format =
  let generator = Fake.Generator.make ~seed in
  let building_number = Fake.Address.building_number ~generator ~locale in
  let street_name = Fake.Address.street_name ~generator ~locale in
  format ~building_number ~street_name

let expected_full_address ~seed ~locale ~format_street ~format_full =
  let generator = Fake.Generator.make ~seed in
  let postal_code = Fake.Address.postal_code ~generator ~locale in
  let region = Fake.Address.region ~generator ~locale in
  let city = Fake.Address.city ~generator ~locale in
  let street_address =
    let building_number = Fake.Address.building_number ~generator ~locale in
    let street_name = Fake.Address.street_name ~generator ~locale in
    format_street ~building_number ~street_name
  in
  format_full ~postal_code ~region ~city ~street_address

let format_english_street_address ~building_number ~street_name =
  building_number ^ " " ^ street_name

let format_japanese_street_address ~building_number ~street_name =
  street_name ^ building_number

let format_english_full_address ~postal_code ~region ~city ~street_address =
  street_address ^ ", " ^ city ^ ", " ^ region ^ " " ^ postal_code

let format_japanese_full_address ~postal_code ~region ~city ~street_address =
  "〒" ^ postal_code ^ " " ^ region ^ city ^ street_address

let test_street_address_formatting () =
  let seed = 11 in
  let en_generator = Fake.Generator.make ~seed in
  let ja_generator = Fake.Generator.make ~seed in
  let en_address =
    Fake.Address.street_address ~generator:en_generator ~locale:Fake.Locale.en
  in
  let ja_address =
    Fake.Address.street_address ~generator:ja_generator
      ~locale:Fake.Locale.ja_jp
  in
  Alcotest.(check string)
    "english street address"
    (expected_street_address ~seed ~locale:Fake.Locale.en
       ~format:format_english_street_address)
    en_address;
  Alcotest.(check string)
    "japanese street address"
    (expected_street_address ~seed ~locale:Fake.Locale.ja_jp
       ~format:format_japanese_street_address)
    ja_address

let test_full_address_formatting () =
  let seed = 17 in
  let en_generator = Fake.Generator.make ~seed in
  let ja_generator = Fake.Generator.make ~seed in
  let en_address =
    Fake.Address.full_address ~generator:en_generator ~locale:Fake.Locale.en
  in
  let ja_address =
    Fake.Address.full_address ~generator:ja_generator ~locale:Fake.Locale.ja_jp
  in
  Alcotest.(check string)
    "english full address"
    (expected_full_address ~seed ~locale:Fake.Locale.en
       ~format_street:format_english_street_address
       ~format_full:format_english_full_address)
    en_address;
  Alcotest.(check string)
    "japanese full address"
    (expected_full_address ~seed ~locale:Fake.Locale.ja_jp
       ~format_street:format_japanese_street_address
       ~format_full:format_japanese_full_address)
    ja_address

let () =
  Alcotest.run "fake.address"
    [
      ( "address",
        [
          Alcotest.test_case "primitive values are generated" `Quick
            test_primitive_values_are_generated;
          Alcotest.test_case "street address formatting" `Quick
            test_street_address_formatting;
          Alcotest.test_case "full address formatting" `Quick
            test_full_address_formatting;
        ] );
    ]
