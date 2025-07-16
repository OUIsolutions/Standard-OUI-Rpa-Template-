local function init_chromedriver(chromedriver_path, chrome_binary)
    -- Setup WebDriver server
    local server = webdriver.newLocalServer({
        fetch = luabear.fetch,
        chromedriver_command = "./chrome/chromedriver-linux64/chromedriver",
        port = 4444
    })

    -- Create a new browser session
    local session = server.newSession({
        binary_location = "./chrome/chrome-linux64/chrome",
    })

    return session
end

local function navigate_to_article(session, article)
    session.navegate_to("https://en.wikipedia.org/wiki/Main_Page")

    local search_input = session.get_element_by_css_selector(".cdx-text-input__input")
    search_input.click()
    search_input.send_keys(article)
    os.execute("sleep 1")
    local search_result = session.get_element_by_css_selector(".cdx-menu-item__content")
    search_result.click()
    os.execute("sleep 1")
end

-- Example of public API function
function PublicApi.fetch_wikipedia_article(props)
    local article = props.article 
    local chromedriver_path = props.chromedriver_path
    local chrome_binary = props.chrome_binary

    print("Searching for article: " .. article)
    print("Using ChromeDriver at: " .. chromedriver_path)
    print("Using Chrome binary at: " .. chrome_binary)
    print("Saving dowloads to : " .. props.outdir)
    print("\n")

    local session = init_chromedriver(chromedriver_path, chrome_binary)
    navigate_to_article(session, article)

    return {
        article_content = "Content of the article: " .. article
    }
end