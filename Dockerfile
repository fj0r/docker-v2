FROM fj0rd/io:os

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8 TIMEZONE=Asia/Shanghai

ARG v2ray_repo=v2fly/v2ray-core
ARG v2ray_files="\
v2ray \
v2ctl \
geoip.dat \
geosite.dat \
"

RUN set -eux \
  ; apt-get update \
  ; DEBIAN_FRONTEND=noninteractive \
  ; apt-get install -y --no-install-recommends \
        ca-certificates tzdata curl unzip jq \
  \
  ; ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime \
  ; echo "$TIMEZONE" > /etc/timezone \
  ; apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* \
  \
  ; mkdir -p /usr/bin/v2ray \
  ; mkdir /var/log/v2ray/ \
  \
  ; v2ray_version=$(curl -sSL -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/${v2ray_repo}/releases | jq -r '.[0].tag_name') \
  ; v2ray_url=https://github.com/${v2ray_repo}/releases/download/${v2ray_version}/v2ray-linux-64.zip \
  ; mkdir -p /tmp/v2ray \
  ; cd /tmp/v2ray \
  ; curl -sSLo v2ray.zip ${v2ray_url} \
  ; unzip v2ray.zip \
  ; mv ${v2ray_files} /usr/bin/v2ray \
  ; cd .. \
  ; rm -rf /tmp/v2ray

ENV PATH /usr/bin/v2ray:$PATH

COPY server.json /etc/v2ray/config.json
CMD ["v2ray", "-config=/etc/v2ray/config.json"]
