FROM debian:wheezy

RUN apt-key adv --keyserver pgp.mit.edu --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
 && echo "deb http://download.mono-project.com/repo/debian wheezy main" > /etc/apt/sources.list.d/mono-xamarin.list \
 && apt-get update \
 && apt-get install -y --fix-missing mono-devel \
 && rm -rf /var/lib/apt/lists/*

COPY proget_start.sh /proget_start.sh

EXPOSE 80
ENV MONO_IOMAP case

ENV PROGET_VERSION 4.0.2
ENV PROGET_DIR /usr/local/proget

RUN apt-get update \
 && apt-get install -y wget bzip2 \
 && mkdir $PROGET_DIR \
 && wget "https://s3.amazonaws.com/cdn.inedo.com/downloads/proget-linux/proget$PROGET_VERSION.tar.bz2" \
 && tar -xvj -C $PROGET_DIR -f "proget$PROGET_VERSION.tar.bz2" \
 && sed -i 's/Server=localhost/Server=db/g' $PROGET_DIR/web/*.config \
 && sed -i 's/Server=localhost/Server=db/g' $PROGET_DIR/service/*.config \
 && rm "proget$PROGET_VERSION.tar.bz2" \
 && apt-get purge -y wget bzip2 \
 && apt-get autoremove -y \
 && rm -rf /var/lib/apt/lists/*

VOLUME /var/proget/packages

RUN chmod +x /proget_start.sh
ENTRYPOINT exec /proget_start.sh
