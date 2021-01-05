#!/bin/bash
set -ev

echo "Running local build test."

# build Terminal2
docker run -it --rm --privileged --name "Terminal2" \
    -v ~/.docker:/root/.docker \
    -v "$(pwd)":/docker \
    hassioaddons/build-env:latest \
    --target "Terminal2" \
    --tag-test \
    --armhf \
    --from "homeassistant/{arch}-base" \
    --author "45clouds <hi@45clouds.com" \
    --doc-url "https://github.com/45clouds/addons" \
    --parallel
