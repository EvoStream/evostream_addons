#
# EvoStream Media Server Extensions
# EvoStream, Inc.
# (c) 2017 by EvoStream, Inc. (support@evostream.com)
# Released under the MIT License
#

require "./lib/*"

module HttpCli
  parameters = ARGV.join(" ")
  send_ems(parameters)
end
