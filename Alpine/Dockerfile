FROM alpine as builder

# Install build dependences
RUN apk add --no-cache --update git cmake make build-base gcc g++ linux-headers openssl openssl-dev openjdk8 gradle

# Build FastRTPS
RUN git clone --depth 1 --recursive https://github.com/eProsima/Fast-RTPS.git /Fast-RTPS
WORKDIR /Fast-RTPS/build
RUN cmake -DTHIRDPARTY=ON -DSECURITY=ON -DBUILD_JAVA=ON -DCOMPILE_EXAMPLES=ON .. && make && make install

# Build Micro XRCE-DDS Gen
RUN git clone --depth 1 --recursive https://github.com/eProsima/micro-XRCE-DDS-gen.git /micro-XRCE-DDS-gen
WORKDIR /micro-XRCE-DDS-gen
RUN gradle build

FROM alpine:3.8

RUN apk add --no-cache --update openssl openjdk8

# Copy/Install FastRTPS
COPY --from=builder /usr/local/examples /usr/local/examples/fastrtps
COPY --from=builder /usr/local/share/fastrtps /usr/local/share/fastrtps
COPY --from=builder /usr/local/share/fastcdr /usr/local/share/fastcdr
COPY --from=builder /usr/local/bin/fastrtpsgen /usr/local/bin/fastrtpsgen
COPY --from=builder /usr/local/include/fastrtps /usr/local/include/fastrtps
COPY --from=builder /usr/local/include/fastcdr /usr/local/include/fastcdr
COPY --from=builder /usr/local/lib/libfast* /usr/local/lib/

# Copy/Install Micro XRCE-DDS Gen
COPY --from=builder /micro-XRCE-DDS-gen/share/microxrcedds/microxrceddsgen.jar /usr/local/lib/
COPY microxrceddsgen /usr/local/bin
