# Use Ubuntu as the base image
FROM ubuntu:20.04

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages and dependencies for Chrome and ChromeDriver
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    wget \
    curl \
    unzip \
    gnupg2 \
    chromium-browser \
    chromium-chromedriver \
    libxss1 \
    libappindicator3-1 \
    libatk-bridge2.0-0 \
    libgtk-3-0 \
    libx11-xcb1 \
    libxcomposite1 \
    libxcursor1 \
    libxi6 \
    libxtst6 \
    libnss3 \
    libxrandr2 \
    libasound2 \
    libxss1 \
    libxdamage1 \
    fonts-liberation \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create a symlink for ChromeDriver
RUN ln -s /usr/bin/chromedriver /usr/local/bin/chromedriver

# Set the working directory
WORKDIR /app

# Copy the requirements file first for better caching
COPY requirements.txt requirements.txt

# Install Python packages
RUN pip3 install --no-cache-dir -r requirements.txt

# Copy the rest of your application code into the container
COPY . .

# Specify the command to run your script
CMD ["python3", "follow_urls.py"]
