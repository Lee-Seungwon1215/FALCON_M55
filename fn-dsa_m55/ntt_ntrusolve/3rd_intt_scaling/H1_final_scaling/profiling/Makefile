# H1-local measurement entry points. No cryptographic candidate selection.
.DEFAULT_GOAL := help
PROFILE_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
PYTHON ?= python3

ifneq ($(origin TARGET),undefined)
$(error TARGET belongs to the old C-only setup; use check, m55 or audit)
endif
ifneq ($(origin INSTRUMENT),undefined)
$(error INSTRUMENT belongs to the old C-only setup; see README.md)
endif

.PHONY: help check all m55 audit pilot audit-pilot full
help:
	@echo 'check: no build/hardware; m55: performance build; audit: arithmetic-test build'
	@echo 'pilot / audit-pilot / full LABEL=<new-label>: explicitly access the M55 board'
check:
	$(PYTHON) "$(PROFILE_DIR)m55.py" check
all: m55
m55:
	bash "$(PROFILE_DIR)build_m55.sh" perf
audit:
	bash "$(PROFILE_DIR)build_m55.sh" audit
pilot:
	$(PYTHON) "$(PROFILE_DIR)m55.py" run perf pilot --label "$(LABEL)"
audit-pilot:
	$(PYTHON) "$(PROFILE_DIR)m55.py" run audit pilot --label "$(LABEL)"
full:
	$(PYTHON) "$(PROFILE_DIR)m55.py" run perf full --label "$(LABEL)"
