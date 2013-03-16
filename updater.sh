#!/bin/sh

function _current_epoch() {
  echo $(($(date +%s) / 60 / 60 / 24))
}

function _update_dotfiles_update() {
  echo "LAST_EPOCH=$(_current_epoch)" > ~/.dotfiles-update
}

function _upgrade_dotfiles() {
  ~/code/dotifiles/bootstrap.sh -f
  # update the .dotfies-update file
  _update_dotfiles_update
}

if [ -f ~/.dotfiles-update ]
then
  . ~/.dotfiles-update

  if [[ -z "$LAST_EPOCH" ]]; then
    _update_dotfiles_update && return 0;
  fi

  epoch_diff=$(($(_current_epoch) - $LAST_EPOCH))

echo $epoch_diff;

if [ $epoch_diff -gt 13 ]
  then
#    if [ "$DISABLE_UPDATE_PROMPT" = "true" ]
#    then
      _upgrade_dotfiles
#    else
#      echo "[dotfiles] Would you like to pull in the updates?"
#      echo "Type Y to update: \c"
#      read line
#      if [ "$line" = Y ] || [ "$line" = y ]; then
#        _upgrade_dotfile
#      else
#        _update_dotfile_update
#      fi
#    fi
  fi
else
  # create the .dotfiles-update file
  _update_dotfiles_update
fi
