# This is conf.mk for turbo-bench.

S:=$(shell pwd)
P:=$(shell echo $$PATH)
export SHELF:=$S
export SHELL:=/bin/bash
export PATH:=$S/bin:$P

# Append ANON=1 to clone anonymously (no ssh key needed).
ifdef ANON
REPO_PREFIX=https://github.com/
REPO_SUFFIX=
else
REPO_PREFIX=git@github.com:
REPO_SUFFIX=.git
endif

# Repository sources
TURBOBENCH_TURBOS_REPO:=$(REPO_PREFIX)boisy/turbos$(REPO_SUFFIX)
TURBOBENCH_TFR9_REPO:=$(REPO_PREFIX)strickyak/tfr9$(REPO_SUFFIX)

# lwtools version
TURBOBENCH_LWTOOLS_VERSION:=lwtools-4.24
TURBOBENCH_LWTOOLS_TARBALL:=$(TURBOBENCH_LWTOOLS_VERSION).tar.gz
TURBOBENCH_LWTOOLS_URL:="http://www.lwtools.ca/releases/lwtools/$(TURBOBENCH_LWTOOLS_TARBALL)"
