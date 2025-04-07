#! /bin/bash

#
# install dotfiles
#

execdatetime=$(date +%Y-%m-%d-%H:%M:%S)
currentDir=$(cd $(dirname $0); pwd)
buckupDir=$HOME/.dotfiles.buckup
[ -d ${backupDir} ] || mkdir -p ${backupDir};

makeLinksToHomeDir(){
  for x in `echo "$*"`; do
        if [ -e ${HOME}/${x} ];then
            cp -af  ${HOME}/${x} ${backupDir}/${x}.${execdatetime}.backup;
        fi
        ln -sfn ${currentDir}/${x} $HOME/${x}
  done;
}

installList=('.bashrc' '.vimrc' '.tmux.conf' '.zshrc' '.gitconfig')
makeLinksToHomeDir ${installList[@]}

[ -d `${HOME}/.config/nvim/lua` ] || mkdir -p `${HOME}/.config/nvim/lua`;

ln -sfn ${currentDir}/init.lua $HOME/.config/nvim/init.lua
ln -sfn ${currentDir}/prompts $HOME/.config/nvim/lua/prompts

exit 0;
