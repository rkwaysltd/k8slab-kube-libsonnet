.PHONY: %.unittests %.eval-pass %.eval-fail

# Test files
UNIT_JSONNET=$(sort $(wildcard unittest*.jsonnet))
PASS_JSONNET=$(sort $(wildcard test*pass.jsonnet))
FAIL_JSONNET=$(sort $(wildcard test*fail.jsonnet))

# Phony targets
PHONY_EVAL_PASS=$(patsubst %.jsonnet,%.eval-pass,$(PASS_JSONNET))
PHONY_EVAL_FAIL=$(patsubst %.jsonnet,%.eval-fail,$(FAIL_JSONNET))
PHONY_UNITTESTS=$(patsubst %.jsonnet,%.unittests,$(UNIT_JSONNET))

tests: req-jsonnet $(PHONY_UNITTESTS) $(PHONY_EVAL_PASS) $(PHONY_EVAL_FAIL)

JSONNET_OPTS=-J ../vendor/ -V qbec.io/tag=testtag -V com.gitlab.ci.cijoburl=test -V com.gitlab.ci.revision=test -V rkways.com/prune-key=test

%.unittests: %.jsonnet
	@echo "INFO: must PASS: $(<)"
	@(jsonnet $(JSONNET_OPTS) $(<))
	@echo "OK[PASS]: $(<)"

%.eval-pass: %.jsonnet
	@echo "INFO: must PASS: $(<)"
	@(jsonnet $(JSONNET_OPTS) $(<) > /dev/null)
	@echo "OK[PASS]: $(<)"

%.eval-fail: %.jsonnet
	@echo "INFO: must FAIL: $(<)"
	@(jsonnet $(JSONNET_OPTS) $(<) > /dev/null) 2>&1 | grep RUNTIME.ERROR
	@echo "OK[FAIL]: $(<)"

req-%:
	@which $(*) >/dev/null && exit 0; echo "ERROR: '$(*)' is required in PATH"; exit 1
