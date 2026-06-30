#!/usr/bin/env bash

set -e

mkdir -p ~/.config
rm -f ~/.config/nvim
ln -s "$PWD" ~/.config/nvim
