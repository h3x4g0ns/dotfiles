#!/usr/bin/env bash
set -Eeuo pipefail

DOTFILES_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
OS="$(uname -s)"
export PATH="$HOME/.local/bin:$PATH"

install_brew_packages() {
  local packages=(zsh git curl fzf tmux wget tree htop ripgrep ncdu speedtest-cli make cmake node npm fastfetch bat yq neovim starship go lazygit zoxide btop)
  local missing=()
  local package
  for package in "${packages[@]}"; do
    brew list --formula "$package" >/dev/null 2>&1 || missing+=("$package")
  done
  if ((${#missing[@]})); then
    brew install "${missing[@]}"
  fi
}

install_apt_packages() {
  local packages=(zsh git curl nvtop bpytop tmux wget tree htop ripgrep ncdu speedtest-cli make cmake nodejs npm fastfetch bat yq neovim alacritty unzip fontconfig)
  if ! command -v fastfetch >/dev/null 2>&1; then
    sudo add-apt-repository -y ppa:zhangsongcui3371/fastfetch
  fi
  sudo apt-get update
  sudo apt-get install -y "${packages[@]}"
}

install_jetbrains_mono_macos() {
  if brew list --cask font-jetbrains-mono-nerd-font >/dev/null 2>&1; then
    return
  fi
  brew install --cask font-jetbrains-mono-nerd-font
}

install_jetbrains_mono_linux() {
  local font_dir version archive
  font_dir="$HOME/.local/share/fonts/JetBrainsMonoNerdFont"
  if find "$font_dir" -type f \( -name '*.ttf' -o -name '*.otf' \) -print -quit 2>/dev/null | grep -q .; then
    return
  fi
  version="$(curl -fsSL https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest | sed -n 's/.*"tag_name": "v\([^"]*\)".*/\1/p' | head -n 1)"
  archive="$HOME/.local/src/JetBrainsMono.zip"
  mkdir -p "$font_dir"
  curl -fL -o "$archive" "https://github.com/ryanoasis/nerd-fonts/releases/download/v${version}/JetBrainsMono.zip"
  unzip -oq "$archive" -d "$font_dir"
  fc-cache -f "$font_dir"
}

install_alacritty_macos() {
  if command -v alacritty >/dev/null 2>&1 || [ -d "/Applications/Alacritty.app" ]; then
    return
  fi

  if brew install --cask alacritty; then
    return
  fi

  local version dmg_file mountpoint app_dir
  version="$(curl -fsSL https://api.github.com/repos/alacritty/alacritty/releases/latest | sed -n 's/.*"tag_name": "v\([^"]*\)".*/\1/p' | head -n 1)"
  dmg_file="$HOME/.local/src/Alacritty-v${version}.dmg"
  mountpoint="$(mktemp -d -t alacritty-install)"
  app_dir="$HOME/Applications"

  echo "Homebrew's Alacritty cask is unavailable; installing the official release instead."
  curl -fL -o "$dmg_file" "https://github.com/alacritty/alacritty/releases/download/v${version}/Alacritty-v${version}.dmg"
  if hdiutil attach "$dmg_file" -nobrowse -readonly -mountpoint "$mountpoint"; then
    mkdir -p "$app_dir"
    ditto "$mountpoint/Alacritty.app" "$app_dir/Alacritty.app"
    hdiutil detach "$mountpoint" >/dev/null
    ln -sfn "$app_dir/Alacritty.app/Contents/MacOS/alacritty" "$HOME/.local/bin/alacritty"
  else
    rmdir "$mountpoint"
    echo "Warning: could not mount the Alacritty release DMG." >&2
  fi
}

install_lazygit_linux() {
  if command -v lazygit >/dev/null 2>&1; then
    return
  fi

  local version arch archive
  version="$(curl -fsSL https://api.github.com/repos/jesseduffield/lazygit/releases/latest | sed -n 's/.*"tag_name": "v\([^"]*\)".*/\1/p' | head -n 1)"
  case "$(uname -m)" in
    x86_64) arch="x86_64" ;;
    aarch64|arm64) arch="arm64" ;;
    *) echo "Unsupported Linux architecture for lazygit: $(uname -m)" >&2; return 1 ;;
  esac
  archive="$HOME/.local/src/lazygit.tar.gz"
  curl -fL -o "$archive" "https://github.com/jesseduffield/lazygit/releases/download/v${version}/lazygit_${version}_Linux_${arch}.tar.gz"
  tar -xzf "$archive" -C "$HOME/.local/bin" lazygit
}

case "$OS" in
  Darwin)
    if ! command -v brew >/dev/null 2>&1; then
      echo "Homebrew is required on macOS: https://brew.sh" >&2
      exit 1
    fi
    install_brew_packages
    install_alacritty_macos
    install_jetbrains_mono_macos
    ;;
  Linux)
    if ! command -v apt-get >/dev/null 2>&1; then
      echo "This Linux installer requires apt-get (Ubuntu/Debian)." >&2
      exit 1
    fi
    install_apt_packages
    install_jetbrains_mono_linux
    ;;
  *)
    echo "Unsupported operating system: $OS" >&2
    exit 1
    ;;
esac

mkdir -p "$HOME/.local/bin" "$HOME/.local/src" "$HOME/.zsh"

ZSH_SYNTAX_DIR="$HOME/.zsh/fast-syntax-highlighting"
if [ ! -f "$ZSH_SYNTAX_DIR/fast-syntax-highlighting.plugin.zsh" ]; then
  if [ -d "$ZSH_SYNTAX_DIR/.git" ]; then
    git -C "$ZSH_SYNTAX_DIR" pull --ff-only
  else
    git clone https://github.com/zdharma-continuum/fast-syntax-highlighting "$ZSH_SYNTAX_DIR"
  fi
fi

if ! command -v starship >/dev/null 2>&1; then
  curl -sS https://starship.rs/install.sh | sh -s -- -y
fi
if ! command -v zoxide >/dev/null 2>&1; then
  curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
fi

if [ "$OS" = Darwin ]; then
  if ! command -v docker >/dev/null 2>&1; then
    brew install --cask docker
    echo "Docker Desktop was installed. Launch it once to start the Docker daemon."
  fi
else
  install_lazygit_linux
  if ! command -v docker >/dev/null 2>&1; then
    sudo apt-get install -y ca-certificates
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    . /etc/os-release
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu ${UBUNTU_CODENAME:-$VERSION_CODENAME} stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  fi
  if getent group docker >/dev/null 2>&1; then
    sudo usermod -aG docker "$USER"
  else
    sudo groupadd docker
    sudo usermod -aG docker "$USER"
  fi
fi

mkdir -p "$HOME/.config/bpytop/themes"
ln -sfn "$DOTFILES_DIR/home/.custom.sh" "$HOME/.custom.sh"
ln -sfn "$DOTFILES_DIR/home/.history.sh" "$HOME/.history.sh"
ln -sfn "$DOTFILES_DIR/home/.alacritty.toml" "$HOME/.alacritty.toml"
ln -sfn "$DOTFILES_DIR/home/.tmux.conf" "$HOME/.tmux.conf"
ln -sfn "$DOTFILES_DIR/home/all_red.theme" "$HOME/.config/bpytop/themes/all_red.theme"

echo "Installed dotfiles from $DOTFILES_DIR for $OS."
echo "Add these lines to ~/.zshrc if they are not already present:"
echo '  source ~/.custom.sh'
echo '  source ~/.history.sh'
