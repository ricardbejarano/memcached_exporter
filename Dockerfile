FROM golang:1-alpine AS build

ARG VERSION="0.14.0"
ARG CHECKSUM="61f66b3d260a16eba3ecdfbf161c7a0beb6516e76e7ba28c793c65719c48768e"

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
