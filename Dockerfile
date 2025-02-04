
FROM node:alpine as builder

# FRONT
WORKDIR /app/front

COPY front/package*.json /app/front

RUN npm i
COPY front/ .
RUN npm run build

# CMD ["npm", "run", "dev"]


# BACK
FROM node:alpine
WORKDIR /app/back
COPY back/package*.json .
COPY --from=builder app/front/dist public

RUN npm i
COPY back/index.js /app/back

RUN addgroup -S test && adduser -S util1
USER util1

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 CMD [ "executable" ]
CMD ["npm", "start"]