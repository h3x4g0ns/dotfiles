# env vars
export PYTHON_UTILS="$PYTHONUTILS:"
export PATH="$PYTHON_UTILS:$PATH"
export PATH="/opt/homebrew/opt/cython/bin:$PATH"
 
# alias
alias vim="nvim"
alias change="cd ~/dotfiles && nvim"
alias update="source ~/.zshrc"
alias ic='cd ~/Library/Mobile\ Documents/com~apple~CloudDocs'
alias cs="cd ~/Documents/code"
alias lspconfig="nvim ~/.config/nvim/lua/custom/configs/lspconfig.lua"
alias config="cd ~/dotfiles && sh install.sh"

# git
alias gs="git status"
alias gd="git diff"
alias gc="git commit -m"
alias gp="git push"
alias gpl="git pull"
alias ga="git add"
alias gaa="git add --all"

# prompt
eval "$(starship init zsh)"

# scripts
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# custom functions
function gpp {
  git add $1 
  git commit -m $2
  git push origin $(git symbolic-ref --short HEAD)
}

function switch {
  git stash
  git switch master
  git pull origin master
  git branch $1
  git swtich $1
}

