#!/bin/bash
set -e

thisdir=$(dirname $(readlink -m $0))
thisscript=$(basename $0)
pushd $thisdir >/dev/null

#link all directories to ~ except the ones mentionned
for item in $(find ./ -mindepth 1 -maxdepth 1); do
    if echo "./$thisscript ./.git ./.gitignore ./.gitmodules" | grep -w $item > /dev/null; then
        true
    else
        target="$HOME/$(basename $item)"
        rm -rf "$target"
        ln -s "$(readlink -m $item)" "$target"
    fi
done

#re-run the new bashrc
. $HOME/.bashrc

popd >/dev/null

#install vundle so vim can install the other plugins using :PluginInstall
pushd ~/.vim/bundle >/dev/null
git submodule init
git submodule update Vundle.vim
popd >/dev/null

#add some useful directories
mkdir -p ~/.local/bin

