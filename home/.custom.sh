# alias
export PATH="$PATH:$HOME/.local/bin"
alias change="nvim ~/.zshrc"
alias update="source ~/.zshrc"
alias lspconfig="nvim ~/.config/nvim/lua/configs/lspconfig.lua"
alias lg="lazygit"
alias ff="fastfetch"

# git
alias gs="git status"
alias gl="git log"
alias gd="git diff"
alias gc="git commit -m"
alias gp="git push"
alias gf="git fetch"
alias gpl="git pull"
alias ga="git add"
alias gaa="git add --all"
alias gst="git stash"
alias gsw="git switch"
alias gcb="git checkout -b"

# scripts 
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# custom functions
function gpp {
  git add --all
  git commit -m $1
  git push origin $(git symbolic-ref --short HEAD)
}

function gac {
  git add $1
  git commit -m $2
}

function switch {
  git stash
  git switch master
  git pull origin master
  git branch $1
  git switch $1
}

# prompt
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
