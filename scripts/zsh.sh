#!/bin/bash

# Change default shell to zsh
sed -i 's/\/bin\/ash/\/usr\/bin\/zsh/g' package/base-files/files/etc/passwd

## preset-terminal-tools

mkdir -p files/root
pushd files/root

# Install oh-my-zsh
git clone https://github.com/ohmyzsh/ohmyzsh ./.oh-my-zsh

# Install extra plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ./.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ./.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-completions ./.oh-my-zsh/custom/plugins/zsh-completions

# Get .zshrc dotfile
cp $GITHUB_WORKSPACE/patches/.zshrc .

popd
