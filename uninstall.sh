#!/bin/bash

LOCAL=/usr/local
BIN={$LOCAL}/bin
TOOL_DIR=${LOCAL}/EnvelopeTool
TOOL=${BIN}/envelope

sudo rm -f ${TOOL}
sudo rm -rf ${TOOL_DIR}
