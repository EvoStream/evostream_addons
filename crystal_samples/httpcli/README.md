# httpcli

**httpcli** is an app for sending API commands to the EMS through the command line. The EMS may be on a local or on a remote server. Commands are sent via HTTP directly to EMS (through port 7777) or through EWS (via port 8888). For sending HTTP commands securely, port 8888 should be used and the EWS configured as follows:

For EMS 1.7.1 and older versions, set `apiProxy` in `webconfig.lua`:
```
apiProxy=
{
  authentication="basic", 
  pseudoDomain="apiproxy",
  address="127.0.0.1",
  port=7777,
  userName="username",
  password="password",
},

```

For EMS 2.0.0 and newer versions, set `apiProxy` in `webconfig.json`:
```
"apiProxy": 
{
  "enable" : true,
  "authentication": "basic",                      
  "pseudoDomain": "apiproxy",
  "address": "127.0.0.1",
  "port": 7777,
  "userName": "username",
  "password": "password"
}
```

Replace "address" with the IP address of the EMS. Replace "userName" and "password" as required.

*TIP: To process JSON responses from EMS, see [httpcli_cookbook](../httpcli_cookbook/README.md) for some command-line examples.*

## Installation

1. EMS is required to run with the code.
   - [Installation of EMS on Ubuntu](http://docs.evostream.com/ems_quick_start_guide/quick_start_guide_for_linux#baptyum-installation)

2. Crystal language is required to build the binary (or run from source).
   Crystal is based on Ruby but is compiled and runs faster.
   - [Installation of Crystal on Ubuntu](http://crystal-lang.org/docs/installation/on_debian_and_ubuntu.html)

3. The binary can also be downloaded for Ubuntu 16.04 (64-bit). Builds for other platforms may be added later.

   ```bash
   $ wget https://github.com/EvoStream/evostream_addons/tree/master/crystal_samples/httpcli/download/httpcli-1.1.2/httpcli-1.1.2-ubuntu16.04-amd64.zip
   $ unzip httpcli-1.1.2-ubuntu16.04-amd64.zip
   ```

## Usage

1. Start the EMS

   ```bash
   $ sudo service evostreamms start
   ```

2. Build the httpcli binary
   
   ```bash
   $ crystal build httpcli.cr
   ```

3. Edit the settings

   Modify the settings file, "settings.yml", according to your EMS configuration.

   ```yaml
   verbosity: 2 # 0=simple json, 1=pretty json, 2=with remarks, 3=with details
   version: 0.0.0 # 0.0.0 / 1.7.1 / 2.0.0
   ip: 127.0.0.1
   username: username
   password: password
   domain: apiproxy
   0.0.0: { port: 7777 }
   1.7.1: { port: 8888 }
   2.0.0: { port: 8888 }
   ```

   Set the parameter "verbosity" to "0" to output simple JSON (for processing responses), "1" for prettified JSON (for readability), "2" to add remarks (for interactive use), or "3" to provide more details (for trouble-shooting).

   Set the parameter "version" to "0.0.0" for sending API commands thru port 7777 (no security). If set to "1.7.1" or "2.0.0", port 8888 will be used (with username/password security).

   Set the parameter "version" to "1.7.1" for EMS 1.7.1 or older versions, or "2.0.0" for EMS 2.0.0" or newer versions.

   Set the parameter "ip" to the IP address of the EMS (127.0.0.1 for local EMS).

   The parameters "username", "password", and "domain" are required only if "version" is not "0.0.0" (i.e. port 7777 is not used).

4. Run httpcli

   Example 1. Normal response for version command.

   ```bash
   $ ./httpcli version
   Send to EMS 'version'
   Sent via HTTP 'http://localhost:7777/version'
   Received from EMS:
   {
     "data": {
       "banner": "EvoStream Media Server (www.evostream.com) version 1.7.1 build 4491 with hash: 64b305253110afc4acd5aeaf87f0a0b0f9b53526 - PacMan|m| - (built for Ubuntu-16.04-x86_64 on 2016-06-17T10:05:48.000)",
       "branchName": "",
       "buildDate": "2016-06-17T10:05:48.000",
       "buildNumber": "4491",
       "codeName": "PacMan|m|",
       "hash": "64b305253110afc4acd5aeaf87f0a0b0f9b53526",
       "releaseNumber": "1.7.1"
     },
     "description": "Version",
     "status": "SUCCESS"
   }
   ```

   Example 2. Normal response for pullstream command.

   ```bash
   $ ./httpcli pullstream uri=rtmp://streaming.cityofboston.gov/live/cable localstreamname=mystream
   Send to EMS 'pullstream uri=rtmp://streaming.cityofboston.gov/live/cable localstreamname=mystream'
   Sent via HTTP 'http://localhost:7777/pullstream?params=dXJpPXJ0bXA6Ly9zdHJlYW1pbmcuY2l0eW9mYm9zdG9uLmdvdi9saXZlL2NhYmxlIGxvY2Fsc3RyZWFtbmFtZT1teXN0cmVhbTE='
   Received from EMS:
   {
     "data": {
       "audioCodecBytes": "",
       "configId": 5,
       "emulateUserAgent": "EvoStream Media Server (www.evostream.com) player",
       "forceTcp": false,
       "httpProxy": "",
       "isAudio": true,
       "keepAlive": true,
       "localStreamName": "mystream",
       "operationType": 1,
       "pageUrl": "",
       "ppsBytes": "",
       "rangeEnd": -1,
       "rangeStart": -2,
       "rtcpDetectionInterval": 10,
       "sendRenewStream": false,
       "spsBytes": "",
       "ssmIp": "",
       "swfUrl": "",
       "tcUrl": "",
       "tos": 256,
       "ttl": 256,
       "uri": {
         "document": "cable",
         "documentPath": "/live/",
         "documentWithFullParameters": "cable",
         "fullDocumentPath": "/live/cable",
         "fullDocumentPathWithParameters": "/live/cable",
         "fullParameters": "",
         "fullUri": "rtmp://streaming.cityofboston.gov/live/cable",
         "fullUriWithAuth": "rtmp://streaming.cityofboston.gov/live/cable",
         "host": "streaming.cityofboston.gov",
         "ip": "140.241.251.94",
         "originalUri": "rtmp://streaming.cityofboston.gov/live/cable",
         "parameters": {},
         "password": "",
         "port": 1935,
         "portSpecified": false,
         "scheme": "rtmp",
         "userName": ""
       }
     },
     "description": "Stream rtmp://streaming.cityofboston.gov/live/cable enqueued for pulling",
     "status": "SUCCESS"
   }
   ```

   Example 3. Error response due to duplicate stream name.

   ```bash
   $ ./httpcli pullstream uri=rtmp://streaming.cityofboston.gov/live/cable localstreamname=mystream
   Send to EMS 'pullstream uri=rtmp://streaming.cityofboston.gov/live/cable localstreamname=mystream'
   Sent via HTTP 'http://localhost:7777/pullstream?params=dXJpPXJ0bXA6Ly9zdHJlYW1pbmcuY2l0eW9mYm9zdG9uLmdvdi9saXZlL2NhYmxlIGxvY2Fsc3RyZWFtbmFtZT1teXN0cmVhbQ=='
   Received from EMS:
   {
     "data": null,
     "description": "Stream name mystream already taken",
     "status": "FAIL"
   }
   ```

## Downloads

- See the [download](https://github.com/EvoStream/evostream_addons/tree/master/crystal_samples/httpcli/download) directory for compiled binaries of httpcli.

## Development

- The source code is provided for demonstration purposes only. It can be found on GitHub:

  https://github.com/EvoStream/evostream_addons/tree/master/crystal_samples/httpcli

- Tweaks in httpcli/constants.cr

  - SETTINGS_FILE changes the path to the httpcli settings. If the settings file is missing, default settings will be used.

- Build a binary for release (optional)
  ```bash
  $ crystal build httpcli.cr
  ```

## Contributing

1. Fork it ( https://github.com/EvoStream/evostream_addons/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [EvoStream](https://github.com/EvoStream)  - creator, maintainer

## License

- [MIT](LICENSE.md)

