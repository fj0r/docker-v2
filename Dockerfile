FROM ubuntu:latest as builder

ENV V2RAY_VERSION=4.22.1
RUN apt-get update
RUN apt-get install curl -y
RUN curl -L -o /tmp/go.sh https://install.direct/go.sh
RUN chmod +x /tmp/go.sh
RUN /tmp/go.sh


FROM debian:buster-slim

COPY --from=builder /usr/bin/v2ray/v2ray /usr/bin/v2ray/
COPY --from=builder /usr/bin/v2ray/v2ctl /usr/bin/v2ray/
COPY --from=builder /usr/bin/v2ray/geoip.dat /usr/bin/v2ray/
COPY --from=builder /usr/bin/v2ray/geosite.dat /usr/bin/v2ray/

RUN set -ex \
  ; sed -i 's/\(.*\)\(security\|deb\).debian.org\(.*\)main/\1ftp.cn.debian.org\3main contrib non-free/g' /etc/apt/sources.list \
  ; apt-get update \
  ; apt-get install -y --no-install-recommends \
        ca-certificates tzdata \
  ; mkdir /var/log/v2ray/ \
  ; chmod +x /usr/bin/v2ray/v2ctl \
  ; chmod +x /usr/bin/v2ray/v2ray \
  \
  ; ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime \
  ; echo "$TIMEZONE" > /etc/timezone \
  ; apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*

ENV PATH /usr/bin/v2ray:$PATH

COPY server.json /etc/v2ray/config.json
CMD ["v2ray", "-config=/etc/v2ray/config.json"]