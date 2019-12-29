FROM debian:stretch-slim
LABEL maintainer="Stephen Price <stephen@stp5.net>"

ENV DNSCRYPT_PROXY_VERSION=2.0.36 \
    DNSCRYPT_PROXY_SHA256=2e01552c83accb02a7b7d768863a12733966066c67742bac5665fdb2df10abd7

ENV UID 1000
ENV GID 1000
ENV TIMEZONE UTC

RUN apt-get update \
  && apt-get install -y curl libcap2-bin

RUN mkdir /tmp/dnscrypt-proxy \
    && curl -fsSL https://github.com/DNSCrypt/dnscrypt-proxy/releases/download/${DNSCRYPT_PROXY_VERSION}/dnscrypt-proxy-linux_x86_64-${DNSCRYPT_PROXY_VERSION}.tar.gz -o /tmp/dnscrypt-proxy/dnscrypt-proxy.tar.gz \
    && cd /tmp/dnscrypt-proxy \
    && echo "${DNSCRYPT_PROXY_SHA256} *dnscrypt-proxy.tar.gz" | sha256sum -c - \
    && tar zxf dnscrypt-proxy.tar.gz \
    && addgroup --gid ${GID} dnscrypt \
    && adduser --system --uid ${UID} --gid ${GID} --home /dnscrypt dnscrypt \
    && mv linux-x86_64/dnscrypt-proxy /dnscrypt/dnscrypt-proxy \
    && chown dnscrypt.dnscrypt /dnscrypt/dnscrypt-proxy \
    && setcap 'cap_net_bind_service=+ep' /dnscrypt/dnscrypt-proxy \
    && cd / \
    && rm -rf /tmp/dnscrypt-proxy \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

EXPOSE 53/tcp 53/udp

ENV SERVER_NAMES="'scaleway-fr', 'google', 'yandex', 'cloudflare'"
ENV REQUIRE_DNSSEC=false
ENV LOG_LEVEL=2

USER dnscrypt

ADD ./dnscrypt-proxy.toml /dnscrypt/dnscrypt-proxy.toml
ADD ./run.sh /dnscrypt/run.sh

WORKDIR /dnscrypt
CMD ["./run.sh"]
