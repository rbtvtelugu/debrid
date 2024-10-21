# Use Ubuntu as the base image
FROM ubuntu:20.04

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    wget \
    curl \
    unzip \
    gnupg2 \
    chromium-browser \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install ChromeDriver matching the installed Chromium version
RUN wget -q "https://chromedriver.storage.googleapis.com/$(curl -s chromedriver.storage.googleapis.com/LATEST_RELEASE)/chromedriver_linux64.zip" -O /tmp/chromedriver.zip && \
    unzip /tmp/chromedriver.zip -d /usr/local/bin/ && \
    chmod +x /usr/local/bin/chromedriver && \
    rm /tmp/chromedriver.zip

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
