FROM node:argon-wheezy

# install nginx
RUN apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62
RUN echo "deb http://nginx.org/packages/mainline/debian/ wheezy nginx" >> /etc/apt/sources.list

ENV NGINX_VERSION 1.9.9-1~wheezy

RUN apt-get update && \
    apt-get install -y ca-certificates nginx=${NGINX_VERSION} && \
    rm -rf /var/lib/apt/lists/*

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

# install gitbook
ARG VERSION=3.2.0
LABEL version=$VERSION
RUN npm install --global gitbook-cli &&\
	gitbook fetch ${VERSION} &&\
	npm cache clear &&\
	rm -rf /tmp/*

WORKDIR /srv/gitbook
VOLUME /srv/gitbook
COPY ./gitbook /srv/gitbook
RUN gitbook install
RUN gitbook build

RUN mkdir -p /usr/share/nginx/html
RUN cp -r /srv/gitbook/_book/* /usr/share/nginx/html/
WORKDIR /usr/share/nginx/html/

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]