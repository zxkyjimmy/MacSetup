#!/usr/bin/bash
set -euo pipefail

function step(){
  echo "$(tput setaf 10)$1$(tput sgr0)"
}

step "Configure git"
git config --global user.name "Yen-Chi Chen"
git config --global user.email "zxkyjimmy@gmail.com"
git config --global pull.rebase false

step "Get HomeBrew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

step "Install utils"
brew install python htop tree podman openssh
brew install --cask the-unarchiver oracle-jdk mos julia
ssh-keygen -b 4096

step "Miniconda 3"
brew install --cask miniconda
conda init "$(basename "${SHELL}")"
conda config --set auto_activate_base false

step "Font"
brew tap homebrew/cask-fonts
brew install font-sauce-code-pro-nerd-font
brew install font-caskaydia-cove-nerd-font

step "Get oh-my-zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended
git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

step "Copy environment"
cp .p10k.zsh .zshrc .hyper.js ${HOME}/
