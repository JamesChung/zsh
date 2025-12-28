# Homebrew
if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

# Swiftly
[[ -f "$HOME/.swiftly/env.sh" ]] && . "$HOME/.swiftly/env.sh"

# OrbStack: command-line tools and integration
[[ -f "$HOME/.orbstack/shell/init.zsh" ]] && source "$HOME/.orbstack/shell/init.zsh"

# Coursier install directory
[[ -d "$HOME/Library/Application Support/Coursier/bin" ]] && export PATH="$PATH:$HOME/Library/Application Support/Coursier/bin"
