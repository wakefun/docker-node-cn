FROM node:12-slim
USER node
RUN mkdir -p /home/node/node-cn
WORKDIR /home/node/node-cn
ENV NPM_CONFIG_PREFIX=/home/node/.npm-global
ENV PATH=$PATH:/home/node/.npm-global/bin 
RUN npm config set registry=https://registry.npmmirror.com/ \
    && yarn config set registry=https://registry.npmmirror.com/ \
    && npm i -g pnpm \
    && npm i -g mirror-config-china \
    && npm version >> .node-cn-info \
    && yarn versions >> .node-cn-info \