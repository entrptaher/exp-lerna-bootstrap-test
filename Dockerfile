FROM node:13.8-slim

# Install dependencies
RUN apt-get update &&\
  apt-get install -yq build-essential gconf-service libasound2 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 \
  libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 \
  libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 \
  libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 \
  ca-certificates fonts-liberation libappindicator1 libnss3 lsb-release xdg-utils wget \
  xvfb x11vnc x11-xkb-utils xfonts-100dpi xfonts-75dpi xfonts-scalable xfonts-cyrillic x11-apps dumb-init\
  # cleanup lists to reduce build size
  && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/usr/bin/dumb-init"]

# Add all packages because of internal dependencies
WORKDIR /app
COPY package.json package.json
COPY lerna.json lerna.json

# Copy package json files
COPY packages/sample-a/package.json packages/sample-a/package.json
COPY packages/sample-b/package.json packages/sample-b/package.json
COPY packages/sample-c/package.json packages/sample-c/package.json

# Install dependencies
RUN yarn install \
    && yarn run bootstrap \
    && yarn cache clean

COPY . .

# build the specific package
RUN yarn build

# Run the specific package only
WORKDIR /app/packages/sample-c
CMD ["node", "dist/index.js"]