FROM ubuntu:focal

ENV V2RAY_VERSION=v4.31.1
ARG V2RAY_URL=https://github.com/v2fly/v2ray-core/releases/download/${V2RAY_VERSION}/v2ray-linux-64.zip
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
        ca-certificates tzdata wget curl unzip \
  \
  ; ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime \
  ; echo "$TIMEZONE" > /etc/timezone \
  ; apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* \
  \
  ; mkdir -p /usr/bin/v2ray \
  ; mkdir /var/log/v2ray/ \
  \
  ; mkdir -p /tmp/v2ray \
  ; cd /tmp/v2ray \
  ; wget ${V2RAY_URL} \
  ; unzip v2ray-linux-64.zip \
  ; mv ${V2RAY_FILES} /usr/bin/v2ray \
  ; cd .. \
  ; rm -rf /tmp/v2ray

ENV PATH /usr/bin/v2ray:$PATH

COPY server.json /etc/v2ray/config.json
CMD ["v2ray", "-config=/etc/v2ray/config.json"]