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
udaemon=daemon
uconfig=root

usage()
{ echo "Usage: docker run [docker options] swish [swish options]"
  echo "swish options:"
  echo "  --bash		 Just jun bash in the container"
  echo "  --authenticated        Force login to SWISH"
  echo "  --social		 Allow optional login"
  echo "  --add_user		 Add a new user"
  echo "  --https		 Create an HTTPS server"
  echo "  --CN=host		 Hostname for certificate"
  echo "  --O=organization	 Organization for certificate"
  echo "  --C=country		 Country for certificate"
  echo "  --help                 Display usage"
}

add_user()
{ if [ -t 0 ]; then
    swipl -g swish_add_user -t halt ${SWISH_HOME}/lib/plugin/http_authenticate.pl
  else
    echo "ERROR: SWISH: must run in interactive mode to setup initial user"
    exit 1
  fi
}

# `mkdir file user` creates user with the uid and gid of file.

mkuser()
{ f="$1"
  u="$2"

  groupadd "$(ls -nd "$f" | awk '{printf "-g %s\n",$4 }')" -o $u
  useradd  "$(ls -nd "$f" | awk '{printf "-u %s\n",$3 }')" -g $u -o $u
}

setup_initial_user()
{ if [ ! -f passwd ]; then
    add_user
  fi
}

add_config()
{ cp "$configavail/$1" "$configdir/$1"
  chown $uconfig.$uconfig "$configdir/$1"
}

# If there is a data directory, reuse it and set our user to be the
# native user of this directory.

if [ -d data ]; then
  mkuser data swish
  udaemon=swish
else
  mkdir data
  chown $udaemon.$udaemon data
fi

if [ -d $configdir ]; then
  mkuser $configdir config
  uconfig=config
else
  mkuser . config
  uconfig=config
  mkdir $configdir
  chown $uconfig.$uconfig "$configdir"
	# Add default configuration
  add_config user_profile.pl
  add_config notifications.pl
  add_config email.pl
  add_config clpqr.pl
fi

if [ -t 0 ] ; then
  start=--interactive
fi

while [ ! -z "$1" ]; do
  case "$1" in
    --bash)		/bin/bash
			exit 0
			;;
    --authenticated)	setup_initial_user
			add_config auth_http_always.pl
			shift
			;;
    --social)		setup_initial_user
			add_config auth_http.pl
			add_config auth_google.pl
			add_config auth_stackoverflow.pl
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

if [ -S /rserve/socket ]; then
  add_config r_serve.pl
  echo ":- set_setting_default(rserve:socket, '/rserve/socket')." >> $configdir/r_serve.pl
fi

${SWISH_HOME}/daemon.pl --${scheme}=3050 ${ssl} --user=$udaemon $start
