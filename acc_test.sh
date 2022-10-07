#!/bin/bash

if [ "$1" != "1" -a "$1" != "2" -a "$1" != "3" -a "$1" != "all" ]
then
    prog=`basename $0`
    echo "usage: ${prog} {1,2,all}"
    exit 1
fi

bundle -v
rm -f Gemfile.lock
bundle install >/dev/null

if [ "$1" = "1" -o "$1" = "all" ]
then
    bundle exec rake 'litmus:provision_list[ubuntu]'
    bundle exec bolt command run 'apt-get update && apt-get install lsb-release -y' -t all -i spec/fixtures/litmus_inventory.yaml
    bundle exec rake 'litmus:provision_list[centos]'
fi

if [ "$1" = "2" -o "$1" = "all" ]
then
    bundle exec rake 'litmus:provision_list[debian]'
    bundle exec bolt command run 'apt-get update && apt-get install lsb-release curl -y' -t all -i spec/fixtures/litmus_inventory.yaml
    bundle exec rake 'litmus:provision_list[oracle]'
fi

if [ "$1" = "3" -o "$1" = "all" ]
then
    bundle exec rake 'litmus:provision_list[rockylinux]'
fi

bundle exec rake 'litmus:install_agent[puppet6]'
bundle exec rake litmus:install_module
bundle exec rake litmus:acceptance:parallel
bundle exec rake 'litmus:tear_down'

exit 0
