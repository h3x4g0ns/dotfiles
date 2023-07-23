# environment variables
export PYTHON_UTILS="$PYTHONUTILS:"
export PATH="$PYTHON_UTILS:$PATH"
export STARSHIP_CONFIG=~/starship.toml
export PATH="/opt/homebrew/opt/cython/bin:$PATH"
 
# alias
alias vim="nvim"
alias change="nvim ~/.custom.sh"
alias update="source ~/.zshrc"
alias ic='cd ~/Library/Mobile\ Documents/com~apple~CloudDocs'
alias cs="cd ~/Documents/code"
alias lspconfig="nvim ~/.config/nvim/lua/custom/configs/lspconfig.lua"

# git
alias gs="git status"
alias gd="git diff"
alias gc="git commit -m"
alias gp="git push"
alias gpl="git pull"
alias ga="git add"
alias gaa="git add --all"

# custom functions
function gpp {
 git add $1 
 git commit -m $2
 git push origin $(git symbolic-ref --short HEAD)
}

# prompt
eval "$(starship init zsh)"