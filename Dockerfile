FROM swipl
RUN apt-get update && \
    apt-get install -y git build-essential autoconf curl unzip \
		       cleancss node-requirejs \
		       graphviz imagemagick

ENV SWISH_HOME /swish
ENV SWISH_DATA /data
ENV SWISH_SHA1 2bccdb6617f7cade39cf1a3f6918ecd4453430f2

VOLUME ${SWISH_DATA}

RUN echo "At version ${SWISH_SHA1}"
RUN git clone https://github.com/SWI-Prolog/swish.git && \
    (cd swish && git checkout -q ${SWISH_SHA1})
RUN make -C /swish RJS="nodejs /usr/lib/nodejs/requirejs/r.js" \
	bower-zip packs min

COPY swish.sh swish.sh

WORKDIR ${SWISH_DATA}

ENTRYPOINT ["/swish.sh"]
