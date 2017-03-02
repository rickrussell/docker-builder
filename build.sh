#!/bin/bash -lex

CONTAINER=${CONTAINER:-$1}

if [[ -e "${CONTAINER}/Dockerfile" ]]; then
  cd ${CONTAINER}
  DOCKER_REPO=$(awk '/^#[[:space:]]*NAME[[:space:]]/{print $NF}' Dockerfile)
  [[ -z "$DOCKER_REPO" ]] && DOCKER_REPO="rickrussell/$(echo ${CONTAINER}|sed 's,/,-,g')"
  TAGS=()
  TAGS+=($(awk '/^#[[:space:]]*VERSION[[:space:]]/{print $NF}' Dockerfile))
  TAGS+=($(git rev-parse --short HEAD))
  if [[ "$DOCKER_LATEST" = "true" ]]; then
    TAGS+=('latest')
  fi

  # Jenkins
  # docker build --pull -t ${DOCKER_REPO}:${BUILD_TAG} .
  # echo "CONTAINER=${DOCKER_REPO}" >> $WORKSPACE/env.properties
  # echo "BUILD_TAG=${BUILD_TAG}" >> $WORKSPACE/env.properties

  # No Jenkins
  docker build --pull -t ${DOCKER_REPO} .

  for tag in "${TAGS[@]}"; do
    docker tag ${DOCKER_REPO} ${DOCKER_REPO}:${tag}
    if [[ "$DOCKER_PUSH" = "true" ]]; then
      docker push ${DOCKER_REPO}:$tag
    fi
  done

else
  echo "No Dockerfile found at path: ${CONTAINER}"
  exit 1
fi
