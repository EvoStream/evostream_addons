#!/usr/bin/env ruby
#
# EvoStream Media Server Extensions
# EvoStream, Inc.
# (c) 2017 by EvoStream, Inc. (support@evostream.com)
# Released under the MIT License
#
# Register with streams manager
#
# sm-register.rb <sm_ip_address> <password> <origin/edge> <apiproxy>
#

def get_ip_address
  items = `ifconfig | grep "inet addr"`.split
  addresses = []
  items.each do |item|
    addresses << item if item =~ /addr:/
  end
  ip = ""
  addresses.each do |address|
    ip = address.split(':')[1]
    if ip != '127.0.0.1'
      break
    end
  end
  ip
end

def get_unique_id
  result = `sudo dmidecode | grep UUID | sed 's/.*UUID: //I'`
  result.chomp
end

# curl -H "Content-Type: application/json" -d '{"id":1,"payload":{"PID":4792,"banner":"EvoStream Media Server (www.evostream.com) version 1.7.1 build 4497 with hash: b62c38564f9e5cee5f76ea30ca03d3a25fdc6d87 on branch: feature\/azure_license - PacMan|m| - (built for Ubuntu-16.04-x86_64 on 2016-08-11T10:22:40.000)","branchName":"feature\/azure_license","buildDate":"2016-08-11T10:22:40.000","buildNumber":"4497","codeName":"PacMan|m|","customData":null,"hash":"b62c38564f9e5cee5f76ea30ca03d3a25fdc6d87","releaseNumber":"1.7.1"},"processId":4792,"timestamp":1475233878,"type":"serverStarted"}' http://191.235.94.48:4000/evowebservices/

sm_ip = "127.0.0.1"
if ARGV.size >= 1
  sm_ip = ARGV[0]
end
password = "Pa$$word1234"
if ARGV.size >= 2
  password = ARGV[1]
end
type = "origin"
if ARGV.size >= 3
  type = ARGV[2]
end
apiproxy = "apiproxy"
if ARGV.size >= 4
  apiproxy = ARGV[3]
end

uuid = get_unique_id
puts "uuid = #{uuid}"
puts "sm_ip = #{sm_ip}"
vm_ip = get_ip_address
puts "vm_ip = #{vm_ip}"
puts "password = #{password}"
puts "type = #{type}"
puts "apiproxy = #{apiproxy}"
json = "{\"id\":0,\"localIp\":\"#{vm_ip}\",\"payload\":{\"PID\":1111,\"UUID\":\"#{uuid}\",\"password\":\"#{password}\",\"serverType\":\"#{type}\",\"apiproxy\":\"#{apiproxy}\"},\"processId\":1111,\"timestamp\":1476171111,\"type\":\"vmCreated\"}"
url = "http://#{sm_ip}:4000/evowebservices/"
puts "url = #{url}"
command = "curl -m 0.5 -s -S -H \"Content-Type: application/json\" -d '#{json}' #{url}"
puts "command:\n#{command}"
response = `#{command}`
ok = response.size > 0
puts "#{response}\nOK" if ok
