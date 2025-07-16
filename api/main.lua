-- Example of local function
local function local_sum(x, y)
    return x + y
end

-- Example of public API function
function PublicApi.sum(x, y)
    return local_sum(x, y) 
end