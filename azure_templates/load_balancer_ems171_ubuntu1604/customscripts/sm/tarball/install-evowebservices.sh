#!/bin/bash
#
# EvoStream Media Server Extensions
# EvoStream, Inc.
# (c) 2017 by EvoStream, Inc. (support@evostream.com)
# Released under the MIT License
#
# Script to install node JS, ERS and PM2 package, and then start ERS.
#

# Get the needed parameters
OS=linux
ARCH=x64
VER=4.1.1
NODE_JS=http://nodejs.org/dist/v$VER/node-v$VER-$OS-$ARCH.tar.gz

# Download and extract needed node JS
which node
if [ $? != 0 ]; then 
    echo "Node.js DOES NOT exist.... Installing Node.js first...." 

    wget $NODE_JS 

    # Next, execute the following command to install the Node.js binary package in /usr/local/:
    tar zxf node-v$VER-$OS-$ARCH.tar.gz -C /usr/local --strip-components 1 
    if [ $? != 0 ]; then echo 'Node.js: INSTALLATION FAILED! Please see errors below:'; exit 1; fi

    echo "Node.js: SUCCESSFUL INSTALLATION!" 

else
    echo "Node.js already exists" 
fi 

# Install dependencies
echo 'Installing NPM evowebservices...'
USERNAME=`awk -v val=1001 -F ":" '$3==val{print $1}' /etc/passwd`
pushd /home/$USERNAME
npm install --save https://github.com/EvoStream/evowebservices/tarball/master-azure
if [ $? != 0 ]; then echo 'Evowebservices: INSTALLATION FAILED! Please see errors below:'; exit 1; fi
chown $USERNAME:$USERNAME -R node_modules
popd

cp run-evowebservices.sh /usr/local/bin

echo "Evowebservices: SUCCESSFUL INSTALLATION!"
exit 0;
