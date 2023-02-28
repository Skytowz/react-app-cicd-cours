# # build environment
# FROM node:13.12.0-alpine as build
# ENV JQ_VERSION=1.6
# RUN wget --no-check-certificate https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64 -O /tmp/jq-linux64
# RUN cp /tmp/jq-linux64 /usr/bin/jq
# RUN chmod +x /usr/bin/jq
# WORKDIR /app
# ENV PATH /app/node_modules/.bin:$PATH
# COPY package.json ./
# COPY package-lock.json ./
# RUN npm ci --silent
# RUN npm install react-scripts@3.4.1 -g --silent
# COPY . ./
# RUN jq 'to_entries | map_values({ (.key) : ("$" + .key) }) | reduce .[] as $item ({}; . + $item)' ./src/config.json > ./src/config.tmp.json && mv ./src/config.tmp.json ./src/config.json
# RUN npm run build
# 
# # production environment
# FROM nginx:stable-alpine
# ENV JSFOLDER=/usr/share/nginx/html/static/js/*.js
# COPY ./start-nginx.sh /usr/bin/start-nginx.sh
# RUN chmod +x /usr/bin/start-nginx.sh
# COPY --from=build /app/build /usr/share/nginx/html
# 
# ENTRYPOINT [ "start-nginx.sh" ]
# 
# EXPOSE 80
# 
# CMD ["nginx", "-g", "daemon off;"]

FROM node:14
ENV JQ_VERSION=1.6
RUN wget --no-check-certificate https://github.com/stedolan/jq/releases/download/jq-${JQ_VERSION}/jq-linux64 -O /tmp/jq-linux64
RUN cp /tmp/jq-linux64 /usr/bin/jq
RUN chmod +x /usr/bin/jq
WORKDIR /app
COPY . .
RUN jq 'to_entries | map_values({ (.key) : ("$" + .key) }) | reduce .[] as $item ({}; . + $item)' ./src/config.json > ./src/config.tmp.json && mv ./src/config.tmp.json ./src/config.json
RUN npm install && npm run build

FROM nginx:1.17
# Angular
# ENV JSFOLDER=/usr/share/nginx/html/*.js
# React
ENV JSFOLDER=/usr/share/nginx/html/static/js/*.js
# VueJS
# ENV JSFOLDER=/usr/share/nginx/html/js/*.js
COPY ./start-nginx.sh /usr/bin/start-nginx.sh
RUN chmod +x /usr/bin/start-nginx.sh
WORKDIR /usr/share/nginx/html
# Angular
# COPY --from=0 /app/dist/<projectName> .
# React
COPY --from=0 /app/build .
# VueJS
# COPY --from=0 /app/dist .
ENTRYPOINT [ "start-nginx.sh" ]