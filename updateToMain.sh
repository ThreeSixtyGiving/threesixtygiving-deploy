#!/bin/bash
set -e

echo "--------------------- DEPLOY"
git checkout main
git pull

echo "--------------------- PILLAR / PRIVATE"
if [ ! -d "pillar/private" ]; then
  git clone git@github.com:ThreeSixtyGiving/threesixtygiving-deploy-pillar-private.git pillar/private
fi

cd pillar/private
git checkout main
git pull
cd ../..

echo "--------------------- SALT / PRIVATE"
if [ ! -d "salt/private" ]; then
  git clone git@github.com:ThreeSixtyGiving/threesixtygiving-deploy-salt-private.git salt/private
fi

cd salt/private
git checkout main
git pull
cd ../..

