type output_format = Text | Jsonl

let usage =
  "fake --provider <provider-id> [--locale en|ja_jp] [--seed <int>] [--count \
   <positive-int>] [--format text|jsonl]"

let fail message =
  prerr_endline message;
  exit 2

let parse_format = function
  | "text" -> Text
  | "jsonl" -> Jsonl
  | value -> fail ("unknown format: " ^ value)

let generate provider ~generator ~locale =
  match provider with
  | "name.first_name" -> Fake.Name.first_name ~generator ~locale
  | "name.last_name" -> Fake.Name.last_name ~generator ~locale
  | "name.full_name" -> Fake.Name.full_name ~generator ~locale
  | "internet.username" -> Fake.Internet.username ~generator ~locale
  | "internet.domain" -> Fake.Internet.domain ~generator ~locale
  | "internet.email" -> Fake.Internet.email ~generator ~locale
  | "lorem.word" -> Fake.Lorem.word ~generator ~locale
  | "lorem.sentence" -> Fake.Lorem.sentence ~generator ~locale
  | value -> fail ("unknown provider: " ^ value)

let json_escape value =
  let buffer = Buffer.create (String.length value) in
  String.iter
    (function
      | '"' -> Buffer.add_string buffer "\\\""
      | '\\' -> Buffer.add_string buffer "\\\\"
      | '\b' -> Buffer.add_string buffer "\\b"
      | '\012' -> Buffer.add_string buffer "\\f"
      | '\n' -> Buffer.add_string buffer "\\n"
      | '\r' -> Buffer.add_string buffer "\\r"
      | '\t' -> Buffer.add_string buffer "\\t"
      | c when Char.code c < 0x20 ->
          Buffer.add_string buffer (Printf.sprintf "\\u%04x" (Char.code c))
      | c -> Buffer.add_char buffer c)
    value;
  Buffer.contents buffer

let print_value ~format ~locale ~provider ~seed value =
  match format with
  | Text -> print_endline value
  | Jsonl ->
      Printf.printf
        "{\"locale\":\"%s\",\"provider\":\"%s\",\"seed\":%d,\"value\":\"%s\"}\n"
        (Fake.Locale.to_string locale)
        (json_escape provider) seed (json_escape value)

let () =
  let locale_arg = ref "en" in
  let seed = ref 0 in
  let provider = ref None in
  let count = ref 1 in
  let format_arg = ref "text" in
  let specs =
    [
      ("--locale", Arg.Set_string locale_arg, "Locale identifier: en or ja_jp");
      ("--seed", Arg.Set_int seed, "Integer seed");
      ( "--provider",
        Arg.String (fun value -> provider := Some value),
        "Provider id" );
      ("--count", Arg.Set_int count, "Number of values to generate");
      ("--format", Arg.Set_string format_arg, "Output format: text or jsonl");
    ]
  in
  Arg.parse specs (fun value -> fail ("unexpected argument: " ^ value)) usage;
  let provider =
    match !provider with
    | Some provider -> provider
    | None -> fail "missing --provider"
  in
  let locale =
    match Fake.Locale.of_string !locale_arg with
    | Ok locale -> locale
    | Error message -> fail message
  in
  if !count <= 0 then fail "--count must be positive";
  let format = parse_format !format_arg in
  let generator = Fake.Generator.make ~seed:!seed in
  for _ = 1 to !count do
    generate provider ~generator ~locale
    |> print_value ~format ~locale ~provider ~seed:!seed
  done
