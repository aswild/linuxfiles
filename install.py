#!/usr/bin/env python
#######################################################################
#
# install.py
# Installer to create multi-call symlinks for selectf.sh
#
# Copyright (c) 2016 Allen Wild
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
#######################################################################

from __future__ import print_function
import sys
import os
import re
import argparse
import itertools

def parse_args(argv=None):
    parser = argparse.ArgumentParser()
    parser.add_argument("-f", "--force", action="store_true",
                        help="Overwrite existing links in <destdir>")
    parser.add_argument("destdir", help="link destination directory")
    default_target = os.path.join(os.path.dirname(sys.argv[0]), "selectf.sh")
    parser.add_argument("target", nargs="?", default=default_target,
                        help="Target of the base 'selectf' link "
                             + "(will be expanded to an absolute path)")
    return parser.parse_args(argv) if argv else parser.parse_args()

def fatal(message):
    print(message, file=sys.stderr)
    sys.exit(1)

def make_link(target, linkdest, force=False):
    if force and os.path.islink(linkdest):
        print("unlink: " + linkdest)
        os.unlink(linkdest)
    print("link: %s -> %s"%(linkdest, target))
    try:
        os.symlink(target, linkdest)
    except FileExistsError:
        print("Error: '%s' already exists."%linkdest
              + " Use [-f] to force overwriting")

# generator which yields the links to make
# all permutations of [g]vimf[r][i]
def link_names():
    G = ['', 'g']
    R = ['', 'r']
    I = ['', 'i']
    for i in itertools.product(G, R, I):
        yield "%svimf%s%s"%i


if __name__ == "__main__":
    args = parse_args()
    destdir = args.destdir
    force = args.force

    # expand target to absolute path
    # may not exist in the case of cross-installing
    base_target = os.path.abspath(args.target)

    # individual links will point back to "selectf" locally rather than
    # using an absolute target for each link. Also, strip off the ".sh"
    target = os.path.basename(base_target)
    target = re.sub(r"\.sh$", "", target)

    # if destdir doesn't exist, create it
    if not os.path.isdir(destdir):
        os.makedirs(destdir)

    # make the base link
    make_link(base_target, os.path.join(destdir, target), force)

    # make multi-call links
    for link in link_names():
        make_link(target, os.path.join(destdir, link), force)
