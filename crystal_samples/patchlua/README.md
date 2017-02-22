# crems

**patchlua** is a tool for programmatically modifying parameters in EMS configuration (LUA) files.


## Instructions

1. Build the binary

     ```bash
     $ crystal build patchlua.cr --release
     ```
     The output file will be `patchlua`.

2. Modify an EMS configuration file

     ```bash
     $ ./patchlua config.lua update url http://111.222.33.44:4000/evowebservices/
     ```
     The output file will be `config.txt`.


## Development

- The source code is provided for demonstration purposes only. It can be found on GitHub:
https://github.com/EvoStream/evostream_addons/tree/master/crystal_samples/patchlua


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

