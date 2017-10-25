# docker_samples

## Overview

The sample files provide an easy way to build and run Docker images for EMS 2.0.0.

## Installing Docker

Install Docker on your machine by following these steps:
```
wget https://download.docker.com/linux/static/stable/x86_64/docker-17.09.0-ce.tgz
tar -xvf docker-17.09.0-ce.tgz
sudo cp docker/* /usr/bin/
sudo dockerd &
```

## Testing Docker

Run the "hello world" demo to test your Docker installation.
```
sudo docker run --name hello hello-world
sudo docker ps -a
sudo docker images
sudo docker rmi hello-world
```

## Running the Pre-built Docker Image for EMS 2.0.0

Run the script below to use a pre-built Docker image for EMS 2.0.0 on Docker Cloud.
```
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
```

## Building Your Own Docker Image for EMS 2.0.0 (optional)

Run the script below to build your own Docker image for EMS 2.0.0.
```
sudo docker build -t ems200-ubuntu1604:mybuild .
```

## Running Your Own Docker Image for EMS 2.0.0 (optional)

Run the script below to use your self-built Docker image for EMS 2.0.0.
```
sudo docker run --name myems -i -t \
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
  ems200-ubuntu1604:mybuild bash
```

## Starting the EMS

The Docker image doesn't include an EMS license.
You may obtain a trial license from the EvoStream website, http://evostream.com.
From your host machine, copy the license file `License.lic` to `/etc/evostreamms` in the container:
```
sudo docker cp /path/to/License.lic myems:/etc/evostreamms
```
Replace `myems` with `ems5550` or whatever container name was used for running the Docker image.

Inside the Docker container, start the EMS (in privileged mode):
```
service evostreamms start
```

## Logging into a Container
```
sudo docker ps -a
sudo docker exec -i -t <container-id> /bin/bash
```
