FROM alpine:3 AS build

ARG VERSION="0.7.0"
ARG CHECKSUM="a8dec3f2493330159b02ab5f8916726d2d41d70170f23206b1987cdb450a839b"

ADD https://github.com/prometheus/memcached_exporter/releases/download/v$VERSION/memcached_exporter-$VERSION.linux-amd64.tar.gz /tmp/memcached_exporter.tar.gz

RUN [ "$CHECKSUM" = "$(sha256sum /tmp/memcached_exporter.tar.gz | awk '{print $1}')" ] && \
    tar -C /tmp -xf /tmp/memcached_exporter.tar.gz

RUN mkdir -p /rootfs/etc && \
    cp /tmp/memcached_exporter-$VERSION.linux-amd64/memcached_exporter /rootfs/ && \
    echo "nogroup:*:100:nobody" > /rootfs/etc/group && \
    echo "nobody:*:100:100:::" > /rootfs/etc/passwd


FROM scratch

COPY --from=build --chown=100:100 /rootfs /

USER 100:100
EXPOSE 9150/tcp
ENTRYPOINT ["/memcached_exporter"]
