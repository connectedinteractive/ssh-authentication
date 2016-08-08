#!/bin/sh

git remote update

LOCAL=$(git rev-parse @)
REMOTE=$(git rev-parse @{u})
BASE=$(git merge-base @ @{u})

if [ $LOCAL = $BASE ]; then
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

chmod 644 authorized_keys
