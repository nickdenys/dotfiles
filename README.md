# Nick's Dotfiles

This repository automates setting up and maintaining my Mac. One script handles everything: Homebrew packages, shell configuration, app preferences, macOS system defaults, and Claude Code setup.

## Structure

```
~/.dotfiles/
├── bin/                        # Scripts
│   ├── install                 # Main setup script (run this on a fresh Mac)
│   └── ssh-setup               # SSH key generation helper
├── home/                       # Shell config (symlinked to ~/)
│   ├── .zshrc                  # Zsh configuration with Oh My Zsh
│   ├── aliases.zsh             # Command aliases (Laravel, PHP, JS, navigation)
│   ├── path.zsh               # PATH additions
│   ├── .gitconfig              # Git user, pager (delta), pull/push defaults
│   └── .gitignore_global       # Global gitignore patterns
├── config/                     # App configuration
│   ├── Brewfile                # All Homebrew packages, casks, and fonts
│   ├── claude/                 # Claude Code settings, agents, and skills
│   ├── ghostty/config          # Ghostty terminal (theme, font, window size)
│   └── macos/
│       ├── .macos              # macOS system preferences script
│       └── .mackup.cfg         # Mackup cloud backup config
└── oh-my-zsh-custom/
    └── themes/                 # Custom Zsh themes
```

## What's Inside

### `bin/`

- **install** sets up a fresh Mac from scratch. It installs Xcode CLI tools, Oh My Zsh, and Homebrew, then symlinks all config files and installs every package from the Brewfile.
- **ssh-setup** generates a new Ed25519 SSH key and adds it to the agent.

### `home/`

Files that get symlinked to your home directory (`~/`).

- **.zshrc** loads Oh My Zsh with the robbyrussell theme, sources aliases and path config, sets up Herd (PHP, NVM), and configures locale settings.
- **aliases.zsh** has shortcuts for Laravel (`a` for artisan, `fresh` for migrate:fresh), PHP (`composer`, `php`, `test`), JS (`watch`, `nfresh`), and navigation (`projects`, `sites`, `dotfiles`).
- **path.zsh** adds Composer, Node, PhpStorm, VS Code, MySQL client, and local project binaries to the PATH.
- **.gitconfig** sets git to use delta as the pager, rebase on pull, and auto setup remote tracking on push.
- **.gitignore_global** ignores OS files, IDE directories, compiled output, and log files across all repositories.

### `config/`

- **Brewfile** declares all Homebrew packages (git, bat, eza, jq, ffmpeg, imagemagick, and more), cask apps (Ghostty, Herd, Ray, TablePlus, Tower, VS Code, Raycast, 1Password, Slack), and fonts (IBM Plex Mono, Cascadia Code, Source Code Pro).
- **claude/** contains the full Claude Code configuration: personal coding guidelines (CLAUDE.md), editor settings, a custom status line, Laravel/PHP standards, peon-ping notification config, 6 custom agents (laravel-simplifier, laravel-debugger, laravel-feature-builder, code-reviewer, code-improvement-scanner, task-planner), and 60+ skills.
- **ghostty/config** sets up the Ghostty terminal with IBM Plex Mono at size 12, TokyoNight theme, bar cursor, and 10,000 lines of scrollback.
- **macos/.macos** is a large script that configures macOS system preferences (Finder, Dock, Safari, keyboard, trackpad, and many others).
- **macos/.mackup.cfg** tells Mackup to back up app preferences to Google Drive.

### `oh-my-zsh-custom/`

Contains custom Zsh themes. The robbyrussell theme override lives in `themes/`.

## Fresh macOS Setup

### 1. Backup your existing Mac

Before migrating, make sure you have covered all of these:

- Commit and push all branches in your git repositories
- Save important documents from non iCloud directories
- Export data from local databases
- Run `mackup backup` (update [mackup](https://github.com/lra/mackup) to the latest version first)

### 2. Set up SSH

Either sync your SSH keys from [1Password's SSH agent](https://developer.1password.com/docs/ssh/get-started/#step-3-turn-on-the-1password-ssh-agent), or generate a new key:

```zsh
curl https://raw.githubusercontent.com/nickdenys/dotfiles/HEAD/bin/ssh-setup | sh -s "<your-email-address>"
```

### 3. Clone and install

```zsh
git clone --recursive git@github.com:nickdenys/dotfiles.git ~/.dotfiles
cd ~/.dotfiles && ./bin/install
```

The install script will:
1. Install Xcode Command Line Tools (if missing)
2. Install Oh My Zsh (if missing)
3. Install Homebrew (if missing)
4. Symlink all config files to their expected locations
5. Install everything from the Brewfile
6. Configure MySQL with a default root password
7. Create `~/Code` and `~/Herd` directories
8. Apply macOS system preferences

### 4. Post install

1. Start `Herd.app` and complete its setup process
2. Once Mackup syncs with your cloud storage, run `mackup restore`
3. Restart your computer

### Using a different install path

The default location is `~/.dotfiles`. If you want to use a different path, update the `DOTFILES` variable in [`home/.zshrc`](./home/.zshrc#L2) and the hardcoded paths in [`bin/install`](./bin/install).

## Wiping your old Mac

After setting up the new machine, you can erase and reinstall your old Mac by following [Apple's guide](https://support.apple.com/guide/mac-help/erase-and-reinstall-macos-mh27903/mac). Make sure you've completed the [backup checklist](#1-backup-your-existing-mac) first.

## Credits

Inspired by the dotfiles of [Dries Vints](https://github.com/driesvints/dotfiles) and [Freek Van der Herten](https://github.com/freekmurze/dotfiles).
