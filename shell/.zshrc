# Qt platform theme
export QT_QPA_PLATFORMTHEME=qt6ct
export QT_STYLE_OVERRIDE=kvantum

# Wayland session type
export XDG_SESSION_TYPE=wayland
export XDG_CURRENT_DESKTOP=Hyprland

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt SHARE_HISTORY

# Aliases
[[ -f ~/.zsh_aliases ]] && source ~/.zsh_aliases
