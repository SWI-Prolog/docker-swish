FROM mndrix/swipl:latest

RUN apt-get install -y git curl unzip

RUN git clone https://github.com/SWI-Prolog/swish.git
RUN curl http://www.swi-prolog.org/download/swish/swish-bower-components.zip > swish/swish-bower-components.zip
RUN cd swish && unzip swish-bower-components.zip
ADD daemon.pl swish/daemon.pl
RUN useradd -ms /bin/false swish

CMD cd swish && swipl daemon.pl	--port=3050 --user=swish --no-fork
