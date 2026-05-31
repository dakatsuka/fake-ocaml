let region ~generator ~locale =
  let data = Locale_data.(get locale).address in
  Generator.choose generator data.regions

let city ~generator ~locale =
  let data = Locale_data.(get locale).address in
  Generator.choose generator data.cities

let community ~generator ~locale =
  let data = Locale_data.(get locale).address in
  Generator.choose generator data.communities

let street_name ~generator ~locale =
  let data = Locale_data.(get locale).address in
  Generator.choose generator data.street_names

let building_number ~generator ~locale =
  let data = Locale_data.(get locale).address in
  Generator.choose generator data.building_numbers

let secondary_address ~generator ~locale =
  let data = Locale_data.(get locale).address in
  Generator.choose generator data.secondary_addresses

let postal_code ~generator ~locale =
  let data = Locale_data.(get locale).address in
  Generator.choose generator data.postal_codes

let street_address ~generator ~locale =
  let data = Locale_data.(get locale).address in
  let building_number = building_number ~generator ~locale in
  let street_name = street_name ~generator ~locale in
  data.format_street_address ~building_number ~street_name

let full_address ~generator ~locale =
  let data = Locale_data.(get locale).address in
  let postal_code = postal_code ~generator ~locale in
  let region = region ~generator ~locale in
  let city = city ~generator ~locale in
  let street_address = street_address ~generator ~locale in
  data.format_full_address ~postal_code ~region ~city ~street_address
