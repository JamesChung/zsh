# Disallows zsh to prompt y/n on * deletion
setopt rmstarsilent

# Cache ZSH compdump files
export ZDOTDIR=$HOME/.zsh

# zsh shell completion
autoload -U compinit; compinit

# Path to iCloud
export ICLOUD="$HOME/Library/Mobile Documents/com~apple~CloudDocs"

# Path to iBooks books
export IBOOKS="$HOME/Library/Mobile Documents/iCloud~com~apple~iBooks/Documents"

# Path to eDEX-UI settings
export EDEX_UI="$HOME/Library/Application Support/eDEX-UI"

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Poetry configuration
export POETRY_VIRTUALENVS_IN_PROJECT=true

# Created by `userpath`
export PATH="$PATH:$HOME/.local/bin"

# Set for Chrome Debugging with Brave
export CHROME_EXECUTABLE='/Applications/Brave Browser.app/Contents/MacOS/Brave Browser'

# Enable GKE kubernetes plugin
export USE_GKE_GCLOUD_AUTH_PLUGIN=True

# If Go is installed export GOPATH and go binaries
if command -v go >/dev/null 2>&1; then
    export GOPATH=$(go env GOPATH)
    export PATH=$PATH:$GOPATH/bin
fi

# If vcpkg is installed export the VCPKG_ROOT path
if command -v vcpkg >/dev/null 2>&1; then
    export VCPKG_ROOT="$HOME/vcpkg"
fi

# oh-my-zsh configuration
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

if command -v gcloud >/dev/null 2>&1; then
    # enable path sourcing for gcloud components
    source "$HOMEBREW_PREFIX/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
    # enable shell command completion for gcloud
    source "$HOMEBREW_PREFIX/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
fi

# add kubectl autocomplete permanently to your zsh shell
if command -v kubectl >/dev/null 2>&1; then
    source <(kubectl completion zsh)
fi

# add helm autocomplete
if command -v helm >/dev/null 2>&1; then
    source <(helm completion zsh)
fi

# add cprl autocomplete
if command -v cprl >/dev/null 2>&1; then
    source <(cprl completion zsh); compdef _cprl cprl
fi

#### Custom Aliases ####

# Shows folders
alias ls="ls -F --color=auto"

# Shows hidden directories/files
alias l.="ls -d .*"

alias ll="ls -l"

# Upgrades everything
alias uge="zsh $HOME/Library/Mobile\ Documents/com~apple~CloudDocs/MacOSConfigs/upgrade_everything.sh"

# Deletes npm logs
alias npm-clear="if [ -d $HOME/.npm/_logs ]; then rm -rf $HOME/.npm/_logs; echo '> Deleted npm logs.'; else; echo '> No npm logs.'; fi"

# Clears npx cache
alias npx-clear="if [ -d $HOME/.npm/_npx ]; then rm -rf $HOME/.npm/_npx; echo '> Deleted npx cache.'; else; echo '> No npx cache.'; fi"

# Updates all docker images
docker-update() {
  if command -v docker >/dev/null 2>&1; then
    images=(`docker images --format="{{.Repository}}:{{.Tag}}"`)
    if [ ${#images[@]} -gt 0 ]; then
      for image in ${images[@]}; do
        docker pull $image
      done
    else
      echo "> No images."
    fi
  fi
}

# Change docker repository context for kubernetes with minikube
minikubeswapdockerctx() {
  if [[ $commands[minikube] && $commands[docker] ]]; then
    eval $(minikube -p minikube docker-env)
  fi
}

# Starts kind 3 node cluster
kind-create() {
  if [ $commands[kind] ]; then
    eval $(kind create cluster --config ${ICLOUD}/Dev/kind-multi-node.yaml)
  else
    echo "> kind is not installed."
  fi
}

# Destroys kind cluster
kind-delete() {
  if [ $commands[kind] ]; then
    kind delete cluster
  else
    echo "> kind is not installed."
  fi
}

######################## INIT ########################

# Starship init
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init zsh)"
fi

# oh-my-zsh by default pipes to less... This disables that
unset LESS;

# nvm init
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# pyenv config
if command -v pyenv >/dev/null 2>&1; then
    export PYENV_ROOT="$HOME/.pyenv"
    command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
fi

# fzf config
eval "$(fzf --zsh)"

# zoxide config
eval "$(zoxide init --cmd cd zsh)"
