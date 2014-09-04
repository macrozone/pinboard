#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export MONGO_URL=mongodb://localhost/pinboard
export ROOT_URL=http://pinboard.macrozone.ch
export PORT=8140
export METEOR_SETTINGS=$(cat settings.prod.json)
forever start $DIR/bundle/main.js
