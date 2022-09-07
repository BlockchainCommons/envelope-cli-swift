#!/bin/bash

LOCAL=/usr/local
BIN={$LOCAL}/bin
TOOL=${BIN}/envelope
BUILD={$PWD}/.build/release

sudo rm -f ${TOOL}
sudo ln -s ${BUILD}/EnvelopeTool ${TOOL}
