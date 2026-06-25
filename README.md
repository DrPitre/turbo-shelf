# turbo-shelf

A focused build shelf for the Turbo9 processor ecosystem.

Clones and builds:
- **[turbos](https://github.com/boisy/turbos)** — Turbo9 simulator and OS port
- **[tfr9](https://github.com/strickyak/tfr9)** — TFR9 hardware support
- **[pico-sdk](https://github.com/raspberrypi/pico-sdk)** — Raspberry Pi Pico SDK for TFR9 firmware builds
- **[lwtools](http://www.lwtools.ca/)** — 6809/6309 assembler toolchain
- **[Hyper9](https://github.com/DrPitre/Hyper9)** — Turbo9 simulator (requires Swift)
- **[FreeRTOS_Turbo9](https://github.com/DrPitre/FreeRTOS_Turbo9)** — FreeRTOS port for Turbo9, 6809, and CoCo

## Quick Start

```sh
git clone <this repo>
cd turbo-shelf
make ANON=1
```

Remove `ANON=1` if you have a GitHub SSH key in your agent.

## Setting Your PATH

After building, add `bin/` to your shell's PATH so the tools are available anywhere.
Run this once from inside the turbo-shelf directory:

```sh
# macOS (zsh)
echo "export PATH=\"$(pwd)/bin:\$PATH\"" >> ~/.zshrc && source ~/.zshrc

# Linux (bash)
echo "export PATH=\"$(pwd)/bin:\$PATH\"" >> ~/.bashrc && source ~/.bashrc
```

## What Gets Built

| Target | Description |
|---|---|
| `lwtools.done` | lwtools assembler, installed to `bin/` |
| `turbos.done` | Turbo9 simulator (`turbos/ports/turbo9sim`) |
| `hyper9.done` | `hyper9-cmd` CLI, installed to `bin/` (requires Swift) |
| `freertos-turbo9.got` | FreeRTOS_Turbo9 source clone |
| `freertos-turbo9.done` | Turbo9 FreeRTOS CLANG demo image built with LLVM-6809 (requires `os9`, `lwtools`, Hyper9, and LLVM-6809) |
| `freertos-coco-clang.done` | CoCo FreeRTOS CLANG demo disk image built with LLVM-6809 (requires `decb`, `lwtools`, and LLVM-6809) |
| `pico-sdk.got` | Raspberry Pi Pico SDK, cloned with submodules and exported as `PICO_SDK_PATH` |

Build the FreeRTOS Turbo9 demo explicitly with:

```sh
make freertos-turbo9.done
```

Smoke-test the FreeRTOS Turbo9 demo under Hyper9:

```sh
make freertos-smoke
```

Build the FreeRTOS CoCo CLANG demo explicitly with:

```sh
make freertos-coco-clang.done
```

Run the TurbOS Turbo9 simulator image with Hyper9:

```sh
make turbos-run
```

By default this runs `turbos/ports/turbo9sim/turbos_dev.img`. Override the image
with `TURBOS_IMAGE=...`.

Run a non-interactive smoke test that builds a dedicated TurbOS image, starts
`hyper9-cmd`, and verifies it prints `TurbOS OK`:

```sh
make turbos-smoke
```

Use `make turbos-smoke-all` to smoke-test `turbos_lite.img`,
`turbos_core.img`, and `turbos_dev.img`.

Run an interactive-shell smoke test against the dev TurbOS image:

```sh
make turbos-dev-smoke
```

This waits for the `TOS:` prompt, sends `mdir`, and verifies the module directory
header is printed.

The `FreeRTOS/Demo/*_CLANG` builds default to `/Volumes/Lagniappe/llvm/llvm-mc6809/llvm/build`.
Override `LLVM6809_ROOT`, `LLVM6809_BINDIR`, or `LLVM6809_RTDIR` if your toolchain
is installed somewhere else.

## Cleaning Up

```sh
make clean
```
