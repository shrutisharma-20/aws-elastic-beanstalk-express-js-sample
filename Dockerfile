FROM node:22-alpine

WORKDIR /app

RUN npm ci --omit=dev

COPY package*.json ./

RUN npm ci

COPY . .

EXPOSE 8080

CMD ["npm", "start"]
