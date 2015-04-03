FROM prom/prometheus
ENV  CONSUL_VERSION 0.8.0
ENV  ARCH linux_amd64

RUN mkdir /etc/prometheus && \
    cp -r /go/src/github.com/prometheus/prometheus/console_libraries \
      /go/src/github.com/prometheus/prometheus/consoles /etc/prometheus && \
    mv /etc/prometheus/consoles/index.html.example /etc/prometheus/consoles/index.html && \
    useradd prometheus && \
    chown -R prometheus:prometheus /prometheus && \
    apt-get -qy install runit && \
    curl -L https://github.com/hashicorp/consul-template/releases/download/v${CONSUL_VERSION}/consul-template_${CONSUL_VERSION}_${ARCH}.tar.gz | tar -C /usr/bin --strip-components=1 -xzf -

ENTRYPOINT  [ "/etc/prometheus.run" ]
ADD         . /etc
ONBUILD ADD . /etc
