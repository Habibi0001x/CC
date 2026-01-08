
--[[
    Advanced UI Library v4.0
    
    Features:
    - Mobile Detection & Support
    - Buttons, Dropdowns (Single & Multi), Toggles, Sliders, ColorPickers, Inputs
    - Sections, Labels, Paragraphs, Dividers
    - Element Descriptions
    - Lockable Elements
    - Transparency Settings
    - Resizable Windows
    - Multiple Themes (Dark, Light, Sky Blue, Ocean, Purple, Rose, Forest, Sunset)
    - Tab & Section Dividers
    - Uses CoreGui with cloneref for undetection
    - Lucide Icon Support
]]

-- CloneRef implementation for security
local cloneref = cloneref or function(instance)
    return instance
end

-- Services (cloned for undetection)
local Players = cloneref(game:GetService("Players"))
local CoreGui = cloneref(game:GetService("CoreGui"))
local TweenService = cloneref(game:GetService("TweenService"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local RunService = cloneref(game:GetService("RunService"))
local HttpService = cloneref(game:GetService("HttpService"))
local GuiService = cloneref(game:GetService("GuiService"))

-- Library Table
local Library = {}
Library.__index = Library

-- Mobile Detection
local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled

-- Themes
local Themes = {
    Dark = {
        MainColor = Color3.fromRGB(25, 25, 35),
        SecondaryColor = Color3.fromRGB(35, 35, 50),
        AccentColor = Color3.fromRGB(88, 101, 242),
        TextColor = Color3.fromRGB(255, 255, 255),
        SecondaryTextColor = Color3.fromRGB(180, 180, 190),
        BorderColor = Color3.fromRGB(50, 50, 65),
        ToggleOnColor = Color3.fromRGB(88, 101, 242),
        ToggleOffColor = Color3.fromRGB(60, 60, 75),
        LockedColor = Color3.fromRGB(80, 80, 90),
        LockedTextColor = Color3.fromRGB(120, 120, 130),
        DividerColor = Color3.fromRGB(60, 60, 75)
    },
    Light = {
        MainColor = Color3.fromRGB(245, 245, 250),
        SecondaryColor = Color3.fromRGB(235, 235, 240),
        AccentColor = Color3.fromRGB(88, 101, 242),
        TextColor = Color3.fromRGB(30, 30, 40),
        SecondaryTextColor = Color3.fromRGB(100, 100, 120),
        BorderColor = Color3.fromRGB(200, 200, 210),
        ToggleOnColor = Color3.fromRGB(88, 101, 242),
        ToggleOffColor = Color3.fromRGB(180, 180, 190),
        LockedColor = Color3.fromRGB(200, 200, 210),
        LockedTextColor = Color3.fromRGB(150, 150, 160),
        DividerColor = Color3.fromRGB(200, 200, 210)
    },
    SkyBlue = {
        MainColor = Color3.fromRGB(20, 30, 45),
        SecondaryColor = Color3.fromRGB(30, 45, 65),
        AccentColor = Color3.fromRGB(65, 165, 245),
        TextColor = Color3.fromRGB(255, 255, 255),
        SecondaryTextColor = Color3.fromRGB(170, 200, 220),
        BorderColor = Color3.fromRGB(50, 75, 100),
        ToggleOnColor = Color3.fromRGB(65, 165, 245),
        ToggleOffColor = Color3.fromRGB(50, 70, 90),
        LockedColor = Color3.fromRGB(60, 80, 100),
        LockedTextColor = Color3.fromRGB(100, 130, 160),
        DividerColor = Color3.fromRGB(50, 75, 100)
    },
    Ocean = {
        MainColor = Color3.fromRGB(15, 30, 40),
        SecondaryColor = Color3.fromRGB(20, 45, 60),
        AccentColor = Color3.fromRGB(0, 180, 180),
        TextColor = Color3.fromRGB(255, 255, 255),
        SecondaryTextColor = Color3.fromRGB(150, 200, 200),
        BorderColor = Color3.fromRGB(30, 70, 85),
        ToggleOnColor = Color3.fromRGB(0, 180, 180),
        ToggleOffColor = Color3.fromRGB(40, 70, 80),
        LockedColor = Color3.fromRGB(50, 80, 90),
        LockedTextColor = Color3.fromRGB(80, 130, 140),
        DividerColor = Color3.fromRGB(30, 70, 85)
    },
    Purple = {
        MainColor = Color3.fromRGB(30, 20, 40),
        SecondaryColor = Color3.fromRGB(45, 30, 60),
        AccentColor = Color3.fromRGB(160, 90, 220),
        TextColor = Color3.fromRGB(255, 255, 255),
        SecondaryTextColor = Color3.fromRGB(200, 180, 220),
        BorderColor = Color3.fromRGB(70, 50, 90),
        ToggleOnColor = Color3.fromRGB(160, 90, 220),
        ToggleOffColor = Color3.fromRGB(60, 45, 75),
        LockedColor = Color3.fromRGB(70, 55, 85),
        LockedTextColor = Color3.fromRGB(120, 100, 140),
        DividerColor = Color3.fromRGB(70, 50, 90)
    },
    Rose = {
        MainColor = Color3.fromRGB(35, 20, 25),
        SecondaryColor = Color3.fromRGB(50, 30, 40),
        AccentColor = Color3.fromRGB(230, 80, 120),
        TextColor = Color3.fromRGB(255, 255, 255),
        SecondaryTextColor = Color3.fromRGB(220, 180, 190),
        BorderColor = Color3.fromRGB(80, 50, 60),
        ToggleOnColor = Color3.fromRGB(230, 80, 120),
        ToggleOffColor = Color3.fromRGB(70, 45, 55),
        LockedColor = Color3.fromRGB(80, 55, 65),
        LockedTextColor = Color3.fromRGB(140, 100, 110),
        DividerColor = Color3.fromRGB(80, 50, 60)
    },
    Forest = {
        MainColor = Color3.fromRGB(20, 30, 20),
        SecondaryColor = Color3.fromRGB(30, 45, 30),
        AccentColor = Color3.fromRGB(80, 180, 80),
        TextColor = Color3.fromRGB(255, 255, 255),
        SecondaryTextColor = Color3.fromRGB(180, 210, 180),
        BorderColor = Color3.fromRGB(50, 75, 50),
        ToggleOnColor = Color3.fromRGB(80, 180, 80),
        ToggleOffColor = Color3.fromRGB(50, 70, 50),
        LockedColor = Color3.fromRGB(60, 80, 60),
        LockedTextColor = Color3.fromRGB(100, 140, 100),
        DividerColor = Color3.fromRGB(50, 75, 50)
    },
    Sunset = {
        MainColor = Color3.fromRGB(35, 25, 20),
        SecondaryColor = Color3.fromRGB(50, 35, 30),
        AccentColor = Color3.fromRGB(255, 120, 50),
        TextColor = Color3.fromRGB(255, 255, 255),
        SecondaryTextColor = Color3.fromRGB(220, 190, 170),
        BorderColor = Color3.fromRGB(80, 60, 50),
        ToggleOnColor = Color3.fromRGB(255, 120, 50),
        ToggleOffColor = Color3.fromRGB(70, 55, 45),
        LockedColor = Color3.fromRGB(80, 65, 55),
        LockedTextColor = Color3.fromRGB(140, 115, 100),
        DividerColor = Color3.fromRGB(80, 60, 50)
    },
    Midnight = {
        MainColor = Color3.fromRGB(10, 10, 20),
        SecondaryColor = Color3.fromRGB(20, 20, 35),
        AccentColor = Color3.fromRGB(100, 100, 255),
        TextColor = Color3.fromRGB(255, 255, 255),
        SecondaryTextColor = Color3.fromRGB(150, 150, 180),
        BorderColor = Color3.fromRGB(40, 40, 60),
        ToggleOnColor = Color3.fromRGB(100, 100, 255),
        ToggleOffColor = Color3.fromRGB(40, 40, 55),
        LockedColor = Color3.fromRGB(50, 50, 65),
        LockedTextColor = Color3.fromRGB(90, 90, 110),
        DividerColor = Color3.fromRGB(40, 40, 60)
    },
    Aqua = {
        MainColor = Color3.fromRGB(15, 35, 35),
        SecondaryColor = Color3.fromRGB(25, 50, 50),
        AccentColor = Color3.fromRGB(0, 220, 200),
        TextColor = Color3.fromRGB(255, 255, 255),
        SecondaryTextColor = Color3.fromRGB(150, 220, 210),
        BorderColor = Color3.fromRGB(40, 80, 75),
        ToggleOnColor = Color3.fromRGB(0, 220, 200),
        ToggleOffColor = Color3.fromRGB(35, 65, 60),
        LockedColor = Color3.fromRGB(45, 75, 70),
        LockedTextColor = Color3.fromRGB(80, 140, 130),
        DividerColor = Color3.fromRGB(40, 80, 75)
    }
}

-- Default Configuration
local Config = {
    Theme = "Dark",
    Font = Enum.Font.GothamMedium,
    TweenSpeed = 0.2,
    Transparent = false,
    TransparencyValue = 0.3,
    MobileScale = 1.1,
    MobileTouchSize = 44
}

-- Apply theme to config
local function ApplyTheme(themeName)
    local theme = Themes[themeName] or Themes.Dark
    for key, value in pairs(theme) do
        Config[key] = value
    end
    Config.Theme = themeName
end

ApplyTheme("Dark")

-- Lucide Icons
local LucideIcons = {
    Home = "rbxassetid://7733960981",
    Settings = "rbxassetid://7734053495",
    User = "rbxassetid://7734068614",
    Search = "rbxassetid://7734053495",
    Menu = "rbxassetid://7733717447",
    X = "rbxassetid://7743878857",
    ChevronDown = "rbxassetid://7733715400",
    ChevronUp = "rbxassetid://7733715315",
    ChevronRight = "rbxassetid://7733715230",
    ChevronLeft = "rbxassetid://7733715548",
    Check = "rbxassetid://7733715076",
    Circle = "rbxassetid://7733658708",
    Square = "rbxassetid://7734056832",
    Minimize = "rbxassetid://7733717447",
    Maximize = "rbxassetid://7733717890",
    Eye = "rbxassetid://7733685814",
    EyeOff = "rbxassetid://7733685542",
    Lock = "rbxassetid://7733704151",
    Unlock = "rbxassetid://7734062968",
    Bell = "rbxassetid://7733658504",
    Star = "rbxassetid://7734056531",
    Heart = "rbxassetid://7733693132",
    Trash = "rbxassetid://7734062083",
    Edit = "rbxassetid://7733680183",
    Copy = "rbxassetid://7733672099",
    Save = "rbxassetid://7734042553",
    Download = "rbxassetid://7733679348",
    Upload = "rbxassetid://7734065042",
    Folder = "rbxassetid://7733688164",
    File = "rbxassetid://7733685101",
    Image = "rbxassetid://7733697276",
    Play = "rbxassetid://7733992450",
    Pause = "rbxassetid://7733989534",
    Stop = "rbxassetid://7734058337",
    Volume = "rbxassetid://7734072792",
    VolumeOff = "rbxassetid://7734072525",
    Zap = "rbxassetid://7734076629",
    Shield = "rbxassetid://7734048384",
    Target = "rbxassetid://7734060159",
    Crosshair = "rbxassetid://7733673041",
    Navigation = "rbxassetid://7733960981",
    Resize = "rbxassetid://7734042553",
    Grip = "rbxassetid://7733717447",
    Info = "rbxassetid://7733697276",
    AlertCircle = "rbxassetid://7733658504",
    CheckCircle = "rbxassetid://7733715076",
    XCircle = "rbxassetid://7743878857",
    Palette = "rbxassetid://7733697276",
    Sliders = "rbxassetid://7734053495",
    MoreHorizontal = "rbxassetid://7733717447",
    Minus = "rbxassetid://7733717447"
}

-- Utility Functions
local function Create(className, properties)
    local instance = Instance.new(className)
    for prop, value in pairs(properties) do
        if prop ~= "Parent" then
            instance[prop] = value
        end
    end
    if properties.Parent then
        instance.Parent = properties.Parent
    end
    return instance
end

local function Tween(instance, properties, duration)
    duration = duration or Config.TweenSpeed
    local tween = TweenService:Create(instance, TweenInfo.new(duration, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), properties)
    tween:Play()
    return tween
end

local function AddCorner(instance, radius)
    return Create("UICorner", {
        CornerRadius = UDim.new(0, radius or 6),
        Parent = instance
    })
end

local function AddStroke(instance, color, thickness)
    return Create("UIStroke", {
        Color = color or Config.BorderColor,
        Thickness = thickness or 1,
        Parent = instance
    })
end

local function AddPadding(instance, top, bottom, left, right)
    return Create("UIPadding", {
        PaddingTop = UDim.new(0, top or 0),
        PaddingBottom = UDim.new(0, bottom or 0),
        PaddingLeft = UDim.new(0, left or 0),
        PaddingRight = UDim.new(0, right or 0),
        Parent = instance
    })
end

local function AddShadow(instance)
    local shadow = Create("ImageLabel", {
        Name = "Shadow",
        BackgroundTransparency = 1,
        Image = "rbxassetid://5554236805",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.5,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(23, 23, 277, 277),
        Size = UDim2.new(1, 47, 1, 47),
        Position = UDim2.new(0, -23, 0, -23),
        ZIndex = -1,
        Parent = instance
    })
    return shadow
end

local function GetIcon(iconName)
    return LucideIcons[iconName] or LucideIcons.Circle
end

-- Dragging Function (Enhanced for Mobile)
local function MakeDraggable(frame, handle)
    handle = handle or frame
    local dragging, dragInput, dragStart, startPos
    
    local function UpdateDrag(input)
        if dragging then
            local delta = input.Position - dragStart
            local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            Tween(frame, {Position = newPos}, 0.05)
        end
    end
    
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
    
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            UpdateDrag(input)
        end
    end)
end

-- Resizable Function
local function MakeResizable(frame, handle, minSize, maxSize)
    local resizing = false
    local resizeStart, startSize
    
    minSize = minSize or Vector2.new(400, 300)
    maxSize = maxSize or Vector2.new(800, 600)
    
    local function UpdateResize(input)
        if resizing then
            local delta = input.Position - resizeStart
            local newWidth = math.clamp(startSize.X + delta.X, minSize.X, maxSize.X)
            local newHeight = math.clamp(startSize.Y + delta.Y, minSize.Y, maxSize.Y)
            Tween(frame, {Size = UDim2.new(0, newWidth, 0, newHeight)}, 0.02)
        end
    end
    
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
            UpdateResize(input)
        end
    end)
end

-- Ripple Effect
local function CreateRipple(parent)
    local ripple = Create("Frame", {
        Name = "Ripple",
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.7,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 0, 0, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ZIndex = 10,
        Parent = parent
    })
    AddCorner(ripple, 100)
    
    local size = math.max(parent.AbsoluteSize.X, parent.AbsoluteSize.Y) * 2
    Tween(ripple, {Size = UDim2.new(0, size, 0, size), BackgroundTransparency = 1}, 0.5)
    
    task.delay(0.5, function()
        ripple:Destroy()
    end)
end

-- Lock Overlay for elements
local function CreateLockOverlay(parent)
    local overlay = Create("Frame", {
        Name = "LockOverlay",
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.5,
        Size = UDim2.new(1, 0, 1, 0),
        ZIndex = 100,
        Visible = false,
        Parent = parent
    })
    AddCorner(overlay, 6)
    
    local lockIcon = Create("ImageLabel", {
        Name = "LockIcon",
        BackgroundTransparency = 1,
        Image = GetIcon("Lock"),
        ImageColor3 = Config.TextColor,
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -30, 0.5, -10),
        ZIndex = 101,
        Parent = overlay
    })
    
    return overlay
end

-- Create Description Label
local function CreateDescription(parent, text, yOffset)
    if not text or text == "" then return nil end
    
    local DescLabel = Create("TextLabel", {
        Name = "Description",
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Config.SecondaryTextColor,
        Font = Config.Font,
        TextSize = IsMobile and 11 or 10,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        Position = UDim2.new(0, 0, 0, yOffset),
        Size = UDim2.new(1, 0, 0, IsMobile and 16 or 14),
        Parent = parent
    })
    
    return DescLabel
end

-- Main Library Functions
function Library:CreateWindow(options)
    options = options or {}
    local title = options.Title or "UI Library"
    local description = options.Description or ""
    local icon = options.Icon or "Zap"
    local theme = options.Theme or "Dark"
    local transparent = options.Transparent or false
    local transparencyValue = options.TransparencyValue or 0.3
    local size = options.Size or (IsMobile and UDim2.new(0, 420, 0, 350) or UDim2.new(0, 550, 0, 400))
    local position = options.Position or UDim2.new(0.5, 0, 0.5, 0)
    local minSize = options.MinSize or Vector2.new(400, 300)
    local maxSize = options.MaxSize or Vector2.new(900, 700)
    
    -- Apply theme
    ApplyTheme(theme)
    
    -- Update config
    Config.Transparent = transparent
    Config.TransparencyValue = transparencyValue
    
    -- Destroy existing UI
    local existingUI = CoreGui:FindFirstChild("AdvancedUILibrary")
    if existingUI then
        existingUI:Destroy()
    end
    
    -- Main ScreenGui
    local ScreenGui = Create("ScreenGui", {
        Name = "AdvancedUILibrary",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true,
        Parent = CoreGui
    })
    
    -- Main Frame
    local MainFrame = Create("Frame", {
        Name = "MainFrame",
        BackgroundColor3 = Config.MainColor,
        BackgroundTransparency = transparent and transparencyValue or 0,
        Size = size,
        Position = position,
        AnchorPoint = Vector2.new(0.5, 0.5),
        ClipsDescendants = true,
        Parent = ScreenGui
    })
    AddCorner(MainFrame, 10)
    AddShadow(MainFrame)
    
    -- Title Bar
    local TitleBar = Create("Frame", {
        Name = "TitleBar",
        BackgroundColor3 = Config.SecondaryColor,
        BackgroundTransparency = transparent and transparencyValue or 0,
        Size = UDim2.new(1, 0, 0, IsMobile and 60 or 50),
        BorderSizePixel = 0,
        Parent = MainFrame
    })
    AddCorner(TitleBar, 10)
    
    -- Fix corner overlap
    local TitleBarFix = Create("Frame", {
        Name = "CornerFix",
        BackgroundColor3 = Config.SecondaryColor,
        BackgroundTransparency = transparent and transparencyValue or 0,
        Size = UDim2.new(1, 0, 0, 15),
        Position = UDim2.new(0, 0, 1, -15),
        BorderSizePixel = 0,
        Parent = TitleBar
    })
    
    -- Icon
    local IconImage = Create("ImageLabel", {
        Name = "Icon",
        BackgroundTransparency = 1,
        Image = GetIcon(icon),
        ImageColor3 = Config.AccentColor,
        Size = UDim2.new(0, IsMobile and 28 or 24, 0, IsMobile and 28 or 24),
        Position = UDim2.new(0, 15, 0.5, IsMobile and -14 or -12),
        Parent = TitleBar
    })
    
    -- Title
    local TitleLabel = Create("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Config.TextColor,
        Font = Enum.Font.GothamBold,
        TextSize = IsMobile and 18 or 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        Size = UDim2.new(1, -120, 0, 20),
        Position = UDim2.new(0, IsMobile and 55 or 50, 0, IsMobile and 10 or 8),
        Parent = TitleBar
    })
    
    -- Description
    local DescLabel = Create("TextLabel", {
        Name = "Description",
        BackgroundTransparency = 1,
        Text = description,
        TextColor3 = Config.SecondaryTextColor,
        Font = Config.Font,
        TextSize = IsMobile and 13 or 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        Size = UDim2.new(1, -120, 0, 16),
        Position = UDim2.new(0, IsMobile and 55 or 50, 0, IsMobile and 32 or 28),
        Parent = TitleBar
    })
    
    -- Window Controls
    local ControlsFrame = Create("Frame", {
        Name = "Controls",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, IsMobile and 90 or 70, 0, IsMobile and 40 or 30),
        Position = UDim2.new(1, IsMobile and -100 or -80, 0.5, IsMobile and -20 or -15),
        Parent = TitleBar
    })
    
    local ControlsLayout = Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        Padding = UDim.new(0, 5),
        Parent = ControlsFrame
    })
    
    -- Minimize Button
    local MinimizeBtn = Create("TextButton", {
        Name = "Minimize",
        BackgroundColor3 = Config.BorderColor,
        Size = UDim2.new(0, IsMobile and 40 or 30, 0, IsMobile and 40 or 30),
        Text = "",
        Parent = ControlsFrame
    })
    AddCorner(MinimizeBtn, 6)
    
    local MinimizeIcon = Create("ImageLabel", {
        BackgroundTransparency = 1,
        Image = GetIcon("Minimize"),
        ImageColor3 = Config.TextColor,
        Size = UDim2.new(0, IsMobile and 20 or 16, 0, IsMobile and 20 or 16),
        Position = UDim2.new(0.5, IsMobile and -10 or -8, 0.5, IsMobile and -10 or -8),
        Parent = MinimizeBtn
    })
    
    -- Close Button
    local CloseBtn = Create("TextButton", {
        Name = "Close",
        BackgroundColor3 = Color3.fromRGB(220, 60, 60),
        Size = UDim2.new(0, IsMobile and 40 or 30, 0, IsMobile and 40 or 30),
        Text = "",
        Parent = ControlsFrame
    })
    AddCorner(CloseBtn, 6)
    
    local CloseIcon = Create("ImageLabel", {
        BackgroundTransparency = 1,
        Image = GetIcon("X"),
        ImageColor3 = Config.TextColor,
        Size = UDim2.new(0, IsMobile and 20 or 16, 0, IsMobile and 20 or 16),
        Position = UDim2.new(0.5, IsMobile and -10 or -8, 0.5, IsMobile and -10 or -8),
        Parent = CloseBtn
    })
    
    -- Tab Container
    local tabContainerWidth = IsMobile and 120 or 140
    local TabContainer = Create("Frame", {
        Name = "TabContainer",
        BackgroundColor3 = Config.SecondaryColor,
        BackgroundTransparency = transparent and transparencyValue or 0,
        Size = UDim2.new(0, tabContainerWidth, 1, IsMobile and -70 or -60),
        Position = UDim2.new(0, 5, 0, IsMobile and 65 or 55),
        Parent = MainFrame
    })
    AddCorner(TabContainer, 8)
    
    local TabScroll = Create("ScrollingFrame", {
        Name = "TabScroll",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -10, 1, -10),
        Position = UDim2.new(0, 5, 0, 5),
        ScrollBarThickness = IsMobile and 4 or 2,
        ScrollBarImageColor3 = Config.AccentColor,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = TabContainer
    })
    
    local TabLayout = Create("UIListLayout", {
        Padding = UDim.new(0, 5),
        Parent = TabScroll
    })
    
    -- Content Container
    local ContentContainer = Create("Frame", {
        Name = "ContentContainer",
        BackgroundColor3 = Config.SecondaryColor,
        BackgroundTransparency = transparent and transparencyValue or 0,
        Size = UDim2.new(1, -(tabContainerWidth + 20), 1, IsMobile and -70 or -60),
        Position = UDim2.new(0, tabContainerWidth + 10, 0, IsMobile and 65 or 55),
        Parent = MainFrame
    })
    AddCorner(ContentContainer, 8)
    
    -- Resize Handle
    local ResizeHandle = Create("TextButton", {
        Name = "ResizeHandle",
        BackgroundColor3 = Config.BorderColor,
        BackgroundTransparency = 0.5,
        Size = UDim2.new(0, IsMobile and 25 or 20, 0, IsMobile and 25 or 20),
        Position = UDim2.new(1, IsMobile and -25 or -20, 1, IsMobile and -25 or -20),
        Text = "",
        AutoButtonColor = false,
        ZIndex = 10,
        Parent = MainFrame
    })
    AddCorner(ResizeHandle, 4)
    
    local ResizeIcon = Create("ImageLabel", {
        BackgroundTransparency = 1,
        Image = GetIcon("Grip"),
        ImageColor3 = Config.SecondaryTextColor,
        Size = UDim2.new(0, 12, 0, 12),
        Position = UDim2.new(0.5, -6, 0.5, -6),
        Rotation = -45,
        ZIndex = 11,
        Parent = ResizeHandle
    })
    
    -- Make draggable and resizable
    MakeDraggable(MainFrame, TitleBar)
    MakeResizable(MainFrame, ResizeHandle, minSize, maxSize)
    
    -- Resize handle hover effect
    ResizeHandle.MouseEnter:Connect(function()
        Tween(ResizeHandle, {BackgroundTransparency = 0})
        Tween(ResizeIcon, {ImageColor3 = Config.TextColor})
    end)
    ResizeHandle.MouseLeave:Connect(function()
        Tween(ResizeHandle, {BackgroundTransparency = 0.5})
        Tween(ResizeIcon, {ImageColor3 = Config.SecondaryTextColor})
    end)
    
    -- Minimize functionality
    local isMinimized = false
    local originalSize = MainFrame.Size
    
    MinimizeBtn.MouseButton1Click:Connect(function()
        CreateRipple(MinimizeBtn)
        isMinimized = not isMinimized
        
        if isMinimized then
            originalSize = MainFrame.Size
            Tween(MainFrame, {Size = UDim2.new(0, originalSize.X.Offset, 0, IsMobile and 60 or 50)})
            TabContainer.Visible = false
            ContentContainer.Visible = false
            ResizeHandle.Visible = false
            MinimizeIcon.Image = GetIcon("Maximize")
        else
            Tween(MainFrame, {Size = originalSize})
            task.delay(0.2, function()
                TabContainer.Visible = true
                ContentContainer.Visible = true
                ResizeHandle.Visible = true
            end)
            MinimizeIcon.Image = GetIcon("Minimize")
        end
    end)
    
    -- Close functionality
    CloseBtn.MouseButton1Click:Connect(function()
        CreateRipple(CloseBtn)
        Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.3)
        task.delay(0.3, function()
            ScreenGui:Destroy()
        end)
    end)
    
    -- Hover effects
    MinimizeBtn.MouseEnter:Connect(function()
        Tween(MinimizeBtn, {BackgroundColor3 = Config.AccentColor})
    end)
    MinimizeBtn.MouseLeave:Connect(function()
        Tween(MinimizeBtn, {BackgroundColor3 = Config.BorderColor})
    end)
    
    CloseBtn.MouseEnter:Connect(function()
        Tween(CloseBtn, {BackgroundColor3 = Color3.fromRGB(255, 80, 80)})
    end)
    CloseBtn.MouseLeave:Connect(function()
        Tween(CloseBtn, {BackgroundColor3 = Color3.fromRGB(220, 60, 60)})
    end)
    
    -- Mobile Toggle Button
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
        
        local MobileToggleIcon = Create("ImageLabel", {
            BackgroundTransparency = 1,
            Image = GetIcon("Menu"),
            ImageColor3 = Config.TextColor,
            Size = UDim2.new(0, 24, 0, 24),
            Position = UDim2.new(0.5, -12, 0.5, -12),
            ZIndex = 101,
            Parent = MobileToggle
        })
        
        MobileToggle.MouseButton1Click:Connect(function()
            CreateRipple(MobileToggle)
            MainFrame.Visible = not MainFrame.Visible
            MobileToggleIcon.Image = MainFrame.Visible and GetIcon("X") or GetIcon("Menu")
        end)
        
        MakeDraggable(MobileToggle, MobileToggle)
    end
    
    -- Window object
    local Window = {}
    Window.Tabs = {}
    Window.ActiveTab = nil
    Window.ScreenGui = ScreenGui
    Window.MainFrame = MainFrame
    Window.Config = Config
    Window.IsMobile = IsMobile
    Window.ThemeObjects = {} -- Store objects to update on theme change
    
    -- Set Theme
    function Window:SetTheme(themeName)
        if not Themes[themeName] then return end
        
        ApplyTheme(themeName)
        
        -- Update main UI elements
        local trans = Config.Transparent and Config.TransparencyValue or 0
        
        Tween(MainFrame, {BackgroundColor3 = Config.MainColor, BackgroundTransparency = trans})
        Tween(TitleBar, {BackgroundColor3 = Config.SecondaryColor, BackgroundTransparency = trans})
        Tween(TitleBarFix, {BackgroundColor3 = Config.SecondaryColor, BackgroundTransparency = trans})
        Tween(TabContainer, {BackgroundColor3 = Config.SecondaryColor, BackgroundTransparency = trans})
        Tween(ContentContainer, {BackgroundColor3 = Config.SecondaryColor, BackgroundTransparency = trans})
        Tween(IconImage, {ImageColor3 = Config.AccentColor})
        Tween(TitleLabel, {TextColor3 = Config.TextColor})
        Tween(DescLabel, {TextColor3 = Config.SecondaryTextColor})
        Tween(MinimizeBtn, {BackgroundColor3 = Config.BorderColor})
        Tween(MinimizeIcon, {ImageColor3 = Config.TextColor})
        Tween(CloseIcon, {ImageColor3 = Config.TextColor})
        Tween(ResizeHandle, {BackgroundColor3 = Config.BorderColor})
        Tween(ResizeIcon, {ImageColor3 = Config.SecondaryTextColor})
        
        if MobileToggle then
            Tween(MobileToggle, {BackgroundColor3 = Config.AccentColor})
        end
        
        -- Update all registered theme objects
        for _, obj in pairs(Window.ThemeObjects) do
            if obj.UpdateTheme then
                obj:UpdateTheme()
            end
        end
    end
    
    -- Get available themes
    function Window:GetThemes()
        local themeNames = {}
        for name, _ in pairs(Themes) do
            table.insert(themeNames, name)
        end
        return themeNames
    end
    
    -- Set Transparency
    function Window:SetTransparency(enabled, value)
        Config.Transparent = enabled
        Config.TransparencyValue = value or Config.TransparencyValue
        
        local transparency = enabled and Config.TransparencyValue or 0
        
        Tween(MainFrame, {BackgroundTransparency = transparency})
        Tween(TitleBar, {BackgroundTransparency = transparency})
        Tween(TitleBarFix, {BackgroundTransparency = transparency})
        Tween(TabContainer, {BackgroundTransparency = transparency})
        Tween(ContentContainer, {BackgroundTransparency = transparency})
    end
    
    -- Create Tab Divider
    function Window:CreateTabDivider(options)
        options = options or {}
        local text = options.Text or ""
        
        local DividerFrame = Create("Frame", {
            Name = "TabDivider",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, text ~= "" and 25 or 15),
            Parent = TabScroll
        })
        
        if text ~= "" then
            local DividerLabel = Create("TextLabel", {
                BackgroundTransparency = 1,
                Text = text,
                TextColor3 = Config.SecondaryTextColor,
                Font = Enum.Font.GothamBold,
                TextSize = IsMobile and 11 or 10,
                TextXAlignment = Enum.TextXAlignment.Left,
                Position = UDim2.new(0, 5, 0, 0),
                Size = UDim2.new(1, -10, 0, 15),
                Parent = DividerFrame
            })
        end
        
        local DividerLine = Create("Frame", {
            BackgroundColor3 = Config.DividerColor,
            Size = UDim2.new(1, -10, 0, 1),
            Position = UDim2.new(0, 5, text ~= "" and 0.7 or 0.5, 0),
            Parent = DividerFrame
        })
        
        return DividerFrame
    end
    
    -- Create Tab
    function Window:CreateTab(options)
        options = options or {}
        local tabName = options.Name or "Tab"
        local tabIcon = options.Icon or "Circle"
        
        -- Tab Button
        local TabButton = Create("TextButton", {
            Name = tabName,
            BackgroundColor3 = Config.BorderColor,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, IsMobile and 44 or 35),
            Text = "",
            Parent = TabScroll
        })
        AddCorner(TabButton, 6)
        
        local TabIconImage = Create("ImageLabel", {
            BackgroundTransparency = 1,
            Image = GetIcon(tabIcon),
            ImageColor3 = Config.SecondaryTextColor,
            Size = UDim2.new(0, IsMobile and 22 or 18, 0, IsMobile and 22 or 18),
            Position = UDim2.new(0, 10, 0.5, IsMobile and -11 or -9),
            Parent = TabButton
        })
        
        local TabLabel = Create("TextLabel", {
            BackgroundTransparency = 1,
            Text = tabName,
            TextColor3 = Config.SecondaryTextColor,
            Font = Config.Font,
            TextSize = IsMobile and 14 or 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            Size = UDim2.new(1, -40, 1, 0),
            Position = UDim2.new(0, IsMobile and 40 or 35, 0, 0),
            Parent = TabButton
        })
        
        -- Content Page
        local ContentPage = Create("ScrollingFrame", {
            Name = tabName .. "Page",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -20, 1, -20),
            Position = UDim2.new(0, 10, 0, 10),
            ScrollBarThickness = IsMobile and 4 or 3,
            ScrollBarImageColor3 = Config.AccentColor,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible = false,
            Parent = ContentContainer
        })
        
        local ContentLayout = Create("UIListLayout", {
            Padding = UDim.new(0, 8),
            Parent = ContentPage
        })
        
        -- Tab selection
        local function SelectTab()
            for _, tab in pairs(Window.Tabs) do
                Tween(tab.Button, {BackgroundTransparency = 1})
                Tween(tab.Icon, {ImageColor3 = Config.SecondaryTextColor})
                Tween(tab.Label, {TextColor3 = Config.SecondaryTextColor})
                tab.Page.Visible = false
            end
            
            Tween(TabButton, {BackgroundTransparency = 0, BackgroundColor3 = Config.AccentColor})
            Tween(TabIconImage, {ImageColor3 = Config.TextColor})
            Tween(TabLabel, {TextColor3 = Config.TextColor})
            ContentPage.Visible = true
            Window.ActiveTab = tabName
        end
        
        TabButton.MouseButton1Click:Connect(function()
            CreateRipple(TabButton)
            SelectTab()
        end)
        
        TabButton.MouseEnter:Connect(function()
            if Window.ActiveTab ~= tabName then
                Tween(TabButton, {BackgroundTransparency = 0.5})
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if Window.ActiveTab ~= tabName then
                Tween(TabButton, {BackgroundTransparency = 1})
            end
        end)
        
        -- Tab object
        local Tab = {}
        Tab.Button = TabButton
        Tab.Icon = TabIconImage
        Tab.Label = TabLabel
        Tab.Page = ContentPage
        
        Window.Tabs[tabName] = Tab
        
        if not Window.ActiveTab then
            SelectTab()
        end
        
        -- Create Section Divider
        function Tab:CreateDivider(options)
            options = options or {}
            local text = options.Text or ""
            
            local DividerFrame = Create("Frame", {
                Name = "Divider",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, text ~= "" and 30 or 20),
                Parent = ContentPage
            })
            
            local DividerLine = Create("Frame", {
                BackgroundColor3 = Config.DividerColor,
                Size = UDim2.new(1, 0, 0, 1),
                Position = UDim2.new(0, 0, 0.5, 0),
                Parent = DividerFrame
            })
            
            if text ~= "" then
                local DividerLabel = Create("TextLabel", {
                    BackgroundColor3 = Config.SecondaryColor,
                    Text = "  " .. text .. "  ",
                    TextColor3 = Config.SecondaryTextColor,
                    Font = Enum.Font.GothamBold,
                    TextSize = IsMobile and 12 or 11,
                    Position = UDim2.new(0.5, 0, 0.5, 0),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Size = UDim2.new(0, 0, 0, 20),
                    AutomaticSize = Enum.AutomaticSize.X,
                    Parent = DividerFrame
                })
                AddCorner(DividerLabel, 4)
            end
            
            return DividerFrame
        end
        
        -- Section creator
        function Tab:CreateSection(options)
            options = options or {}
            local sectionName = options.Name or "Section"
            local sectionDesc = options.Description or ""
            
            local SectionFrame = Create("Frame", {
                Name = sectionName,
                BackgroundColor3 = Config.MainColor,
                BackgroundTransparency = Config.Transparent and Config.TransparencyValue or 0,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                Parent = ContentPage
            })
            AddCorner(SectionFrame, 8)
            AddStroke(SectionFrame, Config.BorderColor, 1)
            
            local headerHeight = sectionDesc ~= "" and (IsMobile and 50 or 45) or (IsMobile and 40 or 35)
            
            local SectionHeader = Create("Frame", {
                Name = "Header",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, headerHeight),
                Parent = SectionFrame
            })
            
            local SectionTitle = Create("TextLabel", {
                BackgroundTransparency = 1,
                Text = sectionName,
                TextColor3 = Config.TextColor,
                Font = Enum.Font.GothamBold,
                TextSize = IsMobile and 15 or 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Position = UDim2.new(0, 12, 0, 8),
                Size = UDim2.new(1, -24, 0, 20),
                Parent = SectionHeader
            })
            
            if sectionDesc ~= "" then
                local SectionDescLabel = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Text = sectionDesc,
                    TextColor3 = Config.SecondaryTextColor,
                    Font = Config.Font,
                    TextSize = IsMobile and 12 or 11,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2.new(0, 12, 0, 26),
                    Size = UDim2.new(1, -24, 0, 16),
                    Parent = SectionHeader
                })
            end
            
            local SectionContent = Create("Frame", {
                Name = "Content",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -20, 0, 0),
                Position = UDim2.new(0, 10, 0, headerHeight),
                AutomaticSize = Enum.AutomaticSize.Y,
                Parent = SectionFrame
            })
            
            local SectionLayout = Create("UIListLayout", {
                Padding = UDim.new(0, 8),
                Parent = SectionContent
            })
            
            Create("UIPadding", {
                PaddingBottom = UDim.new(0, 10),
                Parent = SectionContent
            })
            
            local Section = {}
            
            -- Create Divider within section
            function Section:CreateDivider(options)
                options = options or {}
                local text = options.Text or ""
                
                local DividerFrame = Create("Frame", {
                    Name = "SectionDivider",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, text ~= "" and 25 or 15),
                    Parent = SectionContent
                })
                
                local DividerLine = Create("Frame", {
                    BackgroundColor3 = Config.DividerColor,
                    Size = UDim2.new(1, 0, 0, 1),
                    Position = UDim2.new(0, 0, 0.5, 0),
                    Parent = DividerFrame
                })
                
                if text ~= "" then
                    local DividerLabel = Create("TextLabel", {
                        BackgroundColor3 = Config.MainColor,
                        Text = "  " .. text .. "  ",
                        TextColor3 = Config.SecondaryTextColor,
                        Font = Config.Font,
                        TextSize = IsMobile and 11 or 10,
                        Position = UDim2.new(0, 10, 0.5, 0),
                        AnchorPoint = Vector2.new(0, 0.5),
                        Size = UDim2.new(0, 0, 0, 18),
                        AutomaticSize = Enum.AutomaticSize.X,
                        Parent = DividerFrame
                    })
                    AddCorner(DividerLabel, 4)
                end
                
                return DividerFrame
            end
            
            -- Label
            function Section:CreateLabel(options)
                options = options or {}
                local text = options.Text or "Label"
                local icon = options.Icon
                local description = options.Description or ""
                
                local hasDesc = description ~= ""
                local frameHeight = hasDesc and (IsMobile and 40 or 35) or (IsMobile and 30 or 25)
                
                local LabelFrame = Create("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, frameHeight),
                    Parent = SectionContent
                })
                
                local xOffset = 0
                if icon then
                    Create("ImageLabel", {
                        BackgroundTransparency = 1,
                        Image = GetIcon(icon),
                        ImageColor3 = Config.AccentColor,
                        Size = UDim2.new(0, IsMobile and 20 or 16, 0, IsMobile and 20 or 16),
                        Position = UDim2.new(0, 0, 0, hasDesc and 2 or (IsMobile and 5 or 4)),
                        Parent = LabelFrame
                    })
                    xOffset = IsMobile and 26 or 22
                end
                
                local LabelText = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Text = text,
                    TextColor3 = Config.TextColor,
                    Font = Config.Font,
                    TextSize = IsMobile and 14 or 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2.new(0, xOffset, 0, 0),
                    Size = UDim2.new(1, -xOffset, 0, IsMobile and 22 or 18),
                    Parent = LabelFrame
                })
                
                if hasDesc then
                    CreateDescription(LabelFrame, description, IsMobile and 22 or 18)
                end
                
                local LabelObj = {}
                function LabelObj:SetText(newText)
                    LabelText.Text = newText
                end
                return LabelObj
            end
            
            -- Paragraph
            function Section:CreateParagraph(options)
                options = options or {}
                local title = options.Title or "Paragraph"
                local content = options.Content or "Content goes here..."
                
                local ParagraphFrame = Create("Frame", {
                    BackgroundColor3 = Config.SecondaryColor,
                    BackgroundTransparency = Config.Transparent and Config.TransparencyValue or 0,
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    Parent = SectionContent
                })
                AddCorner(ParagraphFrame, 6)
                
                local ParagraphTitle = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Text = title,
                    TextColor3 = Config.TextColor,
                    Font = Enum.Font.GothamBold,
                    TextSize = IsMobile and 14 or 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2.new(0, 10, 0, 8),
                    Size = UDim2.new(1, -20, 0, 18),
                    Parent = ParagraphFrame
                })
                
                local ParagraphContent = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Text = content,
                    TextColor3 = Config.SecondaryTextColor,
                    Font = Config.Font,
                    TextSize = IsMobile and 13 or 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextYAlignment = Enum.TextYAlignment.Top,
                    TextWrapped = true,
                    Position = UDim2.new(0, 10, 0, 28),
                    Size = UDim2.new(1, -20, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    Parent = ParagraphFrame
                })
                
                Create("UIPadding", {
                    PaddingBottom = UDim.new(0, 10),
                    Parent = ParagraphFrame
                })
                
                local ParagraphObj = {}
                function ParagraphObj:SetTitle(newTitle)
                    ParagraphTitle.Text = newTitle
                end
                function ParagraphObj:SetContent(newContent)
                    ParagraphContent.Text = newContent
                end
                return ParagraphObj
            end
            
            -- Button (with Lock support and Description)
            function Section:CreateButton(options)
                options = options or {}
                local text = options.Text or "Button"
                local icon = options.Icon
                local description = options.Description or ""
                local callback = options.Callback or function() end
                local locked = options.Locked or false
                local lockedText = options.LockedText or "Locked"
                
                local hasDesc = description ~= ""
                local frameHeight = hasDesc and (IsMobile and 58 or 50) or (IsMobile and 44 or 35)
                
                local ButtonFrame = Create("TextButton", {
                    BackgroundColor3 = locked and Config.LockedColor or Config.AccentColor,
                    Size = UDim2.new(1, 0, 0, frameHeight),
                    Text = "",
                    AutoButtonColor = false,
                    ClipsDescendants = true,
                    Parent = SectionContent
                })
                AddCorner(ButtonFrame, 6)
                
                local xOffset = 0
                local IconImg
                if icon then
                    IconImg = Create("ImageLabel", {
                        BackgroundTransparency = 1,
                        Image = GetIcon(locked and "Lock" or icon),
                        ImageColor3 = locked and Config.LockedTextColor or Config.TextColor,
                        Size = UDim2.new(0, IsMobile and 22 or 18, 0, IsMobile and 22 or 18),
                        Position = UDim2.new(0, 12, 0, hasDesc and 8 or (IsMobile and 11 or 8)),
                        Parent = ButtonFrame
                    })
                    xOffset = IsMobile and 26 or 22
                end
                
                local ButtonText = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Text = locked and lockedText or text,
                    TextColor3 = locked and Config.LockedTextColor or Config.TextColor,
                    Font = Config.Font,
                    TextSize = IsMobile and 15 or 14,
                    Position = UDim2.new(0, 12 + xOffset, 0, hasDesc and 6 or 0),
                    Size = UDim2.new(1, -24 - xOffset, 0, hasDesc and (IsMobile and 22 or 18) or frameHeight),
                    TextXAlignment = icon and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center,
                    Parent = ButtonFrame
                })
                
                local DescLabel
                if hasDesc then
                    DescLabel = Create("TextLabel", {
                        BackgroundTransparency = 1,
                        Text = description,
                        TextColor3 = locked and Config.LockedTextColor or Color3.fromRGB(200, 200, 210),
                        Font = Config.Font,
                        TextSize = IsMobile and 11 or 10,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Position = UDim2.new(0, 12 + xOffset, 0, IsMobile and 28 or 24),
                        Size = UDim2.new(1, -24 - xOffset, 0, IsMobile and 20 or 18),
                        Parent = ButtonFrame
                    })
                end
                
                local LockOverlay = CreateLockOverlay(ButtonFrame)
                
                local isLocked = locked
                
                ButtonFrame.MouseButton1Click:Connect(function()
                    if not isLocked then
                        CreateRipple(ButtonFrame)
                        callback()
                    end
                end)
                
                ButtonFrame.MouseEnter:Connect(function()
                    if not isLocked then
                        Tween(ButtonFrame, {BackgroundColor3 = Color3.fromRGB(
                            math.min(Config.AccentColor.R * 255 + 20, 255),
                            math.min(Config.AccentColor.G * 255 + 20, 255),
                            math.min(Config.AccentColor.B * 255 + 20, 255)
                        )})
                    end
                end)
                ButtonFrame.MouseLeave:Connect(function()
                    if not isLocked then
                        Tween(ButtonFrame, {BackgroundColor3 = Config.AccentColor})
                    end
                end)
                
                local ButtonObj = {}
                function ButtonObj:SetText(newText)
                    if not isLocked then
                        ButtonText.Text = newText
                    end
                end
                function ButtonObj:SetLocked(state, newLockedText)
                    isLocked = state
                    lockedText = newLockedText or lockedText
                    
                    if isLocked then
                        Tween(ButtonFrame, {BackgroundColor3 = Config.LockedColor})
                        ButtonText.Text = lockedText
                        ButtonText.TextColor3 = Config.LockedTextColor
                        if IconImg then
                            IconImg.Image = GetIcon("Lock")
                            IconImg.ImageColor3 = Config.LockedTextColor
                        end
                        if DescLabel then
                            DescLabel.TextColor3 = Config.LockedTextColor
                        end
                        LockOverlay.Visible = true
                    else
                        Tween(ButtonFrame, {BackgroundColor3 = Config.AccentColor})
                        ButtonText.Text = text
                        ButtonText.TextColor3 = Config.TextColor
                        if IconImg then
                            IconImg.Image = GetIcon(icon)
                            IconImg.ImageColor3 = Config.TextColor
                        end
                        if DescLabel then
                            DescLabel.TextColor3 = Color3.fromRGB(200, 200, 210)
                        end
                        LockOverlay.Visible = false
                    end
                end
                function ButtonObj:IsLocked()
                    return isLocked
                end
                return ButtonObj
            end
            
            -- Toggle (with Lock support and Description)
            function Section:CreateToggle(options)
                options = options or {}
                local text = options.Text or "Toggle"
                local default = options.Default or false
                local description = options.Description or ""
                local callback = options.Callback or function() end
                local icon = options.Icon
                local locked = options.Locked or false
                
                local hasDesc = description ~= ""
                local frameHeight = hasDesc and (IsMobile and 60 or 52) or (IsMobile and 50 or 40)
                
                local ToggleFrame = Create("Frame", {
                    BackgroundColor3 = Config.SecondaryColor,
                    BackgroundTransparency = Config.Transparent and Config.TransparencyValue or 0,
                    Size = UDim2.new(1, 0, 0, frameHeight),
                    Parent = SectionContent
                })
                AddCorner(ToggleFrame, 6)
                
                local xOffset = 0
                if icon then
                    Create("ImageLabel", {
                        BackgroundTransparency = 1,
                        Image = GetIcon(icon),
                        ImageColor3 = Config.AccentColor,
                        Size = UDim2.new(0, IsMobile and 22 or 18, 0, IsMobile and 22 or 18),
                        Position = UDim2.new(0, 10, 0, hasDesc and 10 or (IsMobile and 14 or 11)),
                        Parent = ToggleFrame
                    })
                    xOffset = IsMobile and 28 or 25
                end
                
                local ToggleLabel = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Text = text,
                    TextColor3 = locked and Config.LockedTextColor or Config.TextColor,
                    Font = Config.Font,
                    TextSize = IsMobile and 14 or 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2.new(0, 10 + xOffset, 0, hasDesc and 8 or 0),
                    Size = UDim2.new(1, -80 - xOffset, 0, hasDesc and (IsMobile and 22 or 18) or frameHeight),
                    Parent = ToggleFrame
                })
                
                if hasDesc then
                    Create("TextLabel", {
                        BackgroundTransparency = 1,
                        Text = description,
                        TextColor3 = Config.SecondaryTextColor,
                        Font = Config.Font,
                        TextSize = IsMobile and 11 or 10,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Position = UDim2.new(0, 10 + xOffset, 0, IsMobile and 30 or 26),
                        Size = UDim2.new(1, -80 - xOffset, 0, IsMobile and 20 or 18),
                        Parent = ToggleFrame
                    })
                end
                
                local ToggleButton = Create("TextButton", {
                    BackgroundColor3 = locked and Config.LockedColor or (default and Config.ToggleOnColor or Config.ToggleOffColor),
                    Size = UDim2.new(0, IsMobile and 52 or 44, 0, IsMobile and 28 or 24),
                    Position = UDim2.new(1, IsMobile and -62 or -54, 0.5, IsMobile and -14 or -12),
                    Text = "",
                    AutoButtonColor = false,
                    Parent = ToggleFrame
                })
                AddCorner(ToggleButton, IsMobile and 14 or 12)
                
                local ToggleCircle = Create("Frame", {
                    BackgroundColor3 = locked and Config.LockedTextColor or Config.TextColor,
                    Size = UDim2.new(0, IsMobile and 22 or 18, 0, IsMobile and 22 or 18),
                    Position = default and UDim2.new(1, IsMobile and -25 or -21, 0.5, IsMobile and -11 or -9) or UDim2.new(0, 3, 0.5, IsMobile and -11 or -9),
                    Parent = ToggleButton
                })
                AddCorner(ToggleCircle, IsMobile and 11 or 9)
                
                local LockOverlay = CreateLockOverlay(ToggleFrame)
                LockOverlay.Visible = locked
                
                local toggled = default
                local isLocked = locked
                
                local function UpdateToggle()
                    if isLocked then return end
                    
                    if toggled then
                        Tween(ToggleButton, {BackgroundColor3 = Config.ToggleOnColor})
                        Tween(ToggleCircle, {Position = UDim2.new(1, IsMobile and -25 or -21, 0.5, IsMobile and -11 or -9)})
                    else
                        Tween(ToggleButton, {BackgroundColor3 = Config.ToggleOffColor})
                        Tween(ToggleCircle, {Position = UDim2.new(0, 3, 0.5, IsMobile and -11 or -9)})
                    end
                    callback(toggled)
                end
                
                ToggleButton.MouseButton1Click:Connect(function()
                    if not isLocked then
                        toggled = not toggled
                        UpdateToggle()
                    end
                end)
                
                local ToggleObj = {}
                function ToggleObj:Set(value)
                    if not isLocked then
                        toggled = value
                        UpdateToggle()
                    end
                end
                function ToggleObj:Get()
                    return toggled
                end
                function ToggleObj:SetLocked(state)
                    isLocked = state
                    LockOverlay.Visible = state
                    
                    if state then
                        Tween(ToggleButton, {BackgroundColor3 = Config.LockedColor})
                        ToggleLabel.TextColor3 = Config.LockedTextColor
                        ToggleCircle.BackgroundColor3 = Config.LockedTextColor
                    else
                        ToggleLabel.TextColor3 = Config.TextColor
                        ToggleCircle.BackgroundColor3 = Config.TextColor
                        UpdateToggle()
                    end
                end
                function ToggleObj:IsLocked()
                    return isLocked
                end
                return ToggleObj
            end
            
            -- Slider (with Lock support and Description)
            function Section:CreateSlider(options)
                options = options or {}
                local text = options.Text or "Slider"
                local min = options.Min or 0
                local max = options.Max or 100
                local default = options.Default or min
                local increment = options.Increment or 1
                local description = options.Description or ""
                local callback = options.Callback or function() end
                local icon = options.Icon
                local locked = options.Locked or false
                local suffix = options.Suffix or ""
                
                local hasDesc = description ~= ""
                local frameHeight = hasDesc and (IsMobile and 78 or 68) or (IsMobile and 65 or 55)
                
                local SliderFrame = Create("Frame", {
                    BackgroundColor3 = Config.SecondaryColor,
                    BackgroundTransparency = Config.Transparent and Config.TransparencyValue or 0,
                    Size = UDim2.new(1, 0, 0, frameHeight),
                    Parent = SectionContent
                })
                AddCorner(SliderFrame, 6)
                
                local xOffset = 0
                if icon then
                    Create("ImageLabel", {
                        BackgroundTransparency = 1,
                        Image = GetIcon(icon),
                        ImageColor3 = Config.AccentColor,
                        Size = UDim2.new(0, IsMobile and 22 or 18, 0, IsMobile and 22 or 18),
                        Position = UDim2.new(0, 10, 0, IsMobile and 10 or 8),
                        Parent = SliderFrame
                    })
                    xOffset = IsMobile and 28 or 25
                end
                
                local SliderLabel = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Text = text,
                    TextColor3 = locked and Config.LockedTextColor or Config.TextColor,
                    Font = Config.Font,
                    TextSize = IsMobile and 14 or 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2.new(0, 10 + xOffset, 0, 5),
                    Size = UDim2.new(1, -80 - xOffset, 0, 20),
                    Parent = SliderFrame
                })
                
                local ValueLabel = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Text = tostring(default) .. suffix,
                    TextColor3 = locked and Config.LockedTextColor or Config.AccentColor,
                    Font = Enum.Font.GothamBold,
                    TextSize = IsMobile and 14 or 13,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    Position = UDim2.new(1, -60, 0, 5),
                    Size = UDim2.new(0, 50, 0, 20),
                    Parent = SliderFrame
                })
                
                local descOffset = 0
                if hasDesc then
                    Create("TextLabel", {
                        BackgroundTransparency = 1,
                        Text = description,
                        TextColor3 = Config.SecondaryTextColor,
                        Font = Config.Font,
                        TextSize = IsMobile and 11 or 10,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Position = UDim2.new(0, 10 + xOffset, 0, 23),
                        Size = UDim2.new(1, -20 - xOffset, 0, IsMobile and 16 or 14),
                        Parent = SliderFrame
                    })
                    descOffset = IsMobile and 12 or 10
                end
                
                local SliderBG = Create("Frame", {
                    BackgroundColor3 = locked and Config.LockedColor or Config.BorderColor,
                    Size = UDim2.new(1, -20, 0, IsMobile and 12 or 8),
                    Position = UDim2.new(0, 10, 0, (IsMobile and 40 or 35) + descOffset),
                    Parent = SliderFrame
                })
                AddCorner(SliderBG, IsMobile and 6 or 4)
                
                local SliderFill = Create("Frame", {
                    BackgroundColor3 = locked and Config.LockedTextColor or Config.AccentColor,
                    Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
                    Parent = SliderBG
                })
                AddCorner(SliderFill, IsMobile and 6 or 4)
                
                local SliderKnob = Create("Frame", {
                    BackgroundColor3 = locked and Config.LockedTextColor or Config.TextColor,
                    Size = UDim2.new(0, IsMobile and 20 or 16, 0, IsMobile and 20 or 16),
                    Position = UDim2.new((default - min) / (max - min), IsMobile and -10 or -8, 0.5, IsMobile and -10 or -8),
                    Parent = SliderBG
                })
                AddCorner(SliderKnob, IsMobile and 10 or 8)
                
                local LockOverlay = CreateLockOverlay(SliderFrame)
                LockOverlay.Visible = locked
                
                local currentValue = default
                local dragging = false
                local isLocked = locked
                             local function UpdateSlider(input)
                    if isLocked then return end
                    
                    local pos = math.clamp((input.Position.X - SliderBG.AbsolutePosition.X) / SliderBG.AbsoluteSize.X, 0, 1)
                    local value = min + (max - min) * pos
                    value = math.floor(value / increment + 0.5) * increment
                    value = math.clamp(value, min, max)
                    
                    currentValue = value
                    local percent = (value - min) / (max - min)
                    
                    Tween(SliderFill, {Size = UDim2.new(percent, 0, 1, 0)}, 0.05)
                    Tween(SliderKnob, {Position = UDim2.new(percent, IsMobile and -10 or -8, 0.5, IsMobile and -10 or -8)}, 0.05)
                    ValueLabel.Text = tostring(value) .. suffix
                    callback(value)
                end
                
                SliderBG.InputBegan:Connect(function(input)
                    if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not isLocked then
                        dragging = true
                        UpdateSlider(input)
                    end
                end)
                
                SliderBG.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and not isLocked and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        UpdateSlider(input)
                    end
                end)
                
                local SliderObj = {}
                function SliderObj:Set(value)
                    if not isLocked then
                        currentValue = math.clamp(value, min, max)
                        local percent = (currentValue - min) / (max - min)
                        Tween(SliderFill, {Size = UDim2.new(percent, 0, 1, 0)})
                        Tween(SliderKnob, {Position = UDim2.new(percent, IsMobile and -10 or -8, 0.5, IsMobile and -10 or -8)})
                        ValueLabel.Text = tostring(currentValue) .. suffix
                        callback(currentValue)
                    end
                end
                function SliderObj:Get()
                    return currentValue
                end
                function SliderObj:SetLocked(state)
                    isLocked = state
                    LockOverlay.Visible = state
                    
                    if state then
                        SliderLabel.TextColor3 = Config.LockedTextColor
                        ValueLabel.TextColor3 = Config.LockedTextColor
                        SliderBG.BackgroundColor3 = Config.LockedColor
                        SliderFill.BackgroundColor3 = Config.LockedTextColor
                        SliderKnob.BackgroundColor3 = Config.LockedTextColor
                    else
                        SliderLabel.TextColor3 = Config.TextColor
                        ValueLabel.TextColor3 = Config.AccentColor
                        SliderBG.BackgroundColor3 = Config.BorderColor
                        SliderFill.BackgroundColor3 = Config.AccentColor
                        SliderKnob.BackgroundColor3 = Config.TextColor
                    end
                end
                function SliderObj:IsLocked()
                    return isLocked
                end
                return SliderObj
            end
            
            -- Input (with Lock support and Description)
            function Section:CreateInput(options)
                options = options or {}
                local text = options.Text or "Input"
                local placeholder = options.Placeholder or "Enter text..."
                local default = options.Default or ""
                local description = options.Description or ""
                local callback = options.Callback or function() end
                local icon = options.Icon
                local locked = options.Locked or false
                local numeric = options.Numeric or false
                
                local hasDesc = description ~= ""
                local frameHeight = hasDesc and (IsMobile and 88 or 78) or (IsMobile and 75 or 65)
                
                local InputFrame = Create("Frame", {
                    BackgroundColor3 = Config.SecondaryColor,
                    BackgroundTransparency = Config.Transparent and Config.TransparencyValue or 0,
                    Size = UDim2.new(1, 0, 0, frameHeight),
                    Parent = SectionContent
                })
                AddCorner(InputFrame, 6)
                
                local xOffset = 0
                if icon then
                    Create("ImageLabel", {
                        BackgroundTransparency = 1,
                        Image = GetIcon(icon),
                        ImageColor3 = Config.AccentColor,
                        Size = UDim2.new(0, IsMobile and 22 or 18, 0, IsMobile and 22 or 18),
                        Position = UDim2.new(0, 10, 0, IsMobile and 10 or 8),
                        Parent = InputFrame
                    })
                    xOffset = IsMobile and 28 or 25
                end
                
                local InputLabel = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Text = text,
                    TextColor3 = locked and Config.LockedTextColor or Config.TextColor,
                    Font = Config.Font,
                    TextSize = IsMobile and 14 or 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2.new(0, 10 + xOffset, 0, 5),
                    Size = UDim2.new(1, -20 - xOffset, 0, 20),
                    Parent = InputFrame
                })
                
                local descOffset = 0
                if hasDesc then
                    Create("TextLabel", {
                        BackgroundTransparency = 1,
                        Text = description,
                        TextColor3 = Config.SecondaryTextColor,
                        Font = Config.Font,
                        TextSize = IsMobile and 11 or 10,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Position = UDim2.new(0, 10 + xOffset, 0, 23),
                        Size = UDim2.new(1, -20 - xOffset, 0, IsMobile and 16 or 14),
                        Parent = InputFrame
                    })
                    descOffset = IsMobile and 14 or 12
                end
                
                local TextBoxFrame = Create("Frame", {
                    BackgroundColor3 = locked and Config.LockedColor or Config.MainColor,
                    Size = UDim2.new(1, -20, 0, IsMobile and 36 or 30),
                    Position = UDim2.new(0, 10, 0, (IsMobile and 32 or 28) + descOffset),
                    Parent = InputFrame
                })
                AddCorner(TextBoxFrame, 6)
                AddStroke(TextBoxFrame, Config.BorderColor, 1)
                
                local TextBox = Create("TextBox", {
                    BackgroundTransparency = 1,
                    Text = default,
                    PlaceholderText = placeholder,
                    PlaceholderColor3 = Config.SecondaryTextColor,
                    TextColor3 = locked and Config.LockedTextColor or Config.TextColor,
                    Font = Config.Font,
                    TextSize = IsMobile and 14 or 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextEditable = not locked,
                    ClearTextOnFocus = false,
                    Size = UDim2.new(1, -16, 1, 0),
                    Position = UDim2.new(0, 8, 0, 0),
                    Parent = TextBoxFrame
                })
                
                local LockOverlay = CreateLockOverlay(InputFrame)
                LockOverlay.Visible = locked
                
                local isLocked = locked
                
                TextBox.FocusLost:Connect(function(enterPressed)
                    if not isLocked then
                        local text = TextBox.Text
                        if numeric then
                            text = tonumber(text) or 0
                            TextBox.Text = tostring(text)
                        end
                        callback(text, enterPressed)
                    end
                end)
                
                TextBox.Focused:Connect(function()
                    if not isLocked then
                        Tween(TextBoxFrame, {BackgroundColor3 = Config.SecondaryColor})
                    end
                end)
                
                TextBox.FocusLost:Connect(function()
                    if not isLocked then
                        Tween(TextBoxFrame, {BackgroundColor3 = Config.MainColor})
                    end
                end)
                
                local InputObj = {}
                function InputObj:SetText(newText)
                    if not isLocked then
                        TextBox.Text = tostring(newText)
                    end
                end
                function InputObj:GetText()
                    return TextBox.Text
                end
                function InputObj:SetLocked(state)
                    isLocked = state
                    LockOverlay.Visible = state
                    TextBox.TextEditable = not state
                    
                    if state then
                        InputLabel.TextColor3 = Config.LockedTextColor
                        TextBoxFrame.BackgroundColor3 = Config.LockedColor
                        TextBox.TextColor3 = Config.LockedTextColor
                    else
                        InputLabel.TextColor3 = Config.TextColor
                        TextBoxFrame.BackgroundColor3 = Config.MainColor
                        TextBox.TextColor3 = Config.TextColor
                    end
                end
                function InputObj:IsLocked()
                    return isLocked
                end
                return InputObj
            end
            
            -- Dropdown (Single & Multi Select with Lock support and Description)
            function Section:CreateDropdown(options)
                options = options or {}
                local text = options.Text or "Dropdown"
                local items = options.Items or {}
                local default = options.Default
                local multi = options.Multi or false
                local description = options.Description or ""
                local callback = options.Callback or function() end
                local icon = options.Icon
                local locked = options.Locked or false
                local maxVisible = options.MaxVisible or 5
                
                local hasDesc = description ~= ""
                local baseHeight = hasDesc and (IsMobile and 88 or 78) or (IsMobile and 75 or 65)
                
                local DropdownFrame = Create("Frame", {
                    BackgroundColor3 = Config.SecondaryColor,
                    BackgroundTransparency = Config.Transparent and Config.TransparencyValue or 0,
                    Size = UDim2.new(1, 0, 0, baseHeight),
                    ClipsDescendants = true,
                    Parent = SectionContent
                })
                AddCorner(DropdownFrame, 6)
                
                local xOffset = 0
                if icon then
                    Create("ImageLabel", {
                        BackgroundTransparency = 1,
                        Image = GetIcon(icon),
                        ImageColor3 = Config.AccentColor,
                        Size = UDim2.new(0, IsMobile and 22 or 18, 0, IsMobile and 22 or 18),
                        Position = UDim2.new(0, 10, 0, IsMobile and 10 or 8),
                        Parent = DropdownFrame
                    })
                    xOffset = IsMobile and 28 or 25
                end
                
                local DropdownLabel = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Text = text,
                    TextColor3 = locked and Config.LockedTextColor or Config.TextColor,
                    Font = Config.Font,
                    TextSize = IsMobile and 14 or 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2.new(0, 10 + xOffset, 0, 5),
                    Size = UDim2.new(1, -20 - xOffset, 0, 20),
                    Parent = DropdownFrame
                })
                
                local descOffset = 0
                if hasDesc then
                    Create("TextLabel", {
                        BackgroundTransparency = 1,
                        Text = description,
                        TextColor3 = Config.SecondaryTextColor,
                        Font = Config.Font,
                        TextSize = IsMobile and 11 or 10,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Position = UDim2.new(0, 10 + xOffset, 0, 23),
                        Size = UDim2.new(1, -20 - xOffset, 0, IsMobile and 16 or 14),
                        Parent = DropdownFrame
                    })
                    descOffset = IsMobile and 14 or 12
                end
                
                local DropdownButton = Create("TextButton", {
                    BackgroundColor3 = locked and Config.LockedColor or Config.MainColor,
                    Size = UDim2.new(1, -20, 0, IsMobile and 36 or 30),
                    Position = UDim2.new(0, 10, 0, (IsMobile and 32 or 28) + descOffset),
                    Text = "",
                    AutoButtonColor = false,
                    Parent = DropdownFrame
                })
                AddCorner(DropdownButton, 6)
                AddStroke(DropdownButton, Config.BorderColor, 1)
                
                -- Get display text for selection
                local function GetDisplayText()
                    if multi then
                        if type(default) == "table" and #default > 0 then
                            return table.concat(default, ", ")
                        end
                        return "Select..."
                    else
                        return default or "Select..."
                    end
                end
                
                local SelectedLabel = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Text = GetDisplayText(),
                    TextColor3 = (default and not locked) and Config.TextColor or Config.SecondaryTextColor,
                    Font = Config.Font,
                    TextSize = IsMobile and 14 or 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    Position = UDim2.new(0, 10, 0, 0),
                    Size = UDim2.new(1, -40, 1, 0),
                    Parent = DropdownButton
                })
                
                local ArrowIcon = Create("ImageLabel", {
                    BackgroundTransparency = 1,
                    Image = locked and GetIcon("Lock") or GetIcon("ChevronDown"),
                    ImageColor3 = locked and Config.LockedTextColor or Config.SecondaryTextColor,
                    Size = UDim2.new(0, IsMobile and 20 or 16, 0, IsMobile and 20 or 16),
                    Position = UDim2.new(1, IsMobile and -30 or -26, 0.5, IsMobile and -10 or -8),
                    Parent = DropdownButton
                })
                
                local optionHeight = IsMobile and 40 or 32
                local optionsYPos = (IsMobile and 73 or 63) + descOffset
                
                local OptionsContainer = Create("Frame", {
                    BackgroundColor3 = Config.MainColor,
                    Size = UDim2.new(1, -20, 0, 0),
                    Position = UDim2.new(0, 10, 0, optionsYPos),
                    ClipsDescendants = true,
                    Parent = DropdownFrame
                })
                AddCorner(OptionsContainer, 6)
                AddStroke(OptionsContainer, Config.BorderColor, 1)
                
                local OptionsScroll = Create("ScrollingFrame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    CanvasSize = UDim2.new(0, 0, 0, 0),
                    ScrollBarThickness = IsMobile and 4 or 3,
                    ScrollBarImageColor3 = Config.AccentColor,
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    Parent = OptionsContainer
                })
                
                local OptionsLayout = Create("UIListLayout", {
                    Padding = UDim.new(0, 2),
                    Parent = OptionsScroll
                })
                
                Create("UIPadding", {
                    PaddingTop = UDim.new(0, 4),
                    PaddingBottom = UDim.new(0, 4),
                    PaddingLeft = UDim.new(0, 4),
                    PaddingRight = UDim.new(0, 4),
                    Parent = OptionsScroll
                })
                
                local LockOverlay = CreateLockOverlay(DropdownFrame)
                LockOverlay.Visible = locked
                
                local isOpen = false
                local selected = multi and (type(default) == "table" and default or {}) or default
                local isLocked = locked
                local optionButtons = {}
                
                local function UpdateSelectedDisplay()
                    if multi then
                        if #selected > 0 then
                            SelectedLabel.Text = table.concat(selected, ", ")
                            SelectedLabel.TextColor3 = Config.TextColor
                        else
                            SelectedLabel.Text = "Select..."
                            SelectedLabel.TextColor3 = Config.SecondaryTextColor
                        end
                    else
                        if selected then
                            SelectedLabel.Text = selected
                            SelectedLabel.TextColor3 = Config.TextColor
                        else
                            SelectedLabel.Text = "Select..."
                            SelectedLabel.TextColor3 = Config.SecondaryTextColor
                        end
                    end
                end
                
                local function UpdateDropdownSize()
                    local itemCount = #items
                    local visibleCount = math.min(itemCount, maxVisible)
                    local contentHeight = (optionHeight * visibleCount) + 8
                    
                    if isOpen and not isLocked then
                        local newHeight = baseHeight + contentHeight + 5
                        Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, newHeight)})
                        Tween(OptionsContainer, {Size = UDim2.new(1, -20, 0, contentHeight)})
                        Tween(ArrowIcon, {Rotation = 180})
                    else
                        Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, baseHeight)})
                        Tween(OptionsContainer, {Size = UDim2.new(1, -20, 0, 0)})
                        Tween(ArrowIcon, {Rotation = 0})
                    end
                end
                
                local function IsSelected(item)
                    if multi then
                        return table.find(selected, item) ~= nil
                    else
                        return selected == item
                    end
                end
                
                local function UpdateOptionVisual(button, isItemSelected)
                    local checkmark = button:FindFirstChild("Checkmark")
                    if checkmark then
                        checkmark.Visible = isItemSelected
                    end
                    if isItemSelected then
                        Tween(button, {BackgroundColor3 = Config.AccentColor, BackgroundTransparency = 0.7})
                    else
                        Tween(button, {BackgroundColor3 = Config.SecondaryColor, BackgroundTransparency = 1})
                    end
                end
                
                local function CreateOption(item)
                    local OptionButton = Create("TextButton", {
                        Name = item,
                        BackgroundColor3 = Config.SecondaryColor,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, -8, 0, optionHeight - 4),
                        Text = "",
                        AutoButtonColor = false,
                        Parent = OptionsScroll
                    })
                    AddCorner(OptionButton, 4)
                    
                    local OptionLabel = Create("TextLabel", {
                        BackgroundTransparency = 1,
                        Text = item,
                        TextColor3 = Config.TextColor,
                        Font = Config.Font,
                        TextSize = IsMobile and 13 or 12,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Position = UDim2.new(0, 10, 0, 0),
                        Size = UDim2.new(1, multi and -40 or -20, 1, 0),
                        Parent = OptionButton
                    })
                    
                    if multi then
                        local Checkmark = Create("ImageLabel", {
                            Name = "Checkmark",
                            BackgroundTransparency = 1,
                            Image = GetIcon("Check"),
                            ImageColor3 = Config.AccentColor,
                            Size = UDim2.new(0, IsMobile and 18 or 14, 0, IsMobile and 18 or 14),
                            Position = UDim2.new(1, IsMobile and -28 or -24, 0.5, IsMobile and -9 or -7),
                            Visible = IsSelected(item),
                            Parent = OptionButton
                        })
                    end
                    
                    UpdateOptionVisual(OptionButton, IsSelected(item))
                    
                    OptionButton.MouseEnter:Connect(function()
                        if not IsSelected(item) then
                            Tween(OptionButton, {BackgroundTransparency = 0.5})
                        end
                    end)
                    
                    OptionButton.MouseLeave:Connect(function()
                        if not IsSelected(item) then
                            Tween(OptionButton, {BackgroundTransparency = 1})
                        end
                    end)
                    
                    OptionButton.MouseButton1Click:Connect(function()
                        if isLocked then return end
                        
                        if multi then
                            local index = table.find(selected, item)
                            if index then
                                table.remove(selected, index)
                            else
                                table.insert(selected, item)
                            end
                            UpdateOptionVisual(OptionButton, IsSelected(item))
                            UpdateSelectedDisplay()
                            callback(selected)
                        else
                            -- Deselect previous
                            for _, btn in pairs(optionButtons) do
                                UpdateOptionVisual(btn, false)
                            end
                            
                            selected = item
                            UpdateOptionVisual(OptionButton, true)
                            UpdateSelectedDisplay()
                            isOpen = false
                            UpdateDropdownSize()
                            callback(item)
                        end
                    end)
                    
                    optionButtons[item] = OptionButton
                    return OptionButton
                end
                
                -- Create initial options
                for _, item in ipairs(items) do
                    CreateOption(item)
                end
                
                DropdownButton.MouseButton1Click:Connect(function()
                    if not isLocked then
                        isOpen = not isOpen
                        UpdateDropdownSize()
                    end
                end)
                
                local DropdownObj = {}
                
                function DropdownObj:SetItems(newItems)
                    -- Clear existing
                    for _, btn in pairs(optionButtons) do
                        btn:Destroy()
                    end
                    optionButtons = {}
                    items = newItems
                    
                    -- Reset selection
                    if multi then
                        selected = {}
                    else
                        selected = nil
                    end
                    UpdateSelectedDisplay()
                    
                    -- Create new options
                    for _, item in ipairs(items) do
                        CreateOption(item)
                    end
                    
                    if isOpen then
                        UpdateDropdownSize()
                    end
                end
                
                function DropdownObj:AddItem(item)
                    if not table.find(items, item) then
                        table.insert(items, item)
                        CreateOption(item)
                        if isOpen then
                            UpdateDropdownSize()
                        end
                    end
                end
                
                function DropdownObj:RemoveItem(item)
                    local index = table.find(items, item)
                    if index then
                        table.remove(items, index)
                        if optionButtons[item] then
                            optionButtons[item]:Destroy()
                            optionButtons[item] = nil
                        end
                        
                        -- Remove from selection
                        if multi then
                            local selIndex = table.find(selected, item)
                            if selIndex then
                                table.remove(selected, selIndex)
                                UpdateSelectedDisplay()
                                callback(selected)
                            end
                        elseif selected == item then
                            selected = nil
                            UpdateSelectedDisplay()
                        end
                        
                        if isOpen then
                            UpdateDropdownSize()
                        end
                    end
                end
                
                function DropdownObj:SetValue(value)
                    if isLocked then return end
                    
                    if multi then
                        selected = type(value) == "table" and value or {value}
                        -- Update visuals
                        for item, btn in pairs(optionButtons) do
                            UpdateOptionVisual(btn, IsSelected(item))
                        end
                    else
                        -- Deselect previous
                        for _, btn in pairs(optionButtons) do
                            UpdateOptionVisual(btn, false)
                        end
                        selected = value
                        if optionButtons[value] then
                            UpdateOptionVisual(optionButtons[value], true)
                        end
                    end
                    UpdateSelectedDisplay()
                    callback(selected)
                end
                
                function DropdownObj:GetValue()
                    return selected
                end
                
                function DropdownObj:ClearSelection()
                    if isLocked then return end
                    
                    if multi then
                        selected = {}
                    else
                        selected = nil
                    end
                    
                    for _, btn in pairs(optionButtons) do
                        UpdateOptionVisual(btn, false)
                    end
                    UpdateSelectedDisplay()
                    callback(selected)
                end
                
                function DropdownObj:SetLocked(state)
                    isLocked = state
                    LockOverlay.Visible = state
                    
                    if state then
                        isOpen = false
                        UpdateDropdownSize()
                        DropdownLabel.TextColor3 = Config.LockedTextColor
                        DropdownButton.BackgroundColor3 = Config.LockedColor
                        SelectedLabel.TextColor3 = Config.LockedTextColor
                        ArrowIcon.Image = GetIcon("Lock")
                        ArrowIcon.ImageColor3 = Config.LockedTextColor
                    else
                        DropdownLabel.TextColor3 = Config.TextColor
                        DropdownButton.BackgroundColor3 = Config.MainColor
                        UpdateSelectedDisplay()
                        ArrowIcon.Image = GetIcon("ChevronDown")
                        ArrowIcon.ImageColor3 = Config.SecondaryTextColor
                    end
                end
                
                function DropdownObj:IsLocked()
                    return isLocked
                end
                
                return DropdownObj
            end
            
            -- ColorPicker (with Lock support and Description)
            function Section:CreateColorPicker(options)
                options = options or {}
                local text = options.Text or "Color Picker"
                local default = options.Default or Color3.fromRGB(255, 255, 255)
                local description = options.Description or ""
                local callback = options.Callback or function() end
                local icon = options.Icon
                local locked = options.Locked or false
                
                local hasDesc = description ~= ""
                local baseHeight = hasDesc and (IsMobile and 60 or 52) or (IsMobile and 50 or 40)
                
                local ColorPickerFrame = Create("Frame", {
                    BackgroundColor3 = Config.SecondaryColor,
                    BackgroundTransparency = Config.Transparent and Config.TransparencyValue or 0,
                    Size = UDim2.new(1, 0, 0, baseHeight),
                    ClipsDescendants = true,
                    Parent = SectionContent
                })
                AddCorner(ColorPickerFrame, 6)
                
                local xOffset = 0
                if icon then
                    Create("ImageLabel", {
                        BackgroundTransparency = 1,
                        Image = GetIcon(icon),
                        ImageColor3 = Config.AccentColor,
                        Size = UDim2.new(0, IsMobile and 22 or 18, 0, IsMobile and 22 or 18),
                        Position = UDim2.new(0, 10, 0, hasDesc and 10 or (IsMobile and 14 or 11)),
                        Parent = ColorPickerFrame
                    })
                    xOffset = IsMobile and 28 or 25
                end
                
                local ColorLabel = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Text = text,
                    TextColor3 = locked and Config.LockedTextColor or Config.TextColor,
                    Font = Config.Font,
                    TextSize = IsMobile and 14 or 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2.new(0, 10 + xOffset, 0, hasDesc and 8 or 0),
                    Size = UDim2.new(1, -80 - xOffset, 0, hasDesc and (IsMobile and 22 or 18) or baseHeight),
                    Parent = ColorPickerFrame
                })
                
                if hasDesc then
                    Create("TextLabel", {
                        BackgroundTransparency = 1,
                        Text = description,
                        TextColor3 = Config.SecondaryTextColor,
                        Font = Config.Font,
                        TextSize = IsMobile and 11 or 10,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Position = UDim2.new(0, 10 + xOffset, 0, IsMobile and 30 or 26),
                        Size = UDim2.new(1, -80 - xOffset, 0, IsMobile and 20 or 18),
                        Parent = ColorPickerFrame
                    })
                end
                
                local ColorPreview = Create("TextButton", {
                    BackgroundColor3 = locked and Config.LockedColor or default,
                    Size = UDim2.new(0, IsMobile and 60 or 50, 0, IsMobile and 30 or 24),
                    Position = UDim2.new(1, IsMobile and -70 or -60, 0.5, IsMobile and -15 or -12),
                    Text = "",
                    AutoButtonColor = false,
                    Parent = ColorPickerFrame
                })
                AddCorner(ColorPreview, 6)
                AddStroke(ColorPreview, Config.BorderColor, 1)
                
                -- Lock icon on preview
                local PreviewLockIcon = Create("ImageLabel", {
                    BackgroundTransparency = 1,
                    Image = GetIcon("Lock"),
                    ImageColor3 = Config.TextColor,
                    Size = UDim2.new(0, 16, 0, 16),
                    Position = UDim2.new(0.5, -8, 0.5, -8),
                    Visible = locked,
                    Parent = ColorPreview
                })
                
                -- Color Picker Panel
                local pickerHeight = IsMobile and 180 or 150
                local PickerPanel = Create("Frame", {
                    BackgroundColor3 = Config.MainColor,
                    Size = UDim2.new(1, -20, 0, pickerHeight),
                    Position = UDim2.new(0, 10, 0, baseHeight + 5),
                    Visible = false,
                    Parent = ColorPickerFrame
                })
                AddCorner(PickerPanel, 6)
                AddStroke(PickerPanel, Config.BorderColor, 1)
                
                -- Saturation/Value picker
                local SVPicker = Create("ImageLabel", {
                    BackgroundColor3 = Color3.fromRGB(255, 0, 0),
                    Size = UDim2.new(1, IsMobile and -70 or -60, 1, IsMobile and -50 or -40),
                    Position = UDim2.new(0, 5, 0, 5),
                    Image = "rbxassetid://4155801252",
                    Parent = PickerPanel
                })
                AddCorner(SVPicker, 4)
                
                local SVCursor = Create("Frame", {
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Size = UDim2.new(0, IsMobile and 16 or 12, 0, IsMobile and 16 or 12),
                    Position = UDim2.new(1, -6, 0, -6),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Parent = SVPicker
                })
                AddCorner(SVCursor, IsMobile and 8 or 6)
                AddStroke(SVCursor, Color3.fromRGB(0, 0, 0), 2)
                
                -- Hue slider
                local HueSlider = Create("Frame", {
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Size = UDim2.new(0, IsMobile and 25 or 20, 1, IsMobile and -50 or -40),
                    Position = UDim2.new(1, IsMobile and -60 or -50, 0, 5),
                    Parent = PickerPanel
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
                    Size = UDim2.new(1, 4, 0, IsMobile and 8 or 6),
                    Position = UDim2.new(0, -2, 0, -3),
                    Parent = HueSlider
                })
                AddCorner(HueCursor, 3)
                AddStroke(HueCursor, Color3.fromRGB(0, 0, 0), 1)
                
                -- Brightness slider
                local BrightnessSlider = Create("Frame", {
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Size = UDim2.new(0, IsMobile and 25 or 20, 1, IsMobile and -50 or -40),
                    Position = UDim2.new(1, IsMobile and -30 or -25, 0, 5),
                    Parent = PickerPanel
                })
                AddCorner(BrightnessSlider, 4)
                
                local BrightnessGradient = Create("UIGradient", {
                    Rotation = 90,
                    Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
                    }),
                    Parent = BrightnessSlider
                })
                
                local BrightnessCursor = Create("Frame", {
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Size = UDim2.new(1, 4, 0, IsMobile and 8 or 6),
                    Position = UDim2.new(0, -2, 0, -3),
                    Parent = BrightnessSlider
                })
                AddCorner(BrightnessCursor, 3)
                AddStroke(BrightnessCursor, Color3.fromRGB(0, 0, 0), 1)
                
                -- RGB/Hex inputs
                local InputFrame = Create("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -10, 0, IsMobile and 35 or 30),
                    Position = UDim2.new(0, 5, 1, IsMobile and -40 or -35),
                    Parent = PickerPanel
                })
                
                local InputLayout = Create("UIListLayout", {
                    FillDirection = Enum.FillDirection.Horizontal,
                    Padding = UDim.new(0, 5),
                    Parent = InputFrame
                })
                
                local function CreateColorInput(name, defaultVal)
                    local Container = Create("Frame", {
                        BackgroundColor3 = Config.SecondaryColor,
                        Size = UDim2.new(0, IsMobile and 50 or 42, 1, 0),
                        Parent = InputFrame
                    })
                    AddCorner(Container, 4)
                    
                    Create("TextLabel", {
                        BackgroundTransparency = 1,
                        Text = name,
                        TextColor3 = Config.SecondaryTextColor,
                        Font = Config.Font,
                        TextSize = IsMobile and 10 or 9,
                        Position = UDim2.new(0, 4, 0, 1),
                        Size = UDim2.new(0, 12, 0, 10),
                        Parent = Container
                    })
                    
                    local Input = Create("TextBox", {
                        BackgroundTransparency = 1,
                        Text = tostring(defaultVal),
                        TextColor3 = Config.TextColor,
                        Font = Config.Font,
                        TextSize = IsMobile and 11 or 10,
                        Position = UDim2.new(0, 4, 0, IsMobile and 12 or 10),
                        Size = UDim2.new(1, -8, 0, IsMobile and 18 or 16),
                        ClearTextOnFocus = true,
                        Parent = Container
                    })
                    
                    return Input
                end
                
                local RInput = CreateColorInput("R", math.floor(default.R * 255))
                local GInput = CreateColorInput("G", math.floor(default.G * 255))
                local BInput = CreateColorInput("B", math.floor(default.B * 255))
                
                -- Hex input
                local HexContainer = Create("Frame", {
                    BackgroundColor3 = Config.SecondaryColor,
                    Size = UDim2.new(1, -(IsMobile and 170 or 145), 1, 0),
                    Parent = InputFrame
                })
                AddCorner(HexContainer, 4)
                
                Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Text = "#",
                    TextColor3 = Config.SecondaryTextColor,
                    Font = Config.Font,
                    TextSize = IsMobile and 11 or 10,
                    Position = UDim2.new(0, 4, 0.5, 0),
                    Size = UDim2.new(0, 10, 0, 14),
                    AnchorPoint = Vector2.new(0, 0.5),
                    Parent = HexContainer
                })
                
                local HexInput = Create("TextBox", {
                    BackgroundTransparency = 1,
                    Text = string.format("%02X%02X%02X", math.floor(default.R * 255), math.floor(default.G * 255), math.floor(default.B * 255)),
                    TextColor3 = Config.TextColor,
                    Font = Config.Font,
                    TextSize = IsMobile and 11 or 10,
                    Position = UDim2.new(0, 14, 0, 0),
                    Size = UDim2.new(1, -18, 1, 0),
                    ClearTextOnFocus = true,
                    Parent = HexContainer
                })
                
                local LockOverlay = CreateLockOverlay(ColorPickerFrame)
                LockOverlay.Visible = locked
                
                local currentColor = default
                local h, s, v = Color3.toHSV(default)
                local isOpen = false
                local isLocked = locked
                
                local function UpdateColor(skipCallback)
                    currentColor = Color3.fromHSV(h, s, v)
                    ColorPreview.BackgroundColor3 = currentColor
                    SVPicker.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                    SVCursor.Position = UDim2.new(s, 0, 1 - v, 0)
                    HueCursor.Position = UDim2.new(0, -2, h, -3)
                    
                    RInput.Text = tostring(math.floor(currentColor.R * 255))
                    GInput.Text = tostring(math.floor(currentColor.G * 255))
                    BInput.Text = tostring(math.floor(currentColor.B * 255))
                    HexInput.Text = string.format("%02X%02X%02X", math.floor(currentColor.R * 255), math.floor(currentColor.G * 255), math.floor(currentColor.B * 255))
                    
                    if not skipCallback then
                        callback(currentColor)
                    end
                end
                
                -- SV Picker interaction
                local svDragging = false
                SVPicker.InputBegan:Connect(function(input)
                    if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not isLocked then
                        svDragging = true
                        local pos = Vector2.new(input.Position.X, input.Position.Y)
                        local relPos = pos - SVPicker.AbsolutePosition
                        s = math.clamp(relPos.X / SVPicker.AbsoluteSize.X, 0, 1)
                        v = 1 - math.clamp(relPos.Y / SVPicker.AbsoluteSize.Y, 0, 1)
                        UpdateColor()
                    end
                end)
                
                SVPicker.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        svDragging = false
                    end
                end)
                
                -- Hue Slider interaction
                local hueDragging = false
                HueSlider.InputBegan:Connect(function(input)
                    if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not isLocked then
                        hueDragging = true
                        local pos = input.Position.Y
                        local relPos = pos - HueSlider.AbsolutePosition.Y
                        h = math.clamp(relPos / HueSlider.AbsoluteSize.Y, 0, 1)
                        UpdateColor()
                    end
                end)
                
                HueSlider.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        hueDragging = false
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if isLocked then return end
                    
                    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                        if svDragging then
                            local pos = Vector2.new(input.Position.X, input.Position.Y)
                            local relPos = pos - SVPicker.AbsolutePosition
                            s = math.clamp(relPos.X / SVPicker.AbsoluteSize.X, 0, 1)
                            v = 1 - math.clamp(relPos.Y / SVPicker.AbsoluteSize.Y, 0, 1)
                            UpdateColor()
                        elseif hueDragging then
                            local pos = input.Position.Y
                            local relPos = pos - HueSlider.AbsolutePosition.Y
                            h = math.clamp(relPos / HueSlider.AbsoluteSize.Y, 0, 1)
                            UpdateColor()
                        end
                    end
                end)
                
                -- RGB Input handling
                local function HandleRGBInput()
                    if isLocked then return end
                    
                    local r = math.clamp(tonumber(RInput.Text) or 0, 0, 255)
                    local g = math.clamp(tonumber(GInput.Text) or 0, 0, 255)
                    local b = math.clamp(tonumber(BInput.Text) or 0, 0, 255)
                    
                    currentColor = Color3.fromRGB(r, g, b)
                    h, s, v = Color3.toHSV(currentColor)
                    UpdateColor()
                end
                
                RInput.FocusLost:Connect(HandleRGBInput)
                GInput.FocusLost:Connect(HandleRGBInput)
                BInput.FocusLost:Connect(HandleRGBInput)
                
                -- Hex Input handling
                HexInput.FocusLost:Connect(function()
                    if isLocked then return end
                    
                    local hex = HexInput.Text:gsub("#", "")
                    if #hex == 6 then
                        local r = tonumber(hex:sub(1, 2), 16) or 0
                        local g = tonumber(hex:sub(3, 4), 16) or 0
                        local b = tonumber(hex:sub(5, 6), 16) or 0
                        
                        currentColor = Color3.fromRGB(r, g, b)
                        h, s, v = Color3.toHSV(currentColor)
                        UpdateColor()
                    else
                        HexInput.Text = string.format("%02X%02X%02X", math.floor(currentColor.R * 255), math.floor(currentColor.G * 255), math.floor(currentColor.B * 255))
                    end
                end)
                
                ColorPreview.MouseButton1Click:Connect(function()
                    if isLocked then return end
                    
                    isOpen = not isOpen
                    PickerPanel.Visible = isOpen
                    local newHeight = isOpen and (baseHeight + pickerHeight + 10) or baseHeight
                    Tween(ColorPickerFrame, {Size = UDim2.new(1, 0, 0, newHeight)})
                end)
                
                UpdateColor(true)
                
                local ColorPickerObj = {}
                function ColorPickerObj:SetColor(color)
                    if not isLocked then
                        h, s, v = Color3.toHSV(color)
                        UpdateColor()
                    end
                end
                function ColorPickerObj:GetColor()
                    return currentColor
                end
                function ColorPickerObj:SetLocked(state)
                    isLocked = state
                    LockOverlay.Visible = state
                    PreviewLockIcon.Visible = state
                    
                    if state then
                        isOpen = false
                        PickerPanel.Visible = false
                        Tween(ColorPickerFrame, {Size = UDim2.new(1, 0, 0, baseHeight)})
                        ColorLabel.TextColor3 = Config.LockedTextColor
                        ColorPreview.BackgroundColor3 = Config.LockedColor
                    else
                        ColorLabel.TextColor3 = Config.TextColor
                        ColorPreview.BackgroundColor3 = currentColor
                    end
                end
                function ColorPickerObj:IsLocked()
                    return isLocked
                end
                return ColorPickerObj
            end
            
            -- Keybind (with Lock support and Description)
            function Section:CreateKeybind(options)
                options = options or {}
                local text = options.Text or "Keybind"
                local default = options.Default or Enum.KeyCode.Unknown
                local description = options.Description or ""
                local callback = options.Callback or function() end
                local changedCallback = options.ChangedCallback or function() end
                local icon = options.Icon
                local locked = options.Locked or false
                
                local hasDesc = description ~= ""
                local frameHeight = hasDesc and (IsMobile and 60 or 52) or (IsMobile and 50 or 40)
                
                local KeybindFrame = Create("Frame", {
                    BackgroundColor3 = Config.SecondaryColor,
                    BackgroundTransparency = Config.Transparent and Config.TransparencyValue or 0,
                    Size = UDim2.new(1, 0, 0, frameHeight),
                    Parent = SectionContent
                })
                AddCorner(KeybindFrame, 6)
                
                local xOffset = 0
                if icon then
                    Create("ImageLabel", {
                        BackgroundTransparency = 1,
                        Image = GetIcon(icon),
                        ImageColor3 = Config.AccentColor,
                        Size = UDim2.new(0, IsMobile and 22 or 18, 0, IsMobile and 22 or 18),
                        Position = UDim2.new(0, 10, 0, hasDesc and 10 or (IsMobile and 14 or 11)),
                        Parent = KeybindFrame
                    })
                    xOffset = IsMobile and 28 or 25
                end
                
                local KeybindLabel = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Text = text,
                    TextColor3 = locked and Config.LockedTextColor or Config.TextColor,
                    Font = Config.Font,
                    TextSize = IsMobile and 14 or 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2.new(0, 10 + xOffset, 0, hasDesc and 8 or 0),
                    Size = UDim2.new(1, -110 - xOffset, 0, hasDesc and (IsMobile and 22 or 18) or frameHeight),
                    Parent = KeybindFrame
                })
                
                if hasDesc then
                    Create("TextLabel", {
                        BackgroundTransparency = 1,
                        Text = description,
                        TextColor3 = Config.SecondaryTextColor,
                        Font = Config.Font,
                        TextSize = IsMobile and 11 or 10,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Position = UDim2.new(0, 10 + xOffset, 0, IsMobile and 30 or 26),
                        Size = UDim2.new(1, -110 - xOffset, 0, IsMobile and 20 or 18),
                        Parent = KeybindFrame
                    })
                end
                
                local KeybindButton = Create("TextButton", {
                    BackgroundColor3 = locked and Config.LockedColor or Config.MainColor,
                    Size = UDim2.new(0, IsMobile and 80 or 70, 0, IsMobile and 32 or 26),
                    Position = UDim2.new(1, IsMobile and -90 or -80, 0.5, IsMobile and -16 or -13),
                    Text = default.Name or "None",
                    TextColor3 = locked and Config.LockedTextColor or Config.TextColor,
                    Font = Config.Font,
                    TextSize = IsMobile and 13 or 12,
                    AutoButtonColor = false,
                    Parent = KeybindFrame
                })
                AddCorner(KeybindButton, 6)
                AddStroke(KeybindButton, Config.BorderColor, 1)
                
                local LockOverlay = CreateLockOverlay(KeybindFrame)
                LockOverlay.Visible = locked
                
                local currentKey = default
                local isListening = false
                local isLocked = locked
                
                KeybindButton.MouseButton1Click:Connect(function()
                    if isLocked then return end
                    
                    isListening = true
                    KeybindButton.Text = "..."
                    Tween(KeybindButton, {BackgroundColor3 = Config.AccentColor})
                end)
                
                UserInputService.InputBegan:Connect(function(input, gameProcessed)
                    if gameProcessed then return end
                    
                    if isListening and not isLocked then
                        if input.UserInputType == Enum.UserInputType.Keyboard then
                            currentKey = input.KeyCode
                            KeybindButton.Text = currentKey.Name
                            isListening = false
                            Tween(KeybindButton, {BackgroundColor3 = Config.MainColor})
                            changedCallback(currentKey)
                        elseif input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then
                            KeybindButton.Text = currentKey.Name or "None"
                            isListening = false
                            Tween(KeybindButton, {BackgroundColor3 = Config.MainColor})
                        end
                    elseif input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == currentKey and not isLocked then
                        callback(currentKey)
                    end
                end)
                
                local KeybindObj = {}
                function KeybindObj:SetKey(key)
                    if not isLocked then
                        currentKey = key
                        KeybindButton.Text = key.Name
                        changedCallback(key)
                    end
                end
                function KeybindObj:GetKey()
                    return currentKey
                end
                function KeybindObj:SetLocked(state)
                    isLocked = state
                    LockOverlay.Visible = state
                    isListening = false
                    
                    if state then
                        KeybindLabel.TextColor3 = Config.LockedTextColor
                        KeybindButton.BackgroundColor3 = Config.LockedColor
                        KeybindButton.TextColor3 = Config.LockedTextColor
                    else
                        KeybindLabel.TextColor3 = Config.TextColor
                        KeybindButton.BackgroundColor3 = Config.MainColor
                        KeybindButton.TextColor3 = Config.TextColor
                    end
                end
                function KeybindObj:IsLocked()
                    return isLocked
                end
                return KeybindObj
            end
            
            return Section
        end
        
        return Tab
    end
    
    -- Notification System
    function Window:Notify(options)
        options = options or {}
        local title = options.Title or "Notification"
        local content = options.Content or ""
        local duration = options.Duration or 3
        local icon = options.Icon or "Bell"
        local notifType = options.Type or "Info"
        
        local typeColors = {
            Info = Config.AccentColor,
            Success = Color3.fromRGB(80, 200, 120),
            Warning = Color3.fromRGB(255, 180, 50),
            Error = Color3.fromRGB(220, 60, 60)
        }
        
        local NotifContainer = ScreenGui:FindFirstChild("NotificationContainer")
        if not NotifContainer then
            NotifContainer = Create("Frame", {
                Name = "NotificationContainer",
                BackgroundTransparency = 1,
                Size = UDim2.new(0, IsMobile and 280 or 300, 1, -20),
                Position = UDim2.new(1, IsMobile and -290 or -310, 0, 10),
                Parent = ScreenGui
            })
            
            Create("UIListLayout", {
                Padding = UDim.new(0, 10),
                VerticalAlignment = Enum.VerticalAlignment.Bottom,
                Parent = NotifContainer
            })
        end
        
        local NotifFrame = Create("Frame", {
            BackgroundColor3 = Config.MainColor,
            BackgroundTransparency = Config.Transparent and Config.TransparencyValue or 0,
            Size = UDim2.new(1, 0, 0, IsMobile and 80 or 70),
            Position = UDim2.new(1, 0, 0, 0),
            Parent = NotifContainer
        })
        AddCorner(NotifFrame, 8)
        AddShadow(NotifFrame)
        
        local ColorBar = Create("Frame", {
            BackgroundColor3 = typeColors[notifType] or typeColors.Info,
            Size = UDim2.new(0, 4, 1, -10),
            Position = UDim2.new(0, 5, 0, 5),
            Parent = NotifFrame
        })
        AddCorner(ColorBar, 2)
        
        local NotifIcon = Create("ImageLabel", {
            BackgroundTransparency = 1,
            Image = GetIcon(icon),
            ImageColor3 = typeColors[notifType] or typeColors.Info,
            Size = UDim2.new(0, IsMobile and 28 or 24, 0, IsMobile and 28 or 24),
            Position = UDim2.new(0, 20, 0, IsMobile and 18 or 15),
            Parent = NotifFrame
        })
        
        local NotifTitle = Create("TextLabel", {
            BackgroundTransparency = 1,
            Text = title,
            TextColor3 = Config.TextColor,
            Font = Enum.Font.GothamBold,
            TextSize = IsMobile and 15 or 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            Position = UDim2.new(0, IsMobile and 55 or 50, 0, IsMobile and 14 or 12),
            Size = UDim2.new(1, IsMobile and -95 or -60, 0, 20),
            Parent = NotifFrame
        })
        
        local NotifContent = Create("TextLabel", {
            BackgroundTransparency = 1,
            Text = content,
            TextColor3 = Config.SecondaryTextColor,
            Font = Config.Font,
            TextSize = IsMobile and 13 or 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            Position = UDim2.new(0, IsMobile and 55 or 50, 0, IsMobile and 36 or 32),
            Size = UDim2.new(1, IsMobile and -95 or -60, 0, 30),
            Parent = NotifFrame
        })
        
        local ProgressBar = Create("Frame", {
            BackgroundColor3 = typeColors[notifType] or typeColors.Info,
            Size = UDim2.new(1, -10, 0, 3),
            Position = UDim2.new(0, 5, 1, -8),
            Parent = NotifFrame
        })
        AddCorner(ProgressBar, 2)
        
        -- Close button
        local CloseNotifBtn = Create("TextButton", {
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 30, 0, 30),
            Position = UDim2.new(1, -35, 0, 5),
            Text = "",
            Parent = NotifFrame
        })
        
        local CloseNotifIcon = Create("ImageLabel", {
            BackgroundTransparency = 1,
            Image = GetIcon("X"),
            ImageColor3 = Config.SecondaryTextColor,
            Size = UDim2.new(0, 16, 0, 16),
            Position = UDim2.new(0.5, -8, 0.5, -8),
            Parent = CloseNotifBtn
        })
        
        local function CloseNotification()
            Tween(NotifFrame, {Position = UDim2.new(1, 20, 0, 0)}, 0.3)
            task.delay(0.3, function()
                if NotifFrame and NotifFrame.Parent then
                    NotifFrame:Destroy()
                end
            end)
        end
        
        CloseNotifBtn.MouseButton1Click:Connect(CloseNotification)
        
        -- Animate in
        NotifFrame.Position = UDim2.new(1, 20, 0, 0)
        Tween(NotifFrame, {Position = UDim2.new(0, 0, 0, 0)}, 0.3)
        Tween(ProgressBar, {Size = UDim2.new(0, 0, 0, 3)}, duration)
        
        task.delay(duration, function()
            if NotifFrame and NotifFrame.Parent then
                CloseNotification()
            end
        end)
    end
    
    -- Dialog System (Fixed)
    function Window:CreateDialog(options)
        options = options or {}
        local title = options.Title or "Dialog"
        local content = options.Content or "Are you sure?"
        local buttons = options.Buttons or {
            {Text = "Confirm", Callback = function() end},
            {Text = "Cancel", Callback = function() end}
        }
        
        -- Create overlay
        local DialogOverlay = Create("Frame", {
            Name = "DialogOverlay",
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            ZIndex = 200,
            Parent = ScreenGui
        })
        
        -- Create dialog frame
        local DialogFrame = Create("Frame", {
            Name = "DialogFrame",
            BackgroundColor3 = Config.MainColor,
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            ClipsDescendants = true,
            ZIndex = 201,
            Parent = DialogOverlay
        })
        AddCorner(DialogFrame, 10)
        AddShadow(DialogFrame)
        
        local targetWidth = IsMobile and 300 or 350
        local targetHeight = 160
        
        -- Dialog content
        local DialogTitle = Create("TextLabel", {
            Name = "Title",
            BackgroundTransparency = 1,
            Text = title,
            TextColor3 = Config.TextColor,
            Font = Enum.Font.GothamBold,
            TextSize = IsMobile and 18 or 16,
            Position = UDim2.new(0, 20, 0, 20),
            Size = UDim2.new(1, -40, 0, 24),
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 202,
            Parent = DialogFrame
        })
        
        local DialogContent = Create("TextLabel", {
            Name = "Content",
            BackgroundTransparency = 1,
            Text = content,
            TextColor3 = Config.SecondaryTextColor,
            Font = Config.Font,
            TextSize = IsMobile and 14 or 13,
            TextWrapped = true,
            TextYAlignment = Enum.TextYAlignment.Top,
            Position = UDim2.new(0, 20, 0, 50),
            Size = UDim2.new(1, -40, 0, 50),
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 202,
            Parent = DialogFrame
        })
        
        local ButtonsFrame = Create("Frame", {
            Name = "Buttons",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -40, 0, IsMobile and 44 or 36),
            Position = UDim2.new(0, 20, 1, IsMobile and -64 or -56),
            ZIndex = 202,
            Parent = DialogFrame
        })
        
        local ButtonsLayout = Create("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            Padding = UDim.new(0, 10),
            Parent = ButtonsFrame
        })
        
        local dialogClosed = false
        
        local function CloseDialog(callback)
            if dialogClosed then return end
            dialogClosed = true
            
            Tween(DialogOverlay, {BackgroundTransparency = 1}, 0.2)
            Tween(DialogFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.2)
            
            task.delay(0.25, function()
                if DialogOverlay and DialogOverlay.Parent then
                    DialogOverlay:Destroy()
                end
                if callback then
                    callback()
                end
            end)
        end
        
        -- Create buttons in reverse order for proper layout
        for i = #buttons, 1, -1 do
            local btnInfo = buttons[i]
            local isPrimary = i == 1
            
            local DialogBtn = Create("TextButton", {
                Name = "Button" .. i,
                BackgroundColor3 = isPrimary and Config.AccentColor or Config.SecondaryColor,
                Size = UDim2.new(0, IsMobile and 90 or 80, 1, 0),
                Text = btnInfo.Text or "Button",
                TextColor3 = Config.TextColor,
                Font = Config.Font,
                TextSize = IsMobile and 14 or 13,
                AutoButtonColor = false,
                ZIndex = 203,
                Parent = ButtonsFrame
            })
            AddCorner(DialogBtn, 6)
            
            DialogBtn.MouseButton1Click:Connect(function()
                CreateRipple(DialogBtn)
                CloseDialog(btnInfo.Callback)
            end)
            
            DialogBtn.MouseEnter:Connect(function()
                local hoverColor = isPrimary and Color3.fromRGB(
                    math.min(Config.AccentColor.R * 255 + 20, 255),
                    math.min(Config.AccentColor.G * 255 + 20, 255),
                    math.min(Config.AccentColor.B * 255 + 20, 255)
                ) or Config.BorderColor
                Tween(DialogBtn, {BackgroundColor3 = hoverColor})
            end)
            
            DialogBtn.MouseLeave:Connect(function()
                Tween(DialogBtn, {BackgroundColor3 = isPrimary and Config.AccentColor or Config.SecondaryColor})
            end)
        end
        
        -- Close on overlay click
        DialogOverlay.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                local mousePos = UserInputService:GetMouseLocation()
                local framePos = DialogFrame.AbsolutePosition
                local frameSize = DialogFrame.AbsoluteSize
                
                if mousePos.X < framePos.X or mousePos.X > framePos.X + frameSize.X or
                   mousePos.Y < framePos.Y or mousePos.Y > framePos.Y + frameSize.Y then
                    CloseDialog()
                end
            end
        end)
        
        -- Animate in
        task.defer(function()
            Tween(DialogOverlay, {BackgroundTransparency = 0.5}, 0.2)
            Tween(DialogFrame, {Size = UDim2.new(0, targetWidth, 0, targetHeight)}, 0.3)
        end)
    end
    
    -- Toggle UI visibility
    function Window:Toggle()
        MainFrame.Visible = not MainFrame.Visible
        if MobileToggle then
            local icon = MainFrame.Visible and GetIcon("X") or GetIcon("Menu")
            MobileToggle:FindFirstChild("ImageLabel", true).Image = icon
        end
    end
    
    -- Destroy UI
    function Window:Destroy()
        ScreenGui:Destroy()
    end
    
    -- Get mobile status
    function Window:IsMobile()
        return IsMobile
    end
    
    return Window
end

return Library
