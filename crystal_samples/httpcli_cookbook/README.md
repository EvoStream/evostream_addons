HTTPCLI COOKBOOK
================

Instructions
------------

The instructions below are for Ubuntu 16.04. Downloads for other platforms will be added later.

1. Install `httpcli` (command-line interface for EMS):
```
$ wget https://github.com/EvoStream/evostream_addons/tree/master/crystal_samples/httpcli/download/httpcli-1.1.2/httpcli-1.1.2-ubuntu16.04-amd64.zip
$ unzip httpcli-1.1.2-ubuntu16.04-amd64.zip
```

2. Install `jq` (command-line JSON processor):
```
$ sudo apt-get install jq
```

3. Modify `settings.yml` for localhost EMS access:
```
verbosity: 0 # 0=simple json, 1=pretty json, 2=with remarks, 3=with details
version: 0.0.0 # 0.0.0 / 1.7.1 / 2.0.0
ip: 127.0.0.1
username: username
password: password
domain: apiproxy
0.0.0: { port: 7777 }
1.7.1: { port: 8888 }
2.0.0: { port: 8888 }
```

Examples
--------

```
$ ./httpcli pullstream uri=rtmp://localhost/live/bunny.mp4
{"data":{"audioCodecBytes":"","configId":1,"emulateUserAgent":"EvoStream Media Server (www.evostream.com) player","forceTcp":false,"httpProxy":"","isAudio":true,"keepAlive":true,"localStreamName":"stream_jSIsMGj0","operationType":1,"pageUrl":"","ppsBytes":"","rangeEnd":-1,"rangeStart":-2,"rtcpDetectionInterval":10,"sendRenewStream":false,"spsBytes":"","ssmIp":"","swfUrl":"","tcUrl":"","tos":256,"ttl":256,"uri":{"document":"bunny.mp4","documentPath":"\/live\/","documentWithFullParameters":"bunny.mp4","fullDocumentPath":"\/live\/bunny.mp4","fullDocumentPathWithParameters":"\/live\/bunny.mp4","fullParameters":"","fullUri":"rtmp:\/\/localhost\/live\/bunny.mp4","fullUriWithAuth":"rtmp:\/\/localhost\/live\/bunny.mp4","host":"localhost","ip":"127.0.0.1","originalUri":"rtmp:\/\/localhost\/live\/bunny.mp4","parameters":{},"password":"","port":1935,"portSpecified":false,"scheme":"rtmp","userName":""}},"description":"Stream rtmp:\/\/localhost\/live\/bunny.mp4 enqueued for pulling","status":"SUCCESS"}

$ ./httpcli liststreamsids
{"data":[1,2,3],"description":"Available stream IDs","status":"SUCCESS"}

$ ./httpcli getstreamscount
{"data":{"streamCount":3},"description":"Active streams count","status":"SUCCESS"}

$ ./httpcli getstreamscount | jq '.data.streamCount'
3

$ ./httpcli liststreams | jq '.data[].name'
"stream_jSIsMGj0"
"bunny.mp4"
"/home/adizon/work/ems/ems4491-171/media/bunny.mp4"

$ ./httpcli liststreams | jq '.data[].name, .data[].video.bytesCount'
"stream_jSIsMGj0"
"bunny.mp4"
"/home/adizon/work/ems/ems4491-171/media/bunny.mp4"
18314860
18314815
0
```

