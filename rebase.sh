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

  if [ -f /etc/debian_version ]; then
    sudo service ssh restart
  elif [ -f /etc/redhat-release ]; then
    sudo service sshd restart
  fi

else
  echo "Up-to-date, nothing to do"
fi

chmod 644 authorized_keys
