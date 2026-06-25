# Makefile for turbo-shelf
#
# Builds the Turbo9 simulator and its toolchain dependencies.
# Usage: make [ANON=1]

include conf.mk

all: turbos.done hyper9.done freertos-turbo9.done

TURBOS_IMAGE ?= turbos/ports/turbo9sim/turbos_dev.img
TURBOS_SMOKE_IMAGE ?= turbos/ports/turbo9sim/turbos_smoke.img
TURBOS_SMOKE_SECONDS ?= 1.0

############################################################################

turbos.done: turbos.got tfr9.got lwtools.done
	make -C turbos/ports/turbo9sim TURBOSDIR=$(SHELF)/turbos
	date > $@

turbos-smoke-image.done: turbos.got tfr9.got lwtools.done turbos/ports/turbo9sim/go_smoke.asm
	make -C turbos/ports/turbo9sim TURBOSDIR=$(SHELF)/turbos turbos_smoke.img
	date > $@

turbos-run: turbos.done hyper9.done
	./bin/hyper9-cmd $(TURBOS_IMAGE)

turbos-smoke: turbos-smoke-image.done hyper9.done
	./scripts/turbos-smoke --seconds $(TURBOS_SMOKE_SECONDS) --expect-output "TurbOS OK" ./bin/hyper9-cmd $(TURBOS_SMOKE_IMAGE)

turbos-dev-smoke: turbos.done hyper9.done
	./scripts/turbos-smoke --seconds 3.0 --input "mdir\\r" --input-after-output "TOS:" --expect-output "Module directory" ./bin/hyper9-cmd turbos/ports/turbo9sim/turbos_dev.img

turbos-smoke-all: turbos.done hyper9.done
	./scripts/turbos-smoke --seconds $(TURBOS_SMOKE_SECONDS) ./bin/hyper9-cmd turbos/ports/turbo9sim/turbos_lite.img
	./scripts/turbos-smoke --seconds $(TURBOS_SMOKE_SECONDS) ./bin/hyper9-cmd turbos/ports/turbo9sim/turbos_core.img
	./scripts/turbos-smoke --seconds $(TURBOS_SMOKE_SECONDS) ./bin/hyper9-cmd turbos/ports/turbo9sim/turbos_dev.img

hyper9.done: hyper9.got hyper9/hyper9-cmd/main.swift
	mkdir -p bin
	cd hyper9 && swift build -c release --product hyper9-cmd
	cp hyper9/.build/release/hyper9-cmd bin/
	date > $@

freertos-turbo9.done: freertos-turbo9.got hyper9.done lwtools.done
	make -C FreeRTOS_Turbo9/FreeRTOS/Demo/Turbo9_CLANG clean
	make -C FreeRTOS_Turbo9/FreeRTOS/Demo/Turbo9_CLANG freertos_baseline.img
	date > $@

freertos-coco-clang.done: freertos-turbo9.got lwtools.done
	make -C FreeRTOS_Turbo9/FreeRTOS/Demo/CoCo_CLANG clean
	make -C FreeRTOS_Turbo9/FreeRTOS/Demo/CoCo_CLANG freertos.dsk
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

freertos-turbo9.got:
	set -x; test -d FreeRTOS_Turbo9 || git clone $(TURBOBENCH_FREERTOS_TURBO9_REPO) FreeRTOS_Turbo9
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
	rm -rf lwtools turbos tfr9 hyper9 FreeRTOS_Turbo9 pico-sdk

_FORCE_:
