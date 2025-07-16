function main()


  local article = argv.get_flag_arg_by_index({ "article" }, 1)
  if not article then
    print("Error: Article argument is required.")
    return
  end
    local chromedriver_path = argv.get_flag_arg_by_index({ "chromedriver_path" ,"chromedriver"}, 1)
    if not chromedriver_path then
        print("Error: ChromeDriver path argument is required.")
        return
    end
    local chrome_binary = argv.get_flag_arg_by_index({ "chrome_binary","chrome" }, 1)
    if not chrome_binary then
        print("Error: Chrome binary argument is required.")
        return
    end
    local out_json = argv.get_flag_arg_by_index({ "out_json" }, 1)
    if not out_json then
        print("Error: Output JSON file argument is required.")
        return
    end
    local result = Rpa.make_wikipedia_search({
        article = article,
        chromedriver_path = chromedriver_path,
        chrome_binary = chrome_binary
    })
    dtw.write_file(out_json,json.dumps_to_string(result))


end