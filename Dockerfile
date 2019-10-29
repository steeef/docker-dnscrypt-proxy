FROM alpine:3.10
MAINTAINER Stephen Price <stephen@stp5.net>

ENV DNSCRYPT_PROXY_VERSION=2.0.29 \
    DNSCRYPT_PROXY_SHA256=dc0d8a636d9175438266a4bd55fd53237f50948bee1a5b5a5289387b5b47954e

ENV UID 1000
ENV GID 1000
ENV TIMEZONE UTC

RUN apk add --no-cache curl libcap ca-certificates libc6-compat

RUN mkdir /tmp/dnscrypt-proxy \
    && curl -fsSL https://github.com/DNSCrypt/dnscrypt-proxy/releases/download/${DNSCRYPT_PROXY_VERSION}/dnscrypt-proxy-linux_x86_64-${DNSCRYPT_PROXY_VERSION}.tar.gz -o /tmp/dnscrypt-proxy/dnscrypt-proxy.tar.gz \
    && cd /tmp/dnscrypt-proxy \
    && echo "${DNSCRYPT_PROXY_SHA256} *dnscrypt-proxy.tar.gz" | sha256sum -c - \
    && tar zxf dnscrypt-proxy.tar.gz \
    && addgroup -g ${GID} dnscrypt \
    && adduser -S -u ${UID} -G dnscrypt -h /dnscrypt dnscrypt \
    && mv linux-x86_64/dnscrypt-proxy /dnscrypt/dnscrypt-proxy \
    && chown dnscrypt.dnscrypt /dnscrypt/dnscrypt-proxy \
    && setcap 'cap_net_bind_service=+ep' /dnscrypt/dnscrypt-proxy \
    && cd / \
    && rm -rf /tmp/dnscrypt-proxy \
    && apk del curl

EXPOSE 53/tcp 53/udp

ENV SERVER_NAMES="'scaleway-fr', 'google', 'yandex', 'cloudflare'"
ENV REQUIRE_DNSSEC=false
ENV LOG_LEVEL=2

USER dnscrypt

ADD ./dnscrypt-proxy.toml /dnscrypt/dnscrypt-proxy.toml
ADD ./run.sh /dnscrypt/run.sh

WORKDIR /dnscrypt
CMD ["./run.sh"]
