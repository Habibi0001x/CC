local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local player = Players.LocalPlayer

local function kick()
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
            kick()
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
        if debug.info(re.FireServer, "s") ~= "[C]" then kick() end
    end)
    pcall(function()
        if debug.info(rf.InvokeServer, "s") ~= "[C]" then kick() end
    end)
    
    re:Destroy()
    rf:Destroy()
end

local function checkMetatable()
    local success, gmt = pcall(function() return getrawmetatable(game) end)
    if success and gmt and gmt.__namecall then
        if debug.info(gmt.__namecall, "s") ~= "[C]" then
            kick()
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
            kick()
        end
    end
end

local function scanHui()
    local success, hui = pcall(function() return (gethui and gethui()) or CoreGui end)
    if success and hui then
        for _, child in ipairs(hui:GetChildren()) do
            if isSuspicious(child.Name) then
                kick()
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
        kick()
    end
end)

pcall(function()
    gethui().ChildAdded:Connect(function(child)
        if isSuspicious(child.Name) then
            kick()
        end
    end)
end)

print("[SECURITY] Checks Loaded")
