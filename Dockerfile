FROM alpine:3.7
MAINTAINER Stephen Price <stephen@stp5.net>

ENV DNSCRYPT_PROXY_VERSION=2.0.9 \
    DNSCRYPT_PROXY_SHA256=0468a3a1233b229c6f730cf522c95480efada8d740db0da4a44fdd37fa1cb5e4

ENV UID 1000
ENV GID 1000
ENV TIMEZONE UTC

RUN apk add --no-cache curl ca-certificates libc6-compat

RUN mkdir /tmp/dnscrypt-proxy \
    && curl -fsSL https://github.com/jedisct1/dnscrypt-proxy/releases/download/${DNSCRYPT_PROXY_VERSION}/dnscrypt-proxy-linux_x86_64-${DNSCRYPT_PROXY_VERSION}.tar.gz -o /tmp/dnscrypt-proxy/dnscrypt-proxy.tar.gz \
    && cd /tmp/dnscrypt-proxy \
    && echo "${DNSCRYPT_PROXY_SHA256} *dnscrypt-proxy.tar.gz" | sha256sum -c - \
    && tar zxf dnscrypt-proxy.tar.gz \
    && addgroup -g ${GID} dnscrypt \
    && adduser -S -u ${UID} -G dnscrypt -h /dnscrypt dnscrypt \
    && mv linux-x86_64/dnscrypt-proxy /dnscrypt/dnscrypt-proxy \
    && cd / \
    && rm -rf /tmp/dnscrypt-proxy \
    && apk del curl

EXPOSE 5353/tcp 5353/udp

ENV SERVER_NAMES="'scaleway-fr', 'google', 'yandex', 'cloudflare'"
ENV REQUIRE_DNSSEC=false
ENV LOG_LEVEL=2

USER dnscrypt

ADD ./dnscrypt-proxy.toml /dnscrypt/dnscrypt-proxy.toml
ADD ./run.sh /dnscrypt/run.sh

WORKDIR /dnscrypt
CMD ["./run.sh"]
