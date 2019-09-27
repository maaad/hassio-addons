
FROM telegraf

# Add env
ENV LANG C.UTF-8

# Setup base
#RUN apk add --no-cache jq
RUN apt-get update \
    && apt-get install -y jq

# Copy data
COPY run.sh /
COPY telegraf.conf /etc/telegraf/

RUN chmod a+x /run.sh

COPY entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD [ "/run.sh" ]
