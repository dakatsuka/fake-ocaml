let collect count f = List.init count (fun _ -> f ())

let test_reproducible () =
  let left = Fake.Generator.make ~seed:42 in
  let right = Fake.Generator.make ~seed:42 in
  let values = [| "alpha"; "beta"; "gamma"; "delta" |] in
  let left_values = collect 10 (fun () -> Fake.Generator.choose left values) in
  let right_values =
    collect 10 (fun () -> Fake.Generator.choose right values)
  in
  Alcotest.(check (list string)) "same seed sequence" left_values right_values

let () =
  Alcotest.run "fake.generator"
    [
      ( "generator",
        [ Alcotest.test_case "reproducible" `Quick test_reproducible ] );
    ]
