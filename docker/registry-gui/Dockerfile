FROM alpine:3

ARG CHECKSUM="ade837fc5224acd8c34732bf54a94f579b47851cc6a7fd5899a98386b782e228"
ARG VERSION="0.16.1"

ARG USER="registry-user"
ARG GROUP="taskrunner"

RUN apk update \
    && apk add curl --no-cache \
    && curl -fsSL "https://github.com/genuinetools/reg/releases/download/v${VERSION}/reg-linux-amd64" -o "/usr/local/bin/reg" \
    && echo "${CHECKSUM}  /usr/local/bin/reg" | sha256sum -c - \
    && chmod a+x '/usr/local/bin/reg' \
    && addgroup -g 1010 ${GROUP} \
    && adduser -D -H -G ${GROUP} -u 1010 ${USER} \
    && mkdir -p /opt/reg \
    && chown ${USER}:${GROUP} /opt/reg \
    && apk del curl

USER registry-user
WORKDIR /opt/reg
COPY docker-start.sh /docker-start.sh

EXPOSE 8080
CMD ["/docker-start.sh"]
