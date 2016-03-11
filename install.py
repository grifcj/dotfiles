#!/usr/bin/env python3
"""
Install dotfiles to system.
"""

import argparse
import os
import shutil
import subprocess
import sys

home = os.path.expanduser('~')
dotdir = os.getcwd()
pj = os.path.join

def dot():
    return '.' if os.name == 'posix' else '_'

def vimhome():
        return pj(home, '.vim')

def install(args):

    global home

    if args.test:
        testdir = pj(os.getcwd(),'test')
        if os.path.exists(testdir):
            shutil.rmtree(testdir)
        home = testdir
        os.makedirs(testdir)

    # Only install bashrc on linux
    if os.name == 'posix':
        os.symlink(pj(dotdir, 'bashrc'), pj(home, dot() + 'bashrc'))

    os.symlink(pj(dotdir, 'vimrc'), pj(home, dot() + 'vimrc'))

    os.makedirs(pj(vimhome(), 'colors'))
    os.symlink(pj(dotdir, 'colors', 'zenburn.vim'), pj(vimhome(), 'colors',
        'zenburn.vim'))
    os.symlink(pj(dotdir, 'colors', 'jellybeans.vim'), pj(vimhome(), 'colors',
        'jellybeans.vim'))

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--test',
            action='store_true', help="""Create config tree in test subdir rather
            than home directory""")
    parser.set_defaults(func=install)

    args = parser.parse_args()
    args.func(args)

