    # 1. For build React app
    FROM node:lts as stage1
    WORKDIR /app
    COPY package.json /app/package.json

    RUN npm install

    COPY . /app

    ENV PORT=3000

    RUN npm run build

    #2: Config for NginX:
    FROM nginx:alpine
    COPY --from=stage1 /app/.nginx/nginx.conf /etc/nginx/conf.d/default.conf
    WORKDIR /usr/share/nginx/html
    # Remove default nginx static assets
    RUN rm -rf ./*
    # Copy static assets from builder stage
    COPY --from=stage1 /app/build .
    # Containers run nginx with global directives and daemon off
    ENTRYPOINT ["nginx", "-g", "daemon off;"]
