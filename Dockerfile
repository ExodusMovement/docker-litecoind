FROM ubuntu:16.04

ENV LITECOIN_VERSION=0.15.1

RUN groupadd --gid 1000 litecoind \
  && useradd --uid 1000 --gid litecoind --shell /bin/bash --create-home litecoind \
  && set -x \
  && buildDeps='ca-certificates wget build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils python3 libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-test-dev libboost-thread-dev' \
  && apt update \
  && apt install -y $buildDeps --no-install-recommends \
  && wget -O v${LITECOIN_VERSION}.tar.gz https://github.com/litecoin-project/litecoin/archive/v${LITECOIN_VERSION}.tar.gz \
  && tar xvf v${LITECOIN_VERSION}.tar.gz -C /usr/local/src \
  && rm v${LITECOIN_VERSION}.tar.gz \
  && mv /usr/local/src/litecoin* /usr/local/src/litecoin \
  && cd /usr/local/src/litecoin \
  && ./autogen.sh \
  && ./configure --disable-wallet --without-gui --without-miniupnpc \
  && make -j$(nproc) \
  && strip -o /home/litecoind/litecoind /usr/local/src/litecoin/src/litecoind \
  && strip -o /home/litecoind/litecoin-cli /usr/local/src/litecoin/src/litecoin-cli \
  && chown litecoind /home/litecoind/litecoin* \
  && rm -rf /usr/local/src/litecoin

USER litecoind
ENTRYPOINT ["/home/litecoind/litecoind"]
