FROM swipl

VOLUME /data

COPY swish swish
COPY swish.sh swish.sh
EXPOSE 3050

ENV SWISH_HOME /swish
ENV SWISH_DATA /data
WORKDIR ${SWISH_DATA}

ENTRYPOINT ["/swish.sh"]
