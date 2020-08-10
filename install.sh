#!/bin/bash
set -euo pipefail

thisdir=$(dirname $(readlink -m $0))
thisscript=$(basename $0)
pushd $thisdir >/dev/null

NOCOLOR='\033[0m'
LIGHTGREEN='\033[1;32m'

function log_success_message {
    echo -e "${LIGHTGREEN}[SUCCESS]${NOCOLOR}" $1
}

if [ -f /lib/lib/init-functions ]; then
    source /lib/lib/init-functions
fi

#link all directories to ~ except the ones mentionned
for item in $(find ./ -mindepth 1 -maxdepth 1); do
    if echo "./$thisscript ./.git ./.gitignore ./.gitmodules" | grep -w $item > /dev/null; then
        true
    else
        target="$HOME/$(basename $item)"
        rm -rf "$target"
        ln -s "$(readlink -m $item)" "$target"
	log_success_message "created symlink $target"
    fi
done


#re-run the new bashrc
set +eu
source $HOME/.bashrc
set -eu
log_success_message "re-run ~/.bashrc"
popd >/dev/null

#install vundle so vim can install the other plugins using :PluginInstall
pushd ~/.vim/bundle >/dev/null
git submodule init
git submodule update Vundle.vim
popd >/dev/null
log_success_message "Vundle installed, do :PluginInstall in vim to end installation"

#add some useful directories
mkdir -p ~/.local/bin
log_success_message "created ~/.local/bin"

#some git config
git config --global user.email "julien.rialland@gmail.com"
git config --global user.name "jrialland"
git config --global credential.helper store
log_success_message "added some configuration for git"

#install nvm
wget -qO- https://raw.gitusercontent.com/creationix/nvm/v0.34.0/install.sh | bash
log_success_message "installed nvm"

#install latest lts version of node
NODEVERSION='lts/'$(nvm ls-remote | grep "Latest LTS" | cut -d':' -f2 | sed -s s/\)//|tail -1|awk '{print $1}')
nvm install $NODEVERSION
log_success_message "installed node $NODEVERSION using nvm"
nvm use $NODEVERSION

npm update npm -g
log_success_message "updated npm to latest version"


