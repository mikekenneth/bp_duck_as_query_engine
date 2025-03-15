FROM ubuntu:24.04 AS base
ARG DUCKDB_VERSION=v1.2.1

FROM base AS base-amd64
ARG DUCKDB_ARCH=amd64

FROM base AS base-arm64
ARG DUCKDB_ARCH=aarch64


FROM base-$TARGETARCH

WORKDIR /usr/app/
RUN apt-get update  \
    && apt-get install -y curl unzip \
    && curl -L -o duckdb_cli.zip "https://github.com/duckdb/duckdb/releases/download/${DUCKDB_VERSION}/duckdb_cli-linux-${DUCKDB_ARCH}.zip" \
    && unzip duckdb_cli.zip \
    && rm duckdb_cli.zip

RUN ln -s /usr/app/duckdb /usr/bin/duckdb

# If you want to initialize your db instance, mount the '/usr/app/init.sql' file
CMD /usr/app/duckdb /usr/app/duck.db -f /usr/app/init.sql && tail -f /dev/null

# ENTRYPOINT ["tail", "-f", "/dev/null"]
