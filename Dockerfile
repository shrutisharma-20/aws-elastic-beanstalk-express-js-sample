FROM node:22-alpine

WORKDIR /app

RUN apk upgrade --no-cache

COPY package*.json ./

RUN npm ci --omit=dev

COPY . .

EXPOSE 8080

CMD ["npm", "start"]
