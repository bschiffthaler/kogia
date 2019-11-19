#!/bin/bash

# Call this script as you would the bwa executable. It acts as a thin layer
# around the docker container and has pretty 

set -eo pipefail

# This is the most crossplatform way I can come up with to resolve a symlink.
# If you have something more concise that doesn't rely on python I'm all for it
function rl() {
  /usr/bin/env python3 -c 'import os, sys; print(os.path.realpath(sys.argv[1]))' $1
}

function gen_docker() {
  pw=$(rl $(pwd))
  mounts="-v ${pw}:${pw}"
  for arg in ${@}
  do
    arg=$(rl $arg)
    if [[ -f $arg ]]
    then
      x=$(dirname $arg)
      mounts="$mounts -v ${x}:${x}"
    elif [[ -d $arg ]]
    then
      mounts="$mounts -v ${arg}:${arg}"
    fi
  done

  docker run -w $pw --rm --user ${UID}:${GID} -i $mounts $@
}