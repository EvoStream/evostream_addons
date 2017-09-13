#!/bin/sh
crystal build httpcli.cr --no-debug --release
strip httpcli
