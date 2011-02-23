OCAMLC = ocamlc -g

all: test

test: test.byte
	ocamlrun -b test.byte && bash test_run.bash

test.byte: ospecl.cma test_matcher.cmo test_specify.cmo test_matchers.cmo
	$(OCAMLC) -o test.byte ospecl.cma test_matcher.cmo test_matchers.cmo test_specify.cmo

ospecl.cma: matcher.cmo matchers.cmo specify.cmo run.cmo
	$(OCAMLC) -pack -o ospecl.cma matcher.cmo matchers.cmo specify.cmo run.cmo

clean:
	rm *.cm* test.byte

.PHONY: all clean test

.SUFFIXES: .mli .ml .cmi .cmo

.mli.cmi:
	$(OCAMLC) -c $<

.ml.cmo:
	$(OCAMLC) -c $<

Makefile.source_dependencies: *.ml *.mli
	ocamldep *.ml *.mli >Makefile.source_dependencies

include Makefile.source_dependencies
