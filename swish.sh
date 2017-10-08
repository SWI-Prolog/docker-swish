#!/bin/bash

port=3050
data="$(pwd)"

done=no
while [ done = no ]; do
  case "$1" in
    --port=*)	port="$(echo $1 | sed 's/[^=*]=//')"
		shift
		;;
    *)		done=yes
		;;
  esac
done

docker run -p $port:3050 -v "$data":/data swish $*
