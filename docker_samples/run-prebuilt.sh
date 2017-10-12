#!/bin/bash
sudo docker run --name ems5550 -i -t \
  -p 1112:1112/tcp \
  -p 1222:1222/tcp \
  -p 1935:1935/tcp \
  -p 4000:4000/tcp \
  -p 4100:4100/tcp \
  -p 5544:5544/tcp \
  -p 6666:6666/tcp \
  -p 7777:7777/tcp \
  -p 8080:8080/tcp \
  -p 8100:8100/tcp \
  -p 8210:8210/tcp \
  -p 8410:8410/tcp \
  -p 8433:8433/tcp \
  -p 8888:8888/tcp \
  -p 9898:9898/UDP \
  -p 9998:9998/tcp \
  -p 9999:9999/tcp \
  dondizon/ems200-ubuntu1604:5550 bash
