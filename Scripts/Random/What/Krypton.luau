local cloneref = cloneref or function(a) return a end
local Players = cloneref(game:GetService("Players"))
local CoreGui = cloneref(game:GetService("CoreGui"))
local TweenService = cloneref(game:GetService("TweenService"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local RunService = cloneref(game:GetService("RunService"))
local HttpService = cloneref(game:GetService("HttpService"))

local Library = {}
Library.__index = Library

local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled

if not getgenv().sizeFix then 
    getgenv().sizeFix = true 
    local oldNewIndex
    oldNewIndex = hookmetamethod(game, '__newindex', function(self, idx, val)
        if not checkcaller() then 
            return oldNewIndex(self, idx, val)
        end 

        if idx == 'TextSize' then 
            if self.Name ~= 'Title' and self.Name ~= 'Description' and not self:GetFullName():match('TabScroll') then 
                return oldNewIndex(self, idx, val * 1.25)
            end 
        end 

        return oldNewIndex(self, idx, val)
    end) 
end 

local Themes = {
    Default = {
        MainColor = Color3.fromRGB(0, 0, 0),
        SecondaryColor = Color3.fromRGB(10, 10, 10),
        AccentColor = Color3.fromRGB(255, 255, 255),
        TextColor = Color3.fromRGB(255, 255, 255),
        SecondaryTextColor = Color3.fromRGB(160, 160, 160),
        BorderColor = Color3.fromRGB(40, 40, 40),
        ToggleOnColor = Color3.fromRGB(255, 255, 255),
        ToggleOffColor = Color3.fromRGB(60, 60, 60),
        LockedColor = Color3.fromRGB(30, 30, 30),
        LockedTextColor = Color3.fromRGB(80, 80, 80)
    },
    Dark = {
        MainColor = Color3.fromRGB(12, 12, 12),
        SecondaryColor = Color3.fromRGB(18, 18, 18),
        AccentColor = Color3.fromRGB(99, 102, 241),
        TextColor = Color3.fromRGB(250, 250, 250),
        SecondaryTextColor = Color3.fromRGB(140, 140, 140),
        BorderColor = Color3.fromRGB(38, 38, 38),
        ToggleOnColor = Color3.fromRGB(99, 102, 241),
        ToggleOffColor = Color3.fromRGB(55, 55, 55),
        LockedColor = Color3.fromRGB(25, 25, 25),
        LockedTextColor = Color3.fromRGB(70, 70, 70)
    },
    Light = {
        MainColor = Color3.fromRGB(255, 255, 255),
        SecondaryColor = Color3.fromRGB(250, 250, 250),
        AccentColor = Color3.fromRGB(0, 0, 0),
        TextColor = Color3.fromRGB(0, 0, 0),
        SecondaryTextColor = Color3.fromRGB(100, 100, 100),
        BorderColor = Color3.fromRGB(230, 230, 230),
        ToggleOnColor = Color3.fromRGB(0, 0, 0),
        ToggleOffColor = Color3.fromRGB(200, 200, 200),
        LockedColor = Color3.fromRGB(245, 245, 245),
        LockedTextColor = Color3.fromRGB(180, 180, 180)
    },
    Ocean = {
        MainColor = Color3.fromRGB(15, 23, 42),
        SecondaryColor = Color3.fromRGB(30, 41, 59),
        AccentColor = Color3.fromRGB(56, 189, 248),
        TextColor = Color3.fromRGB(248, 250, 252),
        SecondaryTextColor = Color3.fromRGB(148, 163, 184),
        BorderColor = Color3.fromRGB(51, 65, 85),
        ToggleOnColor = Color3.fromRGB(56, 189, 248),
        ToggleOffColor = Color3.fromRGB(71, 85, 105),
        LockedColor = Color3.fromRGB(30, 41, 59),
        LockedTextColor = Color3.fromRGB(100, 116, 139)
    },
    Forest = {
        MainColor = Color3.fromRGB(20, 26, 20),
        SecondaryColor = Color3.fromRGB(28, 36, 28),
        AccentColor = Color3.fromRGB(74, 222, 128),
        TextColor = Color3.fromRGB(240, 253, 244),
        SecondaryTextColor = Color3.fromRGB(134, 197, 150),
        BorderColor = Color3.fromRGB(45, 55, 45),
        ToggleOnColor = Color3.fromRGB(74, 222, 128),
        ToggleOffColor = Color3.fromRGB(55, 65, 55),
        LockedColor = Color3.fromRGB(30, 38, 30),
        LockedTextColor = Color3.fromRGB(80, 100, 80)
    },
    Sunset = {
        MainColor = Color3.fromRGB(30, 20, 20),
        SecondaryColor = Color3.fromRGB(42, 28, 28),
        AccentColor = Color3.fromRGB(251, 146, 60),
        TextColor = Color3.fromRGB(255, 247, 237),
        SecondaryTextColor = Color3.fromRGB(194, 165, 150),
        BorderColor = Color3.fromRGB(68, 48, 45),
        ToggleOnColor = Color3.fromRGB(251, 146, 60),
        ToggleOffColor = Color3.fromRGB(75, 55, 50),
        LockedColor = Color3.fromRGB(38, 28, 26),
        LockedTextColor = Color3.fromRGB(120, 90, 80)
    },
    Purple = {
        MainColor = Color3.fromRGB(18, 14, 28),
        SecondaryColor = Color3.fromRGB(28, 22, 42),
        AccentColor = Color3.fromRGB(168, 85, 247),
        TextColor = Color3.fromRGB(250, 245, 255),
        SecondaryTextColor = Color3.fromRGB(167, 139, 200),
        BorderColor = Color3.fromRGB(55, 45, 75),
        ToggleOnColor = Color3.fromRGB(168, 85, 247),
        ToggleOffColor = Color3.fromRGB(65, 55, 85),
        LockedColor = Color3.fromRGB(30, 24, 45),
        LockedTextColor = Color3.fromRGB(100, 80, 130)
    },
    Rose = {
        MainColor = Color3.fromRGB(28, 18, 22),
        SecondaryColor = Color3.fromRGB(40, 26, 32),
        AccentColor = Color3.fromRGB(244, 114, 182),
        TextColor = Color3.fromRGB(255, 241, 245),
        SecondaryTextColor = Color3.fromRGB(190, 150, 170),
        BorderColor = Color3.fromRGB(65, 45, 55),
        ToggleOnColor = Color3.fromRGB(244, 114, 182),
        ToggleOffColor = Color3.fromRGB(70, 50, 60),
        LockedColor = Color3.fromRGB(35, 25, 30),
        LockedTextColor = Color3.fromRGB(110, 85, 95)
    },
    Midnight = {
        MainColor = Color3.fromRGB(3, 7, 18),
        SecondaryColor = Color3.fromRGB(15, 23, 42),
        AccentColor = Color3.fromRGB(129, 140, 248),
        TextColor = Color3.fromRGB(226, 232, 240),
        SecondaryTextColor = Color3.fromRGB(100, 116, 139),
        BorderColor = Color3.fromRGB(30, 41, 59),
        ToggleOnColor = Color3.fromRGB(129, 140, 248),
        ToggleOffColor = Color3.fromRGB(51, 65, 85),
        LockedColor = Color3.fromRGB(15, 23, 42),
        LockedTextColor = Color3.fromRGB(71, 85, 105)
    },
    Aqua = {
        MainColor = Color3.fromRGB(15, 28, 28),
        SecondaryColor = Color3.fromRGB(22, 40, 40),
        AccentColor = Color3.fromRGB(45, 212, 191),
        TextColor = Color3.fromRGB(240, 253, 250),
        SecondaryTextColor = Color3.fromRGB(130, 180, 175),
        BorderColor = Color3.fromRGB(40, 60, 58),
        ToggleOnColor = Color3.fromRGB(45, 212, 191),
        ToggleOffColor = Color3.fromRGB(50, 70, 68),
        LockedColor = Color3.fromRGB(22, 38, 38),
        LockedTextColor = Color3.fromRGB(80, 115, 110)
    },
    Blood = {
        MainColor = Color3.fromRGB(25, 10, 10),
        SecondaryColor = Color3.fromRGB(38, 15, 15),
        AccentColor = Color3.fromRGB(239, 68, 68),
        TextColor = Color3.fromRGB(254, 242, 242),
        SecondaryTextColor = Color3.fromRGB(180, 130, 130),
        BorderColor = Color3.fromRGB(60, 30, 30),
        ToggleOnColor = Color3.fromRGB(239, 68, 68),
        ToggleOffColor = Color3.fromRGB(70, 40, 40),
        LockedColor = Color3.fromRGB(35, 18, 18),
        LockedTextColor = Color3.fromRGB(120, 70, 70)
    },
    Gold = {
        MainColor = Color3.fromRGB(28, 25, 15),
        SecondaryColor = Color3.fromRGB(40, 36, 22),
        AccentColor = Color3.fromRGB(250, 204, 21),
        TextColor = Color3.fromRGB(254, 252, 232),
        SecondaryTextColor = Color3.fromRGB(180, 170, 130),
        BorderColor = Color3.fromRGB(65, 58, 35),
        ToggleOnColor = Color3.fromRGB(250, 204, 21),
        ToggleOffColor = Color3.fromRGB(75, 68, 45),
        LockedColor = Color3.fromRGB(38, 34, 20),
        LockedTextColor = Color3.fromRGB(130, 120, 80)
    }
}

local Fonts = {
    Inter = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
    InterMedium = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
    InterSemiBold = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
    InterBold = Font.new("rbxassetid://12187365364", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
    Gotham = Enum.Font.Gotham,
    GothamMedium = Enum.Font.GothamMedium,
    GothamBold = Enum.Font.GothamBold,
    SourceSans = Enum.Font.SourceSans,
    SourceSansBold = Enum.Font.SourceSansBold,
    Roboto = Enum.Font.Roboto,
    RobotoMono = Enum.Font.RobotoMono
}

local Config = {}
for k, v in pairs(Themes.Default) do
    Config[k] = v
end
Config.Font = Fonts.Inter
Config.BoldFont = Fonts.InterSemiBold
Config.TweenSpeed = 0.15
Config.Transparent = false
Config.TransparencyValue = 0.3
Config.CurrentTheme = "Default"
Config.CurrentFont = "Inter"

local Icons = {}
local IconsLoaded = false

local function LoadIcons()
    if IconsLoaded then return end
    local success, result = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/lucide/dist/Icons.lua"))()
    end)
    if success and type(result) == "table" then
        Icons = result
        IconsLoaded = true
    end
end

LoadIcons()

local function GetIcon(name)
    if not name then return "" end
    local lowerName = string.lower(tostring(name))
    if Icons[lowerName] then
        return Icons[lowerName]
    end
    if Icons[name] then
        return Icons[name]
    end
    return Icons["circle"] or ""
end

local function Create(className, properties)
    local instance = Instance.new(className)
    for prop, value in pairs(properties) do
        if prop ~= "Parent" then
            pcall(function()
                instance[prop] = value
            end)
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

local function MakeResizable(frame, handle, minSize, maxSize)
    minSize = minSize or Vector2.new(400, 300)
    maxSize = maxSize or Vector2.new(800, 600)
    local resizing = false
    local resizeStart, startSize
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            resizing = true
            resizeStart = input.Position
            startSize = Vector2.new(frame.AbsoluteSize.X, frame.AbsoluteSize.Y)
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    resizing = false
                end
            end)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - resizeStart
            local newWidth = math.clamp(startSize.X + delta.X, minSize.X, maxSize.X)
            local newHeight = math.clamp(startSize.Y + delta.Y, minSize.Y, maxSize.Y)
            frame.Size = UDim2.new(0, newWidth, 0, newHeight)
        end
    end)
end

local function CreateRipple(button)
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

local ConfigSystem = {}
ConfigSystem.Folder = "UILibraryConfigs"
ConfigSystem.AutoloadFile = "autoload.txt"
ConfigSystem.Flags = {}
ConfigSystem.ConfigName = ""

function ConfigSystem:Init(configName)
    self.ConfigName = configName or "default"
    if not isfolder then return end
    if not isfolder(self.Folder) then
        makefolder(self.Folder)
    end
    local path = self.Folder .. "/" .. tostring(game.PlaceId)
    if not isfolder(path) then
        makefolder(path)
    end
end

function ConfigSystem:GetConfigPath(name)
    return self.Folder .. "/" .. tostring(game.PlaceId) .. "/" .. name .. ".json"
end

function ConfigSystem:GetAutoloadPath()
    return self.Folder .. "/" .. tostring(game.PlaceId) .. "/" .. self.AutoloadFile
end

function ConfigSystem:ListConfigs()
    if not isfolder or not listfiles then return {} end
    local configs = {}
    local path = self.Folder .. "/" .. tostring(game.PlaceId)
    if isfolder(path) then
        for _, file in ipairs(listfiles(path)) do
            local name = file:match("([^/\\]+)%.json$")
            if name then
                table.insert(configs, name)
            end
        end
    end
    return configs
end

function ConfigSystem:Save(name)
    if not writefile then return false end
    local data = {}
    for flag, info in pairs(self.Flags) do
        if info.Get then
            local value = info.Get()
            if typeof(value) == "Color3" then
                data[flag] = {Type = "Color3", R = value.R, G = value.G, B = value.B}
            elseif typeof(value) == "EnumItem" then
                data[flag] = {Type = "EnumItem", EnumType = tostring(value.EnumType), Name = value.Name}
            else
                data[flag] = {Type = typeof(value), Value = value}
            end
        end
    end
    local success, encoded = pcall(function()
        return HttpService:JSONEncode(data)
    end)
    if success then
        writefile(self:GetConfigPath(name), encoded)
        return true
    end
    return false
end

function ConfigSystem:Load(name)
    if not readfile or not isfile then return false end
    local path = self:GetConfigPath(name)
    if not isfile(path) then return false end
    local success, data = pcall(function()
        return HttpService:JSONDecode(readfile(path))
    end)
    if success and data then
        for flag, info in pairs(data) do
            if self.Flags[flag] and self.Flags[flag].Set then
                local value
                if info.Type == "Color3" then
                    value = Color3.new(info.R, info.G, info.B)
                elseif info.Type == "EnumItem" then
                    pcall(function()
                        value = Enum[info.EnumType][info.Name]
                    end)
                else
                    value = info.Value
                end
                if value ~= nil then
                    pcall(function()
                        self.Flags[flag].Set(value)
                    end)
                end
            end
        end
        return true
    end
    return false
end

function ConfigSystem:Delete(name)
    if not delfile or not isfile then return false end
    local path = self:GetConfigPath(name)
    if isfile(path) then
        delfile(path)
        return true
    end
    return false
end

function ConfigSystem:SetAutoload(name)
    if not writefile then return false end
    writefile(self:GetAutoloadPath(), name)
    return true
end

function ConfigSystem:GetAutoload()
    if not readfile or not isfile then return nil end
    local path = self:GetAutoloadPath()
    if isfile(path) then
        return readfile(path)
    end
    return nil
end

function ConfigSystem:ClearAutoload()
    if not delfile or not isfile then return false end
    local path = self:GetAutoloadPath()
    if isfile(path) then
        delfile(path)
        return true
    end
    return false
end

function ConfigSystem:LoadAutoload()
    local autoload = self:GetAutoload()
    if autoload then
        return self:Load(autoload)
    end
    return false
end

function ConfigSystem:RegisterFlag(flag, getter, setter)
    self.Flags[flag] = {Get = getter, Set = setter}
end

function Library:CreateWindow(options)
    options = options or {}
    local Title = options.Title or "UI Library"
    local Description = options.Description or ""
    local WindowIcon = options.Icon or "zap"
    local Transparent = options.Transparent or false
    local TransparencyValue = options.TransparencyValue or 0.3
    local Size = options.Size or (IsMobile and UDim2.new(0, 420, 0, 350) or UDim2.new(0, 620, 0, 440))
    local MinSize = options.MinSize or Vector2.new(400, 300)
    local MaxSize = options.MaxSize or Vector2.new(900, 700)
    local ThemeName = options.Theme or "Default"
    local ConfigName = options.ConfigName or "default"
    
    ConfigSystem:Init(ConfigName)
    
    if Themes[ThemeName] then
        for key, value in pairs(Themes[ThemeName]) do
            Config[key] = value
        end
        Config.CurrentTheme = ThemeName
    end
    
    Config.Transparent = Transparent
    Config.TransparencyValue = TransparencyValue
    
    local existingGui = CoreGui:FindFirstChild("AdvancedUILibrary")
    if existingGui then
        existingGui:Destroy()
    end
    
    local ThemeCallbacks = {}
    
    local function OnThemeChange(callback)
        table.insert(ThemeCallbacks, callback)
    end
    
    local function FireThemeChange()
        for _, callback in ipairs(ThemeCallbacks) do
            pcall(callback)
        end
    end
    
    local ScreenGui = Create("ScreenGui", {
        Name = "AdvancedUILibrary",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true,
        Parent = CoreGui
    })
    
    local MainFrame = Create("Frame", {
        Name = "MainFrame",
        BackgroundColor3 = Config.MainColor,
        BackgroundTransparency = Transparent and TransparencyValue or 0,
        Size = Size,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ClipsDescendants = true,
        Parent = ScreenGui
    })
    AddCorner(MainFrame, 12)
    AddShadow(MainFrame)
    
    OnThemeChange(function()
        Tween(MainFrame, {BackgroundColor3 = Config.MainColor})
    end)
    
    local TitleBar = Create("Frame", {
        Name = "TitleBar",
        BackgroundColor3 = Config.MainColor,
        BackgroundTransparency = Transparent and TransparencyValue or 0,
        Size = UDim2.new(1, 0, 0, IsMobile and 56 or 48),
        BorderSizePixel = 0,
        Parent = MainFrame
    })
    
    OnThemeChange(function()
        Tween(TitleBar, {BackgroundColor3 = Config.MainColor})
    end)
    
    local TitleDivider = Create("Frame", {
        Name = "Divider",
        BackgroundColor3 = Config.BorderColor,
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 1, -1),
        BorderSizePixel = 0,
        Parent = TitleBar
    })
    
    OnThemeChange(function()
        Tween(TitleDivider, {BackgroundColor3 = Config.BorderColor})
    end)
    
    local TitleIcon = Create("ImageLabel", {
        Name = "Icon",
        BackgroundTransparency = 1,
        Image = GetIcon(WindowIcon),
        ImageColor3 = Config.TextColor,
        Size = UDim2.new(0, IsMobile and 22 or 20, 0, IsMobile and 22 or 20),
        Position = UDim2.new(0, 16, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Parent = TitleBar
    })
    
    OnThemeChange(function()
        Tween(TitleIcon, {ImageColor3 = Config.TextColor})
    end)
    
    local TitleLabel = Create("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Text = Title,
        TextColor3 = Config.TextColor,
        FontFace = Config.BoldFont,
        TextSize = IsMobile and 16 or 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Size = UDim2.new(1, -120, 0, 18),
        Position = UDim2.new(0, IsMobile and 46 or 44, 0, Description ~= "" and 10 or 0),
        Parent = TitleBar
    })
    
    if Description == "" then
        TitleLabel.Position = UDim2.new(0, IsMobile and 46 or 44, 0.5, 0)
        TitleLabel.AnchorPoint = Vector2.new(0, 0.5)
    end
    
    OnThemeChange(function()
        Tween(TitleLabel, {TextColor3 = Config.TextColor})
    end)
    
    local DescriptionLabel
    if Description ~= "" then
        DescriptionLabel = Create("TextLabel", {
            Name = "Description",
            BackgroundTransparency = 1,
            Text = Description,
            TextColor3 = Config.SecondaryTextColor,
            FontFace = Config.Font,
            TextSize = IsMobile and 12 or 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            Size = UDim2.new(1, -120, 0, 14),
            Position = UDim2.new(0, IsMobile and 46 or 44, 0, 28),
            Parent = TitleBar
        })
        
        OnThemeChange(function()
            Tween(DescriptionLabel, {TextColor3 = Config.SecondaryTextColor})
        end)
    end
    
    local Controls = Create("Frame", {
        Name = "Controls",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, IsMobile and 80 or 66, 0, IsMobile and 32 or 28),
        Position = UDim2.new(1, IsMobile and -92 or -78, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Parent = TitleBar
    })
    
    Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        Padding = UDim.new(0, 6),
        Parent = Controls
    })
    
    local MinimizeButton = Create("TextButton", {
        Name = "Minimize",
        BackgroundColor3 = Config.SecondaryColor,
        Size = UDim2.new(0, IsMobile and 32 or 28, 0, IsMobile and 32 or 28),
        Text = "",
        AutoButtonColor = false,
        Parent = Controls
    })
    AddCorner(MinimizeButton, 6)
    
    OnThemeChange(function()
        MinimizeButton.BackgroundColor3 = Config.SecondaryColor
    end)
    
    local MinimizeIcon = Create("ImageLabel", {
        BackgroundTransparency = 1,
        Image = GetIcon("minus"),
        ImageColor3 = Config.SecondaryTextColor,
        Size = UDim2.new(0, IsMobile and 16 or 14, 0, IsMobile and 16 or 14),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Parent = MinimizeButton
    })
    
    OnThemeChange(function()
        Tween(MinimizeIcon, {ImageColor3 = Config.SecondaryTextColor})
    end)
    
    local CloseButton = Create("TextButton", {
        Name = "Close",
        BackgroundColor3 = Config.SecondaryColor,
        Size = UDim2.new(0, IsMobile and 32 or 28, 0, IsMobile and 32 or 28),
        Text = "",
        AutoButtonColor = false,
        Parent = Controls
    })
    AddCorner(CloseButton, 6)
    
    OnThemeChange(function()
        CloseButton.BackgroundColor3 = Config.SecondaryColor
    end)
    
    local CloseIcon = Create("ImageLabel", {
        BackgroundTransparency = 1,
        Image = GetIcon("x"),
        ImageColor3 = Config.SecondaryTextColor,
        Size = UDim2.new(0, IsMobile and 16 or 14, 0, IsMobile and 16 or 14),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Parent = CloseButton
    })
    
    OnThemeChange(function()
        Tween(CloseIcon, {ImageColor3 = Config.SecondaryTextColor})
    end)
    
    local TabContainerWidth = IsMobile and 140 or 160
    
    local TabContainer = Create("Frame", {
        Name = "TabContainer",
        BackgroundColor3 = Config.MainColor,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, TabContainerWidth, 1, IsMobile and -56 or -48),
        Position = UDim2.new(0, 0, 0, IsMobile and 56 or 48),
        Parent = MainFrame
    })
    
    local TabDivider = Create("Frame", {
        Name = "Divider",
        BackgroundColor3 = Config.BorderColor,
        Size = UDim2.new(0, 1, 1, 0),
        Position = UDim2.new(1, 0, 0, 0),
        BorderSizePixel = 0,
        Parent = TabContainer
    })
    
    OnThemeChange(function()
        Tween(TabDivider, {BackgroundColor3 = Config.BorderColor})
    end)
    
    local TabScroll = Create("ScrollingFrame", {
        Name = "TabScroll",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -8, 1, -8),
        Position = UDim2.new(0, 4, 0, 4),
        ScrollBarThickness = 0,
        ScrollBarTransparency = 1,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = TabContainer
    })
    
    Create("UIListLayout", {
        Padding = UDim.new(0, 2),
        Parent = TabScroll
    })
    
    local ContentContainer = Create("Frame", {
        Name = "ContentContainer",
        BackgroundColor3 = Config.MainColor,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -(TabContainerWidth + 1), 1, IsMobile and -56 or -48),
        Position = UDim2.new(0, TabContainerWidth + 1, 0, IsMobile and 56 or 48),
        Parent = MainFrame
    })
    
    local ResizeHandle = Create("TextButton", {
        Name = "ResizeHandle",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(1, -16, 1, -16),
        Text = "",
        ZIndex = 10,
        Parent = MainFrame
    })
    
    local ResizeIcon = Create("ImageLabel", {
        BackgroundTransparency = 1,
        Image = GetIcon("grip-vertical"),
        ImageColor3 = Config.BorderColor,
        Size = UDim2.new(0, 10, 0, 10),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Rotation = -45,
        ZIndex = 11,
        Parent = ResizeHandle
    })
    
    OnThemeChange(function()
        Tween(ResizeIcon, {ImageColor3 = Config.BorderColor})
    end)
    
    MakeDraggable(MainFrame, TitleBar)
    MakeResizable(MainFrame, ResizeHandle, MinSize, MaxSize)
    
    local isMinimized = false
    local originalSize = MainFrame.Size
    
    MinimizeButton.MouseButton1Click:Connect(function()
        CreateRipple(MinimizeButton)
        isMinimized = not isMinimized
        if isMinimized then
            originalSize = MainFrame.Size
            Tween(MainFrame, {Size = UDim2.new(0, originalSize.X.Offset, 0, IsMobile and 56 or 48)})
            TabContainer.Visible = false
            ContentContainer.Visible = false
            ResizeHandle.Visible = false
            TitleDivider.Visible = false
            MinimizeIcon.Image = GetIcon("maximize-2")
        else
            Tween(MainFrame, {Size = originalSize})
            task.delay(0.12, function()
                TabContainer.Visible = true
                ContentContainer.Visible = true
                ResizeHandle.Visible = true
                TitleDivider.Visible = true
            end)
            MinimizeIcon.Image = GetIcon("minus")
        end
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        CreateRipple(CloseButton)
        
        -- Create confirmation dialog
        local ConfirmDialog = Create("Frame", {
            Name = "ConfirmDialog",
            BackgroundColor3 = Config.MainColor,
            Size = UDim2.new(0, 300, 0, 150),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            ZIndex = 1000,
            Parent = ScreenGui
        })
        AddCorner(ConfirmDialog, 12)
        AddShadow(ConfirmDialog)
        
        local DialogTitle = Create("TextLabel", {
            Name = "Title",
            BackgroundTransparency = 1,
            Text = "Are you sure?",
            TextColor3 = Config.TextColor,
            FontFace = Config.BoldFont,
            TextSize = 18,
            Size = UDim2.new(1, -20, 0, 40),
            Position = UDim2.new(0, 10, 0, 10),
            Parent = ConfirmDialog
        })
        
        local DialogMessage = Create("TextLabel", {
            Name = "Message",
            BackgroundTransparency = 1,
            Text = "Do you want to close Krypton?",
            TextColor3 = Config.SecondaryTextColor,
            FontFace = Config.Font,
            TextSize = 14,
            Size = UDim2.new(1, -20, 0, 30),
            Position = UDim2.new(0, 10, 0, 50),
            Parent = ConfirmDialog
        })
        
        local ButtonContainer = Create("Frame", {
            Name = "Buttons",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -20, 0, 40),
            Position = UDim2.new(0, 10, 1, -50),
            Parent = ConfirmDialog
        })
        
        local YesButton = Create("TextButton", {
            Name = "Yes",
            BackgroundColor3 = Color3.fromRGB(200, 60, 60),
            Size = UDim2.new(0.48, 0, 1, 0),
            Position = UDim2.new(0, 0, 0, 0),
            Text = "Yes",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            FontFace = Config.BoldFont,
            TextSize = 14,
            AutoButtonColor = false,
            Parent = ButtonContainer
        })
        AddCorner(YesButton, 6)
        
        local NoButton = Create("TextButton", {
            Name = "No",
            BackgroundColor3 = Config.SecondaryColor,
            Size = UDim2.new(0.48, 0, 1, 0),
            Position = UDim2.new(0.52, 0, 0, 0),
            Text = "No",
            TextColor3 = Config.TextColor,
            FontFace = Config.BoldFont,
            TextSize = 14,
            AutoButtonColor = false,
            Parent = ButtonContainer
        })
        AddCorner(NoButton, 6)
        
        YesButton.MouseButton1Click:Connect(function()
            ConfirmDialog:Destroy()
            Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.2)
            task.delay(0.2, function()
                ScreenGui:Destroy()
            end)
        end)
        
        NoButton.MouseButton1Click:Connect(function()
            Tween(ConfirmDialog, {Size = UDim2.new(0, 0, 0, 0)}, 0.15)
            task.delay(0.15, function()
                ConfirmDialog:Destroy()
            end)
        end)
        
        YesButton.MouseEnter:Connect(function()
            Tween(YesButton, {BackgroundColor3 = Color3.fromRGB(220, 80, 80)})
        end)
        
        YesButton.MouseLeave:Connect(function()
            Tween(YesButton, {BackgroundColor3 = Color3.fromRGB(200, 60, 60)})
        end)
        
        NoButton.MouseEnter:Connect(function()
            Tween(NoButton, {BackgroundColor3 = Config.BorderColor})
        end)
        
        NoButton.MouseLeave:Connect(function()
            Tween(NoButton, {BackgroundColor3 = Config.SecondaryColor})
        end)
    end)

    
    MinimizeButton.MouseEnter:Connect(function()
        Tween(MinimizeButton, {BackgroundColor3 = Config.BorderColor})
    end)
    
    MinimizeButton.MouseLeave:Connect(function()
        Tween(MinimizeButton, {BackgroundColor3 = Config.SecondaryColor})
    end)
    
    CloseButton.MouseEnter:Connect(function()
        Tween(CloseButton, {BackgroundColor3 = Color3.fromRGB(200, 60, 60)})
        Tween(CloseIcon, {ImageColor3 = Color3.fromRGB(255, 255, 255)})
    end)
    
    CloseButton.MouseLeave:Connect(function()
        Tween(CloseButton, {BackgroundColor3 = Config.SecondaryColor})
        Tween(CloseIcon, {ImageColor3 = Config.SecondaryTextColor})
    end)
    
    local MobileToggle
    if IsMobile then
        MobileToggle = Create("TextButton", {
            Name = "MobileToggle",
            BackgroundColor3 = Config.AccentColor,
            Size = UDim2.new(0, 50, 0, 50),
            Position = UDim2.new(0, 10, 0.5, -25),
            Text = "",
            ZIndex = 100,
            Parent = ScreenGui
        })
        AddCorner(MobileToggle, 25)
        AddShadow(MobileToggle)
        
        OnThemeChange(function()
            Tween(MobileToggle, {BackgroundColor3 = Config.AccentColor})
        end)
        
        local MobileIcon = Create("ImageLabel", {
            BackgroundTransparency = 1,
            Image = GetIcon("menu"),
            ImageColor3 = Config.MainColor,
            Size = UDim2.new(0, 24, 0, 24),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            ZIndex = 101,
            Parent = MobileToggle
        })
        
        OnThemeChange(function()
            Tween(MobileIcon, {ImageColor3 = Config.MainColor})
        end)
        
        MobileToggle.MouseButton1Click:Connect(function()
            MainFrame.Visible = not MainFrame.Visible
            MobileIcon.Image = MainFrame.Visible and GetIcon("x") or GetIcon("menu")
        end)
        
        MakeDraggable(MobileToggle, MobileToggle)
    end
    
    local Window = {
        Tabs = {},
        ActiveTab = nil,
        ScreenGui = ScreenGui,
        MainFrame = MainFrame,
        IsMobile = IsMobile,
        ConfigSystem = ConfigSystem,
        CurrentTheme = ThemeName,
        OnThemeChange = OnThemeChange,
        FireThemeChange = FireThemeChange
    }
    
    function Window:SetTheme(themeName)
        if not Themes[themeName] then return end
        
        for key, value in pairs(Themes[themeName]) do
            Config[key] = value
        end
        Config.CurrentTheme = themeName
        self.CurrentTheme = themeName
        
        FireThemeChange()
        
        for tabName, tabInfo in pairs(self.Tabs) do
            if self.ActiveTab == tabName then
                Tween(tabInfo.Button, {BackgroundColor3 = Config.SecondaryColor})
                Tween(tabInfo.Icon, {ImageColor3 = Config.TextColor})
                Tween(tabInfo.Label, {TextColor3 = Config.TextColor})
            else
                Tween(tabInfo.Button, {BackgroundTransparency = 1})
                Tween(tabInfo.Icon, {ImageColor3 = Config.SecondaryTextColor})
                Tween(tabInfo.Label, {TextColor3 = Config.SecondaryTextColor})
            end
        end
    end
    
    function Window:SetFont(fontName)
        if not Fonts[fontName] then return end
        Config.Font = Fonts[fontName]
        Config.CurrentFont = fontName
        
        if fontName == "Inter" then
            Config.BoldFont = Fonts.InterSemiBold
        elseif fontName == "Gotham" then
            Config.BoldFont = Fonts.GothamBold
        elseif fontName == "GothamMedium" then
            Config.BoldFont = Fonts.GothamBold
        elseif fontName == "SourceSans" then
            Config.BoldFont = Fonts.SourceSansBold
        else
            Config.BoldFont = Fonts[fontName]
        end
    end
    
    function Window:GetThemes()
        local themeList = {}
        for name in pairs(Themes) do
            table.insert(themeList, name)
        end
        table.sort(themeList)
        return themeList
    end
    
    function Window:GetFonts()
        return {"Inter", "Gotham", "GothamMedium", "SourceSans", "Roboto", "RobotoMono"}
    end
    
    function Window:SetTransparency(enabled, value)
        Config.Transparent = enabled
        Config.TransparencyValue = value or Config.TransparencyValue
        local transparency = enabled and Config.TransparencyValue or 0
        MainFrame.BackgroundTransparency = transparency
        TitleBar.BackgroundTransparency = transparency
    end
    
    function Window:CreateTab(options)
        options = options or {}
        local TabName = options.Name or "Tab"
        local TabIconName = options.Icon or "circle"
        
        local TabButton = Create("TextButton", {
            Name = TabName,
            BackgroundColor3 = Config.SecondaryColor,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -8, 0, IsMobile and 40 or 36),
            Text = "",
            AutoButtonColor = false,
            Parent = TabScroll
        })
        AddCorner(TabButton, 8)
        
        local TabIconLabel = Create("ImageLabel", {
            BackgroundTransparency = 1,
            Image = GetIcon(TabIconName),
            ImageColor3 = Config.SecondaryTextColor,
            Size = UDim2.new(0, IsMobile and 18 or 16, 0, IsMobile and 18 or 16),
            Position = UDim2.new(0, 12, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            Parent = TabButton
        })
        
        local TabLabel = Create("TextLabel", {
            BackgroundTransparency = 1,
            Text = TabName,
            TextColor3 = Config.SecondaryTextColor,
            FontFace = Config.Font,
            TextSize = IsMobile and 13 or 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            Size = UDim2.new(1, -42, 1, 0),
            Position = UDim2.new(0, IsMobile and 38 or 36, 0, 0),
            Parent = TabButton
        })
        
        local TabPage = Create("ScrollingFrame", {
            Name = TabName .. "Page",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -16, 1, -16),
            Position = UDim2.new(0, 8, 0, 8),
            ScrollBarThickness = 0,
            ScrollBarImageColor3 = Config.BorderColor,
            ScrollBarImageTransparency = 0.5,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible = false,
            Parent = ContentContainer
        })
        
        OnThemeChange(function()
            Tween(TabPage, {ScrollBarImageColor3 = Config.BorderColor})
        end)
        
        Create("UIListLayout", {
            Padding = UDim.new(0, 8),
            Parent = TabPage
        })
        
        local function SelectTab()
            for _, tabInfo in pairs(Window.Tabs) do
                Tween(tabInfo.Button, {BackgroundTransparency = 1})
                Tween(tabInfo.Icon, {ImageColor3 = Config.SecondaryTextColor})
                Tween(tabInfo.Label, {TextColor3 = Config.SecondaryTextColor})
                tabInfo.Page.Visible = false
            end
            Tween(TabButton, {BackgroundTransparency = 0, BackgroundColor3 = Config.SecondaryColor})
            Tween(TabIconLabel, {ImageColor3 = Config.TextColor})
            Tween(TabLabel, {TextColor3 = Config.TextColor})
            TabPage.Visible = true
            Window.ActiveTab = TabName
        end
        
        TabButton.MouseButton1Click:Connect(function()
            SelectTab()
        end)
        
        TabButton.MouseEnter:Connect(function()
            if Window.ActiveTab ~= TabName then
                Tween(TabButton, {BackgroundTransparency = 0.5, BackgroundColor3 = Config.SecondaryColor})
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if Window.ActiveTab ~= TabName then
                Tween(TabButton, {BackgroundTransparency = 1})
            end
        end)
        
        local Tab = {
            Button = TabButton,
            Icon = TabIconLabel,
            Label = TabLabel,
            Page = TabPage
        }
        
        Window.Tabs[TabName] = Tab
        
        if not Window.ActiveTab then
            SelectTab()
        end
        
        function Tab:CreateSection(options)
            options = options or {}
            local SectionName = options.Name or "Section"
            local SectionDescription = options.Description or ""
            local hasDesc = SectionDescription ~= ""
            local HeaderHeight = hasDesc and (IsMobile and 44 or 40) or (IsMobile and 32 or 28)
            
            local SectionFrame = Create("Frame", {
                Name = SectionName,
                BackgroundColor3 = Config.SecondaryColor,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                Parent = TabPage
            })
            AddCorner(SectionFrame, 10)
            
            OnThemeChange(function()
                Tween(SectionFrame, {BackgroundColor3 = Config.SecondaryColor})
            end)
            
            local SectionTitle = Create("TextLabel", {
                BackgroundTransparency = 1,
                Text = SectionName,
                TextColor3 = Config.TextColor,
                FontFace = Config.BoldFont,
                TextSize = IsMobile and 13 or 12,
                TextXAlignment = Enum.TextXAlignment.Left,
                Position = UDim2.new(0, 14, 0, hasDesc and 10 or 8),
                Size = UDim2.new(1, -28, 0, 16),
                Parent = SectionFrame
            })
            
            OnThemeChange(function()
                Tween(SectionTitle, {TextColor3 = Config.TextColor})
            end)
            
            if hasDesc then
                local SectionDesc = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Text = SectionDescription,
                    TextColor3 = Config.SecondaryTextColor,
                    FontFace = Config.Font,
                    TextSize = IsMobile and 11 or 10,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2.new(0, 14, 0, 26),
                    Size = UDim2.new(1, -28, 0, 12),
                    Parent = SectionFrame
                })
                
                OnThemeChange(function()
                    Tween(SectionDesc, {TextColor3 = Config.SecondaryTextColor})
                end)
            end
            
            local SectionContent = Create("Frame", {
                Name = "Content",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -20, 0, 0),
                Position = UDim2.new(0, 10, 0, HeaderHeight),
                AutomaticSize = Enum.AutomaticSize.Y,
                Parent = SectionFrame
            })
            
            Create("UIListLayout", {
                Padding = UDim.new(0, 1),
                Parent = SectionContent
            })
            
            Create("UIPadding", {
                PaddingBottom = UDim.new(0, 10),
                Parent = SectionContent
            })
            
            local Section = {}
            
            function Section:CreateLabel(options)
                options = options or {}
                local Text = options.Text or "Label"
                local LabelDescription = options.Description or ""
                local Icon = options.Icon
                local hasLabelDesc = LabelDescription ~= ""
                local height = hasLabelDesc and (IsMobile and 36 or 32) or (IsMobile and 24 or 20)
                
                local LabelFrame = Create("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, height),
                    Parent = SectionContent
                })
                
                local textOffset = 0
                if Icon then
                    local IconLabel = Create("ImageLabel", {
                        BackgroundTransparency = 1,
                        Image = GetIcon(Icon),
                        ImageColor3 = Config.SecondaryTextColor,
                        Size = UDim2.new(0, IsMobile and 16 or 14, 0, IsMobile and 16 or 14),
                        Position = UDim2.new(0, 4, 0, hasLabelDesc and 3 or 3),
                        Parent = LabelFrame
                    })
                    
                    OnThemeChange(function()
                        Tween(IconLabel, {ImageColor3 = Config.SecondaryTextColor})
                    end)
                    
                    textOffset = IsMobile and 24 or 22
                end
                
                local MainLabel = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Text = Text,
                    TextColor3 = Config.TextColor,
                    FontFace = Config.Font,
                    TextSize = IsMobile and 12 or 11,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2.new(0, 4 + textOffset, 0, 0),
                    Size = UDim2.new(1, -8 - textOffset, 0, IsMobile and 18 or 16),
                    Parent = LabelFrame
                })
                
                OnThemeChange(function()
                    Tween(MainLabel, {TextColor3 = Config.TextColor})
                end)
                
                if hasLabelDesc then
                    local DescLabel = Create("TextLabel", {
                        BackgroundTransparency = 1,
                        Text = LabelDescription,
                        TextColor3 = Config.SecondaryTextColor,
                        FontFace = Config.Font,
                        TextSize = IsMobile and 10 or 9,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Position = UDim2.new(0, 4 + textOffset, 0, IsMobile and 18 or 16),
                        Size = UDim2.new(1, -8 - textOffset, 0, IsMobile and 14 or 12),
                        Parent = LabelFrame
                    })
                    
                    OnThemeChange(function()
                        Tween(DescLabel, {TextColor3 = Config.SecondaryTextColor})
                    end)
                end
                
                return {
                    SetText = function(_, text)
                        MainLabel.Text = text
                    end
                }
            end
            
            function Section:CreateButton(options)
                options = options or {}
                local Text = options.Text or "Button"
                local ButtonDescription = options.Description or ""
                local Icon = options.Icon
                local Callback = options.Callback or function() end
                local Locked = options.Locked or false
                local hasDesc = ButtonDescription ~= ""
                local height = hasDesc and (IsMobile and 52 or 46) or (IsMobile and 38 or 34)
                
                local Button = Create("TextButton", {
                    BackgroundColor3 = Config.MainColor,
                    Size = UDim2.new(1, 0, 0, height),
                    Text = "",
                    AutoButtonColor = false,
                    ClipsDescendants = true,
                    Parent = SectionContent
                })
                AddCorner(Button, 8)
                
                OnThemeChange(function()
                    if not Locked then
                        Tween(Button, {BackgroundColor3 = Config.MainColor})
                    end
                end)
                
                local textOffset = 0
                local IconLabel
                local OriginalIcon = Icon
                
                if Icon then
                    IconLabel = Create("ImageLabel", {
                        BackgroundTransparency = 1,
                        Image = GetIcon(Locked and "lock" or Icon),
                        ImageColor3 = Locked and Config.LockedTextColor or Config.TextColor,
                        Size = UDim2.new(0, IsMobile and 18 or 16, 0, IsMobile and 18 or 16),
                        Position = UDim2.new(0, 12, 0.5, 0),
                        AnchorPoint = Vector2.new(0, 0.5),
                        Parent = Button
                    })
                    
                    OnThemeChange(function()
                        if not Locked then
                            Tween(IconLabel, {ImageColor3 = Config.TextColor})
                        end
                    end)
                    
                    textOffset = IsMobile and 24 or 22
                end
                
                local ButtonText = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Text = Text,
                    TextColor3 = Locked and Config.LockedTextColor or Config.TextColor,
                    FontFace = Config.Font,
                    TextSize = IsMobile and 12 or 11,
                    TextXAlignment = Icon and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center,
                    Position = UDim2.new(0, 12 + textOffset, 0, hasDesc and 10 or 0),
                    Size = UDim2.new(1, -24 - textOffset, 0, hasDesc and 16 or height),
                    Parent = Button
                })
                
                OnThemeChange(function()
                    if not Locked then
                        Tween(ButtonText, {TextColor3 = Config.TextColor})
                    end
                end)
                
                local DescLabel
                if hasDesc then
                    DescLabel = Create("TextLabel", {
                        BackgroundTransparency = 1,
                        Text = ButtonDescription,
                        TextColor3 = Locked and Config.LockedTextColor or Config.SecondaryTextColor,
                        FontFace = Config.Font,
                        TextSize = IsMobile and 10 or 9,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Position = UDim2.new(0, 12 + textOffset, 0, IsMobile and 26 or 24),
                        Size = UDim2.new(1, -24 - textOffset, 0, 14),
                        Parent = Button
                    })
                    
                    OnThemeChange(function()
                        if not Locked then
                            Tween(DescLabel, {TextColor3 = Config.SecondaryTextColor})
                        end
                    end)
                end
                
                local isLocked = Locked
                
                Button.MouseButton1Click:Connect(function()
                    if not isLocked then
                        CreateRipple(Button)
                        Callback()
                    end
                end)
                
                Button.MouseEnter:Connect(function()
                    if not isLocked then
                        Tween(Button, {BackgroundColor3 = Config.BorderColor})
                    end
                end)
                
                Button.MouseLeave:Connect(function()
                    if not isLocked then
                        Tween(Button, {BackgroundColor3 = Config.MainColor})
                    end
                end)
                
                return {
                    SetText = function(_, text)
                        ButtonText.Text = text
                    end,
                    SetLocked = function(_, locked)
                        isLocked = locked
                        Button.BackgroundColor3 = locked and Config.LockedColor or Config.MainColor
                        ButtonText.TextColor3 = locked and Config.LockedTextColor or Config.TextColor
                        if IconLabel then
                            IconLabel.Image = GetIcon(locked and "lock" or OriginalIcon)
                            IconLabel.ImageColor3 = locked and Config.LockedTextColor or Config.TextColor
                        end
                        if DescLabel then
                            DescLabel.TextColor3 = locked and Config.LockedTextColor or Config.SecondaryTextColor
                        end
                    end
                }
            end
            
            function Section:CreateToggle(options)
                options = options or {}
                local Text = options.Text or "Toggle"
                local ToggleDescription = options.Description or ""
                local Default = options.Default or false
                local Icon = options.Icon
                local Callback = options.Callback or function() end
                local Locked = options.Locked or false
                local Flag = options.Flag
                local hasDesc = ToggleDescription ~= ""
                local height = hasDesc and (IsMobile and 52 or 46) or (IsMobile and 38 or 34)
                
                local ToggleFrame = Create("Frame", {
                    BackgroundColor3 = Config.MainColor,
                    Size = UDim2.new(1, 0, 0, height),
                    Parent = SectionContent
                })
                AddCorner(ToggleFrame, 8)
                
                OnThemeChange(function()
                    Tween(ToggleFrame, {BackgroundColor3 = Config.MainColor})
                end)
                
                local textOffset = 0
                if Icon then
                    local IconLabel = Create("ImageLabel", {
                        BackgroundTransparency = 1,
                        Image = GetIcon(Icon),
                        ImageColor3 = Config.SecondaryTextColor,
                        Size = UDim2.new(0, IsMobile and 18 or 16, 0, IsMobile and 18 or 16),
                        Position = UDim2.new(0, 12, 0.5, 0),
                        AnchorPoint = Vector2.new(0, 0.5),
                        Parent = ToggleFrame
                    })
                    
                    OnThemeChange(function()
                        Tween(IconLabel, {ImageColor3 = Config.SecondaryTextColor})
                    end)
                    
                    textOffset = IsMobile and 24 or 22
                end
                
                local ToggleText = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Text = Text,
                    TextColor3 = Config.TextColor,
                    FontFace = Config.Font,
                    TextSize = IsMobile and 12 or 11,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2.new(0, 12 + textOffset, 0, hasDesc and 10 or 0),
                    Size = UDim2.new(1, -70 - textOffset, 0, hasDesc and 16 or height),
                    Parent = ToggleFrame
                })
                
                OnThemeChange(function()
                    Tween(ToggleText, {TextColor3 = Config.TextColor})
                end)
                
                if hasDesc then
                    local DescLabel = Create("TextLabel", {
                        BackgroundTransparency = 1,
                        Text = ToggleDescription,
                        TextColor3 = Config.SecondaryTextColor,
                        FontFace = Config.Font,
                        TextSize = IsMobile and 10 or 9,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Position = UDim2.new(0, 12 + textOffset, 0, IsMobile and 26 or 24),
                        Size = UDim2.new(1, -70 - textOffset, 0, 14),
                        Parent = ToggleFrame
                    })
                    
                    OnThemeChange(function()
                        Tween(DescLabel, {TextColor3 = Config.SecondaryTextColor})
                    end)
                end
                
                local ToggleButton = Create("TextButton", {
                    BackgroundColor3 = Default and Config.ToggleOnColor or Config.ToggleOffColor,
                    Size = UDim2.new(0, IsMobile and 44 or 40, 0, IsMobile and 24 or 22),
                    Position = UDim2.new(1, IsMobile and -54 or -50, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    Text = "",
                    AutoButtonColor = false,
                    Parent = ToggleFrame
                })
                AddCorner(ToggleButton, IsMobile and 12 or 11)
                
                local ToggleIndicator = Create("Frame", {
                    BackgroundColor3 = Default and Config.MainColor or Config.SecondaryTextColor,
                    Size = UDim2.new(0, IsMobile and 18 or 16, 0, IsMobile and 18 or 16),
                    Position = Default and UDim2.new(1, -21, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    Parent = ToggleButton
                })
                AddCorner(ToggleIndicator, IsMobile and 9 or 8)
                
                local toggled = Default
                local isLocked = Locked
                
                local function UpdateToggle()
                    if toggled then
                        Tween(ToggleButton, {BackgroundColor3 = Config.ToggleOnColor})
                        Tween(ToggleIndicator, {Position = UDim2.new(1, -21, 0.5, 0), BackgroundColor3 = Config.MainColor})
                    else
                        Tween(ToggleButton, {BackgroundColor3 = Config.ToggleOffColor})
                        Tween(ToggleIndicator, {Position = UDim2.new(0, 3, 0.5, 0), BackgroundColor3 = Config.SecondaryTextColor})
                    end
                    Callback(toggled)
                end
                
                OnThemeChange(function()
                    if toggled then
                        ToggleButton.BackgroundColor3 = Config.ToggleOnColor
                        ToggleIndicator.BackgroundColor3 = Config.MainColor
                    else
                        ToggleButton.BackgroundColor3 = Config.ToggleOffColor
                        ToggleIndicator.BackgroundColor3 = Config.SecondaryTextColor
                    end
                end)
                
                ToggleButton.MouseButton1Click:Connect(function()
                    if not isLocked then
                        toggled = not toggled
                        UpdateToggle()
                    end
                end)
                
                local ToggleAPI = {
                    Set = function(_, value)
                        if not isLocked then
                            toggled = value
                            UpdateToggle()
                        end
                    end,
                    Get = function()
                        return toggled
                    end,
                    SetLocked = function(_, locked)
                        isLocked = locked
                    end
                }
                
                if Flag then
                    ConfigSystem:RegisterFlag(Flag, function()
                        return toggled
                    end, function(value)
                        toggled = value
                        UpdateToggle()
                    end)
                end
                
                return ToggleAPI
            end
            
            function Section:CreateSlider(options)
                options = options or {}
                local Text = options.Text or "Slider"
                local SliderDescription = options.Description or ""
                local Min = options.Min or 0
                local Max = options.Max or 100
                local Default = options.Default or Min
                local Increment = options.Increment or 1
                local Suffix = options.Suffix or ""
                local Icon = options.Icon
                local Callback = options.Callback or function() end
                local Locked = options.Locked or false
                local Flag = options.Flag
                local hasDesc = SliderDescription ~= ""
                local height = hasDesc and (IsMobile and 68 or 60) or (IsMobile and 54 or 48)
                
                local SliderFrame = Create("Frame", {
                    BackgroundColor3 = Config.MainColor,
                    Size = UDim2.new(1, 0, 0, height),
                    Parent = SectionContent
                })
                AddCorner(SliderFrame, 8)
                
                OnThemeChange(function()
                    Tween(SliderFrame, {BackgroundColor3 = Config.MainColor})
                end)
                
                local textOffset = 0
                if Icon then
                    local IconLabel = Create("ImageLabel", {
                        BackgroundTransparency = 1,
                        Image = GetIcon(Icon),
                        ImageColor3 = Config.SecondaryTextColor,
                        Size = UDim2.new(0, IsMobile and 18 or 16, 0, IsMobile and 18 or 16),
                        Position = UDim2.new(0, 12, 0, IsMobile and 10 or 8),
                        Parent = SliderFrame
                    })
                    
                    OnThemeChange(function()
                        Tween(IconLabel, {ImageColor3 = Config.SecondaryTextColor})
                    end)
                    
                    textOffset = IsMobile and 24 or 22
                end
                
                local SliderText = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Text = Text,
                    TextColor3 = Config.TextColor,
                    FontFace = Config.Font,
                    TextSize = IsMobile and 12 or 11,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2.new(0, 12 + textOffset, 0, 6),
                    Size = UDim2.new(1, -80 - textOffset, 0, 16),
                    Parent = SliderFrame
                })
                
                OnThemeChange(function()
                    Tween(SliderText, {TextColor3 = Config.TextColor})
                end)
                
                local ValueLabel = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Text = tostring(Default) .. Suffix,
                    TextColor3 = Config.SecondaryTextColor,
                    FontFace = Config.Font,
                    TextSize = IsMobile and 11 or 10,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    Position = UDim2.new(1, -56, 0, 6),
                    Size = UDim2.new(0, 44, 0, 16),
                    Parent = SliderFrame
                })
                
                OnThemeChange(function()
                    Tween(ValueLabel, {TextColor3 = Config.SecondaryTextColor})
                end)
                
                local descOffset = hasDesc and 12 or 0
                if hasDesc then
                    local DescLabel = Create("TextLabel", {
                        BackgroundTransparency = 1,
                        Text = SliderDescription,
                        TextColor3 = Config.SecondaryTextColor,
                        FontFace = Config.Font,
                        TextSize = IsMobile and 10 or 9,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Position = UDim2.new(0, 12 + textOffset, 0, 20),
                        Size = UDim2.new(1, -24 - textOffset, 0, 12),
                        Parent = SliderFrame
                    })
                    
                    OnThemeChange(function()
                        Tween(DescLabel, {TextColor3 = Config.SecondaryTextColor})
                    end)
                end
                
                local SliderBar = Create("Frame", {
                    BackgroundColor3 = Config.BorderColor,
                    Size = UDim2.new(1, -24, 0, 6),
                    Position = UDim2.new(0, 12, 0, (hasDesc and 36 or 28)),
                    Parent = SliderFrame
                })
                AddCorner(SliderBar, 3)
                
                OnThemeChange(function()
                    Tween(SliderBar, {BackgroundColor3 = Config.BorderColor})
                end)
                
                local SliderFill = Create("Frame", {
                    BackgroundColor3 = Config.AccentColor,
                    Size = UDim2.new((Default - Min) / (Max - Min), 0, 1, 0),
                    Parent = SliderBar
                })
                AddCorner(SliderFill, 3)
                
                OnThemeChange(function()
                    Tween(SliderFill, {BackgroundColor3 = Config.AccentColor})
                end)
                
                local SliderKnob = Create("Frame", {
                    BackgroundColor3 = Config.TextColor,
                    Size = UDim2.new(0, 14, 0, 14),
                    Position = UDim2.new((Default - Min) / (Max - Min), 0, 0.5, 0),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Parent = SliderBar
                })
                AddCorner(SliderKnob, 7)
                
                OnThemeChange(function()
                    Tween(SliderKnob, {BackgroundColor3 = Config.TextColor})
                end)
                
                local value = Default
                local dragging = false
                local isLocked = Locked
                
                local function GetDecimalPlaces(num)
                    local s = tostring(num)
                    local dot = string.find(s, '%.')
                    return dot and (#s - dot) or 0 
                end 

                local function RoundToIncrement(value, increment)
                    local decimals = GetDecimalPlaces(increment)
                    local multiplier = 10 ^ decimals

                    return math.round(value * multiplier) / multiplier
                end 

                local function UpdateSlider(input)
                    if isLocked then return end
                    local percent = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                    local newValue = Min + (Max - Min) * percent
                    newValue = math.floor(newValue / Increment + 0.5) * Increment
                    newValue = math.clamp(newValue, Min, Max)
                    newValue = RoundToIncrement(newValue, Increment)
                    value = newValue
                    local fillPercent = (newValue - Min) / (Max - Min)
                    SliderFill.Size = UDim2.new(fillPercent, 0, 1, 0)
                    SliderKnob.Position = UDim2.new(fillPercent, 0, 0.5, 0)
                    ValueLabel.Text = tostring(newValue) .. Suffix
                    Callback(newValue)
                end
                
                SliderBar.InputBegan:Connect(function(input)
                    if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not isLocked then
                        dragging = true
                        UpdateSlider(input)
                    end
                end)
                
                SliderBar.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and not isLocked and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        UpdateSlider(input)
                    end
                end)
                
                local SliderAPI = {
                    Set = function(_, newValue)
                        if not isLocked then
                            value = math.clamp(newValue, Min, Max)
                            local fillPercent = (value - Min) / (Max - Min)
                            SliderFill.Size = UDim2.new(fillPercent, 0, 1, 0)
                            SliderKnob.Position = UDim2.new(fillPercent, 0, 0.5, 0)
                            ValueLabel.Text = tostring(value) .. Suffix
                            Callback(value)
                        end
                    end,
                    Get = function()
                        return value
                    end
                }
                
                if Flag then
                    ConfigSystem:RegisterFlag(Flag, function()
                        return value
                    end, function(newValue)
                        SliderAPI:Set(newValue)
                    end)
                end
                
                return SliderAPI
            end
            
            function Section:CreateDropdown(options)
                options = options or {}
                local Text = options.Text or "Dropdown"
                local DropdownDescription = options.Description or ""
                local Items = options.Items or {}
                local Default = options.Default
                local Multi = options.Multi or false
                local MaxVisible = options.MaxVisible or 5
                local Icon = options.Icon
                local Callback = options.Callback or function() end
                local Locked = options.Locked or false
                local Flag = options.Flag
                local hasDesc = DropdownDescription ~= ""
                local closedHeight = hasDesc and (IsMobile and 76 or 68) or (IsMobile and 60 or 54)
                
                local DropdownHolder = Create("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, closedHeight),
                    ClipsDescendants = false,
                    Parent = SectionContent
                })
                
                local DropdownFrame = Create("Frame", {
                    BackgroundColor3 = Config.MainColor,
                    Size = UDim2.new(1, 0, 0, closedHeight),
                    Parent = DropdownHolder
                })
                AddCorner(DropdownFrame, 8)
                
                OnThemeChange(function()
                    Tween(DropdownFrame, {BackgroundColor3 = Config.MainColor})
                end)
                
                local textOffset = 0
                if Icon then
                    local IconLabel = Create("ImageLabel", {
                        BackgroundTransparency = 1,
                        Image = GetIcon(Icon),
                        ImageColor3 = Config.SecondaryTextColor,
                        Size = UDim2.new(0, IsMobile and 18 or 16, 0, IsMobile and 18 or 16),
                        Position = UDim2.new(0, 12, 0, IsMobile and 10 or 8),
                        Parent = DropdownFrame
                    })
                    
                    OnThemeChange(function()
                        Tween(IconLabel, {ImageColor3 = Config.SecondaryTextColor})
                    end)
                    
                    textOffset = IsMobile and 24 or 22
                end
                
                local DropdownText = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Text = Text,
                    TextColor3 = Config.TextColor,
                    FontFace = Config.Font,
                    TextSize = IsMobile and 12 or 11,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2.new(0, 12 + textOffset, 0, 6),
                    Size = UDim2.new(1, -24 - textOffset, 0, 16),
                    Parent = DropdownFrame
                })
                
                OnThemeChange(function()
                    Tween(DropdownText, {TextColor3 = Config.TextColor})
                end)
                
                local descOffset = 0
                if hasDesc then
                    local DescLabel = Create("TextLabel", {
                        BackgroundTransparency = 1,
                        Text = DropdownDescription,
                        TextColor3 = Config.SecondaryTextColor,
                        FontFace = Config.Font,
                        TextSize = IsMobile and 10 or 9,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Position = UDim2.new(0, 12 + textOffset, 0, 20),
                        Size = UDim2.new(1, -24 - textOffset, 0, 12),
                        Parent = DropdownFrame
                    })
                    
                    OnThemeChange(function()
                        Tween(DescLabel, {TextColor3 = Config.SecondaryTextColor})
                    end)
                    
                    descOffset = 10
                end
                
                local DropdownButton = Create("TextButton", {
                    BackgroundColor3 = Config.SecondaryColor,
                    Size = UDim2.new(1, -24, 0, IsMobile and 30 or 26),
                    Position = UDim2.new(0, 12, 0, (hasDesc and 36 or 26)),
                    Text = "",
                    AutoButtonColor = false,
                    Parent = DropdownFrame
                })
                AddCorner(DropdownButton, 6)
                
                OnThemeChange(function()
                    Tween(DropdownButton, {BackgroundColor3 = Config.SecondaryColor})
                end)
                
                local function GetDisplayText()
                    if Multi then
                        if type(Default) == "table" and #Default > 0 then
                            return table.concat(Default, ", ")
                        end
                        return "Select..."
                    else
                        return Default or "Select..."
                    end
                end
                
                local SelectedText = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Text = GetDisplayText(),
                    TextColor3 = Default and Config.TextColor or Config.SecondaryTextColor,
                    FontFace = Config.Font,
                    TextSize = IsMobile and 11 or 10,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    Position = UDim2.new(0, 10, 0, 0),
                    Size = UDim2.new(1, -32, 1, 0),
                    Parent = DropdownButton
                })
                
                OnThemeChange(function()
                    if selected then
                        Tween(SelectedText, {TextColor3 = Config.TextColor})
                    else
                        Tween(SelectedText, {TextColor3 = Config.SecondaryTextColor})
                    end
                end)
                
                local DropdownArrow = Create("ImageLabel", {
                    BackgroundTransparency = 1,
                    Image = GetIcon("chevron-down"),
                    ImageColor3 = Config.SecondaryTextColor,
                    Size = UDim2.new(0, IsMobile and 16 or 14, 0, IsMobile and 16 or 14),
                    Position = UDim2.new(1, -22, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    Parent = DropdownButton
                })
                
                OnThemeChange(function()
                    Tween(DropdownArrow, {ImageColor3 = Config.SecondaryTextColor})
                end)
                
                local itemHeight = IsMobile and 34 or 30
                
                local DropdownListContainer = Create("Frame", {
                    Name = "DropdownListContainer",
                    BackgroundColor3 = Config.SecondaryColor,
                    Size = UDim2.new(1, -24, 0, 0),
                    Position = UDim2.new(0, 12, 0, closedHeight + 4),
                    ClipsDescendants = true,
                    Visible = false,
                    ZIndex = 100,
                    Parent = DropdownHolder
                })
                AddCorner(DropdownListContainer, 8)
                AddShadow(DropdownListContainer)
                
                OnThemeChange(function()
                    Tween(DropdownListContainer, {BackgroundColor3 = Config.SecondaryColor})
                end)
                
                local DropdownScroll = Create("ScrollingFrame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -8, 1, -8),
                    Position = UDim2.new(0, 4, 0, 4),
                    CanvasSize = UDim2.new(0, 0, 0, 0),
                    ScrollBarThickness = 0,
                    ScrollBarImageColor3 = Config.BorderColor,
                    ScrollBarImageTransparency = 0.5,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    ZIndex = 101,
                    Parent = DropdownListContainer
                })
                
                OnThemeChange(function()
                    Tween(DropdownScroll, {ScrollBarImageColor3 = Config.BorderColor})
                end)
                
                Create("UIListLayout", {
                    Padding = UDim.new(0, 2),
                    Parent = DropdownScroll
                })
                
                local isOpen = false
                local selected = Multi and (type(Default) == "table" and table.clone(Default) or {}) or Default
                local isLocked = Locked
                local itemButtons = {}
                
                local function UpdateDisplayText()
                    if Multi then
                        if #selected > 0 then
                            SelectedText.Text = table.concat(selected, ", ")
                            SelectedText.TextColor3 = Config.TextColor
                        else
                            SelectedText.Text = "Select..."
                            SelectedText.TextColor3 = Config.SecondaryTextColor
                        end
                    else
                        if selected then
                            SelectedText.Text = selected
                            SelectedText.TextColor3 = Config.TextColor
                        else
                            SelectedText.Text = "Select..."
                            SelectedText.TextColor3 = Config.SecondaryTextColor
                        end
                    end
                end
                
                local function ToggleDropdown()
                    isOpen = not isOpen
                    
                    if isOpen then
                        local visibleItems = math.min(#Items, MaxVisible)
                        local listHeight = itemHeight * visibleItems + 8
                        DropdownListContainer.Visible = true
                        DropdownListContainer.Size = UDim2.new(1, -24, 0, 0)
                        Tween(DropdownListContainer, {Size = UDim2.new(1, -24, 0, listHeight)})
                        Tween(DropdownArrow, {Rotation = 180})
                        Tween(DropdownHolder, {Size = UDim2.new(1, 0, 0, closedHeight + listHeight + 8)})
                    else
                        Tween(DropdownListContainer, {Size = UDim2.new(1, -24, 0, 0)})
                        Tween(DropdownArrow, {Rotation = 0})
                        Tween(DropdownHolder, {Size = UDim2.new(1, 0, 0, closedHeight)})
                        task.delay(0.12, function()
                            if not isOpen then
                                DropdownListContainer.Visible = false
                            end
                        end)
                    end
                end
                
                local function IsSelected(item)
                    if Multi then
                        return table.find(selected, item) ~= nil
                    else
                        return selected == item
                    end
                end
                
                local function UpdateItemVisual(button, isItemSelected)
                    local checkmark = button:FindFirstChild("Checkmark")
                    if checkmark then
                        checkmark.Visible = isItemSelected
                    end
                    if isItemSelected then
                        Tween(button, {BackgroundColor3 = Config.BorderColor})
                    else
                        Tween(button, {BackgroundColor3 = Config.SecondaryColor})
                    end
                end
                
                local function CreateItem(item)
                    local ItemButton = Create("TextButton", {
                        Name = item,
                        BackgroundColor3 = IsSelected(item) and Config.BorderColor or Config.SecondaryColor,
                        Size = UDim2.new(1, 0, 0, itemHeight - 2),
                        Text = "",
                        AutoButtonColor = false,
                        ZIndex = 102,
                        Parent = DropdownScroll
                    })
                    AddCorner(ItemButton, 6)
                    
                    OnThemeChange(function()
                        if IsSelected(item) then
                            ItemButton.BackgroundColor3 = Config.BorderColor
                        else
                            ItemButton.BackgroundColor3 = Config.SecondaryColor
                        end
                    end)
                    
                    local ItemText = Create("TextLabel", {
                        BackgroundTransparency = 1,
                        Text = item,
                        TextColor3 = Config.TextColor,
                        FontFace = Config.Font,
                        TextSize = IsMobile and 11 or 10,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Position = UDim2.new(0, 10, 0, 0),
                        Size = UDim2.new(1, Multi and -32 or -20, 1, 0),
                        ZIndex = 103,
                        Parent = ItemButton
                    })
                    
                    OnThemeChange(function()
                        Tween(ItemText, {TextColor3 = Config.TextColor})
                    end)
                    
                    if Multi then
                        local Checkmark = Create("ImageLabel", {
                            Name = "Checkmark",
                            BackgroundTransparency = 1,
                            Image = GetIcon("check"),
                            ImageColor3 = Config.AccentColor,
                            Size = UDim2.new(0, IsMobile and 14 or 12, 0, IsMobile and 14 or 12),
                            Position = UDim2.new(1, -22, 0.5, 0),
                            AnchorPoint = Vector2.new(0, 0.5),
                            Visible = IsSelected(item),
                            ZIndex = 103,
                            Parent = ItemButton
                        })
                        
                        OnThemeChange(function()
                            Tween(Checkmark, {ImageColor3 = Config.AccentColor})
                        end)
                    end
                    
                    ItemButton.MouseEnter:Connect(function()
                        if not IsSelected(item) then
                            Tween(ItemButton, {BackgroundColor3 = Config.BorderColor})
                        end
                    end)

                    OnThemeChange(function()
                        if not IsSelected(item) then
                            Tween(ItemButton, {BackgroundColor3 = Config.SecondaryColor})
                        else
                            Tween(ItemButton, {BackgroundColor3 = Config.BorderColor})
                        end 
                    end)
                    
                    ItemButton.MouseLeave:Connect(function()
                        if not IsSelected(item) then
                            Tween(ItemButton, {BackgroundColor3 = Config.SecondaryColor})
                        end
                    end)
                    
                    ItemButton.MouseButton1Click:Connect(function()
                        if isLocked then return end
                        
                        if Multi then
                            local index = table.find(selected, item)
                            if index then
                                table.remove(selected, index)
                            else
                                table.insert(selected, item)
                            end
                            UpdateItemVisual(ItemButton, IsSelected(item))
                            local checkmark = ItemButton:FindFirstChild("Checkmark")
                            if checkmark then
                                checkmark.Visible = IsSelected(item)
                            end
                            UpdateDisplayText()
                            Callback(selected)
                        else
                            for _, btn in pairs(itemButtons) do
                                UpdateItemVisual(btn, false)
                            end
                            selected = item
                            UpdateItemVisual(ItemButton, true)
                            UpdateDisplayText()
                            ToggleDropdown()
                            Callback(item)
                        end
                    end)
                    
                    itemButtons[item] = ItemButton
                end
                
                for _, item in ipairs(Items) do
                    CreateItem(item)
                end
                
                DropdownButton.MouseButton1Click:Connect(function()
                    if not isLocked then
                        ToggleDropdown()
                    end
                end)
                
                DropdownButton.MouseEnter:Connect(function()
                    if not isLocked then
                        Tween(DropdownButton, {BackgroundColor3 = Config.BorderColor})
                    end
                end)
                
                DropdownButton.MouseLeave:Connect(function()
                    if not isLocked then
                        Tween(DropdownButton, {BackgroundColor3 = Config.SecondaryColor})
                    end
                end)
                
                local DropdownAPI = {
                    SetItems = function(_, newItems)
                        for _, btn in pairs(itemButtons) do
                            btn:Destroy()
                        end
                        itemButtons = {}
                        Items = newItems
                        
                        if Multi then
                            selected = {}
                        else
                            selected = nil
                        end
                        UpdateDisplayText()
                        
                        for _, item in ipairs(Items) do
                            CreateItem(item)
                        end
                        
                        if isOpen then
                            ToggleDropdown()
                        end
                    end,
                    AddItem = function(_, item)
                        if not table.find(Items, item) then
                            table.insert(Items, item)
                            CreateItem(item)
                        end
                    end,
                    RemoveItem = function(_, item)
                        local index = table.find(Items, item)
                        if index then
                            table.remove(Items, index)
                            if itemButtons[item] then
                                itemButtons[item]:Destroy()
                                itemButtons[item] = nil
                            end
                            
                            if Multi then
                                local selIndex = table.find(selected, item)
                                if selIndex then
                                    table.remove(selected, selIndex)
                                    UpdateDisplayText()
                                    Callback(selected)
                                end
                            elseif selected == item then
                                selected = nil
                                UpdateDisplayText()
                            end
                        end
                    end,
                    SetValue = function(_, value)
                        if isLocked then return end
                        
                        if Multi then
                            selected = type(value) == "table" and table.clone(value) or {value}
                            for item, btn in pairs(itemButtons) do
                                UpdateItemVisual(btn, IsSelected(item))
                                local checkmark = btn:FindFirstChild("Checkmark")
                                if checkmark then
                                    checkmark.Visible = IsSelected(item)
                                end
                            end
                        else
                            for _, btn in pairs(itemButtons) do
                                UpdateItemVisual(btn, false)
                            end
                            selected = value
                            if itemButtons[value] then
                                UpdateItemVisual(itemButtons[value], true)
                            end
                        end
                        UpdateDisplayText()
                        Callback(selected)
                    end,
                    GetValue = function()
                        return selected
                    end,
                    ClearSelection = function(_)
                        if isLocked then return end
                        
                        if Multi then
                            selected = {}
                        else
                            selected = nil
                        end
                        
                        for _, btn in pairs(itemButtons) do
                            UpdateItemVisual(btn, false)
                            local checkmark = btn:FindFirstChild("Checkmark")
                            if checkmark then
                                checkmark.Visible = false
                            end
                        end
                        UpdateDisplayText()
                        Callback(selected)
                    end,
                    SetLocked = function(_, locked)
                        isLocked = locked
                        if locked and isOpen then
                            ToggleDropdown()
                        end
                    end,
                    Refresh = function(_)
                        for _, btn in pairs(itemButtons) do
                            btn:Destroy()
                        end
                        itemButtons = {}
                        
                        for _, item in ipairs(Items) do
                            CreateItem(item)
                        end
                    end
                }
                
                if Flag then
                    ConfigSystem:RegisterFlag(Flag, function()
                        return selected
                    end, function(value)
                        DropdownAPI:SetValue(value)
                    end)
                end
                
                return DropdownAPI
            end
            
            function Section:CreateInput(options)
                options = options or {}
                local Text = options.Text or "Input"
                local InputDescription = options.Description or ""
                local Placeholder = options.Placeholder or "Enter text..."
                local Default = options.Default or ""
                local Icon = options.Icon
                local Callback = options.Callback or function() end
                local Locked = options.Locked or false
                local Flag = options.Flag
                local hasDesc = InputDescription ~= ""
                local height = hasDesc and (IsMobile and 76 or 68) or (IsMobile and 60 or 54)
                
                local InputFrame = Create("Frame", {
                    BackgroundColor3 = Config.MainColor,
                    Size = UDim2.new(1, 0, 0, height),
                    Parent = SectionContent
                })
                AddCorner(InputFrame, 8)
                
                OnThemeChange(function()
                    Tween(InputFrame, {BackgroundColor3 = Config.MainColor})
                end)
                
                local textOffset = 0
                if Icon then
                    local IconLabel = Create("ImageLabel", {
                        BackgroundTransparency = 1,
                        Image = GetIcon(Icon),
                        ImageColor3 = Config.SecondaryTextColor,
                        Size = UDim2.new(0, IsMobile and 18 or 16, 0, IsMobile and 18 or 16),
                        Position = UDim2.new(0, 12, 0, IsMobile and 10 or 8),
                        Parent = InputFrame
                    })
                    
                    OnThemeChange(function()
                        Tween(IconLabel, {ImageColor3 = Config.SecondaryTextColor})
                    end)
                    
                    textOffset = IsMobile and 24 or 22
                end
                
                local InputText = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Text = Text,
                    TextColor3 = Config.TextColor,
                    FontFace = Config.Font,
                    TextSize = IsMobile and 12 or 11,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2.new(0, 12 + textOffset, 0, 6),
                    Size = UDim2.new(1, -24 - textOffset, 0, 16),
                    Parent = InputFrame
                })
                
                OnThemeChange(function()
                    Tween(InputText, {TextColor3 = Config.TextColor})
                end)
                
                if hasDesc then
                    local DescLabel = Create("TextLabel", {
                        BackgroundTransparency = 1,
                        Text = InputDescription,
                        TextColor3 = Config.SecondaryTextColor,
                        FontFace = Config.Font,
                        TextSize = IsMobile and 10 or 9,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Position = UDim2.new(0, 12 + textOffset, 0, 20),
                        Size = UDim2.new(1, -24 - textOffset, 0, 12),
                        Parent = InputFrame
                    })
                    
                    OnThemeChange(function()
                        Tween(DescLabel, {TextColor3 = Config.SecondaryTextColor})
                    end)
                end
                
                local InputContainer = Create("Frame", {
                    BackgroundColor3 = Config.SecondaryColor,
                    Size = UDim2.new(1, -24, 0, IsMobile and 30 or 26),
                    Position = UDim2.new(0, 12, 0, (hasDesc and 36 or 26)),
                    Parent = InputFrame
                })
                AddCorner(InputContainer, 6)
                
                OnThemeChange(function()
                    Tween(InputContainer, {BackgroundColor3 = Config.SecondaryColor})
                end)
                
                local TextBox = Create("TextBox", {
                    BackgroundTransparency = 1,
                    Text = Default,
                    PlaceholderText = Placeholder,
                    PlaceholderColor3 = Config.SecondaryTextColor,
                    TextColor3 = Config.TextColor,
                    FontFace = Config.Font,
                    TextSize = IsMobile and 11 or 10,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextEditable = not Locked,
                    ClearTextOnFocus = false,
                    Size = UDim2.new(1, -16, 1, 0),
                    Position = UDim2.new(0, 8, 0, 0),
                    Parent = InputContainer
                })
                
                OnThemeChange(function()
                    Tween(TextBox, {TextColor3 = Config.TextColor, PlaceholderColor3 = Config.SecondaryTextColor})
                end)
                
                local isLocked = Locked
                
                TextBox.FocusLost:Connect(function(enterPressed)
                    if not isLocked then
                        Tween(InputContainer, {BackgroundColor3 = Config.SecondaryColor})
                        Callback(TextBox.Text, enterPressed)
                    end
                end)
                
                TextBox.Focused:Connect(function()
                    if not isLocked then
                        Tween(InputContainer, {BackgroundColor3 = Config.BorderColor})
                    end
                end)
                
                local InputAPI = {
                    SetText = function(_, text)
                        if not isLocked then
                            TextBox.Text = text
                        end
                    end,
                    GetText = function()
                        return TextBox.Text
                    end,
                    SetLocked = function(_, locked)
                        isLocked = locked
                        TextBox.TextEditable = not locked
                    end
                }
                
                if Flag then
                    ConfigSystem:RegisterFlag(Flag, function()
                        return TextBox.Text
                    end, function(value)
                        TextBox.Text = value
                    end)
                end
                
                return InputAPI
            end
            
            function Section:CreateColorPicker(options)
                options = options or {}
                local Text = options.Text or "Color"
                local ColorDescription = options.Description or ""
                local Default = options.Default or Color3.fromRGB(255, 255, 255)
                local Icon = options.Icon
                local Callback = options.Callback or function() end
                local Locked = options.Locked or false
                local Flag = options.Flag
                local hasDesc = ColorDescription ~= ""
                local closedHeight = hasDesc and (IsMobile and 52 or 46) or (IsMobile and 38 or 34)
                
                local ColorHolder = Create("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, closedHeight),
                    ClipsDescendants = false,
                    Parent = SectionContent
                })
                
                local ColorFrame = Create("Frame", {
                    BackgroundColor3 = Config.MainColor,
                    Size = UDim2.new(1, 0, 0, closedHeight),
                    Parent = ColorHolder
                })
                AddCorner(ColorFrame, 8)
                
                OnThemeChange(function()
                    Tween(ColorFrame, {BackgroundColor3 = Config.MainColor})
                end)
                
                local textOffset = 0
                if Icon then
                    local IconLabel = Create("ImageLabel", {
                        BackgroundTransparency = 1,
                        Image = GetIcon(Icon),
                        ImageColor3 = Config.SecondaryTextColor,
                        Size = UDim2.new(0, IsMobile and 18 or 16, 0, IsMobile and 18 or 16),
                        Position = UDim2.new(0, 12, 0.5, 0),
                        AnchorPoint = Vector2.new(0, 0.5),
                        Parent = ColorFrame
                    })
                    
                    OnThemeChange(function()
                        Tween(IconLabel, {ImageColor3 = Config.SecondaryTextColor})
                    end)
                    
                    textOffset = IsMobile and 24 or 22
                end
                
                local ColorText = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Text = Text,
                    TextColor3 = Config.TextColor,
                    FontFace = Config.Font,
                    TextSize = IsMobile and 12 or 11,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2.new(0, 12 + textOffset, 0, hasDesc and 8 or 0),
                    Size = UDim2.new(1, -70 - textOffset, 0, hasDesc and 16 or closedHeight),
                    Parent = ColorFrame
                })
                
                OnThemeChange(function()
                    Tween(ColorText, {TextColor3 = Config.TextColor})
                end)
                
                if hasDesc then
                    local DescLabel = Create("TextLabel", {
                        BackgroundTransparency = 1,
                        Text = ColorDescription,
                        TextColor3 = Config.SecondaryTextColor,
                        FontFace = Config.Font,
                        TextSize = IsMobile and 10 or 9,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Position = UDim2.new(0, 12 + textOffset, 0, 24),
                        Size = UDim2.new(1, -70 - textOffset, 0, 12),
                        Parent = ColorFrame
                    })
                    
                    OnThemeChange(function()
                        Tween(DescLabel, {TextColor3 = Config.SecondaryTextColor})
                    end)
                end
                
                local ColorPreview = Create("TextButton", {
                    BackgroundColor3 = Default,
                    Size = UDim2.new(0, IsMobile and 44 or 40, 0, IsMobile and 24 or 22),
                    Position = UDim2.new(1, IsMobile and -54 or -50, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    Text = "",
                    AutoButtonColor = false,
                    Parent = ColorFrame
                })
                AddCorner(ColorPreview, 6)
                
                local pickerHeight = IsMobile and 140 or 120
                
                local PickerContainer = Create("Frame", {
                    BackgroundColor3 = Config.SecondaryColor,
                    Size = UDim2.new(1, 0, 0, pickerHeight),
                    Position = UDim2.new(0, 0, 0, closedHeight + 4),
                    Visible = false,
                    ZIndex = 100,
                    Parent = ColorHolder
                })
                AddCorner(PickerContainer, 8)
                AddShadow(PickerContainer)
                
                OnThemeChange(function()
                    Tween(PickerContainer, {BackgroundColor3 = Config.SecondaryColor})
                end)
                
                local SaturationValue = Create("ImageLabel", {
                    BackgroundColor3 = Color3.fromRGB(255, 0, 0),
                    Size = UDim2.new(1, -40, 1, -12),
                    Position = UDim2.new(0, 6, 0, 6),
                    Image = "rbxassetid://4155801252",
                    ZIndex = 101,
                    Parent = PickerContainer
                })
                AddCorner(SaturationValue, 6)
                
                local SatValCursor = Create("Frame", {
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Size = UDim2.new(0, 12, 0, 12),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    ZIndex = 102,
                    Parent = SaturationValue
                })
                AddCorner(SatValCursor, 6)
                
                local HueSlider = Create("Frame", {
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Size = UDim2.new(0, 16, 1, -12),
                    Position = UDim2.new(1, -26, 0, 6),
                    ZIndex = 101,
                    Parent = PickerContainer
                })
                AddCorner(HueSlider, 4)
                
                Create("UIGradient", {
                    Rotation = 90,
                    Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                        ColorSequenceKeypoint.new(0.167, Color3.fromRGB(255, 255, 0)),
                        ColorSequenceKeypoint.new(0.333, Color3.fromRGB(0, 255, 0)),
                        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
                        ColorSequenceKeypoint.new(0.667, Color3.fromRGB(0, 0, 255)),
                        ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255, 0, 255)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
                    }),
                    Parent = HueSlider
                })
                
                local HueCursor = Create("Frame", {
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Size = UDim2.new(1, 4, 0, 4),
                    Position = UDim2.new(0, -2, 0, 0),
                    AnchorPoint = Vector2.new(0, 0),
                    ZIndex = 102,
                    Parent = HueSlider
                })
                AddCorner(HueCursor, 2)
                
                local color = Default
                local h, s, v = Color3.toHSV(Default)
                local isOpen = false
                local isLocked = Locked
                local draggingSatVal, draggingHue = false, false
                
                local function UpdateColor()
                    color = Color3.fromHSV(h, s, v)
                    ColorPreview.BackgroundColor3 = color
                    SaturationValue.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                    SatValCursor.Position = UDim2.new(s, 0, 1 - v, 0)
                    HueCursor.Position = UDim2.new(0, -2, h, 0)
                    Callback(color)
                end
                
                SaturationValue.InputBegan:Connect(function(input)
                    if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not isLocked then
                        draggingSatVal = true
                        local offset = Vector2.new(input.Position.X, input.Position.Y) - SaturationValue.AbsolutePosition
                        s = math.clamp(offset.X / SaturationValue.AbsoluteSize.X, 0, 1)
                        v = 1 - math.clamp(offset.Y / SaturationValue.AbsoluteSize.Y, 0, 1)
                        UpdateColor()
                    end
                end)
                
                SaturationValue.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        draggingSatVal = false
                    end
                end)
                
                HueSlider.InputBegan:Connect(function(input)
                    if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not isLocked then
                        draggingHue = true
                        local offset = input.Position.Y - HueSlider.AbsolutePosition.Y
                        h = math.clamp(offset / HueSlider.AbsoluteSize.Y, 0, 1)
                        UpdateColor()
                    end
                end)
                
                HueSlider.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        draggingHue = false
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if isLocked then return end
                    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                        if draggingSatVal then
                            local offset = Vector2.new(input.Position.X, input.Position.Y) - SaturationValue.AbsolutePosition
                            s = math.clamp(offset.X / SaturationValue.AbsoluteSize.X, 0, 1)
                            v = 1 - math.clamp(offset.Y / SaturationValue.AbsoluteSize.Y, 0, 1)
                            UpdateColor()
                        elseif draggingHue then
                            local offset = input.Position.Y - HueSlider.AbsolutePosition.Y
                            h = math.clamp(offset / HueSlider.AbsoluteSize.Y, 0, 1)
                            UpdateColor()
                        end
                    end
                end)
                
                ColorPreview.MouseButton1Click:Connect(function()
                    if isLocked then return end
                    isOpen = not isOpen
                    
                    if isOpen then
                        PickerContainer.Visible = true
                        PickerContainer.Size = UDim2.new(1, 0, 0, 0)
                        Tween(PickerContainer, {Size = UDim2.new(1, 0, 0, pickerHeight)})
                        Tween(ColorHolder, {Size = UDim2.new(1, 0, 0, closedHeight + pickerHeight + 8)})
                    else
                        Tween(PickerContainer, {Size = UDim2.new(1, 0, 0, 0)})
                        Tween(ColorHolder, {Size = UDim2.new(1, 0, 0, closedHeight)})
                        task.delay(0.12, function()
                            if not isOpen then
                                PickerContainer.Visible = false
                            end
                        end)
                    end
                end)
                
                UpdateColor()
                SatValCursor.Position = UDim2.new(s, 0, 1 - v, 0)
                HueCursor.Position = UDim2.new(0, -2, h, 0)
                
                local ColorAPI = {
                    SetColor = function(_, newColor)
                        if not isLocked then
                            h, s, v = Color3.toHSV(newColor)
                            UpdateColor()
                        end
                    end,
                    GetColor = function()
                        return color
                    end,
                    SetLocked = function(_, locked)
                        isLocked = locked
                        if locked and isOpen then
                            isOpen = false
                            PickerContainer.Visible = false
                            ColorHolder.Size = UDim2.new(1, 0, 0, closedHeight)
                        end
                    end
                }
                
                if Flag then
                    ConfigSystem:RegisterFlag(Flag, function()
                        return color
                    end, function(newColor)
                        ColorAPI:SetColor(newColor)
                    end)
                end
                
                return ColorAPI
            end
            
            function Section:CreateKeybind(options)
                options = options or {}
                local Text = options.Text or "Keybind"
                local KeybindDescription = options.Description or ""
                local Default = options.Default or Enum.KeyCode.Unknown
                local Icon = options.Icon
                local Callback = options.Callback or function() end
                local ChangedCallback = options.ChangedCallback or function() end
                local Locked = options.Locked or false
                local Flag = options.Flag
                local hasDesc = KeybindDescription ~= ""
                local height = hasDesc and (IsMobile and 52 or 46) or (IsMobile and 38 or 34)
                
                local KeybindFrame = Create("Frame", {
                    BackgroundColor3 = Config.MainColor,
                    Size = UDim2.new(1, 0, 0, height),
                    Parent = SectionContent
                })
                AddCorner(KeybindFrame, 8)
                
                OnThemeChange(function()
                    Tween(KeybindFrame, {BackgroundColor3 = Config.MainColor})
                end)
                
                local textOffset = 0
                if Icon then
                    local IconLabel = Create("ImageLabel", {
                        BackgroundTransparency = 1,
                        Image = GetIcon(Icon),
                        ImageColor3 = Config.SecondaryTextColor,
                        Size = UDim2.new(0, IsMobile and 18 or 16, 0, IsMobile and 18 or 16),
                        Position = UDim2.new(0, 12, 0.5, 0),
                        AnchorPoint = Vector2.new(0, 0.5),
                        Parent = KeybindFrame
                    })
                    
                    OnThemeChange(function()
                        Tween(IconLabel, {ImageColor3 = Config.SecondaryTextColor})
                    end)
                    
                    textOffset = IsMobile and 24 or 22
                end
                
                local KeybindText = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Text = Text,
                    TextColor3 = Config.TextColor,
                    FontFace = Config.Font,
                    TextSize = IsMobile and 12 or 11,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2.new(0, 12 + textOffset, 0, hasDesc and 8 or 0),
                    Size = UDim2.new(1, -90 - textOffset, 0, hasDesc and 16 or height),
                    Parent = KeybindFrame
                })
                
                OnThemeChange(function()
                    Tween(KeybindText, {TextColor3 = Config.TextColor})
                end)
                
                if hasDesc then
                    local DescLabel = Create("TextLabel", {
                        BackgroundTransparency = 1,
                        Text = KeybindDescription,
                        TextColor3 = Config.SecondaryTextColor,
                        FontFace = Config.Font,
                        TextSize = IsMobile and 10 or 9,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Position = UDim2.new(0, 12 + textOffset, 0, 24),
                        Size = UDim2.new(1, -90 - textOffset, 0, 12),
                        Parent = KeybindFrame
                    })
                    
                    OnThemeChange(function()
                        Tween(DescLabel, {TextColor3 = Config.SecondaryTextColor})
                    end)
                end
                
                local KeyButton = Create("TextButton", {
                    BackgroundColor3 = Config.SecondaryColor,
                    Size = UDim2.new(0, IsMobile and 64 or 60, 0, IsMobile and 24 or 22),
                    Position = UDim2.new(1, IsMobile and -74 or -70, 0.5, 0),
                    AnchorPoint = Vector2.new(0, 0.5),
                    Text = Default.Name or "None",
                    TextColor3 = Config.TextColor,
                    FontFace = Config.Font,
                    TextSize = IsMobile and 10 or 9,
                    AutoButtonColor = false,
                    Parent = KeybindFrame
                })
                AddCorner(KeyButton, 6)
                
                OnThemeChange(function()
                    Tween(KeyButton, {BackgroundColor3 = Config.SecondaryColor, TextColor3 = Config.TextColor})
                end)
                
                local key = Default
                local listening = false
                local isLocked = Locked
                
                KeyButton.MouseButton1Click:Connect(function()
                    if isLocked then return end
                    listening = true
                    KeyButton.Text = "..."
                    Tween(KeyButton, {BackgroundColor3 = Config.AccentColor})
                end)
                
                KeyButton.MouseEnter:Connect(function()
                    if not isLocked and not listening then
                        Tween(KeyButton, {BackgroundColor3 = Config.BorderColor})
                    end
                end)
                
                KeyButton.MouseLeave:Connect(function()
                    if not isLocked and not listening then
                        Tween(KeyButton, {BackgroundColor3 = Config.SecondaryColor})
                    end
                end)
                
                UserInputService.InputBegan:Connect(function(input, gameProcessed)
                    if gameProcessed then return end
                    
                    if listening and not isLocked then
                        if input.UserInputType == Enum.UserInputType.Keyboard then
                            key = input.KeyCode
                            KeyButton.Text = key.Name
                            listening = false
                            Tween(KeyButton, {BackgroundColor3 = Config.SecondaryColor})
                            ChangedCallback(key)
                        elseif input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then
                            KeyButton.Text = key.Name or "None"
                            listening = false
                            Tween(KeyButton, {BackgroundColor3 = Config.SecondaryColor})
                        end
                    elseif input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == key and not isLocked then
                        Callback(key)
                    end
                end)
                
                local KeybindAPI = {
                    SetKey = function(_, newKey)
                        if not isLocked then
                            key = newKey
                            KeyButton.Text = newKey.Name
                            ChangedCallback(newKey)
                        end
                    end,
                    GetKey = function()
                        return key
                    end,
                    SetLocked = function(_, locked)
                        isLocked = locked
                        listening = false
                    end
                }
                
                if Flag then
                    ConfigSystem:RegisterFlag(Flag, function()
                        return key
                    end, function(newKey)
                        KeybindAPI:SetKey(newKey)
                    end)
                end
                
                return KeybindAPI
            end
            
            return Section
        end
        
        return Tab
    end
    
    function Window:CreateSettingsTab(options)
        options = options or {}
        local TabName = options.Name or "Settings"
        local TabIcon = options.Icon or "settings"
        
        local SettingsTab = self:CreateTab({Name = TabName, Icon = TabIcon})
        
        local AppearanceSection = SettingsTab:CreateSection({
            Name = "Appearance",
            Description = "Customize the look and feel"
        })
        
        AppearanceSection:CreateDropdown({
            Text = "Theme",
            Description = "Select a color theme",
            Icon = "palette",
            Items = self:GetThemes(),
            Default = self.CurrentTheme,
            Callback = function(theme)
                self:SetTheme(theme)
            end
        })
        
        AppearanceSection:CreateDropdown({
            Text = "Font",
            Description = "Select a font family",
            Icon = "type",
            Items = self:GetFonts(),
            Default = Config.CurrentFont,
            Callback = function(font)
                self:SetFont(font)
            end
        })
        
        AppearanceSection:CreateToggle({
            Text = "Transparency",
            Description = "Enable transparent background",
            Icon = "eye",
            Default = Config.Transparent,
            Callback = function(enabled)
                self:SetTransparency(enabled, Config.TransparencyValue)
            end
        })
        
        AppearanceSection:CreateSlider({
            Text = "Transparency Amount",
            Description = "Adjust background transparency",
            Icon = "sliders-horizontal",
            Min = 0,
            Max = 100,
            Default = Config.TransparencyValue * 100,
            Suffix = "%",
            Callback = function(value)
                self:SetTransparency(Config.Transparent, value / 100)
            end
        })
        
        local ConfigSection = SettingsTab:CreateSection({
            Name = "Configuration",
            Description = "Save and load your settings"
        })
        
        local ConfigNameInput
        local ConfigDropdown
        
        local function RefreshConfigs()
            local configs = ConfigSystem:ListConfigs()
            if ConfigDropdown then
                ConfigDropdown:SetItems(configs)
            end
            return configs
        end
        
        ConfigNameInput = ConfigSection:CreateInput({
            Text = "Config Name",
            Description = "Enter a name for your config",
            Icon = "file-text",
            Placeholder = "my_config",
            Callback = function() end
        })
        
        ConfigSection:CreateButton({
            Text = "Create Config",
            Description = "Save current settings to a new config",
            Icon = "save",
            Callback = function()
                local name = ConfigNameInput:GetText()
                if name and name ~= "" then
                    if ConfigSystem:Save(name) then
                        Window:Notify({
                            Title = "Config Saved",
                            Content = "Successfully saved config: " .. name,
                            Duration = 3,
                            Type = "Success"
                        })
                        RefreshConfigs()
                    else
                        Window:Notify({
                            Title = "Error",
                            Content = "Failed to save config",
                            Duration = 3,
                            Type = "Error"
                        })
                    end
                else
                    Window:Notify({
                        Title = "Error",
                        Content = "Please enter a config name",
                        Duration = 3,
                        Type = "Warning"
                    })
                end
            end
        })
        
        ConfigDropdown = ConfigSection:CreateDropdown({
            Text = "Select Config",
            Description = "Choose a config to manage",
            Icon = "folder",
            Items = ConfigSystem:ListConfigs(),
            Callback = function() end
        })
        
        ConfigSection:CreateButton({
            Text = "Load Config",
            Description = "Load the selected config",
            Icon = "download",
            Callback = function()
                local selected = ConfigDropdown:GetValue()
                if selected then
                    if ConfigSystem:Load(selected) then
                        Window:Notify({
                            Title = "Config Loaded",
                            Content = "Successfully loaded: " .. selected,
                            Duration = 3,
                            Type = "Success"
                        })
                    end
                end
            end
        })
        
        ConfigSection:CreateButton({
            Text = "Delete Config",
            Description = "Delete the selected config",
            Icon = "trash-2",
            Callback = function()
                local selected = ConfigDropdown:GetValue()
                if selected then
                    if ConfigSystem:Delete(selected) then
                        Window:Notify({
                            Title = "Config Deleted",
                            Content = "Successfully deleted: " .. selected,
                            Duration = 3,
                            Type = "Success"
                        })
                        RefreshConfigs()
                    end
                end
            end
        })
        
        ConfigSection:CreateButton({
            Text = "Refresh Configs",
            Description = "Refresh the config list",
            Icon = "refresh-cw",
            Callback = function()
                RefreshConfigs()
                Window:Notify({
                    Title = "Refreshed",
                    Content = "Config list has been refreshed",
                    Duration = 2,
                    Type = "Info"
                })
            end
        })
        
        local UtilitySection = SettingsTab:CreateSection({
            Name = "Utility",
            Description = "Useful features"
        })
        
        local antiAFKConnection = nil
        
        UtilitySection:CreateToggle({
            Text = "Anti-AFK",
            Description = "Prevents the game from kicking you for being idle",
            Icon = "shield",
            Default = false,
            Callback = function(enabled)
                if enabled then
                    local VirtualUser = game:GetService("VirtualUser")
                    local LocalPlayer = Players.LocalPlayer
                    antiAFKConnection = LocalPlayer.Idled:Connect(function()
                        VirtualUser:CaptureController()
                        VirtualUser:ClickButton2(Vector2.new())
                    end)
                    Window:Notify({
                        Title = "Anti-AFK Enabled",
                        Content = "You will no longer be kicked for inactivity",
                        Duration = 3,
                        Type = "Success"
                    })
                else
                    if antiAFKConnection then
                        antiAFKConnection:Disconnect()
                        antiAFKConnection = nil
                    end
                    Window:Notify({
                        Title = "Anti-AFK Disabled",
                        Content = "Anti-AFK has been turned off",
                        Duration = 3,
                        Type = "Info"
                    })
                end
            end
        })
        
        return SettingsTab
    end
    
    function Window:Notify(options)
        options = options or {}
        local Title = options.Title or "Notification"
        local Content = options.Content or ""
        local Duration = options.Duration or 3
        local NotifIcon = options.Icon or "bell"
        local Type = options.Type or "Info"
        
        local TypeColors = {
            Info = Config.AccentColor,
            Success = Color3.fromRGB(74, 222, 128),
            Warning = Color3.fromRGB(251, 191, 36),
            Error = Color3.fromRGB(248, 113, 113)
        }
        
        local NotificationContainer = ScreenGui:FindFirstChild("NotificationContainer")
        if not NotificationContainer then
            NotificationContainer = Create("Frame", {
                Name = "NotificationContainer",
                BackgroundTransparency = 1,
                Size = UDim2.new(0, IsMobile and 280 or 320, 1, -20),
                Position = UDim2.new(1, IsMobile and -290 or -330, 0, 10),
                Parent = ScreenGui
            })
            Create("UIListLayout", {
                Padding = UDim.new(0, 8),
                VerticalAlignment = Enum.VerticalAlignment.Bottom,
                Parent = NotificationContainer
            })
        end
        
        local Notification = Create("Frame", {
            BackgroundColor3 = Config.SecondaryColor,
            Size = UDim2.new(1, 0, 0, IsMobile and 72 or 64),
            Parent = NotificationContainer
        })
        AddCorner(Notification, 10)
        AddShadow(Notification)
        
        local AccentBar = Create("Frame", {
            BackgroundColor3 = TypeColors[Type] or TypeColors.Info,
            Size = UDim2.new(0, 3, 1, -12),
            Position = UDim2.new(0, 6, 0, 6),
            Parent = Notification
        })
        AddCorner(AccentBar, 2)
        
        local NotifIconLabel = Create("ImageLabel", {
            BackgroundTransparency = 1,
            Image = GetIcon(NotifIcon),
            ImageColor3 = TypeColors[Type] or TypeColors.Info,
            Size = UDim2.new(0, IsMobile and 20 or 18, 0, IsMobile and 20 or 18),
            Position = UDim2.new(0, 18, 0, IsMobile and 14 or 12),
            Parent = Notification
        })
        
        local TitleLabel = Create("TextLabel", {
            BackgroundTransparency = 1,
            Text = Title,
            TextColor3 = Config.TextColor,
            FontFace = Config.BoldFont,
            TextSize = IsMobile and 13 or 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            Position = UDim2.new(0, IsMobile and 46 or 44, 0, IsMobile and 10 or 8),
            Size = UDim2.new(1, IsMobile and -80 or -60, 0, 16),
            Parent = Notification
        })
        
        local ContentLabel = Create("TextLabel", {
            BackgroundTransparency = 1,
            Text = Content,
            TextColor3 = Config.SecondaryTextColor,
            FontFace = Config.Font,
            TextSize = IsMobile and 11 or 10,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            Position = UDim2.new(0, IsMobile and 46 or 44, 0, IsMobile and 28 or 26),
            Size = UDim2.new(1, IsMobile and -80 or -60, 0, 28),
            Parent = Notification
        })
        
        local ProgressBar = Create("Frame", {
            BackgroundColor3 = TypeColors[Type] or TypeColors.Info,
            Size = UDim2.new(1, -12, 0, 2),
            Position = UDim2.new(0, 6, 1, -8),
            Parent = Notification
        })
        AddCorner(ProgressBar, 1)
        
        local CloseNotif = Create("TextButton", {
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 24, 0, 24),
            Position = UDim2.new(1, -28, 0, 4),
            Text = "",
            Parent = Notification
        })
        
        local CloseIconLabel = Create("ImageLabel", {
            BackgroundTransparency = 1,
            Image = GetIcon("x"),
            ImageColor3 = Config.SecondaryTextColor,
            Size = UDim2.new(0, 12, 0, 12),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Parent = CloseNotif
        })
        
        local function DismissNotification()
            Tween(Notification, {Position = UDim2.new(1, 20, 0, 0)}, 0.2)
            task.delay(0.2, function()
                if Notification and Notification.Parent then
                    Notification:Destroy()
                end
            end)
        end
        
        CloseNotif.MouseButton1Click:Connect(DismissNotification)
        
        Notification.Position = UDim2.new(1, 20, 0, 0)
        Tween(Notification, {Position = UDim2.new(0, 0, 0, 0)}, 0.2)
        Tween(ProgressBar, {Size = UDim2.new(0, 0, 0, 2)}, Duration)
        
        task.delay(Duration, function()
            if Notification and Notification.Parent then
                DismissNotification()
            end
        end)
    end
    
    function Window:CreateDialog(options)
        options = options or {}
        local Title = options.Title or "Dialog"
        local Content = options.Content or "Are you sure?"
        local Buttons = options.Buttons or {
            {Text = "Confirm", Callback = function() end},
            {Text = "Cancel", Callback = function() end}
        }
        
        local DialogOverlay = Create("Frame", {
            Name = "DialogOverlay",
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            ZIndex = 500,
            Parent = ScreenGui
        })
        
        local Dialog = Create("Frame", {
            Name = "Dialog",
            BackgroundColor3 = Config.SecondaryColor,
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            ClipsDescendants = true,
            ZIndex = 501,
            Parent = DialogOverlay
        })
        AddCorner(Dialog, 12)
        AddShadow(Dialog)
        
        local dialogWidth = IsMobile and 300 or 340
        local dialogHeight = 150
        
        local DialogTitle = Create("TextLabel", {
            Name = "Title",
            BackgroundTransparency = 1,
            Text = Title,
            TextColor3 = Config.TextColor,
            FontFace = Config.BoldFont,
            TextSize = IsMobile and 15 or 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            Position = UDim2.new(0, 20, 0, 18),
            Size = UDim2.new(1, -40, 0, 20),
            ZIndex = 502,
            Parent = Dialog
        })
        
        local DialogContent = Create("TextLabel", {
            Name = "Content",
            BackgroundTransparency = 1,
            Text = Content,
            TextColor3 = Config.SecondaryTextColor,
            FontFace = Config.Font,
            TextSize = IsMobile and 12 or 11,
            TextWrapped = true,
            TextYAlignment = Enum.TextYAlignment.Top,
            TextXAlignment = Enum.TextXAlignment.Left,
            Position = UDim2.new(0, 20, 0, 44),
            Size = UDim2.new(1, -40, 0, 44),
            ZIndex = 502,
            Parent = Dialog
        })
        
        local ButtonContainer = Create("Frame", {
            Name = "Buttons",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -40, 0, IsMobile and 36 or 32),
            Position = UDim2.new(0, 20, 1, IsMobile and -52 or -48),
            ZIndex = 502,
            Parent = Dialog
        })
        
        Create("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            Padding = UDim.new(0, 8),
            Parent = ButtonContainer
        })
        
        local closing = false
        
        local function CloseDialog(callback)
            if closing then return end
            closing = true
            Tween(DialogOverlay, {BackgroundTransparency = 1}, 0.15)
            Tween(Dialog, {Size = UDim2.new(0, 0, 0, 0)}, 0.15)
            task.delay(0.15, function()
                if DialogOverlay and DialogOverlay.Parent then
                    DialogOverlay:Destroy()
                end
                if callback then
                    task.spawn(callback)
                end
            end)
        end
        
        for i = #Buttons, 1, -1 do
            local info = Buttons[i]
            local isPrimary = i == 1
            
            local Button = Create("TextButton", {
                Name = "Button" .. i,
                BackgroundColor3 = isPrimary and Config.AccentColor or Config.MainColor,
                Size = UDim2.new(0, IsMobile and 80 or 76, 1, 0),
                Text = info.Text or "Button",
                TextColor3 = isPrimary and Config.MainColor or Config.TextColor,
                FontFace = Config.Font,
                TextSize = IsMobile and 12 or 11,
                AutoButtonColor = false,
                ZIndex = 503,
                Parent = ButtonContainer
            })
            AddCorner(Button, 8)
            
            Button.MouseButton1Click:Connect(function()
                CloseDialog(info.Callback)
            end)
            
            Button.MouseEnter:Connect(function()
                if isPrimary then
                    Tween(Button, {BackgroundColor3 = Config.TextColor})
                else
                    Tween(Button, {BackgroundColor3 = Config.BorderColor})
                end
            end)
            
            Button.MouseLeave:Connect(function()
                if isPrimary then
                    Tween(Button, {BackgroundColor3 = Config.AccentColor})
                else
                    Tween(Button, {BackgroundColor3 = Config.MainColor})
                end
            end)
        end
        
        DialogOverlay.InputBegan:Connect(function(input)
            if closing then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                task.defer(function()
                    if closing then return end
                    local mousePos = UserInputService:GetMouseLocation()
                    local dialogPos = Dialog.AbsolutePosition
                    local dialogSize = Dialog.AbsoluteSize
                    local outside = mousePos.X < dialogPos.X or mousePos.X > dialogPos.X + dialogSize.X or mousePos.Y < dialogPos.Y or mousePos.Y > dialogPos.Y + dialogSize.Y
                    if outside and dialogSize.X > 10 then
                        CloseDialog()
                    end
                end)
            end
        end)
        
        task.defer(function()
            Tween(DialogOverlay, {BackgroundTransparency = 0.5}, 0.15)
            Tween(Dialog, {Size = UDim2.new(0, dialogWidth, 0, dialogHeight)}, 0.2)
        end)
    end
    
    function Window:Toggle()
        MainFrame.Visible = not MainFrame.Visible
        if MobileToggle then
            local mobileIcon = MobileToggle:FindFirstChild("ImageLabel", true)
            if mobileIcon then
                mobileIcon.Image = MainFrame.Visible and GetIcon("x") or GetIcon("menu")
            end
        end
    end
    
    function Window:Destroy()
        ScreenGui:Destroy()
    end
    
    function Window:SaveConfig(name)
        return ConfigSystem:Save(name)
    end
    
    function Window:LoadConfig(name)
        return ConfigSystem:Load(name)
    end
    
    function Window:GetConfigs()
        return ConfigSystem:ListConfigs()
    end
    
    return Window
end

return Library 
