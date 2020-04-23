# Call this script as you would the bwa executable. It acts as a thin layer
# around the docker containers in kogia. Need bash 4+

set -euo pipefail

# This is the most crossplatform way I can come up with to resolve a symlink.
# If you have something more concise that doesn't rely on python I'm all for it
function rl() {
  /usr/bin/env python3 -c 'import os, sys; print(os.path.realpath(sys.argv[1]))' $1
}

function get_uid() {
  /usr/bin/env python3 -c 'import os; print(os.getuid())'
}

function get_gid() {
  /usr/bin/env python3 -c 'import os; print(os.getgid())'
}

# Don't mess with the indentation...
function get_suppl_groups() {
  /usr/bin/env python3 -c \
'import os
print(" ".join([str(x) for x in os.getgroups() if not x == os.getgid()]))'
}

function gen_docker() {
  # Detect podman
  IS_PODMAN="$(docker -v | grep -oi podman || true)"
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
  MYUID=$(get_uid)
  MYGID=$(get_gid)
  MYSUPPGRPS=""
  for GRP in $(get_suppl_groups)
  do
    MYSUPPGRPS="$MYSUPPGRPS --group-add $GRP"
  done
  cmd=""
  if [ -z $IS_PODMAN ]
  then
    cmd="docker run -w $pw --rm --user ${MYUID}:${MYGID} ${MYSUPPGRPS} -i"
  else
    cmd="docker run --privileged -w $pw --rm -i"
  fi
  if [[ -v KOGIA_DOCKER_OPTS ]]
  then
    cmd="$cmd $KOGIA_DOCKER_OPTS"
  fi
  for M in ${MOUNTS[@]}
  do
    cmd="$cmd -v ${M}:${M}"
  done
  eval $cmd $@
}
