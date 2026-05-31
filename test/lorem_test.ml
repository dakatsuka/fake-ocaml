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

let expected_paragraph ~seed ~locale ~format =
  let generator = Fake.Generator.make ~seed in
  let length = 3 + Fake.Generator.int generator ~bound:3 in
  let sentences =
    List.init length (fun _ -> Fake.Lorem.sentence ~generator ~locale)
  in
  format sentences

let format_english_paragraph sentences = String.concat " " sentences
let format_japanese_paragraph sentences = String.concat "" sentences

let count_char needle value =
  String.fold_left
    (fun count character ->
      if Char.equal character needle then count + 1 else count)
    0 value

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

let test_paragraph_formatting () =
  let seed = 23 in
  let en_generator = Fake.Generator.make ~seed in
  let ja_generator = Fake.Generator.make ~seed in
  let en_paragraph =
    Fake.Lorem.paragraph ~generator:en_generator ~locale:Fake.Locale.en
  in
  let ja_paragraph =
    Fake.Lorem.paragraph ~generator:ja_generator ~locale:Fake.Locale.ja_jp
  in
  Alcotest.(check string)
    "english paragraph"
    (expected_paragraph ~seed ~locale:Fake.Locale.en
       ~format:format_english_paragraph)
    en_paragraph;
  Alcotest.(check string)
    "japanese paragraph"
    (expected_paragraph ~seed ~locale:Fake.Locale.ja_jp
       ~format:format_japanese_paragraph)
    ja_paragraph

let test_paragraph_sentence_count_range () =
  List.iter
    (fun seed ->
      let generator = Fake.Generator.make ~seed in
      let paragraph = Fake.Lorem.paragraph ~generator ~locale:Fake.Locale.en in
      let sentence_count = count_char '.' paragraph in
      Alcotest.(check bool)
        "paragraph has three to five sentences" true
        (sentence_count >= 3 && sentence_count <= 5))
    (List.init 20 (fun index -> index + 1))

let () =
  Alcotest.run "fake.lorem"
    [
      ( "lorem",
        [
          Alcotest.test_case "sentence punctuation" `Quick
            test_sentence_has_punctuation;
          Alcotest.test_case "sentence formatting" `Quick
            test_sentence_formatting;
          Alcotest.test_case "paragraph formatting" `Quick
            test_paragraph_formatting;
          Alcotest.test_case "paragraph sentence count range" `Quick
            test_paragraph_sentence_count_range;
        ] );
    ]
