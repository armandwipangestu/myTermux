#!/bin/bash

HELPERS=(
    banner package colors dotfiles cursor
    clone themes
)

for HELPER in "${HELPERS[@]}"; do
    source helper/"${HELPER}.sh"
done

# banner
# printInfoPackages
# dotFiles
# repositories
zshTheme