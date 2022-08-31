#!/bin/bash

swift build --configuration release
sudo cp -f .build/release/EnvelopeTool /usr/local/bin/envelope
sudo cp -Rf .build/release/BCWally.framework /usr/local/bin/
sudo cp -Rf .build/release/SSKR.framework /usr/local/bin/
