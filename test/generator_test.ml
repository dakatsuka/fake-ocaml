let collect count f = List.init count (fun _ -> f ())

let int_values generator =
  collect 10 (fun () -> Fake.Generator.int generator ~bound:100)

let test_reproducible () =
  let left = Fake.Generator.make ~seed:42 in
  let right = Fake.Generator.make ~seed:42 in
  let values = [| "alpha"; "beta"; "gamma"; "delta" |] in
  let left_values = collect 10 (fun () -> Fake.Generator.choose left values) in
  let right_values =
    collect 10 (fun () -> Fake.Generator.choose right values)
  in
  Alcotest.(check (list string)) "same seed sequence" left_values right_values

let test_state_advances () =
  let one_pass = Fake.Generator.make ~seed:99 in
  let split_pass = Fake.Generator.make ~seed:99 in
  let one_pass_values = int_values one_pass in
  let first_half =
    collect 5 (fun () -> Fake.Generator.int split_pass ~bound:100)
  in
  let second_half =
    collect 5 (fun () -> Fake.Generator.int split_pass ~bound:100)
  in
  Alcotest.(check (list int))
    "first five values"
    (List.filteri (fun index _ -> index < 5) one_pass_values)
    first_half;
  Alcotest.(check (list int))
    "next five values"
    (List.filteri (fun index _ -> index >= 5) one_pass_values)
    second_half

let test_invalid_int_bound () =
  let generator = Fake.Generator.make ~seed:1 in
  Alcotest.check_raises "non-positive bound"
    (Invalid_argument "Fake.Generator.int: bound must be positive") (fun () ->
      ignore (Fake.Generator.int generator ~bound:0))

let test_empty_choose () =
  let generator = Fake.Generator.make ~seed:1 in
  Alcotest.check_raises "empty array"
    (Invalid_argument "Fake.Generator.choose: empty array") (fun () ->
      ignore (Fake.Generator.choose generator [||]))

let () =
  Alcotest.run "fake.generator"
    [
      ( "generator",
        [
          Alcotest.test_case "reproducible" `Quick test_reproducible;
          Alcotest.test_case "state advances" `Quick test_state_advances;
          Alcotest.test_case "invalid int bound" `Quick test_invalid_int_bound;
          Alcotest.test_case "empty choose" `Quick test_empty_choose;
        ] );
    ]
