FROM node:20-alpine AS client_build
WORKDIR /app/client

COPY client/package*.json ./
RUN npm install
COPY client/ ./
RUN npm run build


FROM node:20-alpine AS runtime

ENV NODE_ENV=production
ENV PORT=8080
ENV NODE_PATH=/app/node_modules

WORKDIR /app

RUN addgroup -S app && adduser -S -G app app \
 && mkdir -p /app/client/build /app/client/public /app/client/src /app/ssr \
 && chown -R app:app /app

COPY --from=client_build --chown=app:app /app/client/build /app/client/build

USER app
RUN cd /app && npm install \
    react@19.2.0 react-dom@19.2.0 react-router-dom@7.9.4 \
    react-bootstrap@2.10.10 react-router-bootstrap@0.26.3 bootstrap@5.3.8 \
    antd@5.27.6 \
    @fortawesome/fontawesome-svg-core@7.1.0 @fortawesome/free-solid-svg-icons@7.1.0 @fortawesome/react-fontawesome@3.1.0

USER root
COPY --chown=app:app ssr/package.json /app/ssr/package.json

USER app
RUN cd /app/ssr && npm install

USER root
RUN rm -rf /app/ssr/node_modules/react /app/ssr/node_modules/react-dom /app/ssr/node_modules/react-router-dom || true

COPY --chown=app:app ssr/ /app/ssr/
COPY --chown=app:app client/src /app/client/src
COPY --chown=app:app client/public /app/client/public

USER app

EXPOSE 8080
CMD ["node", "ssr/index.js"]
