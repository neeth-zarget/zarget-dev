#!/usr/bin/env bash

if [[ $EUID -eq 0 ]]; then
   echo "Hold your horses! I refuse to run this as root."
   exit 1
fi

if [[ "$1" = "services" ]]; then
  node $ODDENV_DIR/scripts/services.js $2 $3
  exit 0
fi

test -f "/etc/facter/facts.d/oddenv.txt" || echo oddenv_dir=$ODDENV_DIR | sudo tee -a /etc/facter/facts.d/oddenv.txt

cd $ODDENV_DIR
git pull
brew bundle check || brew bundle
source "$(brew --prefix nvm)/nvm.sh"
nvm which 5.0 || nvm install 5.0
npm install
composer install
bundle install
sudo puppet apply manifests

sudo brew services restart dnsmasq
brew services restart mysql56