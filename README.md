## Overview

Ospecl is a library for writing executable specifications for your OCaml code à la [rspec](http://rspec.info/).

Ospecl allows you to build *specs*, which are nested data structures combining textual descriptions of the component's behaviour, together with the code that can verify it. Specs may then be executed to verify your component's continued conformance.

Specs are built using calls to `describe` to provide context for a group of executable examples, each constructed through `it` calls. Examples contain a single *expectation* which uses *matchers* to test whether a given value meets some criteria.


## Usage

    let component_spec = 
      describe "some component" [
        it "has some behaviour" begin
          expect my_component (has some_behaviour)
        end;
        describe "in some particular context" begin
          let different = in_context my_component in
          [
            it "has some different behaviour" begin
              expect different (has different_behaviour)
            end;
            it "does something else too" begin
              different =~ (does something_else)
            end
          ]
        end
      ]

Here, `describe` takes a string, which, well, describes what you're specifying, and a list of child specs. `it` takes a string, which describes the behaviour that this example verifies, and an expectation. `expect` takes a value and a matcher for that value and returns an expectation, which will be checked when the spec is executed. `=~` is an alias for `expect` which can be used infix.

As you can see, specs may be nested arbitrarily within each other, so you can organise your contexts and examples as you see fit.

A [working example](https://github.com/rapha/Ospecl/blob/master/examples/account_spec.ml) can be found in the examples directory, and another one [here](https://gist.github.com/896752#file_spec.ml).


## Installation

    $ make install

will install `ospecl` as a findlib package.

    $ make uninstall

will uninstall it.


## Matchers

Matchers are used to construct expectations. They are based on the idea of matchers in [hamcrest](http://code.google.com/p/hamcrest/), which is like a predicate coupled with a way of describing successful and unsucessful matches. Matchers are nice because they are both descriptive on their own, and may be composed to build arbitrary new self-describing constraints on values. Ospecl comes with a core set of matchers in `Ospecl.Matchers`, but you can define additional matchers on top of `Ospecl.Matcher` to fit your domain.

## Execution

There are several ways to execute specs.

### Command line

First:

    $ ln -s `pwd`/ospecl ~/bin/ospecl

Thereafter:

    $ ospecl -color -I dir_with_cmo_files my_spec1.ml my_spec2.ml my_spec3.ml 
    
`ospecl` accepts a list of ocaml script files, each of which must define a single value called `specs` of type `Ospecl.Spec.t list`. The specs from each of these files will be executed and the results reported together.

### Provided runners

Ospecl comes with runner functions `Ospecl.Console.progress` and `Ospecl.Console.documentation` which take a list of specs, execute them, print the results to stdout and exit. They're designed to be used in your own spec runner which is run from the shell.

### Custom runners

Custom runners may be built by calling `Ospecl.Spec.Exec.execute` with your own set of handlers for the events that are fired during the execution of the specs.
