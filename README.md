<p align="center"><img src="https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/320/apple/198/fire-extinguisher_1f9ef.png" width="120px"></p>
<h1 align="center">memcached_exporter (container image)</h1>
<p align="center">Minimal container image of Prometheus' <a href="https://github.com/prometheus/memcached_exporter">memcached_exporter</a></p>


## Tags

### Docker Hub

Available on [Docker Hub](https://hub.docker.com) as [`ricardbejarano/memcached_exporter`](https://hub.docker.com/r/ricardbejarano/memcached_exporter):

- [`0.6.0`, `master`, `latest` *(Dockerfile)*](https://github.com/ricardbejarano/memcached_exporter/blob/master/Dockerfile) (about `13.5MB`)

### Quay

Available on [Quay](https://quay.io) as [`quay.io/ricardbejarano/memcached_exporter`](https://quay.io/repository/ricardbejarano/memcached_exporter):

- [`0.6.0`, `master`, `latest` *(Dockerfile)*](https://github.com/ricardbejarano/memcached_exporter/blob/master/Dockerfile) (about `13.5MB`)


## Features

* Super tiny (see [Tags](#tags))
* Binary pulled from official sources during build time
* Built `FROM scratch`, with zero bloat (see [Filesystem](#filesystem))
* Reduced attack surface (no shell, no UNIX tools, no package manager...)
* Runs as unprivileged (non-`root`) user


## Building

```bash
docker build -t memcached_exporter .
```


## Filesystem

```
/
├── memcached_exporter
└── etc/
    ├── group
    └── passwd
```


## License

See [LICENSE](https://github.com/ricardbejarano/memcached_exporter/blob/master/LICENSE).
