#!/usr/bin/env bash

PACKAGES=(
    bat curl clang exa fzf git lf mpd
    mpc neovim neofetch termux-api zsh
)

printInfoPackages() {
    
    KB_DOWNLOAD_SIZE=0
    MB_DOWNLOAD_SIZE=0
    
    KB_INSTALLED_SIZE=0
    MB_INSTALLED_SIZE=0
    
    echo -e "  ╭─ Dependency Packages ────────────────────────────────────────────────╮"
    echo -e "  │                                                                      │"
    printf "  │    %-15s    %-10s    %-13s    %-14s  │\n" "Name" "Version" "Download Size" "Installed Size"
    printf "  │    %-15s    %-10s    %-13s    %-14s  │\n" "───────────────" "──────────" "─────────────" "──────────────"
    
    for PACKAGE in "${PACKAGES[@]}"; do
        
        PACKAGE_NAME=$(apt show "$PACKAGE" 2> /dev/null | grep Package: | awk '{print $2}')
        VERSION=$(apt show "$PACKAGE" 2> /dev/null | grep Version: | awk '{print $2}')
        DOWNLOAD_SIZE=$(apt show "$PACKAGE" 2> /dev/null | grep Download-Size: | awk '{print $2}')
        INSTALLED_SIZE=$(apt show "$PACKAGE" 2> /dev/null | grep Installed-Size: | awk '{print $2}')
        
        UNIT_DOWNLOAD_SIZE=$(apt show "$PACKAGE" 2> /dev/null | grep Download-Size: | awk '{print $3}')
        UNIT_INSTALLED_SIZE=$(apt show "$PACKAGE" 2> /dev/null | grep Installed-Size: | awk '{print $3}')
        
        printf "  │  · ${COLOR_BLUE}%-15s${COLOR_RESET}    %-10s    ${COLOR_SUCCESS}%-4s${COLOR_RESET} %-2s          ${COLOR_WARNING}%-4s${COLOR_RESET} %-2s         │\n" "$PACKAGE_NAME" "$VERSION" "$DOWNLOAD_SIZE" "$UNIT_DOWNLOAD_SIZE" "$INSTALLED_SIZE" "$UNIT_INSTALLED_SIZE"
        
        if [[ "${UNIT_DOWNLOAD_SIZE}" == "kB" && "${UNIT_INSTALLED_SIZE}" == "MB" ]]; then
            
            KB_DOWNLOAD_SIZE=$(echo "${KB_DOWNLOAD_SIZE} + ${DOWNLOAD_SIZE} / 1024" | bc -l | xargs -i printf "%'.1f" {})
            MB_INSTALLED_SIZE=$(echo "${MB_INSTALLED_SIZE} + ${INSTALLED_SIZE}" | bc -l | xargs -i printf "%'.1f" {})
            
            elif [[ "${UNIT_DOWNLOAD_SIZE}" == "MB" && "${UNIT_INSTALLED_SIZE}" == "kB" ]]; then
            
            MB_DOWNLOAD_SIZE=$(echo "${MB_DOWNLOAD_SIZE} + ${DOWNLOAD_SIZE}" | bc -l | xargs -i printf "%'.1f" {})
            KB_INSTALLED_SIZE=$(echo "${KB_INSTALLED_SIZE} + ${INSTALLED_SIZE} / 1024" | bc -l | xargs -i printf "%'.1f" {})
            
            elif [[ "${UNIT_DOWNLOAD_SIZE}" == "kB" && "${UNIT_INSTALLED_SIZE}" == "kB" ]]; then
            
            KB_DOWNLOAD_SIZE=$(echo "${KB_DOWNLOAD_SIZE} + ${DOWNLOAD_SIZE} / 1024" | bc -l | xargs -i printf "%'.1f" {})
            KB_INSTALLED_SIZE=$(echo "${KB_INSTALLED_SIZE} + ${INSTALLED_SIZE} / 1024" | bc -l | xargs -i printf "%'.1f" {})
            
            elif [[ "${UNIT_DOWNLOAD_SIZE}" == "MB" && "${UNIT_INSTALLED_SIZE}" == "MB" ]]; then
            
            MB_DOWNLOAD_SIZE=$(echo "${MB_DOWNLOAD_SIZE} + ${DOWNLOAD_SIZE}" | bc -l | xargs -i printf "%'.1f" {})
            MB_INSTALLED_SIZE=$(echo "${MB_INSTALLED_SIZE} + ${INSTALLED_SIZE}" | bc -l | xargs -i printf "%'.1f" {})
            
        fi
        
    done
    
    TOTAL_DOWNLOAD_SIZE=$(echo "${KB_DOWNLOAD_SIZE} + ${MB_DOWNLOAD_SIZE}" | bc -l | xargs -i printf "%'.1f" {})
    TOTAL_INSTALLED_SIZE=$(echo "${KB_INSTALLED_SIZE} + ${MB_INSTALLED_SIZE}" | bc -l | xargs -i printf "%'.1f" {})
    
    echo -e "  │                                                                      │"
    echo -e "  ╰──────────────────────────────────────────────────────────────────────╯\n"
    echo -e "                                    ╭─ TOTAL ──────────────────────╮          "
    echo -e "                                    │  · Download Size: ${COLOR_SUCCESS}${TOTAL_DOWNLOAD_SIZE}${COLOR_DEFAULT} MB    │            "
    echo -e "                                    │  · Installed Size: ${COLOR_WARNING}${TOTAL_INSTALLED_SIZE}${COLOR_DEFAULT} MB  │           "
    echo -e "                                    ╰──────────────────────────────╯          "
}

function installPackages() {
    
    setCursor off
    gum style --border rounded --margin '1 2' --padding '0 2' 'Downloading Packages'
    
    for PACKAGE in "${PACKAGES[@]}"; do
        
        if gum spin -s line --title "Installing ${PACKAGE}" -- pkg i -y "${PACKAGE}"; then
            printf "  %-10s %-10s ${COLOR_SUCCESS}${OK}${COLOR_DEFAULT}\n" "Installing" "${PACKAGE}"
        else
            printf "  %-10s %-10s ${COLOR_DANGER}${FAIL}${COLOR_DEFAULT}\n" "Installing" "${PACKAGE}"
        fi
        
    done
    
    echo -e ""
    setCursor on
    
    
}
