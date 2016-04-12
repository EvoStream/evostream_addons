# php_webservices


## Overview

The PHP-based web services are a collection of scripts that provide aggregate or high-level functionality on top of the EMS API and Event Notification system.  These scripts can be used directly or modified to better suit the needs of your project.  The EMS v1.7.0 and below are all distributed with a copy of these web services and are pre-configured to use them.

These web services can be run on the same computer that is running the Evostream Media Server (EMS) or they can be run on a fully seperate machine.

You can read more about these web services here: [http://docs.evostream.com](http://docs.evostream.com/ems_web_services_user_guide/table_of_contents) 

## Getting Started

The main entry point for these Web Services is the **evowebservices.php** file.  This is the file that you will configure the EMS to send events to in the ```config.lua``` configuration file.  The EMS v1.7.0 and below are installed pre-configured to send Events to this file.

The various web services are organized into *Plugins* that can be turned on or off.  To turn a plugin on and configure it, you will edit the ```config/config.ini``` file.

## The Core

Inside the ```core``` directory, you will find a few files:

* **evoapi-core.php**:		This file contains the PHP wrappers for the full EMS Run-Time API.
* **ini-parser.php**:		A simple parser for the config.ini file
* **s3-core.php**:			This file is provided by Amazon and is used for accessing the Amazon AWS API to do things like upload HLS to an AWS S3 Bucket.

## The Plugins

### Amazon HLS/HDS Upload

This web service listens for events like ```hlschunkcreated``` and will manage the upload of a live-streaming HLS stream to an Amazon AWS S3 bucket

### Stream Load Balancer

This web service listens for new inbound streams on an origin server and cause each of the edge servers to pull that new stream from the origin.  This will effectively replicate all the source streams accross a collection of edge servers dynamically.

### Stream Auto Router

This web service will tell an origin server to push streams whos names include a specified token.  Streams that meet this filter will be pushed to one or more destination servers.  These destination servers can be other EMS servers or could be other ingest sytems such as YouTube Live, Facebook, or even an ONVIF compliant system.

### Stream Recorder

Automatically record certain streams

### Transcode Resetter

This web service listens for a loss in either audio or video in the source stream.  If both audio and video are lost, the EMS will reset the stream for us, so it is only necessary to dectect here for the loss of one or the other.  If such a loss is detected, the stream connections will be reset.

 