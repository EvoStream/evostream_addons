# http_cli

**http_cli** is a tool for sending EMS API commands via HTTP and showing JSON responses in pretty format.


## Installation

1. Install Ruby (if not yet installed)

     ```bash
     $ sudo apt-get install ruby
     ```

2. Install required Ruby gems (if not yet installed)

     ```bash
     $ sudo gem install open-uri
     $ sudo gem install base64
     $ sudo gem install json
     $ sudo gem install colorize
     ```

3. Configure the tool according to the EMS settings:

     For local EMS with no API proxy:
     ```
     SERVER_IP = "127.0.0.1"
     HTTP_USERNAME = "evostream"
     HTTP_PASSWORD = ""
     ```
     API proxy should be disabled in the EMS webserver configuration file, `webconfig.lua`, by commenting out the `apiProxy` block.
     ```
     --[[
     apiProxy=
     {
        authentication="basic",
        pseudoDomain="<domain>",
        address="127.0.0.1",
        port=7777,
        userName="<username>",
        password="<password>",
     },
     ]]--
     ```

     For remote EMS with API proxy:
     ```
     SERVER_IP = "111.222.33.44"
     HTTP_USERNAME = "evostream"
     HTTP_PASSWORD = "Pa$$word1234"
     ```
     This is for remote EMS IP `111.222.33.44` with API proxy enabled. The `apiProxy` block in the EMS webserver configuration file, `webconfig.lua`, should be uncommented, with parameters set as follows:
     ```
     apiProxy=
     {
     	authentication="basic",
     	pseudoDomain="apiproxy",
     	address="127.0.0.1",
     	port=7777,
     	userName="evostream",
     	password="Pa$$word1234",
     },
     ```


## Usage Examples

1. Get the EMS version

     ```bash
     $ ./http_cli version
     ```

     A typical response would be:
     ```
     --API command: version
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
     --API response: SUCCESS (Version)
     ```

2. Pull a live stream to EMS

     ```bash
     $ ./http_cli.rb pullstream uri=rtmp://streaming.cityofboston.gov/live/cable localstreamname=mystream
     ```

     A typical response would be:
     ```
     --API command: pullstream uri=rtmp://streaming.cityofboston.gov/live/cable localstreamname=mystream
     {
       "data": {
         "audioCodecBytes": "",
         "configId": 2,
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
           "parameters": {
           },
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
     --API response: SUCCESS (Stream rtmp://streaming.cityofboston.gov/live/cable enqueued for pulling)
     ```

3. List streams on EMS

     ```bash
     $ ./http_cli.rb liststreams
     ```

     A typical response would be:
     ```
     --API command: liststreams
     {
       "data": [
         {
           "appName": "evostreamms",
           "audio": {
             "bytesCount": 116433,
             "codec": "AAAC",
             "codecNumeric": 4702111241970122752,
             "droppedBytesCount": 0,
             "droppedPacketsCount": 0,
             "packetsCount": 341
           },
           "bandwidth": 0,
           "connectionType": 1,
           "creationTimestamp": 1487730410699.551,
           "edgePid": 0,
           "farIp": "140.241.251.94",
           "farPort": 1935,
           "ip": "192.168.2.4",
           "name": "mystream",
           "nearIp": "192.168.2.4",
           "nearPort": 57224,
           "outStreamsUniqueIds": null,
           "pageUrl": "",
           "port": 57224,
           "processId": 8785,
           "processType": "origin",
           "pullSettings": {
             "_callback": null,
             "audioCodecBytes": "",
             "configId": 2,
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
             "uri": "rtmp://streaming.cityofboston.gov/live/cable"
           },
           "queryTimestamp": 1487730418677.512,
           "serverAgent": "FMS/3,5,7,7009",
           "swfUrl": "rtmp://streaming.cityofboston.gov/live/cable",
           "tcUrl": "rtmp://streaming.cityofboston.gov/live/cable",
           "type": "INR",
           "typeNumeric": 5282249572905648128,
           "uniqueId": 1,
           "upTime": 7977.9609,
           "video": {
             "bytesCount": 755514,
             "codec": "VH264",
             "codecNumeric": 6217274493967007744,
             "droppedBytesCount": 0,
             "droppedPacketsCount": 0,
             "height": 480,
             "level": 30,
             "packetsCount": 286,
             "profile": 77,
             "width": 720
           }
         }
       ],
       "description": "Available streams",
       "status": "SUCCESS"
     }
     --API response: SUCCESS (Available streams)
     ```


## Development

- The source code is provided for demonstration purposes only. It can be found on GitHub:
https://github.com/EvoStream/evostream_addons/tree/master/ruby_samples/http_cli


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

