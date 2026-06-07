let format_full_name ~first ~last = first ^ " " ^ last

let format_sentence = function
  | [] -> "."
  | first :: rest ->
      String.concat " " (String.capitalize_ascii first :: rest) ^ "."

let format_paragraph sentences = String.concat " " sentences

let format_street_address ~building_number ~street_name =
  building_number ^ " " ^ street_name

let format_full_address ~postal_code ~region ~city ~street_address =
  street_address ^ ", " ^ city ^ ", " ^ region ^ " " ^ postal_code

let format_company_name ~pattern ~last_names ~suffix =
  match (pattern, last_names) with
  | 0, [ last ] -> last ^ " " ^ suffix
  | 1, [ left; right ] -> left ^ "-" ^ right
  | 2, [ first; second; third ] -> first ^ ", " ^ second ^ " and " ^ third
  | _ -> invalid_arg "format_company_name"

let format_catch_phrase = function
  | [] -> ""
  | first :: rest -> String.concat " " (String.capitalize_ascii first :: rest)

let format_buzz_phrase words =
  words |> List.map String.lowercase_ascii |> String.concat " "

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
      address =
        {
          regions =
            [| "Northland"; "Eastford"; "Westhaven"; "Southridge"; "Lakevale" |];
          cities =
            [|
              "Clearwater"; "Brookfield"; "Hillview"; "Mapleton"; "Stoneport";
            |];
          communities =
            [|
              "Old Quarter";
              "River District";
              "Pine Ward";
              "Market Row";
              "Garden End";
            |];
          street_names =
            [|
              "Oak Street";
              "Cedar Avenue";
              "Harbor Road";
              "Maple Lane";
              "Sunset Boulevard";
            |];
          building_numbers = [| "12"; "48"; "103"; "221B"; "704" |];
          secondary_addresses =
            [| "Apt. 2A"; "Suite 400"; "Unit 7"; "Room 12"; "Floor 3" |];
          postal_codes = [| "10482"; "23817"; "40596"; "67240"; "81935" |];
          format_street_address;
          format_full_address;
        };
      company =
        {
          suffixes = [| "Inc"; "LLC"; "Group"; "PLC"; "Ltd" |];
          buzzwords =
            [|
              "Adaptive"; "Balanced"; "Business-focused"; "Innovative"; "Robust";
            |];
          catch_phrase_words =
            [|
              [| "Adaptive"; "Balanced"; "Innovative"; "Robust" |];
              [| "coherent"; "modular"; "scalable"; "integrated" |];
              [| "parallelism"; "infrastructure"; "platform"; "framework" |];
            |];
          buzz_phrase_words =
            [|
              [| "empower"; "integrate"; "synthesize"; "leverage" |];
              [| "wireless"; "end-to-end"; "back-end"; "cross-platform" |];
              [| "mindshare"; "paradigms"; "synergies"; "interfaces" |];
            |];
          name_patterns =
            [|
              { last_name_count = 1; uses_suffix = true };
              { last_name_count = 2; uses_suffix = false };
              { last_name_count = 3; uses_suffix = false };
            |];
          format_company_name;
          format_catch_phrase;
          format_buzz_phrase;
        };
    }
