# dnscrypt-proxy 2 Docker image

## Description

Installs dnscrypt-proxy 2 in an Alpine Linux Docker image:
https://github.com/jedisct1/dnscrypt-proxy

## Configuration

You can set a few variables depending on your needs:

* `SERVER_NAMES="'scaleway-fr', 'google', 'yandex', 'cloudflare'"`: Set to a comma-separated, single-quoted list
  of server names based on [https://download.dnscrypt.info/dnscrypt-resolvers/v2/public-resolvers.md](this list).
* `REQUIRE_DNSSEC=false`: set to `true` if you want to require DNSSEC queries
* `LOG_LEVEL=2`: Can be set to `0` to `6`, where a lower number is more
  verbose.

## Running

This container will listen on 5353 tcp and udp. If you want `dnscrypt-proxy` to listen on the default port 53 tcp/udp, run with a command similar to:

```
docker run -p 53:5353/tcp -p 53:5353/udp \
  -e REQUIRE_DNSSEC=true \
  -e LOG_LEVEL=5 \
  -e SERVER_NAMES="'cloudflare'" \
  --name dnscrypt-proxy \
  steeef/dnscrypt-proxy
```
