let format_full_name ~first ~last = last ^ " " ^ first
let format_sentence words = String.concat "" words ^ "。"
let format_paragraph sentences = String.concat "" sentences

let format_street_address ~building_number ~street_name =
  street_name ^ building_number

let format_full_address ~postal_code ~region ~city ~street_address =
  "〒" ^ postal_code ^ " " ^ region ^ city ^ street_address

let data =
  Locale_data_types.
    {
      name =
        {
          first_names = [| "太郎"; "花子"; "葵"; "蓮"; "陽菜"; "湊" |];
          last_names = [| "佐藤"; "鈴木"; "高橋"; "田中"; "伊藤"; "渡辺" |];
          format_full_name;
        };
      internet =
        {
          usernames = [| "taro"; "hanako"; "aoi"; "ren"; "hina"; "minato" |];
          domains =
            [| "example.jp"; "mail.example.jp"; "sample.test"; "demo.jp" |];
        };
      lorem =
        {
          words = [| "これは"; "ダミー"; "文章"; "です"; "日本語"; "データ"; "生成"; "します" |];
          format_sentence;
          format_paragraph;
        };
      address =
        {
          regions = [| "青葉県"; "白河県"; "緑川県"; "桜野県"; "海原県" |];
          cities = [| "朝日市"; "風見市"; "花丘市"; "水上市"; "星野市" |];
          communities = [| "中央"; "南町"; "北原"; "東野"; "西浜" |];
          street_names = [| "青葉"; "桜通り"; "緑町"; "海岸"; "星見台" |];
          building_numbers = [| "1-2-3"; "4-5"; "6番地"; "7-8-9"; "10号" |];
          secondary_addresses = [| "101号室"; "A棟"; "2階"; "305号室"; "別館" |];
          postal_codes =
            [| "123-4567"; "234-5678"; "345-6789"; "456-7890"; "567-8901" |];
          format_street_address;
          format_full_address;
        };
    }
