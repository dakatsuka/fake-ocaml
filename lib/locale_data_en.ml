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
    }
