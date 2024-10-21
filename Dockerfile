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

# Install a specific version of ChromeDriver that matches the Chromium version
# Check the installed version of Chromium and set the corresponding ChromeDriver version
RUN CHROMIUM_VERSION=130.0.6723.58 && \
    CHROMEDRIVER_VERSION=130.0.6723.24 && \
    wget -N "https://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip" && \
    unzip chromedriver_linux64.zip -d /usr/local/bin/ && \
    chmod +x /usr/local/bin/chromedriver && \
    rm chromedriver_linux64.zip

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
