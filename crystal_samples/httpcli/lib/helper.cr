#
# EvoStream Media Server Extensions
# EvoStream, Inc.
# (c) 2017 by EvoStream, Inc. (support@evostream.com)
# Released under the MIT License
#

def puts_error(text)
  puts text.colorize(:light_red).underline
end

def puts_info(text)
  puts text.colorize(:light_cyan)
end
