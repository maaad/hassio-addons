ARG BUILD_FROM=ghcr.io/hassio-addons/debian-base/amd64:stable
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
ENV LANG C.UTF-8

# Setup base system
ARG BUILD_ARCH=amd64
RUN \
    VICTORIAMETRICS_VERSION="v1.78.1" \
    \
    && ARCH="${BUILD_ARCH}" \
    && if [ "${BUILD_ARCH}" = "aarch64" ]; then ARCH="arm64"; fi \
    && if [ "${BUILD_ARCH}" = "armv7" ]; then ARCH="armhf"; fi \
    \
    && echo "nameserver 1.1.1.1" > /etc/resolv.conf \
    && curl -fL https://github.com/VictoriaMetrics/VictoriaMetrics/releases/download/${VICTORIAMETRICS_VERSION}/victoria-metrics-${ARCH}-${VICTORIAMETRICS_VERSION}.tar.gz -o victoria-metrics.tar.gz \ 
    && tar -xzf victoria-metrics.tar.gz -C /usr/local/bin

# Copy root filesystem
COPY rootfs /

# Build arguments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="maaad" \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="Home Assistant Add-ons" \
    org.opencontainers.image.authors="maaad" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://addons.community" \
    org.opencontainers.image.source="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.documentation="https://github.com/${BUILD_REPOSITORY}/blob/main/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}
