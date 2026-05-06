FROM squidfunk/mkdocs-material:9.5.17
LABEL maintainer="Michael Hausenblas, hausenbl@amazon.com"

# Bake heavy build/runtime dependencies into the image so consumers do not
# pay the apk add + libsass-from-source compile cost on every action run.
# These were previously passed via EXTRA_PACKAGES / POST_INSTALL / requirements.txt
# in consumer workflows; action.sh keeps that path working for callers that
# need additional packages, but the common case is now a no-op at runtime.
RUN apk add --no-cache \
        bash \
        build-base \
        cairo \
        cairo-gobject \
        fontconfig \
        gdk-pixbuf \
        jpeg-dev \
        libffi-dev \
        linux-headers \
        msttcorefonts-installer \
        pango \
        zlib-dev \
 && update-ms-fonts \
 && fc-cache -f \
 && pip install --no-cache-dir mkdocs-with-pdf

COPY action.sh /action.sh
RUN chmod +x /action.sh

ENTRYPOINT ["/action.sh"]
