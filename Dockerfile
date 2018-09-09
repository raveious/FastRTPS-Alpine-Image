FROM alpine as builder

# Install build dependences
RUN apk add --no-cache --update git cmake make build-base gcc g++ perl linux-headers openssl openssl-dev openjdk8 gradle

# Install FastRTPS
RUN git clone --depth 1 https://github.com/eProsima/Fast-RTPS.git
WORKDIR Fast-RTPS/build
RUN cmake -DTHIRDPARTY=ON -DSECURITY=ON -DBUILD_JAVA=ON ..
RUN make && make install

FROM alpine:3.8

RUN apk add --no-cache --update openssl openjdk8

COPY --from=builder /usr/local/examples /usr/local/examples/fastrtps
COPY --from=builder /usr/local/share/fastrtps /usr/local/share/fastrtps
COPY --from=builder /usr/local/bin/fastrtpsgen /usr/local/bin/fastrtpsgen
COPY --from=builder /usr/local/lib/fastrtps /usr/local/lib/fastrtps
COPY --from=builder /usr/local/include/fastcdr /usr/local/include/fastcdr
COPY --from=builder /usr/local/lib/libfastcdr* /usr/local/lib/
COPY --from=builder /usr/local/share/fastcdr /usr/local/share/fastcdr
COPY --from=builder /usr/local/include/fastrtps /usr/local/include/fastrtps
COPY --from=builder /usr/local/lib/libfastrtps* /usr/local/lib/
