#FROM python:alpine
FROM hashicorp/terraform:light
# Install awscli and aws-sam-cli
# RUN apk update && \
#     apk upgrade && \
#     # apk add bash && \
#     # apk add --no-cache --virtual build-deps build-base gcc && \
#     # pip install awscli && \
#     # pip install aws-sam-cli && \
#     # apk del build-deps
#     apk add zip 1
RUN mkdir /app
WORKDIR /app
#ENTRYPOINT ["/bin/sh"]
