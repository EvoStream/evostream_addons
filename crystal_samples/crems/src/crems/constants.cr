#
# EvoStream Media Server Extensions
# EvoStream, Inc.
# (c) 2016 by EvoStream, Inc. (support@evostream.com)
# Released under the MIT License
#

module Crems
  VERSION       = "0.1.0"
  TRACE         = 1 # 0=quiet, 1=minimal, 2=verbose
  EMS_IP        = "localhost"
  EMS_CLI_PORT  = 7777
  SEC_GRAB      =  0.1
  SEC_WAIT      =   50 # seconds to wait for live stream
  SEC_PLAY      =   20 # seconds to play, 0=nonstop
  PLAYER_BIN    = "vlc"
  AVCONV_BIN    = "evo-avconv"
  AVCONV_ERRORS = ["not open conn", "timed out", "Ignoring", "Failed to resolve", "connect error", "Server error",
    "does not contain any stream", "Operation not permitted", "Ignoring SWFVerification request", "Input/output error",
    "Connection timed out", "Unknown error occurred", "End of file",
  ]
  URIS_LIVE = [
    "rtmp://streaming.cityofboston.gov/live/cable",
    "rtmp://s2pchzxmtymn2k.cloudfront.net/cfx/st/mp4:sintel.mp4",
    "rtsp://c.itvitv.com/jp.test3",
    "rtsp://u.itvitv.com/test2.j"
  ]
  TEMP_DIR    = "/tmp"
  STREAM_NAME = "mystream"
end
