#!/bin/bash
#
# Start script for the SWISH docker
#
# This script is started in /data.  SWISH is in /swish

reconf=no
config=
start=--no-fork

usage()
{ echo "Usage: docker run [docker options] swish [swish options]"
  echo "swish options:"
  echo "  --interactive          Run Prolog toplevel (requires -it)"
  echo "  --help                 Display usage"
}

while [ ! -z "$1" ]; do
  case "$1" in
    --interactive)	start=--interactive
			shift
			;;
    --help)		usage
			exit 0
			;;
  esac
done

for dir in storage; do
  mkdir -p $dir
  chown daemon $dir
done

for file in ; do
  if [ ! -f $file ]; then
    touch $file
  fi
  chown daemon $file
done

${SWISH_HOME}/daemon.pl --port=3050 --user=daemon $start
