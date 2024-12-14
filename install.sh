#!/bin/bash -e

SYSNAME=$(uname -s)
PACKAGES="bpytop tmux wget tree htop ripgrep ncdu speedtest-cli make cmake tmux nodejs npm"

sudo apt-get update && sudo apt-get upgrade
sudo apt-get install -y $PACKAGES
sudo apt-get install -y nvtop zsh
chsh -s $(which zsh)

# neovim from source
if command -v nvim &>/dev/null; then
  echo "Neovim is installed."
else
  echo "Neovim is not installed"
  mkdir -p ~/Code && cd ~/Code
  git clone https://github.com/neovim/neovim.git
  cd neovim
  make CMAKE_BUILD_TYPE=RelWithDebInfo
  sudo make install
  git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1 && nvim
fi

# starship prompt
if command -v starship &>/dev/null; then
  echo "starship is installed."
else
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
if command -v fzf &>/dev/null; then
  echo "fzf is installed."
else
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install
fi

# lazygit
if command -v lazygit &>/dev/null; then
  echo "lazygit is installed."
else
  cd ~/Code
  git clone https://github.com/jesseduffield/lazygit.git
  cd lazygit
  go install
fi

# zoxide
if command -v z &>/dev/null; then
  echo "zoxide is installed."
else
  curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
fi

# symlinks
cd -
ln -s $(pwd)/dotfiles/home/.custom.sh $(pwd)/.custom.sh
ln -s $(pwd)/dotfiles/home/.history.sh $(pwd)/.history.sh
ln -s $(pwd)/dotfiles/home/.alacritty.toml $(pwd)/.alacritty.toml

# user binaries
mkdir ~/.local/bin
