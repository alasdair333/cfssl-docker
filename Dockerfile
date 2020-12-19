FROM golang:alpine as builder

RUN apk update && apk add --no-cache wget \
            git \
            gcc \
            musl-dev \
            make

ENV CGO_ENABLED=0

WORKDIR /builddir

RUN git clone https://github.com/cloudflare/cfssl.git . && \
    git clone https://github.com/cloudflare/cfssl_trust.git /etc/cfssl && \
    make clean && \
    make bin/rice && ./bin/rice embed-go -i=./cli/serve && \
    make all && cp bin/* /bin/

RUN addgroup -S cfssl && adduser -S cfssl -G cfssl -H -h /

RUN mkdir -m777 /certs

USER cfssl
COPY --chown=cfssl:cfssl ca-csr.json /certs
COPY --chown=cfssl:cfssl ca-config.json /certs

FROM alpine

USER root

WORKDIR /

RUN mkdir -m777 /certs
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /bin/* /bin/
COPY --from=builder /certs/* /certs/
COPY entrypoint.sh /entrypoint.sh

USER cfssl
ENTRYPOINT [ "/bin/sh", "entrypoint.sh" ]