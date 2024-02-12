# First stage - Build the Node.js application
FROM node:9 AS build

WORKDIR /src

COPY ./package.json /src/package.json
COPY ./package-lock.json /src/package-lock.json
RUN npm install --silent

COPY ./app /src/app
COPY ./bin /src/bin
COPY ./public /src/public
COPY ./nodemon.json /src/nodemon.json

ENV NODE_ENV=production

RUN npm run build

# Second stage - Serve the application with a smaller image using Alpine
FROM node:alpine

WORKDIR /var/www/html

COPY --from=build /src/app/* ./

# Install Apache
RUN apk add --no-cache apache2

# Expose port 80
EXPOSE 80

CMD ["httpd", "-D", "FOREGROUND"]
