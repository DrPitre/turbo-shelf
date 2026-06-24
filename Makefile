# Makefile for turbo-shelf
#
# Builds the Turbo9 simulator and its toolchain dependencies.
# Usage: make [ANON=1]

include conf.mk

all: turbos.done hyper9.done

############################################################################

turbos.done: turbos.got tfr9.got lwtools.done
	make -C turbos/ports/turbo9sim TURBOSDIR=$(SHELF)/turbos
	date > $@

hyper9.done: hyper9.got
	mkdir -p bin
	cd hyper9 && swift build -c release --product hyper9-cmd
	cp hyper9/.build/release/hyper9-cmd bin/
	date > $@

lwtools.done: lwtools.got
	make -C lwtools PREFIX="$(SHELF)" all
	make -C lwtools PREFIX="$(SHELF)" install
	date > $@

############################################################################

lwtools.got: inputs/$(TURBOBENCH_LWTOOLS_TARBALL)
	test -d lwtools || { tar -xzf inputs/$(TURBOBENCH_LWTOOLS_TARBALL) && mv -v $(TURBOBENCH_LWTOOLS_VERSION) lwtools; }
	date > $@

turbos.got:
	B=$(basename $@); set -x; test -d $$B || git clone $(TURBOBENCH_TURBOS_REPO) $$B
	date > $@

tfr9.got:
	B=$(basename $@); set -x; test -d $$B || git clone $(TURBOBENCH_TFR9_REPO) $$B
	date > $@

hyper9.got:
	B=$(basename $@); set -x; test -d $$B || git clone $(TURBOBENCH_HYPER9_REPO) $$B
	date > $@

pico-sdk.got:
	B=$(basename $@); set -x; test -d $$B || git clone --recurse-submodules $(TURBOBENCH_PICO_SDK_REPO) $$B
	date > $@

############################################################################

inputs/$(TURBOBENCH_LWTOOLS_TARBALL):
	mkdir -p inputs
	set -x; test -s $@ || curl $(TURBOBENCH_LWTOOLS_URL) > $@
	expr 33333 '<' $$( wc -c < $@ ) || ( mv $@ $@.BAD ; exit 13 )

############################################################################

clean:
	rm -rf *.got *.done
	rm -rf bin share lib libexec usr include
	rm -rf lwtools turbos tfr9 hyper9 pico-sdk

_FORCE_:
