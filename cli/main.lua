function main()
    local article = argv.get_flag_arg_by_index({ "article", "a" }, 1)
    if not article then
        print("Error: Article argument is required.")
        return
    end

    local chromedriver_path = argv.get_flag_arg_by_index({ "chromedriver_path" ,"d" }, 1)
    if not chromedriver_path then
        print("Error: ChromeDriver path argument is required.")
        return
    end

    local chrome_binary = argv.get_flag_arg_by_index({ "chrome_binary", "c" }, 1)
    if not chrome_binary then
        print("Error: Chrome binary argument is required.")
        return
    end

    local out_dir  = argv.get_flag_arg_by_index({ "out_dir", "o" }, 1)
    if not out_dir then
        print("Error: Output directory argument is required.")
        return
    end

    dtw.remove_any(out_dir)
    local download_path = out_dir.."/downloads/"
    dtw.write_file(download_path.."nothing","")
    dtw.remove_any(download_path.."nothing")

    local result = Rpa.fetch_wikipedia_article({
        article = article,
        chromedriver_path = chromedriver_path,
        chrome_binary = chrome_binary,
        outdir = download_path
    })

    dtw.write_file(out_dir.."/result.json",json.dumps_to_string(result))
end