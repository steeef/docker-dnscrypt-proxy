FROM debian:stretch-slim
LABEL maintainer="Stephen Price <stephen@stp5.net>"

ENV DNSCRYPT_PROXY_VERSION=2.0.39 \
    DNSCRYPT_PROXY_SHA256=f0da25d0289719bf87a245f7ee193903f1b220062e8cebcb7a2eed44c4a60302

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
