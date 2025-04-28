# /Users/erauner/git/side/mcp-client-chatbot/Dockerfile
# ── Stage 1: build assets ──────────────────────────────────────────
FROM node:20-alpine AS builder
WORKDIR /app

# Install pnpm via corepack
RUN corepack enable && corepack prepare pnpm@latest --activate

# Declare build arguments for environment variables needed during build
ARG USE_FILE_SYSTEM_DB
ARG FILEBASE_URL
ARG POSTGRES_URL
# Set environment variables from build arguments for the build stage
ENV USE_FILE_SYSTEM_DB=$USE_FILE_SYSTEM_DB
ENV FILEBASE_URL=$FILEBASE_URL
ENV POSTGRES_URL=$POSTGRES_URL
# Also set NODE_ENV for build optimizations
ENV NODE_ENV=production

# Copy package manifests and lockfile first for better caching
COPY package.json pnpm-lock.yaml ./
# Copy workspace config if present (adjust if needed)
# COPY pnpm-workspace.yaml ./

# Install dependencies
# Use --frozen-lockfile for reproducible installs
RUN pnpm install --frozen-lockfile

# Copy the rest of the source code *before* running scripts that depend on it
COPY . .

# Generate the default .mcp-config.json if it doesn't exist
# This ensures the file is present for the final stage copy
# Run this *after* copying the source code
RUN pnpm initial:mcp-config

# Build the custom MCP server (compile TS to JS)
RUN pnpm build:server

# Build the Next.js app (emits .next/standalone)
# Ensure build command matches your project setup if different
RUN pnpm run build

# ── Stage 2: lightweight runtime ───────────────────────────────────
FROM node:20-alpine
WORKDIR /app

ENV NODE_ENV=production
# Default port, can be overridden by PORT env var
ENV PORT=3000

# Copy the entire node_modules directory from the builder stage
# This includes all dependencies, devDependencies (if needed by standalone output),
# and native addons installed correctly by pnpm.
COPY --from=builder /app/node_modules /app/node_modules
# Depending on pnpm version and structure, you might need to copy the store.
# Test if the above COPY is sufficient first. If not, uncomment the line below.
# COPY --from=builder /app/.pnpm /app/.pnpm

# Copy necessary artifacts from the builder stage's standalone output
COPY --from=builder /app/.next/standalone ./
# Copy static assets and public files
COPY --from=builder /app/.next/static ./.next/static
COPY --from=builder /app/public ./public
# Copy the default mcp config if it exists in the build stage
COPY --from=builder /app/.mcp-config.json ./.mcp-config.json
# Copy the compiled custom MCP server
COPY --from=builder /app/custom-mcp-server/dist ./custom-mcp-server/dist
# Copy Drizzle configuration file and database schema/migration files
COPY --from=builder /app/drizzle.config.ts ./drizzle.config.ts
COPY --from=builder /app/src/lib/db ./src/lib/db

# Remove the specific copy for the native addon - it's included in the full node_modules copy
# COPY --from=builder /app/node_modules/.pnpm/libsql*/node_modules/@libsql/linux-x64-musl/ \
#      ./node_modules/.pnpm/libsql*/node_modules/@libsql/linux-x64-musl/

# Expose the port the app runs on
EXPOSE 3000

# Command to run the standalone server output by Next.js build
# This assumes the output includes a server.js entrypoint
CMD ["node", "server.js"]
