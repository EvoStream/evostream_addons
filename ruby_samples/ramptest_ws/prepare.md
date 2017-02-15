# PREPARE BANDWIDTH TEST FOR WEBSOCKET

This part is only required for setup / preparation of the bandwidth test tool.

## A. PREPARE SERVER & CLIENT

   1. Install Ruby and required gems at each side

      ```bash
      $ sudo apt-get update
      $ sudo apt-get install ruby
      $ sudo apt-get install bundler
      $ bundle install
      ```

      In case the last step fails, the following steps may be required

      ```bash
      $ sudo apt-get install zlib1g-dev
      $ sudo gem install nokogiri
      ```

   2. Install NPM and NodeJS WebSocket NetCat module at the client side

      ```bash
      $ sudo apt-get install nodejs
      $ sudo ln -sf /usr/bin/nodejs /usr/bin/node
      $ curl -L https://www.npmjs.com/install.sh
      $ sudo sh install.sh
      $ sudo npm install -g wsnc
      ```

   3. Configure the server EMS to allow remote Telnet.
      In `/etc/evostreamms/config.lua`, under `CLI acceptors`, for protocol `inboundJsonCli`, change `ip` from `127.0.0.1` to `0.0.0.0`:

      ```lua
      -- CLI acceptors
      {
              ip="0.0.0.0",
              port=1112,
              protocol="inboundJsonCli",
              useLengthPadding=true
      } 
      ```

   4. Check if the EMS is online by browsing:

      ```text
      http://<ems_ip>:8888/EMS_Web_UI/index.php
      ```

      then clicking Connect.

## B. PREPARE FOR WEBSOCKET PLAYBACK

### SERVER SIDE

   1. If the EMS is not running at the server, start it.

   2. Copy a 1-minute video, `sintel1m720p.mp4`, and 2 text files from the GitHub:

      ```bash
      $ wget http://docs.evostream.com/sample_content/assets/sintel1m720p.mp4
      $ wget http://docs.evostream.com/sample_content/assets/sintel1h.sh
      $ wget http://docs.evostream.com/sample_content/assets/sintel1h.list
      ```

   3. Install `ffmpeg` if required

      ```bash
      $ sudo apt-add-repository ppa:mc3man/trusty-media
      $ sudo apt-get update
      $ sudo apt-get install ffmpeg
      ```

   4. Run the script `sintel1h.sh` to create a 1-hour video, `sintel1h720p.mp4`.

      ```bash
      $ sh sintel1h.sh
      ```

   5. Move the 1-hour video, `sintel1h720p.mp4`, to the EMS media folder:

      ```bash
      $ sudo mv sintel1h720p.mp4 /var/evostreamms/media
      ```

   6. Change ownership and permissions to allow MP4 playback:

      ```bash
      $ cd /var/evostreamms/media
      $ sudo chown evostreamd:evostreamd sintel1h720p.mp4
      $ sudo chmod a+r sintel1h720p.mp4
      ```

   7. Test the playability of the MP4 test file, typically:

      ```bash
      $ ffplay rtmp://<ems_ip>/vod/sintel1h720p.mp4
      ```

      Alternatively, use VLC, JWPlayer or some other Flash player to play it back.

   8. If the MP4 test file is not playable, review steps A-4 and B-6.
   
  
## C. SETUP PARAMETERS

   Modify the following parameters in `ramptest-ws.rb` before running tests.

   1. *INTERFACE* = the network interface between the EMS and the websocket player (e.g. "eth0")

   2. *MAIN_EMS_IP* = IP address of EMS to serve a stream for playback

   3. *IN_URI* = source URI to be pulled by EMS for the stream to be played back

      The sample video, `sintel1h720p.mp4`, has a bandwidth of `1.165 megabits/sec`.

   4. *RAMP_STEPS* = number of steps to ramp up/down (see calculations below)

   5. *RAMP_PULL_COUNT* = number of additional streams to play per step (see calculations below)

   6. *RAMP_STEP_DELAY* = delay in seconds between steps

   7. *RAMP_PEAK_TIMES* = number of delay loops between ramp-up and ramp-down

### Note

   Other settings that can limit playback performance for Linux:

   ```bash
   $ ulimit -n
   ```

   Set `ulimit` in excess of the number of expected streams. Refer to the OS documentation on how to set `ulimit`.


## D. CALCULATIONS

   The maximum number of streams will be:

   ```
   Maximum_Streams = RAMP_STEPS x RAMP_PULL_COUNT
   ```
   
   The maximum bandwidth will be:

   ```
   Maximum_Bandwidth = Maximum_Streams x Source_Bandwidth
                     = RAMP_STEPS x RAMP_PULL_COUNT x Source_Bandwidth
   ```

   For example, with *RAMP_STEPS* = 10, *RAMP_PULL_COUNT* = 8, and a source bandwidth of 1.165 megabits/sec:

   ```
   Maximum_Streams = 10 x 8 = 80 streams
   Maximum_Bandwidth = 80 x 1.165 megabits/sec = 93.2 megabits/sec
   ```

   Ramping up further would saturate a 100-baseT network, but would use only around 10% of a gigabit network's bandwidth.

   The maximum duration will be:

   ```
   Maximum_Duration = (RAMP_STEPS x 2 + RAMP_PEAK_TIMES) x RAMP_STEP_DELAY

   ```
   For, with *RAMP_STEPS* = 10, *RAMP_PEAK_TIMES* = 5 and *RAMP_STEP_DELAY* = 20

   ```
   Maximum_Duration = (10 x 2 + 5) x 20 = 500 seconds
   ```

   The source stream should have a duration longer than this to be able to ramp up/down smoothly with the expected bandwidth profile.

