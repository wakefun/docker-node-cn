FROM node:16-bookworm-slim
LABEL org.opencontainers.image.authors="wakefun"
LABEL org.opencontainers.image.documentation="https://github.com/wakefun/docker-node-cn/blob/main/README.MD"

ENV NPM_CONFIG_PREFIX=/home/node/.npm-global
ENV PATH=$PATH:/home/node/.npm-global/bin 

USER root
COPY --chown=root:root apt/bookworm.http /etc/apt/sources.list
RUN apt-get update && apt-get install -y apt-transport-https ca-certificates
COPY --chown=root:root apt/bookworm /etc/apt/sources.list

USER node
RUN mkdir -p /home/node/node-cn
WORKDIR /home/node/node-cn
COPY --chown=node:node .npmrc /home/node/.npmrc
RUN mkdir -p /home/node/.npm-global/etc \
    && cat /home/node/.npmrc >> /home/node/.npm-global/etc/npmrc \
    && npm i -g pnpm \
    && npm version >> .node-cn-info

ONBUILD RUN cat /home/node/node-cn/.node-cn-info    