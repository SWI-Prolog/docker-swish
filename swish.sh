#!/bin/bash
#
# Start script for the SWISH docker
#
# This script is started in /data.  SWISH is in /swish

reconf=no
config=
start=--no-fork
ssl=
scheme=http
SWISH_MODULES=

usage()
{ echo "Usage: docker run [docker options] swish [swish options]"
  echo "swish options:"
  echo "  --interactive          Run Prolog toplevel (requires -it)"
  echo "  --authenticated        Force login to SWISH"
  echo "  --add_user		 Add a new user"
  echo "  --https		 Create an HTTPS server"
  echo "  --CN=host		 Hostname for certificate"
  echo "  --O=organization	 Organization for certificate"
  echo "  --C=country		 Country for certificate"
  echo "  --help                 Display usage"
}

add_user()
{ if [ -t 0 ]; then
    swipl -g swish_add_user,halt -t 'halt(1)' ${SWISH_HOME}/lib/authenticate.pl
  else
    echo "ERROR: SWISH: must run in interactive mode to setup initial user"
    exit 1
  fi
}

setup_initial_user()
{ if [ ! -f passwd ]; then
    add_user
  fi
}

add_module()
{ if [ -z "$SWISH_MODULES" ]; then
    SWISH_MODULES=$1
  else
    SWISH_MODULES="$SWISH_MODULES:$1"
  fi
}

while [ ! -z "$1" ]; do
  case "$1" in
    --interactive)	start=--interactive
			shift
			;;
    --authenticated)	setup_initial_user
			add_module authenticate
			shift
			;;
    --add-user)		add_user
			exit 0
			;;
    --https)		scheme=https
			shift
			;;
    --CN=*|--O=*|--C=*)	ssl="$ssl $1"
			shift
			;;
    --modules=*)	modules=$(echo "$1" | sed 's/^--modules=//')
			shift;
			;;
    --help)		usage
			exit 0
			;;
    *)			usage
			exit 1
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

export SWISH_MODULES
${SWISH_HOME}/daemon.pl --${scheme}=3050 --user=daemon $start
