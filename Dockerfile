FROM muhlisbc/docker-ruby

MAINTAINER Muhlis BC "muhlisbc@gmail.com"

ENV RAILS_LOG_TO_STDOUT=1 \
	RAILS_ENV=production

WORKDIR /app

COPY . /app

RUN rm -f /etc/nginx/*ed/* \
	&& mv nginx_vhost.conf /etc/nginx/*ed/ \
	&& echo "gem: --no-document" >> $HOME/.gemrc \
	&& bundle \
	&& rm -rf /var/lib/apt/lists/* /tmp/*

EXPOSE 80

CMD bash /app/start.sh
