# turbo-bench

A focused build shelf for the Turbo9 processor ecosystem.

Clones and builds:
- **[turbos](https://github.com/boisy/turbos)** — Turbo9 simulator and OS port
- **[tfr9](https://github.com/strickyak/tfr9)** — TFR9 hardware support
- **[lwtools](http://www.lwtools.ca/)** — 6809/6309 assembler toolchain

## Quick Start

```sh
git clone <this repo>
cd turbo-bench
make ANON=1
```

Remove `ANON=1` if you have a GitHub SSH key in your agent.

## What Gets Built

| Target | Description |
|---|---|
| `lwtools.done` | lwtools assembler, installed to `bin/` |
| `turbos.done` | Turbo9 simulator (`turbos/ports/turbo9sim`) |

## Cleaning Up

```sh
make clean
```
