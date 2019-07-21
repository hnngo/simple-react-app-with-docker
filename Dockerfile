# Dockerfile for production mode

# Build phase
FROM ubuntu:bionic AS builder

# Install node and npm
RUN apt-get update
RUN apt-get install -y curl
RUN apt-get install -y nodejs
RUN apt-get install -y npm
RUN npm cache clean -f
RUN npm install -g n
RUN n stable

# Indicate work dir
WORKDIR /app

# Install node_modules
COPY package.json .
RUN npm install
COPY . .

# Build app
RUN npm run build

# Run pahse
FROM nginx

# Copy the build files from build phase to run phase
COPY --from=builder /app/build /usr/share/nginx/html

# CMD docker run -p 8080:80 4b46ee072ee5