FROM ubuntu:16.04
MAINTAINER don dizon (dondizon@gmail.com)
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y ruby
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y wget
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y curl
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y vim
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y telnet
RUN wget http://apt.evostream.com/installkeys.sh -O /tmp/installkeys.sh
RUN sh /tmp/installkeys.sh
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y evostream-mediaserver
EXPOSE 22/TCP
EXPOSE 1112/TCP
EXPOSE 1222/TCP
EXPOSE 1935/TCP
EXPOSE 4000/TCP
EXPOSE 4100/TCP
EXPOSE 5544/TCP
EXPOSE 6666/TCP
EXPOSE 7777/TCP
EXPOSE 8080/TCP
EXPOSE 8100/TCP
EXPOSE 8210/TCP
EXPOSE 8410/TCP
EXPOSE 8433/TCP
EXPOSE 8888/TCP
EXPOSE 9898/UDP
EXPOSE 9998/TCP
EXPOSE 9999/TCP
