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
  sudo service ssh restart
else
  echo "Up-to-date, nothing to do"
fi
