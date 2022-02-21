FROM node-cn:latest as frontend
WORKDIR /node-cn
COPY . .
RUN npm ci \
    && npm run build

FROM nginx:latest
COPY --from=frontend /node-cn/dist/ /usr/share/nginx/html/