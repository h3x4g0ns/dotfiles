#!/bin/bash

sysname=$(uname -s)
packages="bpytop tmux neovim alacritty nvtop wget stow tree starship neofetch htop"

if [[ "$sysname" == "Darwin" ]]; then
  if command -v brew >/dev/null 2>&1; then
  else
    echo "Homebrew is not installed."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  # installing brew packages
  brew install $packages
else
  # installing ubuntu packages
  sudo apt-get update && sudo apt-get upgrade
  sudo apt-get install $packages
fi

# platform agnostic
curl -sS https://starship.rs/install.sh | sh
git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1 && nvim

# stowing config files
stow -d . -t ~ home
