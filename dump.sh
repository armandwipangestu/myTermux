#!/bin/bash

HELPERS=(
    banner package colors dotfiles cursor
    clone themes icon
)

for HELPER in "${HELPERS[@]}"; do
    source helper/"${HELPER}.sh"
done

banner
printInfoPackages
if gum confirm; then
    installPackages
fi
dotFiles
if gum confirm; then
    backupDotFiles
fi
# repositories
# zshTheme