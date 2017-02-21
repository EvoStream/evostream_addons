#!/bin/bash
#
# EvoStream Media Server Extensions
# EvoStream, Inc.
# (c) 2017 by EvoStream, Inc. (support@evostream.com)
# Released under the MIT License
# 
# bash startup.sh <sm_ip_address> <password> <apiproxy> <license_url>
# e.g. bash startup.sh 111.222.33.44 Pa$$word1234 apiproxy http://myaccount.blob.core.windows.net/licenses/License.lic?st=2017-01-01T01%3A17%3A00Z&se=2018-01-01T01%3A28%3A00Z&sp=rl&sv=2015-12-11&sr=s&sig=v9z8M1PIdrIdNGSuTImXA72h3%2Bu%1FeeH%4FqPN3bSHGmm8%3D
#

SMIPADDRESS=$1
PASSWORD=$2
APIPROXY=$3
LICENSEURL=$4
SERVERTYPE=origin
WEBSERVPORT=4000

sudo killall -9 evostreamms
# files were downloaded earlier from fileUris in template
tar -xvf tarball.tgz
pushd tarball
# download license
sudo wget $LICENSEURL -O /etc/evostreamms/License.lic
# update config.lua
./patchlua config.lua.$SERVERTYPE update url http://$SMIPADDRESS:$WEBSERVPORT/evowebservices/
mv config.txt /etc/evostreamms/config.lua
rm config.lua.$SERVERTYPE
# patch webconfig.lua.auth
./patchlua webconfig.lua.auth update password $PASSWORD
rm webconfig.lua.auth
mv webconfig.txt webconfig.txt1
./patchlua webconfig.txt1 update pseudoDomain $APIPROXY
mv webconfig.txt /etc/evostreamms/webconfig.lua.auth
rm webconfig.txt1
# allow more than 1024 connections
sudo mv limits.conf /etc/security/
# register VM to SM
./sm-register.rb $SMIPADDRESS $PASSWORD $SERVERTYPE $APIPROXY
./ems-restart.rb
popd

# cleanup
rm -fr tarball/
rm tarball.tgz
rm startup.sh
