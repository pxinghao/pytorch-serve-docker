#!/bin/bash

# Start server
torchserve --start --ts-config /home/model-server/config.properties

# Do not close container
tail -f /dev/null