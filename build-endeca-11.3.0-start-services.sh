#!/bin/sh

set -o pipefail

FILE=endeca-11.3.0-start-services
IMAGE=micsigen/endeca-start-services
VERSION=11.3.0

docker build -t ${IMAGE}:${VERSION} $FILE | tee build.log || exit 1
ID=$(tail -1 build.log | awk '{print $3;}')
