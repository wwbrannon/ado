#!/bin/bash

# Install more recent versions of certain packages than
# travis's R support includes by default

cat > /tmp/apt_preferences << EOF
Package: bison
Pin: release n=trusty
Pin-Priority: 990

Package: libbison-dev
Pin: release n=trusty
Pin-Priority: 990

Explanation: Uninstall or do not install any Ubuntu-originated
Explanation: package versions other than those in precise
Package: *
Pin: release n=precise
Pin-Priority: 900

Package: *
Pin: release o=Ubuntu
Pin-Priority: -10
EOF
sudo mv /tmp/apt_preferences /etc/apt/preferences

cat /etc/apt/sources.list | sed -e 's/precise/trusty/g' > /tmp/trusty.list
sudo mv /tmp/trusty.list /etc/apt/sources.list.d/trusty.list

sudo apt-get update
sudo apt-get -y install --only-upgrade bison

sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test
sudo apt-get -qq update
sudo apt-get -qq install g++-4.8
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.8 90
