# A SWISH Docker

This repository provides a   [Docker](https://www.docker.com/) image for
[SWISH](http://swish.swi-prolog.org) based on the   official  SWI-Prolog
docker image (`swipl`).

## Building the image

The image is built by simply running

    make image

## Running the image

### Data

The docker image maintains its data (user programs and configuration) on
the _volume_ `/data`. This may be mapped   to a host directory using the
docker `-v` options. The command below maps the current directory.

    docker run -v `pwd`:/data swish

Within the data directory, SWISH manages the following items:

  - **config-enabled** is a directory where the configuration is stored.
  If it doesn't exist it is created and filled with a default
  configuration that depends on the provided options.  The directory
  and its files have the same owner and group as the root of the managed
  volume.

  - **data** is the directory where all dynamic user data is maintained.
  If the directory exists, the SWISH server is started with the user and
  group of the directory.  If it doesn't exist the directory is created
  as owned by `daemon.daemon` and the server is started with these
  credentials.

  - **https** If the `--https` option is passed, it creates or reuses
  this directory and the files `server.crt` and `server.key`. The
  created certificate is _self-signed_.

  - **passwd**  If authenticated mode is enabled, this file maintains
  the users and password hashes.


### Network access

The container creates a server at port `3050`. By default this is an
HTTP server. If `run <docker options> swish --https` is used, an HTTPS
server is started.


### The entry point

The entry point of the containser is   `/swish.sh`,  a shell script that
initialises the data volume if needed and  starts the server. It accepts
the following options:

  - `--bash` <br>
  Instead of starting the server, start a bash shell.  Terminate after
  bash completes.

  - `--authenticated` <br>
  Run in fully _authenticated_ mode, forcing the user to login
  and allowing to execute arbitrary commands.  When executed for
  the first time, docker must be run _interactively_ (`run -it`)
  to create the first user.  Additional users are created using

      `docker run -it swish --add-user`.

  - `--social` <br>
  Use _social_ login.  By default enables optional http login,
  login using google and stackoverflow.  Both need to be further
  configured by editing `config-enabled/auth_google.pl` and
  `config-enabled/auth_stackoverflow.pl`

  - `--https` <br>
  Create an HTTPS server.  This uses the certificate from the
  `https` directory (see above).  If no certificate exists, a
  self-signed certificate is created.  The details may be refined
  using `--CN=host`, `--O=organization` and `--C=country`

  - `--help` <br>
  Emit short help.


### Configuration

