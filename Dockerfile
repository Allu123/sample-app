### STAGE 1: Build ###

# We label our stage as 'node'
FROM node:latest as node

WORKDIR /app

COPY . .

RUN npm install

## Build the angular app in production mode and store the artifacts in dist folder
RUN npm run build --prod


### STAGE 2: Setup ###

FROM nginx:alpine

## From 'node' stage copy over the artifacts in dist folder to default nginx public folder
COPY --from=node app/dist/sample-app /usr/share/nginx/html

# set maintainer
LABEL maintainer "miiro@getintodevops.com"

# set a health check
HEALTHCHECK --interval=5s \
            --timeout=5s \
            CMD curl -f http://127.0.0.1:8000 || exit 1

# tell docker what port to expose
EXPOSE 8000
