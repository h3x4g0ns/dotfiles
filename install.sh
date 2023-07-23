#!/bin/bash
sysname=$(uname -s)
packages="bpytop tmux alacritty wget tree neofetch htop ripgrep ncdu speedtest-cli make cmake tmux"

if [[ "$sysname" == "Darwin" ]]; then
  if command -v brew &>/dev/null; then
    echo "Homebrew is installed."
  else
    echo "Homebrew is not installed."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  # installing brew packages
  brew install $packages

  # custom commands
  echo "source ~/.custom.sh" >> ~/.zshrc
else
  # installing ubuntu packages
  sudo apt-get update && sudo apt-get upgrade
  sudo apt-get install -y $packages
  sudo apt-get install -y nvtop

  # custom commands
  echo "source ~/.custom.sh" >> ~/.bashrc
fi

# installing neovim from source
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

# installing starship prompt
curl -sS https://starship.rs/install.sh | sh

# applying custom config files
mv ~/dotfiles/home/* ~/.
