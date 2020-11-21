FROM ubuntu:latest

RUN apt update
RUN apt install -y wget git build-essential
RUN wget https://golang.org/dl/go1.15.5.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf go1.15.5.linux-amd64.tar.gz

ENV PATH $PATH:/usr/local/go/bin:/root/go/bin

RUN go get -u github.com/cloudflare/cfssl/cmd/...
RUN mkdir -p /certs
ADD ca-csr.json /certs
ADD ca-config.json /certs
RUN cd /certs && cfssl gencert -initca /certs/ca-csr.json | cfssljson -bare ca

ADD entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT [ "/bin/bash", "entrypoint.sh" ]