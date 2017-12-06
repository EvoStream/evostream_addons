# evocli

**evocli** is an app for sending API commands to the EMS 2.0.0 through the command line. The EMS may be on a local or on a remote server. Commands are sent via HTTP. To send HTTP commands securely, the EWS should be configured as follows:

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

## Installation

1. EMS 2.0.0 or later is required to run with this code. EMS 1.7.1 or earlier is not yet supported.
   - [Installing EMS 2.0.0 on Windows](http://docs.evostream.com/2.0/home_quickstartguidewindows.html)
   - [Installing of EMS 2.0.0 on Linux](http://docs.evostream.com/2.0/home_quickstartguidelinux.html)

2. Go language is required to build the binary (or run from source).
   - [Installation/usage of Go on Windows/Linux/macOS](http://golang.org/dl)

## Setup

1. Modify the settings file, "settings-evocli.yml", for your target EMS configuration.

   ```
   {
      "ip": "127.0.0.1",
      "port": 8888,
      "user": "username",
      "pass": "password"
   }
   ```

   Set the parameter "ip" to the IP address of the EMS ("127.0.0.1" is the default; this is for local EMS).

   Set the parameter "port" to the port number of the EWS (8888 is the default).

   Set the parameter "user" to the username for HTTP API ("username" is the default).

   Set the parameter "pass" to the password for HTTP API ("password" is the default).

2. Start the EMS

   - [Starting EMS 2.0.0 on Windows](http://docs.evostream.com/2.0/home_quickstartguidewindows.html)
   - [Starting EMS 2.0.0 on Linux](http://docs.evostream.com/2.0/home_quickstartguidelinux.html)

3. Build evocli

   Windows:
   ```
   > cd evostream_addons\go_samples\evocli\
   > go build evocli.go
   ```
   
   Linux:
   ```
   $ cd ~/evostream_addons/go_samples/evocli/
   $ go build evocli.go
   ```
   
4. Run evocli
   
   Windows:
   ```
   > evocli.exe version
   ==>
   {"data":{"banner":"EvoStream Media Server (www.evostream.com) version 2.0.0 build 5580 with hash: 2b7379cdfdc11a3fcbb3b02c37d6eb852b254806 on branch: release\/2.0.0\/main - QBert - (built for Microsoft Windows 10 Pro-10.0.14393-x86_64 on 2017-12-05T10:11:36.000)","branchName":"release\/2.0.0\/main","buildDate":"2017-12-05T10:11:36.000","buildNumber":"5580","codeName":"QBert","hash":"2b7379cdfdc11a3fcbb3b02c37d6eb852b254806","releaseNumber":"2.0.0"},"description":"Version","status":"SUCCESS"}
   ```

   Linux:
   ```
   $ ./evocli version
   ==>
   {"data":{"banner":"EvoStream Media Server (www.evostream.com) version 2.0.0 build 5580 with hash: 2b7379cdfdc11a3fcbb3b02c37d6eb852b254806 on branch: release\/2.0.0\/main - QBert - (built for Microsoft Windows 10 Pro-10.0.14393-x86_64 on 2017-12-05T10:11:36.000)","branchName":"release\/2.0.0\/main","buildDate":"2017-12-05T10:11:36.000","buildNumber":"5580","codeName":"QBert","hash":"2b7379cdfdc11a3fcbb3b02c37d6eb852b254806","releaseNumber":"2.0.0"},"description":"Version","status":"SUCCESS"}
   ```

## Development

- The source code is provided for demonstration purposes only. It can be found on GitHub:

  https://github.com/EvoStream/evostream_addons/tree/master/go_samples/evocli

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
