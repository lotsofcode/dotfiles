#!/bin/bash

source .platform
source .functions

CONFIG=~/.dotfiles;

# grab the current epoch
function _current_epoch() {
  echo $(($(date +%s) / 60 / 60 / 24))
}

# create the epoch config
function _update_dotfiles_create_epoch() {
  echo -e "\nLAST_EPOCH=$(_current_epoch)" >> $CONFIG
}

# update the epoch config
function _update_dotfiles_update_epoch() {
  # @see http://stackoverflow.com/questions/7648328/getting-sed-error #annoying
  if [ "$platform" = "darwin" ] ; then
    sed -i "" "s/LAST_EPOCH=.*/LAST_EPOCH=$(_current_epoch)/g" $CONFIG
  else
    sed -i "s/LAST_EPOCH=.*/LAST_EPOCH=$(_current_epoch)/g" $CONFIG
  fi
}

function _upgrade_dotfiles() {
  sayhead "UPDATING DOTFILES"
  saybody "~/code/dotfiles/sync.sh -f"
  ~/code/dotfiles/sync.sh -f
  saybody "_update_dotfiles_update_epoch"
  _update_dotfiles_update_epoch
  saybody "source ~/.zshrc"
  source ~/.zshrc # recurssion issue w/ source - seek medical attention immediately
}

if [ -f $CONFIG ]
then
  source $CONFIG
  if [[ -z "$LAST_EPOCH" ]]; then
    _update_dotfiles_create_epoch && exit 0;
  fi
  epoch_diff=$(($(_current_epoch) - $LAST_EPOCH))
  if [ $epoch_diff -gt 13 ]; then

    gitstatus=$(git pull);
    if [ "$gitstatus" = "Already up-to-date." ]; then
      _update_dotfiles_create_epoch && exit 0;
    fi

    if [ "$DISABLE_UPDATE_PROMPT" = "true" ]; then
      _upgrade_dotfiles
    else
      echo "[dotfiles] Would you like to pull in the updates [y/n]? \c"
      read line
      if [ "$line" = Y ] || [ "$line" = y ]; then
        _upgrade_dotfiles
      else
        _update_dotfiles_update_epoch
      fi
    fi
  fi
else
  _update_dotfiles_create_epoch
fi
