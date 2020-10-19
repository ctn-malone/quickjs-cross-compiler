FROM alpine:3.12.0
ARG arch=x86_64
WORKDIR /usr/local/src/quickjs-cross-compiler/builder
COPY builder /tmp/builder
RUN /tmp/builder/scripts/bootstrap-alpine.sh && \
    /tmp/builder/scripts/fetch_deps.sh -va $arch -d /usr/local/src/quickjs-cross-compiler/deps && \
    /tmp/builder/scripts/build_deps.sh -va $arch -d /usr/local/src/quickjs-cross-compiler/deps
