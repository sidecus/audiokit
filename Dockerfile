# Ubuntu for decoder build, with multiple reusable layers
FROM ubuntu AS build
RUN apt-get update; \
    apt-get install libspeex-dev -y;

RUN apt-get install git -y; \
    apt-get install build-essential -y;

WORKDIR /var
RUN git clone https://github.com/imhuzi/wechat-speex-declib.git; \
    cd wechat-speex-declib/; \
    make;

# Ubuntu for running the decoder
# Need libspeex libraries to run
# Usage: docker run -it -v $HOME/repos/audiodata:/audiodata speexdecode
FROM ubuntu
RUN apt-get update; \
    apt-get install libspeex-dev -y;
COPY --from=build /var/wechat-speex-declib/bin/speex_decode /var/speex_decode/
WORKDIR /var/speex_decode
