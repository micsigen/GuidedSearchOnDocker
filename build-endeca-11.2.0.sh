#!/bin/sh

set -o pipefail

FILE=endeca-11.2.0
IMAGE=micsigen/endeca
VERSION=11.2.0

docker build -t ${IMAGE}:${VERSION} $FILE | tee build.log || exit 1
ID=$(tail -1 build.log | awk '{print $3;}')
