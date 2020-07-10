# build phase
FROM node:lts as build

WORKDIR /app

ENV PATH /app/node_modules/.bin:$PATH

COPY package.json /app/package.json

RUN npm install

RUN npm install -g @angular/cli

COPY ./ /app

RUN ls

RUN npm run build-storybook

# deploy phase
FROM nginx:alpine

COPY nginx/ /etc/nginx/conf.d/

RUN rm -rf /usr/share/nginx/html/*

COPY --from=build /app/storybook-static /usr/share/nginx/html

EXPOSE 8080

CMD [ "nginx", "-g", "daemon off;"]