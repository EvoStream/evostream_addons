#
# EvoStream Media Server Extensions
# EvoStream, Inc.
# (c) 2016 by EvoStream, Inc. (support@evostream.com)
# Released under the MIT License
#

#
# telnet functions
#

require 'net/telnet'

module Telnet

  @@timeout = 30
  @@port = 1112

  def Telnet.initialize(settings)
    @theHost = nil
    # get new settings
    @@timeout = settings["timeout"] if (settings["timeout"] != nil)
    @@port = settings["port"] if (settings["port"] != nil)
    # actual settings
    settings["timeout"] = @@timeout
    settings["port"] = @@port
    p settings if $DEBUG
    settings
  end

  def open(ip, settings = {})
    initialize(settings)
    if ip == ""
      ip = "localhost"
    end
    @theHost = Net::Telnet::new("Host" => "#{ip}",
        "Timeout" => @@timeout,
        "Port" => @@port,
        #"Output_log" => "output.log",
        #"Dump_log" => "dump.log",
        "Telnetmode" => false,
        #"Waittime" => 0.1,
        "Prompt" => /[}]/n)
    raise "error opening telnet" if (@theHost == nil)
  rescue
    # error exit: show error message
    puts "-----error: #$!-----"
  end

  def close
    @theHost.close if (@theHost != nil)
    @theHost = nil
  end

  def host
    @theHost
  end

end
