#!/usr/bin/env bash

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"

HOST_NAME="samba-srv"

docker container inspect "${HOST_NAME}" >/dev/null 2>&1
if [ $? -eq 0 ]; then
  docker kill "${HOST_NAME}"
  docker rm "${HOST_NAME}"
fi

docker run -d --restart=unless-stopped --name "${HOST_NAME}" --hostname "${HOST_NAME}" \
  --network host \
  -v "${DIR}/data:/share:rw" \
  -v "${DIR}/config.yml:/data/config.yml:ro" \
  crazymax/samba
