FROM ubuntu:16.04
MAINTAINER evostream (salesupport@evostream.com)
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y wget
RUN wget http://apt.evostream.com/installkeys.sh -O /tmp/installkeys.sh
RUN sh /tmp/installkeys.sh
RUN apt-get update && apt-get install -y evostream-mediaserver
EXPOSE 22 1112 1222 1935 4000 4100 5544 6666 7777 \
  8080 8100 8210 8410 8433 8888 9898/UDP 9998 9999
