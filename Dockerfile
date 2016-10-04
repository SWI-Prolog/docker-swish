FROM mndrix/swipl:latest

RUN apt-get update
RUN apt-get dist-upgrade -y
RUN apt-get install -y git curl unzip

RUN git clone https://github.com/SWI-Prolog/swish.git #4
RUN curl http://www.swi-prolog.org/download/swish/swish-bower-components.zip > swish/swish-bower-components.zip; \
    (cd swish && unzip swish-bower-components.zip && rm swish-bower-components.zip)

VOLUME /data

COPY swish.sh swish.sh
EXPOSE 3050

ENV SWISH_HOME /swish
ENV SWISH_DATA /data
WORKDIR ${SWISH_DATA}

ENTRYPOINT ["bash", "/swish.sh"]
