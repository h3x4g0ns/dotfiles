#!/bin/bash -e

SYSNAME=$(uname -s)
PACKAGES="zsh git curl nvtop bpytop tmux wget tree htop ripgrep ncdu speedtest-cli make cmake tmux nodejs npm fastfetch bat yq"

sudo add-apt-repository ppa:zhangsongcui3371/fastfetch
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y $PACKAGES

# user binaries
mkdir -p ~/.local/bin
mkdir -p ~/.local/src

# neovim from source
if command -v nvimbo >/dev/null 2>&1; then
  echo "Neovim is installed."
else
  cd ~/.local/src
  curl -LO https://github.com/neovim/neovim/releases/download/v0.11.2/nvim-linux-x86_64.tar.gz
  sudo rm -rf ~/.local/bin/nvim
  sudo tar -C ~/.local/bin -xzf nvim-linux-x86_64.tar.gz
  sudo chown -R $USER ~/.local/bin
fi

# starship prompt
if command -v starship >/dev/null 2>&1; then
  echo "starship is installed."
else
  cd -
  curl -sS https://starship.rs/install.sh | sh
fi

# zsh syntax highlighting
ZSH_SYNTAX_FILE=~/.zsh/zsh-syntax-highlighting
if [ -f "$ZSH_SYNTAX_FILE" ]; then
  echo "zsh syntax is installed"
else
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_SYNTAX_FILE 
fi

# fuzzy finder
if command -v fzf >/dev/null 2>&1; then
  echo "fzf is installed."
else
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install
fi

# go
if command -v go >/dev/null 2>&1; then
  echo "go is installed"
else
  wget -q -O - https://git.io/vQhTU | bash
fi

# lazygit
LG=~/.local/src/lazygit
if command -v lazygit >/dev/null 2>&1; then
  echo "lazygit is installed."
else
  LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
  curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
  tar xf lazygit.tar.gz lazygit
  sudo install lazygit -D -t /usr/local/bin/
fi

# zoxide
if command -v z >/dev/null 2>&1; then
  echo "zoxide is installed."
else
  cd -
  curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
fi

# symlinks
cd ~
ln -s $(pwd)/dotfiles/home/.custom.sh $(pwd)/.custom.sh
ln -s $(pwd)/dotfiles/home/.history.sh $(pwd)/.history.sh
ln -s $(pwd)/dotfiles/home/.alacritty.toml $(pwd)/.alacritty.toml
ln -s $(pwd)/dotfiles/home/.tmux.conf $(pwd)/.tmux.conf

