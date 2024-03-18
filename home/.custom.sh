# env vars
export PYTHON_UTILS="$PYTHONUTILS:"
export PATH="$PYTHON_UTILS:$PATH"
export PATH="/opt/homebrew/opt/cython/bin:$PATH"
export PICO_SDK_PATH="$HOME/Documents/Code/pico-sdk"
 
# alias
alias vim="nvim"
alias change="cd ~/dotfiles && nvim"
alias update="source ~/.zshrc"
alias ic='cd ~/Library/Mobile\ Documents/com~apple~CloudDocs'
alias cs="cd ~/Documents/code"
alias lspconfig="nvim ~/.config/nvim/lua/custom/configs/lspconfig.lua"
alias config="cd ~/dotfiles && sh install.sh"
alias journal="cd '/Users/hexagon/Library/Mobile Documents/iCloud~md~obsidian/Documents/hexagon/journal' && nvim"

# git
alias gs="git status"
alias gl="git log"
alias gd="git diff"
alias gc="git commit -m"
alias gp="git push"
alias gpl="git pull"
alias ga="git add"
alias gaa="git add --all"
alias gst="git stash"
alias gsw="git switch"

# scripts 
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# custom functions
function gpp {
  git add $1 
  git commit -m $2
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
  git swtich $1
}

# prompt
eval "$(starship init zsh)"
eval "$(direnv hook zsh)"
eval "$(fzf --zsh)"
