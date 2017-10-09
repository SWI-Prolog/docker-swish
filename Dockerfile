FROM swipl

LABEL maintainer "Jan Wielemaker <jan@swi-prolog.org>"

RUN apt-get update && \
    apt-get install -y git build-essential autoconf curl unzip \
		       cleancss node-requirejs \
		       graphviz imagemagick

ENV SWISH_HOME /swish
ENV SWISH_DATA /data
ENV SWISH_SHA1 3f262a39c2e1480b0722a0906f0fee603cb67124

VOLUME ${SWISH_DATA}

RUN echo "At version ${SWISH_SHA1}"
RUN git clone https://github.com/SWI-Prolog/swish.git && \
    (cd swish && git checkout -q ${SWISH_SHA1})
RUN make -C /swish RJS="nodejs /usr/lib/nodejs/requirejs/r.js" \
	bower-zip packs min

COPY entry.sh entry.sh

WORKDIR ${SWISH_DATA}

ENTRYPOINT ["/entry.sh"]
