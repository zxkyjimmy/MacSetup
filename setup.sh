#!/bin/bash
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
if [[ $(uname -p) == 'arm' ]]; then
  step "Set Apple Silicon HomeBrew Path"
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ${HOME}/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

step "Install utils"
brew install htop tree openssh cmake julia
brew install --cask the-unarchiver oracle-jdk mos
brew install --cask topnotch # hide the notch

step "Set ssh"
[ -d ~/.ssh ] || mkdir ~/.ssh
ssh-keygen -b 4096 -t rsa -f ~/.ssh/id_rsa -q -N "" <<< y
echo "" # newline

step "Font"
brew tap homebrew/cask-fonts
brew install font-sauce-code-pro-nerd-font
brew install font-caskaydia-cove-nerd-font

step "Modify Terminal Font"
plutil -replace Window\ Settings.Basic.Font -data \
YnBsaXN0MDDUAQIDBAUGBwpYJHZlcnNpb25ZJGFyY2hpdmVyVCR0b3BYJG9iamVjdHMSAAGGoF8QD05T\
S2V5ZWRBcmNoaXZlctEICVRyb290gAGkCwwVFlUkbnVsbNQNDg8QERITFFZOU1NpemVYTlNmRmxhZ3NW\
TlNOYW1lViRjbGFzcyNALAAAAAAAABAQgAKAA18QHkNhc2theWRpYUNvdmVOZXJkRm9udENvbXBsZXRl\
LdIXGBkaWiRjbGFzc25hbWVYJGNsYXNzZXNWTlNGb250ohkbWE5TT2JqZWN0CBEaJCkyN0lMUVNYXmdu\
d36FjpCSlLW6xc7V2AAAAAAAAAEBAAAAAAAAABwAAAAAAAAAAAAAAAAAAADh \
${HOME}/Library/Preferences/com.apple.Terminal.plist

step "Get oh-my-zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended
git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
cp .p10k.zsh .zshrc ${HOME}/

step "Get HyperTerminal"
brew install --cask hyper
cp .hyper.js ${HOME}/

step "Get python & yapf"
PYTHON="python@3.11"
brew install ${PYTHON}
echo "export PATH=\$(brew --prefix)/opt/"${PYTHON}"/bin:\$PATH" >> ~/.zshrc
echo "export PATH=\$(brew --prefix)/opt/"${PYTHON}"/libexec/bin:\$PATH" >> ~/.zshrc
export PATH=$(brew --prefix)/opt/$PYTHON/bin:$PATH
export PATH=$(brew --prefix)/opt/$PYTHON/libexec/bin:$PATH
pip install yapf
[ -d ${HOME}/.config/yapf ] || mkdir -p ${HOME}/.config/yapf
cat <<EOF | tee ${HOME}/.config/yapf/style
[style]
based_on_style = yapf
EOF

step "Miniconda 3"
brew install --cask miniconda
conda init "$(basename "${SHELL}")"
conda config --set auto_activate_base false
