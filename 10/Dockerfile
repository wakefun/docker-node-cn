FROM node:10-slim
LABEL org.opencontainers.image.authors="wakefun"
LABEL org.opencontainers.image.documentation="https://github.com/wakefun/docker-node-cn/blob/main/README.MD"
USER node
RUN mkdir -p /home/node/node-cn
WORKDIR /home/node/node-cn
ENV NPM_CONFIG_PREFIX=/home/node/.npm-global
ENV PATH=$PATH:/home/node/.npm-global/bin 
RUN npm config set registry=https://registry.npmmirror.com/ \
    && yarn config set registry=https://registry.npmmirror.com/ \
    && npm i -g mirror-config-china \
    && npm version >> .node-cn-info \
    && yarn versions >> .node-cn-info 

ONBUILD RUN cat /home/node/node-cn/.node-cn-info