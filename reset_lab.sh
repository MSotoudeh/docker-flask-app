#!/usr/bin/env bash
set -Eeuo pipefail

if command -v docker >/dev/null 2>&1; then
  running_containers=$(docker ps -q)
  if [ -n "$running_containers" ]; then
    docker kill $running_containers
  fi

  all_containers=$(docker ps -aq)
  if [ -n "$all_containers" ]; then
    docker rm $all_containers
  fi

  docker system prune -f --volumes
fi

rm -rf \
  "$HOME/.ansible" \
  "$HOME/.terraform.d"

echo "Lab environment reset."
