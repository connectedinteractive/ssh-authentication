#!/bin/sh

git remote update

LOCAL=$(git rev-parse @)
REMOTE=$(git rev-parse @{u})
BASE=$(git merge-base @ @{u})

if [ $LOCAL = $BASE ]; then
  echo "Rebasing"
  git fetch
  git reset --hard origin/master
  echo "Restarting SSH (a kludge to kick expired key sessions)"

  sudo pkill --signal HUP sshd

else
  echo "Up-to-date, nothing to do"
fi

chmod 644 authorized_keys
