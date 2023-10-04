#!/bin/bash

set -e

swift build --configuration release

LOCAL=/usr/local
BIN=${LOCAL}/bin
TOOL_DIR=${LOCAL}/EnvelopeTool
TOOL=${BIN}/envelope
BUILD=${PWD}/.build/release

sudo rm -rf ${TOOL_DIR}
sudo mkdir ${TOOL_DIR}
sudo cp -f ${BUILD}/EnvelopeTool ${TOOL_DIR}/
sudo cp -Rf ${BUILD}/BCWally.framework ${TOOL_DIR}/
sudo cp -Rf ${BUILD}/SSKR.framework ${TOOL_DIR}/
sudo cp -Rf ${BUILD}/CryptoBase.framework ${TOOL_DIR}/
sudo rm -f ${TOOL}
sudo ln -s ${TOOL_DIR}/EnvelopeTool ${TOOL}
