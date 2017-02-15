#!/usr/bin/ruby
#
# EvoStream Media Server Extensions
# EvoStream, Inc.
# (c) 2016 by EvoStream, Inc. (support@evostream.com)
# Released under the MIT License
#

$DEBUG = true

#
# bandwidth test tool for client & server EMS
#

# gems & modules
require 'rubygems'
require 'json'
require 'pp'
require 'timeout'
require 'colorize'

require './lib_telnet'
require './lib_ems'
require './lib_utils'
require './class_usage'

include Telnet
include Ems
include Utils

# general settings
INTERFACE = "eno1" #"wlp4s0b1" #"wlan0" #"eth0"
MAIN_EMS_IP = "192.168.2.106" #"localhost"
STREAM_SOURCE_IP = MAIN_EMS_IP #"localhost"
# ems constants
RTMP_PORT=1935
WEBSOCKET_PORT=8410
NAME_EMS = "evostreamms"
# capture settings
SAMPLE_PERIOD = 10
SAMPLE_PORT = WEBSOCKET_PORT
FILE_PREFIX = "ws" #"rtmp"
# ramp test settings
RAMP_STEPS = 20 #7 #2
RAMP_PULL_COUNT = 20 #10
RAMP_STEP_DELAY = 40 #20
RAMP_PEAK_TIMES = 1
# pull settings
PULL_FORCE_TCP = 1
PULL_KEEP_ALIVE = 1
IN_STREAM_NAME = "mystream"
# stream sources
IN_URI_RAMP = "rtmp://#{STREAM_SOURCE_IP}/live/#{IN_STREAM_NAME}"
#IN_URI = "rtmp://streaming.cityofboston.gov/live/cable"
#IN_URI = "rtmp://localhost/vod/sintel1h720p.mp4"
#IN_URI = "rtmp://localhost/vod/bunny1h.mp4"
IN_URI = "rtmp://localhost/vod/bun1h.mp4"
# record settings
TARGET_DIR = "/tmp"
RECORD_PATH = "/tmp/record"

@threadRamp = nil
@threadCapture = nil
@stopCapture = false
@stopRamp = false
@streamCount = 0

def getStreamCountAtPort(port)
  `netstat -tan|grep ESTABLISHED|grep :#{port}|wc -l`.strip.to_i
end

def rampTest
  puts "-- ramp started --".colorize(:light_green)
  @stopRamp = false
  pids = {}
  rampMax = RAMP_STEPS
  # ramp up
  tstart = Time.now
  for rampNo in 1..RAMP_STEPS do
    puts "ramp up ##{rampNo} of #{RAMP_STEPS} (x#{RAMP_PULL_COUNT} streams) start".colorize(:light_green)
    RAMP_PULL_COUNT.times do |i|
      id = rampNo * RAMP_PULL_COUNT + i
      pids[id] = Process.spawn("./wsplay.sh #{MAIN_EMS_IP} #{WEBSOCKET_PORT} #{IN_STREAM_NAME}")
      print "[+pid:#{pids[id]}]".colorize(:light_blue)
    end
    totalSecLeft = RAMP_STEP_DELAY * (RAMP_STEPS * 2 - rampNo + RAMP_PEAK_TIMES)
    min = totalSecLeft / 60
    sec = totalSecLeft - 60 * min
    puts "ramp up ##{rampNo} of #{RAMP_STEPS} (x#{RAMP_PULL_COUNT} streams) end -- #{'%02d'%min}:#{'%02d'%sec} min:sec left".colorize(:green)
    tstep = tstart + RAMP_STEP_DELAY * rampNo
    while Time.now < tstep do
      sleep 0.2
      break if @stopRamp
    end
    if @stopRamp
      rampMax = rampNo
      break
    end
  end
  # ramp peak
  sleep RAMP_STEP_DELAY * RAMP_PEAK_TIMES
  # ramp down
  tstart = Time.now
  for rampNo in 1..rampMax do
    puts "ramp down ##{rampMax - rampNo + 1} of #{rampMax} (x#{RAMP_PULL_COUNT} streams) start".colorize(:light_red)
    RAMP_PULL_COUNT.times do |i|
      id = rampNo * RAMP_PULL_COUNT + i
      print "[-#{id}]".colorize(:light_yellow)
      print "[-pid:#{pids[id]}]".colorize(:yellow)
      kill_tree = "kill `pstree -l -p #{pids[id]} | grep \"([[:digit:]]*)\" -o |tr -d '()'`"
      if pids[id]
        system(kill_tree)
        Process.wait(pids[id])
        pids[id] = nil
      end
    end
    totalSecLeft = RAMP_STEP_DELAY * (rampMax - rampNo + 1)
    min = totalSecLeft / 60
    sec = totalSecLeft - 60 * min
    tstep = tstart + RAMP_STEP_DELAY * rampNo
    while Time.now < tstep do
      sleep 0.2
      break if @stopRamp
    end
    puts "ramp down ##{rampMax - rampNo + 1} of #{rampMax} (x#{RAMP_PULL_COUNT} streams) end -- #{'%02d'%min}:#{'%02d'%sec} min:sec left".colorize(:red)
  end
  puts "-- ramp done --".colorize(:red)
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
  if @threadRamp
    sleep(5)
    @threadRamp.join
    Thread.kill(@threadRamp)
    @threadRamp = nil
  end
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
  puts "RAMP_PULL_COUNT = #{RAMP_PULL_COUNT}        (MAX_STREAMS = #{RAMP_STEPS * RAMP_PULL_COUNT})"
  puts "RAMP_STEP_DELAY = #{RAMP_STEP_DELAY}        (MAX_DURATION = #{(RAMP_STEPS * 2 + RAMP_PEAK_TIMES) * RAMP_STEP_DELAY} sec)"
  puts "RAMP_PEAK_TIMES = #{RAMP_PEAK_TIMES}"
  puts "RECORD_PATH = #{RECORD_PATH}"
  puts "PULL_FORCE_TCP = #{PULL_FORCE_TCP}"
  puts "PULL_KEEP_ALIVE = #{PULL_KEEP_ALIVE}"
end

begin
  puts
  puts "-----Begin [#{MAIN_EMS_IP}]-----"
  Ems.initialize({"target_dir" => TARGET_DIR, "record_path" => RECORD_PATH})
  Telnet.open(MAIN_EMS_IP)
  raise "error opening telnet" if (Telnet.host == nil)
  key = ' '
  pid = nil
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
        pid = Process.spawn("./wsplay.sh #{MAIN_EMS_IP} #{WEBSOCKET_PORT} #{IN_STREAM_NAME}") if !pid
        print "[+pid:#{pid}]".colorize(:light_blue)
      when '3'
        stopRamp
        if pid
          print "[-pid:#{pid}]".colorize(:yellow)
          kill_tree = "kill `pstree -l -p #{pid} | grep \"([[:digit:]]*)\" -o |tr -d '()'`"
          system(kill_tree)
          Process.wait(pid)
          pid = nil
        end
      when '5'
        if (@threadRamp == nil)
          @threadRamp = Thread.new { rampTest }
        else
          stopRamp
        end
      when '7'
        Ems.listConfig(Telnet.host)
      when '8'
        Ems.removeLastConfig(Telnet.host)
        Ems.listConfig(Telnet.host)
      when ' ', '_'
        showSettings
      when '>'
        `vlc "rtmp://localhost/live/#{IN_STREAM_NAME} live=1"`
      else
        Ems.version(Telnet.host)
    end
    statRamp = (@threadRamp == nil ? "start" : "STOP")
    statCapture = (@threadCapture == nil ? "start" : "STOP")
    puts
    puts "-----1:pull1 2:play 3:stop 5:ramptest(#{statRamp}) 7:listconfig 8:removeconfig _:settings >:vlc"
    puts "[#{MAIN_EMS_IP}] X:exit C:capture(#{statCapture}) L:liststreams S:shutlast .shutems else:version"
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
  puts "-----Done [#{MAIN_EMS_IP}]-----"
  Telnet.close
end
