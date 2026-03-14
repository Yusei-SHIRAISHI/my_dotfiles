#! /bin/bash

#
# install dotfiles
#

set -e

execdatetime=$(date +%Y-%m-%d-%H:%M:%S)
currentDir=$(cd "$(dirname "$0")"; pwd)
backupDir="$HOME/.dotfiles.backup"
[ -d "$backupDir" ] || mkdir -p "$backupDir"

makeLinksToHomeDir(){
  for x in "$@"; do
    if [ -e "$HOME/$x" ] || [ -L "$HOME/$x" ]; then
      cp -af "$HOME/$x" "$backupDir/$x.$execdatetime.backup"
    fi
    ln -sfn "$currentDir/$x" "$HOME/$x"
  done
}

installList=(".bashrc" ".vimrc" ".tmux.conf" ".zshrc" ".gitconfig")
makeLinksToHomeDir "${installList[@]}"

mkdir -p "$HOME/.config/nvim/lua"
ln -sfn "$currentDir/init.lua" "$HOME/.config/nvim/init.lua"
ln -sfn "$currentDir/prompts" "$HOME/.config/nvim/lua/prompts"

if [ -e "$HOME/.codex" ] && [ ! -L "$HOME/.codex" ]; then
  mv "$HOME/.codex" "$backupDir/.codex.$execdatetime.backup"
fi
ln -sfn "$currentDir/.codex" "$HOME/.codex"

exit 0
