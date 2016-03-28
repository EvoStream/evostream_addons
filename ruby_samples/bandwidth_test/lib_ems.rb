#
# EvoStream Media Server Extensions
# EvoStream, Inc.
# (c) 2016 by EvoStream, Inc. (support@evostream.com)
# Released under the MIT License
#

#
# control ems thru telnet using ems api commands
#

require 'net/telnet'
require 'rubygems'
require 'json'
require 'pp'

module Ems

  @@target_dir = "/var/www"
  @@record_path = "/var/www/record"

  # initialize ems settings
  def Ems.initialize(settings)
    # get new settings
    @@target_dir = settings["target_dir"] if (settings["target_dir"] != nil)
    @@record_path = settings["record_path"] if (settings["record_path"] != nil)
    # actual settings
    settings["target_dir"] = @@target_dir
    settings["record_path"] = @@record_path
    p settings if $DEBUG
    settings
  end

  # process ems api command
  # inputs:
  #   host - telnet host
  #   cmd - telnet command
  # outputs:
  #   status - response status: "SUCCESS" if no error, "FAIL" if error encountered
  #   details - command description if SUCCESS, error message if FAIL
  def command(host, cmd, verbose)
    response = ""
    puts "--telnet command: #{cmd}" if verbose
    text = ""
    response = ""
    host.cmd(cmd) do |str|
      response = response + str.to_s
      sleep 0.1
    end
    response.size.times do |i|
      if (RUBY_VERSION >= "1.9")
        validChar = ((i > 3) && (response[i] >= " ") && (response[i] <= "~"))
      else
        validChar = ((i > 3) && (response[i].chr >= " ") && (response[i].chr <= "~"))
      end
      if validChar
        if (RUBY_VERSION >= "1.9")
          text = text + response[i]
        else
          text = text + response[i].chr
        end
      end
    end
    result = JSON.parse(text)
    description = result["description"]
    status = result["status"]
    puts "  telnet response: #{status} (#{description})" if verbose
    details = result["data"]
    return status, details
  end

  # process ems api command in verbose mode
  # inputs:
  #   host - telnet host
  #   cmd - telnet command
  # outputs:
  #   status - response status: "SUCCESS" if no error, "FAIL" if error encountered
  #   details - command description if SUCCESS, error message if FAIL
  def commandVerbose(host, cmd)
    puts
    (status, details) = command(host, "#{cmd}", true)
    #raise "error on #{cmd.split[0]}" if (status != "SUCCESS")
    return status, details
  end
  
  # process ems api command in silent mode
  # inputs:
  #   host - telnet host
  #   cmd - telnet command
  # outputs:
  #   status - response status: "SUCCESS" if no error, "FAIL" if error encountered
  #   details - command description if SUCCESS, error message if FAIL
  def commandSilent(host, cmd)
    (status, details) = command(host, "#{cmd}", false)
    #raise "error on #{cmd.split[0]}" if (status != "SUCCESS")
    return status, details
  end

  def version(host)
    cmd = "version"
    (status, details) = commandVerbose(host, cmd)
    puts "  releaseNumber: #{details["releaseNumber"]}"
    puts "  buildDate: #{details["buildDate"]}"
    puts "  buildNumber: #{details["buildNumber"]}"
    puts "  codeName: #{details["codeName"]}"
    puts "  banner: #{details["banner"]}"
    version = details
  end

  def listStreams(host)
    cmd = "listStreams"
    (status, details) = commandVerbose(host, cmd)
    lastName = ""
    if (details != nil)
      puts "    #{details.size} stream(s) found."
      details.size.times do |i|
        printf("    id=%d, ", details[i]["uniqueId"])
        printf("type=%s, ", details[i]["type"])
        lastName = details[i]["name"]
        printf("name=%s, ", lastName)
        printf("ip=%s, ", details[i]["ip"])
        printf("port=%s\n", details[i]["port"])
        printf("      serverAgent=%s", details[i]["serverAgent"])
        printf("\n")
      end
      return lastName
    else
      puts "    No stream found."
      return ""
    end
  rescue
    puts "-----error: #$!-----"
    return ""
  end
  
  def getStreamsCount(host, verbose = true)
    cmd = "getStreamsCount"
    (status, details) = command(host, cmd, verbose)
    if (details != nil)
      count = details["count"]
      puts "    #{count} stream(s) total." if verbose
    else
      puts "    No stream." if verbose
    end
    return count
  end

  def getConnectionsCount(host, verbose = true)
    cmd = "getConnectionsCount"
    (status, details) = command(host, cmd, verbose)
    if (details != nil)
      count = details["count"]
      puts "    #{count} connections(s) total." if verbose
    else
      puts "    No connection." if verbose
    end
    return count
  end

  def listStreamsIds(host)
    cmd = "listStreamsIds"
    (status, details) = commandVerbose(host, cmd)
    if (details != nil)
      puts "    #{details.size} stream ID(s) found."
      details.size.times do |i|
        printf("%d ", details[i])
      end
      puts
    else
      puts "    No stream ID found."
    end
    return details
  end

  def getStreamInfo(host, id)
    cmd = "getStreamInfo id=#{id}"
    (status, details) = commandSilent(host, cmd)
    if (details != nil)
      printf("%s=", details["uniqueId"])
      printf("%s ", details["name"])
      streamType = details["type"]
      printf("[%s] ", streamType)
      printf("%s/%s ", details["video"]["codec"], details["audio"]["codec"])
      printf("%s:%s", details["nearIp"], details["nearPort"])
      case streamType[0].chr
        when "O"
          printf("==>")
        when "I"
          printf("<==")
        else
          printf("<=>")
      end
      printf("%s:%s(far)", details["farIp"], details["farPort"])
      printf("\n")
    end
    return details
  end

  def pullStream(host, uri, localStreamName = "test", keepAlive = 1, forceTcp = 0)
    cmd = "pullStream uri=#{uri} localStreamName=#{localStreamName} keepAlive=#{keepAlive} forceTcp=#{forceTcp}"
    (status, details) = commandVerbose(host, cmd)
  end

  def pushStream(host, uri, localStreamName = "test", targetStreamName = "target", keepAlive = 1)
    cmd = "pushStream uri=#{uri} localStreamName=#{localStreamName} targetStreamName=#{targetStreamName} keepAlive=#{keepAlive}"
    (status, details) = commandVerbose(host, cmd)
  end

  def record(host, localStreamName = "test", pathToFile = @@record_path, type = "mp4", keepAlive = 0, chunkLength = 0, waitForIdr = 1)
    cmd = "record localStreamName=#{localStreamName} pathToFile=#{pathToFile} type=#{type} keepAlive=#{keepAlive} chunkLength=#{chunkLength} waitForIdr=#{waitForIdr}"
    (status, details) = commandVerbose(host, cmd)
  end
  
  def createHlsStream(host, localStreamNames, targetFolder = @@target_dir, chunklength = 10, playlistlength = 30, keepalive = 1)
    cmd = "createHlsStream localStreamNames=#{localStreamNames} targetFolder=#{targetFolder} playlistType=appending groupName=hls cleanupDestination=1 chunkonidr=1 chunklength=#{chunklength} maxchunklength=#{(chunklength * 1.2).to_i} playlistlength=#{playlistlength} keepalive=#{keepalive}"
    (status, details) = commandVerbose(host, cmd)
  end

  def createHlsStreamEncrypted(host, localStreamNames, targetFolder = @@target_dir, chunklength = 10, keepAlive = 1)
    cmd = "createHlsStream localStreamNames=#{localStreamNames} targetFolder=#{targetFolder} playlistType=appending groupName=hlsaes staleretentioncount=16 cleanupDestination=1 chunkonidr=1 playlistlength=8 chunklength=#{chunklength} maxchunklength=#{(chunklength * 1.2).to_i} encryptStream=1 aesKeyCount=3 keepAlive=#{keepAlive}"
    (status, details) = commandVerbose(host, cmd)
  end

  def createMssStream(host, localStreamNames, targetFolder = @@target_dir, chunklength = 10, keepAlive = 1)
    cmd = "createMssStream localStreamNames=#{localStreamNames} targetFolder=#{targetFolder} playlistType=appending groupName=mss staleretentioncount=16 cleanupDestination=1 chunkonidr=1 playlistlength=8 chunklength=#{chunklength} maxchunklength=#{(chunklength * 1.2).to_i} keepAlive=#{keepAlive}"
    (status, details) = commandVerbose(host, cmd)
  end
  
  def createIngestPoint(host, privateName, publicName)
    cmd = "createIngestPoint privateStreamName=#{privateName} publicStreamName=#{publicName}"
    (status, details) = commandVerbose(host, cmd)
  end
  
  def listIngestPoints(host)
    cmd = "listIngestPoints"
    (status, details) = commandVerbose(host, cmd)
    if (details != nil)
      puts "    #{details.size} ingest point(s) found."
      details.size.times do |i|
        printf("    privateStreamName=%s, ", details[i]["privateStreamName"])
        printf("publicStreamName=%s, ", details[i]["publicStreamName"])      
        printf("\n")
      end
    else
      puts "    No ingest point found."
    end
  end

  def shutdownStream(host, streamName)
    puts "    shutting down stream name=#{streamName}"
    cmd = "shutdownStream localStreamName=#{streamName} permanently=1"
    (status, details) = commandSilent(host, cmd)
  end

  def shutdownLastStream(host)
    cmd = "listStreamsIds"
    (status, ids) = commandVerbose(host, cmd)
    lastid = 0
    lastname = ""
    if (ids != nil)
      ids.size.times do |k|
        cmd = "getStreamInfo id=#{ids[k]}"
        (status, details) = commandSilent(host, cmd)
        if (details != nil)
          lastid = ids[k]
          lastname = details["name"]
        end
      end
    end
    # shutdown last stream
    if lastid > 0
      puts "    shutting down stream id=#{lastid} name=#{lastname}"
      cmd = "shutdownStream id=#{lastid} permanently=1"
      (status, details) = commandSilent(host, cmd)
    else
      puts "no stream found, no stream shutdown"
    end
  end
  
  def shutdownPriorStream(host) #-todo: review
    cmd = "listStreams"
    (status, details) = commandVerbose(host, cmd)
    lastid = 0
    lastname = ""
    priorid = 0
    priorname = ""
    if (details != nil)
      # one or more stream(s) found
      details.size.times do |i|
        priorid = lastid
        priorname = lastname
        lastid = details[i]["uniqueId"]
        lastname = details[i]["name"]
        printf("    id=%d, ", lastid)
        printf("name=%s\n", lastname)
      end
      # shutdown stream before last
      if priorid > 0
        puts "shutting down stream id=#{priorid} name=#{priorname}"
        cmd = "shutdownStream id=#{priorid} permanently=1"
        (status, details) = commandVerbose(host, cmd)
      end
    end
  end
  
  def listConfig(host, verbose = true)
    cmd = "listConfig"
    (status, details) = command(host, cmd, verbose)
    lastId = 0
    if (details != nil)
      #puts JSON.pretty_generate(details)
      details.each do |key, value|
        printf("    %s: ", key) if verbose
        value.size.times do |i|
          lastId = value[i]["configId"]
          printf(" %d ", lastId) if verbose
        end
        printf("\n") if verbose
      end
      return lastId
    else
      puts "    No config found."
      return 0
    end
  rescue
    puts "-----error: #$!-----"
    return 0
  end

  def removeLastConfig(host, verbose = true)
    lastId = listConfig(host, verbose)
    # remove last config
    if lastId > 0
      puts "    removing last config id=#{lastId}"
      cmd = "removeConfig id=#{lastId}"
      (status, details) = commandSilent(host, cmd)
      return lastId
    else
      puts "no config found, nothing removed" if verbose
      return 0
    end
  end

  def shutdownServer(host)
    # step 1 to get key
    cmd = "shutdownServer"
    (status, details) = commandVerbose(host, cmd)
    if (details != nil)
      key = details["key"]
      printf("    key=%s\n", key)
      # step 2 to give key
      puts "  telnet command (part2)"
      puts "  no response expected as server should shutdown immediately"
      cmd = "shutdownServer key=#{key}"
      (status, details) = commandVerbose(host, cmd)
    end
  rescue  #-todo: review if necessary
    puts "-----error: #$!-----"
  end

end
