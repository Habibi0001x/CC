local cloneref = cloneref or function(a) return a end
local CoreGui = cloneref(game:GetService("CoreGui"))
local TweenService = cloneref(game:GetService("TweenService"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local HttpService = cloneref(game:GetService("HttpService"))
local Players = cloneref(game:GetService("Players"))

local KeySystem = {}
KeySystem.__index = KeySystem

local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled

local Themes = {
    Default = {
        MainColor = Color3.fromRGB(0, 0, 0),
        SecondaryColor = Color3.fromRGB(10, 10, 10),
        AccentColor = Color3.fromRGB(255, 255, 255),
        TextColor = Color3.fromRGB(255, 255, 255),
        SecondaryTextColor = Color3.fromRGB(160, 160, 160),
        BorderColor = Color3.fromRGB(40, 40, 40),
        SuccessColor = Color3.fromRGB(74, 222, 128),
        ErrorColor = Color3.fromRGB(248, 113, 113),
        WarningColor = Color3.fromRGB(251, 191, 36),
        DiscordColor = Color3.fromRGB(88, 101, 242)
    },
    Dark = {
        MainColor = Color3.fromRGB(12, 12, 12),
        SecondaryColor = Color3.fromRGB(18, 18, 18),
        AccentColor = Color3.fromRGB(99, 102, 241),
        TextColor = Color3.fromRGB(250, 250, 250),
        SecondaryTextColor = Color3.fromRGB(140, 140, 140),
        BorderColor = Color3.fromRGB(38, 38, 38),
        SuccessColor = Color3.fromRGB(74, 222, 128),
        ErrorColor = Color3.fromRGB(248, 113, 113),
        WarningColor = Color3.fromRGB(251, 191, 36),
        DiscordColor = Color3.fromRGB(88, 101, 242)
    },
    Light = {
        MainColor = Color3.fromRGB(255, 255, 255),
        SecondaryColor = Color3.fromRGB(245, 245, 245),
        AccentColor = Color3.fromRGB(0, 0, 0),
        TextColor = Color3.fromRGB(0, 0, 0),
        SecondaryTextColor = Color3.fromRGB(100, 100, 100),
        BorderColor = Color3.fromRGB(220, 220, 220),
        SuccessColor = Color3.fromRGB(34, 197, 94),
        ErrorColor = Color3.fromRGB(239, 68, 68),
        WarningColor = Color3.fromRGB(234, 179, 8),
        DiscordColor = Color3.fromRGB(88, 101, 242)
    },
    Ocean = {
        MainColor = Color3.fromRGB(15, 23, 42),
        SecondaryColor = Color3.fromRGB(30, 41, 59),
        AccentColor = Color3.fromRGB(56, 189, 248),
        TextColor = Color3.fromRGB(248, 250, 252),
        SecondaryTextColor = Color3.fromRGB(148, 163, 184),
        BorderColor = Color3.fromRGB(51, 65, 85),
        SuccessColor = Color3.fromRGB(74, 222, 128),
        ErrorColor = Color3.fromRGB(248, 113, 113),
        WarningColor = Color3.fromRGB(251, 191, 36),
        DiscordColor = Color3.fromRGB(88, 101, 242)
    },
    Forest = {
        MainColor = Color3.fromRGB(20, 26, 20),
        SecondaryColor = Color3.fromRGB(28, 36, 28),
        AccentColor = Color3.fromRGB(74, 222, 128),
        TextColor = Color3.fromRGB(240, 253, 244),
        SecondaryTextColor = Color3.fromRGB(134, 197, 150),
        BorderColor = Color3.fromRGB(45, 55, 45),
        SuccessColor = Color3.fromRGB(74, 222, 128),
        ErrorColor = Color3.fromRGB(248, 113, 113),
        WarningColor = Color3.fromRGB(251, 191, 36),
        DiscordColor = Color3.fromRGB(88, 101, 242)
    },
    Sunset = {
        MainColor = Color3.fromRGB(30, 20, 20),
        SecondaryColor = Color3.fromRGB(42, 28, 28),
        AccentColor = Color3.fromRGB(251, 146, 60),
        TextColor = Color3.fromRGB(255, 247, 237),
        SecondaryTextColor = Color3.fromRGB(194, 165, 150),
        BorderColor = Color3.fromRGB(68, 48, 45),
        SuccessColor = Color3.fromRGB(74, 222, 128),
        ErrorColor = Color3.fromRGB(248, 113, 113),
        WarningColor = Color3.fromRGB(251, 191, 36),
        DiscordColor = Color3.fromRGB(88, 101, 242)
    },
    Purple = {
        MainColor = Color3.fromRGB(18, 14, 28),
        SecondaryColor = Color3.fromRGB(28, 22, 42),
        AccentColor = Color3.fromRGB(168, 85, 247),
        TextColor = Color3.fromRGB(250, 245, 255),
        SecondaryTextColor = Color3.fromRGB(167, 139, 200),
        BorderColor = Color3.fromRGB(55, 45, 75),
        SuccessColor = Color3.fromRGB(74, 222, 128),
        ErrorColor = Color3.fromRGB(248, 113, 113),
        WarningColor = Color3.fromRGB(251, 191, 36),
        DiscordColor = Color3.fromRGB(88, 101, 242)
    },
    Rose = {
        MainColor = Color3.fromRGB(28, 18, 22),
        SecondaryColor = Color3.fromRGB(40, 26, 32),
        AccentColor = Color3.fromRGB(244, 114, 182),
        TextColor = Color3.fromRGB(255, 241, 245),
        SecondaryTextColor = Color3.fromRGB(190, 150, 170),
        BorderColor = Color3.fromRGB(65, 45, 55),
        SuccessColor = Color3.fromRGB(74, 222, 128),
        ErrorColor = Color3.fromRGB(248, 113, 113),
        WarningColor = Color3.fromRGB(251, 191, 36),
        DiscordColor = Color3.fromRGB(88, 101, 242)
    },
    Midnight = {
        MainColor = Color3.fromRGB(3, 7, 18),
        SecondaryColor = Color3.fromRGB(15, 23, 42),
        AccentColor = Color3.fromRGB(129, 140, 248),
        TextColor = Color3.fromRGB(226, 232, 240),
        SecondaryTextColor = Color3.fromRGB(100, 116, 139),
        BorderColor = Color3.fromRGB(30, 41, 59),
        SuccessColor = Color3.fromRGB(74, 222, 128),
        ErrorColor = Color3.fromRGB(248, 113, 113),
        WarningColor = Color3.fromRGB(251, 191, 36),
        DiscordColor = Color3.fromRGB(88, 101, 242)
    },
    Aqua = {
        MainColor = Color3.fromRGB(15, 28, 28),
        SecondaryColor = Color3.fromRGB(22, 40, 40),
        AccentColor = Color3.fromRGB(45, 212, 191),
        TextColor = Color3.fromRGB(240, 253, 250),
        SecondaryTextColor = Color3.fromRGB(130, 180, 175),
        BorderColor = Color3.fromRGB(40, 60, 58),
        SuccessColor = Color3.fromRGB(74, 222, 128),
        ErrorColor = Color3.fromRGB(248, 113, 113),
        WarningColor = Color3.fromRGB(251, 191, 36),
        DiscordColor = Color3.fromRGB(88, 101, 242)
    },
    Blood = {
        MainColor = Color3.fromRGB(25, 10, 10),
        SecondaryColor = Color3.fromRGB(38, 15, 15),
        AccentColor = Color3.fromRGB(239, 68, 68),
        TextColor = Color3.fromRGB(254, 242, 242),
        SecondaryTextColor = Color3.fromRGB(180, 130, 130),
        BorderColor = Color3.fromRGB(60, 30, 30),
        SuccessColor = Color3.fromRGB(74, 222, 128),
        ErrorColor = Color3.fromRGB(248, 113, 113),
        WarningColor = Color3.fromRGB(251, 191, 36),
        DiscordColor = Color3.fromRGB(88, 101, 242)
    },
    Gold = {
        MainColor = Color3.fromRGB(28, 25, 15),
        SecondaryColor = Color3.fromRGB(40, 36, 22),
        AccentColor = Color3.fromRGB(250, 204, 21),
        TextColor = Color3.fromRGB(254, 252, 232),
        SecondaryTextColor = Color3.fromRGB(180, 170, 130),
        BorderColor = Color3.fromRGB(65, 58, 35),
        SuccessColor = Color3.fromRGB(74, 222, 128),
        ErrorColor = Color3.fromRGB(248, 113, 113),
        WarningColor = Color3.fromRGB(251, 191, 36),
        DiscordColor = Color3.fromRGB(88, 101, 242)
    },
    Neon = {
        MainColor = Color3.fromRGB(10, 10, 15),
        SecondaryColor = Color3.fromRGB(15, 15, 22),
        AccentColor = Color3.fromRGB(0, 255, 135),
        TextColor = Color3.fromRGB(255, 255, 255),
        SecondaryTextColor = Color3.fromRGB(150, 150, 160),
        BorderColor = Color3.fromRGB(35, 35, 45),
        SuccessColor = Color3.fromRGB(0, 255, 135),
        ErrorColor = Color3.fromRGB(255, 50, 100),
        WarningColor = Color3.fromRGB(255, 200, 0),
        DiscordColor = Color3.fromRGB(88, 101, 242)
    },
    Cherry = {
        MainColor = Color3.fromRGB(30, 15, 20),
        SecondaryColor = Color3.fromRGB(45, 22, 30),
        AccentColor = Color3.fromRGB(255, 100, 130),
        TextColor = Color3.fromRGB(255, 240, 245),
        SecondaryTextColor = Color3.fromRGB(180, 140, 155),
        BorderColor = Color3.fromRGB(70, 40, 50),
        SuccessColor = Color3.fromRGB(74, 222, 128),
        ErrorColor = Color3.fromRGB(248, 113, 113),
        WarningColor = Color3.fromRGB(251, 191, 36),
        DiscordColor = Color3.fromRGB(88, 101, 242)
    },
    Cyber = {
        MainColor = Color3.fromRGB(8, 8, 12),
        SecondaryColor = Color3.fromRGB(14, 14, 20),
        AccentColor = Color3.fromRGB(0, 200, 255),
        TextColor = Color3.fromRGB(230, 245, 255),
        SecondaryTextColor = Color3.fromRGB(100, 140, 160),
        BorderColor = Color3.fromRGB(30, 40, 50),
        SuccessColor = Color3.fromRGB(0, 255, 180),
        ErrorColor = Color3.fromRGB(255, 60, 100),
        WarningColor = Color3.fromRGB(255, 180, 0),
        DiscordColor = Color3.fromRGB(88, 101, 242)
    }
}

local Config = {}
for key, value in pairs(Themes.Default) do
    Config[key] = value
end
Config.TweenSpeed = 0.15

local Fonts = {
    Regular = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
    Medium = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
    SemiBold = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
    Bold = Font.new("rbxassetid://12187365364", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
}

local Icons = {}
local iconsLoaded = false

local function LoadIcons()
    if iconsLoaded then return end
    local success, result = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/lucide/dist/Icons.lua"))()
    end)
    if success and type(result) == "table" then
        Icons = result
        iconsLoaded = true
    end
end
LoadIcons()

local function IsAssetId(str)
    if not str then return false end
    str = tostring(str)
    if string.match(str, "^rbxassetid://") then return true end
    if string.match(str, "^rbxasset://") then return true end
    if string.match(str, "^https?://") then return true end
    if tonumber(str) then return true end
    return false
end

local function GetIcon(name)
    if not name then return "" end
    
    local str = tostring(name)
    
    if IsAssetId(str) then
        if tonumber(str) then
            return "rbxassetid://" .. str
        end
        return str
    end
    
    local lower = string.lower(str)
    if Icons[lower] then return Icons[lower] end
    if Icons[str] then return Icons[str] end
    return Icons["circle"] or ""
end

local function Create(class, properties)
    local instance = Instance.new(class)
    for prop, value in pairs(properties) do
        if prop ~= "Parent" then
            pcall(function() instance[prop] = value end)
        end
    end
    if properties.Parent then
        instance.Parent = properties.Parent
    end
    return instance
end

local function Tween(instance, properties, duration)
    if not instance or not instance.Parent then return end
    duration = duration or Config.TweenSpeed
    local tween = TweenService:Create(instance, TweenInfo.new(duration, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), properties)
    tween:Play()
    return tween
end

local function AddCorner(instance, radius)
    return Create("UICorner", {
        CornerRadius = UDim.new(0, radius or 8),
        Parent = instance
    })
end

local function AddShadow(instance)
    return Create("ImageLabel", {
        Name = "Shadow",
        BackgroundTransparency = 1,
        Image = "rbxassetid://5554236805",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.6,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(23, 23, 277, 277),
        Size = UDim2.new(1, 47, 1, 47),
        Position = UDim2.new(0, -23, 0, -23),
        ZIndex = -1,
        Parent = instance
    })
end

local function MakeDraggable(frame, handle)
    handle = handle or frame
    local dragging, dragStart, startPos

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local function AddRipple(button)
    local ripple = Create("Frame", {
        Name = "Ripple",
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.85,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 0, 0, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ZIndex = 10,
        Parent = button
    })
    AddCorner(ripple, 100)
    
    local size = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2
    Tween(ripple, {Size = UDim2.new(0, size, 0, size), BackgroundTransparency = 1}, 0.35)
    
    task.delay(0.35, function()
        if ripple and ripple.Parent then
            ripple:Destroy()
        end
    end)
end

local function ParseIconSize(size, default)
    if not size then return default, default end
    
    if type(size) == "number" then
        return size, size
    end
    
    if type(size) == "table" then
        return size.X or size[1] or default, size.Y or size[2] or default
    end
    
    if typeof(size) == "Vector2" then
        return size.X, size.Y
    end
    
    if typeof(size) == "UDim2" then
        return size.X.Offset, size.Y.Offset
    end
    
    return default, default
end

local function CreateButton(parent, config)
    local button = Create("TextButton", {
        Name = config.Name,
        BackgroundColor3 = config.BackgroundColor,
        Size = UDim2.new(0, config.Width, 0, config.Height),
        Text = "",
        AutoButtonColor = false,
        ClipsDescendants = true,
        LayoutOrder = config.LayoutOrder,
        Parent = parent
    })
    AddCorner(button, 8)
    
    local icon = Create("ImageLabel", {
        Name = "Icon",
        BackgroundTransparency = 1,
        Image = GetIcon(config.Icon),
        ImageColor3 = config.IconColor,
        Size = UDim2.new(0, config.IconSize, 0, config.IconSize),
        Position = UDim2.new(0, 10, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        ScaleType = Enum.ScaleType.Fit,
        Parent = button
    })
    
    local label = Create("TextLabel", {
        Name = "Label",
        BackgroundTransparency = 1,
        Text = config.Text,
        TextColor3 = config.TextColor,
        FontFace = Fonts.Medium,
        TextSize = isMobile and 12 or 11,
        TextXAlignment = Enum.TextXAlignment.Center,
        Size = UDim2.new(1, -30, 1, 0),
        Position = UDim2.new(0, 28, 0, 0),
        Parent = button
    })
    
    return button, icon, label
end

function KeySystem:GetThemes()
    local themeList = {}
    for name in pairs(Themes) do
        table.insert(themeList, name)
    end
    table.sort(themeList)
    return themeList
end

function KeySystem:Create(options)
    options = options or {}
    
    local title = options.Title or "Key System"
    local description = options.Description or "Please enter your key to continue"
    local icon = options.Icon or "key"
    local centerIcon = options.CenterIcon or "lock"
    local iconSize = options.IconSize
    local centerIconSize = options.CenterIconSize
    local keys = options.Keys or {}
    local keyLink = options.KeyLink or ""
    local discordLink = options.DiscordLink or ""
    local savePath = options.SavePath or "KeyData.json"
    local onSuccess = options.OnSuccess or function() end
    local onFailed = options.OnFailed or function() end
    local theme = options.Theme or "Default"
    
    -- Apply theme
    if Themes[theme] then
        for key, value in pairs(Themes[theme]) do
            Config[key] = value
        end
    end
    
    -- Custom color overrides
    if options.MainColor then Config.MainColor = options.MainColor end
    if options.SecondaryColor then Config.SecondaryColor = options.SecondaryColor end
    if options.AccentColor then Config.AccentColor = options.AccentColor end
    if options.TextColor then Config.TextColor = options.TextColor end
    if options.SecondaryTextColor then Config.SecondaryTextColor = options.SecondaryTextColor end
    if options.BorderColor then Config.BorderColor = options.BorderColor end
    if options.DiscordColor then Config.DiscordColor = options.DiscordColor end
    
    local titleIconDefault = isMobile and 24 or 22
    local centerIconDefault = isMobile and 28 or 24
    
    local titleIconSizeX, titleIconSizeY = ParseIconSize(iconSize, titleIconDefault)
    local centerIconSizeX, centerIconSizeY = ParseIconSize(centerIconSize, centerIconDefault)
    
    local centerContainerSize = math.max(centerIconSizeX, centerIconSizeY) + (isMobile and 36 or 32)
    
    local existing = CoreGui:FindFirstChild("KeySystemUI")
    if existing then existing:Destroy() end
    
    local function CheckSavedKey()
        if not isfile then return false end
        local success, data = pcall(function()
            if isfile(savePath) then
                return HttpService:JSONDecode(readfile(savePath))
            end
        end)
        if success and data and data.Key then
            for _, key in ipairs(keys) do
                if data.Key == key then
                    return true
                end
            end
        end
        return false
    end
    
    local function SaveKey(key)
        if not writefile then return end
        pcall(function()
            writefile(savePath, HttpService:JSONEncode({Key = key, SavedAt = os.time()}))
        end)
    end
    
    if CheckSavedKey() then
        task.spawn(onSuccess)
        return {
            Destroy = function() end,
            SetStatus = function() end,
            SetIcon = function() end,
            SetCenterIcon = function() end,
            SetTheme = function() end
        }
    end
    
    -- Count buttons
    local hasDiscord = discordLink ~= ""
    local hasGetKey = keyLink ~= ""
    local buttonCount = 1 + (hasDiscord and 1 or 0) + (hasGetKey and 1 or 0)
    
    local buttonWidth
    if buttonCount == 1 then
        buttonWidth = isMobile and 200 or 180
    elseif buttonCount == 2 then
        buttonWidth = isMobile and 145 or 135
    else
        buttonWidth = isMobile and 100 or 95
    end
    
    local buttonHeight = isMobile and 40 or 36
    local buttonIconSize = isMobile and 16 or 14
    
    local frameWidth = isMobile and 360 or 420
    local frameHeight = isMobile and 320 or 340
    
    local ScreenGui = Create("ScreenGui", {
        Name = "KeySystemUI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true,
        Parent = CoreGui
    })
    
    local Background = Create("Frame", {
        Name = "Background",
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.3,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = ScreenGui
    })
    
    local MainFrame = Create("Frame", {
        Name = "MainFrame",
        BackgroundColor3 = Config.MainColor,
        Size = UDim2.new(0, frameWidth, 0, frameHeight),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ClipsDescendants = true,
        Parent = ScreenGui
    })
    AddCorner(MainFrame, 12)
    AddShadow(MainFrame)
    
    -- Title Bar
    local TitleBar = Create("Frame", {
        Name = "TitleBar",
        BackgroundColor3 = Config.MainColor,
        Size = UDim2.new(1, 0, 0, isMobile and 56 or 48),
        BorderSizePixel = 0,
        Parent = MainFrame
    })
    
    local Divider = Create("Frame", {
        Name = "Divider",
        BackgroundColor3 = Config.BorderColor,
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 1, -1),
        BorderSizePixel = 0,
        Parent = TitleBar
    })
    
    local TitleIcon = Create("ImageLabel", {
        Name = "Icon",
        BackgroundTransparency = 1,
        Image = GetIcon(icon),
        ImageColor3 = Config.AccentColor,
        Size = UDim2.new(0, titleIconSizeX, 0, titleIconSizeY),
        Position = UDim2.new(0, 16, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        ScaleType = Enum.ScaleType.Fit,
        Parent = TitleBar
    })
    
    local titlePosX = 16 + titleIconSizeX + 10
    
    local TitleLabel = Create("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Config.TextColor,
        FontFace = Fonts.SemiBold,
        TextSize = isMobile and 16 or 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Size = UDim2.new(1, -titlePosX - 50, 1, 0),
        Position = UDim2.new(0, titlePosX, 0, 0),
        Parent = TitleBar
    })
    
    -- Close Button
    local CloseButton = Create("TextButton", {
        Name = "Close",
        BackgroundColor3 = Config.SecondaryColor,
        Size = UDim2.new(0, isMobile and 32 or 28, 0, isMobile and 32 or 28),
        Position = UDim2.new(1, isMobile and -44 or -38, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Text = "",
        AutoButtonColor = false,
        Parent = TitleBar
    })
    AddCorner(CloseButton, 6)
    
    local CloseIcon = Create("ImageLabel", {
        BackgroundTransparency = 1,
        Image = GetIcon("x"),
        ImageColor3 = Config.SecondaryTextColor,
        Size = UDim2.new(0, isMobile and 16 or 14, 0, isMobile and 16 or 14),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ScaleType = Enum.ScaleType.Fit,
        Parent = CloseButton
    })
    
    CloseButton.MouseEnter:Connect(function()
        Tween(CloseButton, {BackgroundColor3 = Color3.fromRGB(200, 60, 60)})
        Tween(CloseIcon, {ImageColor3 = Color3.fromRGB(255, 255, 255)})
    end)
    
    CloseButton.MouseLeave:Connect(function()
        Tween(CloseButton, {BackgroundColor3 = Config.SecondaryColor})
        Tween(CloseIcon, {ImageColor3 = Config.SecondaryTextColor})
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        AddRipple(CloseButton)
        Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.2)
        task.delay(0.2, function()
            ScreenGui:Destroy()
            task.spawn(onFailed)
        end)
    end)
    
    -- Content
    local Content = Create("Frame", {
        Name = "Content",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -32, 1, isMobile and -72 or -64),
        Position = UDim2.new(0, 16, 0, isMobile and 64 or 56),
        Parent = MainFrame
    })
    
    -- Center Icon Container
    local CenterContainer = Create("Frame", {
        Name = "CenterContainer",
        BackgroundColor3 = Config.SecondaryColor,
        Size = UDim2.new(0, centerContainerSize, 0, centerContainerSize),
        Position = UDim2.new(0.5, 0, 0, 0),
        AnchorPoint = Vector2.new(0.5, 0),
        Parent = Content
    })
    AddCorner(CenterContainer, centerContainerSize / 2)
    
    local CenterIcon = Create("ImageLabel", {
        Name = "CenterIcon",
        BackgroundTransparency = 1,
        Image = GetIcon(centerIcon),
        ImageColor3 = Config.AccentColor,
        Size = UDim2.new(0, centerIconSizeX, 0, centerIconSizeY),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ScaleType = Enum.ScaleType.Fit,
        Parent = CenterContainer
    })
    
    local descPosY = centerContainerSize + 12
    
    -- Description
    local DescLabel = Create("TextLabel", {
        Name = "Description",
        BackgroundTransparency = 1,
        Text = description,
        TextColor3 = Config.SecondaryTextColor,
        FontFace = Fonts.Regular,
        TextSize = isMobile and 13 or 12,
        TextWrapped = true,
        Size = UDim2.new(1, 0, 0, 40),
        Position = UDim2.new(0, 0, 0, descPosY),
        Parent = Content
    })
    
    local inputPosY = descPosY + 48
    
    -- Input Container
    local InputContainer = Create("Frame", {
        Name = "InputContainer",
        BackgroundColor3 = Config.SecondaryColor,
        Size = UDim2.new(1, 0, 0, isMobile and 48 or 44),
        Position = UDim2.new(0, 0, 0, inputPosY),
        Parent = Content
    })
    AddCorner(InputContainer, 8)
    
    local InputIcon = Create("ImageLabel", {
        Name = "InputIcon",
        BackgroundTransparency = 1,
        Image = GetIcon("key"),
        ImageColor3 = Config.SecondaryTextColor,
        Size = UDim2.new(0, isMobile and 18 or 16, 0, isMobile and 18 or 16),
        Position = UDim2.new(0, 12, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        ScaleType = Enum.ScaleType.Fit,
        Parent = InputContainer
    })
    
    local KeyInput = Create("TextBox", {
        Name = "KeyInput",
        BackgroundTransparency = 1,
        Text = "",
        PlaceholderText = "Enter your key here...",
        PlaceholderColor3 = Config.SecondaryTextColor,
        TextColor3 = Config.TextColor,
        FontFace = Fonts.Regular,
        TextSize = isMobile and 13 or 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false,
        Size = UDim2.new(1, -48, 1, 0),
        Position = UDim2.new(0, isMobile and 38 or 36, 0, 0),
        Parent = InputContainer
    })
    
    KeyInput.Focused:Connect(function()
        Tween(InputContainer, {BackgroundColor3 = Config.BorderColor})
        Tween(InputIcon, {ImageColor3 = Config.AccentColor})
    end)
    
    KeyInput.FocusLost:Connect(function()
        Tween(InputContainer, {BackgroundColor3 = Config.SecondaryColor})
        Tween(InputIcon, {ImageColor3 = Config.SecondaryTextColor})
    end)
    
    local statusPosY = inputPosY + (isMobile and 56 or 52)
    
    -- Status Label
    local StatusLabel = Create("TextLabel", {
        Name = "Status",
        BackgroundTransparency = 1,
        Text = "",
        TextColor3 = Config.SecondaryTextColor,
        FontFace = Fonts.Regular,
        TextSize = isMobile and 11 or 10,
        Size = UDim2.new(1, 0, 0, 16),
        Position = UDim2.new(0, 0, 0, statusPosY),
        Parent = Content
    })
    
    -- Buttons Container
    local ButtonsContainer = Create("Frame", {
        Name = "Buttons",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, buttonHeight),
        Position = UDim2.new(0, 0, 1, -buttonHeight),
        Parent = Content
    })
    
    Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = ButtonsContainer
    })
    
    local layoutOrder = 0
    local allButtons = {}
    
    -- Discord Button
    if hasDiscord then
        local DiscordButton = Create("TextButton", {
            Name = "Discord",
            BackgroundColor3 = Config.DiscordColor,
            Size = UDim2.new(0, buttonWidth, 0, buttonHeight),
            Text = "",
            AutoButtonColor = false,
            ClipsDescendants = true,
            LayoutOrder = layoutOrder,
            Parent = ButtonsContainer
        })
        AddCorner(DiscordButton, 8)
        layoutOrder = layoutOrder + 1
        
        Create("ImageLabel", {
            Name = "Icon",
            BackgroundTransparency = 1,
            Image = GetIcon("message-circle"),
            ImageColor3 = Color3.fromRGB(255, 255, 255),
            Size = UDim2.new(0, buttonIconSize, 0, buttonIconSize),
            Position = UDim2.new(0, 10, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            ScaleType = Enum.ScaleType.Fit,
            Parent = DiscordButton
        })
        
        Create("TextLabel", {
            Name = "Label",
            BackgroundTransparency = 1,
            Text = buttonCount >= 3 and "Discord" or "Join Discord",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            FontFace = Fonts.Medium,
            TextSize = isMobile and 12 or 11,
            TextXAlignment = Enum.TextXAlignment.Center,
            Size = UDim2.new(1, -28, 1, 0),
            Position = UDim2.new(0, 26, 0, 0),
            Parent = DiscordButton
        })
        
        DiscordButton.MouseEnter:Connect(function()
            Tween(DiscordButton, {BackgroundColor3 = Color3.fromRGB(108, 121, 255)})
        end)
        
        DiscordButton.MouseLeave:Connect(function()
            Tween(DiscordButton, {BackgroundColor3 = Config.DiscordColor})
        end)
        
        DiscordButton.MouseButton1Click:Connect(function()
            AddRipple(DiscordButton)
            if setclipboard then
                setclipboard(discordLink)
                StatusLabel.Text = "Discord link copied!"
                StatusLabel.TextColor3 = Config.DiscordColor
                task.delay(2, function()
                    if StatusLabel and StatusLabel.Parent then
                        StatusLabel.Text = ""
                    end
                end)
            end
        end)
        
        table.insert(allButtons, {Button = DiscordButton, Type = "Discord"})
    end
    
    -- Get Key Button
    if hasGetKey then
        local GetKeyButton = Create("TextButton", {
            Name = "GetKey",
            BackgroundColor3 = Config.SecondaryColor,
            Size = UDim2.new(0, buttonWidth, 0, buttonHeight),
            Text = "",
            AutoButtonColor = false,
            ClipsDescendants = true,
            LayoutOrder = layoutOrder,
            Parent = ButtonsContainer
        })
        AddCorner(GetKeyButton, 8)
        layoutOrder = layoutOrder + 1
        
        local GetKeyIconEl = Create("ImageLabel", {
            Name = "Icon",
            BackgroundTransparency = 1,
            Image = GetIcon("external-link"),
            ImageColor3 = Config.TextColor,
            Size = UDim2.new(0, buttonIconSize, 0, buttonIconSize),
            Position = UDim2.new(0, 10, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            ScaleType = Enum.ScaleType.Fit,
            Parent = GetKeyButton
        })
        
        local GetKeyLabelEl = Create("TextLabel", {
            Name = "Label",
            BackgroundTransparency = 1,
            Text = buttonCount >= 3 and "Get Key" or "Get Key",
            TextColor3 = Config.TextColor,
            FontFace = Fonts.Medium,
            TextSize = isMobile and 12 or 11,
            TextXAlignment = Enum.TextXAlignment.Center,
            Size = UDim2.new(1, -28, 1, 0),
            Position = UDim2.new(0, 26, 0, 0),
            Parent = GetKeyButton
        })
        
        GetKeyButton.MouseEnter:Connect(function()
            Tween(GetKeyButton, {BackgroundColor3 = Config.BorderColor})
        end)
        
        GetKeyButton.MouseLeave:Connect(function()
            Tween(GetKeyButton, {BackgroundColor3 = Config.SecondaryColor})
        end)
        
        GetKeyButton.MouseButton1Click:Connect(function()
            AddRipple(GetKeyButton)
            if setclipboard then
                setclipboard(keyLink)
                StatusLabel.Text = "Key link copied!"
                StatusLabel.TextColor3 = Config.SuccessColor
                task.delay(2, function()
                    if StatusLabel and StatusLabel.Parent then
                        StatusLabel.Text = ""
                    end
                end)
            end
        end)
        
        table.insert(allButtons, {Button = GetKeyButton, Type = "GetKey", Icon = GetKeyIconEl, Label = GetKeyLabelEl})
    end
    
    -- Verify Button
    local VerifyButton = Create("TextButton", {
        Name = "Verify",
        BackgroundColor3 = Config.AccentColor,
        Size = UDim2.new(0, buttonWidth, 0, buttonHeight),
        Text = "",
        AutoButtonColor = false,
        ClipsDescendants = true,
        LayoutOrder = layoutOrder,
        Parent = ButtonsContainer
    })
    AddCorner(VerifyButton, 8)
    
    local VerifyIcon = Create("ImageLabel", {
        Name = "Icon",
        BackgroundTransparency = 1,
        Image = GetIcon("check"),
        ImageColor3 = Config.MainColor,
        Size = UDim2.new(0, buttonIconSize, 0, buttonIconSize),
        Position = UDim2.new(0, 10, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        ScaleType = Enum.ScaleType.Fit,
        Parent = VerifyButton
    })
    
    local VerifyLabel = Create("TextLabel", {
        Name = "Label",
        BackgroundTransparency = 1,
        Text = "Verify",
        TextColor3 = Config.MainColor,
        FontFace = Fonts.Medium,
        TextSize = isMobile and 12 or 11,
        TextXAlignment = Enum.TextXAlignment.Center,
        Size = UDim2.new(1, -28, 1, 0),
        Position = UDim2.new(0, 26, 0, 0),
        Parent = VerifyButton
    })
    
    VerifyButton.MouseEnter:Connect(function()
        Tween(VerifyButton, {BackgroundColor3 = Config.TextColor})
    end)
    
    VerifyButton.MouseLeave:Connect(function()
        Tween(VerifyButton, {BackgroundColor3 = Config.AccentColor})
    end)
    
    local function VerifyKey()
        local inputKey = KeyInput.Text
        
        if inputKey == "" then
            StatusLabel.Text = "Please enter a key!"
            StatusLabel.TextColor3 = Config.WarningColor
            
            local originalPos = InputContainer.Position
            for i = 1, 4 do
                Tween(InputContainer, {Position = originalPos + UDim2.new(0, i % 2 == 0 and 6 or -6, 0, 0)}, 0.04)
                task.wait(0.04)
            end
            Tween(InputContainer, {Position = originalPos}, 0.04)
            return
        end
        
        local valid = false
        for _, key in ipairs(keys) do
            if inputKey == key then
                valid = true
                break
            end
        end
        
        if valid then
            StatusLabel.Text = "Key verified successfully!"
            StatusLabel.TextColor3 = Config.SuccessColor
            CenterIcon.Image = GetIcon("unlock")
            Tween(CenterIcon, {ImageColor3 = Config.SuccessColor})
            Tween(CenterContainer, {BackgroundColor3 = Color3.fromRGB(30, 60, 30)})
            Tween(InputIcon, {ImageColor3 = Config.SuccessColor})
            Tween(InputContainer, {BackgroundColor3 = Color3.fromRGB(30, 60, 30)})
            
            SaveKey(inputKey)
            
            task.delay(1.2, function()
                Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.25)
                Tween(Background, {BackgroundTransparency = 1}, 0.25)
                task.delay(0.25, function()
                    ScreenGui:Destroy()
                    task.spawn(onSuccess)
                end)
            end)
        else
            StatusLabel.Text = "Invalid key! Please try again."
            StatusLabel.TextColor3 = Config.ErrorColor
            
            Tween(InputContainer, {BackgroundColor3 = Color3.fromRGB(60, 30, 30)}, 0.1)
            Tween(InputIcon, {ImageColor3 = Config.ErrorColor}, 0.1)
            task.delay(0.5, function()
                Tween(InputContainer, {BackgroundColor3 = Config.SecondaryColor}, 0.2)
                Tween(InputIcon, {ImageColor3 = Config.SecondaryTextColor}, 0.2)
            end)
            
            local originalPos = InputContainer.Position
            for i = 1, 6 do
                Tween(InputContainer, {Position = originalPos + UDim2.new(0, i % 2 == 0 and 8 or -8, 0, 0)}, 0.04)
                task.wait(0.04)
            end
            Tween(InputContainer, {Position = originalPos}, 0.04)
        end
    end
    
    VerifyButton.MouseButton1Click:Connect(function()
        AddRipple(VerifyButton)
        VerifyKey()
    end)
    
    KeyInput.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            VerifyKey()
        end
    end)
    
    MakeDraggable(MainFrame, TitleBar)
    
    -- Entrance animation
    local targetSize = UDim2.new(0, frameWidth, 0, frameHeight)
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    Background.BackgroundTransparency = 1
    
    Tween(Background, {BackgroundTransparency = 0.3}, 0.2)
    Tween(MainFrame, {Size = targetSize}, 0.3)
    
    -- Theme change function
    local function ApplyTheme(themeName)
        if not Themes[themeName] then return end
        
        for key, value in pairs(Themes[themeName]) do
            Config[key] = value
        end
        
        MainFrame.BackgroundColor3 = Config.MainColor
        TitleBar.BackgroundColor3 = Config.MainColor
        Divider.BackgroundColor3 = Config.BorderColor
        TitleIcon.ImageColor3 = Config.AccentColor
        TitleLabel.TextColor3 = Config.TextColor
        CloseButton.BackgroundColor3 = Config.SecondaryColor
        CloseIcon.ImageColor3 = Config.SecondaryTextColor
        CenterContainer.BackgroundColor3 = Config.SecondaryColor
        CenterIcon.ImageColor3 = Config.AccentColor
        DescLabel.TextColor3 = Config.SecondaryTextColor
        InputContainer.BackgroundColor3 = Config.SecondaryColor
        InputIcon.ImageColor3 = Config.SecondaryTextColor
        KeyInput.TextColor3 = Config.TextColor
        KeyInput.PlaceholderColor3 = Config.SecondaryTextColor
        StatusLabel.TextColor3 = Config.SecondaryTextColor
        VerifyButton.BackgroundColor3 = Config.AccentColor
        VerifyIcon.ImageColor3 = Config.MainColor
        VerifyLabel.TextColor3 = Config.MainColor
        
        for _, btnData in ipairs(allButtons) do
            if btnData.Type == "GetKey" then
                btnData.Button.BackgroundColor3 = Config.SecondaryColor
                if btnData.Icon then btnData.Icon.ImageColor3 = Config.TextColor end
                if btnData.Label then btnData.Label.TextColor3 = Config.TextColor end
            end
        end
    end
    
    return {
        Destroy = function()
            if ScreenGui and ScreenGui.Parent then
                ScreenGui:Destroy()
            end
        end,
        SetStatus = function(text, color)
            StatusLabel.Text = text
            StatusLabel.TextColor3 = color or Config.SecondaryTextColor
        end,
        SetIcon = function(newIcon, newSize)
            TitleIcon.Image = GetIcon(newIcon)
            if newSize then
                local sizeX, sizeY = ParseIconSize(newSize, titleIconDefault)
                TitleIcon.Size = UDim2.new(0, sizeX, 0, sizeY)
            end
        end,
        SetCenterIcon = function(newIcon, newSize)
            CenterIcon.Image = GetIcon(newIcon)
            if newSize then
                local sizeX, sizeY = ParseIconSize(newSize, centerIconDefault)
                CenterIcon.Size = UDim2.new(0, sizeX, 0, sizeY)
            end
        end,
        SetTheme = function(themeName)
            ApplyTheme(themeName)
        end,
        GetThemes = function()
            return KeySystem:GetThemes()
        end
    }
end

return KeySystem
