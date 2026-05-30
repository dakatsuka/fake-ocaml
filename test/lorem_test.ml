let expected_sentence ~seed ~locale ~format =
  let generator = Fake.Generator.make ~seed in
  let length = 4 + Fake.Generator.int generator ~bound:5 in
  let words = List.init length (fun _ -> Fake.Lorem.word ~generator ~locale) in
  format words

let format_english_sentence = function
  | [] -> "."
  | first :: rest ->
      String.capitalize_ascii first ^ " " ^ String.concat " " rest ^ "."

let format_japanese_sentence words = String.concat "" words ^ "。"

let test_sentence_has_punctuation () =
  let generator = Fake.Generator.make ~seed:9 in
  let sentence = Fake.Lorem.sentence ~generator ~locale:Fake.Locale.en in
  Alcotest.(check bool)
    "sentence has final period" true
    (String.ends_with ~suffix:"." sentence)

let test_sentence_formatting () =
  let seed = 13 in
  let en_generator = Fake.Generator.make ~seed in
  let ja_generator = Fake.Generator.make ~seed in
  let en_sentence =
    Fake.Lorem.sentence ~generator:en_generator ~locale:Fake.Locale.en
  in
  let ja_sentence =
    Fake.Lorem.sentence ~generator:ja_generator ~locale:Fake.Locale.ja_jp
  in
  Alcotest.(check string)
    "english sentence"
    (expected_sentence ~seed ~locale:Fake.Locale.en
       ~format:format_english_sentence)
    en_sentence;
  Alcotest.(check string)
    "japanese sentence"
    (expected_sentence ~seed ~locale:Fake.Locale.ja_jp
       ~format:format_japanese_sentence)
    ja_sentence

let () =
  Alcotest.run "fake.lorem"
    [
      ( "lorem",
        [
          Alcotest.test_case "sentence punctuation" `Quick
            test_sentence_has_punctuation;
          Alcotest.test_case "sentence formatting" `Quick
            test_sentence_formatting;
        ] );
    ]
