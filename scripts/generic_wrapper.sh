#!/usr/bin/env bash

# Call this script as you would the bwa executable. It acts as a thin layer
# around the docker containers in kogia. Need bash 4+

set -eo pipefail

# This is the most crossplatform way I can come up with to resolve a symlink.
# If you have something more concise that doesn't rely on python I'm all for it
function rl() {
  /usr/bin/env python3 -c 'import os, sys; print(os.path.realpath(sys.argv[1]))' $1
}

function gen_docker() {
  pw=$(rl $(pwd))
  # Associative array serves as a unique container similar to a set
  # so we don't mount twice
  declare -A MOUNTS
  MOUNTS[$pw]=$pw
  for arg in ${@}
  do
    # Ignore options that start with a dash
    if [[ $arg =~ ^- ]]
    then
      continue
    fi

    # If current string is an argument, resolve as a path and add to mounts if it exists
    # If it's a file, mount the `dirname`
    arg=$(rl $arg)
    if [[ -f $arg ]]
    then
      x=$(dirname $arg)
      MOUNTS[$x]=$x
    elif [[ -d $arg ]]
    then
      MOUNTS[$arg]=$arg
    fi
  done
  cmd="docker run -w $pw --rm --user ${UID}:${GID} -i"
  for M in ${MOUNTS[@]}
  do
    cmd="$cmd -v ${M}:${M}"
  done
  eval $cmd $@
}