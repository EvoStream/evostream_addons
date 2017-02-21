#!/usr/bin/env ruby
#
# EvoStream Media Server Extensions
# EvoStream, Inc.
# (c) 2017 by EvoStream, Inc. (support@evostream.com)
# Released under the MIT License
#
# Restart EMS, ensure EWS running
#

`sudo killall -9 evostreamms`
command = "curl -m 0.5 -s -S http://localhost:8888/crossdomain.xml"
5.times do
  puts "Restarting EMS ..."
  `sudo service evostreamms restart`
  sleep 10
  response = `#{command}`
  exit 0 if /cross-domain-policy/ =~ response
end
puts "EWS not started!"
exit 1
