#
# EvoStream Media Server Extensions
# EvoStream, Inc.
# (c) 2016 by EvoStream, Inc. (support@evostream.com)
# Released under the MIT License
#

module Rbems
  def self.play(uri, play_time = 0)
    puts "Play stream '#{uri}' for #{play_time} seconds" if TRACE > 0
    fork do
      `#{PLAYER_BIN} #{uri} 2>&1 > /dev/null`
    end
    return 0 if play_time <= 0
    sleep play_time
    `killall -9 #{PLAYER_BIN} 2> /dev/null`
    return play_time
  end
end
