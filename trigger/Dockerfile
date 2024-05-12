FROM node:20.10.0-slim
WORKDIR /usr/src/app
COPY package*.json ./
RUN yarn install --production --frozen-lockfile

# Copy local code to the container image.
COPY . .

# Run the web service on container startup.
ENTRYPOINT ["yarn", "start"]