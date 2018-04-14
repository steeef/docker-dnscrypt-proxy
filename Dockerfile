FROM alpine:3.7
MAINTAINER Stephen Price <stephen@stp5.net>

ENV TIMEZONE UTC
ENV DNSCRYPT_PROXY_VERSION 2.0.9

ADD https://github.com/jedisct1/dnscrypt-proxy/releases/download/${DNSCRYPT_PROXY_VERSION}/dnscrypt-proxy-linux_x86_64-${DNSCRYPT_PROXY_VERSION}.tar.gz ./
ADD ./dnscrypt-proxy.toml /etc/dnscrypt-proxy/dnscrypt-proxy.toml

EXPOSE 5353/tcp 5353/udp

CMD ["dnscrypt-proxy", "-config", "/etc/dnscrypt-proxy/dnscrypt-proxy.toml"]
