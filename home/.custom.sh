# globals 
export PATH="$HOME/.local/bin:$PATH"
if [ -d "$HOME/.local/bin/nvim-linux-x86_64/bin" ]; then
  export PATH="$HOME/.local/bin/nvim-linux-x86_64/bin:$PATH"
fi
export ANTHROPIC_AUTH_TOKEN=ollama
export ANTHROPIC_API_KEY=""
export ANTHROPIC_BASE_URL=http://stark02:11434

# alia
alias change="nvim ~/.zshrc"
alias update="source ~/.zshrc"
alias lspconfig="nvim ~/.config/nvim/lua/configs/lspconfig.lua"
alias lg="lazygit"
alias ff="fastfetch"
if command -v batcat >/dev/null 2>&1; then
  alias bat="batcat"
fi

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
if [ -f "$HOME/.zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh" ]; then
  source "$HOME/.zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
fi

# custom functions
function gpp {
  git add $1
  git commit -m $2
  git push origin $(git symbolic-ref --short HEAD)
}


function gpfl {
  git add --all
  git commit --amend --no-edit
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

function condainit {
  local conda_bin
  conda_bin="${CONDA_EXE:-$(command -v conda 2>/dev/null || true)}"
  if [ -z "$conda_bin" ]; then
    return 0
  fi
  __conda_setup="$("$conda_bin" shell.zsh hook 2> /dev/null)"
  if [ $? -eq 0 ]; then
      eval "$__conda_setup"
  fi
  unset __conda_setup
  # <<< conda initialize <<<
}

function y {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# prompt
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi
