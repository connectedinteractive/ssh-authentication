#!/bin/sh

git fetch
CHANGED_FILES=$(git status --porcelain --untracked-files=no | wc -l)
BASE=$(git rev-parse origin/master)

if [ $CHANGED_FILES -gt 0 ]; then
  logger System "Updating authorized_keys (git commit $BASE)"
  git fetch
  git reset --hard origin/master
  logger System "Kicking active SSH sessions"

  SSH_SERVICE=sshd

  if [ -f /etc/debian_version ]; then
    SSH_SERVICE=ssh
  fi

  sudo pkill --signal HUP sshd
  sudo service $SSH_SERVICE restart
fi

chmod 600 authorized_keys
