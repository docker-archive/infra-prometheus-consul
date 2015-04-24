# prometheus-consul

This Docker image run prometheus along with consul-template to update
the prometheus config. It adds job, if found, for the following
services:

- prometheus-node-exporter
- prometheus-container-exporter
- prometheus-haproxy-exporter
- prometheus-cloudwatch-exporter
- prometheus-pushgateway
- prometheus-alertmanager

It requires the services to have a tag which will be added as label to
the job.

As the parent image [prom/prometheus](https://hub.docker.com/u/prom/prometheus),
this image stores the metrics in a volume at `/prometheus`. It's
advised to use a data volume container to persist the metrics when
updating the image:

    $ docker run --name prometheus-data -v /prometheus busybox true
    $ docker run --volumes-from prometheus-data dckr/prometheus-consul ...

This way you can remove and recreate the prometheus container while
keeping the metrics around.

## Configuration
You can pass consul-template parameters directly to the image like
this:

    $ docker run dckr/prometheus-consul -consul consul:8500

Yo pass command line arguments to prometheus, you can set them via the
PROMETHEUS_OPTS env variable:

    $ docker run -e PROMETHEUS_OPTS="-alertmanager.url=http://alarm:9095" \
                 -p 9090:9090 dckr/prometheus-consul -consul consul:8500

To customize the config template itself or the console templates,
create a new directory with the following files (all optional):

    ./prometheus.conf.tmpl: the prometheus config consul template
    ./prometheus/consoles: prometheus console templates
    ./prometheus/console_libraries: prometheus console libraries

Now create a Dockerfile with only `FROM dckr/prometheus-consul` in it.
Building this image will replace the provided template with the
templates in your directory.
