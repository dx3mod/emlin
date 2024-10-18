(lang dune 3.7)

(generate_opam_files true)

(source
 (github dx3mod/emlin))

(authors "Mikhail Lopatin <dx3mod@bk.ru>")

(maintainers "Mikhail Lopatin <dx3mod@bk.ru>")

(license MIT)

(package
 (name emlin)
 (depends ocaml dune))

(package
 (name emlin-extra-ssd1306)
 (depends ocaml dune emlin))
