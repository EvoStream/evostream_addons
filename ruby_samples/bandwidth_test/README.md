# BANDWIDTH TEST

This bandwidth test tool uses an EMS client to pull multiple streams from an EMS server.
Statistics are gathered at the server while the client ramps up/down the number of streams pulled from the server.

## PREPARATION

Please refer to [prepare.md](prepare.md) for setup / preparation steps.
Various settings such as IP address, source stream and ramp profile, as well as bandwidth calculations, are explained there.

## USAGE

A. SERVER SIDE

   1. If the EMS is not running, start it.

   2. Run `pullscript.rb`.

      ```bash
      $ ruby pullscript.rb
      ```

   3. Press [7] to list config.

   4. Press [8] to remove config entries.

   5. Repeat the previous step until all config entries are removed.

   6. Press [1] to pull 1 stream.

   7. Press [c] to start capturing statistics.

   8. Wait for at least 3 lines of statistics.

B. CLIENT SIDE

   1. If the EMS is not running, start it.

   2. Run `pullscript.rb`.

      ```bash
      $ ruby pullscript.rb
      ```

   3. Press [3] to start ramping.

   4. Wait for ramp up and ramp down to finish.

   5. Press [x] to exit.
   
C. SERVER SIDE

   1. Wait for the client to finish ramping down.

   2. Press [x] to exit.

   3. Get the results from file `rtmp-##########.csv` where `##########` is the timestamp.

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

