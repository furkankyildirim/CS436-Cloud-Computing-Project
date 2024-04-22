# Use the official Node.js runtime as the base image
FROM node:21.6.2-alpine as build

# Set the working directory in the container
WORKDIR /client

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install dependencies
RUN yarn install

# Copy the entire application code to the container
COPY . .

# Build the React app for production
RUN yarn build
RUN yarn global add serve

EXPOSE 3000

# Start Nginx when the container runs
CMD ["serve", "-s", "build"]