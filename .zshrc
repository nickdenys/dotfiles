# Dotfiles
export DOTFILES=$HOME/.dotfiles

# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
ZSH_CUSTOM=$DOTFILES # Use dotfiles repo for custom plugins/themes
plugins=(git)
source $ZSH/oh-my-zsh.sh

# Locale
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Zsh plugins (installed via brew)
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Herd (PHP, NVM, and shell config)
export HERD_PHP_84_INI_SCAN_DIR="/Users/nick/Library/Application Support/Herd/config/php/84/"
export HERD_PHP_85_INI_SCAN_DIR="/Users/nick/Library/Application Support/Herd/config/php/85/"
export PATH="/Users/nick/Library/Application Support/Herd/bin/":$PATH
export NVM_DIR="/Users/nick/Library/Application Support/Herd/config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[[ -f "/Applications/Herd.app/Contents/Resources/config/shell/zshrc.zsh" ]] && builtin source "/Applications/Herd.app/Contents/Resources/config/shell/zshrc.zsh"
