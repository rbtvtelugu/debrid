from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from webdriver_manager.chrome import ChromeDriverManager
import time

def setup_browser():
    chrome_options = Options()
    chrome_options.add_argument("--headless")  # Run in headless mode
    chrome_options.add_argument("--no-sandbox")
    chrome_options.add_argument("--disable-dev-shm-usage")
    chrome_options.add_argument("--disable-blink-features=AutomationControlled")
    return webdriver.Chrome(service=Service(ChromeDriverManager().install()), options=chrome_options)

def follow_dynamic_content(start_url, cookies=None, max_wait=30):
    browser = setup_browser()

    try:
        # Set cookies if provided
        if cookies:
            browser.get(start_url)  # First navigate to the start URL to set cookies
            for cookie in cookies:
                browser.add_cookie(cookie)

        # Now navigate to the start URL again after setting cookies
        browser.get(start_url)

        # Monitor for dynamic content
        visited_urls = set()
        visited_urls.add(browser.current_url)

        print(f"Starting URL: {browser.current_url}")

        start_time = time.time()

        while time.time() - start_time < max_wait:
            # Monitor the current URL
            current_url = browser.current_url
            if current_url not in visited_urls:
                print(f"Following URL: {current_url}")
                visited_urls.add(current_url)
                start_time = time.time()  # Reset wait time if a new URL is found

                # Load the new page to check for more dynamic content
                time.sleep(2)  # Give some time for the new content to load

            # Scroll down the page to trigger dynamic loading
            browser.execute_script("window.scrollTo(0, document.body.scrollHeight);")
            time.sleep(2)  # Allow some time for dynamic content to load

    except Exception as e:
        print(f"An error occurred: {e}")
    
    finally:
        browser.quit()  # Ensure the browser is closed even if an error occurs

if __name__ == "__main__":
    start_url = "https://debridmediamanager.com/movie/tt14564000"  # Replace with your dynamic start URL
    
    # Add the cf_clearance cookie
    cookies = [
        {
            'name': 'cf_clearance',
            'value': 'vIEs0_XDvd8oBDHW4zdHGySwONEGTxquhhkzuBnNkyI-1729515901-1.2.1.1-1FkUgQrmyVe3XXdDBqEI4kB_JgaVY9xyL659nvuQyhHmRPL1naTk4pMTNqOcJC3KPovkujQCxfJTH9fNcy8UrrCTgAw2SgqHnNEZ5SeoAndIj1gJvFJwWhJHEsT9wlp_VCmxWyntLbAfHHA.k9S1bWQi5pV.mCl4PGtfodpgTaug.ZWdbSrjt3wfwQwcCV.S77ctmyoNNB6OWrYA_yfZIXixcpHYplEE1GTAX2zUtOovz2CcY3GaIaZo0KVYxVFgfwWQVjzdBkcdDAbb4qxN9QpIwpbQdjjFASlzj4vxCZQCYejui2zB0STs6ec1JR5ftuPf0y9NveNFcbwCrbRVNs2j2GgpD4Kc5qYElYC5MZ0',
            'domain': '.debridmediamanager.com',  # Adjust the domain accordingly
            'path': '/',
            'secure': True,  # Set to True if the cookie is secure
            'httpOnly': False  # Adjust if the cookie is HttpOnly
        }
    ]
    
    follow_dynamic_content(start_url, cookies)
