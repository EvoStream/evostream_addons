# httpcli

**httpcli** is an app for sending API commands to the EMS through the command line.

## Installation

1. EMS is required to run with the code.
   - [Installation of EMS on Ubuntu](http://docs.evostream.com/ems_quick_start_guide/quick_start_guide_for_linux#baptyum-installation)

2. Crystal language is required to run the code or build the binary.
   Crystal is based on Ruby but is compiled and runs faster.
   - [Installation of Crystal on Ubuntu](http://crystal-lang.org/docs/installation/on_debian_and_ubuntu.html)

3. The binary can also be downloaded for Ubuntu 16.04 (64-bit).

   ```bash
   $ unzip bin\release-1_0_0-ubuntu-16_04-64\httpcli.zip
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
   version: 0.0.0 # 0.0.0 / 1.7.1 / 2.0.0
   ip: 127.0.0.1
   username: username
   password: password
   domain: apiproxy
   0.0.0: { port: 7777 }
   1.7.1: { port: 8888 }
   2.0.0: { port: 8888 }
   ```

   Set the parameter "version" to "0.0.0" for sending API commands thru port 7777 (JSON_CLI).
   Set the parameter "version" to "1.7.1" or "2.0.0" for sending API commands thru port 8888 (HTTP_CLI).
   Set the parameter "ip" to the IP address of the EMS.
   The parameters "username", "password", and "domain" are used only for HTTP_CLI.

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

  - TRACE adjusts the console output for debugging
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

