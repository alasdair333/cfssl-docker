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

WORKDIR /certs
RUN cfssl gencert -initca ca-csr.json | cfssljson -bare ca

WORKDIR /

FROM scratch

USER root

WORKDIR /

COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /bin/* /bin/
COPY --from=builder /certs/* /

USER cfssl
ENTRYPOINT [ "cfssl", "serve", "-address=0.0.0.0", "-ca-key=ca-key.pem", "-ca=ca.pem", "-config=ca-config.json" ]
