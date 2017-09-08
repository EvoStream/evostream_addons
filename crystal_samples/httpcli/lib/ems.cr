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
    @@version = "0.0.0"
    @@ip = "127.0.0.1"
    @@port = "7777"
    @@username = "username"
    @@password = "password"
    @@domain = "apiproxy"
    @@verbosity = 2

    def initialize(settings : Array(YAML::Any) | Nil)
      if !settings
        puts_error "No settings file '#{SETTINGS_FILE}' in current directory! Using default settings." if @@verbosity > 1
        return
      end
      begin
        @@verbosity = settings[0]["verbosity"].to_s.to_i
        @@version = settings[0]["version"].to_s
        @@ip = settings[0]["ip"].to_s
        @@port = settings[0][@@version]["port"].to_s
        if @@version != "0.0.0"
          @@username = settings[0]["username"].to_s
          @@password = settings[0]["password"].to_s
          @@domain = settings[0]["domain"].to_s
        end
      rescue ex
        puts_error "Error: #{ex.message}" if @@verbosity > 2
        puts_error "Bad settings file '#{SETTINGS_FILE}' in current directory! Using default settings." if @@verbosity > 1
        return
      end
    end

    def self.send_ems(command)
      puts_info "Sent to EMS: '#{command}'" if @@verbosity > 1
      parts = command.split(" ")
      cmd = parts[0]
      parts.delete_at(0)
      params = Base64.encode(parts.join(" ")).delete('\n')
      suffix = ""
      url = ""
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
        puts_error "Invalid version (#{@@version})! Should be 0.0.0, 1.7.1, or 2.0.0." if @@verbosity > 1
      end
      puts_info "Sent via HTTP '#{url}'" if @@verbosity > 2
      text = `curl -s #{url}`
      json = {} of JSON::Any => JSON::Any
      begin
        json = JSON.parse(text)
        puts_info "Received from EMS:" if @@verbosity > 1
        case @@verbosity
        when 0
          puts text.chomp
        else
          puts json.to_pretty_json
        end
      rescue ex
        puts_error "Error: #{ex.message}" if @@verbosity > 2
        puts_error "No response from EMS! Please check if the EMS at #{@@ip} is running!" if @@verbosity > 1
      end
      json
    end
  end
end
