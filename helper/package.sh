#!/usr/bin/env bash

PACKAGES=(
    awesomeshot bat curl clang exa fzf git imagemagick
    inotify-tools lf mpd mpc neovim openssh
    neofetch termux-api tmux zsh
)

printInfoPackages() {
    
    KB_DOWNLOAD_SIZE=0
    MB_DOWNLOAD_SIZE=0
    
    KB_INSTALLED_SIZE=0
    MB_INSTALLED_SIZE=0
    
    echo -e "  ╭─ myTermux Packages ──────────────────────────────────────────────────╮"
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
    echo -e "                                          ╭─ TOTAL ──────────────────────╮          "
    echo -e "                                          │  · Download Size: ${COLOR_SUCCESS}${TOTAL_DOWNLOAD_SIZE}${COLOR_DEFAULT} MB    │            "
    echo -e "                                          │  · Installed Size: ${COLOR_WARNING}${TOTAL_INSTALLED_SIZE}${COLOR_DEFAULT} MB  │           "
    echo -e "                                          ╰──────────────────────────────╯          "
}

function installPackages() {
    
    setCursor off
    
    echo -e "\n‏‏‎‏‏‎ ‎ ‎‏‏‎  ‎📦 Downloading Packages\n"
    
    for PACKAGE in "${PACKAGES[@]}"; do
        
        start_animation "       Installing ${COLOR_WARNING}'${COLOR_SUCCESS}${PACKAGE}${COLOR_WARNING}'${COLOR_BASED} ..."
        
        pkg i -y $PACKAGE &>/dev/null
        THIS_PACKAGE=$(pkg list-installed $PACKAGE 2> /dev/null | tail -n 1)
        CHECK_PACKAGE=${THIS_PACKAGE%/*}
        
        if [[ $CHECK_PACKAGE == $PACKAGE ]]; then
            
            stop_animation $? || exit 1
            
        else
            
            stop_animation $?
            
        fi
        
    done
    
    setCursor on
    
}
