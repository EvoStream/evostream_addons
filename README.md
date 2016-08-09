# evostream_addons

## Overview

This repository is for scripts and web services that can be used in conjunction with the EvoStream Media Server.  Most (if not all) of these scripts directly leverage the EMS Run-Time API and Event Notification System to add business logic to or provide run-time controls of the EvoStream Media Server

## PHP Web Services

The PHP-based web services are a collection of scripts that provide aggregate or high-level functionality on top of the EMS API and Event Notification system.  These scripts can be used directly or modified to better suit the needs of your project.  The EMS v1.7.0 and below are all distributed with a copy of these web services and are pre-configured to use them.

These web services can be run on the same computer that is running the Evostream Media Server (EMS) or they can be run on a fully seperate machine.

You can read more about these web services here: [http://docs.evostream.com](http://docs.evostream.com/ems_web_services_user_guide/table_of_contents)

## BASH Scripts

The **bash_scripts** folder provides a colleciton of BASH scripts that call the EMS API and control the streaming behavior of the video streaming during runtime.  These scripts can be used on embedded devices such as security cameras, action cams, or wearables, or can be used on servers to provide discrete functional scripts for server management.

## Ruby Samples

The **ruby_samples** directory contains a collection of stress tests and server statistic gathering tools written in Ruby.  EvoStream uses these in tests in their QA but they can be useful in stress testing streaming platforms in general.

## Azure Templates

The **azure_templates** directory contains sample templates for deploying Azure VMs for EMS on various platforms.

## Certificates and Keys

The **certificates_and_keys** folder provides a set of scripts to create certificates and keys required by EMS. One script creates certificates and keys for your own Certificate Authority (CA). Another script creates certificates and keys for your server. The ones created for your CA should be kept secret. They are used for signing the ones created for your server.
