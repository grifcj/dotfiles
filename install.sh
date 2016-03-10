#!/bin/bash
################################################################################
# Install dotfiles to system.
#
# TODO Currently, this only supports unix systems, obviously. Consider making
# it a python script to allow better support of Windows.
################################################################################

dir=~/dotfiles

ln -svf $dir/bashrc ~/.bashrc
ln -svf $dir/vimrc ~/.vimrc
mkdir -pv ~/.vim/colors
ln -svf $dir/colors/zenburn.vim ~/.vim/colors/zenburn.vim
ln -svf $dir/colors/jellybeans.vim ~/.vim/colors/jellybeans.vim
