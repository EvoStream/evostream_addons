#!/bin/sh
crystal build httpcli.cr --release
strip httpcli
