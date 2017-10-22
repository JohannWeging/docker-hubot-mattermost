FROM johannweging/base-alpine:latest

RUN apk add --update --no-cache nodejs nodejs-npm jq

RUN npm install --global yo generator-hubot


# setup hubot user
RUN set -x \
&& addgroup hubot\
&& adduser -D -G  hubot hubot

RUN set -x \
&& mkdir /hubot \
&& chown hubot:hubot /hubot

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/hubot.sh"]

EXPOSE 8080

ADD rootfs /
RUN chmod +x /hubot.sh
