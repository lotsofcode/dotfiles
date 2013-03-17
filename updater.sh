#!/bin/bash

# source .functions

local CONFIG=~/.dotfiles-update;

# tmp
# _update_dotfiles_update;

function _current_epoch() {
  echo $(($(date +%s) / 60 / 60 / 24))
}

# create the epoch config
function _update_dotfiles_create_epoch() {
  echo "LAST_EPOCH=$(_current_epoch)" >> $CONFIG
}

# update the epoch config
function _update_dotfiles_update_epoch() {
  sed -i "s/LAST_EPOCH=.*/LAST_EPOCH=$(_current_epoch)/g" $CONFIG
}

function _upgrade_dotfiles() {
  # saysay "~/code/dotifiles/sync.sh -f"
  ~/code/dotfiles/sync.sh -f
  # update the .dotfies-update file
  _update_dotfiles_update_epoch
  source ~/.zshrc
}

if [ -f ~/.dotfiles-update ]
then
  source ~/.dotfiles-update

  if [[ -z "$LAST_EPOCH" ]]; then
    _update_dotfiles_create_epoch && return 0;
  fi

  epoch_diff=$(($(_current_epoch) - $LAST_EPOCH))
  if [ $epoch_diff -gt 13 ]; then
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
  # create the .dotfiles-update file
  _update_dotfiles_create_epoch
fi
