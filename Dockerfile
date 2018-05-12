FROM alpine:3.7

# Install build dependences
RUN apk add --no-cache --update git cmake make curl build-base gcc g++ perl linux-headers

# OpenSSL
ARG OPENSSL_VERSION=1.0.2n
ARG OPENSSL_HASH=370babb75f278c39e0c50e8c4e7493bc0f18db6867478341a832a982fd15a8fe
RUN set -ex \
	&& curl -s -O https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz \
	&& echo "${OPENSSL_HASH}  openssl-${OPENSSL_VERSION}.tar.gz" | sha256sum -c \
	&& tar -xzf openssl-${OPENSSL_VERSION}.tar.gz \
	&& cd openssl-${OPENSSL_VERSION} \
	&& ./Configure linux-x86_64 no-shared --static -fPIC \
	&& make build_crypto build_ssl \
	&& make install
ENV OPENSSL_ROOT_DIR=/usr/local/ssl

# Install FastRTPS
RUN git clone --depth 1 https://github.com/eProsima/Fast-RTPS.git
WORKDIR Fast-RTPS/build
RUN cmake -DTHIRDPARTY=ON -DSECURITY=ON ..
RUN make && make install

WORKDIR /
