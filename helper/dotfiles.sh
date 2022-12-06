#!/usr/bin/env bash

BACKUP_DOTFILES=(
    .autostart .aliases
    .config .colorscheme
    .fonts .local .scripts
    .termux .tmux.conf
    .zshrc .oh-my-zsh
)

DOTFILES=(
    .autostart .aliases
    .config .colorscheme
    .fonts .local .scripts
    .termux .tmux.conf
    .zshrc
)


function dotFiles() {
    
    KB_DOTFILE_SIZE=0
    MB_DOTFILE_SIZE=0
    
    setCursor off
    
    echo -e "  ╭─ Dotfiles ─────────────────────────────────────╮"
    echo -e "  │                                                │"
    printf "  │    %-18s    %-18s    │\n" "Folder / File Name" "Folder / File Size"
    printf "  │    %-18s    %-18s    │\n" "──────────────────" "──────────────────"
    
    for DOTFILE in "${DOTFILES[@]}"; do
        
        FOLDER_SIZE=$(du -s -h "${DOTFILE}" | awk '{print $1}')
        UNIT_FOLDER_SIZE="${FOLDER_SIZE:0-1}"
        # echo -e "${UNIT_FOLDER_SIZE}"
        printf "  │  · ${COLOR_BLUE}%-12s${COLOR_RESET}          ${COLOR_SUCCESS}%-18s${COLOR_RESET}    │\n" "$DOTFILE" "$FOLDER_SIZE"
        
        if [[ "${UNIT_FOLDER_SIZE}" == "K" ]]; then
            KB_DOTFILE_SIZE=$(echo "${KB_DOTFILE_SIZE} + ${FOLDER_SIZE::-1} / 1024" | bc -l | xargs -i printf "%'.1f" {})
            elif [[ "${UNIT_FOLDER_SIZE}" == "M" ]]; then
            MB_DOTFILE_SIZE=$(echo "${MB_DOTFILE_SIZE} + ${FOLDER_SIZE::-1}" | bc -l | xargs -i printf "%'.1f" {})
        fi
        
    done
    
    TOTAL_DOTFILE_SIZE=$(echo "${KB_DOTFILE_SIZE} + ${MB_DOTFILE_SIZE}" | bc -l | xargs -i printf "%'.1f" {})
    
    echo -e "  │                                                │"
    echo -e "  ╰────────────────────────────────────────────────╯\n"
    echo -e "                               ╭─ TOTAL ───────────╮          "
    echo -e "                               │  · Size: ${COLOR_SUCCESS}${TOTAL_DOTFILE_SIZE}${COLOR_DEFAULT} MB  │            "
    echo -e "                               ╰───────────────────╯          "
    
}

function backupDotFiles() {
    
    read -rd "" restore <<"EOF"
DOTFILE_NAME=(

)
EOF
    
    printf '%s\n' "${restore}" > "restore.txt"
    
    setCursor off
    gum style --border rounded --margin '1 2' --padding '0 2' 'Backup Dotfiles'
    
    for BACKUP_DOTFILE in "${BACKUP_DOTFILES[@]}"; do
        
        if [[ -d "$HOME/$BACKUP_DOTFILE" || -f "$HOME/$BACKUP_DOTFILE" ]]; then
            
            gum spin -s line --title "Backup ${BACKUP_DOTFILE}" -- sleep 2s
            #mv "${HOME}/${BACKUP_DOTFILE}" "${HOME}/${BACKUP_DOTFILE}.$(date +%Y.%m.%d-%H.%M.%S).backup"
            echo -e "$(date +%Y.%m.%d-%H.%M.%S)"
            sed -i "2i ${BACKUP_DOTFILE}.$(date +%Y.%m.%d-%H.%M.%S)" restore.txt
            
            if [[ -d ${HOME}/${BACKUP_DOTFILE}.$(date +%Y.%m.%d-%H.%M.%S).backup || -f ${HOME}/${BACKUP_DOTFILE}.$(date +%Y.%m.%d-%H.%M.%S).backup ]]; then
                
                printf "  %-6s %-10s ${COLOR_SUCCESS}${OK}${COLOR_DEFAULT}\n" "Backup" "${BACKUP_DOTFILE}"
                
            else
                
                printf "  %-6s %-10s ${COLOR_DANGER}${FAIL}${COLOR_DEFAULT}\n" "Backup" "${BACKUP_DOTFILE}"
                
            fi
            
        else
            
            printf "  %-6s %-10s ${COLOR_DANGER}NOT FOUND${COLOR_DEFAULT}\n" "Backup" "${BACKUP_DOTFILE}"
            
        fi
        
    done
    
    echo -e ""
    
}

function installDotFiles() {
    
    setCursor off
    
    echo -e "\n‏‏‎‏‏‎ ‎ ‎‏‏‎  ‎📦 Installing Dotfiles\n"
    
    for DOTFILE in "${DOTFILES[@]}"; do
        
        if [ "${DOTFILE}" == ".termux" ]; then
            
            start_animation "       Installing ${COLOR_WARNING}'${COLOR_SUCCESS}${DOTFILE}${COLOR_WARNING}'${COLOR_BASED} ..."
            cp -R $DOTFILE $HOME
            
            if [[ -d $HOME/$DOTFILE || -f $HOME/$DOTFILE ]]; then
                
                termux-reload-settings
                stop_animation $? || exit 1
                
            else
                
                stop_animation $?
                
            fi
            
        else
            
            start_animation "       Installing ${COLOR_WARNING}'${COLOR_SUCCESS}${DOTFILE}${COLOR_WARNING}'${COLOR_BASED} ..."
            cp -R $DOTFILE $HOME
            
            if [[ -d $HOME/$DOTFILE || -f $HOME/$DOTFILE ]]; then
                
                stop_animation $? || exit 1
                
            else
                
                stop_animation $?
                
            fi
            
        fi
        
    done
    
    echo -e ""
    
    setCursor on
    
}
