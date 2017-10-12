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

## Running the Pre-build Docker Image for EMS 2.0.0

Run the script `run-prebuilt.sh` to run a pre-built Docker image for EMS 2.0.0 from Docker Cloud.
```
./run-prebuilt.sh
```

## Building Your Own Docker Image for EMS 2.0.0 (optional)

Run the script `build.sh` to build your own Docker image for EMS 2.0.0.
```
./build.sh
```

## Running Your Own Docker Image for EMS 2.0.0 (optional)

Run the script `run-mybuild.sh` to run your self-built Docker image for EMS 2.0.0.
```
./run-mybuild.sh
```

## Starting the EMS

The Docker image doesn't include an EMS license.
You may obtain a trial license from the EvoStream website, http://evostream.com.
Copy your license file `License.lic` to /etc/evostreamms.

Start the EMS.
```
sudo service evostreamms start
```

