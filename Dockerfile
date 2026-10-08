# mi-fft-order-system — imagen para Coolify (endurecida para el escáner de seguridad).
#
# - Multi-stage: npm sólo existe en la etapa de build.
# - Runtime: se parchan paquetes del SO (zlib, etc.) con `apk upgrade` y se BORRAN
#   npm / npx / corepack. La imagen base de Node trae npm con sus propias copias de
#   tar, brace-expansion, @sigstore/core, http-cache-semantics, ip-address… que no
#   están en package-lock.json y por eso no se arreglan desde las dependencias de
#   este repo. Nada usa npm en runtime (CMD = node server.js).
# - Corre como usuario `node`, no root.

# ---- Build stage: instala sólo dependencias de producción ----
FROM node:22-alpine AS deps
WORKDIR /app
COPY package*.json ./
RUN npm ci --omit=dev && npm cache clean --force

# ---- Runtime stage ----
FROM node:22-alpine AS runtime
WORKDIR /app
ENV NODE_ENV=production

RUN apk upgrade --no-cache \
    && npm_root="$(npm root -g)" \
    && rm -rf "$npm_root/npm" "$npm_root/corepack" \
       /usr/local/bin/npm /usr/local/bin/npx /usr/local/bin/corepack \
    && chown node:node /app

COPY --chown=node:node --from=deps /app/node_modules ./node_modules
COPY --chown=node:node . .

USER node

EXPOSE 3000
CMD ["node", "server.js"]
