local CONCAT_PATH = true 

-- Bundles the API files into a single Lua file
function build_api()
    local files = darwin.dtw.list_files_recursively("api", CONCAT_PATH)
    
    local content = "local PublicApi = {}\n"
    for i =1, #files do
        content = content .. "\n" .. darwin.dtw.load_file(files[i]) 
    end

    content = content.."\nreturn PublicApi\n"

    return "(function ()\n" .. content .. "\nend)()"
end

-- Bundles the API bundle into a library format
function build_api_lib(api_content)
    return "return " .. api_content .. "\n"
end  

function  build_cli(api_content)
    local files = darwin.dtw.list_files_recursively("cli",CONCAT_PATH)

    local content = "local Rpa = " ..api_content .. "\n"
    for i =1,#files do 
        content = content.."\n"..darwin.dtw.load_file(files[i]) 
    end     
    
    content = content.. "\nmain()\n"
    return content
end

-- Main bundle generation function
function  main()
    local api_content = build_api()
    local api_lib = build_api_lib(api_content)
    local cli_content = build_cli(api_content)
    
    darwin.dtw.write_file("release/api.lua", api_content)
    darwin.dtw.write_file("release/cli.lua", cli_content)
    darwin.dtw.write_file("release/api_lib.lua", api_lib)
end

main()