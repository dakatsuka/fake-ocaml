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
          regions =
            [|
              "北海道";
              "青森県";
              "岩手県";
              "宮城県";
              "秋田県";
              "山形県";
              "福島県";
              "茨城県";
              "栃木県";
              "群馬県";
              "埼玉県";
              "千葉県";
              "東京都";
              "神奈川県";
              "新潟県";
              "富山県";
              "石川県";
              "福井県";
              "山梨県";
              "長野県";
              "岐阜県";
              "静岡県";
              "愛知県";
              "三重県";
              "滋賀県";
              "京都府";
              "大阪府";
              "兵庫県";
              "奈良県";
              "和歌山県";
              "鳥取県";
              "島根県";
              "岡山県";
              "広島県";
              "山口県";
              "徳島県";
              "香川県";
              "愛媛県";
              "高知県";
              "福岡県";
              "佐賀県";
              "長崎県";
              "熊本県";
              "大分県";
              "宮崎県";
              "鹿児島県";
              "沖縄県";
            |];
          cities =
            [|
              "朝日市";
              "風見市";
              "花丘市";
              "水上市";
              "星野市";
              "青葉区";
              "白川区";
              "緑野区";
              "桜町";
              "海原町";
              "光町";
              "月見町";
              "森村";
              "川辺村";
              "空峰村";
            |];
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
