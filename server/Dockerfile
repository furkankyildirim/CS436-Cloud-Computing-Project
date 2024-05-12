
# Use a specific version of Node.js based on an Alpine Linux image
ARG NODE_VERSION=21.6.2
FROM node:${NODE_VERSION}-alpine

# Set the node environment to production
ENV NODE_ENV production

# Cloud Run defaults to listening on port 8080, but you can specify a different port
# Set the PORT environment variable to match the port your application listens on
ENV PORT 8080

# Expose the port your application listens on
EXPOSE 8080

# Set the working directory inside the container

WORKDIR /usr/src/app
COPY package*.json ./
RUN yarn install --production --frozen-lockfile


# Copy package.json and yarn.lock into the working directory
COPY package.json yarn.lock ./

# Install production dependencies
RUN yarn install --production --frozen-lockfile

# Copy the rest of your application source code into the working directory
COPY . .

# Specify the user to run the application (non-root for security)
USER node

# Command to run your application
CMD ["yarn", "start"]

