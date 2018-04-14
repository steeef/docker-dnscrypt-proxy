FROM alpine:3.7
MAINTAINER Stephen Price <stephen@stp5.net>

ENV DNSCRYPT_PROXY_VERSION 2.0.9

ENV UID 1000
ENV GID 1000
ENV TIMEZONE UTC

RUN apk add --no-cache ca-certificates

RUN addgroup -g ${GID} dnscrypt \
    && adduser -S -u ${UID} -G dnscrypt -h /dnscrypt dnscrypt

ADD https://github.com/jedisct1/dnscrypt-proxy/releases/download/${DNSCRYPT_PROXY_VERSION}/dnscrypt-proxy-linux_x86_64-${DNSCRYPT_PROXY_VERSION}.tar.gz /tmp/dnscrypt-proxy.tar.gz
ADD ./dnscrypt-proxy.toml /dnscrypt/dnscrypt-proxy.toml

RUN tar zxf /tmp/dnscrypt-proxy.tar.gz \
    && mv linux-x86_64/dnscrypt-proxy /dnscrypt/dnscrypt-proxy \
    && mkdir /lib64 \
    && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2 \
    && rm -rf linux-x86_64 \
    && rm -f /tmp/dnscrypt-proxy.tar.gz

USER dnscrypt

EXPOSE 5353/tcp 5353/udp

WORKDIR /dnscrypt
CMD ["./dnscrypt-proxy"]
