FROM ubuntu:latest as build
RUN sed -i s/archive.ubuntu.com/mirrors.aliyun.com/g /etc/apt/sources.list \
    && sed -i s/security.ubuntu.com/mirrors.aliyun.com/g /etc/apt/sources.list \
    && apt-get clean \
    && apt-get update
RUN apt-get install -y libspeex-dev git gcc make
WORKDIR /app
COPY ./ ./
RUN make

# Ubuntu for running the decoder
# Need libspeex libraries to run
# Usage: docker run -it -v $HOME/repos/audiodata:/audiodata speexdecode
FROM ubuntu:latest
RUN sed -i s/archive.ubuntu.com/mirrors.aliyun.com/g /etc/apt/sources.list \
    && sed -i s/security.ubuntu.com/mirrors.aliyun.com/g /etc/apt/sources.list \
    && apt-get clean \
    && apt-get update
RUN apt-get install -y libspeex-dev
COPY --from=build /app/bin/speex_decode /app/
ENV PATH="/app:${PATH}"
