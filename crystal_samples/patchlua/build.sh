#!/bin/sh
#
# EvoStream Media Server Extensions
# EvoStream, Inc.
# (c) 2017 by EvoStream, Inc. (support@evostream.com)
# Released under the MIT License
#

crystal build patchlua.cr --release
strip patchlua
