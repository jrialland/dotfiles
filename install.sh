#!/bin/bash
set -e

thisdir=$(dirname $(readlink -m $0))
thisscript=$(basename $0)
pushd $thisdir >/dev/null

for item in $(find ./ -mindepth 1 -maxdepth 1); do
    if echo "./$thisscript ./.git ./.gitignore ./.gitmodules" | grep -w $item > /dev/null; then
        true
    else
        target="$HOME/$(basename $item)"
        rm -rf "$target"
        ln -s "$(readlink -m $item)" "$target"
    fi
done
. $HOME/.bashrc

popd >/dev/null

pushd ~/.vim/bundle >/dev/null
git submodule update Vundle.vim
popd >/dev/null

