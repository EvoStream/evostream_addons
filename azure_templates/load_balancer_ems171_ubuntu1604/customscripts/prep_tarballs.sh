#!/bin/bash
#
# EvoStream Media Server Extensions
# EvoStream, Inc.
# (c) 2017 by EvoStream, Inc. (support@evostream.com)
# Released under the MIT License
#
# prepare tarball files
#
echo "--- compressing files"
cd sm
rm tarball.tgz > /dev/null
tar -czvf tarball.tgz tarball/
cd ..
cd origin
rm tarball.tgz > /dev/null
tar -czvf tarball.tgz tarball/
cd ..
cd edge
rm tarball.tgz > /dev/null
tar -czvf tarball.tgz tarball/
cd ..
echo "--- done"
