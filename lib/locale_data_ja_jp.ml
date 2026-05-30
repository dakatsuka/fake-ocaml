let format_full_name ~first ~last = last ^ " " ^ first
let format_sentence words = String.concat "" words ^ "。"

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
        };
    }
