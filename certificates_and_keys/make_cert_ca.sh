#!/bin/bash
#
# Make a certificate & key for your own Certificate Authority (CA)
#
# Output:
# secretca.key - your own CA key
# secretca.csr - your own CA certificate signing request
# secretca.crt - your own CA certificate (self-signed)
#

FILENAME="secretca"
COUNTRY="US" # only 2 letters
STATE="California"
LOCALITY="San Diego"
ORGANIZATION="My Company"
ORG_UNIT="My Department"
COMMON_NAME="www.mycompany.com"

# Generate your own CA key
openssl genrsa -out $FILENAME.key 1024 

# Create your own CA certificate
openssl req -new -key $FILENAME.key -out $FILENAME.csr -subj "/C=$COUNTRY/ST=$STATE/L=$LOCALITY/O=$ORGANIZATION/OU=$ORG_UNIT/CN=$COMMON_NAME"
openssl x509 -req -days 365 -in $FILENAME.csr -signkey $FILENAME.key -out $FILENAME.crt
