#!/bin/sh
pushd ~/.dotfiles
nix build .#homeConfigurations.nixos.activationPackage
./result/activate
popd
