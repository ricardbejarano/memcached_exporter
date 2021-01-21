FROM golang:1-alpine AS build

ARG VERSION="0.8.0"
ARG CHECKSUM="a861ade4ad1a6ab8298b1a0a7228c7ba8331baefc66dfeade72b51b2981fd680"

ADD https://github.com/prometheus/memcached_exporter/archive/v$VERSION.tar.gz /tmp/memcached_exporter.tar.gz

RUN [ "$CHECKSUM" = "$(sha256sum /tmp/memcached_exporter.tar.gz | awk '{print $1}')" ] && \
    apk add ca-certificates curl make && \
    tar -C /tmp -xf /tmp/memcached_exporter.tar.gz && \
    mkdir -p /go/src/github.com/prometheus && \
    mv /tmp/memcached_exporter-$VERSION /go/src/github.com/prometheus/memcached_exporter && \
    cd /go/src/github.com/prometheus/memcached_exporter && \
      make build

RUN mkdir -p /rootfs/bin && \
      cp /go/src/github.com/prometheus/memcached_exporter/memcached_exporter /rootfs/bin/ && \
    mkdir -p /rootfs/etc && \
      echo "nogroup:*:10000:nobody" > /rootfs/etc/group && \
      echo "nobody:*:10000:10000:::" > /rootfs/etc/passwd


FROM scratch

COPY --from=build --chown=10000:10000 /rootfs /

USER 10000:10000
EXPOSE 9150/tcp
ENTRYPOINT ["/bin/memcached_exporter"]
