#!/bin/bash
# ============================================================
# Terminal Reset Script for CachyOS
# Restores Fish, Zsh and Bash back to CachyOS defaults
# ============================================================

# Text colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${RED}========================================${NC}"
echo -e "${RED}   CachyOS Terminal Reset Script        ${NC}"
echo -e "${RED}========================================${NC}"
echo -e "\n${YELLOW}This will restore all shells to CachyOS defaults.${NC}"
echo -e "${YELLOW}Your current configs will be backed up first.${NC}\n"

# ── Confirm ───────────────────────────────────────────────
read -p "Are you sure you want to reset? (y/n): " confirm
if [[ $confirm != "y" ]]; then
    echo -e "${GREEN}Reset cancelled. Nothing was changed.${NC}"
    exit 0
fi

# ── Backup current configs ────────────────────────────────
echo -e "\n${YELLOW}[1/4] Backing up current configs...${NC}"
BACKUP_DIR="$HOME/.config/shell-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"
cp ~/.bashrc "$BACKUP_DIR/.bashrc.bak" 2>/dev/null
cp ~/.zshrc "$BACKUP_DIR/.zshrc.bak" 2>/dev/null
cp ~/.config/fish/config.fish "$BACKUP_DIR/config.fish.bak" 2>/dev/null
echo -e "${GREEN}✔ Backups saved to $BACKUP_DIR${NC}"

# ── Reset Fish ────────────────────────────────────────────
echo -e "\n${YELLOW}[2/4] Resetting Fish...${NC}"
cat > ~/.config/fish/config.fish << 'EOF'
source /usr/share/cachyos-fish-config/cachyos-config.fish
# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end
EOF
echo -e "${GREEN}✔ Fish reset to default${NC}"

# ── Reset Zsh ─────────────────────────────────────────────
echo -e "\n${YELLOW}[3/4] Resetting Zsh...${NC}"
cat > ~/.zshrc << 'EOF'
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
source /usr/share/cachyos-zsh-config/cachyos-config.zsh
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
EOF
echo -e "${GREEN}✔ Zsh reset to default${NC}"

# ── Reset Bash ────────────────────────────────────────────
echo -e "\n${YELLOW}[4/4] Resetting Bash...${NC}"
cat > ~/.bashrc << 'EOF'
#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '
EOF
echo -e "${GREEN}✔ Bash reset to default${NC}"

# ── Done ──────────────────────────────────────────────────
echo -e "\n${GREEN}========================================${NC}"
echo -e "${GREEN}   Reset Complete!                       ${NC}"
echo -e "${GREEN}========================================${NC}"
echo -e "\nYour backups are saved at:"
echo -e "  ${YELLOW}$BACKUP_DIR${NC}"
echo -e "\nRestart your terminal to see the changes!"
