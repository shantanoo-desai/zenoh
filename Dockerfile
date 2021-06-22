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

FROM alpine:3.12

ARG TARGETPLATFORM
RUN case "$TARGETPLATFORM" in \
    "linux/arm64") echo aarch64-unknown-linux-gnu > /rust_target.txt ;; \
    *) exit 1 ;; \
    esac

RUN apk add --no-cache libgcc libstdc++

RUN ls -la

COPY ./target/$(cat /rust_target.txt)/release/zenohd /
COPY ./target/$(cat /rust_target.txt)/release/*.so /

RUN echo '#!/bin/ash' > /entrypoint.sh
RUN echo 'echo " * Starting: /zenohd $*"' >> /entrypoint.sh
RUN echo 'exec /zenohd $*' >> /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 7447/udp
EXPOSE 7447/tcp
EXPOSE 8000/tcp

ENV RUST_LOG info

ENTRYPOINT ["/entrypoint.sh"]
