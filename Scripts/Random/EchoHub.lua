local gamescripts = {
    [126884695634066] = "https://api.luarmor.net/files/v3/loaders/868384a9798a122db625b53199ae84bb.lua",
    [2753915549]      = "https://api.luarmor.net/files/v3/loaders/36ee5f40e2b57d44f2af0049d438cf09.lua",
    [124977557560410] = "https://api.luarmor.net/files/v3/loaders/36ee5f40e2b57d44f2af0049d438cf09.lua",
    [4442272183]      = "https://api.luarmor.net/files/v3/loaders/36ee5f40e2b57d44f2af0049d438cf09.lua",
    [101151419317285] = "https://api.luarmor.net/files/v3/loaders/36ee5f40e2b57d44f2af0049d438cf09.lua",
    [7449423635]      = "https://api.luarmor.net/files/v3/loaders/36ee5f40e2b57d44f2af0049d438cf09.lua",
    [96342491571673]  = "https://api.luarmor.net/files/v3/loaders/e5f9f615f943858198b7816b963cf706.lua",
    [109983668079237] = "https://api.luarmor.net/files/v3/loaders/e5f9f615f943858198b7816b963cf706.lua",
    [79546208627805]  = "https://api.luarmor.net/files/v3/loaders/af6a9697d1cf7e8a288fb1279b363385.lua",
    [126509999114328] = "https://api.luarmor.net/files/v3/loaders/87684dc664efb78576c425146fcea4e3.lua",
    [121864768012064] = "https://api.luarmor.net/files/v3/loaders/02d021bc5317adc01b1f42696184ba16.lua",
    [142823291]       = "https://api.luarmor.net/files/v3/loaders/2110e245e129f6c1d2b451d26dd2712e.lua",
    [537413528]       = "https://api.luarmor.net/files/v3/loaders/8d16095fa5d1532a6dc727beafdefa61.lua",
    [127742093697776] = "https://api.luarmor.net/files/v3/loaders/5b8bcc342eb805a81c7a5772b5d5c370.lua",
    [16732694052]     = "https://api.luarmor.net/files/v3/loaders/ba120508e61c7cd87899ec69bc544788.lua",
    -- // Build ur base removed.
    [18687417158]     = "https://api.luarmor.net/files/v3/loaders/3aa92a34a03f3c1010587a07903446d4.lua",
    -- // Violence district removed.
    -- // Build a Plane removed. 
    
}

local gameid = game.PlaceId

if gamescripts[gameid] then
    local url = gamescripts[gameid]
    loadstring(game:HttpGet(url))()
else
    game.StarterGui:SetCore("SendNotification", {
        Title = "Not Supported",
        Text = "This game isn't supported",
        Duration = 5
    })
end

-- // this is here to debug/update any attempt of deobfuscation/dumping will resault in nothing, since you cannot dump it. lol.
