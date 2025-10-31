# ---------- Client build stage ----------
FROM node:20-alpine AS client_build
WORKDIR /app/client

# Install client deps and build CRA
COPY client/package*.json ./
RUN npm install
COPY client/ ./
RUN npm run build


# ---------- Runtime image ----------
FROM node:20-alpine AS runtime

ENV NODE_ENV=production
ENV PORT=8080
# Ensure SSR always resolves React/DOM from the top-level node_modules
ENV NODE_PATH=/app/node_modules

WORKDIR /app

# Create non-root user and prepare directories
RUN addgroup -S app && adduser -S -G app app \
 && mkdir -p /app/client/build /app/client/public /app/client/src /app/ssr \
 && chown -R app:app /app

# Copy built client assets for hydration (optional usage by your server)
COPY --from=client_build --chown=app:app /app/client/build /app/client/build

# Install shared UI/runtime libs at the top level so SSR resolves a single copy
USER app
RUN cd /app && npm install \
    react@19.2.0 react-dom@19.2.0 react-router-dom@7.9.4 \
    react-bootstrap@2.10.10 react-router-bootstrap@0.26.3 bootstrap@5.3.8 \
    antd@5.27.6 \
    @fortawesome/fontawesome-svg-core@7.1.0 @fortawesome/free-solid-svg-icons@7.1.0 @fortawesome/react-fontawesome@3.1.0

# ---------- SSR server dependencies ----------
# 1) Copy only the SSR manifest first for better layer caching
USER root
COPY --chown=app:app ssr/package.json /app/ssr/package.json
# If you add a lockfile later, copy it too:
# COPY --chown=app:app ssr/package-lock.json /app/ssr/package-lock.json

# 2) Install SSR deps (Express, Babel, etc.) as non-root
USER app
RUN cd /app/ssr && npm install

# After SSR npm install, remove accidental local React/DOM copies if any
# (Prevents a second React instance under /app/ssr that would break hooks during SSR)
USER root
RUN rm -rf /app/ssr/node_modules/react /app/ssr/node_modules/react-dom /app/ssr/node_modules/react-router-dom || true

# 3) Copy SSR source and client sources referenced by SSR (ServerEntry, App, HTML template)
COPY --chown=app:app ssr/ /app/ssr/
COPY --chown=app:app client/src /app/client/src
COPY --chown=app:app client/public /app/client/public

# Drop privileges for runtime
USER app

EXPOSE 8080
CMD ["node", "ssr/index.js"]
