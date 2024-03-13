#!/bin/sh
pushd ~/.dotfiles
home-manager switch -I ./users/nixos/home.nix
popd
