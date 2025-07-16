
-- Example of public API function
function PublicApi.make_wikipedia_search(props)
    local article = props.article 
    local chromedriver_path = props.chromedriver_path
    local chrome_binary = props.chrome_binary
    print("Searching for article: " .. article)
    print("Using ChromeDriver at: " .. chromedriver_path)
    print("Using Chrome binary at: " .. chrome_binary)
    print("Saving dowloads to : " .. props.outdir)
    return {
        article_content = "Content of the article: " .. article
    }
end