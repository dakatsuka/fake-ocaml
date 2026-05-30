let test_email () =
  let generator = Fake.Generator.make ~seed:7 in
  let email = Fake.Internet.email ~generator ~locale:Fake.Locale.en in
  Alcotest.(check bool) "email contains @" true (String.contains email '@')

let () =
  Alcotest.run "fake.internet"
    [ ("internet", [ Alcotest.test_case "email" `Quick test_email ]) ]
