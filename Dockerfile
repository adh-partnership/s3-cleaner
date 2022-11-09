FROM python:3.9-alpine

LABEL "com.github.actions.name"="S3 Cleaner"
LABEL "com.github.actions.description"="Clean up S3 bucket based on age"
LABEL "com.github.actions.icon"="refresh-cw"
LABEL "com.github.actions.color"="green"

LABEL version="0.1.0"
LABEL repository="https://github.com/adh-partnership/s3-cleaner"
LABEL homepage="https://github.com/adh-partnership/s3-cleaner"
LABEL maintainer="Daniel Hawton <daniel@hawton.org>"

# https://github.com/aws/aws-cli/blob/master/CHANGELOG.rst
ENV AWSCLI_VERSION='1.27.4'

RUN pip install --quiet --no-cache-dir awscli==${AWSCLI_VERSION}

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
