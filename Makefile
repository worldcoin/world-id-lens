all: install build
# Install forge dependencies (not needed if submodules are already initialized).
install:; forge install
# Build contracts.
build:; forge build
# Update forge dependencies.
update:; forge update
