#
# EvoStream Media Server Extensions
# EvoStream, Inc.
# (c) 2016 by EvoStream, Inc. (support@evostream.com)
# Released under the MIT License
#

#
# miscellaneous utilities
#

require 'rubygems'

def osIsWindows
  /mingw/ =~ Gem::Platform.local.os
end

require 'Win32API' if osIsWindows
require 'win32ole' if osIsWindows

module Utils

if osIsWindows
  # read one char w/o enter nor echo
  def get_key
    key = Win32API.new('crtdll','_getch', [], 'L').call
    key.chr
  end
else
  # read one char w/o enter nor echo
  def get_key
    begin
      # save previous state of stty
      old_state = `stty -g`
      # disable echoing and enable raw (not having to press enter)
      system "stty raw -echo"
      c = STDIN.getc.chr
      # gather next two characters of special keys
      if (c=="\e")
        extra_thread = Thread.new{
          c = c + STDIN.getc.chr
          c = c + STDIN.getc.chr
        }
        # wait just long enough for special keys to get swallowed
        extra_thread.join(0.00001)
        # kill thread so not-so-long special keys don't wait on getc
        extra_thread.kill
      end
    rescue => ex
      puts "#{ex.class}: #{ex.message}"
      puts ex.backtrace
    ensure
      # restore previous state of stty
      system "stty #{old_state}"
    end
    return c
  end
end

end
