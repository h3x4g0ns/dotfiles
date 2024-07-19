#!/bin/bash
sysname=$(uname -s)
packages="bpytop tmux wget tree htop ripgrep ncdu speedtest-cli make cmake tmux nodejs npm"
customsh="~/.custom.sh"
zshrcfile="~/.zshrc"

if [[ "$sysname" == "Darwin" ]]; then
  if command -v brew &>/dev/null; then
    echo "Homebrew is installed."
  else
    echo "Homebrew is not installed."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  # brew packages
  brew install $packages

else
  # ubuntu packages
  sudo apt-get update && sudo apt-get upgrade
  sudo apt-get install -y $packages
  sudo apt-get install -y nvtop zsh
  chsh -s $(which zsh)
fi

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
curl -sS https://starship.rs/install.sh | sh

# zsh syntax highlighting
rm -rf ~/.zsh/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting

# fuzzy finder
if command -v fzf &>/dev/null; then
  echo "Fzf is installed."
else
  echo "Fzf is not installed."
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install

# lazygit
git clone https://github.com/jesseduffield/lazygit.git
cd lazygit
go install
cd ~

# custom config files
yes | cp -rf ~/dotfiles/home/ ~/
mkdir -p ~/.config
yes | cp -rf ~/dotfiles/config/ ~/.config/
