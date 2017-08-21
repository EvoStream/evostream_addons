#
# EvoStream Media Server Extensions
# EvoStream, Inc.
# (c) 2017 by EvoStream, Inc. (support@evostream.com)
# Released under the MIT License
#

require "yaml"
require "./lib/*"

module HttpCli
  ems_settings : Array(YAML::Any) | Nil
  ems_settings = YAML.parse_all(File.read(SETTINGS_FILE)) if File.exists?(SETTINGS_FILE)
  ems = Ems.new(ems_settings)
  parameters = ARGV.join(" ")
  parameters = "version" if parameters.size < 3
  Ems.send_ems(parameters)
end
