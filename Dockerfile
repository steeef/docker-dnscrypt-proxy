FROM alpine:3.7
MAINTAINER Stephen Price <stephen@stp5.net>

ENV DNSCRYPT_PROXY_VERSION 2.0.9

ENV UID 1000
ENV GID 1000
ENV TIMEZONE UTC

RUN apk add --no-cache curl ca-certificates \
    && mkdir /lib64 \
    && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2

RUN curl -sL -o /tmp/dnscrypt-proxy.tar.gz \
      https://github.com/jedisct1/dnscrypt-proxy/releases/download/${DNSCRYPT_PROXY_VERSION}/dnscrypt-proxy-linux_x86_64-${DNSCRYPT_PROXY_VERSION}.tar.gz \
    && tar zvxf /tmp/dnscrypt-proxy.tar.gz \
    && addgroup -g ${GID} dnscrypt \
    && adduser -S -u ${UID} -G dnscrypt -h /dnscrypt dnscrypt \
    && mv linux-x86_64/dnscrypt-proxy /dnscrypt/dnscrypt-proxy \
    && rm -rf linux-x86_64 \
    && rm -f /tmp/dnscrypt-proxy.tar.gz

EXPOSE 5353/tcp 5353/udp

ENV SERVER_NAMES="'cloudflare'"
ENV REQUIRE_DNSSEC=true
ENV LOG_LEVEL=2

USER dnscrypt

ADD ./dnscrypt-proxy.toml /dnscrypt/dnscrypt-proxy.toml
ADD ./run.sh /dnscrypt/run.sh

WORKDIR /dnscrypt
CMD ["./run.sh"]
