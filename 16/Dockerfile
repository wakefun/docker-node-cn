FROM node:16-slim

RUN npm config set registry=https://registry.npmmirror.com/ \
    && yarn config set registry=https://registry.npmmirror.com/ \
    && npm i -g pnpm \
    && npm i -g mirror-config-china 
