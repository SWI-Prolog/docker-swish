#!/bin/bash
#
# Start script for the SWISH docker
#
# This script is started in /data.  SWISH is in /swish

configdir=config-enabled
configavail=/swish/config-available
start=--no-fork
ssl=
scheme=http

usage()
{ echo "Usage: docker run [docker options] swish [swish options]"
  echo "swish options:"
  echo "  --bash		 Just jun bash in the container"
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

if [ -t 0 ] ; then
  start=--interactive
fi

add_config()
{ mkdir -p $configdir
  cp $configavail/$1 $configdir
}

while [ ! -z "$1" ]; do
  case "$1" in
    --bash)		/bin/bash
			exit 0
			;;
    --authenticated)	setup_initial_user
			add_config auth_http_always.pl
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
    --help)		usage
			exit 0
			;;
    *)			usage
			exit 1
			;;
  esac
done

for dir in data; do
  mkdir -p $dir
  chown -R daemon $dir
done

for file in ; do
  if [ ! -f $file ]; then
    touch $file
  fi
  chown daemon $file
done

if [ -S /rserve/socket ]; then
  add_config r_serve.pl
  echo ":- set_setting_default(rserve:socket, '/rserve/socket')." >> $configdir/r_serve.pl
fi

${SWISH_HOME}/daemon.pl --${scheme}=3050 ${ssl} --user=daemon $start
