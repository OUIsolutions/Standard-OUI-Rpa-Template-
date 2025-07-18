return (function()

local WebDriver = {};
local Server  ={};
local Session = {};
local MetaSession = {};
local PublicSession = {};
local Element = {};
local MetaElement = {};
local PublicElement = {};

local Heregitage = (function()  
return (function ()

    local herigitage = {}
    herigitage.pairs =pairs
    herigitage.setmetatable = setmetatable
    herigitage.type = type
    herigitage.newMetaObject = function (props)
        if not props then
            props = {}
        end
        local selfobject = {}
        selfobject.public = props.public or {}
        selfobject.private = props.private or {}
        selfobject.meta_table =  props.meta_table or {}
        
        -- Factory function to create method setters
        local function createMethodSetter(target, extraAction)
            return function(method_name, callback)
                target[method_name] = function (...)
                    return callback(selfobject.public, selfobject.private, ...)
                end
                if extraAction then
                    extraAction()
                end
            end
        end
        
        selfobject.set_meta_method = createMethodSetter(selfobject.meta_table, function()
            herigitage.setmetatable(selfobject.public, selfobject.meta_table)
        end)
        
        selfobject.set_public_method = createMethodSetter(selfobject.public)
        
        selfobject.set_private_method = createMethodSetter(selfobject.private)
        
        -- Props extends functions - basic property assignment without function checking
        selfobject.public_props_extends = function(props)
            for k,v in herigitage.pairs(props) do
                selfobject.public[k] = v
            end
        end
        
        selfobject.private_props_extends = function(props)
            for k,v in herigitage.pairs(props) do
                selfobject.private[k] = v
            end
        end
        
        selfobject.meta_props_extends = function(props)
            for k,v in herigitage.pairs(props) do
                selfobject.meta_table[k] = v
            end
        end
        
        -- Method extends functions - treat all props as methods
        selfobject.public_method_extends = function(props)
            for k,v in herigitage.pairs(props) do
                selfobject.set_public_method(k, v)
            end
        end
        
        selfobject.private_method_extends = function(props)
            for k,v in herigitage.pairs(props) do
                selfobject.set_private_method(k, v)
            end
        end
        
        selfobject.meta_method_extends = function(props)
            for k,v in herigitage.pairs(props) do
                selfobject.set_meta_method(k, v)
            end
        end

        return selfobject
    end


    return herigitage



end )()
 end
)()


PublicElement.send_keys = function(public, private, keys)
    -- Check if the keys parameter is a string
    if type(keys) ~= "string" then
        error("Keys must be a string")
    end

    -- Send the request to the WebDriver server
    local result = private.fetch({
        url = private.url .. "/session/" .. private.session_id .. "/element/" .. private.element_id .. "/value",
        method = "POST",
        headers = {
            ["Content-Type"] = "application/json"
        },
        body = {text=keys},
        http_version = "1.1"
    })

    -- Check for errors in the response
    if result.status_code  ~= 200 then
        error("Failed to send keys: " .. (result.read_body() or "Unknown error"))
    end

    return true
end

PublicElement.click = function(public, private)
    -- Send a POST request to click the element
    local result = private.fetch({
        url = private.url .. "/session/" .. private.session_id .. "/element/" .. private.element_id .. "/click",
        method = "POST",
        http_version = "1.1",
        body={}
    })
    -- Check for errors in the response
    if result.status_code  ~= 200 then
        error("Failed to send keys: " .. (result.read_body() or "Unknown error"))
    end

    return true
end




Element.newElement = function (props)
    local selfobject = Heregitage.newMetaObject()
    selfobject.private_props_extends(props)
    selfobject.public_method_extends(PublicElement)
    selfobject.meta_method_extends(MetaElement)
    return selfobject.public
end 



PublicElement.get_chromedriver_id = function(public, private)
    return private.element_id
end

PublicElement.get_element = function(public, private, selector, value)
    local payload = {
        using = selector,
        value = value
    }
    local response = private.fetch({
        method = "POST",
        http_version = "1.1",
        url = private.url .. "/session/" .. private.session_id .. "/element/" .. private.element_id .. "/element",
        body = payload
    })
    if response.status_code == 200 then
        local body = response.read_body_json()
    
        if body.value and body.value["element-6066-11e4-a52e-4f735466cecf"] then
            local element = Element.newElement({
                element_id = body.value["element-6066-11e4-a52e-4f735466cecf"],
                session_id = private.session_id,
                url = private.url,
                fetch = private.fetch
            })
            return element
        end
    else 
        local error_body = response.read_body()
        error("Failed to get element: " .. (error_body or "Unknown error"))
    end
    return nil
end
PublicElement.get_element_by_id = function(public, private, element_id)
    if not element_id then
        error("element_id is required to get an element by ID")
    end
    return public.get_element("xpath", "//*[@id='" .. element_id .. "']")
end

PublicElement.get_element_by_css_selector = function(public, private, selector)
    if not selector then
        error("selector is required to get an element by CSS selector")
    end
    return public.get_element("css selector", selector)
end

PublicElement.get_element_by_xpath = function(public, private, xpath)
    if not xpath then
        error("xpath is required to get an element by XPath")
    end
    return public.get_element("xpath", xpath)
end

PublicElement.get_element_by_class_name = function(public, private, class_name)
    if not class_name then
        error("class_name is required to get an element by class name")
    end
    return public.get_element("xpath", "//*[@class='" .. class_name .. "']")

end



PublicElement.get_elements = function(_public, private, selector, value)

    local response = private.fetch({
        method = "POST",
        http_version="1.1",
        url = private.url .. "/session/" .. private.session_id .. "/element/" .. private.element_id .. "/elements",
        body = {
            using = selector,
            value = value
        }
    })

    if response.status_code == 200 then
        local body = response.read_body_json()
        if body.value and #body.value > 0 then
            local elements = {}
            for i=1,#body.value do
                local element_data = body.value[i]
                print("element id is " .. element_data["element-6066-11e4-a52e-4f735466cecf"])
                local element = Element.newElement({
                    element_id = element_data["element-6066-11e4-a52e-4f735466cecf"],
                    session_id = private.session_id,
                    url = private.url,
                    fetch = private.fetch
                })
                elements[#elements + 1] = element
            end
            return elements
        end
    else 
        local error_body = response.read_body()
        error("Failed to get elements: " .. (error_body or "Unknown error"))
    end
    return {}
end

PublicElement.get_elements_by_css_selector = function(public, private, selector)
    if not selector then
        error("selector is required to get elements by CSS selector")
    end
    return public.get_elements("css selector", selector)
end

PublicElement.get_elements_by_xpath = function(public, private, xpath)
    if not xpath then
        error("xpath is required to get elements by XPath")
    end
    return public.get_elements("xpath", xpath)
end

PublicElement.get_elements_by_class_name = function(public, private, class_name)
    if not class_name then
        error("class_name is required to get elements by class name")
    end
    return public.get_elements("class name", class_name)
end


PublicElement.get_element_by_index_recursively = function(public, private, index)
    if not index or type(index) ~= "number" or index < 1 then
        error("Index must be a positive integer")
    end

    local elements = public.get_elements("css selector", "*")
    return elements[index]    
end


PublicElement.get_element_by_index = function(public, private, index)
    if not index or type(index) ~= "number" or index < 1 then
        error("Index must be a positive integer")
    end
    
    -- Get only direct children (siblings at the same level)
    local elements = public.get_elements("xpath", "./child::*")
    return elements[index]
    
end

PublicElement.get_children_size = function(public, private)
    local elements = public.get_elements("xpath", "./child::*")
    return #elements
end


PublicElement.get_all_children_size = function(public, private)
    local elements = public.get_elements("css selector", "*")
    return #elements
end


MetaElement.__tostring = function (public,private)
    return public.get_html()
end
MetaElement.__index = function (public,private,self,index)
    return public.get_element_by_index(index)
end

PublicElement.get_html = function(public, private)

    print("aaa")
    local response = private.fetch({
        method = "GET",
        http_version = "1.1",
        url = private.url .. "/session/" .. private.session_id .. "/element/" .. private.element_id .. "/property/outerHTML"
    })
    print("bbb")

    if response.status_code == 200 then
        local body = response.read_body_json()
        if body and body.value then
            return body.value
        end
    end
    return nil
end




PublicElement.get_text = function(public, private)
    local response = private.fetch({
        method = "GET",
        http_version = "1.1",
        url = private.url .. "/session/" .. private.session_id .. "/element/" .. private.element_id .. "/text"
    })
    
    if response.status_code == 200 then
        local body = response.read_body_json()
        if body and body.value then
            return body.value
        end
    end
    return nil
end



PublicElement.get_attribute = function(public, private, attribute_name)
    if not attribute_name or type(attribute_name) ~= "string" then
        error("Nome do atributo deve ser uma string não vazia")
    end
    
    local response = private.fetch({
        method = "GET",
        http_version = "1.1",
        url = private.url .. "/session/" .. private.session_id .. "/element/" .. private.element_id .. "/attribute/" .. attribute_name
    })
    
    if response.status_code == 200 then
        local body = response.read_body_json()
        if body and body.value ~= nil then
            return body.value
        end
    end
    return nil
end


PublicElement.get_id = function(public, private)
    return private.element_id   
end

PublicElement.execute_script = function(public, private, script, ...)
    if not script or type(script) ~= "string" then
        error("Script should be a non-empty string")
    end
    
    -- Prepare arguments - the element is passed as the first argument, followed by any additional arguments
    local args = {...}
    -- Insert the element reference as the first argument (arguments[0] in JavaScript)
    local element_ref = {["element-6066-11e4-a52e-4f735466cecf"] = private.element_id}
    table.insert(args, 1, element_ref)
    
    local response = private.fetch({
        method = "POST",
        http_version = "1.1",
        url = private.url .. "/session/" .. private.session_id .. "/execute/sync",
        body = {
            script = script,
            args = args
        }
    })
    
    if response.status_code == 200 then
        local body = response.read_body_json()
        if body then
            return body.value
        end
    else
        local error_body = response.read_body()
        error("Failed to execute script: " .. (error_body or "Unknown error"))
    end
    return nil
end




Server.__gc = function (public,private)
    print("turning off chromedriver on port " .. private.port)
    private.fetch({
        http_version = "1.1",
        url=string.format("http://127.0.0.1:%d/shutdown", private.port),
    })
end

Server.newSession = function(public,private, props)
    if not props then 
        error("props is required")
    end
    if not props.binary_location then
        error("binary_location is required")
    end

    return Session.newSession({url = private.url, fetch = private.fetch,binary_location= props.binary_location})
end


WebDriver.newLocalServer = function(props)

    if not props.chromedriver_command then
        error("chromedriver_command is required")
    end
    
    if not props.fetch then
        error("fetch is required")
    end

    local selfobj = Heregitage.newMetaObject()
    selfobj.private_props_extends(props)
    selfobj.private.url = "http://127.0.0.1:"..selfobj.private.port
    selfobj.set_meta_method("__gc", Server.__gc)
    selfobj.set_public_method("newSession", Server.newSession)


    -- Start chromedriver with proper command formatting
    local command = "%s --port=%d &"
    command = command:format(props.chromedriver_command, props.port)
    
    print("Starting chromedriver with command: " .. command)
    os.execute(command)
    
    -- Wait for chromedriver to start
    os.execute("sleep 2")
    
    return selfobj.public
end

WebDriver.newRemoteServer = function(props)
    if not props.url then
        error("url is required")
    end

    if not props.fetch then
        error("fetch is required")
    end

    local selfobj = Heregitage.newMetaObject()
    selfobj.private_props_extends(props)
    selfobj.private.url = props.url
    selfobj.set_meta_method("__gc", Server.__gc)
    selfobj.set_public_method("newSession", Server.newSession)

    return selfobj.public
end





Session.newSession = function (props)

    local selfobject = Heregitage.newMetaObject()
    selfobject.private_props_extends(props)
    selfobject.meta_method_extends(MetaSession)
    selfobject.public_method_extends(PublicSession)
    local args = props.args 
    
    
    if not args  then 
        args = {
            "--disable-blink-features=AutomationControlled",
            "--disable-infobars",
            "--disable-notifications",
            "--disable-popup-blocking",
            "--disable-extensions",
            "--no-sandbox",
            "--ignore-certificate-errors",
            "--window-size=1920,1080",
            "--user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36"
        }
    end

    local use_automation_extension = props.use_automation_extension or false

    local result = props.fetch({
        url=props.url.."/session",
        method = "POST",
        http_version = "1.1",
        body = {
            capabilities = {
                alwaysMatch = {
                    browserName = "chrome",
                    ["goog:chromeOptions"] = {
                        binary = props.binary_location,
                        args =args,
                        excludeSwitches = {"enable-automation"},
                        useAutomationExtension = use_automation_extension
                    }
                }
            }
        }
    })
    local body = result.read_body_json()
    selfobject.private.session_id = body.value.sessionId
    return selfobject.public

end



PublicSession.get_id = function(public, private)
    return private.session_id
end

PublicSession.get_element = function(public,private,by, value)
    if not by or not value then
        error("by and value are required to get an element")
    end

    local result = private.fetch({
        url = private.url .. "/session/" .. private.session_id .. "/element",
        method = "POST",
        http_version = "1.1",
        body = {
            using = by,
            value = value
        }
    })
    
    if result.status_code ~= 200 then
        error("Failed to get element: " .. result.read_body())
    end
    local body = result.read_body_json()
    local id = body.value["element-6066-11e4-a52e-4f735466cecf"]
    return Element.newElement({
        element_id = id,
        url = private.url,
        session_id = private.session_id,
        fetch = private.fetch
   })
   
end
PublicSession.get_element_by_id = function(public,private,element_id)
    if not element_id then
        error("element_id is required to get an element by ID")
    end
    return public.get_element( "xpath", "//*[@id='" .. element_id .. "']")
end

PublicSession.get_element_by_css_selector = function(public,private,selector)
    if not selector then
        error("selector is required to get an element by CSS selector")
    end
    return public.get_element("css selector", selector)
end

PublicSession.get_element_by_xpath = function(public,private,xpath)
    if not xpath then
        error("xpath is required to get an element by XPath")
    end
    return public.get_element( "xpath", xpath)
end

PublicSession.get_element_by_class_name = function(public,private,class_name)
    if not class_name then
        error("class_name is required to get an element by class name")
    end
    return public.get_element("class name", class_name)
end

PublicSession.get_elements = function(public,private,by, value)
    if not by or not value then
        error("by and value are required to get elements")
    end

    local result = private.fetch({
        url = private.url .. "/session/" .. private.session_id .. "/elements",
        method = "POST",
        http_version = "1.1",
        body = {
            using = by,
            value = value
        }
    })
    
    if result.status_code ~= 200 then
        error("Failed to get elements: " .. result.read_body())
    end
    
    local body = result.read_body_json()
    local elements = {}
    
    if body.value and #body.value > 0 then
        for _, element_data in ipairs(body.value) do
            local element = Element.newElement({
                element_id = element_data["element-6066-11e4-a52e-4f735466cecf"],
                url = private.url,
                session_id = private.session_id,
                fetch = private.fetch
            })
            elements[#elements + 1] = element
        end
    end
    
    return elements
end


PublicSession.get_elements_by_css_selector = function(public,private,selector)
    if not selector then
        error("selector is required to get elements by CSS selector")
    end
    return public.get_elements("css selector", selector)
end

PublicSession.get_elements_by_xpath = function(public,private,xpath)
    if not xpath then
        error("xpath is required to get elements by XPath")
    end
    return public.get_elements( "xpath", xpath)
end

PublicSession.get_elements_by_class_name = function(public,private,class_name)
    if not class_name then
        error("class_name is required to get elements by class name")
    end
    return public.get_elements("class name", class_name)
end


PublicSession.get_session_id = function(public, private)
    return private.session_id
end

MetaSession.__gc = function (public, private)
    print("Closing session with ID: " .. private.session_id)
    
    -- First, close the WebDriver session
    local result = private.fetch({
        url = private.url .. "/session/" .. private.session_id,
        method = "DELETE",
        http_version = "1.1"
    })
    if result.status_code ~= 200 then
        print("Failed to close session: " .. result.read_body())
    end
end



PublicSession.navegate_to = function(public,private,url)
   
    if not url then 
        error("URL is required for navigation")
    end
    --make a requisiton to navegate_to a url
    local result = private.fetch({
        url = private.url .. "/session/" .. private.session_id .. "/url",
        method = "POST",
        http_version = "1.1",
        body = {
            url = url
        }
    })
    if result.status_code ~= 200 then
        error("Failed to navigate to URL: " .. result.read_body())
    end
end


-- Switch to a specific window by handle
PublicSession.switch_to_window = function(public, private, index)
    if not index or type(index) ~= "number" then
        error("Window index is required for switching windows")
    end

    local handles_request = private.fetch({
        url = private.url .. "/session/" .. private.session_id .. "/window/handles",
        method = "GET",
        http_version = "1.1"
    })
    local handles = handles_request.read_body_json().value or {}
    if index < 1 or index > #handles then
        error("Invalid window index: " .. index)
    end
    local window_handle = handles[index]
    local result = private.fetch({
        url = private.url .. "/session/" .. private.session_id .. "/window",
        method = "POST",
        http_version = "1.1",
        body = {
            handle = window_handle
        }
    })
    if result.status_code ~= 200 then
        error("Failed to switch to window: " .. result.read_body())
    end
end

PublicSession.open_new_tab = function(public, private)
    local result = private.fetch({
        url = private.url .. "/session/" .. private.session_id .. "/window/new",
        method = "POST",
        http_version = "1.1",
        body = {
            type = "tab"
        }
    })
    if result.status_code ~= 200 then
        error("Failed to create new window: " .. result.read_body())
    end
end

-- Open a new window or tab
PublicSession.open_new_window = function(public, private)
    local result = private.fetch({
        url = private.url .. "/session/" .. private.session_id .. "/window/new",
        method = "POST",
        http_version = "1.1",
        body = {
            type = "Window"
        }
    })
    if result.status_code ~= 200 then
        error("Failed to create new window: " .. result.read_body())
    end
end



-- Close the current window
PublicSession.close_window = function(public, private)
    local result = private.fetch({
        url = private.url .. "/session/" .. private.session_id .. "/window",
        method = "DELETE",
        http_version = "1.1"
    })
    
    if result.status_code ~= 200 then
        error("Failed to close window: " .. result.read_body())
    end
    
    local body = result.read_body_json()
    return body.value or {}
end




---@class WebDriverServer

---@class WebDriver
---@field newLocalServer fun(props:table): WebDriverServer

---@type WebDriver
WebDriver = WebDriver 


---@class WebDriverPrivateFunctions


---@type WebDriverPrivateFunctions
Private  = Private


    return WebDriver;
end)()