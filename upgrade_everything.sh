#!/bin/zsh

set -uo pipefail

function upgrade_pip_packages() {
  packages=($(python3 -m pip list -o --format json | jq -r '.[] | .name'))
  length=${#packages[@]}
  if [[ $length -eq 0 ]]; then
    echo "> All packages are up to date."
  else
    echo "> Out of date: ${packages}"
    for package in "${packages[@]}"
    do
      echo "> Installing upgrade for: [${package}]."
      python3 -m pip install -U "$package" 2> /dev/null
      printf "\n"
    done
  fi
}

function upgrade() {
  echo "> Upgrading brew..."
  brew update
  brew upgrade
  casks=($(brew list --casks))
  if [[ ${#casks[@]} -gt 0 ]]; then
    brew upgrade --cask "${casks[@]}"
  fi
  brew cleanup --prune=all
  if [ $commands[rustup] ]; then
    echo "> Upgrading rust..."
    rustup update
  fi
  # if command -v pip >/dev/null 2>&1; then
  #   echo "> Upgrading pip..."
  #   upgrade_pip_packages
  # fi
  if command -v pipx >/dev/null 2>&1; then
    echo "> Upgrading pipx..."
    pipx upgrade-all
  fi
  if command -v npm >/dev/null 2>&1; then
    echo "> Listing outdated global npm packages..."
    npm outdated -g
    echo "> Upgrading npm..."
    npm update -g
  fi
  if command -v gcloud >/dev/null 2>&1; then
    echo "> Upgrading gcloud..."
    gcloud components update <<< y
  fi
  echo "> Done!"
}

upgrade

