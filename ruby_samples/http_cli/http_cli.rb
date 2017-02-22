#!/usr/bin/ruby
#
# EvoStream Media Server Extensions
# EvoStream, Inc.
# (c) 2017 by EvoStream, Inc. (support@evostream.com)
# Released under the MIT License
#
# HTTP CLI tool - Send EMS API commands via HTTP, see JSON responses in pretty format
#
# Usage:
# ./http_cli.rb <ems_api_command_with_parameters>
#

require 'open-uri'
require 'base64'
require 'json'
require 'colorize'

load 'config_http.rb'

HTTP_CLI_PORT = 7777
HTTP_APIPROXY_PORT = 8888
ENABLE_LOG = false
TARGET_IP = SERVER_IP
TARGET_PASSWORD = HTTP_PASSWORD

def ems_http_cli(command, parameters)
  params = Base64.encode64(parameters)
  params.gsub!("\n", "")
  begin
    if HTTP_PASSWORD == ""
      url = "http://#{TARGET_IP}:#{HTTP_CLI_PORT}/#{command}?params=#{params}"
      p "| url = #{url}" if ENABLE_LOG
      response = open(url)
    else
      url = "http://#{TARGET_IP}:#{HTTP_APIPROXY_PORT}/apiproxy/#{command}%3Fparams%3D#{params}" #encode for apiproxy http
      p "| url = #{url}" if ENABLE_LOG
      response = open(url, http_basic_authentication: [HTTP_USERNAME, TARGET_PASSWORD])
    end
    text = ""
    response.each do |line|
      text += line
    end
    json = JSON.parse(text)
    puts JSON.pretty_generate(json)
    return json
  rescue
    puts "error: #$!" if ENABLE_LOG
    return nil
  end
end

def ems_command(cmd, verbose = true)
  response = ""
  puts "--API command: #{cmd}".colorize(:light_blue) if verbose
  parts = cmd.split
  command = parts[0]
  parts.delete_at(0)
  parameters = parts.join(' ')
  response = ems_http_cli(command, parameters)
  status = ""
  description = ""
  details = {}
  unless response.nil?
    description = response["description"]
    status = response["status"]
    textcolor = (status == "SUCCESS") ? :light_green : :light_red
    puts "--API response: #{status} (#{description})".colorize(textcolor) if verbose
    details = response["data"]
  end
  return status, details
end

parameters = ARGV.join(' ')
ems_command parameters

