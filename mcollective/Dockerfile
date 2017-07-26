FROM debian:jessie

RUN apt-get update \
  && apt-get install -y wget \
  && wget https://apt.puppetlabs.com/puppet5-release-jessie.deb \
  && dpkg -i puppet5-release-jessie.deb \
  && apt-get update \
  && apt-get install puppet-agent \
  && apt-get clean

ADD server.cfg /etc/puppetlabs/mcollective/server.cfg
ADD client.cfg /etc/puppetlabs/mcollective/client.cfg

ADD prometheus.ddl /opt/puppetlabs/puppet/lib/ruby/vendor_ruby/mcollective/agent/
ADD prometheus.rb /opt/puppetlabs/puppet/lib/ruby/vendor_ruby/mcollective/agent/
ADD prometheus-targets.yml /etc/

CMD ["/opt/puppetlabs/puppet/bin/mcollectived","--no-daemonize","--config","/etc/puppetlabs/mcollective/server.cfg"]

