#!/bin/bash
#
# EvoStream Media Server Extensions
# EvoStream, Inc.
# (c) 2017 by EvoStream, Inc. (support@evostream.com)
# Released under the MIT License
# 
# bash startup.sh <admin_username> <license_url>
# e.g. bash startup.sh user1234 http://myaccount.blob.core.windows.net/licenses/License.lic?st=2017-01-01T01%3A17%3A00Z&se=2018-01-01T01%3A28%3A00Z&sp=rl&sv=2015-12-11&sr=s&sig=v9z8M1PIdrIdNGSuTImXA72h3%2Bu%1FeeH%4FqPN3bSHGmm8%3D
#

USERNAME=$1
LICENSEURL=$2

sudo killall -9 evostreamms
# files were downloaded earlier from fileUris in template
tar -xvf tarball.tgz
pushd tarball
# download license
sudo wget $LICENSEURL -O /etc/evostreamms/License.lic
# allow more than 1024 connections
sudo mv limits.conf /etc/security/
# install & run evowebservices
bash install-evowebservices.sh
bash run-evowebservices.sh > /dev/null
popd

# cleanup
rm -fr tarball/
rm tarball.tgz
rm startup.sh
