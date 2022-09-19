#!/usr/bin/env bash

ZSH_CUSTOM_THEMES=(
    osx.zsh-theme
    osx2.zsh-theme
    archcraft.zsh-theme
    ar-round.zsh-theme
    la-round.zsh-theme
    rounded-custom.zsh-theme
    rounded.zsh-theme
    simple.zsh-theme
)

function zshTheme() {
    
    setCursor off
    
    echo -e "  ╭─ ZSH Themes ────────────────────────────────╮"
    echo -e "  │                                             │"
    printf "  │    %-24s    %-9s    │\n" "File Name" "File Size"
    printf "  │    %-24s    %-9s    │\n" "────────────────────────" "─────────"
    
    for ZSH_CUSTOM_THEME in "${ZSH_CUSTOM_THEMES[@]}"; do
        
        FILE_SIZE=$(du -s -h .oh-my-zsh/custom/themes/$ZSH_CUSTOM_THEME | awk '{print $1}')
        printf "  │  · ${COLOR_BLUE}%-24s${COLOR_RESET}    ${COLOR_SUCCESS}%-5s${COLOR_RESET}        │\n" "$ZSH_CUSTOM_THEME" "$FILE_SIZE"
        
    done
    
    echo -e "  │                                             │"
    echo -e "  ╰─────────────────────────────────────────────╯\n"
    
}

function installZshTheme() {
    
    setCursor off
    
    echo -e "\n‏‏‎‏‏‎ ‎ ‎‏‏‎  ‎📦 Installing ZSH Custom Themes\n"
    
    PATHDIR=".oh-my-zsh/custom/themes"
    
    for ZSH_CUSTOM_THEME in "${ZSH_CUSTOM_THEMES[@]}"; do
        
        start_animation "       Installing ${COLOR_WARNING}'${COLOR_SUCCESS}${ZSH_CUSTOM_THEME}${COLOR_WARNING}'${COLOR_BASED} ..."
        sleep 2s
        cp $(pwd)/${PATHDIR}/${ZSH_CUSTOM_THEME} $HOME/${PATHDIR}/${ZSH_CUSTOM_THEME}
        
        if [ -f $HOME/$PATHDIR/$ZSH_CUSTOM_THEME ]; then
            
            stop_animation $? || exit 1
            
        else
            
            stop_animation $?
            
        fi
        
    done
    
    setCursor on
    
}
