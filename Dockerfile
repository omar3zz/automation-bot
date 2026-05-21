# =========================
# VULTIX Node-RED Runtime
# Optimized Production Dockerfile
# =========================

FROM nodered/node-red:latest

# Set working directory
WORKDIR /usr/src/node-red

# Copy package configuration
COPY package*.json ./

# Install dependencies
RUN npm install --omit=dev && npm cache clean --force

# Copy project files
COPY . .

# Create workspace directories
RUN mkdir -p /data/workspace \
    && mkdir -p /data/logs \
    && chmod -R 777 /data

# Environment variables
ENV NODE_ENV=production
ENV NODE_RED_ENABLE_PROJECTS=true
ENV FLOWS=flows.json

# Expose Node-RED port
EXPOSE 1880

# Healthcheck
HEALTHCHECK --interval=30s --timeout=10s --start-period=20s --retries=3 \
CMD curl -f http://localhost:1880 || exit 1

# Start Node-RED
CMD ["npm", "run", "start"]
