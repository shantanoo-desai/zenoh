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

FROM alpine as base

FROM --platform=${BUILDPLATFORM} alpine as tiny-project

# Use BuildKit to help translate architecture names
ARG TARGETPLATFORM

WORKDIR /app

RUN case ${TARGETPLATFORM} in \
         "linux/amd64")  TARGET_DIR=x86_64-unknown-linux-musl  ;; \
         "linux/arm64")  TARGET_DIR=aarch64-unknown-linux-gnu  ;; \
         *) exit 1 ;; \
    esac; \
    cp target/$TARGET_DIR/release/zenohd .; \
    cp target/$TARGET_DIR/release/*.so .


FROM base as release
COPY --from=tiny-project /app/* ./

RUN apk add --no-cache libgcc libstdc++

RUN echo '#!/bin/ash' > /entrypoint.sh
RUN echo 'echo " * Starting: /zenohd $*"' >> /entrypoint.sh
RUN echo 'exec /zenohd $*' >> /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 7447/udp
EXPOSE 7447/tcp
EXPOSE 8000/tcp

ENV RUST_LOG info

ENTRYPOINT ["/entrypoint.sh"]
