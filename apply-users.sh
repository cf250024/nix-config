#!/bin/sh
pushd ~/.dotfiles
home-manager switch --flake ./users/nixos/#nixos
popd
