FROM alpine:3.10
MAINTAINER Stephen Price <stephen@stp5.net>

ENV DNSCRYPT_PROXY_VERSION=2.0.36 \
    DNSCRYPT_PROXY_SHA256=2e01552c83accb02a7b7d768863a12733966066c67742bac5665fdb2df10abd7

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
