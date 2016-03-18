# rbems

rbems is an app for demonstrating basic streaming functionality of EMS

## Installation

1. EMS is required to run with the code.
   - [Installation of EMS on Ubuntu](http://docs.evostream.com/ems_quick_start_guide/quick_start_guide_for_linux#baptyum-installation)

2. Ruby language is required to run the code.
   - Installation of Ruby on Ubuntu

     ```sh
     $ sudo apt-add-repository ppa:brightbox/ruby-ng
     $ sudo apt-get update
     $ sudo apt-get install ruby2.2 ruby2.2-dev
     ```

3. VLC is required to play streams.
   - Installation of VLC on Ubuntu:

     ```sh
     $ sudo apt-get install vlc
     ```

## Usage

1. Start EMS

   ```sh
   $ sudo service evostreamms start
   ```

2. Run rbems

   ```sh
   $ ruby rbems.rb
   ```

## Development

- The source code is provided for demonstration purposes only. It can be found on GitHub:

  https://github.com/EvoStream/evostream_addons/tree/master/ruby_samples/rbems

- Tweaks in src/rbems/constants.rb

  - TRACE adjusts the console output for debugging
  - URIS_LIVE sets the source stream URI

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

