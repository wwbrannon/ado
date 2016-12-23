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
sudo cat /etc/apt/sources.list | sed 's/precise/trusty' > /etc/apt/sources.list.d/trusty.list

sudo apt-get update
sudo apt-get upgrade
