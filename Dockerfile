# build phase

# get node container to build app
FROM node:lts as build

# set work directory
WORKDIR /app

# add node_modules to path
ENV PATH /app/node_modules/.bin:$PATH

# copy project dependencies to directory
COPY package.json /app/package.json

# install angular cli since it is a dependency of all packages in app
RUN npm install -g @angular/cli

# install dependencies
RUN npm install

# copy app files
COPY ./ /app

# show folder structure
RUN ls

# build project
RUN npm run build-storybook

# deploy phase
FROM nginx:alpine

COPY nginx/ /etc/nginx/conf.d/

RUN rm -rf /usr/share/nginx/html/*

COPY --from=build /app/storybook-static /usr/share/nginx/html

EXPOSE 8080

CMD [ "nginx", "-g", "daemon off;"]