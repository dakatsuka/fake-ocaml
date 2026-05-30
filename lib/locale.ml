type t = En | Ja_jp

let en = En
let ja_jp = Ja_jp
let all = [ en; ja_jp ]
let to_string = function En -> "en" | Ja_jp -> "ja_jp"

let of_string = function
  | "en" -> Ok En
  | "ja_jp" -> Ok Ja_jp
  | value -> Error ("unknown locale: " ^ value)
