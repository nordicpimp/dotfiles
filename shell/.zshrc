# =============================================================================
# ENVIRONMENT
# =============================================================================

# Editor — used by git, CLI tools, and anything that needs $EDITOR
export EDITOR=nvim
export VISUAL=nvim

# Qt platform theme
export QT_QPA_PLATFORMTHEME=qt6ct

# Scripts directory on PATH
export PATH="$HOME/dotfiles/shell/scripts:$PATH"

# =============================================================================
# ZSH OPTIONS
# =============================================================================

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt SHARE_HISTORY
setopt HIST_REDUCE_BLANKS

# Navigation
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS

# =============================================================================
# COMPLETIONS
# =============================================================================

autoload -Uz compinit
compinit

# =============================================================================
# FZF
# =============================================================================
# Ctrl+R  — fuzzy search shell history
# Ctrl+T  — fuzzy find file and insert path
# Alt+C   — fuzzy find directory and cd into it

[[ -f /usr/share/fzf/key-bindings.zsh ]] && source /usr/share/fzf/key-bindings.zsh
[[ -f /usr/share/fzf/completion.zsh ]]   && source /usr/share/fzf/completion.zsh

# =============================================================================
# ALIASES
# =============================================================================

[[ -f ~/.zsh_aliases ]] && source ~/.zsh_aliases
