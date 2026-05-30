let test_sentence () =
  let generator = Fake.Generator.make ~seed:9 in
  let sentence = Fake.Lorem.sentence ~generator ~locale:Fake.Locale.en in
  Alcotest.(check bool)
    "sentence has final period" true
    (String.ends_with ~suffix:"." sentence)

let () =
  Alcotest.run "fake.lorem"
    [ ("lorem", [ Alcotest.test_case "sentence" `Quick test_sentence ]) ]
