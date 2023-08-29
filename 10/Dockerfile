FROM node:10-buster-slim
LABEL org.opencontainers.image.authors="wakefun"
LABEL org.opencontainers.image.documentation="https://github.com/wakefun/docker-node-cn/blob/main/README.MD"

USER root
COPY --chown=root:root apt/buster.http /etc/apt/sources.list
RUN apt-get update \
    && apt-get install -y apt-transport-https ca-certificates gnupg \
    # 添加软件密钥，因为该版本的node官方已经drop了，后续没有基于新的debian底包更新，所以会有key缺失的情况导致apt-get update失败
    && apt-key adv --recv-keys 0E98404D386FA1D9 6ED0E7B82643E131
COPY --chown=root:root apt/buster /etc/apt/sources.list

USER node
RUN mkdir -p /home/node/node-cn
WORKDIR /home/node/node-cn
ENV NPM_CONFIG_PREFIX=/home/node/.npm-global
ENV PATH=$PATH:/home/node/.npm-global/bin 
RUN npm config set registry https://registry.npmmirror.com \
    && yarn config set registry=https://registry.npmmirror.com \
    && npm version >> .node-cn-info \
    && yarn versions >> .node-cn-info 

ONBUILD RUN cat /home/node/node-cn/.node-cn-info    