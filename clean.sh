#!/bin/bash

LOCAL=/usr/local
BIN=${LOCAL}/bin
TOOL=${BIN}/envelope
BUILD=${PWD}/.build/release

rm -rf ./.build
rm -rf ~/Library/Developer/Xcode/DerivedData/envelope-cli-*
