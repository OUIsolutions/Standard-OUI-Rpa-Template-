local CONCAT_PATH = true 

function build_api()
    local files = darwin.dtw.list_files_recursively("api",CONCAT_PATH)
    local content = "local PublicApi = {}\n"
    
    for i =1,#files do
        content = content.."\n"..darwin.dtw.load_file(files[i]) 
    end

    content = content.."\nreturn PublicApi\n"
    return "(function ()\n" .. content .. "\nend)()"
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

function  main()
    local api_content = build_api()
    local cli_content = build_cli(api_content)
    
    darwin.dtw.write_file("release/api.lua", api_content)
    darwin.dtw.write_file("release/cli.lua", cli_content)
end

main()