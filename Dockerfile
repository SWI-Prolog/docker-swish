FROM swipl as base

RUN apt-get update && apt-get install -y \
    git build-essential autoconf curl unzip \
    cleancss node-requirejs

ENV SWISH_HOME /swish
ENV SWISH_SHA1 3d3ae7cf91f53e34e6f0d030ffd68c1c196b2a74

RUN echo "At version ${SWISH_SHA1}"
RUN git clone https://github.com/SWI-Prolog/swish.git ${SWISH_HOME} && \
    (cd ${SWISH_HOME} && git checkout -q ${SWISH_SHA1})
RUN make -C ${SWISH_HOME} RJS="nodejs /usr/lib/nodejs/requirejs/r.js" \
	bower-zip packs min

FROM base
LABEL maintainer "Jan Wielemaker <jan@swi-prolog.org>"

RUN apt-get update && apt-get install -y \
    graphviz imagemagick \
    wamerican && \
    rm -rf /var/lib/apt/lists/*

COPY --from=base ${SWISH_HOME} ${SWISH_HOME}
COPY entry.sh /entry.sh

ENV SWISH_DATA /data
VOLUME ${SWISH_DATA}
WORKDIR ${SWISH_DATA}

ENTRYPOINT ["/entry.sh"]
