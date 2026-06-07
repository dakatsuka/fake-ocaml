type name_pattern_spec = int * bool

type phrase_spec = {
  catch_phrase_uses_spaces : bool;
  buzz_phrase_words_lowercase : bool;
}

type locale_case = {
  locale : Fake.Locale.t;
  name_patterns : name_pattern_spec list;
  format_name : int -> string list -> string -> string;
  phrase : phrase_spec;
}

let check_locale_cases_match_supported_locales cases =
  let locales = List.map (fun case -> case.locale) cases in
  if locales <> Fake.Locale.all then
    Alcotest.fail
      "company test locale cases must match Fake.Locale.all in stable order"

let locale_cases =
  let cases =
    [
      {
        locale = List.nth Fake.Locale.all 0;
        name_patterns = [ (1, true); (2, false); (3, false) ];
        format_name =
          (fun pattern last_names suffix ->
            match (pattern, last_names) with
            | 0, [ last ] -> last ^ " " ^ suffix
            | 1, [ left; right ] -> left ^ "-" ^ right
            | 2, [ first; second; third ] ->
                first ^ ", " ^ second ^ " and " ^ third
            | _ -> Alcotest.failf "unexpected company name pattern %d" pattern);
        phrase =
          {
            catch_phrase_uses_spaces = true;
            buzz_phrase_words_lowercase = true;
          };
      };
      {
        locale = List.nth Fake.Locale.all 1;
        name_patterns = [ (1, false); (1, false); (2, false) ];
        format_name =
          (fun pattern last_names _suffix ->
            match (pattern, last_names) with
            | 0, [ last ] -> "株式会社" ^ last
            | 1, [ last ] -> last ^ "株式会社"
            | 2, [ left; right ] -> left ^ right ^ "グループ"
            | _ -> Alcotest.failf "unexpected company name pattern %d" pattern);
        phrase =
          {
            catch_phrase_uses_spaces = false;
            buzz_phrase_words_lowercase = false;
          };
      };
    ]
  in
  check_locale_cases_match_supported_locales cases;
  cases

let check_non_empty name value =
  Alcotest.(check bool) name true (String.length value > 0)

let expected_name ~seed ~locale_case =
  let generator = Fake.Generator.make ~seed in
  let pattern =
    Fake.Generator.int generator ~bound:(List.length locale_case.name_patterns)
  in
  let last_name_count, uses_suffix =
    List.nth locale_case.name_patterns pattern
  in
  let last_names =
    List.init last_name_count (fun _ ->
        Fake.Name.last_name ~generator ~locale:locale_case.locale)
  in
  let suffix =
    if uses_suffix then
      Fake.Company.suffix ~generator ~locale:locale_case.locale
    else ""
  in
  locale_case.format_name pattern last_names suffix

let find_seed_for_pattern ~locale_case ~target =
  let rec loop seed =
    if seed > 200 then Alcotest.failf "no seed found for pattern %d" target
    else
      let generator = Fake.Generator.make ~seed in
      let pattern =
        Fake.Generator.int generator
          ~bound:(List.length locale_case.name_patterns)
      in
      if pattern = target then seed else loop (seed + 1)
  in
  loop 0

let test_primitive_values_are_generated () =
  List.iter
    (fun case ->
      let generator = Fake.Generator.make ~seed:3 in
      let locale = case.locale in
      check_non_empty "suffix" (Fake.Company.suffix ~generator ~locale);
      check_non_empty "buzzword" (Fake.Company.buzzword ~generator ~locale);
      check_non_empty "name" (Fake.Company.name ~generator ~locale);
      check_non_empty "catch phrase"
        (Fake.Company.catch_phrase ~generator ~locale);
      check_non_empty "buzz phrase"
        (Fake.Company.buzz_phrase ~generator ~locale))
    locale_cases

let test_company_name_formatting_for_case locale_case =
  List.iteri
    (fun pattern _ ->
      let seed = find_seed_for_pattern ~locale_case ~target:pattern in
      let generator = Fake.Generator.make ~seed in
      let actual = Fake.Company.name ~generator ~locale:locale_case.locale in
      let expected = expected_name ~seed ~locale_case in
      Alcotest.(check string)
        (Printf.sprintf "%s company name pattern %d"
           (Fake.Locale.to_string locale_case.locale)
           pattern)
        expected actual)
    locale_case.name_patterns

let test_company_name_formatting () =
  List.iter test_company_name_formatting_for_case locale_cases

let test_phrases_are_repeatable_for_case locale_case =
  let seed = 19 in
  let locale = locale_case.locale in
  let left =
    Fake.Company.catch_phrase ~generator:(Fake.Generator.make ~seed) ~locale
  in
  let right =
    Fake.Company.catch_phrase ~generator:(Fake.Generator.make ~seed) ~locale
  in
  Alcotest.(check string)
    (Printf.sprintf "%s repeatable catch phrase" (Fake.Locale.to_string locale))
    left right;
  let left_buzz =
    Fake.Company.buzz_phrase ~generator:(Fake.Generator.make ~seed) ~locale
  in
  let right_buzz =
    Fake.Company.buzz_phrase ~generator:(Fake.Generator.make ~seed) ~locale
  in
  Alcotest.(check string)
    (Printf.sprintf "%s repeatable buzz phrase" (Fake.Locale.to_string locale))
    left_buzz right_buzz

let test_phrases_are_repeatable () =
  List.iter test_phrases_are_repeatable_for_case locale_cases

let is_lowercase_word word =
  String.for_all (function 'a' .. 'z' | '-' -> true | _ -> false) word

let test_phrase_formatting_for_case locale_case =
  let generator = Fake.Generator.make ~seed:23 in
  let locale = locale_case.locale in
  let catch_phrase = Fake.Company.catch_phrase ~generator ~locale in
  let buzz_phrase = Fake.Company.buzz_phrase ~generator ~locale in
  let locale_label = Fake.Locale.to_string locale in
  if locale_case.phrase.catch_phrase_uses_spaces then
    Alcotest.(check bool)
      (locale_label ^ " catch phrase uses spaces")
      true
      (String.contains catch_phrase ' ')
  else
    Alcotest.(check bool)
      (locale_label ^ " catch phrase has no spaces")
      true
      (not (String.contains catch_phrase ' '));
  if locale_case.phrase.buzz_phrase_words_lowercase then
    List.iter
      (fun word ->
        Alcotest.(check bool)
          (locale_label ^ " buzz phrase word " ^ word)
          true (is_lowercase_word word))
      (String.split_on_char ' ' buzz_phrase)
  else
    Alcotest.(check bool)
      (locale_label ^ " buzz phrase has no spaces")
      true
      (not (String.contains buzz_phrase ' '))

let test_phrase_formatting () =
  List.iter test_phrase_formatting_for_case locale_cases

let () =
  Alcotest.run "fake.company"
    [
      ( "company",
        [
          Alcotest.test_case "primitive values are generated" `Quick
            test_primitive_values_are_generated;
          Alcotest.test_case "company name formatting" `Quick
            test_company_name_formatting;
          Alcotest.test_case "phrases are repeatable" `Quick
            test_phrases_are_repeatable;
          Alcotest.test_case "phrase formatting" `Quick test_phrase_formatting;
        ] );
    ]
