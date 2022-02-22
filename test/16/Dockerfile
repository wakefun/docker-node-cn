FROM node-cn:16 as frontend
WORKDIR /home/node/node-cn
COPY . .
RUN npm ci \
    && npm run build

FROM nginx:latest
COPY --from=frontend /home/node/node-cn/dist /usr/share/nginx/html/