#!/usr/bin/env bash
tagname="discourse/base:newgit"
# use head to get the newest version base
baseid=$(docker images 2>/dev/null | awk '/^discourse\/base[ ]+[0-9]/ {print $3}' | head -1)
[[ -z "$baseid" ]] && { echo "No tagged official Discourse base image found. Exit."; exit 1; }
sed "s/_DOCKER_BASE_ID_/$baseid/g" Dockerfile.template > Dockerfile

# to enable squash, modify Docker daemon.json
docker build . --no-cache --tag "$tagname"  --squash

