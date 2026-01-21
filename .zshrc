# エイリアス
alias ll='ls -laFh'
alias vi='nvim'
alias vim='nvim'
alias view='nvim -R'

# zsh オプション
setopt no_beep
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
setopt hist_ignore_dups
setopt share_history
setopt inc_append_history

export HISTFILE=~/.zsh_history
export HISTSIZE=500
export SAVEHIST=500

# starship
export STARSHIP_CONFIG=~/.config/starship/starship.toml
eval "$(starship init zsh)"


# Added by Antigravity
export PATH="${HOME}/.antigravity/antigravity/bin:$PATH"
