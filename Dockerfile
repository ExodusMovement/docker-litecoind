FROM ubuntu:18.04 AS builder

ENV BUILD_TAG 0.16.3

RUN apt update
RUN apt install -y --no-install-recommends \
  autoconf \
  automake \
  build-essential \
  ca-certificates \
  libboost-chrono-dev \
  libboost-filesystem-dev \
  libboost-program-options-dev \
  libboost-system-dev \
  libboost-thread-dev \
  libczmq-dev \
  libevent-dev \
  libssl-dev \
  libtool \
  pkg-config \
  wget

RUN wget -qO- https://github.com/litecoin-project/litecoin/archive/v$BUILD_TAG.tar.gz | tar xz && mv /litecoin-$BUILD_TAG /litecoin
WORKDIR /litecoin

RUN ./autogen.sh
RUN ./configure \
  --disable-shared \
  --disable-static \
  --disable-wallet \
  --disable-tests \
  --disable-bench \
  --enable-zmq \
  --with-utils \
  --without-libs \
  --without-gui
RUN make -j$(nproc)
RUN strip src/litecoind src/litecoin-cli


FROM ubuntu:18.04

RUN apt update \
  && apt-get install -y --no-install-recommends \
    libboost-chrono1.65.1 \
    libboost-filesystem1.65.1 \
    libboost-program-options1.65.1 \
    libboost-system1.65.1 \
    libboost-thread1.65.1 \
    libczmq-dev \
    libevent-dev \
    libssl-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

COPY --from=builder /litecoin/src/litecoind /litecoin/src/litecoin-cli /usr/local/bin/

RUN groupadd --gid 1000 litecoind \
  && useradd --uid 1000 --gid litecoind --shell /bin/bash --create-home litecoind

USER litecoind

# P2P & RPC
EXPOSE 9333 9332

ENV \
  LITECOIND_DBCACHE=450 \
  LITECOIND_PAR=0 \
  LITECOIND_PORT=9333 \
  LITECOIND_RPC_PORT=9332 \
  LITECOIND_RPC_THREADS=4 \
  LITECOIND_ARGUMENTS=""

CMD exec litecoind \
  -dbcache=$LITECOIND_DBCACHE \
  -par=$LITECOIND_PAR \
  -port=$LITECOIND_PORT \
  -rpcport=$LITECOIND_RPC_PORT \
  -rpcthreads=$LITECOIND_RPC_THREADS \
  $LITECOIND_ARGUMENTS
