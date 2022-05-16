FROM python:3.10-slim-buster

RUN apt-get update \
    && apt-get install -y --no-install-suggests --no-install-recommends \
       curl tzdata build-essential \
    && rm -rf /var/lib/apt/lists/*

ENV SUPERCRONIC_URL=https://github.com/aptible/supercronic/releases/download/v0.1.9/supercronic-linux-amd64 \
SUPERCRONIC=supercronic-linux-amd64 \
SUPERCRONIC_SHA1SUM=5ddf8ea26b56d4a7ff6faecdd8966610d5cb9d85

RUN curl -fsSLO "$SUPERCRONIC_URL" \
    && echo "${SUPERCRONIC_SHA1SUM}  ${SUPERCRONIC}" | sha1sum -c - \
    && chmod +x "$SUPERCRONIC" \
    && mv "$SUPERCRONIC" "/usr/local/bin/${SUPERCRONIC}" \
    && ln -s "/usr/local/bin/${SUPERCRONIC}" /usr/local/bin/supercronic


ENV CLI_URL=https://omnibus-aptible-toolbelt.s3.amazonaws.com/aptible/omnibus-aptible-toolbelt/master/340/pkg/aptible-toolbelt_0.19.3%2B20220317192554~debian.9.13-1_amd64.deb
RUN curl -fsSLO "$CLI_URL" \
    && dpkg -i aptible-toolbelt_0.19.3%2B20220317192554~debian.9.13-1_amd64.deb \
    && rm aptible-toolbelt_0.19.3%2B20220317192554~debian.9.13-1_amd64.deb

WORKDIR /opt/app

COPY scale /opt/app/scale
RUN chmod +x /opt/app/scale

COPY crontab /opt/app

ENV APTIBLE_OUTPUT_FORMAT=json

CMD ["supercronic", "/opt/app/crontab"]
