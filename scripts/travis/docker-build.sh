#!/bin/bash

#  Copyright 2018 U.C. Berkeley RISE Lab
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.

# only build a new Docker image if this is a master branch build -- ignore this
# for PR builds
if [[ "$TRAVIS_BRANCH" = "master" ]] && [[ "$TRAVIS_PULL_REQUEST" = "false" ]]; then
  docker pull fluentproject/base
  docker pull fluentproject/annakvs
  docker pull fluentproject/kops
  docker pull fluentproject/executor
  docker pull fluentproject/cache

  cd dockerfiles/kvs
  docker build . -f anna.dockerfile -t fluentproject/annakvs --cache-from fluentproject/annakvs:latest
  docker build . -f kops.dockerfile -t fluentproject/kops --cache-from fluentproject/kops:latest

  cd ../functions
  docker build . -f executor.dockerfile -t fluentproject/executor --cache-from fluentproject/executor:latest
  docker build . -f cache.dockerfile -t fluentproject/cache --cache-from fluentproject/cache:latest

  echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin

  docker push fluentproject/annakvs
  docker push fluentproject/kops
  docker push fluentproject/executor
  docker push fluentproject/cache
fi
