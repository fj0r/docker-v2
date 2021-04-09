FROM debian:testing-slim

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8 TIMEZONE=Asia/Shanghai

ARG v2ray_repo=v2fly/v2ray-core
ARG v2ray_files="\
v2ray \
v2ctl \
geoip.dat \
geosite.dat \
"

RUN set -ex \
  ; sed -i 's/\(.*\)\(security\|deb\).debian.org\(.*\)main/\1ftp.cn.debian.org\3main contrib non-free/g' /etc/apt/sources.list \
  ; apt-get update \
  ; DEBIAN_FRONTEND=noninteractive \
  ; apt-get install -y --no-install-recommends \
        ca-certificates tzdata locales curl unzip jq \
  \
  ; ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime \
  ; echo "$TIMEZONE" > /etc/timezone \
  ; sed -i /etc/locale.gen \
		-e 's/# \(en_US.UTF-8 UTF-8\)/\1/' \
		-e 's/# \(zh_CN.UTF-8 UTF-8\)/\1/' \
	; locale-gen \
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
