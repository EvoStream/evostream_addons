# crems

crems is an app for demonstrating basic streaming functionality of EMS

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

