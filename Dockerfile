FROM alpine:3.10

RUN apk add --update --no-cache openssh bash

ADD entrypoint.sh /entrypoint.sh
ADD scripts /scripts

ENTRYPOINT ["/entrypoint.sh"]
