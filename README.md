# A SWISH Docker

This repository provides a   [Docker](https://www.docker.com/) image for
[SWISH](http://swish.swi-prolog.org)  based  on  the  SWI-Prolog  docker
image by Michael Hendricks (`mndrix/swipl`).

## Building the image

The image is built by simply running

    make

## Running the image

SWISH can run in two modes

  1) **Anonymously** In this mode no authentication is required, any
  user can create and edit any file.  Users can only run _safe_
  _goals_, i.e., goals that have no permanent side effects and do
  not reveal information about other users. That is how
  http://swish.swi-prolog.org runs.

  2) **Authenticated** In this mode users need to log into the system.
  This removes the _sandbox_ protection and thus lets the user run
  any command.  Note that this is practically the same as giving the
  user a shell.

