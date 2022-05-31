FROM node:8-slim
LABEL org.opencontainers.image.authors="wakefun"
LABEL org.opencontainers.image.documentation="https://github.com/wakefun/docker-node-cn/blob/main/README.MD"

USER root
COPY --chown=root:root apt/stretch /etc/apt/sources.list

USER node
RUN mkdir -p /home/node/node-cn
WORKDIR /home/node/node-cn
ENV NPM_CONFIG_PREFIX=/home/node/.npm-global
ENV PATH=$PATH:/home/node/.npm-global/bin 
RUN npm i -g mirror-config-china --registry=https://registry.npmmirror.com \
    && cd $HOME \
    && mirror-config-china --registry=https://registry.npmmirror.com --bin-mirrors-prefix=https://npmmirror.com/mirrors \
    && cd /home/node/node-cn \
    && yarn config set registry=https://registry.npmmirror.com/ \
    && npm version >> .node-cn-info \
    && yarn versions >> .node-cn-info 

ONBUILD RUN cat /home/node/node-cn/.node-cn-info    