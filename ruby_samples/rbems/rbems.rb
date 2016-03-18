$LOAD_PATH.unshift File.dirname(__FILE__)
#$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))
#
# EvoStream Media Server Extensions
# EvoStream, Inc.
# (c) 2016 by EvoStream, Inc. (support@evostream.com)
# Released under the MIT License
#

require "rbems/constants.rb"
require "rbems/ems.rb"
require "rbems/player.rb"
require "rbems/streams.rb"

module Rbems
  puts "rbems version #{VERSION}"
  send_ems("version")
  send_ems("pullstream uri=#{URIS_LIVE[0]} localstreamname=#{STREAM_NAME}")
  uri = "rtmp://#{EMS_IP}/live/#{STREAM_NAME}"
  check_live(uri)
  play(uri, SEC_PLAY)
  send_ems("liststreams")
  send_ems("shutdownstream localstreamname=#{STREAM_NAME} permanently=1")
  send_ems("liststreams")
end
