# エイリアス
alias ll='ls -laFh'
alias vi='nvim'
alias vim='nvim'
alias view='nvim -R'

# zsh オプション
setopt auto_cd
setopt auto_pushd
setopt correct
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt inc_append_history
setopt interactive_comments
setopt no_beep
setopt pushd_ignore_dups
setopt share_history

export HISTFILE=~/.zsh_history
export HISTSIZE=500
export SAVEHIST=500

# starship
export STARSHIP_CONFIG=~/.config/starship/starship.toml
eval "$(starship init zsh)"

# sheldon
eval "$(sheldon source)"

alias google='web_search google'

# Added by Antigravity
export PATH="${HOME}/.antigravity/antigravity/bin:$PATH"
