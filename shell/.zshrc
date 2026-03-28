# =============================================================================
# ENVIRONMENT
# =============================================================================

export EDITOR=nvim
export VISUAL=nvim
export QT_QPA_PLATFORMTHEME=qt6ct
export PATH="$HOME/dotfiles/shell/scripts:$PATH"

# =============================================================================
# OH MY ZSH
# =============================================================================

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"  # or powerlevel10k/powerlevel10k

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  archlinux
)

source $ZSH/oh-my-zsh.sh

# =============================================================================
# ZSH OPTIONS
# =============================================================================
# Note: OMZ sets sane history defaults — these override/extend them

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt SHARE_HISTORY
setopt HIST_REDUCE_BLANKS

setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS

# =============================================================================
# FZF
# =============================================================================

[[ -f /usr/share/fzf/key-bindings.zsh ]] && source /usr/share/fzf/key-bindings.zsh
[[ -f /usr/share/fzf/completion.zsh ]]   && source /usr/share/fzf/completion.zsh

# =============================================================================
# ALIASES
# =============================================================================

[[ -f ~/.zsh_aliases ]] && source ~/.zsh_aliases
