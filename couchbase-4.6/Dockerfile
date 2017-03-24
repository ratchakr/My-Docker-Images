FROM couchbase:latest

ENV DOCKER_HOST_IP ${DOCKER_HOST_IP:-192.168.99.100}

ENV BUCKET_NAME ${BUCKET_NAME:-books}


COPY configure.sh /opt/couchbase

CMD ["/opt/couchbase/configure.sh"]
