local function configure_chrome()

    
    local chromedriver_path = argv.get_flag_arg_by_index({ "chromedriver_path" ,"d" }, 1)
    if not chromedriver_path then
        error("Error: --chromedriver_path path argument is required.")
        return
    end

    local chrome_binary = argv.get_flag_arg_by_index({ "chrome_binary", "c" }, 1)
    if not chrome_binary then
        error("Error: --chrome_binary argument is required.")
        return
    end
    set_prop("chromedriver_path", chromedriver_path)
    set_prop("chrome_binary", chrome_binary)


end

function run_crawler()
    
    local chromedriver_path = get_prop("chromedriver_path")
    if not chromedriver_path then
        error("Error: ChromeDriver path is not configured. Please run 'configure_chrome'")
        return
    end

    local chrome_binary = get_prop("chrome_binary")
    if not chrome_binary then
        error("Error: Chrome binary is not configured. Please run 'configure_chrome'")
        return
    end

    local article = argv.get_flag_arg_by_index({ "article", "a" }, 1)
    if not article then
        error("Error: --article argument is required.")
        return
    end

    local out_dir  = argv.get_flag_arg_by_index({ "out_dir", "o" }, 1)
    if not out_dir then
        error("Error: --out_dir argument is required.")
        return
    end
    
    dtw.remove_any(out_dir)
    local download_path = out_dir.."/downloads/"
    dtw.write_file(download_path.."nothing","")
    dtw.remove_any(download_path.."nothing")

    local result = API.fetch_wikipedia_article({
        article = article,
        chromedriver_path = chromedriver_path,
        chrome_binary = chrome_binary,
        outdir = download_path
    })

    dtw.write_file(out_dir.."/result.json",json.dumps_to_string(result))
end 
function main()
    
    local possible_action = argv.get_next_unused()
    if not possible_action then
        error("Error: No action specified. Please provide an action.")
        error("Available actions: configure_chrome, run_crawler")
        return
    end

    if possible_action == "configure_chrome" then
        configure_chrome()
    elseif possible_action == "run_crawler" then
        run_crawler()
    else 
        error("Error: Unknown action '" .. possible_action .. "'.")
        error("Available actions: configure_chrome, run_crawler")
    end
end