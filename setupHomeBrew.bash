#!/bin/bash

echo "This script will download and setup Home Brew on your Mac"
echo "It will also install the GNU version of many tools for you using brew"
echo "This script may take a little while to run."
echo ""
echo "Press <Enter> to continue or Ctrl+D to Quit"
read
# Download and setup Home brew

# tap homebrew/dupes
brew tap homebrew/dupes

# install all the GNU/Linux goodness
# The --default-names option will prevent Homebrew from prepending gs to the newly installed commands, thus we could use these commands as default ones over the ones shipped by OS X
brew install coreutils
brew install binutils
brew install diffutils
brew install ed --default-names
brew install findutils --default-names
brew install gawk
brew install gnu-indent --default-names
brew install gnu-sed --default-names
brew install gnu-tar --default-names
brew install gnu-which --default-names
brew install gnutls --default-names
brew install grep --default-names
brew install gzip
brew install screen
brew install watch
brew install wdiff --with-gettext
brew install wget

# Some command line tools already exist on OS X, but you may wanna a newer version:
brew install bash
brew install emacs
brew install gdb  # gdb requires further actions to make it work. See `brew info gdb`.
brew install gpatch
brew install m4
brew install make
brew install nano

# As a complementary set of packages, the following ones are not from GNU, but you can install and use a newer version instead of the version shipped by OS X:
brew install file-formula
brew install git
brew install less
brew install openssh --with-brewed-openssl
brew install perl518   # must run "brew tap homebrew/versions" first!
brew install python --with-brewed-openssl
brew install rsync
brew install svn
brew install unzip
brew install vim --override-system-vi
brew install macvim --override-system-vim --custom-system-icons
brew install zsh

