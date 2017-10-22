#!/bin/sh

HUBOT_NAME=${HUBOT_NAME:-"hubot"}
HUBOT_DESCIPTION=${HUBOT_DESCIPTION:-"hubot bot"}
HUBOT_EXTERNAL_SCRIPTS=${HUBOT_EXTERNAL_SCRIPTS:-""}

if [ -z ${HUBOT_OWNER+x} ]; then
    echo "env HUBOT_OWNER required"
    exit 1
fi

if [ -z ${MATTERMOST_HOST+x} ]; then
    echo "env MATTERMOST_HOST required"
    exit 1
fi

if [ -z ${MATTERMOST_GROUP+x} ]; then
    echo "env MATTERMOST_GROUP required"
    exit 1
fi

if [ -z ${MATTERMOST_PASSWORD+x} ]; then
    echo "env MATTERMOST_PASSWORD required"
    exit 1
fi

cd /hubot || exit 1

echo "No"| gosu hubot yo hubot --adapter matteruser --owner="${HUBOT_OWNER}" --name="${HUBOT_NAME}" --description="${HUBOT_DESCIPTION}" --defaults

echo $HUBOT_EXTERNAL_SCRIPTS | jq -R 'split(",")' > external-scripts.json

gosu hubot npm install --save "$(cat external-scripts.json | jq '[].')"

gosu hubot /hubot/bin/hubot --adapter matteruser
