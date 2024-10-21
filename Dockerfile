# Use a slim version of Python as the base image
FROM python:3.9-slim

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    gnupg2 \
    unzip \
    chromium \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install ChromeDriver
RUN apt-get install -y chromium-chromedriver && \
    ln -s /usr/bin/chromedriver /usr/local/bin/chromedriver

# Set the working directory
WORKDIR /app

# Copy the requirements file first for better caching
COPY requirements.txt requirements.txt

# Install Python packages
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of your application code into the container
COPY . .

# Specify the command to run your script
CMD ["python", "follow_urls.py"]
