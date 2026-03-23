# Add directories to the PATH and prevent to add the same directory multiple times upon shell reload.
add_to_path() {
  if [[ -d "$1" ]] && [[ ":$PATH:" != *":$1:"* ]]; then
    export PATH="$1:$PATH"
  fi
}

add_to_path "$HOME/.local/bin"
add_to_path "$DOTFILES/bin"

# Load global Composer tools
add_to_path "$HOME/.composer/vendor/bin"

# Load global Node installed binaries
add_to_path "$HOME/.node/bin"

# App binaries
add_to_path "/Applications/PhpStorm.app/Contents/MacOS"
add_to_path "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
add_to_path "/opt/homebrew/opt/mysql-client/bin"

# Use project specific binaries before global ones
add_to_path "vendor/bin"
add_to_path "node_modules/.bin"
