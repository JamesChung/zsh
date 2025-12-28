# Disallows zsh to prompt y/n on * deletion
setopt rmstarsilent

# Default TUI editor
export EDITOR=nvim

# Default GUI editor
export VISUAL=code

# Cache ZSH compdump files
export ZDOTDIR=$HOME/.zsh

# Path to iCloud
export ICLOUD="$HOME/Library/Mobile Documents/com~apple~CloudDocs"

# Path to iBooks books
export IBOOKS="$HOME/Library/Mobile Documents/iCloud~com~apple~iBooks/Documents"

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

# Lazy-load gcloud (loads on first use)
if command -v gcloud >/dev/null 2>&1; then
    gcloud() {
        unfunction gcloud
        # enable path sourcing for gcloud components
        source "$HOMEBREW_PREFIX/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
        # enable shell command completion for gcloud
        source "$HOMEBREW_PREFIX/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
        gcloud "$@"
    }
fi

# Lazy-load kubectl autocomplete (loads on first use)
if command -v kubectl >/dev/null 2>&1; then
    kubectl() {
        unfunction kubectl
        source <(command kubectl completion zsh)
        kubectl "$@"
    }
fi

# Lazy-load helm autocomplete (loads on first use)
if command -v helm >/dev/null 2>&1; then
    helm() {
        unfunction helm
        source <(command helm completion zsh)
        helm "$@"
    }
fi

# Lazy-load cprl autocomplete (loads on first use)
if command -v cprl >/dev/null 2>&1; then
    cprl() {
        unfunction cprl
        source <(command cprl completion zsh)
        compdef _cprl cprl
        cprl "$@"
    }
fi

#### Custom Aliases ####

# eza aliases (modern ls replacement)
if command -v eza >/dev/null 2>&1; then
    alias ls="eza --icons -F"
    alias l.="eza -d .*"
    alias ll="eza -l --icons"
    alias la="eza -la --icons"
    alias lt="eza --tree --icons"
    alias llt="eza -l --tree --icons"      # Long list with tree
    alias lls="eza -l --sort=size --icons" # Sort by size
    alias lld="eza -lD --icons"            # Directories only
    alias lll="eza -l --icons -H"          # Show hard links count
else
    alias ls="ls -F --color=auto"
    alias l.="ls -d .*"
    alias ll="ls -l"
fi

# Upgrades everything
alias uge="zsh $HOME/.zsh/upgrade_everything.sh"

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

# nvm lazy-loading (loads only when needed)
export NVM_DIR="$HOME/.nvm"
nvm() {
    unset -f nvm node npm npx
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    nvm "$@"
}
node() {
    unset -f nvm node npm npx
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    node "$@"
}
npm() {
    unset -f nvm node npm npx
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    npm "$@"
}
npx() {
    unset -f nvm node npm npx
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    npx "$@"
}

# Lazy-load pyenv (loads on first use)
if command -v pyenv >/dev/null 2>&1; then
    export PYENV_ROOT="$HOME/.pyenv"
    command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
    pyenv() {
        unfunction pyenv
        eval "$(command pyenv init -)"
        pyenv "$@"
    }
    python() {
        unfunction pyenv python
        eval "$(command pyenv init -)"
        python "$@"
    }
fi

# Lazy-load Angular CLI autocompletion (loads on first use)
if command -v ng >/dev/null 2>&1; then
    ng() {
        unfunction ng
        source <(command ng completion script)
        ng "$@"
    }
fi

# fzf config
if command -v fzf >/dev/null 2>&1; then
    eval "$(fzf --zsh)"
fi

# zoxide config
if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init --cmd cd zsh)"
fi

# Lazy-load pixi autocomplete (loads on first use)
if command -v pixi >/dev/null 2>&1; then
    pixi() {
        unfunction pixi
        eval "$(command pixi completion --shell zsh)"
        pixi "$@"
    }
fi

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/jameschung/.cache/lm-studio/bin"


# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/jameschung/.docker/completions $fpath)
# End of Docker CLI completions

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
