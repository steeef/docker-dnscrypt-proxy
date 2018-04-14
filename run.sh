#!/bin/sh

sed -i "s/%%SERVER_NAMES%%/${SERVER_NAMES}/" dnscrypt_proxy.toml
sed -i "s/%%REQUIRE_DNSSEC%%/${REQUIRE_DNSSEC}/" dnscrypt_proxy.toml
sed -i "s/%%LOG_LEVEL%%/${LOG_LEVEL}/" dnscrypt_proxy.toml
