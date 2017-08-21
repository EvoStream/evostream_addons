#
# EvoStream Media Server Extensions
# EvoStream, Inc.
# (c) 2017 by EvoStream, Inc. (support@evostream.com)
# Released under the MIT License
#

require "base64"
require "json"
require "yaml"
require "colorize"

module HttpCli

  class Ems

    @@version : String = "0.0.0"
    @@ip : String = "127.0.0.1"
    @@port : String = "7777"
    @@username : String = "username"
    @@password : String = "password"
    @@domain : String = "apiproxy"

    def initialize(settings : Array(YAML::Any) | Nil)
      if settings
        @@version = settings[0]["version"].to_s
        @@ip = settings[0]["ip"].to_s
        @@port = settings[0][@@version]["port"].to_s
        if @@version != "0.0.0"
          @@username = settings[0]["username"].to_s
          @@password = settings[0]["password"].to_s
          @@domain = settings[0]["domain"].to_s
        end
      else
        puts "-- Settings file (#{SETTINGS_FILE}) is missing! Using default settings. --".colorize(:light_red)
      end
    end

    def self.send_ems(command)
      puts "Send to EMS '#{command}'".colorize(:blue) if TRACE > 0
      parts = command.split(" ")
      cmd = parts[0]
      parts.delete_at(0)
      params = Base64.encode(parts.join(" ")).delete('\n')
      suffix = ""
      if @@version == "0.0.0"
        suffix = "?params=#{params}" if parts.size > 0
        url = "http://#{@@ip}:#{@@port}/#{cmd}#{suffix}"
      elsif @@version == "1.7.1"
        suffix = "%3fparams=#{params}" if parts.size > 0
        url = "http://#{@@username}:#{@@password}@#{@@ip}:#{@@port}/#{@@domain}/#{cmd}#{suffix}"
      elsif @@version == "2.0.0"
        suffix = "?params=#{params}" if parts.size > 0
        url = "http://#{@@username}:#{@@password}@#{@@ip}:#{@@port}/#{@@domain}/#{cmd}#{suffix}"
      else
        url = "-- Invalid version (#{@@version})! Should be 0.0.0, 1.7.1, or 2.0.0. --".colorize(:light_red)
      end
      puts "Sent via HTTP '#{url}'".colorize(:blue) if TRACE > 1
      text = `curl -s #{url}`
      json = {} of JSON::Any => JSON::Any
      begin
        json = JSON.parse(text)
        puts "Received from EMS:".colorize(:blue) if TRACE > 0
        puts text if TRACE == 1
        puts json.to_pretty_json if TRACE > 1
      rescue ex
        puts "Error: #{ex.message}".colorize(:light_red) if TRACE > 1
        puts "No response from EMS! Please check if the EMS at #{@@ip} is running!".colorize(:light_red)
      end
      json
    end
  end

end
