FROM debian:buster-slim

ENV V2RAY_VERSION=4.23.1
ARG V2RAY_URL=https://iffy.me/pub/v2ray-linux-amd64.tar.gz
ARG V2RAY_FILES="\
v2ray \
v2ctl \
geoip.dat \
geosite.dat \
"

RUN set -ex \
  ; sed -i 's/\(.*\)\(security\|deb\).debian.org\(.*\)main/\1ftp.cn.debian.org\3main contrib non-free/g' /etc/apt/sources.list \
  ; apt-get update \
  ; apt-get install -y --no-install-recommends \
        ca-certificates tzdata curl \
  \
  ; ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime \
  ; echo "$TIMEZONE" > /etc/timezone \
  ; apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* \
  \
  ; mkdir -p /usr/bin/v2ray \
  ; mkdir /var/log/v2ray/ \
  ; curl -#L ${V2RAY_URL} \
    | tar zxvf - -C /usr/bin/v2ray ${V2RAY_FILES} \
  ; chmod +x /usr/bin/v2ray/v2ctl \
  ; chmod +x /usr/bin/v2ray/v2ray

ENV PATH /usr/bin/v2ray:$PATH

COPY server.json /etc/v2ray/config.json
CMD ["v2ray", "-config=/etc/v2ray/config.json"]