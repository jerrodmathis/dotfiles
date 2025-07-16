# Dotfiles

Personal macOS development environment setup and configuration management.

## Overview

This repository contains scripts and configuration for setting up a complete development environment on macOS. It automates the installation of essential tools, applications, and development repositories.

## Directory Structure

- **`fresh.sh`** - Main installation script that sets up the entire environment
- **`Brewfile`** - Homebrew bundle file defining all packages and applications to install
- **`clone.sh`** - Script for cloning specific development repositories
- **`.config/`** - Configuration files for various tools (managed via Stow)

## Quick Start

### Prerequisites

- macOS
- Internet connection
- SSH key configured for GitHub (for repository cloning)

### Installation

Run the fresh install script:

```bash
./fresh.sh
```

This will:

1. **Install oh-my-zsh** (if not already installed)
2. **Install Homebrew** (if not already installed) 
3. **Update Homebrew** and install bundle support
4. **Install all packages** defined in `Brewfile`
5. **Create directory structure** (`~/code/intellistack`, `~/code/jerrodmathis`)
6. **Clone repositories** via `clone.sh`
7. **Create symlinks** for dotfiles using Stow

## What Gets Installed

### Development Tools
- Git, Neovim, Node.js, Yarn, NVM
- tmux, Stow, Starship prompt
- btop, Gemini CLI

### Applications
- 1Password, Cursor, Docker, Figma
- Ghostty, Kitty, Obsidian, OrbStack
- Postman, Raycast, Rectangle Pro
- Discord, Spotify

### Repositories
- **Intellistack projects**: odin-ui, odin-workflows, daedalus
- **Personal projects**: live-pull-requests

## Manual Steps

After running `fresh.sh`, you may need to:

1. **Configure SSH keys** for GitHub if not already done
2. **Sign into applications** (1Password, Spotify, etc.)
3. **Configure shell** - restart terminal to load oh-my-zsh
4. **Import application settings** if you have backups

## Customization

- Edit `Brewfile` to add/remove packages
- Modify `clone.sh` to include different repositories
- Add configuration files to `.config/` directory
- Use `stow .` to apply changes after modifications

## Notes

- The script is idempotent - safe to run multiple times
- Uses Stow for dotfile management (symlinks)
- Creates organized directory structure under `~/code`
- Assumes SSH access to GitHub repositories
