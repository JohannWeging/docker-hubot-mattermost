#!/bin/sh

HUBOT_NAME=${HUBOT_NAME:-"hubot"}
HUBOT_DESCIPTION=${HUBOT_DESCIPTION:-"hubot bot"}
HUBOT_EXTERNAL_SCRIPTS=${HUBOT_EXTERNAL_SCRIPTS:-""}
HUBOT_NPM_DEPS=${HUBOT_NPM_DEPS:-""}

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

echo $HUBOT_EXTERNAL_SCRIPTS | jq -R 'gsub("( |\t)+"; "") | split(",")' > external-scripts.json

if [ -n "${FILE_BRAIN_PATH+x}" ]; then
    mkdir -p ${FILE_BRAIN_PATH}
    chown hubot:hubot ${FILE_BRAIN_PATH}
fi

OIFS=${IFS}
IFS=','
for package in $( echo ${HUBOT_NPM_DEPS} | tr -d ' \t\n'); do
    gosu hubot npm install --save ${package}
done
IFS=${OIFS}

gosu hubot /hubot/bin/hubot --adapter matteruser
