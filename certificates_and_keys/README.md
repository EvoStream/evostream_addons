# certificates_and_keys

This folder contains scripts for creating certificates and keys required by EMS.

### make_cert_ca.sh

Make a certificate & key for my own Certificate Authority (CA)

Output:  
`secretca.key` - my own CA key  
`secretca.csr` - my own CA certificate signing request  
`secretca.crt` - my own CA certificate (self-signed)  

Note:  
These files should be kept secret. They required for creating the certificate & key for my server.

### make_cert_server.sh

Make a certificate & key for my server

Requires:  
`secretca.key` - my own CA key  
`secretca.crt` - my own CA certificate  

Output:  
`myserver.key` - my server key  
`myserver.csr` - my server certificate signing request  
`myserver.crt` - my server certificate (signed by my own CA)  

Optional Output:  
`myserver.p12` - my server certificate (signed by my own CA) in PKCS12 format (requires a password)

Note:  
Only `myserver.key` and `myserver.crt` are required by EMS.
The paths to these files are specified in the EMS configuration files `config.lua` (for RTMPS) and `webconfig.lua` (for EWS HTTPS and WebRTC).
