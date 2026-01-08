
--[[
    Advanced UI Library v4.2 - Simplified
    
    Features:
    - Mobile Detection & Support
    - All UI Elements with Descriptions
    - Single & Multi-Select Dropdowns
    - Lockable Elements
    - Transparency Settings
    - Resizable Windows
    - Fixed Dialogs
    - CoreGui with cloneref
]]

-- CloneRef implementation
local cloneref = cloneref or function(instance)
    return instance
end

-- Services
local Players = cloneref(game:GetService("Players"))
local CoreGui = cloneref(game:GetService("CoreGui"))
local TweenService = cloneref(game:GetService("TweenService"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local RunService = cloneref(game:GetService("RunService"))

-- Library
local Library = {}
Library.__index = Library

-- Mobile Detection
local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled

-- Config (Single Dark Theme)
local Config = {
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
    Font = Enum.Font.GothamMedium,
    TweenSpeed = 0.2,
    Transparent = false,
    TransparencyValue = 0.3
}

-- Icons
local LucideIcons = {
    Home = "rbxassetid://7733960981",
    Settings = "rbxassetid://7734053495",
    User = "rbxassetid://7734068614",
    Menu = "rbxassetid://7733717447",
    X = "rbxassetid://7743878857",
    ChevronDown = "rbxassetid://7733715400",
    Check = "rbxassetid://7733715076",
    Circle = "rbxassetid://7733658708",
    Minimize = "rbxassetid://7733717447",
    Maximize = "rbxassetid://7733717890",
    Eye = "rbxassetid://7733685814",
    Lock = "rbxassetid://7733704151",
    Unlock = "rbxassetid://7734062968",
    Bell = "rbxassetid://7733658504",
    Star = "rbxassetid://7734056531",
    Play = "rbxassetid://7733992450",
    Zap = "rbxassetid://7734076629",
    Shield = "rbxassetid://7734048384",
    Target = "rbxassetid://7734060159",
    Navigation = "rbxassetid://7733960981",
    Grip = "rbxassetid://7733717447",
    Info = "rbxassetid://7733697276",
    AlertCircle = "rbxassetid://7733658504",
    Palette = "rbxassetid://7733697276",
    Sliders = "rbxassetid://7734053495",
    Edit = "rbxassetid://7733680183",
    Crosshair = "rbxassetid://7733673041"
}

-- Utilities
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

local function AddShadow(instance)
    return Create("ImageLabel", {
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
end

local function GetIcon(iconName)
    return LucideIcons[iconName] or LucideIcons.Circle
end

-- Dragging
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

-- Resizing
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

-- Ripple
local function CreateRipple(parent)
    local ripple = Create("Frame", {
        Name = "Ripple",
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.7,
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

-- Lock Overlay
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
    
    Create("ImageLabel", {
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

-- Main Window
function Library:CreateWindow(options)
    options = options or {}
    local title = options.Title or "UI Library"
    local description = options.Description or ""
    local icon = options.Icon or "Zap"
    local transparent = options.Transparent or false
    local transparencyValue = options.TransparencyValue or 0.3
    local size = options.Size or (IsMobile and UDim2.new(0, 420, 0, 350) or UDim2.new(0, 550, 0, 400))
    local minSize = options.MinSize or Vector2.new(400, 300)
    local maxSize = options.MaxSize or Vector2.new(900, 700)
    
    Config.Transparent = transparent
    Config.TransparencyValue = transparencyValue
    
    -- Remove existing
    local existing = CoreGui:FindFirstChild("AdvancedUILibrary")
    if existing then existing:Destroy() end
    
    -- ScreenGui
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
        Position = UDim2.new(0.5, 0, 0.5, 0),
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
        Parent = MainFrame
    })
    AddCorner(TitleBar, 10)
    
    Create("Frame", {
        Name = "CornerFix",
        BackgroundColor3 = Config.SecondaryColor,
        BackgroundTransparency = transparent and transparencyValue or 0,
        Size = UDim2.new(1, 0, 0, 15),
        Position = UDim2.new(0, 0, 1, -15),
        BorderSizePixel = 0,
        Parent = TitleBar
    })
    
    Create("ImageLabel", {
        Name = "Icon",
        BackgroundTransparency = 1,
        Image = GetIcon(icon),
        ImageColor3 = Config.AccentColor,
        Size = UDim2.new(0, IsMobile and 28 or 24, 0, IsMobile and 28 or 24),
        Position = UDim2.new(0, 15, 0.5, IsMobile and -14 or -12),
        Parent = TitleBar
    })
    
    Create("TextLabel", {
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
    
    Create("TextLabel", {
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
    
    -- Controls
    local ControlsFrame = Create("Frame", {
        Name = "Controls",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, IsMobile and 90 or 70, 0, IsMobile and 40 or 30),
        Position = UDim2.new(1, IsMobile and -100 or -80, 0.5, IsMobile and -20 or -15),
        Parent = TitleBar
    })
    
    Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        Padding = UDim.new(0, 5),
        Parent = ControlsFrame
    })
    
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
    
    local CloseBtn = Create("TextButton", {
        Name = "Close",
        BackgroundColor3 = Color3.fromRGB(220, 60, 60),
        Size = UDim2.new(0, IsMobile and 40 or 30, 0, IsMobile and 40 or 30),
        Text = "",
        Parent = ControlsFrame
    })
    AddCorner(CloseBtn, 6)
    
    Create("ImageLabel", {
        BackgroundTransparency = 1,
        Image = GetIcon("X"),
        ImageColor3 = Config.TextColor,
        Size = UDim2.new(0, IsMobile and 20 or 16, 0, IsMobile and 20 or 16),
        Position = UDim2.new(0.5, IsMobile and -10 or -8, 0.5, IsMobile and -10 or -8),
        Parent = CloseBtn
    })
    
    -- Tab Container
    local tabWidth = IsMobile and 120 or 140
    local TabContainer = Create("Frame", {
        Name = "TabContainer",
        BackgroundColor3 = Config.SecondaryColor,
        BackgroundTransparency = transparent and transparencyValue or 0,
        Size = UDim2.new(0, tabWidth, 1, IsMobile and -70 or -60),
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
    
    Create("UIListLayout", {
        Padding = UDim.new(0, 5),
        Parent = TabScroll
    })
    
    -- Content Container
    local ContentContainer = Create("Frame", {
        Name = "ContentContainer",
        BackgroundColor3 = Config.SecondaryColor,
        BackgroundTransparency = transparent and transparencyValue or 0,
        Size = UDim2.new(1, -(tabWidth + 20), 1, IsMobile and -70 or -60),
        Position = UDim2.new(0, tabWidth + 10, 0, IsMobile and 65 or 55),
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
        ZIndex = 10,
        Parent = MainFrame
    })
    AddCorner(ResizeHandle, 4)
    
    Create("ImageLabel", {
        BackgroundTransparency = 1,
        Image = GetIcon("Grip"),
        ImageColor3 = Config.SecondaryTextColor,
        Size = UDim2.new(0, 12, 0, 12),
        Position = UDim2.new(0.5, -6, 0.5, -6),
        Rotation = -45,
        ZIndex = 11,
        Parent = ResizeHandle
    })
    
    MakeDraggable(MainFrame, TitleBar)
    MakeResizable(MainFrame, ResizeHandle, minSize, maxSize)
    
    -- Minimize
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
    
    -- Close
    CloseBtn.MouseButton1Click:Connect(function()
        CreateRipple(CloseBtn)
        Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
        task.delay(0.3, function()
            ScreenGui:Destroy()
        end)
    end)
    
    -- Hover effects
    MinimizeBtn.MouseEnter:Connect(function() Tween(MinimizeBtn, {BackgroundColor3 = Config.AccentColor}) end)
    MinimizeBtn.MouseLeave:Connect(function() Tween(MinimizeBtn, {BackgroundColor3 = Config.BorderColor}) end)
    CloseBtn.MouseEnter:Connect(function() Tween(CloseBtn, {BackgroundColor3 = Color3.fromRGB(255, 80, 80)}) end)
    CloseBtn.MouseLeave:Connect(function() Tween(CloseBtn, {BackgroundColor3 = Color3.fromRGB(220, 60, 60)}) end)
    
    -- Mobile Toggle
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
        
        local MobileIcon = Create("ImageLabel", {
            BackgroundTransparency = 1,
            Image = GetIcon("Menu"),
            ImageColor3 = Config.TextColor,
            Size = UDim2.new(0, 24, 0, 24),
            Position = UDim2.new(0.5, -12, 0.5, -12),
            ZIndex = 101,
            Parent = MobileToggle
        })
        
        MobileToggle.MouseButton1Click:Connect(function()
            MainFrame.Visible = not MainFrame.Visible
            MobileIcon.Image = MainFrame.Visible and GetIcon("X") or GetIcon("Menu")
        end)
        
        MakeDraggable(MobileToggle, MobileToggle)
    end
    
    -- Window Object
    local Window = {
        Tabs = {},
        ActiveTab = nil,
        ScreenGui = ScreenGui,
        MainFrame = MainFrame,
        IsMobile = IsMobile
    }
    
    -- Set Transparency
    function Window:SetTransparency(enabled, value)
        Config.Transparent = enabled
        Config.TransparencyValue = value or Config.TransparencyValue
        local trans = enabled and Config.TransparencyValue or 0
        
        MainFrame.BackgroundTransparency = trans
        TitleBar.BackgroundTransparency = trans
        TabContainer.BackgroundTransparency = trans
        ContentContainer.BackgroundTransparency = trans
    end
    
    -- Create Tab
    function Window:CreateTab(options)
        options = options or {}
        local tabName = options.Name or "Tab"
        local tabIcon = options.Icon or "Circle"
        
        local TabButton = Create("TextButton", {
            Name = tabName,
            BackgroundColor3 = Config.BorderColor,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, IsMobile and 44 or 35),
            Text = "",
            Parent = TabScroll
        })
        AddCorner(TabButton, 6)
        
        local TabIconImg = Create("ImageLabel", {
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
        
        Create("UIListLayout", {
            Padding = UDim.new(0, 8),
            Parent = ContentPage
        })
        
        local function SelectTab()
            for _, tab in pairs(Window.Tabs) do
                Tween(tab.Button, {BackgroundTransparency = 1})
                tab.Icon.ImageColor3 = Config.SecondaryTextColor
                tab.Label.TextColor3 = Config.SecondaryTextColor
                tab.Page.Visible = false
            end
            
            Tween(TabButton, {BackgroundTransparency = 0, BackgroundColor3 = Config.AccentColor})
            TabIconImg.ImageColor3 = Config.TextColor
            TabLabel.TextColor3 = Config.TextColor
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
        
        local Tab = {
            Button = TabButton,
            Icon = TabIconImg,
            Label = TabLabel,
            Page = ContentPage
        }
        
        Window.Tabs[tabName] = Tab
        
        if not Window.ActiveTab then
            SelectTab()
        end
        
        -- Section
        function Tab:CreateSection(options)
            options = options or {}
            local sectionName = options.Name or "Section"
            local sectionDesc = options.Description or ""
            
            local headerHeight = sectionDesc ~= "" and (IsMobile and 50 or 45) or (IsMobile and 40 or 35)
            
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
            
            Create("TextLabel", {
                BackgroundTransparency = 1,
                Text = sectionName,
                TextColor3 = Config.TextColor,
                Font = Enum.Font.GothamBold,
                TextSize = IsMobile and 15 or 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Position = UDim2.new(0, 12, 0, 8),
                Size = UDim2.new(1, -24, 0, 20),
                Parent = SectionFrame
            })
            
            if sectionDesc ~= "" then
                Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Text = sectionDesc,
                    TextColor3 = Config.SecondaryTextColor,
                    Font = Config.Font,
                    TextSize = IsMobile and 12 or 11,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2.new(0, 12, 0, 26),
                    Size = UDim2.new(1, -24, 0, 16),
                    Parent = SectionFrame
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
            
            Create("UIListLayout", {
                Padding = UDim.new(0, 8),
                Parent = SectionContent
            })
            
            Create("UIPadding", {
                PaddingBottom = UDim.new(0, 10),
                Parent = SectionContent
            })
            
            local Section = {}
            
            -- Label
            function Section:CreateLabel(options)
                options = options or {}
                local text = options.Text or "Label"
                local desc = options.Description or ""
                local icon = options.Icon
                
                local hasDesc = desc ~= ""
                local h = hasDesc and (IsMobile and 40 or 35) or (IsMobile and 28 or 24)
                
                local Frame = Create("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, h),
                    Parent = SectionContent
                })
                
                local xOff = 0
                if icon then
                    Create("ImageLabel", {
                        BackgroundTransparency = 1,
                        Image = GetIcon(icon),
                        ImageColor3 = Config.AccentColor,
                        Size = UDim2.new(0, IsMobile and 20 or 16, 0, IsMobile and 20 or 16),
                        Position = UDim2.new(0, 0, 0, hasDesc and 2 or 4),
                        Parent = Frame
                    })
                    xOff = IsMobile and 26 or 22
                end
                
                local LabelText = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Text = text,
                    TextColor3 = Config.TextColor,
                    Font = Config.Font,
                    TextSize = IsMobile and 14 or 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2.new(0, xOff, 0, 0),
                    Size = UDim2.new(1, -xOff, 0, IsMobile and 20 or 18),
                    Parent = Frame
                })
                
                if hasDesc then
                    Create("TextLabel", {
                        BackgroundTransparency = 1,
                        Text = desc,
                        TextColor3 = Config.SecondaryTextColor,
                        Font = Config.Font,
                        TextSize = IsMobile and 11 or 10,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Position = UDim2.new(0, xOff, 0, IsMobile and 20 or 18),
                        Size = UDim2.new(1, -xOff, 0, IsMobile and 16 or 14),
                        Parent = Frame
                    })
                end
                
                return {
                    SetText = function(_, t) LabelText.Text = t end
                }
            end
            
            -- Paragraph
            function Section:CreateParagraph(options)
                options = options or {}
                local title = options.Title or "Paragraph"
                local content = options.Content or ""
                
                local Frame = Create("Frame", {
                    BackgroundColor3 = Config.SecondaryColor,
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    Parent = SectionContent
                })
                AddCorner(Frame, 6)
                
                local TitleLabel = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Text = title,
                    TextColor3 = Config.TextColor,
                    Font = Enum.Font.GothamBold,
                    TextSize = IsMobile and 14 or 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2.new(0, 10, 0, 8),
                    Size = UDim2.new(1, -20, 0, 18),
                    Parent = Frame
                })
                
                local ContentLabel = Create("TextLabel", {
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
                    Parent = Frame
                })
                
                Create("UIPadding", {PaddingBottom = UDim.new(0, 10), Parent = Frame})
                
                return {
                    SetTitle = function(_, t) TitleLabel.Text = t end,
                    SetContent = function(_, c) ContentLabel.Text = c end
                }
            end
            
            -- Button
            function Section:CreateButton(options)
                options = options or {}
                local text = options.Text or "Button"
                local desc = options.Description or ""
                local icon = options.Icon
                local callback = options.Callback or function() end
                local locked = options.Locked or false
                local lockedText = options.LockedText or "Locked"
                
                local hasDesc = desc ~= ""
                local h = hasDesc and (IsMobile and 58 or 50) or (IsMobile and 44 or 35)
                
                local Button = Create("TextButton", {
                    BackgroundColor3 = locked and Config.LockedColor or Config.AccentColor,
                    Size = UDim2.new(1, 0, 0, h),
                    Text = "",
                    AutoButtonColor = false,
                    ClipsDescendants = true,
                    Parent = SectionContent
                })
                AddCorner(Button, 6)
                
                local xOff = 0
                local IconImg
                if icon then
                    IconImg = Create("ImageLabel", {
                        BackgroundTransparency = 1,
                        Image = GetIcon(locked and "Lock" or icon),
                        ImageColor3 = locked and Config.LockedTextColor or Config.TextColor,
                        Size = UDim2.new(0, IsMobile and 22 or 18, 0, IsMobile and 22 or 18),
                        Position = UDim2.new(0, 12, 0, hasDesc and 10 or (h/2 - 9)),
                        Parent = Button
                    })
                    xOff = IsMobile and 26 or 22
                end
                
                local ButtonText = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Text = locked and lockedText or text,
                    TextColor3 = locked and Config.LockedTextColor or Config.TextColor,
                    Font = Config.Font,
                    TextSize = IsMobile and 15 or 14,
                    TextXAlignment = icon and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center,
                    Position = UDim2.new(0, 12 + xOff, 0, hasDesc and 8 or 0),
                    Size = UDim2.new(1, -24 - xOff, 0, hasDesc and (IsMobile and 22 or 18) or h),
                    Parent = Button
                })
                
                local DescLabel
                if hasDesc then
                    DescLabel = Create("TextLabel", {
                        BackgroundTransparency = 1,
                        Text = desc,
                        TextColor3 = locked and Config.LockedTextColor or Color3.fromRGB(220, 220, 230),
                        Font = Config.Font,
                        TextSize = IsMobile and 11 or 10,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Position = UDim2.new(0, 12 + xOff, 0, IsMobile and 30 or 26),
                        Size = UDim2.new(1, -24 - xOff, 0, IsMobile and 18 or 16),
                        Parent = Button
                    })
                end
                
                local LockOverlay = CreateLockOverlay(Button)
                local isLocked = locked
                
                Button.MouseButton1Click:Connect(function()
                    if not isLocked then
                        CreateRipple(Button)
                        callback()
                    end
                end)
                
                Button.MouseEnter:Connect(function()
                    if not isLocked then
                        Tween(Button, {BackgroundColor3 = Color3.fromRGB(108, 121, 255)})
                    end
                end)
                
                Button.MouseLeave:Connect(function()
                    if not isLocked then
                        Tween(Button, {BackgroundColor3 = Config.AccentColor})
                    end
                end)
                
                return {
                    SetText = function(_, t)
                        if not isLocked then ButtonText.Text = t end
                    end,
                    SetLocked = function(_, state)
                        isLocked = state
                        LockOverlay.Visible = state
                        Button.BackgroundColor3 = state and Config.LockedColor or Config.AccentColor
                        ButtonText.Text = state and lockedText or text
                        ButtonText.TextColor3 = state and Config.LockedTextColor or Config.TextColor
                        if IconImg then
                            IconImg.Image = GetIcon(state and "Lock" or icon)
                            IconImg.ImageColor3 = state and Config.LockedTextColor or Config.TextColor
                        end
                        if DescLabel then
                            DescLabel.TextColor3 = state and Config.LockedTextColor or Color3.fromRGB(220, 220, 230)
                        end
                    end,
                    IsLocked = function() return isLocked end
                }
            end
            
            -- Toggle
            function Section:CreateToggle(options)
                options = options or {}
                local text = options.Text or "Toggle"
                local desc = options.Description or ""
                local default = options.Default or false
                local icon = options.Icon
                local callback = options.Callback or function() end
                local locked = options.Locked or false
                
                local hasDesc = desc ~= ""
                local h = hasDesc and (IsMobile and 60 or 52) or (IsMobile and 50 or 40)
                
                local Frame = Create("Frame", {
                    BackgroundColor3 = Config.SecondaryColor,
                    Size = UDim2.new(1, 0, 0, h),
                    Parent = SectionContent
                })
                AddCorner(Frame, 6)
                
                local xOff = 0
                if icon then
                    Create("ImageLabel", {
                        BackgroundTransparency = 1,
                        Image = GetIcon(icon),
                        ImageColor3 = Config.AccentColor,
                        Size = UDim2.new(0, IsMobile and 22 or 18, 0, IsMobile and 22 or 18),
                        Position = UDim2.new(0, 10, 0, hasDesc and 10 or (h/2 - 9)),
                        Parent = Frame
                    })
                    xOff = IsMobile and 28 or 25
                end
                
                local Label = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Text = text,
                    TextColor3 = locked and Config.LockedTextColor or Config.TextColor,
                    Font = Config.Font,
                    TextSize = IsMobile and 14 or 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2.new(0, 10 + xOff, 0, hasDesc and 8 or 0),
                    Size = UDim2.new(1, -80 - xOff, 0, hasDesc and (IsMobile and 22 or 18) or h),
                    Parent = Frame
                })
                
                if hasDesc then
                    Create("TextLabel", {
                        BackgroundTransparency = 1,
                        Text = desc,
                        TextColor3 = Config.SecondaryTextColor,
                        Font = Config.Font,
                        TextSize = IsMobile and 11 or 10,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Position = UDim2.new(0, 10 + xOff, 0, IsMobile and 30 or 26),
                        Size = UDim2.new(1, -80 - xOff, 0, IsMobile and 18 or 16),
                        Parent = Frame
                    })
                end
                
                local ToggleBtn = Create("TextButton", {
                    BackgroundColor3 = locked and Config.LockedColor or (default and Config.ToggleOnColor or Config.ToggleOffColor),
                    Size = UDim2.new(0, IsMobile and 52 or 44, 0, IsMobile and 28 or 24),
                    Position = UDim2.new(1, IsMobile and -62 or -54, 0.5, IsMobile and -14 or -12),
                    Text = "",
                    AutoButtonColor = false,
                    Parent = Frame
                })
                AddCorner(ToggleBtn, IsMobile and 14 or 12)
                
                local Circle = Create("Frame", {
                    BackgroundColor3 = locked and Config.LockedTextColor or Config.TextColor,
                    Size = UDim2.new(0, IsMobile and 22 or 18, 0, IsMobile and 22 or 18),
                    Position = default and UDim2.new(1, IsMobile and -25 or -21, 0.5, IsMobile and -11 or -9) or UDim2.new(0, 3, 0.5, IsMobile and -11 or -9),
                    Parent = ToggleBtn
                })
                AddCorner(Circle, IsMobile and 11 or 9)
                
                local LockOverlay = CreateLockOverlay(Frame)
                LockOverlay.Visible = locked
                
                local toggled = default
                local isLocked = locked
                
                local function Update()
                    if isLocked then return end
                    if toggled then
                        Tween(ToggleBtn, {BackgroundColor3 = Config.ToggleOnColor})
                        Tween(Circle, {Position = UDim2.new(1, IsMobile and -25 or -21, 0.5, IsMobile and -11 or -9)})
                    else
                        Tween(ToggleBtn, {BackgroundColor3 = Config.ToggleOffColor})
                        Tween(Circle, {Position = UDim2.new(0, 3, 0.5, IsMobile and -11 or -9)})
                    end
                    callback(toggled)
                end
                
                ToggleBtn.MouseButton1Click:Connect(function()
                    if not isLocked then
                        toggled = not toggled
                        Update()
                    end
                end)
                
                return {
                    Set = function(_, v) if not isLocked then toggled = v; Update() end end,
                    Get = function() return toggled end,
                    SetLocked = function(_, state)
                        isLocked = state
                        LockOverlay.Visible = state
                        Label.TextColor3 = state and Config.LockedTextColor or Config.TextColor
                        ToggleBtn.BackgroundColor3 = state and Config.LockedColor or (toggled and Config.ToggleOnColor or Config.ToggleOffColor)
                        Circle.BackgroundColor3 = state and Config.LockedTextColor or Config.TextColor
                    end,
                    IsLocked = function() return isLocked end
                }
            end
            
            -- Slider
            function Section:CreateSlider(options)
                options = options or {}
                local text = options.Text or "Slider"
                local desc = options.Description or ""
                local min = options.Min or 0
                local max = options.Max or 100
                local default = options.Default or min
                local increment = options.Increment or 1
                local suffix = options.Suffix or ""
                local icon = options.Icon
                local callback = options.Callback or function() end
                local locked = options.Locked or false
                
                local hasDesc = desc ~= ""
                local h = hasDesc and (IsMobile and 78 or 68) or (IsMobile and 65 or 55)
                
                local Frame = Create("Frame", {
                    BackgroundColor3 = Config.SecondaryColor,
                    Size = UDim2.new(1, 0, 0, h),
                    Parent = SectionContent
                })
                AddCorner(Frame, 6)
                
                local xOff = 0
                if icon then
                    Create("ImageLabel", {
                        BackgroundTransparency = 1,
                        Image = GetIcon(icon),
                        ImageColor3 = Config.AccentColor,
                        Size = UDim2.new(0, IsMobile and 22 or 18, 0, IsMobile and 22 or 18),
                        Position = UDim2.new(0, 10, 0, IsMobile and 10 or 8),
                        Parent = Frame
                    })
                    xOff = IsMobile and 28 or 25
                end
                
                local Label = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Text = text,
                    TextColor3 = locked and Config.LockedTextColor or Config.TextColor,
                    Font = Config.Font,
                    TextSize = IsMobile and 14 or 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2.new(0, 10 + xOff, 0, 5),
                    Size = UDim2.new(1, -80 - xOff, 0, 20),
                    Parent = Frame
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
                    Parent = Frame
                })
                
                local descOff = 0
                if hasDesc then
                    Create("TextLabel", {
                        BackgroundTransparency = 1,
                        Text = desc,
                        TextColor3 = Config.SecondaryTextColor,
                        Font = Config.Font,
                        TextSize = IsMobile and 11 or 10,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Position = UDim2.new(0, 10 + xOff, 0, 23),
                        Size = UDim2.new(1, -20 - xOff, 0, IsMobile and 16 or 14),
                        Parent = Frame
                    })
                    descOff = IsMobile and 12 or 10
                end
                
                local SliderBG = Create("Frame", {
                    BackgroundColor3 = locked and Config.LockedColor or Config.BorderColor,
                    Size = UDim2.new(1, -20, 0, IsMobile and 12 or 8),
                    Position = UDim2.new(0, 10, 0, (IsMobile and 40 or 35) + descOff),
                    Parent = Frame
                })
                AddCorner(SliderBG, IsMobile and 6 or 4)
                
                local Fill = Create("Frame", {
                    BackgroundColor3 = locked and Config.LockedTextColor or Config.AccentColor,
                    Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
                    Parent = SliderBG
                })
                AddCorner(Fill, IsMobile and 6 or 4)
                
                local Knob = Create("Frame", {
                    BackgroundColor3 = locked and Config.LockedTextColor or Config.TextColor,
                    Size = UDim2.new(0, IsMobile and 20 or 16, 0, IsMobile and 20 or 16),
                    Position = UDim2.new((default - min) / (max - min), IsMobile and -10 or -8, 0.5, IsMobile and -10 or -8),
                    Parent = SliderBG
                })
                AddCorner(Knob, IsMobile and 10 or 8)
                
                local LockOverlay = CreateLockOverlay(Frame)
                LockOverlay.Visible = locked
                
                local value = default
                local dragging = false
                local isLocked = locked
                
                local function UpdateSlider(input)
                    if isLocked then return end
                    local pct = math.clamp((input.Position.X - SliderBG.AbsolutePosition.X) / SliderBG.AbsoluteSize.X, 0, 1)
                    local v = min + (max - min) * pct
                    v = math.floor(v / increment + 0.5) * increment
                    v = math.clamp(v, min, max)
                    value = v
                    local p = (v - min) / (max - min)
                    Fill.Size = UDim2.new(p, 0, 1, 0)
                    Knob.Position = UDim2.new(p, IsMobile and -10 or -8, 0.5, IsMobile and -10 or -8)
                    ValueLabel.Text = tostring(v) .. suffix
                    callback(v)
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
                
                return {
                    Set = function(_, v)
                        if not isLocked then
                            value = math.clamp(v, min, max)
                            local p = (value - min) / (max - min)
                            Fill.Size = UDim2.new(p, 0, 1, 0)
                            Knob.Position = UDim2.new(p, IsMobile and -10 or -8, 0.5, IsMobile and -10 or -8)
                            ValueLabel.Text = tostring(value) .. suffix
                            callback(value)
                        end
                    end,
                    Get = function() return value end,
                    SetLocked = function(_, state)
                        isLocked = state
                        LockOverlay.Visible = state
                        Label.TextColor3 = state and Config.LockedTextColor or Config.TextColor
                        ValueLabel.TextColor3 = state and Config.LockedTextColor or Config.AccentColor
                        SliderBG.BackgroundColor3 = state and Config.LockedColor or Config.BorderColor
                        Fill.BackgroundColor3 = state and Config.LockedTextColor or Config.AccentColor
                        Knob.BackgroundColor3 = state and Config.LockedTextColor or Config.TextColor
                    end,
                    IsLocked = function() return isLocked end
                }
            end
            
            -- Dropdown (Single & Multi)
            function Section:CreateDropdown(options)
                options = options or {}
                local text = options.Text or "Dropdown"
                local desc = options.Description or ""
                local items = options.Items or {}
                local default = options.Default
                local multi = options.Multi or false
                local maxVisible = options.MaxVisible or 5
                local icon = options.Icon
                local callback = options.Callback or function() end
                local locked = options.Locked or false
                
                local hasDesc = desc ~= ""
                local baseH = hasDesc and (IsMobile and 88 or 78) or (IsMobile and 75 or 65)
                
                local Frame = Create("Frame", {
                    BackgroundColor3 = Config.SecondaryColor,
                    Size = UDim2.new(1, 0, 0, baseH),
                    ClipsDescendants = true,
                    Parent = SectionContent
                })
                AddCorner(Frame, 6)
                
                local xOff = 0
                if icon then
                    Create("ImageLabel", {
                        BackgroundTransparency = 1,
                        Image = GetIcon(icon),
                        ImageColor3 = Config.AccentColor,
                        Size = UDim2.new(0, IsMobile and 22 or 18, 0, IsMobile and 22 or 18),
                        Position = UDim2.new(0, 10, 0, IsMobile and 10 or 8),
                        Parent = Frame
                    })
                    xOff = IsMobile and 28 or 25
                end
                
                local Label = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Text = text,
                    TextColor3 = locked and Config.LockedTextColor or Config.TextColor,
                    Font = Config.Font,
                    TextSize = IsMobile and 14 or 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2.new(0, 10 + xOff, 0, 5),
                    Size = UDim2.new(1, -20 - xOff, 0, 20),
                    Parent = Frame
                })
                
                local descOff = 0
                if hasDesc then
                    Create("TextLabel", {
                        BackgroundTransparency = 1,
                        Text = desc,
                        TextColor3 = Config.SecondaryTextColor,
                        Font = Config.Font,
                        TextSize = IsMobile and 11 or 10,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Position = UDim2.new(0, 10 + xOff, 0, 23),
                        Size = UDim2.new(1, -20 - xOff, 0, IsMobile and 16 or 14),
                        Parent = Frame
                    })
                    descOff = IsMobile and 14 or 12
                end
                
                local DropBtn = Create("TextButton", {
                    BackgroundColor3 = locked and Config.LockedColor or Config.MainColor,
                    Size = UDim2.new(1, -20, 0, IsMobile and 36 or 30),
                    Position = UDim2.new(0, 10, 0, (IsMobile and 32 or 28) + descOff),
                    Text = "",
                    AutoButtonColor = false,
                    Parent = Frame
                })
                AddCorner(DropBtn, 6)
                AddStroke(DropBtn, Config.BorderColor, 1)
                
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
                    Parent = DropBtn
                })
                
                local Arrow = Create("ImageLabel", {
                    BackgroundTransparency = 1,
                    Image = locked and GetIcon("Lock") or GetIcon("ChevronDown"),
                    ImageColor3 = locked and Config.LockedTextColor or Config.SecondaryTextColor,
                    Size = UDim2.new(0, IsMobile and 20 or 16, 0, IsMobile and 20 or 16),
                    Position = UDim2.new(1, IsMobile and -30 or -26, 0.5, IsMobile and -10 or -8),
                    Parent = DropBtn
                })
                
                local optH = IsMobile and 40 or 32
                local optY = (IsMobile and 73 or 63) + descOff
                
                local OptionsContainer = Create("Frame", {
                    BackgroundColor3 = Config.MainColor,
                    Size = UDim2.new(1, -20, 0, 0),
                    Position = UDim2.new(0, 10, 0, optY),
                    ClipsDescendants = true,
                    Parent = Frame
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
                
                Create("UIListLayout", {
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
                
                local LockOverlay = CreateLockOverlay(Frame)
                LockOverlay.Visible = locked
                
                local isOpen = false
                local selected = multi and (type(default) == "table" and table.clone(default) or {}) or default
                local isLocked = locked
                local optionButtons = {}
                
                local function UpdateDisplay()
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
                
                local function UpdateSize()
                    local count = math.min(#items, maxVisible)
                    local contentH = (optH * count) + 8
                    
                    if isOpen and not isLocked then
                        Tween(Frame, {Size = UDim2.new(1, 0, 0, baseH + contentH + 5)})
                        Tween(OptionsContainer, {Size = UDim2.new(1, -20, 0, contentH)})
                        Tween(Arrow, {Rotation = 180})
                    else
                        Tween(Frame, {Size = UDim2.new(1, 0, 0, baseH)})
                        Tween(OptionsContainer, {Size = UDim2.new(1, -20, 0, 0)})
                        Tween(Arrow, {Rotation = 0})
                    end
                end
                
                local function IsItemSelected(item)
                    if multi then
                        return table.find(selected, item) ~= nil
                    else
                        return selected == item
                    end
                end
                
                local function UpdateOptionVisual(btn, isSel)
                    local check = btn:FindFirstChild("Checkmark")
                    if check then check.Visible = isSel end
                    if isSel then
                        btn.BackgroundColor3 = Config.AccentColor
                        btn.BackgroundTransparency = 0.7
                    else
                        btn.BackgroundColor3 = Config.SecondaryColor
                        btn.BackgroundTransparency = 1
                    end
                end
                
                local function CreateOption(item)
                    local OptBtn = Create("TextButton", {
                        Name = item,
                        BackgroundColor3 = Config.SecondaryColor,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, -8, 0, optH - 4),
                        Text = "",
                        AutoButtonColor = false,
                        Parent = OptionsScroll
                    })
                    AddCorner(OptBtn, 4)
                    
                    Create("TextLabel", {
                        BackgroundTransparency = 1,
                        Text = item,
                        TextColor3 = Config.TextColor,
                        Font = Config.Font,
                        TextSize = IsMobile and 13 or 12,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Position = UDim2.new(0, 10, 0, 0),
                        Size = UDim2.new(1, multi and -40 or -20, 1, 0),
                        Parent = OptBtn
                    })
                    
                    if multi then
                        Create("ImageLabel", {
                            Name = "Checkmark",
                            BackgroundTransparency = 1,
                            Image = GetIcon("Check"),
                            ImageColor3 = Config.AccentColor,
                            Size = UDim2.new(0, IsMobile and 18 or 14, 0, IsMobile and 18 or 14),
                            Position = UDim2.new(1, IsMobile and -28 or -24, 0.5, IsMobile and -9 or -7),
                            Visible = IsItemSelected(item),
                            Parent = OptBtn
                        })
                    end
                    
                    UpdateOptionVisual(OptBtn, IsItemSelected(item))
                    
                    OptBtn.MouseEnter:Connect(function()
                        if not IsItemSelected(item) then
                            OptBtn.BackgroundTransparency = 0.5
                        end
                    end)
                    
                    OptBtn.MouseLeave:Connect(function()
                        if not IsItemSelected(item) then
                            OptBtn.BackgroundTransparency = 1
                        end
                    end)
                    
                    OptBtn.MouseButton1Click:Connect(function()
                        if isLocked then return end
                        
                        if multi then
                            local idx = table.find(selected, item)
                            if idx then
                                table.remove(selected, idx)
                            else
                                table.insert(selected, item)
                            end
                            UpdateOptionVisual(OptBtn, IsItemSelected(item))
                            UpdateDisplay()
                            callback(selected)
                        else
                            for _, btn in pairs(optionButtons) do
                                UpdateOptionVisual(btn, false)
                            end
                            selected = item
                            UpdateOptionVisual(OptBtn, true)
                            UpdateDisplay()
                            isOpen = false
                            UpdateSize()
                            callback(item)
                        end
                    end)
                    
                    optionButtons[item] = OptBtn
                end
                
                for _, item in ipairs(items) do
                    CreateOption(item)
                end
                
                DropBtn.MouseButton1Click:Connect(function()
                    if not isLocked then
                        isOpen = not isOpen
                        UpdateSize()
                    end
                end)
                
                return {
                    SetItems = function(_, newItems)
                        for _, btn in pairs(optionButtons) do btn:Destroy() end
                        optionButtons = {}
                        items = newItems
                        if multi then selected = {} else selected = nil end
                        UpdateDisplay()
                        for _, item in ipairs(items) do CreateOption(item) end
                        if isOpen then UpdateSize() end
                    end,
                    AddItem = function(_, item)
                        if not table.find(items, item) then
                            table.insert(items, item)
                            CreateOption(item)
                            if isOpen then UpdateSize() end
                        end
                    end,
                    RemoveItem = function(_, item)
                        local idx = table.find(items, item)
                        if idx then
                            table.remove(items, idx)
                            if optionButtons[item] then
                                optionButtons[item]:Destroy()
                                optionButtons[item] = nil
                            end
                            if multi then
                                local selIdx = table.find(selected, item)
                                if selIdx then
                                    table.remove(selected, selIdx)
                                    UpdateDisplay()
                                    callback(selected)
                                end
                            elseif selected == item then
                                selected = nil
                                UpdateDisplay()
                            end
                            if isOpen then UpdateSize() end
                        end
                    end,
                    SetValue = function(_, value)
                        if isLocked then return end
                        if multi then
                            selected = type(value) == "table" and table.clone(value) or {value}
                            for item, btn in pairs(optionButtons) do
                                UpdateOptionVisual(btn, IsItemSelected(item))
                            end
                        else
                            for _, btn in pairs(optionButtons) do UpdateOptionVisual(btn, false) end
                            selected = value
                            if optionButtons[value] then UpdateOptionVisual(optionButtons[value], true) end
                        end
                        UpdateDisplay()
                        callback(selected)
                    end,
                    GetValue = function() return selected end,
                    ClearSelection = function(_)
                        if isLocked then return end
                        if multi then selected = {} else selected = nil end
                        for _, btn in pairs(optionButtons) do UpdateOptionVisual(btn, false) end
                        UpdateDisplay()
                        callback(selected)
                    end,
                    SetLocked = function(_, state)
                        isLocked = state
                        LockOverlay.Visible = state
                        if state then isOpen = false; UpdateSize() end
                        Label.TextColor3 = state and Config.LockedTextColor or Config.TextColor
                        DropBtn.BackgroundColor3 = state and Config.LockedColor or Config.MainColor
                        SelectedLabel.TextColor3 = state and Config.LockedTextColor or (selected and Config.TextColor or Config.SecondaryTextColor)
                        Arrow.Image = GetIcon(state and "Lock" or "ChevronDown")
                        Arrow.ImageColor3 = state and Config.LockedTextColor or Config.SecondaryTextColor
                    end,
                    IsLocked = function() return isLocked end
                }
            end
            
            -- Input
            function Section:CreateInput(options)
                options = options or {}
                local text = options.Text or "Input"
                local desc = options.Description or ""
                local placeholder = options.Placeholder or "Enter text..."
                local default = options.Default or ""
                local icon = options.Icon
                local callback = options.Callback or function() end
                local locked = options.Locked or false
                
                local hasDesc = desc ~= ""
                local h = hasDesc and (IsMobile and 88 or 78) or (IsMobile and 75 or 65)
                
                local Frame = Create("Frame", {
                    BackgroundColor3 = Config.SecondaryColor,
                    Size = UDim2.new(1, 0, 0, h),
                    Parent = SectionContent
                })
                AddCorner(Frame, 6)
                
                local xOff = 0
                if icon then
                    Create("ImageLabel", {
                        BackgroundTransparency = 1,
                        Image = GetIcon(icon),
                        ImageColor3 = Config.AccentColor,
                        Size = UDim2.new(0, IsMobile and 22 or 18, 0, IsMobile and 22 or 18),
                        Position = UDim2.new(0, 10, 0, IsMobile and 10 or 8),
                        Parent = Frame
                    })
                    xOff = IsMobile and 28 or 25
                end
                
                local Label = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Text = text,
                    TextColor3 = locked and Config.LockedTextColor or Config.TextColor,
                    Font = Config.Font,
                    TextSize = IsMobile and 14 or 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2.new(0, 10 + xOff, 0, 5),
                    Size = UDim2.new(1, -20 - xOff, 0, 20),
                    Parent = Frame
                })
                
                local descOff = 0
                if hasDesc then
                    Create("TextLabel", {
                        BackgroundTransparency = 1,
                        Text = desc,
                        TextColor3 = Config.SecondaryTextColor,
                        Font = Config.Font,
                        TextSize = IsMobile and 11 or 10,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Position = UDim2.new(0, 10 + xOff, 0, 23),
                        Size = UDim2.new(1, -20 - xOff, 0, IsMobile and 16 or 14),
                        Parent = Frame
                    })
                    descOff = IsMobile and 14 or 12
                end
                
                local BoxFrame = Create("Frame", {
                    BackgroundColor3 = locked and Config.LockedColor or Config.MainColor,
                    Size = UDim2.new(1, -20, 0, IsMobile and 36 or 30),
                    Position = UDim2.new(0, 10, 0, (IsMobile and 32 or 28) + descOff),
                    Parent = Frame
                })
                AddCorner(BoxFrame, 6)
                AddStroke(BoxFrame, Config.BorderColor, 1)
                
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
                    Parent = BoxFrame
                })
                
                local LockOverlay = CreateLockOverlay(Frame)
                LockOverlay.Visible = locked
                local isLocked = locked
                
                TextBox.FocusLost:Connect(function(enter)
                    if not isLocked then callback(TextBox.Text, enter) end
                end)
                
                TextBox.Focused:Connect(function()
                    if not isLocked then Tween(BoxFrame, {BackgroundColor3 = Config.SecondaryColor}) end
                end)
                
                TextBox.FocusLost:Connect(function()
                    if not isLocked then Tween(BoxFrame, {BackgroundColor3 = Config.MainColor}) end
                end)
                
                                return {
                    SetText = function(_, t) if not isLocked then TextBox.Text = t end end,
                    GetText = function() return TextBox.Text end,
                    SetLocked = function(_, state)
                        isLocked = state
                        LockOverlay.Visible = state
                        TextBox.TextEditable = not state
                        Label.TextColor3 = state and Config.LockedTextColor or Config.TextColor
                        BoxFrame.BackgroundColor3 = state and Config.LockedColor or Config.MainColor
                        TextBox.TextColor3 = state and Config.LockedTextColor or Config.TextColor
                    end,
                    IsLocked = function() return isLocked end
                }
            end
            
            -- ColorPicker
            function Section:CreateColorPicker(options)
                options = options or {}
                local text = options.Text or "Color"
                local desc = options.Description or ""
                local default = options.Default or Color3.fromRGB(255, 255, 255)
                local icon = options.Icon
                local callback = options.Callback or function() end
                local locked = options.Locked or false
                
                local hasDesc = desc ~= ""
                local baseH = hasDesc and (IsMobile and 60 or 52) or (IsMobile and 50 or 40)
                
                local Frame = Create("Frame", {
                    BackgroundColor3 = Config.SecondaryColor,
                    Size = UDim2.new(1, 0, 0, baseH),
                    ClipsDescendants = true,
                    Parent = SectionContent
                })
                AddCorner(Frame, 6)
                
                local xOff = 0
                if icon then
                    Create("ImageLabel", {
                        BackgroundTransparency = 1,
                        Image = GetIcon(icon),
                        ImageColor3 = Config.AccentColor,
                        Size = UDim2.new(0, IsMobile and 22 or 18, 0, IsMobile and 22 or 18),
                        Position = UDim2.new(0, 10, 0, hasDesc and 10 or (baseH/2 - 9)),
                        Parent = Frame
                    })
                    xOff = IsMobile and 28 or 25
                end
                
                local Label = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Text = text,
                    TextColor3 = locked and Config.LockedTextColor or Config.TextColor,
                    Font = Config.Font,
                    TextSize = IsMobile and 14 or 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2.new(0, 10 + xOff, 0, hasDesc and 8 or 0),
                    Size = UDim2.new(1, -80 - xOff, 0, hasDesc and (IsMobile and 22 or 18) or baseH),
                    Parent = Frame
                })
                
                if hasDesc then
                    Create("TextLabel", {
                        BackgroundTransparency = 1,
                        Text = desc,
                        TextColor3 = Config.SecondaryTextColor,
                        Font = Config.Font,
                        TextSize = IsMobile and 11 or 10,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Position = UDim2.new(0, 10 + xOff, 0, IsMobile and 30 or 26),
                        Size = UDim2.new(1, -80 - xOff, 0, IsMobile and 20 or 18),
                        Parent = Frame
                    })
                end
                
                local Preview = Create("TextButton", {
                    BackgroundColor3 = locked and Config.LockedColor or default,
                    Size = UDim2.new(0, IsMobile and 60 or 50, 0, IsMobile and 30 or 24),
                    Position = UDim2.new(1, IsMobile and -70 or -60, 0.5, IsMobile and -15 or -12),
                    Text = "",
                    AutoButtonColor = false,
                    Parent = Frame
                })
                AddCorner(Preview, 6)
                AddStroke(Preview, Config.BorderColor, 1)
                
                local LockIcon = Create("ImageLabel", {
                    BackgroundTransparency = 1,
                    Image = GetIcon("Lock"),
                    ImageColor3 = Config.TextColor,
                    Size = UDim2.new(0, 16, 0, 16),
                    Position = UDim2.new(0.5, -8, 0.5, -8),
                    Visible = locked,
                    Parent = Preview
                })
                
                local pickerH = IsMobile and 160 or 140
                local Panel = Create("Frame", {
                    BackgroundColor3 = Config.MainColor,
                    Size = UDim2.new(1, -20, 0, pickerH),
                    Position = UDim2.new(0, 10, 0, baseH + 5),
                    Visible = false,
                    Parent = Frame
                })
                AddCorner(Panel, 6)
                AddStroke(Panel, Config.BorderColor, 1)
                
                local SVPicker = Create("ImageLabel", {
                    BackgroundColor3 = Color3.fromRGB(255, 0, 0),
                    Size = UDim2.new(1, IsMobile and -50 or -45, 1, -10),
                    Position = UDim2.new(0, 5, 0, 5),
                    Image = "rbxassetid://4155801252",
                    Parent = Panel
                })
                AddCorner(SVPicker, 4)
                
                local SVCursor = Create("Frame", {
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Size = UDim2.new(0, IsMobile and 14 or 12, 0, IsMobile and 14 or 12),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Parent = SVPicker
                })
                AddCorner(SVCursor, IsMobile and 7 or 6)
                AddStroke(SVCursor, Color3.fromRGB(0, 0, 0), 2)
                
                local HueSlider = Create("Frame", {
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Size = UDim2.new(0, IsMobile and 20 or 16, 1, -10),
                    Position = UDim2.new(1, IsMobile and -40 or -35, 0, 5),
                    Parent = Panel
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
                    Size = UDim2.new(1, 4, 0, IsMobile and 6 or 5),
                    Position = UDim2.new(0, -2, 0, 0),
                    Parent = HueSlider
                })
                AddCorner(HueCursor, 2)
                AddStroke(HueCursor, Color3.fromRGB(0, 0, 0), 1)
                
                local LockOverlay = CreateLockOverlay(Frame)
                LockOverlay.Visible = locked
                
                local color = default
                local h, s, v = Color3.toHSV(default)
                local isOpen = false
                local isLocked = locked
                local svDrag, hueDrag = false, false
                
                local function UpdateColor()
                    color = Color3.fromHSV(h, s, v)
                    Preview.BackgroundColor3 = color
                    SVPicker.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                    SVCursor.Position = UDim2.new(s, 0, 1 - v, 0)
                    HueCursor.Position = UDim2.new(0, -2, h, 0)
                    callback(color)
                end
                
                SVPicker.InputBegan:Connect(function(input)
                    if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not isLocked then
                        svDrag = true
                        local rel = Vector2.new(input.Position.X, input.Position.Y) - SVPicker.AbsolutePosition
                        s = math.clamp(rel.X / SVPicker.AbsoluteSize.X, 0, 1)
                        v = 1 - math.clamp(rel.Y / SVPicker.AbsoluteSize.Y, 0, 1)
                        UpdateColor()
                    end
                end)
                
                SVPicker.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        svDrag = false
                    end
                end)
                
                HueSlider.InputBegan:Connect(function(input)
                    if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not isLocked then
                        hueDrag = true
                        local rel = input.Position.Y - HueSlider.AbsolutePosition.Y
                        h = math.clamp(rel / HueSlider.AbsoluteSize.Y, 0, 1)
                        UpdateColor()
                    end
                end)
                
                HueSlider.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        hueDrag = false
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if isLocked then return end
                    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                        if svDrag then
                            local rel = Vector2.new(input.Position.X, input.Position.Y) - SVPicker.AbsolutePosition
                            s = math.clamp(rel.X / SVPicker.AbsoluteSize.X, 0, 1)
                            v = 1 - math.clamp(rel.Y / SVPicker.AbsoluteSize.Y, 0, 1)
                            UpdateColor()
                        elseif hueDrag then
                            local rel = input.Position.Y - HueSlider.AbsolutePosition.Y
                            h = math.clamp(rel / HueSlider.AbsoluteSize.Y, 0, 1)
                            UpdateColor()
                        end
                    end
                end)
                
                Preview.MouseButton1Click:Connect(function()
                    if isLocked then return end
                    isOpen = not isOpen
                    Panel.Visible = isOpen
                    local newH = isOpen and (baseH + pickerH + 10) or baseH
                    Tween(Frame, {Size = UDim2.new(1, 0, 0, newH)})
                end)
                
                UpdateColor()
                SVCursor.Position = UDim2.new(s, 0, 1 - v, 0)
                HueCursor.Position = UDim2.new(0, -2, h, 0)
                
                return {
                    SetColor = function(_, c)
                        if not isLocked then
                            h, s, v = Color3.toHSV(c)
                            UpdateColor()
                        end
                    end,
                    GetColor = function() return color end,
                    SetLocked = function(_, state)
                        isLocked = state
                        LockOverlay.Visible = state
                        LockIcon.Visible = state
                        if state then
                            isOpen = false
                            Panel.Visible = false
                            Tween(Frame, {Size = UDim2.new(1, 0, 0, baseH)})
                        end
                        Label.TextColor3 = state and Config.LockedTextColor or Config.TextColor
                        Preview.BackgroundColor3 = state and Config.LockedColor or color
                    end,
                    IsLocked = function() return isLocked end
                }
            end
            
            -- Keybind
            function Section:CreateKeybind(options)
                options = options or {}
                local text = options.Text or "Keybind"
                local desc = options.Description or ""
                local default = options.Default or Enum.KeyCode.Unknown
                local icon = options.Icon
                local callback = options.Callback or function() end
                local changedCallback = options.ChangedCallback or function() end
                local locked = options.Locked or false
                
                local hasDesc = desc ~= ""
                local h = hasDesc and (IsMobile and 60 or 52) or (IsMobile and 50 or 40)
                
                local Frame = Create("Frame", {
                    BackgroundColor3 = Config.SecondaryColor,
                    Size = UDim2.new(1, 0, 0, h),
                    Parent = SectionContent
                })
                AddCorner(Frame, 6)
                
                local xOff = 0
                if icon then
                    Create("ImageLabel", {
                        BackgroundTransparency = 1,
                        Image = GetIcon(icon),
                        ImageColor3 = Config.AccentColor,
                        Size = UDim2.new(0, IsMobile and 22 or 18, 0, IsMobile and 22 or 18),
                        Position = UDim2.new(0, 10, 0, hasDesc and 10 or (h/2 - 9)),
                        Parent = Frame
                    })
                    xOff = IsMobile and 28 or 25
                end
                
                local Label = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Text = text,
                    TextColor3 = locked and Config.LockedTextColor or Config.TextColor,
                    Font = Config.Font,
                    TextSize = IsMobile and 14 or 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2.new(0, 10 + xOff, 0, hasDesc and 8 or 0),
                    Size = UDim2.new(1, -100 - xOff, 0, hasDesc and (IsMobile and 22 or 18) or h),
                    Parent = Frame
                })
                
                if hasDesc then
                    Create("TextLabel", {
                        BackgroundTransparency = 1,
                        Text = desc,
                        TextColor3 = Config.SecondaryTextColor,
                        Font = Config.Font,
                        TextSize = IsMobile and 11 or 10,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Position = UDim2.new(0, 10 + xOff, 0, IsMobile and 30 or 26),
                        Size = UDim2.new(1, -100 - xOff, 0, IsMobile and 20 or 18),
                        Parent = Frame
                    })
                end
                
                local KeyBtn = Create("TextButton", {
                    BackgroundColor3 = locked and Config.LockedColor or Config.MainColor,
                    Size = UDim2.new(0, IsMobile and 80 or 70, 0, IsMobile and 32 or 26),
                    Position = UDim2.new(1, IsMobile and -90 or -80, 0.5, IsMobile and -16 or -13),
                    Text = default.Name or "None",
                    TextColor3 = locked and Config.LockedTextColor or Config.TextColor,
                    Font = Config.Font,
                    TextSize = IsMobile and 13 or 12,
                    AutoButtonColor = false,
                    Parent = Frame
                })
                AddCorner(KeyBtn, 6)
                AddStroke(KeyBtn, Config.BorderColor, 1)
                
                local LockOverlay = CreateLockOverlay(Frame)
                LockOverlay.Visible = locked
                
                local key = default
                local listening = false
                local isLocked = locked
                
                KeyBtn.MouseButton1Click:Connect(function()
                    if isLocked then return end
                    listening = true
                    KeyBtn.Text = "..."
                    Tween(KeyBtn, {BackgroundColor3 = Config.AccentColor})
                end)
                
                UserInputService.InputBegan:Connect(function(input, processed)
                    if processed then return end
                    if listening and not isLocked then
                        if input.UserInputType == Enum.UserInputType.Keyboard then
                            key = input.KeyCode
                            KeyBtn.Text = key.Name
                            listening = false
                            Tween(KeyBtn, {BackgroundColor3 = Config.MainColor})
                            changedCallback(key)
                        elseif input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then
                            KeyBtn.Text = key.Name or "None"
                            listening = false
                            Tween(KeyBtn, {BackgroundColor3 = Config.MainColor})
                        end
                    elseif input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == key and not isLocked then
                        callback(key)
                    end
                end)
                
                return {
                    SetKey = function(_, k)
                        if not isLocked then
                            key = k
                            KeyBtn.Text = k.Name
                            changedCallback(k)
                        end
                    end,
                    GetKey = function() return key end,
                    SetLocked = function(_, state)
                        isLocked = state
                        LockOverlay.Visible = state
                        listening = false
                        Label.TextColor3 = state and Config.LockedTextColor or Config.TextColor
                        KeyBtn.BackgroundColor3 = state and Config.LockedColor or Config.MainColor
                        KeyBtn.TextColor3 = state and Config.LockedTextColor or Config.TextColor
                    end,
                    IsLocked = function() return isLocked end
                }
            end
            
            return Section
        end
        
        return Tab
    end
    
    -- Notification
    function Window:Notify(options)
        options = options or {}
        local title = options.Title or "Notification"
        local content = options.Content or ""
        local duration = options.Duration or 3
        local icon = options.Icon or "Bell"
        local notifType = options.Type or "Info"
        
        local colors = {
            Info = Config.AccentColor,
            Success = Color3.fromRGB(80, 200, 120),
            Warning = Color3.fromRGB(255, 180, 50),
            Error = Color3.fromRGB(220, 60, 60)
        }
        
        local Container = ScreenGui:FindFirstChild("NotificationContainer")
        if not Container then
            Container = Create("Frame", {
                Name = "NotificationContainer",
                BackgroundTransparency = 1,
                Size = UDim2.new(0, IsMobile and 280 or 300, 1, -20),
                Position = UDim2.new(1, IsMobile and -290 or -310, 0, 10),
                Parent = ScreenGui
            })
            Create("UIListLayout", {
                Padding = UDim.new(0, 10),
                VerticalAlignment = Enum.VerticalAlignment.Bottom,
                Parent = Container
            })
        end
        
        local Notif = Create("Frame", {
            BackgroundColor3 = Config.MainColor,
            Size = UDim2.new(1, 0, 0, IsMobile and 80 or 70),
            Parent = Container
        })
        AddCorner(Notif, 8)
        AddShadow(Notif)
        
        Create("Frame", {
            BackgroundColor3 = colors[notifType] or colors.Info,
            Size = UDim2.new(0, 4, 1, -10),
            Position = UDim2.new(0, 5, 0, 5),
            Parent = Notif
        })
        
        Create("ImageLabel", {
            BackgroundTransparency = 1,
            Image = GetIcon(icon),
            ImageColor3 = colors[notifType] or colors.Info,
            Size = UDim2.new(0, IsMobile and 28 or 24, 0, IsMobile and 28 or 24),
            Position = UDim2.new(0, 20, 0, IsMobile and 18 or 15),
            Parent = Notif
        })
        
        Create("TextLabel", {
            BackgroundTransparency = 1,
            Text = title,
            TextColor3 = Config.TextColor,
            Font = Enum.Font.GothamBold,
            TextSize = IsMobile and 15 or 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            Position = UDim2.new(0, IsMobile and 55 or 50, 0, IsMobile and 14 or 12),
            Size = UDim2.new(1, IsMobile and -95 or -60, 0, 20),
            Parent = Notif
        })
        
        Create("TextLabel", {
            BackgroundTransparency = 1,
            Text = content,
            TextColor3 = Config.SecondaryTextColor,
            Font = Config.Font,
            TextSize = IsMobile and 13 or 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            Position = UDim2.new(0, IsMobile and 55 or 50, 0, IsMobile and 36 or 32),
            Size = UDim2.new(1, IsMobile and -95 or -60, 0, 30),
            Parent = Notif
        })
        
        local Progress = Create("Frame", {
            BackgroundColor3 = colors[notifType] or colors.Info,
            Size = UDim2.new(1, -10, 0, 3),
            Position = UDim2.new(0, 5, 1, -8),
            Parent = Notif
        })
        AddCorner(Progress, 2)
        
        local CloseBtn = Create("TextButton", {
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 30, 0, 30),
            Position = UDim2.new(1, -35, 0, 5),
            Text = "",
            Parent = Notif
        })
        
        Create("ImageLabel", {
            BackgroundTransparency = 1,
            Image = GetIcon("X"),
            ImageColor3 = Config.SecondaryTextColor,
            Size = UDim2.new(0, 16, 0, 16),
            Position = UDim2.new(0.5, -8, 0.5, -8),
            Parent = CloseBtn
        })
        
        local function Close()
            Tween(Notif, {Position = UDim2.new(1, 20, 0, 0)}, 0.3)
            task.delay(0.3, function()
                if Notif.Parent then Notif:Destroy() end
            end)
        end
        
        CloseBtn.MouseButton1Click:Connect(Close)
        
        Notif.Position = UDim2.new(1, 20, 0, 0)
        Tween(Notif, {Position = UDim2.new(0, 0, 0, 0)}, 0.3)
        Tween(Progress, {Size = UDim2.new(0, 0, 0, 3)}, duration)
        
        task.delay(duration, function()
            if Notif.Parent then Close() end
        end)
    end
    
    -- Dialog (FIXED)
    function Window:CreateDialog(options)
        options = options or {}
        local title = options.Title or "Dialog"
        local content = options.Content or "Are you sure?"
        local buttons = options.Buttons or {
            {Text = "Confirm", Callback = function() end},
            {Text = "Cancel", Callback = function() end}
        }
        
        local Overlay = Create("Frame", {
            Name = "DialogOverlay",
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            ZIndex = 500,
            Parent = ScreenGui
        })
        
        local Dialog = Create("Frame", {
            Name = "Dialog",
            BackgroundColor3 = Config.MainColor,
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            ClipsDescendants = true,
            ZIndex = 501,
            Parent = Overlay
        })
        AddCorner(Dialog, 10)
        AddShadow(Dialog)
        
        local targetW = IsMobile and 300 or 350
        local targetH = 160
        
        Create("TextLabel", {
            Name = "Title",
            BackgroundTransparency = 1,
            Text = title,
            TextColor3 = Config.TextColor,
            Font = Enum.Font.GothamBold,
            TextSize = IsMobile and 18 or 16,
            TextXAlignment = Enum.TextXAlignment.Left,
            Position = UDim2.new(0, 20, 0, 20),
            Size = UDim2.new(1, -40, 0, 24),
            ZIndex = 502,
            Parent = Dialog
        })
        
        Create("TextLabel", {
            Name = "Content",
            BackgroundTransparency = 1,
            Text = content,
            TextColor3 = Config.SecondaryTextColor,
            Font = Config.Font,
            TextSize = IsMobile and 14 or 13,
            TextWrapped = true,
            TextYAlignment = Enum.TextYAlignment.Top,
            TextXAlignment = Enum.TextXAlignment.Left,
            Position = UDim2.new(0, 20, 0, 50),
            Size = UDim2.new(1, -40, 0, 50),
            ZIndex = 502,
            Parent = Dialog
        })
        
        local ButtonsFrame = Create("Frame", {
            Name = "Buttons",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -40, 0, IsMobile and 44 or 36),
            Position = UDim2.new(0, 20, 1, IsMobile and -64 or -56),
            ZIndex = 502,
            Parent = Dialog
        })
        
        Create("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            Padding = UDim.new(0, 10),
            Parent = ButtonsFrame
        })
        
        local closed = false
        
        local function CloseDialog(cb)
            if closed then return end
            closed = true
            
            Tween(Overlay, {BackgroundTransparency = 1}, 0.2)
            Tween(Dialog, {Size = UDim2.new(0, 0, 0, 0)}, 0.2)
            
            task.delay(0.25, function()
                if Overlay.Parent then
                    Overlay:Destroy()
                end
                if cb then
                    task.spawn(cb)
                end
            end)
        end
        
        for i = #buttons, 1, -1 do
            local info = buttons[i]
            local isPrimary = i == 1
            
            local Btn = Create("TextButton", {
                Name = "Button" .. i,
                BackgroundColor3 = isPrimary and Config.AccentColor or Config.SecondaryColor,
                Size = UDim2.new(0, IsMobile and 90 or 80, 1, 0),
                Text = info.Text or "Button",
                TextColor3 = Config.TextColor,
                Font = Config.Font,
                TextSize = IsMobile and 14 or 13,
                AutoButtonColor = false,
                ZIndex = 503,
                Parent = ButtonsFrame
            })
            AddCorner(Btn, 6)
            
            Btn.MouseButton1Click:Connect(function()
                CloseDialog(info.Callback)
            end)
            
            Btn.MouseEnter:Connect(function()
                Tween(Btn, {BackgroundColor3 = isPrimary and Color3.fromRGB(108, 121, 255) or Config.BorderColor})
            end)
            
            Btn.MouseLeave:Connect(function()
                Tween(Btn, {BackgroundColor3 = isPrimary and Config.AccentColor or Config.SecondaryColor})
            end)
        end
        
        Overlay.InputBegan:Connect(function(input)
            if closed then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                task.defer(function()
                    if closed then return end
                    
                    local mousePos = UserInputService:GetMouseLocation()
                    local dialogPos = Dialog.AbsolutePosition
                    local dialogSize = Dialog.AbsoluteSize
                    
                    local isOutside = mousePos.X < dialogPos.X or 
                                      mousePos.X > dialogPos.X + dialogSize.X or
                                      mousePos.Y < dialogPos.Y or 
                                      mousePos.Y > dialogPos.Y + dialogSize.Y
                    
                    if isOutside and dialogSize.X > 10 then
                        CloseDialog()
                    end
                end)
            end
        end)
        
        task.defer(function()
            Tween(Overlay, {BackgroundTransparency = 0.5}, 0.2)
            Tween(Dialog, {Size = UDim2.new(0, targetW, 0, targetH)}, 0.3)
        end)
    end
    
    -- Toggle visibility
    function Window:Toggle()
        MainFrame.Visible = not MainFrame.Visible
        if MobileToggle then
            local icon = MainFrame.Visible and GetIcon("X") or GetIcon("Menu")
            MobileToggle:FindFirstChild("ImageLabel", true).Image = icon
        end
    end
    
    -- Destroy
    function Window:Destroy()
        ScreenGui:Destroy()
    end
    
    return Window
end

return Library
