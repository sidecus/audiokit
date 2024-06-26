# Use python slim image as the base for both build and runtime stages
FROM python:3.12.2-slim as builder
RUN apt-get update && apt-get install -y \
    libspeex-dev \
    git \
    gcc \
    make \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY ./speex_decode/ ./
RUN make

# Start new stage for the runtime environment
FROM python:3.12.2-slim
# Install runtime dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libsndfile1-dev \
        libspeex-dev \
        libatlas3-base \
        ffmpeg \
        sox \
        curl \
    && rm -rf /var/lib/apt/lists/*
# Set up Kaldi libraries
WORKDIR /app/kaldilibs
COPY --from=pykaldi/pykaldi:latest /kaldi/src/feat/libkaldi-feat.so \
                                    /kaldi/src/util/libkaldi-util.so \
                                    /kaldi/src/matrix/libkaldi-matrix.so \
                                    /kaldi/src/base/libkaldi-base.so \
                                    /kaldi/src/transform/libkaldi-transform.so \
                                    /kaldi/src/gmm/libkaldi-gmm.so \
                                    /kaldi/src/tree/libkaldi-tree.so \
                                    ./
COPY ./registerkaldi.sh ./
RUN sh ./registerkaldi.sh

# Copy kaldi wav-reverberate, speex_decode and set PATH
WORKDIR /app
COPY --from=pykaldi/pykaldi:latest /kaldi/src/featbin/wav-reverberate ./
COPY --from=build /app/bin/speex_decode ./
ENV PATH="/app:${PATH}"

# Usage: docker run -it -v $HOME/repos/audiodata:/audiodata speexdecode