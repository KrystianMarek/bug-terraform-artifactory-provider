#!/usr/bin/env bash

docker run -it -w /app -v "$PWD:/app" hashicorp/terraform "$@"