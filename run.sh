#!/bin/sh

sed -i "s/%%SERVER_NAMES%%/${SERVER_NAMES}/" dnscrypt-proxy.toml
sed -i "s/%%REQUIRE_DNSSEC%%/${REQUIRE_DNSSEC}/" dnscrypt-proxy.toml
sed -i "s/%%LOG_LEVEL%%/${LOG_LEVEL}/" dnscrypt-proxy.toml
