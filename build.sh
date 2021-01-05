#!/bin/bash
set -ev

if [ -z "${TRAVIS_TAG}" ]; then
    echo "Untagged build found. Testing building Terminal2 with tag 'test' and Terminal2-edge with tag 'test'."
    # build Terminal2
    docker run -it --rm --privileged --name "${ADDON_NAME}" \
        -v ~/.docker:/root/.docker \
        -v "$(pwd)":/docker \
        hassioaddons/build-env:latest \
        --target "${ADDON_NAME}" \
        --tag-test \
        --all \
        --from "homeassistant/{arch}-base" \
        --author "45clouds <hi@45clouds.com>" \
        --doc-url "${GITHUB_URL}" \
        --login "${DOCKER_USERNAME}" \
        --password "${DOCKER_PASSWORD}" \
        --parallel
    # build Terminal2-edge
    docker run -it --rm --privileged --name "${ADDON_NAME_EDGE}" \
        -v ~/.docker:/root/.docker \
        -v "$(pwd)":/docker \
        hassioaddons/build-env:latest \
        --target "${ADDON_NAME_EDGE}" \
        --tag-test \
        --all \
        --from "homeassistant/{arch}-base" \
        --author "45clouds <hi@45clouds.com>" \
        --doc-url "${GITHUB_URL}" \
        --login "${DOCKER_USERNAME}" \
        --password "${DOCKER_PASSWORD}" \
        --parallel \
        --arg COMMIT "${TRAVIS_COMMIT}"
else
    echo "New git tagged build found. Testing building Terminal2 with tag 'latest'."
    docker run -it --rm --privileged --name "${ADDON_NAME}" \
        -v ~/.docker:/root/.docker \
        -v "$(pwd)":/docker \
        hassioaddons/build-env:latest \
        --target "${ADDON_NAME}" \
        --tag-latest \
        --all \
        --from "homeassistant/{arch}-base" \
        --author "45clouds <hi@45clouds.com>" \
        --doc-url "${GITHUB_URL}" \
        --login "${DOCKER_USERNAME}" \
        --password "${DOCKER_PASSWORD}" \
        --parallel \
        --arg COMMIT "${TRAVIS_COMMIT}"
fi
echo "Local Docker build successful."
