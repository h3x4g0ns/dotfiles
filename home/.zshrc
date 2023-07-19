# environment variables
export PYTHON_UTILS="$HOME/Documents/projects/code/scripts"
export PATH="$PYTHON_UTILS:$PATH"
export STARSHIP_CONFIG=~/starship.toml

# aliases
alias vim="nvim"
alias change="vim ~/.zshrc"
alias update="source ~/.zshrc"
alias ic='cd ~/Library/Mobile\ Documents/com~apple~CloudDocs'
alias cs="cd ~/Documents/code"
alias backup="sudo rsync -a /Volumes/utility/ /Volumes/beta"
alias lspconfig="nvim ~/.config/nvim/lua/custom/configs/lspconfig.lua"

# git
alias gs="git status"
alias gd="git diff"
alias gc="git commit -m"
alias gp="git push"
alias gpl="git pull"
alias ga="git add --all"

function gpp {
 git add $1 
 git commit -m $2
 git push origin $(git rev-parse --abbrev-ref HEAD)
}

# set zsh syntax + autosuggestions
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# custom functions
source ~/.custom.sh

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/hexagon/miniforge3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/hexagon/miniforge3/etc/profile.d/conda.sh" ]; then
        . "/Users/hexagon/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/hexagon/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# gdb setup
echo "set startup-with-shell off" >> ~/.gdbinit

# homebrew setup
eval "$(/opt/homebrew/bin/brew shellenv)"

# starship prompt
eval "$(starship init zsh)"

