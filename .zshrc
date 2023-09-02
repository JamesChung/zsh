# Disallows zsh to prompt y/n on * deletion
setopt rmstarsilent

# Cache ZSH compdump files
export ZDOTDIR=$HOME/.zsh

# zsh shell completion
autoload -U compinit; compinit

# Path to iCloud
export ICLOUD="$HOME/Library/Mobile Documents/com~apple~CloudDocs"

# Path to eDEX-UI settings
export EDEX_UI="$HOME/Library/Application Support/eDEX-UI"

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Poetry configuration
export POETRY_VIRTUALENVS_IN_PROJECT=true

# Created by `userpath`
export PATH="$PATH:$HOME/.local/bin"

# Set for Chrome Debugging
export CHROME_EXECUTABLE='/Applications/Brave Browser.app/Contents/MacOS/Brave Browser'

# Enable GKE kubernetes plugin
export USE_GKE_GCLOUD_AUTH_PLUGIN=True

# If Go is installed export GOPATH and go binaries
[ $commands[go] ] && export GOPATH=$(go env GOPATH); export PATH=$PATH:$GOPATH/bin

# If vcpkg is installed export the VCPKG_ROOT path
[ $commands[vcpkg] ] && export VCPKG_ROOT="$HOME/vcpkg"

# oh-my-zsh configuration
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# enable path sourcing for gcloud components
source "$HOMEBREW_PREFIX/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
# enable shell command completion for gcloud
source "$HOMEBREW_PREFIX/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"

# add kubectl autocomplete permanently to your zsh shell
[ $commands[kubectl] ] && source <(kubectl completion zsh)

# add helm autocomplete
[ $commands[helm] ] && source <(helm completion zsh)

# add cprl autocomplete
[ $commands[cprl] ] && source <(cprl completion zsh); compdef _cprl cprl

# add atuin autocomplete
[ $commands[atuin] ] && source <(atuin gen-completions --shell=zsh)

#### Custom Aliases ####

# Shows folders
alias ls="ls -F --color=auto"

# Shows hidden directories/files
alias l.="ls -d .*"

alias ll="ls -l"

# Upgrades everything
alias uge="zsh $HOME/Library/Mobile\ Documents/com~apple~CloudDocs/MacOSConfigs/upgrade_everything.sh"

# Clears .zsh_history file.
alias clhis="echo "" > $HOME/.zsh_history && rm ~/.local/share/atuin/*"

# Update yarn to latest stable version
alias yarn-up='corepack prepare yarn@stable --activate'

# Deletes npm logs
alias npm-clear="if [ -d $HOME/.npm/_logs ]; then rm -rf $HOME/.npm/_logs; echo '> Deleted npm logs.'; else; echo '> No npm logs.'; fi"

# Clears npx cache
alias npx-clear="if [ -d $HOME/.npm/_npx ]; then rm -rf $HOME/.npm/_npx; echo '> Deleted npx cache.'; else; echo '> No npx cache.'; fi"

# Updates all docker images
docker-update() {
  if [ $commands[docker] ]; then
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

books() {
  cd ~/Projects/git/safaribooks
  docker run --rm -it -v "$PWD":/root/safari jamesechung/safari:0.1 bash
}

######################## INIT ########################

# Starship init
eval "$(starship init zsh)"

# Atuin init
eval "$(atuin init zsh)"

# oh-my-zsh by default pipes to less... This disables that
unset LESS;

# nvm init
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# asdf config
source "$HOMEBREW_PREFIX/opt/asdf/libexec/asdf.sh"

# pyenv config
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
