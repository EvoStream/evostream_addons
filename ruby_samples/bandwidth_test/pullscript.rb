#!/usr/bin/ruby
#
# EvoStream Media Server Extensions
# EvoStream, Inc.
# (c) 2016 by EvoStream, Inc. (support@evostream.com)
# Released under the MIT License
#

#
# bandwidth test tool for client & server EMS
#

# gems & modules
require 'rubygems'
require 'json'
require 'pp'
require 'timeout'

require './lib_telnet'
require './lib_ems'
require './lib_utils'
require './class_usage'

include Telnet
include Ems
include Utils

# general settings
REMOTE_IP = "192.168.2.46"
LOCAL_IP = "localhost"
INTERFACE = "eth0"
NAME_EMS = "evostreamms"
# capture settings
SAMPLE_PERIOD = 10
SAMPLE_PORT = 1935 #rtmp
FILE_PREFIX = "rtmp"
# ramp test settings
RAMP_STEPS = 2 #48
RAMP_PULL_COUNT = 5 #50
RAMP_STEP_DELAY = 20
RAMP_PEAK_TIMES = 8
# pull settings
PULL_FORCE_TCP = 1
PULL_KEEP_ALIVE = 1
IN_STREAM_NAME = "mystream"
# push setting
OUT_URI = "rtmp://#{REMOTE_IP}/live"
OUT_STREAM_NAME = "test"
# stream sources
IN_URI_RAMP = "rtmp://#{REMOTE_IP}/live/#{IN_STREAM_NAME}"
IN_URI = "rtmp://localhost/vod/sintel-1h-720p.mp4"
# record settings
TARGET_DIR = "/tmp"
RECORD_PATH = "/tmp/record"
RECORD_TYPE = "mp4"

@threadRamp = nil
@threadCapture = nil
@stopCapture = false
@stopRamp = false
@streamCount = 0

def getStreamCountAtPort(port)
  count = `netstat -tan|grep ESTABLISHED|grep :#{port}|wc -l`.strip.to_i
end

def rampRecordTest
  puts "-- ramp started --"
  @stopRamp = false
  # ramp up
  tstart = Time.now
  for rampNo in 1..RAMP_STEPS do
    puts "ramp up ##{rampNo} of #{RAMP_STEPS} (x#{RAMP_PULL_COUNT} streams) start"
    for i in 1..RAMP_PULL_COUNT do
      Ems.pullStream(Telnet.host, IN_URI_RAMP, "#{IN_STREAM_NAME}#{'%02d'%rampNo}-#{'%02d'%i}", PULL_KEEP_ALIVE, PULL_FORCE_TCP)
    end
    totalSecLeft = RAMP_STEP_DELAY * (RAMP_STEPS * 2 - rampNo + RAMP_PEAK_TIMES)
    min = totalSecLeft / 60
    sec = totalSecLeft - 60 * min
    puts "ramp up ##{rampNo} of #{RAMP_STEPS} (x#{RAMP_PULL_COUNT} streams) end -- #{'%02d'%min}:#{'%02d'%sec} min:sec left"
    tstep = tstart + RAMP_STEP_DELAY * rampNo
    while Time.now < tstep do
      sleep 0.2
      break if @stopRamp
    end
    break if @stopRamp
  end
  # ramp peak
  sleep RAMP_STEP_DELAY * RAMP_PEAK_TIMES
  # ramp down
  tstart = Time.now
  for rampNo in 1..RAMP_STEPS do
    puts "ramp down ##{RAMP_STEPS - rampNo + 1} of #{RAMP_STEPS} (x#{RAMP_PULL_COUNT} streams) start"
    for i in 1..RAMP_PULL_COUNT do
      Ems.shutdownStream(Telnet.host, "#{IN_STREAM_NAME}#{'%02d'%rampNo}-#{'%02d'%i}")
    end
    totalSecLeft = RAMP_STEP_DELAY * (RAMP_STEPS - rampNo + 1)
    min = totalSecLeft / 60
    sec = totalSecLeft - 60 * min
    puts "ramp down ##{RAMP_STEPS - rampNo + 1} of #{RAMP_STEPS} (x#{RAMP_PULL_COUNT} streams) end -- #{'%02d'%min}:#{'%02d'%sec} min:sec left"
    tstep = tstart + RAMP_STEP_DELAY * rampNo
    while Time.now < tstep do
      sleep 0.2
      break if @stopRamp
    end
    puts "ramp down ##{RAMP_STEPS - rampNo + 1} of #{RAMP_STEPS} (x#{RAMP_PULL_COUNT} streams) end"
  end
  puts "-- ramp done --"
end

def captureStats
  puts "-- capture started --"
  @stopCapture = false
  @streamCount = 0
  usages = Usage.new({"name_ems" => NAME_EMS, "quiet_mode" => true})
  timeStamp = Time.now.to_i
  tsample = Time.now
  begin
    elapsedSec = Time.now.to_i - timeStamp
    memUsages = usages.getMemUsages
    cpuUsages = usages.getCpuUsages
    bwUsages = usages.getBandwidthUsages(elapsedSec, INTERFACE)
    @streamCount = getStreamCountAtPort(SAMPLE_PORT)
    usages.saveStatistics("#{FILE_PREFIX}-#{timeStamp}.csv", elapsedSec, @streamCount, cpuUsages, memUsages, bwUsages)
    verbose = (@threadRamp == nil)
    if verbose
      printf "\n\r#{elapsedSec} sec, #{@streamCount} streams, "
      printf " #{cpuUsages[cpuUsages.size - 1]}%% cpu, #{memUsages[memUsages.size - 1]}%% mem, "
      printf " #{bwUsages[bwUsages.size - 1]} kbps"
    end
    tsample += SAMPLE_PERIOD
    while Time.now < tsample do
      sleep 0.2
      break if @stopCapture
    end
  end until @stopCapture
  puts "-- capture done --"
end

def stopRamp
  puts ">>> stopping ramp ..."
  @stopRamp = true
  sleep(5)
  @threadRamp.join if @threadRamp != nil
  Thread.kill(@threadRamp) if @threadRamp != nil
  @threadRamp = nil
  puts ">>> stopping ramp done"
end

def stopCapture
  puts ">>> stopping capture ..."
  @stopCapture = true
  sleep(5)
  @threadCapture.join if @threadCapture != nil
  Thread.kill(@threadCapture) if @threadCapture != nil
  @threadCapture = nil
  puts ">>> stopping capture done"
end

def showSettings
  puts
  puts "TEST SETTINGS:"
  puts "SAMPLE_PERIOD = #{SAMPLE_PERIOD}"
  puts "RAMP_STEPS = #{RAMP_STEPS}"
  puts "RAMP_PULL_COUNT = #{RAMP_PULL_COUNT}"
  puts "RAMP_STEP_DELAY = #{RAMP_STEP_DELAY}"
  puts "RAMP_PEAK_TIMES = #{RAMP_PEAK_TIMES}"
  puts "RECORD_PATH = #{RECORD_PATH}"
  puts "RECORD_TYPE = #{RECORD_TYPE}"
  puts "PULL_FORCE_TCP = #{PULL_FORCE_TCP}"
  puts "PULL_KEEP_ALIVE = #{PULL_KEEP_ALIVE}"
end

begin
  #$DEBUG = true
  puts
  puts "-----Begin [#{LOCAL_IP}]-----"
  Ems.initialize({"target_dir" => TARGET_DIR, "record_path" => RECORD_PATH})
  Telnet.open("")
  raise "error opening telnet" if (Telnet.host == nil)
  key = ' '
  begin
    case key.upcase
      when 'C'
        if @threadCapture == nil
          @threadCapture = Thread.new { captureStats }
        else
          stopCapture
        end
      when 'L'
        ids = Ems.listStreamsIds(Telnet.host)
        puts "--getStreamInfo"
        if (ids != nil)
          ids.size.times do |i|
            printf("%d) ", i + 1)
            Ems.getStreamInfo(Telnet.host, ids[i])
            sleep 0.02
          end
        end
      when 'S'
        Ems.shutdownLastStream(Telnet.host)
      when '.'
        Ems.shutdownServer(Telnet.host)
      when '1'
        Ems.pullStream(Telnet.host, IN_URI, IN_STREAM_NAME, PULL_KEEP_ALIVE, PULL_FORCE_TCP)
      when '2'
        Ems.record(Telnet.host, IN_STREAM_NAME, RECORD_PATH, RECORD_TYPE)
      when '3'
        if (@threadRamp == nil)
          @threadRamp = Thread.new { rampRecordTest }
        else
          stopRamp
        end
      when '5'
        Ems.pushStream(Telnet.host, OUT_URI, IN_STREAM_NAME, OUT_STREAM_NAME + "1")
        Ems.pushStream(Telnet.host, OUT_URI, IN_STREAM_NAME, OUT_STREAM_NAME + "2")
      when '7'
        Ems.listConfig(Telnet.host)
      when '8'
        Ems.removeLastConfig(Telnet.host)
        Ems.listConfig(Telnet.host)
      when ' ', '_'
        showSettings
      else
        Ems.version(Telnet.host)
    end
    statRamp = (@threadRamp == nil ? "start" : "STOP")
    statCapture = (@threadCapture == nil ? "start" : "STOP")
    puts
    puts "-----1:pull1 2:record1 3:ramptest(#{statRamp}) 5:push 7:listconfig 8:removeconfig _:settings"
    puts "[#{LOCAL_IP}] X:exit C:capture(#{statCapture}) L:liststreams S:shutlast .shutems else:version"
    key = Utils.get_key
  end until key.upcase == 'X'
rescue
  # error exit: show error message
  puts
  puts "-----Error: #$!-----"
ensure
  # normal/error exit: close telnet & cleanup
  Thread.kill(@threadCapture) if @threadCapture != nil
  Thread.kill(@threadRamp) if @threadRamp != nil
  puts
  puts "-----Done [#{LOCAL_IP}]-----"
  Telnet.close
end
