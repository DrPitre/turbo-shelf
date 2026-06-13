# turbo-bench

A focused build shelf for the Turbo9 processor ecosystem.

Clones and builds:
- **[turbos](https://github.com/boisy/turbos)** — Turbo9 simulator and OS port
- **[tfr9](https://github.com/strickyak/tfr9)** — TFR9 hardware support
- **[lwtools](http://www.lwtools.ca/)** — 6809/6309 assembler toolchain
- **[Hyper9](https://github.com/DrPitre/Hyper9)** — Turbo9 simulator (requires Swift)

## Quick Start

```sh
git clone <this repo>
cd turbo-bench
make ANON=1
```

Remove `ANON=1` if you have a GitHub SSH key in your agent.

## Setting Your PATH

After building, add `bin/` to your shell's PATH so the tools are available anywhere.
Run this once from inside the turbo-bench directory:

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

## Cleaning Up

```sh
make clean
```
