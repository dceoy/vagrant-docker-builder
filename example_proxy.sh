#!/usr/bin/env bash

export HTTP_PROXY="http://example.proxy.com:8080"
export http_proxy="${HTTP_PROXY}"
export HTTPS_PROXY="https://example.proxy.com:8080"
export https_proxy="${HTTPS_PROXY}"
export NO_PROXY="127.0.0.1,localhost"
export no_proxy="${NO_PROXY}"
