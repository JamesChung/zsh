# System Setup

This repository contains my zsh configuration and setup scripts to quickly restore my development environment on a new machine.

## Quick Start

### Prerequisites

- macOS (this setup is designed for macOS)
- Git installed (comes pre-installed on macOS)
- SSH key configured for GitHub access

### Setup from Scratch

1. **Clone this repository:**
   ```bash
   git clone git@github.com:JamesChung/zsh.git ~/.zsh
   ```

2. **Run the setup script:**
   ```bash
   cd ~/.zsh
   ./setup.sh
   ```

3. **Restart your terminal:**
   ```bash
   exec zsh
   ```

That's it! The setup script will automatically:
- Install Homebrew (if not already installed)
- Install all packages from the Brewfile (casks and formulae)
- Clone your configuration repositories:
  - Ghostty config → `~/.config/ghostty`
  - Neovim config → `~/.config/nvim`
  - Zsh config → `~/.zsh`
- Set zsh as your default shell

## What Gets Installed

### GUI Applications (Casks)
- Development: VS Code, IntelliJ IDEA CE, Lapce, Claude Code
- Browsers: Brave
- Communication: Discord, Slack
- Utilities: Ghostty, UTM, Obsidian, Postman, Insomnia
- And more (see Brewfile for complete list)

### CLI Tools (Formulae)
- Shell: zsh, bash, tmux, starship
- Version Control: git, gh, lazygit, jj
- Programming Languages: go, rust-analyzer, dart, deno, bun
- Development Tools: neovim, docker-credential-helper-ecr, kind, helm
- Utilities: fzf, ripgrep, bat, eza, fd, zoxide
- And many more (see Brewfile for complete list)

## Manual Steps

After running the setup script, you may need to:

1. **Configure Git:**
   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "your.email@example.com"
   ```

2. **Set up SSH keys for GitHub** (if not already done):
   ```bash
   ssh-keygen -t ed25519 -C "your.email@example.com"
   eval "$(ssh-agent -s)"
   ssh-add ~/.ssh/id_ed25519
   # Add the public key to GitHub
   cat ~/.ssh/id_ed25519.pub
   ```

3. **Configure any application-specific settings** as needed

## Repository Structure

```
~/.zsh/
├── README.md          # This file
├── Brewfile           # Homebrew packages list
└── setup.sh           # Main setup script
```

## Updating the Brewfile

To update the Brewfile with newly installed packages:

```bash
cd ~/.zsh
brew bundle dump --force
```

## Configuration Repositories

This setup clones the following configuration repositories:

- [ghostty-config](https://github.com/JamesChung/ghostty-config) - Ghostty terminal configuration
- [nvim-config](https://github.com/JamesChung/nvim-config) - Neovim configuration
- [zsh](https://github.com/JamesChung/zsh) - Zsh configuration (this repo)

## Troubleshooting

### Setup script fails

- Ensure you have an active internet connection
- Check that your SSH key is properly configured for GitHub
- Run `brew doctor` to diagnose Homebrew issues

### Missing packages after setup

- Run `brew bundle install --file=~/.zsh/Brewfile` to retry installation
- Check the terminal output for any error messages

### Shell doesn't change to zsh

- Manually set zsh as default: `chsh -s $(which zsh)`
- Restart your terminal application

## License

Personal configuration files - use at your own discretion.
