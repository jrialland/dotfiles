#!/bin/bash
if [ -d ~/.scripts ]; then
    export PATH=~/.scripts:$PATH
fi

if [ -d ~/.local/bin ]; then
    export PATH=~/.local/bin:$PATH
fi
