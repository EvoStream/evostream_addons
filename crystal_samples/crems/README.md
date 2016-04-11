# crems

**crems** is an app for demonstrating basic streaming functionality of the EMS. The demo app checks the EMS version, pulls a live stream, checks the pulled stream for liveness, plays the pulled stream for a fixed duration, lists streams, shuts down the pulled stream, then lists streams again.

## Installation

1. EMS is required to run with the code.
   - [Installation of EMS on Ubuntu](http://docs.evostream.com/ems_quick_start_guide/quick_start_guide_for_linux#baptyum-installation)

2. Crystal language is required to run the code.
   Crystal is based on Ruby but is compiled and runs faster.
   - [Installation of Crystal on Ubuntu](http://crystal-lang.org/docs/installation/on_debian_and_ubuntu.html)

3. VLC is required to play streams.
   - Installation of VLC on Ubuntu:

     ```bash
     $ sudo apt-get install vlc
     ```

## Usage

1. Start EMS

   ```bash
   $ sudo service evostreamms start
   ```

2. Run crems

   ```bash
   $ crystal src/crems.cr
   ```

   Typical output:

   ```
   crems version 0.1.0
   Send to EMS 'version'
   Received from EMS:
   {"data":{"banner":"EvoStream Media Server (www.evostream.com) version 1.7.0 build 4283 with hash: 395ff5e220ea7311adf3fca70960fb30c7785d34 - PacMan|m| - (built for Ubuntu-14.04-x86_64 on 2016-01-27T10:00:15.000)","branchName":"","buildDate":"2016-01-27T10:00:15.000","buildNumber":"4283","codeName":"PacMan|m|","hash":"395ff5e220ea7311adf3fca70960fb30c7785d34","releaseNumber":"1.7.0"},"description":"Version","status":"SUCCESS"}

   Send to EMS 'pullstream uri=rtmp://streaming.cityofboston.gov/live/cable localstreamname=mystream'
   Received from EMS:
   {"data":{"audioCodecBytes":"","configId":1,"emulateUserAgent":"EvoStream Media Server (www.evostream.com) player","forceTcp":false,"httpProxy":"","isAudio":true,"keepAlive":true,"localStreamName":"mystream","operationType":1,"pageUrl":"","ppsBytes":"","rangeEnd":-1,"rangeStart":-2,"rtcpDetectionInterval":10,"sendRenewStream":false,"spsBytes":"","ssmIp":"","swfUrl":"","tcUrl":"","tos":256,"ttl":256,"uri":{"document":"cable","documentPath":"\/live\/","documentWithFullParameters":"cable","fullDocumentPath":"\/live\/cable","fullDocumentPathWithParameters":"\/live\/cable","fullParameters":"","fullUri":"rtmp:\/\/streaming.cityofboston.gov\/live\/cable","fullUriWithAuth":"rtmp:\/\/streaming.cityofboston.gov\/live\/cable","host":"streaming.cityofboston.gov","ip":"140.241.251.94","originalUri":"rtmp:\/\/streaming.cityofboston.gov\/live\/cable","parameters":{},"password":"","port":1935,"portSpecified":false,"scheme":"rtmp","userName":""}},"description":"Stream rtmp:\/\/streaming.cityofboston.gov\/live\/cable enqueued for pulling","status":"SUCCESS"}

   Check stream 'rtmp://localhost/live/mystream'
   Key frame found after 9 sec
   Play stream 'rtmp://localhost/live/mystream' for 20 seconds

   Send to EMS 'liststreams'
   Received from EMS:
   {"data":[{"appName":"evostreamms","audio":{"bytesCount":400005,"codec":"AAAC","codecNumeric":4702111241970122752,"droppedBytesCount":0,"droppedPacketsCount":0,"packetsCount":1167},"bandwidth":0,"connectionType":1,"creationTimestamp":1460353344514.9880,"edgePid":0,"farIp":"140.241.251.94","farPort":1935,"ip":"192.168.2.121","name":"mystream","nearIp":"192.168.2.121","nearPort":34012,"outStreamsUniqueIds":null,"pageUrl":"","port":34012,"processId":3868,"processType":"origin","pullSettings":{"_callback":null,"audioCodecBytes":"","configId":1,"emulateUserAgent":"EvoStream Media Server (www.evostream.com) player","forceTcp":false,"httpProxy":"","isAudio":true,"keepAlive":true,"localStreamName":"mystream","operationType":1,"pageUrl":"","ppsBytes":"","rangeEnd":-1,"rangeStart":-2,"rtcpDetectionInterval":10,"sendRenewStream":false,"spsBytes":"","ssmIp":"","swfUrl":"","tcUrl":"","tos":256,"ttl":256,"uri":"rtmp:\/\/streaming.cityofboston.gov\/live\/cable"},"queryTimestamp":1460353371669.9031,"serverAgent":"FMS\/3,5,7,7009","swfUrl":"rtmp:\/\/streaming.cityofboston.gov\/live\/cable","tcUrl":"rtmp:\/\/streaming.cityofboston.gov\/live\/cable","type":"INR","typeNumeric":5282249572905648128,"uniqueId":2,"upTime":27154.9150,"video":{"bytesCount":2923547,"codec":"VH264","codecNumeric":6217274493967007744,"droppedBytesCount":0,"droppedPacketsCount":0,"height":480,"level":30,"packetsCount":1325,"profile":77,"width":720}}],"description":"Available streams","status":"SUCCESS"}

   Send to EMS 'shutdownstream localstreamname=mystream permanently=1'
   Received from EMS:
   {"data":{"protocolStackInfo":{"carrier":{"farIP":"140.241.251.94","farPort":1935,"id":30,"nearIP":"192.168.2.121","nearPort":34012,"rx":3346644,"tx":3589,"type":"IOHT_TCP_CARRIER"},"stack":[{"applicationId":0,"creationTimestamp":1460353343803.4780,"id":28,"isEnqueueForDelete":false,"queryTimestamp":1460353371690.6350,"type":"TCP"},{"applicationId":1,"creationTimestamp":1460353343803.5171,"id":29,"isEnqueueForDelete":false,"queryTimestamp":1460353371690.6499,"rxInvokes":62,"serverAgent":"FMS\/3,5,7,7009","streams":[{"appName":"evostreamms","audio":{"bytesCount":400005,"codec":"AAAC","codecNumeric":4702111241970122752,"droppedBytesCount":0,"droppedPacketsCount":0,"packetsCount":1167},"bandwidth":0,"connectionType":1,"creationTimestamp":1460353344514.9880,"farIp":"140.241.251.94","farPort":1935,"ip":"192.168.2.121","name":"mystream","nearIp":"192.168.2.121","nearPort":34012,"outStreamsUniqueIds":null,"pageUrl":"","port":34012,"processId":3868,"processType":"origin","pullSettings":{"audioCodecBytes":"","configId":1,"emulateUserAgent":"EvoStream Media Server (www.evostream.com) player","forceTcp":false,"httpProxy":"","isAudio":true,"keepAlive":true,"localStreamName":"mystream","operationType":1,"pageUrl":"","ppsBytes":"","rangeEnd":-1,"rangeStart":-2,"rtcpDetectionInterval":10,"sendRenewStream":false,"spsBytes":"","ssmIp":"","swfUrl":"","tcUrl":"","tos":256,"ttl":256,"uri":"rtmp:\/\/streaming.cityofboston.gov\/live\/cable"},"queryTimestamp":1460353371690.7180,"serverAgent":"FMS\/3,5,7,7009","swfUrl":"rtmp:\/\/streaming.cityofboston.gov\/live\/cable","tcUrl":"rtmp:\/\/streaming.cityofboston.gov\/live\/cable","type":"INR","typeNumeric":5282249572905648128,"uniqueId":2,"upTime":27175.7300,"video":{"bytesCount":2923547,"codec":"VH264","codecNumeric":6217274493967007744,"droppedBytesCount":0,"droppedPacketsCount":0,"height":480,"level":30,"packetsCount":1325,"profile":77,"width":720}}],"txInvokes":6,"type":"OR"}]},"streamInfo":{"appName":"evostreamms","audio":{"bytesCount":400005,"codec":"AAAC","codecNumeric":4702111241970122752,"droppedBytesCount":0,"droppedPacketsCount":0,"packetsCount":1167},"bandwidth":0,"connectionType":1,"creationTimestamp":1460353344514.9880,"farIp":"140.241.251.94","farPort":1935,"ip":"192.168.2.121","name":"mystream","nearIp":"192.168.2.121","nearPort":34012,"outStreamsUniqueIds":null,"pageUrl":"","port":34012,"processId":3868,"processType":"origin","pullSettings":{"audioCodecBytes":"","configId":1,"emulateUserAgent":"EvoStream Media Server (www.evostream.com) player","forceTcp":false,"httpProxy":"","isAudio":true,"keepAlive":true,"localStreamName":"mystream","operationType":1,"pageUrl":"","ppsBytes":"","rangeEnd":-1,"rangeStart":-2,"rtcpDetectionInterval":10,"sendRenewStream":false,"spsBytes":"","ssmIp":"","swfUrl":"","tcUrl":"","tos":256,"ttl":256,"uri":"rtmp:\/\/streaming.cityofboston.gov\/live\/cable"},"queryTimestamp":1460353371690.9749,"serverAgent":"FMS\/3,5,7,7009","swfUrl":"rtmp:\/\/streaming.cityofboston.gov\/live\/cable","tcUrl":"rtmp:\/\/streaming.cityofboston.gov\/live\/cable","type":"INR","typeNumeric":5282249572905648128,"uniqueId":2,"upTime":27175.9868,"video":{"bytesCount":2923547,"codec":"VH264","codecNumeric":6217274493967007744,"droppedBytesCount":0,"droppedPacketsCount":0,"height":480,"level":30,"packetsCount":1325,"profile":77,"width":720}}},"description":"Stream closed","status":"SUCCESS"}

   Send to EMS 'liststreams'
   Received from EMS:
   {"data":null,"description":"Available streams","status":"SUCCESS"}
   ```

## Development

- The source code is provided for demonstration purposes only. It can be found on GitHub:

  https://github.com/EvoStream/evostream_addons/tree/master/crystal_samples/crems

- Tweaks in src/crems/constants.cr

  - TRACE adjusts the console output for debugging
  - URIS_LIVE sets the source stream URI

- Format the source code (optional)

  ```bash
  $ crystal tool format src
  ```

- Run tests (optional)

  ```bash
  $ crystal spec
  ```

- Build a binary for release (optional)
  ```bash
  $ crystal build src/crems.cr --release
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

