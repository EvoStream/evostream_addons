#!/bin/bash
#
#  Make a certificate & key for my server
#
#  Requires:
#  secretca.key - my own CA key
#  secretca.crt - my own CA certificate
#
#  Output:
#  myserver.key - my server key
#  myserver.csr - my server certificate signing request
#  myserver.crt - my server certificate (signed by my own CA)
#
#  Optional output:
#  myserver.p12 - my server certificate (signed by my own CA) in PKCS#12 format (requires a password)
#

CAFILENAME="secretca"
FILENAME="myserver"
COUNTRY="US" # only 2 letters
STATE="California"
LOCALITY="San Diego"
ORGANIZATION="My Company"
ORG_UNIT="My Department"
COMMON_NAME="localhost" #"www.myserver.com"
DURATION="365"
SERIAL="01"

# Generate a key for my server
openssl genrsa -out $FILENAME.key 1024

# Request and sign a client certificate for my server using my own CA certificate
openssl req -new -key $FILENAME.key -out $FILENAME.csr -subj "/C=$COUNTRY/ST=$STATE/L=$LOCALITY/O=$ORGANIZATION/OU=$ORG_UNIT/CN=$COMMON_NAME"
openssl x509 -req -days $DURATION -in $FILENAME.csr -CA $CAFILENAME.crt -CAkey $CAFILENAME.key -set_serial $SERIAL -out $FILENAME.crt

# Convert my server certificate to PKCS#12 format (requires a password)
openssl pkcs12 -export -in $FILENAME.crt -out $FILENAME.p12 -name "MyCertificate" -inkey $FILENAME.key
