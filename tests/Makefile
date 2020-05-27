.PHONY: unittests
UNIT_JSONNET=$(sort $(wildcard unittest*.jsonnet))

tests: unittests

unittests: req-jsonnet
	jsonnet -J ../vendor/ $(UNIT_JSONNET)

req-%:
	@which $(*) >/dev/null && exit 0; echo "ERROR: '$(*)' is required in PATH"; exit 1
