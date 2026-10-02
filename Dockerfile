FROM node:22-alpine

WORKDIR /app

RUN apk upgrade --no-cache

COPY package*.json ./

RUN npm ci --omit=dev \
    && npm cache clean --force \
    && rm -rf /usr/local/lib/node_modules/npm \
    && rm -f /usr/local/bin/npm /usr/local/bin/npx

COPY . .

EXPOSE 8080

CMD ["node", "app.js"]
