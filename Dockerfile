FROM golang:1-alpine AS build

ARG VERSION="0.13.0"
ARG CHECKSUM="bf8384f4cea5066a6492fdded2b0bef35859407363c20e2788b220373f09951c"

ADD https://github.com/prometheus/memcached_exporter/archive/v$VERSION.tar.gz /tmp/memcached_exporter.tar.gz

RUN [ "$(sha256sum /tmp/memcached_exporter.tar.gz | awk '{print $1}')" = "$CHECKSUM" ] && \
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
