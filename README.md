# threesixtygiving-deploy

The SaltStack configuration is split into three repositories.

* threesixtygiving-deploy
* threesixtygiving-deploy-salt-private
* threesixtygiving-deploy-pillar-private

## Requirements

$ pip install salt

(you may wish to use a virtualenv)

## To update to latest content

This will also clone the private repos if they don't exist

`$ ./updateToMain.sh`

## To use salt as a standard user

`$ ./setupForNonRootUse.sh`

