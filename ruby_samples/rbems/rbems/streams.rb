#
# EvoStream Media Server Extensions
# EvoStream, Inc.
# (c) 2016 by EvoStream, Inc. (support@evostream.com)
# Released under the MIT License
#

module Rbems
  def self.check_live(uri)
    puts "Check stream '#{uri}'" if TRACE > 0
    filename = "file#{rand(10000)}"
    file_image = "#{TEMP_DIR}/#{filename}-#{SEC_GRAB}.jpg"
    file_error = "#{TEMP_DIR}/error_#{filename}.log"
    File.delete file_image if File.exists? file_image
    File.delete file_error if File.exists? file_error
    # at X sec, grab 1 frame
    cmd = "#{AVCONV_BIN} -i #{uri} -ss #{SEC_GRAB} -vframes 1 -f image2 -vf select=\"eq(pict_type\\,I)\" -vsync 2 #{file_image} 2>&1 > /dev/null"
    # e.g. evo-avconv -i rtmp://streaming.cityofboston.gov/live/cable -ss 10 -vframes 1 -f image2 -vf select="eq(pict_type\,I)" -vsync 2 bunny.jpg 2>&1
    puts "-- CMD: \"#{cmd}\"" if TRACE > 1
    fork do
      resp = `#{cmd}`
      puts "-- RESP: \"#{resp}\"" if TRACE > 1
      error_found = false
      AVCONV_ERRORS.each do |error|
        if resp =~ /#{error}/
          error_found = true
          fil = File.new(file_error, "w")
          fil.puts resp
          fil.close
          break
        end
      end
    end
    wait_time = 1
    SEC_WAIT.times do |i|
      print "#{i} " if TRACE > 1
      wait_time = i + 1
      break if File.exists? file_error
      break if File.exists? file_image
      sleep 1
    end
    `killall -9 #{AVCONV_BIN} 2> /dev/null`
    found = File.exists? file_image
    puts `ls -al #{file_image}` if found && TRACE > 1
    puts "Key frame found after #{wait_time} sec" if TRACE > 0
    return found ? wait_time : 0
  end
end
