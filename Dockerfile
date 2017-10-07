FROM swipl
RUN apt-get update && \
    apt-get install -y git build-essential autoconf curl unzip \
		       cleancss node-requirejs \
		       graphviz imagemagick

ENV SWISH_HOME /swish
ENV SWISH_DATA /data

VOLUME ${SWISH_DATA}

RUN echo "At version 33ad316a60429f2ba1569dce70a4397a4b2e3531"
RUN git clone https://github.com/SWI-Prolog/swish.git
RUN make -C /swish RJS="nodejs /usr/lib/nodejs/requirejs/r.js" \
	bower-zip packs min

COPY swish.sh swish.sh

WORKDIR ${SWISH_DATA}

ENTRYPOINT ["/swish.sh"]
