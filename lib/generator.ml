type t = { seed : int; state : Random.State.t }

let make ~seed = { seed; state = Random.State.make [| seed |] }
let seed generator = generator.seed

let int generator ~bound =
  if bound <= 0 then invalid_arg "Fake.Generator.int: bound must be positive";
  Random.State.int generator.state bound

let choose generator values =
  let length = Array.length values in
  if length = 0 then invalid_arg "Fake.Generator.choose: empty array";
  values.(int generator ~bound:length)
