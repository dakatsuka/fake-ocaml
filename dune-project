(lang dune 3.11)

(name fake)

(source
 (github dakatsuka/fake-ocaml))

(authors "Dai Akatsuka")

(license MIT)

(package
 (name fake)
 (synopsis "Fake data generation for OCaml")
 (description
  "An OCaml library for generating fake data in multiple locales.")
 (depends
  (ocaml
   (>= "5.0"))
  (dune
   (>= "3.11"))
  (alcotest
   :with-test)))
