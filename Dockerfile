FROM ubuntu:latest as build
RUN sed -i s/archive.ubuntu.com/mirrors.aliyun.com/g /etc/apt/sources.list \
    && sed -i s/security.ubuntu.com/mirrors.aliyun.com/g /etc/apt/sources.list \
    && apt-get clean \
    && apt-get update
RUN apt-get install -y libspeex-dev git gcc make
WORKDIR /app
COPY ./speex_decode/ ./
RUN make

# Ubuntu for running the decoder
FROM python:3.12.2-slim
RUN apt-get clean && apt-get update
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y --no-install-recommends \
        libsndfile1-dev libspeex-dev libatlas3-base \
        ffmpeg sox curl

# Copy and register kaldi wav-reverberate dependencies, then copy wav-reverberate and set path
WORKDIR /app/kaldilibs
COPY --from=pykaldi/pykaldi:latest /kaldi/src/feat/libkaldi-feat.so \
                    /kaldi/src/feat/libkaldi-feat.so \
                    /kaldi/src/util/libkaldi-util.so \
                    /kaldi/src/matrix/libkaldi-matrix.so \
                    /kaldi/src/base/libkaldi-base.so \
                    /kaldi/src/transform/libkaldi-transform.so \
                    /kaldi/src/gmm/libkaldi-gmm.so \
                    /kaldi/src/tree/libkaldi-tree.so \
                    ./
COPY ./registerkaldi.sh ./
RUN sh ./registerkaldi.sh

WORKDIR /app
COPY --from=pykaldi/pykaldi:latest /kaldi/src/featbin/wav-reverberate ./
COPY --from=build /app/bin/speex_decode ./
ENV PATH="/app:${PATH}"

# Usage: docker run -it -v $HOME/repos/audiodata:/audiodata speexdecode
