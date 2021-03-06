FROM ubuntu:18.04

RUN apt-get update; apt-get upgrade -f; \
    apt-get install -y golang git

ENV GOPATH="/root/go"
ENV PATH="$GOPATH/bin:$PATH"

RUN mkdir -p $GOPATH/src/github.com/barnumd/vault-fastly-secret-engine
WORKDIR $GOPATH/src/github.com/barnumd/vault-fastly-secret-engine
COPY . .

RUN make
#Output SHASUM
RUN SHASUM=$(shasum -a 256 vault-fastly-secret-engine | cut -d " " -f1); \
    echo "SHASUM for vault package is: ${SHASUM}";


#Final image
FROM vault:1.3.4

RUN mkdir /tmp/vault-plugins
COPY --from=0 /root/go/src/github.com/barnumd/vault-fastly-secret-engine/vault-fastly-secret-engine /tmp/vault-plugins/
COPY vault-fastly-secret-engine /tmp/vault-plugins
RUN echo 'plugin_directory = "/tmp/vault-plugins"' >> /vault/config/plugin.hcl