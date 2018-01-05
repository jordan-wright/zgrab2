#!/usr/bin/env bash

# Build the zgrab2_runner docker image using docker-runner/Dockerfile.

set -e

RUNNER_DIR=$(dirname "$0")
ZGRAB_ROOT="$RUNNER_DIR/.."

docker build -t zgrab2_runner_base:latest -f $RUNNER_DIR/Dockerfile.base $ZGRAB_ROOT