hostname := `hostname`

default:
  @just --list

# Build the configuration
build:
	@sudo nixos-rebuild build --flake '.#{{hostname}}'

# Build the configuration and activate it, but don't add it to the bootloader menu
test:
	@sudo nixos-rebuild test --flake '.#{{hostname}}'

# Build the configuration, activate it and make it the default boot option
switch:
	@sudo nixos-rebuild switch --flake '.#{{hostname}}'

