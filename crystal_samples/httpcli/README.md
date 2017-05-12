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

1. Start EMS

   ```bash
   $ sudo service evostreamms start
   ```

2. Build httpcli binary
   
   ```bash
   $ crystal build httpcli.cr
   ```

3. Run httpcli

   ```bash
   $ ./httpcli version
   Send to EMS 'version'
   Received from EMS:
   {"data":{"banner":"EvoStream Media Server (www.evostream.com) version 1.7.0 build 4283 with hash: 395ff5e220ea7311adf3fca70960fb30c7785d34 - PacMan|m| - (built for Ubuntu-14.04-x86_64 on 2016-01-27T10:00:15.000)","branchName":"","buildDate":"2016-01-27T10:00:15.000","buildNumber":"4283","codeName":"PacMan|m|","hash":"395ff5e220ea7311adf3fca70960fb30c7785d34","releaseNumber":"1.7.0"},"description":"Version","status":"SUCCESS"}

   $ ./httpcli pullstream uri=rtmp://streaming.cityofboston.gov/live/cable localstreamname=mystream
   Received from EMS:
   {"data":{"audioCodecBytes":"","configId":1,"emulateUserAgent":"EvoStream Media Server (www.evostream.com) player","forceTcp":false,"httpProxy":"","isAudio":true,"keepAlive":true,"localStreamName":"mystream","operationType":1,"pageUrl":"","ppsBytes":"","rangeEnd":-1,"rangeStart":-2,"rtcpDetectionInterval":10,"sendRenewStream":false,"spsBytes":"","ssmIp":"","swfUrl":"","tcUrl":"","tos":256,"ttl":256,"uri":{"document":"cable","documentPath":"\/live\/","documentWithFullParameters":"cable","fullDocumentPath":"\/live\/cable","fullDocumentPathWithParameters":"\/live\/cable","fullParameters":"","fullUri":"rtmp:\/\/streaming.cityofboston.gov\/live\/cable","fullUriWithAuth":"rtmp:\/\/streaming.cityofboston.gov\/live\/cable","host":"streaming.cityofboston.gov","ip":"140.241.251.94","originalUri":"rtmp:\/\/streaming.cityofboston.gov\/live\/cable","parameters":{},"password":"","port":1935,"portSpecified":false,"scheme":"rtmp","userName":""}},"description":"Stream rtmp:\/\/streaming.cityofboston.gov\/live\/cable enqueued for pulling","status":"SUCCESS"}
   ```

## Downloads

- See the [download](https://github.com/EvoStream/evostream_addons/tree/master/crystal_samples/httpcli/download) directory for compiled binaries of httpcli.

## Development

- The source code is provided for demonstration purposes only. It can be found on GitHub:

  https://github.com/EvoStream/evostream_addons/tree/master/crystal_samples/httpcli

- Tweaks in httpcli/constants.cr

  - TRACE adjusts the console output for debugging
  - EMS_IP sets the IP address of the target EMS (the default is localhost)

- Build a binary for release (optional)
  ```bash
  $ crystal build httpcli.cr --release
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

