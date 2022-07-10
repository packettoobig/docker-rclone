FROM alpine

LABEL maintainer="Pilbbq (previously, Brian J. Cardiff <bcardiff@gmail.com>)"

ARG RCLONE_VERSION=current
ARG ARCH=amd64
ENV SYNC_SRC=
ENV SYNC_DEST=
ENV SYNC_OPTS=-v
ENV RCLONE_OPTS="--config /config/rclone.conf"
ENV CRON=
ENV CRON_ABORT=
ENV FORCE_SYNC=
ENV CHECK_URL=
ENV TZ=
ENV CURL_TIMEOUT=5
ENV CURL_MAXTIME=10
ENV CURL_RETRIES=3

RUN apk -U add ca-certificates fuse wget curl dcron tzdata \
  && rm -rf /var/cache/apk/*

RUN URL=http://downloads.rclone.org/${RCLONE_VERSION}/rclone-${RCLONE_VERSION}-linux-${ARCH}.zip ; \
  URL=${URL/\/current/} ; \
  cd /tmp \
  && wget -q $URL \
  && unzip /tmp/rclone-${RCLONE_VERSION}-linux-${ARCH}.zip \
  && mv /tmp/rclone-*-linux-${ARCH}/rclone /usr/bin \
  && rm -r /tmp/rclone*

COPY entrypoint.sh /
COPY sync.sh /
COPY sync-abort.sh /

VOLUME ["/config"]

ENTRYPOINT ["/entrypoint.sh"]

CMD [""]
