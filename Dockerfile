# Copyright (c) 2017, 2020 ADLINK Technology Inc.
#
# This program and the accompanying materials are made available under the
# terms of the Eclipse Public License 2.0 which is available at
# http://www.eclipse.org/legal/epl-2.0, or the Apache License, Version 2.0
# which is available at https://www.apache.org/licenses/LICENSE-2.0.
#
# SPDX-License-Identifier: EPL-2.0 OR Apache-2.0
#
# Contributors:
#   ADLINK zenoh team, <zenoh@adlink-labs.tech>
#   Shantanoo 'Shan' Desai <shantanoo.desai@gmail.com>

FROM alpine:latest as base

RUN apk add --no-cache libgcc libstdc++

FROM --platform=${BUILDPLATFORM} alpine as zenoh-binary
# Use BuildKit to help translate architecture names
ARG TARGETPLATFORM

COPY target/ /tmp/target/

RUN case "${TARGETPLATFORM}" in \
         "linux/arm64")  TARGET_DIR=aarch64-unknown-linux-gnu  ;; \
         *) exit 1 ;; \
    esac \
    && mv /tmp/target/$TARGET_DIR/release/zenohd /home \
    && mv /tmp/target/$TARGET_DIR/release/*.so /home

FROM base as release

COPY --from=zenoh-binary /home/* /usr/local/bin/

EXPOSE 7447/udp
EXPOSE 7447/tcp
EXPOSE 8000/tcp

ENV RUST_LOG info
ENV RUST_BACKTRACE full

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

CMD ["/usr/local/bin/zenohd"]
