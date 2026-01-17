# Use official Node 22 image
FROM node:22-bullseye

# Install dependencies for Puppeteer/Chrome
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    ca-certificates \
    fonts-liberation \
    libnss3 \
    libxss1 \
    libatk-bridge2.0-0 \
    libgtk-3-0 \
    libx11-xcb1 \
    libxcomposite1 \
    libasound2 \
    libxrandr2 \
    libgbm1 \
    --no-install-recommends \
 && rm -rf /var/lib/apt/lists/*

# Install Google Chrome
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
 && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' \
 && apt-get update && apt-get install -y google-chrome-stable --no-install-recommends \
 && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install Node dependencies
RUN npm install

# Copy app code
COPY . .

# Expose port
EXPOSE 10000

# Start command
CMD ["node", "server.js"]
