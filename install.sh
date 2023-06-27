#!/bin/bash

# Check if macOS
if [[ $(uname) == "Darwin" ]]; then
    # Install Homebrew if not already installed
    if ! command -v brew >/dev/null 2>&1; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        echo "Homebrew is already installed."
    fi

# Check if Ubuntu
elif [[ $(lsb_release -si) == "Ubuntu" ]]; then
    # Update and upgrade system packages
    echo "Updating and upgrading system packages..."
    sudo apt update
    sudo apt upgrade -y
else
    echo "Unsupported operating system. Only macOS and Ubuntu are supported."
    exit 1
fi

# Install bpytop if not already installed
if ! command -v bpytop >/dev/null 2>&1; then
    echo "Installing bpytop..."
    if [[ $(uname) == "Darwin" ]]; then
        brew install bpytop
    else
        sudo apt install -y bpytop
    fi
else
    echo "bpytop is already installed."
fi

# Install Miniconda if not already installed
if ! command -v conda >/dev/null 2>&1; then
    echo "Installing Miniconda..."
    wget -qO miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
    bash miniconda.sh -b -p $HOME/miniconda
    rm miniconda.sh
else
    echo "Miniconda is already installed."
fi

# Install Neovim if not already installed
if ! command -v nvim >/dev/null 2>&1; then
    echo "Installing Neovim..."
    if [[ $(uname) == "Darwin" ]]; then
        brew install neovim
    else
        sudo apt install -y neovim
    fi
else
    echo "Neovim is already installed."
fi

# Install Docker if not already installed
if ! command -v docker >/dev/null 2>&1; then
    echo "Installing Docker..."
    if [[ $(uname) == "Darwin" ]]; then
        brew install docker
    else
        sudo apt install -y docker.io
    fi
else
    echo "Docker is already installed."
fi

# Install Git autocomplete if not already installed
if [[ ! -f ~/.git-completion.bash ]]; then
    echo "Installing Git autocomplete..."
    curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash
else
    echo "Git autocomplete is already installed."
fi
