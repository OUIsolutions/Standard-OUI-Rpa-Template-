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
    local search_results = session.get_elements_by_css_selector(".cdx-menu-item__content")
    if #search_results <= 1 then
        return false
    end
    search_results[1].click()
    os.execute("sleep 2")
    return true
end

local function get_article_content(session)
    local content_map = {}
    local page_hatnote = session.get_element_by_css_selector(".hatnote")
    if page_hatnote then
        content_map.hatnote = page_hatnote.get_text()
    end

    local text = ""

    local body = session.get_element_by_css_selector(".mw-parser-output")
    for i = 1, 10 do 
        local paragraph = body.get_element_by_index(i) -- <-- fails
        local text = tr.get_text()
        if text and text ~= "" then
            print(i .. ". " .. text)
        end
    end

    -- Fails as well
    -- local paragraphs = session.get_elements_by_css_selector(".mw-parser-output > p")
    -- for i = 1, 10 do
    --     local text = paragraphs[i].get_text()
    --     if text and text ~= "" then
    --         print(i .. ". " .. text)
    --     end

    return content_map
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
    local article_found = navigate_to_article(session, article)
    if not article_found then
        print("\nArticle \"" .. article .. "\" not found.\n")
        return nil
    end
    
    local article_content = get_article_content(session)

    return article_content
end