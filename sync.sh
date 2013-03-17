#!/bin/bash
cd "$(dirname "${BASH_SOURCE}")"
git pull
function doIt() {
  rsync --exclude ".git/" \
    --exclude ".DS_Store" \
    --exclude "sync.sh" \
    --exclude "updater.sh" \
    --exclude "README.md" \
  -av . ~
}
if [ "$1" == "--force" -o "$1" == "-f" ]; then
	doIt
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1
	echo
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt
	fi
fi
unset doIt

# if [ "$2" != "--no-source" -a "$2" != "-ns" ]; then
  # source ~/.bash_profile
  # source ~/.zshrc
# fi
