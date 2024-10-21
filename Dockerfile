# Use the official Python image from the Docker Hub
FROM python:3.9-slim

# Install required packages
RUN apt-get update && \
    apt-get install -y curl unzip wget && \
    apt-get clean

# Install Chrome browser
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    apt-get install -y ./google-chrome-stable_current_amd64.deb && \
    rm ./google-chrome-stable_current_amd64.deb

# Install ChromeDriver
RUN CHROME_DRIVER_VERSION=$(curl -sS https://chromedriver.storage.googleapis.com/LATEST_RELEASE) && \
    wget -O /tmp/chromedriver.zip https://chromedriver.storage.googleapis.com/$CHROME_DRIVER_VERSION/chromedriver_linux64.zip && \
    unzip /tmp/chromedriver.zip -d /usr/local/bin/ && \
    rm /tmp/chromedriver.zip

# Install Selenium
RUN pip install selenium

# Copy the Selenium script into the container
COPY follow_urls.py /usr/src/app/follow_urls.py

# Set the default command to execute the Selenium script
CMD ["python", "/usr/src/app/follow_urls.py"]
