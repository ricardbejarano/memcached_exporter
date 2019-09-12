FROM alpine:3 AS build

ARG VERSION="0.6.0"
ARG CHECKSUM="20382d37ca99bbde2661fdbfb43a181f95d68889b761e56b39678e31bb23b64c"

ADD https://github.com/prometheus/memcached_exporter/releases/download/v$VERSION/memcached_exporter-$VERSION.linux-amd64.tar.gz /tmp/memcached_exporter.tar.gz

RUN [ "$CHECKSUM" = "$(sha256sum /tmp/memcached_exporter.tar.gz | awk '{print $1}')" ] && \
    tar -C /tmp -xf /tmp/memcached_exporter.tar.gz && \
    mv /tmp/memcached_exporter-$VERSION.linux-amd64 /tmp/memcached_exporter

RUN echo "nogroup:*:100:nobody" > /tmp/group && \
    echo "nobody:*:100:100:::" > /tmp/passwd


FROM scratch

COPY --from=build --chown=100:100 /tmp/memcached_exporter/memcached_exporter /
COPY --from=build --chown=100:100 /tmp/group \
                                  /tmp/passwd \
                                  /etc/

USER 100:100
EXPOSE 9150/tcp
ENTRYPOINT ["/memcached_exporter"]
