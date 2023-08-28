FROM node:8-buster-slim
LABEL org.opencontainers.image.authors="wakefun"
LABEL org.opencontainers.image.documentation="https://github.com/wakefun/docker-node-cn/blob/main/README.MD"

USER root
COPY --chown=root:root apt/buster.http /etc/apt/sources.list
RUN apt-get update && apt-get install -y apt-transport-https ca-certificates
COPY --chown=root:root apt/buster /etc/apt/sources.list

USER node
RUN mkdir -p /home/node/node-cn
WORKDIR /home/node/node-cn
ENV NPM_CONFIG_PREFIX=/home/node/.npm-global
ENV PATH=$PATH:/home/node/.npm-global/bin 
RUN npm config set registry https://registry.npmmirror.com \
    && cd /home/node/node-cn \
    && yarn config set registry=https://registry.npmmirror.com \
    && npm version >> .node-cn-info \
    && yarn versions >> .node-cn-info 

ONBUILD RUN cat /home/node/node-cn/.node-cn-info    