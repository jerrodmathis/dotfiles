#!/bin/sh

echo "Performing a fresh install..."

# Check for oh-my-zsh and install if we don't have it
if test ! $(which omz); then
  /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/HEAD/tools/install.sh)"
fi

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Update Homebrew recipes
brew update

# Install all dependencies with bundle (see Brewfile)
brew bundle

# Create directories
mkdir $HOME/code

# Create code subdirectories
mkdir $HOME/code/intellistack
mkdir $HOME/code/jerrodmathis

# Generate SSH keys
./github-ssh.sh

# Clone repositories
./clone.sh

# Create symlinks with Stow
stow .
