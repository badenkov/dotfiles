.PHONY: test switch build

HOSTNAME := $(shell hostname)

u:
	@echo $(MAKEFILE_DIR)
	@echo $(HOSTNAME)

test:
	sudo nixos-rebuild test --flake '.#$(HOSTNAME)'

switch:
	sudo nixos-rebuild switch --flake '.#$(HOSTNAME)'

build:
	sudo nixos-rebuild build --flake '.#$(HOSTNAME)'

