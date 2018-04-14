FROM alpine:3.7
MAINTAINER Stephen Price <stephen@stp5.net>

ENV TIMEZONE UTC
ENV DNSCRYPT_PROXY_VERSION 2.0.9

ADD https://github.com/jedisct1/dnscrypt-proxy/releases/download/${DNSCRYPT_PROXY_VERSION}/dnscrypt-proxy-linux_x86_64-${DNSCRYPT_PROXY_VERSION}.tar.gz /tmp/dnscrypt-proxy.tar.gz
ADD ./dnscrypt-proxy.toml /etc/dnscrypt-proxy/dnscrypt-proxy.toml

RUN apk add --no-cache ca-certificates

RUN tar zxf /tmp/dnscrypt-proxy.tar.gz \
    && mv linux-x86_64/dnscrypt-proxy /usr/bin/dnscrypt-proxy \
    && mkdir /lib64 \
    && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2 \
    && rm -rf linux-x86_64 \
    && rm -f /tmp/dnscrypt-proxy.tar.gz

EXPOSE 5353/tcp 5353/udp

CMD ["dnscrypt-proxy", "-config", "/etc/dnscrypt-proxy/dnscrypt-proxy.toml"]
