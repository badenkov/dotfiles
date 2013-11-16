#!/bin/bash

ln -s "$PWD/ack-grep/ackrc" "$HOME/.ackrc"

ln -s "$PWD/git/gitconfig" "$HOME/.gitconfig"
ln -s "$PWD/git/gitignore" "$HOME/.gitignore"

ln -s "$PWD/ruby/gemrc" "$HOME/.gemrc"
ln -s "$PWD/ruby/rdebugrc" "$HOME/.rdebugrc"

ln -s "$PWD/tmux/tmux.conf" "$HOME/.tmux.conf"

# becouse we use lightdm - xprofile and remove call to start window manager
ln -s "$PWD/xsession/xinitrc" "$HOME/.xprofile"

ln -s "$PWD/fonts" "$HOME/.fonts"
ln -s "$PWD/fontconfig/fonts.conf" "$HOME/.fonts.conf"
