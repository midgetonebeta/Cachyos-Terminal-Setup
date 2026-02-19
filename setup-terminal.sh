#!/bin/bash
# ============================================================
# Terminal Setup Script for CachyOS
# Sets up Oh My Posh + aliases + plugins for Fish, Zsh, Bash
# ============================================================

# Text colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}   CachyOS Terminal Setup Script        ${NC}"
echo -e "${GREEN}========================================${NC}"

# ── Variables ─────────────────────────────────────────────
THEME_PATH="/home/$USER/Templates/oh my posh/themes/Maintheme/clean-detailed.omp.json"

# ── Check Oh My Posh ──────────────────────────────────────
echo -e "\n${YELLOW}[1/5] Checking Oh My Posh...${NC}"
if command -v oh-my-posh &> /dev/null; then
    echo -e "${GREEN}✔ Oh My Posh is installed: $(oh-my-posh --version)${NC}"
else
    echo -e "${RED}✘ Oh My Posh not found! Installing...${NC}"
    paru -S oh-my-posh-bin
fi

# ── Install packages ──────────────────────────────────────
echo -e "\n${YELLOW}[2/5] Installing required packages...${NC}"
sudo pacman -S --needed --noconfirm tree fzf bat eza fd ripgrep htop zsh-autosuggestions zsh-syntax-highlighting
paru -S --needed --noconfirm zsh-autocomplete
echo -e "${GREEN}✔ Packages installed${NC}"

# ── Setup Fish ────────────────────────────────────────────
echo -e "\n${YELLOW}[3/5] Setting up Fish...${NC}"
cat > ~/.config/fish/config.fish << 'EOF'
source /usr/share/cachyos-fish-config/cachyos-config.fish
oh-my-posh init fish --config "/home/$USER/Templates/oh my posh/themes/Maintheme/clean-detailed.omp.json" | source

# Better history
set -g fish_history_size 10000

# ── Navigation shortcuts ──────────────────────────────
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# ── Better file listing ───────────────────────────────
alias ls='eza --icons'
alias ll='eza -alF --icons'
alias la='eza -a --icons'
alias lt='eza --tree --icons'

# ── Better cat ───────────────────────────────────────
alias cat='bat'

# ── Quick config editing ──────────────────────────────
alias zshconfig='code-oss ~/.zshrc'
alias fishconfig='code-oss ~/.config/fish/config.fish'
alias bashconfig='code-oss ~/.bashrc'
alias reload='source ~/.config/fish/config.fish'

# ── System info ───────────────────────────────────────
alias topmem='ps aux --sort=-%mem | head'
alias topcpu='ps aux --sort=-%cpu | head'
alias myip='curl ifconfig.me'
alias weather='curl wttr.in'

# ── Pacman shortcuts ──────────────────────────────────
alias install='sudo pacman -S'
alias search='pacman -Ss'
alias remove='sudo pacman -Rsn'
alias update='sudo pacman -Syu'
alias cleanup='sudo pacman -Rsn $(pacman -Qtdq)'
alias c='clear'

# ── Tree alias ────────────────────────────────────────
alias tree='tree --dirsfirst -C'

# ── Search history ────────────────────────────────────
alias histg='history | grep'

# ── Git shortcuts ─────────────────────────────────────
function g; git $argv; end
function gs; git status $argv; end
function gcm; git commit $argv; end
function gph; git push $argv; end
function gpl; git pull $argv; end

# ── Go up multiple directories ────────────────────────
function up
    cd (string repeat -n $argv[1] ../)
end

# ── Mkdir and cd ─────────────────────────────────────
function mkcd
    mkdir -p $argv[1] && cd $argv[1]
end

# ── Find where a command is located ──────────────────
function whereis; which $argv; end
EOF
echo -e "${GREEN}✔ Fish configured${NC}"

# ── Setup Zsh ─────────────────────────────────────────────
echo -e "\n${YELLOW}[4/5] Setting up Zsh...${NC}"
cat > ~/.zshrc << 'EOF'
# Oh My Posh
eval "$(oh-my-posh init zsh --config "/home/$USER/Templates/oh my posh/themes/Maintheme/clean-detailed.omp.json")"

# Oh-my-zsh plugins (without p10k)
export ZSH="/usr/share/oh-my-zsh"
plugins=(git fzf extract)
source $ZSH/oh-my-zsh.sh

# Better history
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_DUPS
setopt SHARE_HISTORY

# ── Navigation shortcuts ──────────────────────────────
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# ── Better file listing ───────────────────────────────
alias ls='eza --icons'
alias ll='eza -alF --icons'
alias la='eza -a --icons'
alias lt='eza --tree --icons'

# ── Better cat ───────────────────────────────────────
alias cat='bat'

# ── Quick config editing ──────────────────────────────
alias zshconfig='code-oss ~/.zshrc'
alias fishconfig='code-oss ~/.config/fish/config.fish'
alias bashconfig='code-oss ~/.bashrc'
alias reload='source ~/.zshrc'

# ── System info ───────────────────────────────────────
alias ports='netstat -tulanp'
alias topmem='ps aux --sort=-%mem | head'
alias topcpu='ps aux --sort=-%cpu | head'
alias myip='curl ifconfig.me'
alias weather='curl wttr.in'

# ── Pacman shortcuts ──────────────────────────────────
alias install='sudo pacman -S'
alias search='pacman -Ss'
alias remove='sudo pacman -Rsn'
alias update='sudo pacman -Syu'
alias cleanup='sudo pacman -Rsn $(pacman -Qtdq)'
alias c='clear'
alias jctl='journalctl -p 3 -xb'

# ── Tree alias ────────────────────────────────────────
alias tree='tree --dirsfirst -C'
alias make="make -j$(nproc)"
alias ninja="ninja -j$(nproc)"

# ── Search history ────────────────────────────────────
alias histg='history | grep'

# ── Git shortcuts ─────────────────────────────────────
function g  { git $@ }
function gs { git status $@ }
function gcm { git commit $@ }
function gph { git push $@ }
function gpl { git pull $@ }

# ── Go up multiple directories ────────────────────────
function up { cd $(printf '../%.0s' $(seq 1 $1)) }

# ── Mkdir and cd ─────────────────────────────────────
mkcd() { mkdir -p "$1" && cd "$1" }

# ── Find where a command is located ──────────────────
function whereis { which $1 }

# ── Autocomplete & plugins ───────────────────────────
source /usr/share/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# ── FZF ──────────────────────────────────────────────
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh
EOF
echo -e "${GREEN}✔ Zsh configured${NC}"

# ── Setup Bash ────────────────────────────────────────────
echo -e "\n${YELLOW}[5/5] Setting up Bash...${NC}"
cat > ~/.bashrc << 'EOF'
#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '
eval "$(oh-my-posh init bash --config "/home/$USER/Templates/oh my posh/themes/Maintheme/clean-detailed.omp.json")"

# Better history
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoredups:erasedups

# Autosuggestions via history search
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# ── Navigation shortcuts ──────────────────────────────
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# ── Better file listing ───────────────────────────────
alias ls='eza --icons'
alias ll='eza -alF --icons'
alias la='eza -a --icons'
alias lt='eza --tree --icons'

# ── Better cat ───────────────────────────────────────
alias cat='bat'

# ── Quick config editing ──────────────────────────────
alias zshconfig='code-oss ~/.zshrc'
alias fishconfig='code-oss ~/.config/fish/config.fish'
alias bashconfig='code-oss ~/.bashrc'
alias reload='source ~/.bashrc'

# ── System info ───────────────────────────────────────
alias topmem='ps aux --sort=-%mem | head'
alias topcpu='ps aux --sort=-%cpu | head'
alias myip='curl ifconfig.me'
alias weather='curl wttr.in'

# ── Pacman shortcuts ──────────────────────────────────
alias install='sudo pacman -S'
alias search='pacman -Ss'
alias remove='sudo pacman -Rsn'
alias update='sudo pacman -Syu'
alias c='clear'

# ── Tree alias ────────────────────────────────────────
alias tree='tree --dirsfirst -C'

# ── Search history ────────────────────────────────────
alias histg='history | grep'

# ── Git shortcuts ─────────────────────────────────────
function g  { git "$@"; }
function gs { git status "$@"; }
function gcm { git commit "$@"; }
function gph { git push "$@"; }
function gpl { git pull "$@"; }

# ── Go up multiple directories ────────────────────────
function up { cd $(printf '../%.0s' $(seq 1 $1)); }

# ── Mkdir and cd ─────────────────────────────────────
mkcd() { mkdir -p "$1" && cd "$1"; }

# ── Find where a command is located ──────────────────
function whereis { which $1; }

# ── FZF ──────────────────────────────────────────────
source /usr/share/fzf/key-bindings.bash
source /usr/share/fzf/completion.bash
EOF
echo -e "${GREEN}✔ Bash configured${NC}"

# ── Done ──────────────────────────────────────────────────
echo -e "\n${GREEN}========================================${NC}"
echo -e "${GREEN}   Setup Complete!                       ${NC}"
echo -e "${GREEN}========================================${NC}"
echo -e "\nRestart your terminal or run:"
echo -e "  ${YELLOW}source ~/.config/fish/config.fish${NC} for Fish"
echo -e "  ${YELLOW}source ~/.zshrc${NC} for Zsh"
echo -e "  ${YELLOW}source ~/.bashrc${NC} for Bash"
