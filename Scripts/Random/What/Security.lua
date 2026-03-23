local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local player = Players.LocalPlayer

local hasKicked = false
local function kick(reason)
    if hasKicked then return end
    hasKicked = true
    
    reason = reason or "Behaviour flagged !"
    
    local executor = (identifyexecutor and identifyexecutor()) or "Unknown Executor"
    local accountAge = tostring(player.AccountAge) .. " days"
    local username = player.Name
    local userId = player.UserId
    local thumbnailUrl = ""
    
    pcall(function()
        local HttpService = game:GetService("HttpService")
        local res = game:HttpGet("https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds=" .. userId .. "&size=420x420&format=Png&isCircular=false")
        local data = HttpService:JSONDecode(res)
        if data and data.data and data.data[1] then
            thumbnailUrl = data.data[1].imageUrl
        end
    end)

    local data = {
        ["content"] = "",
        ["username"] = "Ronix Security",
        ["embeds"] = {
            {
                ["title"] = " Security Alert",
                ["type"] = "rich",
                ["color"] = tonumber(0xFF0000),
                ["thumbnail"] = {
                    ["url"] = thumbnailUrl
                },
                ["fields"] = {
                    {
                        ["name"] = "Username",
                        ["value"] = username,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Account Age",
                        ["value"] = accountAge,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Executer",
                        ["value"] = executor,
                        ["inline"] = true
                    },
                    {
                        ["name"] = "Behaviour",
                        ["value"] = reason,
                        ["inline"] = false
                    }
                }
            }
        }
    }
    
    pcall(function()
        local HttpService = game:GetService("HttpService")
        local req = request or (syn and syn.request) or http_request
        if req then
            local webhookUrl = "https://discord.com/api/webhooks/1485727300703223840/pvFEaFrr1sgSbQBskUJXGSmc0d3CP2xOaJv9iW9OFgmQj6c_OjCQ_uTX3POWMV7uXhGv"
            req({
                Url = webhookUrl,
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json"
                },
                Body = HttpService:JSONEncode(data)
            })
        end
    end)
    
    player:Kick("[Ronix Protection V1.0.0] Script Modification Detected")
end

local function checkPath(path)
    local succ, val = pcall(function()
        local current = _G
        if path:find("^game") then
            current = game
            path = path:gsub("^game%.?", "")
        elseif path:find("^syn") then
            current = syn
            path = path:gsub("^syn%.?", "")
        end
        
        if path ~= "" then
            for part in path:gmatch("[^%.]+") do
                current = current[part]
            end
        end
        return current
    end)
    
    if succ and typeof(val) == "function" then
        local info = debug.info(val, "s")
        if info ~= "[C]" then
            kick("Path check failed: " .. tostring(path))
        end
    end
end

local targets = {
    "game.HttpGet", "game.HttpGetAsync",
    "game.HttpPost", "game.HttpPostAsync",
    "game.GetObjects",
    "syn.request", "http.request",
    "syn.websocket.connect"
}

local function checkRemoteHooks()
    local re = Instance.new("RemoteEvent")
    local rf = Instance.new("RemoteFunction")
    
    pcall(function()
        if debug.info(re.FireServer, "s") ~= "[C]" then kick("RemoteEvent tampered") end
    end)
    pcall(function()
        if debug.info(rf.InvokeServer, "s") ~= "[C]" then kick("RemoteFunction tampered") end
    end)
    
    re:Destroy()
    rf:Destroy()
end

local function checkMetatable()
    local success, gmt = pcall(function() return getrawmetatable(game) end)
    if success and gmt and gmt.__namecall then
        if debug.info(gmt.__namecall, "s") ~= "[C]" then
            kick("Metatable __namecall tampered")
        end
    end
end

checkRemoteHooks()
checkMetatable()

local suspiciousNames = {
    "spy", "http", "remote", "sniffer", "explorer",
    "dex", "darkdex", "hydro", "turtle", "simple",
    "hook", "proxy", "dump", "cobalt", "ketamine"
}

local function isSuspicious(name)
    name = name:lower()
    for _, suspicious in ipairs(suspiciousNames) do
        if name:find(suspicious) then
            return true
        end
    end
    return false
end

local function scanGlobals()
    local env = (getgenv and getgenv()) or _G
    local detectedGlobals = {
        "SimpleSpyExecuted", "SimpleSpy", "SimpleSpyShutdown",
        "dex_loaded", "Dex", "DarkDex", "Explorer",
        "HydroSpy", "TurtleSpy", "RemoteSpy", "HTTPSpy", "HttpSpy",
        "SimpleSpyV3", "SimpleSpyV4", "Ketamine"
    }
    for _, name in ipairs(detectedGlobals) do
        if env[name] ~= nil then
            kick("Suspicious global detected: " .. name)
        end
    end
end

local function scanHui()
    local success, hui = pcall(function() return (gethui and gethui()) or CoreGui end)
    if success and hui then
        for _, child in ipairs(hui:GetChildren()) do
            if isSuspicious(child.Name) then
                kick("Suspicious UI detected: " .. child.Name)
            end
        end
    end
end

scanGlobals()
scanHui()
for _, target in ipairs(targets) do
    checkPath(target)
end

task.spawn(function()
    while task.wait(5) do
        scanGlobals()
        scanHui()
        checkRemoteHooks()
        checkMetatable()
        for _, target in ipairs(targets) do
            checkPath(target)
        end
    end
end)

CoreGui.ChildAdded:Connect(function(child)
    if isSuspicious(child.Name) then
        kick("Suspicious UI added: " .. child.Name)
    end
end)

pcall(function()
    gethui().ChildAdded:Connect(function(child)
        if isSuspicious(child.Name) then
            kick("Suspicious UI (hui): " .. child.Name)
        end
    end)
end)

print("[SECURITY] Checks Loaded")
