#!/bin/bash
set -ev

if [ "$TRAVIS_PULL_REQUEST" != "false" ]; then
    echo "This build is a pull request, aborting distribution script."
    exit 0
fi

if [ ! -z "$TRAVIS_TAG" ]; then
    echo "Tagged build found. Pushing Terminal2 image to Docker with tag 'latest'."

    docker run -it --rm --privileged --name "${ADDON_NAME}" \
        -v ~/.docker:/root/.docker \
        -v "$(pwd)":/docker \
        hassioaddons/build-env:latest \
        --target "${ADDON_NAME}" \
        --tag-latest \
        --push \
        --all \
        --from "homeassistant/{arch}-base" \
        --author "45clouds <hi@45clouds.com>" \
        --doc-url "${GITHUB_URL}" \
        --login "${DOCKER_USERNAME}" \
        --password "${DOCKER_PASSWORD}" \
        --parallel
else
    echo "No tag found."
    if [ "$TRAVIS_BRANCH" != "master" ]; then
        echo "Not on master branch. Aborting distribution script"
        exit 0
    fi
    echo "Untagged push to master branch identified. Pushing Terminal2 and Terminal2-edge images to Docker with tag 'test'."

    # distribute Terminal2 with tag test
    docker run -it --rm --privileged --name "${ADDON_NAME}" \
        -v ~/.docker:/root/.docker \
        -v "$(pwd)":/docker \
        hassioaddons/build-env:latest \
        --target "${ADDON_NAME}" \
        --tag-test \
        --push \
        --all \
        --from "homeassistant/{arch}-base" \
        --author "45clouds <hi@45clouds.com>" \
        --doc-url "${GITHUB_URL}" \
        --login "${DOCKER_USERNAME}" \
        --password "${DOCKER_PASSWORD}" \
        --parallel

    # distribute Terminal2-edge with tag test
    docker run -it --rm --privileged --name "${ADDON_NAME_EDGE}" \
        -v ~/.docker:/root/.docker \
        -v "$(pwd)":/docker \
        hassioaddons/build-env:latest \
        --target "${ADDON_NAME_EDGE}" \
        --tag-test \
        --push \
        --all \
        --from "homeassistant/{arch}-base" \
        --author "45clouds <hi@45clouds.com>" \
        --doc-url "${GITHUB_URL}" \
        --login "${DOCKER_USERNAME}" \
        --password "${DOCKER_PASSWORD}" \
        --parallel \
        --arg COMMIT "${TRAVIS_COMMIT}"
fi
