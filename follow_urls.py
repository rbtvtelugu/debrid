from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options
from webdriver_manager.chrome import ChromeDriverManager

def setup_browser():
    chrome_options = Options()
    chrome_options.add_argument("--headless")  # Run in headless mode
    chrome_options.add_argument("--no-sandbox")
    chrome_options.add_argument("--disable-dev-shm-usage")
    return webdriver.Chrome(service=Service(ChromeDriverManager().install()), options=chrome_options)

def follow_links(start_url):
    browser = setup_browser()
    browser.get(start_url)
    
    # Retrieve and follow all links on the page
    links = browser.find_elements(By.TAG_NAME, "a")
    visited_links = set()

    for link in links:
        href = link.get_attribute("href")
        if href and href not in visited_links:
            print(f"Following URL: {href}")
            visited_links.add(href)
            browser.get(href)

    browser.quit()

if __name__ == "__main__":
    start_url = "https://proxy-debrid.mcocib.easypanel.host/movie/tt14564000"  # Replace with your start URL
    follow_links(start_url)
