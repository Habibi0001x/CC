local cloneref = cloneref or function(a) return a end
local CoreGui = cloneref(game:GetService("CoreGui"))
local TweenService = cloneref(game:GetService("TweenService"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local HttpService = cloneref(game:GetService("HttpService"))

local KeySystem = {}

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
    local s, r = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/lucide/dist/Icons.lua"))()
    end)
    if s and type(r) == "table" then
        Icons = r
        iconsLoaded = true
    end
end
LoadIcons()

local function GetIcon(name)
    if not name then return "" end
    local str = tostring(name)
    if string.match(str, "^rbxassetid://") or string.match(str, "^rbxasset://") or string.match(str, "^https?://") then
        return str
    end
    if tonumber(str) then
        return "rbxassetid://" .. str
    end
    local lower = string.lower(str)
    return Icons[lower] or Icons[str] or ""
end

local function Create(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props) do
        if k ~= "Parent" then
            pcall(function() inst[k] = v end)
        end
    end
    if props.Parent then inst.Parent = props.Parent end
    return inst
end

local function Tween(inst, props, dur)
    if not inst or not inst.Parent then return end
    local t = TweenService:Create(inst, TweenInfo.new(dur or 0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props)
    t:Play()
    return t
end

local function AddCorner(inst, rad)
    return Create("UICorner", {CornerRadius = UDim.new(0, rad or 8), Parent = inst})
end

local function AddShadow(inst)
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
        Parent = inst
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
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
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

local function AddRipple(btn)
    local ripple = Create("Frame", {
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.85,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 0, 0, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ZIndex = 10,
        Parent = btn
    })
    AddCorner(ripple, 100)
    local size = math.max(btn.AbsoluteSize.X, btn.AbsoluteSize.Y) * 2
    Tween(ripple, {Size = UDim2.new(0, size, 0, size), BackgroundTransparency = 1}, 0.35)
    task.delay(0.35, function()
        if ripple and ripple.Parent then ripple:Destroy() end
    end)
end

function KeySystem:GetThemes()
    local list = {}
    for name in pairs(Themes) do
        table.insert(list, name)
    end
    table.sort(list)
    return list
end

function KeySystem:Create(options)
    options = options or {}
    
    local title = options.Title or "Key System"
    local description = options.Description or "Please enter your key to continue"
    local icon = options.Icon or "key"
    local centerIcon = options.CenterIcon or "lock"
    local keys = options.Keys or {}
    local keyLink = options.KeyLink or ""
    local discordLink = options.DiscordLink or ""
    local savePath = options.SavePath or "KeyData.json"
    local onSuccess = options.OnSuccess or function() end
    local onFailed = options.OnFailed or function() end
    local themeName = options.Theme or "Default"
    
    -- Build config from theme
    local Config = {}
    local baseTheme = Themes[themeName] or Themes.Default
    for k, v in pairs(baseTheme) do
        Config[k] = v
    end
    
    -- Apply custom overrides
    if options.MainColor then Config.MainColor = options.MainColor end
    if options.SecondaryColor then Config.SecondaryColor = options.SecondaryColor end
    if options.AccentColor then Config.AccentColor = options.AccentColor end
    if options.TextColor then Config.TextColor = options.TextColor end
    if options.SecondaryTextColor then Config.SecondaryTextColor = options.SecondaryTextColor end
    if options.BorderColor then Config.BorderColor = options.BorderColor end
    if options.DiscordColor then Config.DiscordColor = options.DiscordColor end
    
    -- Remove existing
    local existing = CoreGui:FindFirstChild("KeySystemUI")
    if existing then existing:Destroy() end
    
    -- Check saved key
    local function CheckSavedKey()
        if not isfile then return false end
        local s, data = pcall(function()
            if isfile(savePath) then
                return HttpService:JSONDecode(readfile(savePath))
            end
        end)
        if s and data and data.Key then
            for _, key in ipairs(keys) do
                if data.Key == key then return true end
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
        return {}
    end
    
    -- Sizes
    local frameW = isMobile and 360 or 420
    local frameH = isMobile and 320 or 340
    local titleBarH = isMobile and 56 or 48
    local btnH = isMobile and 38 or 34
    local iconS = isMobile and 16 or 14
    
    -- Count buttons
    local hasDiscord = discordLink ~= ""
    local hasGetKey = keyLink ~= ""
    local btnCount = 1 + (hasDiscord and 1 or 0) + (hasGetKey and 1 or 0)
    
    local btnW
    if btnCount == 1 then btnW = isMobile and 180 or 160
    elseif btnCount == 2 then btnW = isMobile and 140 or 130
    else btnW = isMobile and 100 or 92 end
    
    -- UI
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
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = ScreenGui
    })
    
    local MainFrame = Create("Frame", {
        Name = "MainFrame",
        BackgroundColor3 = Config.MainColor,
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ClipsDescendants = true,
        Parent = ScreenGui
    })
    AddCorner(MainFrame, 12)
    AddShadow(MainFrame)
    
    -- TitleBar
    local TitleBar = Create("Frame", {
        Name = "TitleBar",
        BackgroundColor3 = Config.MainColor,
        Size = UDim2.new(1, 0, 0, titleBarH),
        BorderSizePixel = 0,
        Parent = MainFrame
    })
    
    Create("Frame", {
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
        Size = UDim2.new(0, isMobile and 24 or 22, 0, isMobile and 24 or 22),
        Position = UDim2.new(0, 16, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        ScaleType = Enum.ScaleType.Fit,
        Parent = TitleBar
    })
    
    Create("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Config.TextColor,
        FontFace = Fonts.SemiBold,
        TextSize = isMobile and 16 or 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Size = UDim2.new(1, -100, 1, 0),
        Position = UDim2.new(0, isMobile and 50 or 46, 0, 0),
        Parent = TitleBar
    })
    
    local CloseBtn = Create("TextButton", {
        Name = "Close",
        BackgroundColor3 = Config.SecondaryColor,
        Size = UDim2.new(0, isMobile and 32 or 28, 0, isMobile and 32 or 28),
        Position = UDim2.new(1, isMobile and -44 or -38, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Text = "",
        AutoButtonColor = false,
        Parent = TitleBar
    })
    AddCorner(CloseBtn, 6)
    
    local CloseIcon = Create("ImageLabel", {
        BackgroundTransparency = 1,
        Image = GetIcon("x"),
        ImageColor3 = Config.SecondaryTextColor,
        Size = UDim2.new(0, isMobile and 16 or 14, 0, isMobile and 16 or 14),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Parent = CloseBtn
    })
    
    CloseBtn.MouseEnter:Connect(function()
        Tween(CloseBtn, {BackgroundColor3 = Color3.fromRGB(200, 60, 60)})
        Tween(CloseIcon, {ImageColor3 = Color3.fromRGB(255, 255, 255)})
    end)
    CloseBtn.MouseLeave:Connect(function()
        Tween(CloseBtn, {BackgroundColor3 = Config.SecondaryColor})
        Tween(CloseIcon, {ImageColor3 = Config.SecondaryTextColor})
    end)
    CloseBtn.MouseButton1Click:Connect(function()
        AddRipple(CloseBtn)
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
        Size = UDim2.new(1, -32, 1, -titleBarH - 16),
        Position = UDim2.new(0, 16, 0, titleBarH + 8),
        Parent = MainFrame
    })
    
    -- Center Icon
    local centerSize = isMobile and 60 or 56
    local CenterContainer = Create("Frame", {
        Name = "CenterContainer",
        BackgroundColor3 = Config.SecondaryColor,
        Size = UDim2.new(0, centerSize, 0, centerSize),
        Position = UDim2.new(0.5, 0, 0, 0),
        AnchorPoint = Vector2.new(0.5, 0),
        Parent = Content
    })
    AddCorner(CenterContainer, centerSize / 2)
    
    local CenterIcon = Create("ImageLabel", {
        Name = "CenterIcon",
        BackgroundTransparency = 1,
        Image = GetIcon(centerIcon),
        ImageColor3 = Config.AccentColor,
        Size = UDim2.new(0, isMobile and 28 or 24, 0, isMobile and 28 or 24),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ScaleType = Enum.ScaleType.Fit,
        Parent = CenterContainer
    })
    
    -- Description
    Create("TextLabel", {
        Name = "Description",
        BackgroundTransparency = 1,
        Text = description,
        TextColor3 = Config.SecondaryTextColor,
        FontFace = Fonts.Regular,
        TextSize = isMobile and 13 or 12,
        TextWrapped = true,
        Size = UDim2.new(1, 0, 0, 36),
        Position = UDim2.new(0, 0, 0, centerSize + 12),
        Parent = Content
    })
    
    -- Input
    local inputY = centerSize + 52
    local InputContainer = Create("Frame", {
        Name = "InputContainer",
        BackgroundColor3 = Config.SecondaryColor,
        Size = UDim2.new(1, 0, 0, isMobile and 46 or 42),
        Position = UDim2.new(0, 0, 0, inputY),
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
        Size = UDim2.new(1, -46, 1, 0),
        Position = UDim2.new(0, 36, 0, 0),
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
    
    -- Status
    local statusY = inputY + (isMobile and 52 or 48)
    local StatusLabel = Create("TextLabel", {
        Name = "Status",
        BackgroundTransparency = 1,
        Text = "",
        TextColor3 = Config.SecondaryTextColor,
        FontFace = Fonts.Regular,
        TextSize = isMobile and 11 or 10,
        Size = UDim2.new(1, 0, 0, 16),
        Position = UDim2.new(0, 0, 0, statusY),
        Parent = Content
    })
    
    -- Buttons
    local ButtonsContainer = Create("Frame", {
        Name = "Buttons",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, btnH),
        Position = UDim2.new(0, 0, 1, -btnH),
        Parent = Content
    })
    
    -- Manually position buttons instead of UIListLayout
    local totalWidth = btnW * btnCount + 8 * (btnCount - 1)
    local startX = (ButtonsContainer.AbsoluteSize.X - totalWidth) / 2
    local currentX = 0
    
    local function CreateBtn(name, bgColor, iconName, iconColor, labelText, labelColor, order)
        local xPos = (frameW - 32 - totalWidth) / 2 + order * (btnW + 8)
        
        local btn = Create("TextButton", {
            Name = name,
            BackgroundColor3 = bgColor,
            Size = UDim2.new(0, btnW, 0, btnH),
            Position = UDim2.new(0, xPos, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            Text = "",
            AutoButtonColor = false,
            ClipsDescendants = true,
            Parent = ButtonsContainer
        })
        AddCorner(btn, 8)
        
        Create("ImageLabel", {
            Name = "Icon",
            BackgroundTransparency = 1,
            Image = GetIcon(iconName),
            ImageColor3 = iconColor,
            Size = UDim2.new(0, iconS, 0, iconS),
            Position = UDim2.new(0, 10, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            Parent = btn
        })
        
        Create("TextLabel", {
            Name = "Label",
            BackgroundTransparency = 1,
            Text = labelText,
            TextColor3 = labelColor,
            FontFace = Fonts.Medium,
            TextSize = isMobile and 12 or 11,
            Size = UDim2.new(1, -28, 1, 0),
            Position = UDim2.new(0, 26, 0, 0),
            Parent = btn
        })
        
        return btn
    end
    
    local order = 0
    
    -- Discord Button
    if hasDiscord then
        local DiscordBtn = CreateBtn("Discord", Config.DiscordColor, "message-circle", Color3.new(1,1,1), btnCount >= 3 and "Discord" or "Join Discord", Color3.new(1,1,1), order)
        order = order + 1
        
        DiscordBtn.MouseEnter:Connect(function()
            Tween(DiscordBtn, {BackgroundColor3 = Color3.fromRGB(108, 121, 255)})
        end)
        DiscordBtn.MouseLeave:Connect(function()
            Tween(DiscordBtn, {BackgroundColor3 = Config.DiscordColor})
        end)
        DiscordBtn.MouseButton1Click:Connect(function()
            AddRipple(DiscordBtn)
            if setclipboard then
                setclipboard(discordLink)
                StatusLabel.Text = "Discord link copied!"
                StatusLabel.TextColor3 = Config.DiscordColor
            end
        end)
    end
    
    -- Get Key Button
    if hasGetKey then
        local GetKeyBtn = CreateBtn("GetKey", Config.SecondaryColor, "external-link", Config.TextColor, "Get Key", Config.TextColor, order)
        order = order + 1
        
        GetKeyBtn.MouseEnter:Connect(function()
            Tween(GetKeyBtn, {BackgroundColor3 = Config.BorderColor})
        end)
        GetKeyBtn.MouseLeave:Connect(function()
            Tween(GetKeyBtn, {BackgroundColor3 = Config.SecondaryColor})
        end)
        GetKeyBtn.MouseButton1Click:Connect(function()
            AddRipple(GetKeyBtn)
            if setclipboard then
                setclipboard(keyLink)
                StatusLabel.Text = "Key link copied!"
                StatusLabel.TextColor3 = Config.SuccessColor
            end
        end)
    end
    
    -- Verify Button
    local VerifyBtn = CreateBtn("Verify", Config.AccentColor, "check", Config.MainColor, "Verify", Config.MainColor, order)
    
    VerifyBtn.MouseEnter:Connect(function()
        Tween(VerifyBtn, {BackgroundColor3 = Config.TextColor})
    end)
    VerifyBtn.MouseLeave:Connect(function()
        Tween(VerifyBtn, {BackgroundColor3 = Config.AccentColor})
    end)
    
    local function VerifyKey()
        local inputKey = KeyInput.Text
        
        if inputKey == "" then
            StatusLabel.Text = "Please enter a key!"
            StatusLabel.TextColor3 = Config.WarningColor
            local orig = InputContainer.Position
            for i = 1, 4 do
                Tween(InputContainer, {Position = orig + UDim2.new(0, i % 2 == 0 and 6 or -6, 0, 0)}, 0.04)
                task.wait(0.04)
            end
            Tween(InputContainer, {Position = orig}, 0.04)
            return
        end
        
        local valid = false
        for _, key in ipairs(keys) do
            if inputKey == key then valid = true break end
        end
        
        if valid then
            StatusLabel.Text = "Key verified!"
            StatusLabel.TextColor3 = Config.SuccessColor
            CenterIcon.Image = GetIcon("unlock")
            Tween(CenterIcon, {ImageColor3 = Config.SuccessColor})
            Tween(CenterContainer, {BackgroundColor3 = Color3.fromRGB(30, 60, 30)})
            Tween(InputContainer, {BackgroundColor3 = Color3.fromRGB(30, 60, 30)})
            Tween(InputIcon, {ImageColor3 = Config.SuccessColor})
            SaveKey(inputKey)
            task.delay(1, function()
                Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.2)
                Tween(Background, {BackgroundTransparency = 1}, 0.2)
                task.delay(0.2, function()
                    ScreenGui:Destroy()
                    task.spawn(onSuccess)
                end)
            end)
        else
            StatusLabel.Text = "Invalid key!"
            StatusLabel.TextColor3 = Config.ErrorColor
            Tween(InputContainer, {BackgroundColor3 = Color3.fromRGB(60, 30, 30)}, 0.1)
            Tween(InputIcon, {ImageColor3 = Config.ErrorColor}, 0.1)
            local orig = InputContainer.Position
            for i = 1, 6 do
                Tween(InputContainer, {Position = orig + UDim2.new(0, i % 2 == 0 and 8 or -8, 0, 0)}, 0.04)
                task.wait(0.04)
            end
            Tween(InputContainer, {Position = orig}, 0.04)
            task.delay(0.5, function()
                Tween(InputContainer, {BackgroundColor3 = Config.SecondaryColor}, 0.2)
                Tween(InputIcon, {ImageColor3 = Config.SecondaryTextColor}, 0.2)
            end)
        end
    end
    
    VerifyBtn.MouseButton1Click:Connect(function()
        AddRipple(VerifyBtn)
        VerifyKey()
    end)
    
    KeyInput.FocusLost:Connect(function(enter)
        if enter then VerifyKey() end
    end)
    
    MakeDraggable(MainFrame, TitleBar)
    
    -- Animate in
    Tween(Background, {BackgroundTransparency = 0.3}, 0.2)
    Tween(MainFrame, {Size = UDim2.new(0, frameW, 0, frameH)}, 0.3)
    
    return {
        Destroy = function()
            if ScreenGui and ScreenGui.Parent then ScreenGui:Destroy() end
        end,
        SetStatus = function(text, color)
            StatusLabel.Text = text
            StatusLabel.TextColor3 = color or Config.SecondaryTextColor
        end,
        SetIcon = function(newIcon)
            TitleIcon.Image = GetIcon(newIcon)
        end,
        SetCenterIcon = function(newIcon)
            CenterIcon.Image = GetIcon(newIcon)
        end
    }
end

return KeySystem
