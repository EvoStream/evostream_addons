# evocli

**evocli** is an app for sending API commands to the EMS 2.0.0 from the command line. The EMS may be on a local or on a remote server. Commands are sent via HTTP.

## Installation

1. EMS 2.0.0 or later is required to run with this code. EMS 1.7.1 or earlier is not yet supported.
   - [Installing EMS 2.0.0 on Windows](http://docs.evostream.com/2.0/home_quickstartguidewindows.html)
   - [Installing of EMS 2.0.0 on Linux](http://docs.evostream.com/2.0/home_quickstartguidelinux.html)

1. Go language is required to build the binary or run from source (optional if next step is done).
   - [Installation/usage of Go on Windows/Linux/macOS](http://golang.org/dl)

1. Alternatively, instead of installing Go to build the binary, a pre-built binary can be downloaded from here:
   - [For Ubuntu 16.04 64-bit : evocli-ubuntu1604-amd64.tgz](https://github.com/EvoStream/evostream_addons/tree/master/go_samples/evocli/releases/evocli-ubuntu1604-amd64.tgz)
   - [For Windows 10 64-bit : evocli-windows10-amd64.zip](https://github.com/EvoStream/evostream_addons/tree/master/go_samples/evocli/releases/evocli-windows10-amd64.zip)
   - [For OSX 10 64-bit : evocli-osx10-amd64.tgz](https://github.com/EvoStream/evostream_addons/tree/master/go_samples/evocli/releases/evocli-osx10-amd64.tgz)

## Setup

1. Modify the EMS configuration file, `webconfig.json`, as follows:

   For EMS 2.0.0 and newer versions, edit the "apiProxy" section as shown below:
   ```json
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
   Set "address" to the IP address of the EMS. Set "userName" and "password" to the desired username and password.

   IMPORTANT: Restart the EMS after changing any setting in the EMS configuration file.

1. Start the EMS

   - [Starting EMS 2.0.0 on Windows](http://docs.evostream.com/2.0/home_quickstartguidewindows.html)
   - [Starting EMS 2.0.0 on Linux](http://docs.evostream.com/2.0/home_quickstartguidelinux.html)

1. Build `evocli` (optional if the binary was downloaded)

   Note: You can skip this step if the pre-built binary was downloaded during [installation](https://github.com/EvoStream/evostream_addons/tree/master/go_samples/evocli/README.md#installation).

   After cloning the `evostream_addons` source code from GitHub to your local drive, go to the `evocli` directory and build the binary.

   Windows:
   ```bash
   cd evostream_addons\go_samples\evocli\
   go get github.com/joshbetz/config
   go build
   ```
   This will create the binary file `evocli.exe`.

   Linux:
   ```bash
   cd ~/evostream_addons/go_samples/evocli/
   go get github.com/joshbetz/config
   go build
   ```
   This will create the binary file `evocli`.

   Note: The command `go get github.com/joshbetz/config` is only required for fresh installs or builds.

1. Modify the `evocli` settings file, `settings-evocli.json`, for your target EMS configuration.
   ```json
   {
      "ip": "127.0.0.1",
      "port": 8888,
      "user": "username",
      "pass": "password",
      "pretty": 1,
      "debug": 1
   }
   ```
   - Set the parameter "ip" to the IP address of the EMS ("127.0.0.1" is the default; this is for local EMS).
   - Set the parameter "port" to the port number of the EWS (8888 is the default).
   - Set the parameter "user" to the username for HTTP API ("username" is the default).
   - Set the parameter "pass" to the password for HTTP API ("password" is the default).
   - Set the parameter "pretty" to 0 for plain JSON output, or 1 for pretty JSON output (1 is the default).
   - Set the parameter "debug" to 0 to disable all logs, 1 to enable error logs, or 2 to enable error and info logs (1 is the default).

   Note: If the settings file, `settings-evocli.json`, is missing, default settings will be used.

## Usage

The settings file `settings-evocli.json` should be in the current folder when running the `evocli` command. Below are some examples of sending EMS API commands via HTTP using `evocli`.

### Example 1: Check the EMS version

- Windows:
```bash
evocli.exe version
```
or just
```bash
evocli.exe
```

- Linux:
```bash
./evocli version
```
or just
```bash
./evocli
```

- Plain output: The EMS output is shown in plain JSON when "pretty" is set to 0 in the settings file:
```json
{"data":{"banner":"EvoStream Media Server (www.evostream.com) version 2.0.0 build 5580 with hash: 2b7379cdfdc11a3fcbb3b02c37d6eb852b254806 on branch: release\/2.0.0\/main - QBert - (built for Microsoft Windows 10 Pro-10.0.14393-x86_64 on 2017-12-05T10:11:36.000)","branchName":"release\/2.0.0\/main","buildDate":"2017-12-05T10:11:36.000","buildNumber":"5580","codeName":"QBert","hash":"2b7379cdfdc11a3fcbb3b02c37d6eb852b254806","releaseNumber":"2.0.0"},"description":"Version","status":"SUCCESS"}
```

- Pretty output: The EMS output is shown in prettified JSON when "pretty" is set to 1 in the settings file:
```json
{
    "data": {
        "banner": "EvoStream Media Server (www.evostream.com) version 2.0.0 build 5550 with hash: eab81ed5ed39d3794e77408249f51817142b90ba - QBert - (built for Ubuntu-16.04-x86_64 on 2017-10-16T02:10:21.000)",
        "branchName": "",
        "buildDate": "2017-10-16T02:10:21.000",
        "buildNumber": "5550",
        "codeName": "QBert",
        "hash": "eab81ed5ed39d3794e77408249f51817142b90ba",
        "releaseNumber": "2.0.0"
    },
    "description": "Version",
    "status": "SUCCESS"
}
```

### Example 2: Pull a stream to EMS

- Windows:
```bash
evocli.exe pullstream uri=rtmp://localhost/live/bunny.mp4 localstreamname=bunny
```

- Linux:
```bash
./evocli pullstream uri=rtmp://localhost/live/bunny.mp4 localstreamname=bunny
```

- Output: The EMS output is shown in prettified JSON when "pretty" is set to 1 in the settings file:
```json
{
    "data": {
        "audioCodecBytes": "",
        "configId": 2,
        "emulateUserAgent": "EvoStream Media Server (www.evostream.com) player",
        "forceTcp": false,
        "httpProxy": "",
        "httpStreamType": "ts",
        "isAudio": true,
        "keepAlive": true,
        "localStreamName": "bunny",
        "operationType": 1,
        "pageUrl": "",
        "ppsBytes": "",
        "rangeEnd": -1,
        "rangeStart": -2,
        "rtcpDetectionInterval": 10,
        "saveToConfig": true,
        "sendDummyPayload": false,
        "sendRenewStream": false,
        "spsBytes": "",
        "ssmIp": "",
        "swfUrl": "",
        "tcUrl": "",
        "tos": 256,
        "ttl": 256,
        "uri": {
            "document": "bunny.mp4",
            "documentPath": "\/live\/",
            "documentWithFullParameters": "bunny.mp4",
            "fullDocumentPath": "\/live\/bunny.mp4",
            "fullDocumentPathWithParameters": "\/live\/bunny.mp4",
            "fullParameters": "",
            "fullUri": "rtmp:\/\/localhost\/live\/bunny.mp4",
            "fullUriWithAuth": "rtmp:\/\/localhost\/live\/bunny.mp4",
            "generatedPort": 0,
            "host": "localhost",
            "ip": "127.0.0.1",
            "originalUri": "rtmp:\/\/localhost\/live\/bunny.mp4",
            "parameters": {},
            "password": "",
            "port": 1935,
            "portSpecified": false,
            "scheme": "rtmp",
            "userName": ""
        },
        "videoSourceIndex": "high"
    },
    "description": "Stream rtmp:\/\/localhost\/live\/bunny.mp4 enqueued for pulling",
    "status": "SUCCESS"
}
```

### Example 3: List the EMS configuration

- Windows:
```bash
evocli.exe listconfig
```

- Linux:
```bash
./evocli listconfig
```

- Output: The EMS output is shown in prettified JSON when "pretty" is set to 1 in the settings file:
```json
{
    "data": {
        "dash": [],
        "hds": [],
        "hls": [],
        "metalistener": [],
        "mss": [],
        "process": [],
        "pull": [
            {
                "audioCodecBytes": "",
                "configId": 2,
                "emulateUserAgent": "EvoStream Media Server (www.evostream.com) player",
                "forceTcp": false,
                "httpProxy": "",
                "httpStreamType": "ts",
                "isAudio": true,
                "keepAlive": true,
                "localStreamName": "bunny",
                "operationType": 1,
                "pageUrl": "",
                "ppsBytes": "",
                "rangeEnd": -1,
                "rangeStart": -2,
                "rtcpDetectionInterval": 10,
                "saveToConfig": true,
                "sendDummyPayload": false,
                "sendRenewStream": false,
                "spsBytes": "",
                "ssmIp": "",
                "status": {
                    "current": {
                        "code": 0,
                        "description": "Streaming",
                        "timestamp": 1512641007,
                        "uniqueStreamId": 7
                    },
                    "previous": {
                        "code": 3,
                        "description": "Connected",
                        "timestamp": 1512641007,
                        "uniqueStreamId": 0
                    }
                },
                "swfUrl": "",
                "tcUrl": "",
                "tos": 256,
                "ttl": 256,
                "uri": "rtmp:\/\/localhost\/live\/bunny.mp4",
                "videoSourceIndex": "high"
            }
        ],
        "push": [],
        "record": [],
        "webrtc": []
    },
    "description": "Run-time configuration",
    "status": "SUCCESS"
}
```

### Reference for EMS API Commands

- For details on EMS API commands, please refer to the following document:

  [http://docs.evostream.com/2.0/api_overview.html](http://docs.evostream.com/2.0/api_overview.html)

## Development

- The source code is provided for demonstration purposes only. It can be found on GitHub:

  [https://github.com/EvoStream/evostream_addons/tree/master/go_samples/evocli](https://github.com/EvoStream/evostream_addons/tree/master/go_samples/evocli)

## Contributing

1. Fork it ( [https://github.com/EvoStream/evostream_addons/fork](https://github.com/EvoStream/evostream_addons/fork) )
1. Create your feature branch (git checkout -b my-new-feature)
1. Commit your changes (git commit -am 'Add some feature')
1. Push to the branch (git push origin my-new-feature)
1. Create a new Pull Request

## Contributors

- [EvoStream](https://github.com/EvoStream)  - creator, maintainer

## License

- [MIT](LICENSE.md)
