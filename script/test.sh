#!/bin/sh

set -e

cleanup() {
  docker-compose -f docker-compose-test.yml rm -fv
  docker-compose -f docker-compose-test-different-env-var-names.yml rm -fv
}
trap cleanup EXIT

cleanup

docker build -t pactfoundation/pact_broker:localtest .
docker-compose -f docker-compose-test.yml up --build --abort-on-container-exit --exit-code-from test
cleanup

export PACT_BROKER_BASIC_AUTH_USERNAME=foo
export PACT_BROKER_BASIC_AUTH_PASSWORD=bar
export PACT_BROKER_PUBLIC_HEARTBEAT=true
docker-compose -f docker-compose-test.yml up --build --abort-on-container-exit --exit-code-from test

unset PACT_BROKER_BASIC_AUTH_USERNAME
unset PACT_BROKER_BASIC_AUTH_PASSWORD
unset PACT_BROKER_PUBLIC_HEARTBEAT

docker-compose -f docker-compose-test-different-env-var-names.yml up --build --abort-on-container-exit --exit-code-from test
