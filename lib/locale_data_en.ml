let format_full_name ~first ~last = first ^ " " ^ last

let format_sentence = function
  | [] -> "."
  | first :: rest ->
      String.concat " " (String.capitalize_ascii first :: rest) ^ "."

let format_paragraph sentences = String.concat " " sentences

let data =
  Locale_data_types.
    {
      name =
        {
          first_names =
            [| "Alice"; "Amelia"; "Avery"; "Benjamin"; "Charlotte"; "Daniel" |];
          last_names =
            [| "Baker"; "Carter"; "Johnson"; "Morgan"; "Parker"; "Taylor" |];
          format_full_name;
        };
      internet =
        {
          usernames =
            [| "alice"; "avery"; "benjamin"; "charlotte"; "daniel"; "morgan" |];
          domains =
            [| "example.com"; "example.net"; "mail.test"; "sample.org" |];
        };
      lorem =
        {
          words =
            [|
              "lorem";
              "ipsum";
              "dolor";
              "sit";
              "amet";
              "consectetur";
              "adipiscing";
              "elit";
            |];
          format_sentence;
          format_paragraph;
        };
    }
