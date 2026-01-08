--[[
    Advanced UI Library v2.0
    Features: Buttons, Dropdowns, Toggles, Sliders, ColorPickers, Inputs, Sections, Labels, Paragraphs
    Uses CoreGui with cloneref for undetection
    Lucide Icon Support
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

-- Library Table
local Library = {}
Library.__index = Library

-- Configuration
local Config = {
    MainColor = Color3.fromRGB(25, 25, 35),
    SecondaryColor = Color3.fromRGB(35, 35, 50),
    AccentColor = Color3.fromRGB(88, 101, 242),
    TextColor = Color3.fromRGB(255, 255, 255),
    SecondaryTextColor = Color3.fromRGB(180, 180, 190),
    BorderColor = Color3.fromRGB(50, 50, 65),
    ToggleOnColor = Color3.fromRGB(88, 101, 242),
    ToggleOffColor = Color3.fromRGB(60, 60, 75),
    Font = Enum.Font.GothamMedium,
    TweenSpeed = 0.2
}

-- Lucide Icons (Base64 encoded SVG-like paths converted to ImageIds or Unicode alternatives)
local LucideIcons = {
    -- Using Roblox asset IDs that resemble Lucide icons (you can replace with actual uploaded icons)
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
    Navigation = "rbxassetid://7733960981"
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

local function AddPadding(instance, padding)
    return Create("UIPadding", {
        PaddingTop = UDim.new(0, padding),
        PaddingBottom = UDim.new(0, padding),
        PaddingLeft = UDim.new(0, padding),
        PaddingRight = UDim.new(0, padding),
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

-- Dragging Function
local function MakeDraggable(frame, handle)
    handle = handle or frame
    local dragging, dragInput, dragStart, startPos
    
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
            local delta = input.Position - dragStart
            Tween(frame, {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}, 0.05)
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

-- Main Library Functions
function Library:CreateWindow(options)
    options = options or {}
    local title = options.Title or "UI Library"
    local description = options.Description or ""
    local icon = options.Icon or "Zap"
    local size = options.Size or UDim2.new(0, 550, 0, 400)
    local position = options.Position or UDim2.new(0.5, -275, 0.5, -200)
    
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
        Size = UDim2.new(1, 0, 0, 50),
        BorderSizePixel = 0,
        Parent = MainFrame
    })
    AddCorner(TitleBar, 10)
    
    -- Fix corner overlap
    local TitleBarFix = Create("Frame", {
        Name = "CornerFix",
        BackgroundColor3 = Config.SecondaryColor,
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
        Size = UDim2.new(0, 24, 0, 24),
        Position = UDim2.new(0, 15, 0.5, -12),
        Parent = TitleBar
    })
    
    -- Title
    local TitleLabel = Create("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Config.TextColor,
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        Size = UDim2.new(1, -120, 0, 20),
        Position = UDim2.new(0, 50, 0, 8),
        Parent = TitleBar
    })
    
    -- Description
    local DescLabel = Create("TextLabel", {
        Name = "Description",
        BackgroundTransparency = 1,
        Text = description,
        TextColor3 = Config.SecondaryTextColor,
        Font = Config.Font,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        Size = UDim2.new(1, -120, 0, 16),
        Position = UDim2.new(0, 50, 0, 28),
        Parent = TitleBar
    })
    
    -- Window Controls
    local ControlsFrame = Create("Frame", {
        Name = "Controls",
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 70, 0, 30),
        Position = UDim2.new(1, -80, 0.5, -15),
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
        Size = UDim2.new(0, 30, 0, 30),
        Text = "",
        Parent = ControlsFrame
    })
    AddCorner(MinimizeBtn, 6)
    
    local MinimizeIcon = Create("ImageLabel", {
        BackgroundTransparency = 1,
        Image = GetIcon("Minimize"),
        ImageColor3 = Config.TextColor,
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(0.5, -8, 0.5, -8),
        Parent = MinimizeBtn
    })
    
    -- Close Button
    local CloseBtn = Create("TextButton", {
        Name = "Close",
        BackgroundColor3 = Color3.fromRGB(220, 60, 60),
        Size = UDim2.new(0, 30, 0, 30),
        Text = "",
        Parent = ControlsFrame
    })
    AddCorner(CloseBtn, 6)
    
    local CloseIcon = Create("ImageLabel", {
        BackgroundTransparency = 1,
        Image = GetIcon("X"),
        ImageColor3 = Config.TextColor,
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(0.5, -8, 0.5, -8),
        Parent = CloseBtn
    })
    
    -- Tab Container
    local TabContainer = Create("Frame", {
        Name = "TabContainer",
        BackgroundColor3 = Config.SecondaryColor,
        Size = UDim2.new(0, 140, 1, -60),
        Position = UDim2.new(0, 5, 0, 55),
        Parent = MainFrame
    })
    AddCorner(TabContainer, 8)
    
    local TabScroll = Create("ScrollingFrame", {
        Name = "TabScroll",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -10, 1, -10),
        Position = UDim2.new(0, 5, 0, 5),
        ScrollBarThickness = 2,
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
        Size = UDim2.new(1, -160, 1, -60),
        Position = UDim2.new(0, 150, 0, 55),
        Parent = MainFrame
    })
    AddCorner(ContentContainer, 8)
    
    -- Make draggable
    MakeDraggable(MainFrame, TitleBar)
    
    -- Minimize functionality
    local isMinimized = false
    local originalSize = MainFrame.Size
    
    MinimizeBtn.MouseButton1Click:Connect(function()
        CreateRipple(MinimizeBtn)
        isMinimized = not isMinimized
        
        if isMinimized then
            Tween(MainFrame, {Size = UDim2.new(0, originalSize.X.Offset, 0, 50)})
            TabContainer.Visible = false
            ContentContainer.Visible = false
            MinimizeIcon.Image = GetIcon("Maximize")
        else
            Tween(MainFrame, {Size = originalSize})
            task.delay(0.2, function()
                TabContainer.Visible = true
                ContentContainer.Visible = true
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
    
    -- Window object
    local Window = {}
    Window.Tabs = {}
    Window.ActiveTab = nil
    Window.ScreenGui = ScreenGui
    Window.MainFrame = MainFrame
    
    function Window:CreateTab(options)
        options = options or {}
        local tabName = options.Name or "Tab"
        local tabIcon = options.Icon or "Circle"
        
        -- Tab Button
        local TabButton = Create("TextButton", {
            Name = tabName,
            BackgroundColor3 = Config.BorderColor,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 35),
            Text = "",
            Parent = TabScroll
        })
        AddCorner(TabButton, 6)
        
        local TabIconImage = Create("ImageLabel", {
            BackgroundTransparency = 1,
            Image = GetIcon(tabIcon),
            ImageColor3 = Config.SecondaryTextColor,
            Size = UDim2.new(0, 18, 0, 18),
            Position = UDim2.new(0, 10, 0.5, -9),
            Parent = TabButton
        })
        
        local TabLabel = Create("TextLabel", {
            BackgroundTransparency = 1,
            Text = tabName,
            TextColor3 = Config.SecondaryTextColor,
            Font = Config.Font,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            Size = UDim2.new(1, -40, 1, 0),
            Position = UDim2.new(0, 35, 0, 0),
            Parent = TabButton
        })
        
        -- Content Page
        local ContentPage = Create("ScrollingFrame", {
            Name = tabName .. "Page",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -20, 1, -20),
            Position = UDim2.new(0, 10, 0, 10),
            ScrollBarThickness = 3,
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
            -- Deselect all tabs
            for _, tab in pairs(Window.Tabs) do
                Tween(tab.Button, {BackgroundTransparency = 1})
                Tween(tab.Icon, {ImageColor3 = Config.SecondaryTextColor})
                Tween(tab.Label, {TextColor3 = Config.SecondaryTextColor})
                tab.Page.Visible = false
            end
            
            -- Select this tab
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
        
        -- Select first tab by default
        if #Window.Tabs == 1 or not Window.ActiveTab then
            SelectTab()
        end
        
        -- Section creator
        function Tab:CreateSection(options)
            options = options or {}
            local sectionName = options.Name or "Section"
            
            local SectionFrame = Create("Frame", {
                Name = sectionName,
                BackgroundColor3 = Config.MainColor,
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                Parent = ContentPage
            })
            AddCorner(SectionFrame, 8)
            AddStroke(SectionFrame, Config.BorderColor, 1)
            
            local SectionHeader = Create("Frame", {
                Name = "Header",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 35),
                Parent = SectionFrame
            })
            
            local SectionTitle = Create("TextLabel", {
                BackgroundTransparency = 1,
                Text = sectionName,
                TextColor3 = Config.TextColor,
                Font = Enum.Font.GothamBold,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Position = UDim2.new(0, 12, 0, 0),
                Size = UDim2.new(1, -24, 1, 0),
                Parent = SectionHeader
            })
            
            local SectionContent = Create("Frame", {
                Name = "Content",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -20, 0, 0),
                Position = UDim2.new(0, 10, 0, 35),
                AutomaticSize = Enum.AutomaticSize.Y,
                Parent = SectionFrame
            })
            
            local SectionLayout = Create("UIListLayout", {
                Padding = UDim.new(0, 8),
                Parent = SectionContent
            })
            
            local SectionPadding = Create("UIPadding", {
                PaddingBottom = UDim.new(0, 10),
                Parent = SectionContent
            })
            
            local Section = {}
            
            -- Label
            function Section:CreateLabel(options)
                options = options or {}
                local text = options.Text or "Label"
                local icon = options.Icon
                
                local LabelFrame = Create("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 25),
                    Parent = SectionContent
                })
                
                local xOffset = 0
                if icon then
                    local IconImg = Create("ImageLabel", {
                        BackgroundTransparency = 1,
                        Image = GetIcon(icon),
                        ImageColor3 = Config.AccentColor,
                        Size = UDim2.new(0, 16, 0, 16),
                        Position = UDim2.new(0, 0, 0.5, -8),
                        Parent = LabelFrame
                    })
                    xOffset = 22
                end
                
                local LabelText = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Text = text,
                    TextColor3 = Config.TextColor,
                    Font = Config.Font,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2.new(0, xOffset, 0, 0),
                    Size = UDim2.new(1, -xOffset, 1, 0),
                    Parent = LabelFrame
                })
                
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
                    TextSize = 13,
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
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextYAlignment = Enum.TextYAlignment.Top,
                    TextWrapped = true,
                    Position = UDim2.new(0, 10, 0, 28),
                    Size = UDim2.new(1, -20, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    Parent = ParagraphFrame
                })
                
                local ParagraphPadding = Create("UIPadding", {
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
            
            -- Button
            function Section:CreateButton(options)
                options = options or {}
                local text = options.Text or "Button"
                local icon = options.Icon
                local callback = options.Callback or function() end
                
                local ButtonFrame = Create("TextButton", {
                    BackgroundColor3 = Config.AccentColor,
                    Size = UDim2.new(1, 0, 0, 35),
                    Text = "",
                    AutoButtonColor = false,
                    ClipsDescendants = true,
                    Parent = SectionContent
                })
                AddCorner(ButtonFrame, 6)
                
                local xOffset = 0
                if icon then
                    local IconImg = Create("ImageLabel", {
                        BackgroundTransparency = 1,
                        Image = GetIcon(icon),
                        ImageColor3 = Config.TextColor,
                        Size = UDim2.new(0, 18, 0, 18),
                        Position = UDim2.new(0, 12, 0.5, -9),
                        Parent = ButtonFrame
                    })
                    xOffset = 22
                end
                
                local ButtonText = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Text = text,
                    TextColor3 = Config.TextColor,
                    Font = Config.Font,
                    TextSize = 14,
                    Position = UDim2.new(0, 12 + xOffset, 0, 0),
                    Size = UDim2.new(1, -24 - xOffset, 1, 0),
                    TextXAlignment = icon and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center,
                    Parent = ButtonFrame
                })
                
                ButtonFrame.MouseButton1Click:Connect(function()
                    CreateRipple(ButtonFrame)
                    callback()
                end)
                
                ButtonFrame.MouseEnter:Connect(function()
                    Tween(ButtonFrame, {BackgroundColor3 = Color3.fromRGB(108, 121, 255)})
                end)
                ButtonFrame.MouseLeave:Connect(function()
                    Tween(ButtonFrame, {BackgroundColor3 = Config.AccentColor})
                end)
                
                local ButtonObj = {}
                function ButtonObj:SetText(newText)
                    ButtonText.Text = newText
                end
                return ButtonObj
            end
            
            -- Toggle
            function Section:CreateToggle(options)
                options = options or {}
                local text = options.Text or "Toggle"
                local default = options.Default or false
                local callback = options.Callback or function() end
                local icon = options.Icon
                
                local ToggleFrame = Create("Frame", {
                    BackgroundColor3 = Config.SecondaryColor,
                    Size = UDim2.new(1, 0, 0, 40),
                    Parent = SectionContent
                })
                AddCorner(ToggleFrame, 6)
                
                local xOffset = 0
                if icon then
                    local IconImg = Create("ImageLabel", {
                        BackgroundTransparency = 1,
                        Image = GetIcon(icon),
                        ImageColor3 = Config.AccentColor,
                        Size = UDim2.new(0, 18, 0, 18),
                        Position = UDim2.new(0, 10, 0.5, -9),
                        Parent = ToggleFrame
                    })
                    xOffset = 25
                end
                
                local ToggleLabel = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Text = text,
                    TextColor3 = Config.TextColor,
                    Font = Config.Font,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2.new(0, 10 + xOffset, 0, 0),
                    Size = UDim2.new(1, -70 - xOffset, 1, 0),
                    Parent = ToggleFrame
                })
                
                local ToggleButton = Create("TextButton", {
                    BackgroundColor3 = default and Config.ToggleOnColor or Config.ToggleOffColor,
                    Size = UDim2.new(0, 44, 0, 24),
                    Position = UDim2.new(1, -54, 0.5, -12),
                    Text = "",
                    AutoButtonColor = false,
                    Parent = ToggleFrame
                })
                AddCorner(ToggleButton, 12)
                
                local ToggleCircle = Create("Frame", {
                    BackgroundColor3 = Config.TextColor,
                    Size = UDim2.new(0, 18, 0, 18),
                    Position = default and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9),
                    Parent = ToggleButton
                })
                AddCorner(ToggleCircle, 9)
                
                local toggled = default
                
                local function UpdateToggle()
                    if toggled then
                        Tween(ToggleButton, {BackgroundColor3 = Config.ToggleOnColor})
                        Tween(ToggleCircle, {Position = UDim2.new(1, -21, 0.5, -9)})
                    else
                        Tween(ToggleButton, {BackgroundColor3 = Config.ToggleOffColor})
                        Tween(ToggleCircle, {Position = UDim2.new(0, 3, 0.5, -9)})
                    end
                    callback(toggled)
                end
                
                ToggleButton.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    UpdateToggle()
                end)
                
                local ToggleObj = {}
                function ToggleObj:Set(value)
                    toggled = value
                    UpdateToggle()
                end
                function ToggleObj:Get()
                    return toggled
                end
                return ToggleObj
            end
            
            -- Slider
            function Section:CreateSlider(options)
                options = options or {}
                local text = options.Text or "Slider"
                local min = options.Min or 0
                local max = options.Max or 100
                local default = options.Default or min
                local increment = options.Increment or 1
                local callback = options.Callback or function() end
                local icon = options.Icon
                
                local SliderFrame = Create("Frame", {
                    BackgroundColor3 = Config.SecondaryColor,
                    Size = UDim2.new(1, 0, 0, 55),
                    Parent = SectionContent
                })
                AddCorner(SliderFrame, 6)
                
                local xOffset = 0
                if icon then
                    local IconImg = Create("ImageLabel", {
                        BackgroundTransparency = 1,
                        Image = GetIcon(icon),
                        ImageColor3 = Config.AccentColor,
                        Size = UDim2.new(0, 18, 0, 18),
                        Position = UDim2.new(0, 10, 0, 8),
                        Parent = SliderFrame
                    })
                    xOffset = 25
                end
                
                local SliderLabel = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Text = text,
                    TextColor3 = Config.TextColor,
                    Font = Config.Font,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2.new(0, 10 + xOffset, 0, 5),
                    Size = UDim2.new(1, -70 - xOffset, 0, 20),
                    Parent = SliderFrame
                })
                
                local ValueLabel = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Text = tostring(default),
                    TextColor3 = Config.AccentColor,
                    Font = Enum.Font.GothamBold,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    Position = UDim2.new(1, -50, 0, 5),
                    Size = UDim2.new(0, 40, 0, 20),
                    Parent = SliderFrame
                })
                
                local SliderBG = Create("Frame", {
                    BackgroundColor3 = Config.BorderColor,
                    Size = UDim2.new(1, -20, 0, 8),
                    Position = UDim2.new(0, 10, 0, 35),
                    Parent = SliderFrame
                })
                AddCorner(SliderBG, 4)
                
                local SliderFill = Create("Frame", {
                    BackgroundColor3 = Config.AccentColor,
                    Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
                    Parent = SliderBG
                })
                AddCorner(SliderFill, 4)
                
                local SliderKnob = Create("Frame", {
                    BackgroundColor3 = Config.TextColor,
                    Size = UDim2.new(0, 16, 0, 16),
                    Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8),
                    Parent = SliderBG
                })
                AddCorner(SliderKnob, 8)
                
                local currentValue = default
                local dragging = false
                
                local function UpdateSlider(input)
                    local pos = math.clamp((input.Position.X - SliderBG.AbsolutePosition.X) / SliderBG.AbsoluteSize.X, 0, 1)
                    local value = min + (max - min) * pos
                    value = math.floor(value / increment + 0.5) * increment
                    value = math.clamp(value, min, max)
                    
                    currentValue = value
                    local percent = (value - min) / (max - min)
                    
                    Tween(SliderFill, {Size = UDim2.new(percent, 0, 1, 0)}, 0.05)
                    Tween(SliderKnob, {Position = UDim2.new(percent, -8, 0.5, -8)}, 0.05)
                    ValueLabel.Text = tostring(value)
                    callback(value)
                end
                
                SliderBG.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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
                    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        UpdateSlider(input)
                    end
                end)
                
                local SliderObj = {}
                function SliderObj:Set(value)
                    currentValue = math.clamp(value, min, max)
                    local percent = (currentValue - min) / (max - min)
                    Tween(SliderFill, {Size = UDim2.new(percent, 0, 1, 0)})
                    Tween(SliderKnob, {Position = UDim2.new(percent, -8, 0.5, -8)})
                    ValueLabel.Text = tostring(currentValue)
                    callback(currentValue)
                end
                function SliderObj:Get()
                    return currentValue
                end
                return SliderObj
            end
            
            -- Input (TextBox)
            function Section:CreateInput(options)
                options = options or {}
                local text = options.Text or "Input"
                local placeholder = options.Placeholder or "Enter text..."
                local default = options.Default or ""
                local callback = options.Callback or function() end
                local icon = options.Icon
                
                local InputFrame = Create("Frame", {
                    BackgroundColor3 = Config.SecondaryColor,
                    Size = UDim2.new(1, 0, 0, 65),
                    Parent = SectionContent
                })
                AddCorner(InputFrame, 6)
                
                local xOffset = 0
                if icon then
                    local IconImg = Create("ImageLabel", {
                        BackgroundTransparency = 1,
                        Image = GetIcon(icon),
                        ImageColor3 = Config.AccentColor,
                        Size = UDim2.new(0, 18, 0, 18),
                        Position = UDim2.new(0, 10, 0, 8),
                        Parent = InputFrame
                    })
                    xOffset = 25
                end
                
                local InputLabel = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Text = text,
                    TextColor3 = Config.TextColor,
                    Font = Config.Font,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2.new(0, 10 + xOffset, 0, 5),
                    Size = UDim2.new(1, -20 - xOffset, 0, 20),
                    Parent = InputFrame
                })
                
                local TextBoxFrame = Create("Frame", {
                    BackgroundColor3 = Config.MainColor,
                    Size = UDim2.new(1, -20, 0, 30),
                    Position = UDim2.new(0, 10, 0, 28),
                    Parent = InputFrame
                })
                AddCorner(TextBoxFrame, 6)
                AddStroke(TextBoxFrame, Config.BorderColor, 1)
                
                local TextBox = Create("TextBox", {
                    BackgroundTransparency = 1,
                    Text = default,
                    PlaceholderText = placeholder,
                    PlaceholderColor3 = Config.SecondaryTextColor,
                    TextColor3 = Config.TextColor,
                    Font = Config.Font,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ClearTextOnFocus = false,
                    Size = UDim2.new(1, -16, 1, 0),
                    Position = UDim2.new(0, 8, 0, 0),
                    Parent = TextBoxFrame
                })
                
                TextBox.FocusLost:Connect(function(enterPressed)
                    callback(TextBox.Text, enterPressed)
                end)
                
                TextBox.Focused:Connect(function()
                    Tween(TextBoxFrame, {BackgroundColor3 = Config.SecondaryColor})
                end)
                
                TextBox.FocusLost:Connect(function()
                    Tween(TextBoxFrame, {BackgroundColor3 = Config.MainColor})
                end)
                
                local InputObj = {}
                function InputObj:SetText(newText)
                    TextBox.Text = newText
                end
                function InputObj:GetText()
                    return TextBox.Text
                end
                return InputObj
            end
            
            -- Dropdown
            function Section:CreateDropdown(options)
                options = options or {}
                local text = options.Text or "Dropdown"
                local items = options.Items or {}
                local default = options.Default
                local multi = options.Multi or false
                local callback = options.Callback or function() end
                local icon = options.Icon
                
                local DropdownFrame = Create("Frame", {
                    BackgroundColor3 = Config.SecondaryColor,
                    Size = UDim2.new(1, 0, 0, 65),
                    ClipsDescendants = true,
                    Parent = SectionContent
                })
                AddCorner(DropdownFrame, 6)
                
                local xOffset = 0
                if icon then
                    local IconImg = Create("ImageLabel", {
                        BackgroundTransparency = 1,
                        Image = GetIcon(icon),
                        ImageColor3 = Config.AccentColor,
                        Size = UDim2.new(0, 18, 0, 18),
                        Position = UDim2.new(0, 10, 0, 8),
                        Parent = DropdownFrame
                    })
                    xOffset = 25
                end
                
                local DropdownLabel = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Text = text,
                    TextColor3 = Config.TextColor,
                    Font = Config.Font,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2.new(0, 10 + xOffset, 0, 5),
                    Size = UDim2.new(1, -20 - xOffset, 0, 20),
                    Parent = DropdownFrame
                })
                
                local DropdownButton = Create("TextButton", {
                    BackgroundColor3 = Config.MainColor,
                    Size = UDim2.new(1, -20, 0, 30),
                    Position = UDim2.new(0, 10, 0, 28),
                    Text = "",
                    AutoButtonColor = false,
                    Parent = DropdownFrame
                })
                AddCorner(DropdownButton, 6)
                AddStroke(DropdownButton, Config.BorderColor, 1)
                
                local SelectedLabel = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Text = default or "Select...",
                    TextColor3 = default and Config.TextColor or Config.SecondaryTextColor,
                    Font = Config.Font,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2.new(0, 10, 0, 0),
                    Size = UDim2.new(1, -40, 1, 0),
                    Parent = DropdownButton
                })
                
                local ArrowIcon = Create("ImageLabel", {
                    BackgroundTransparency = 1,
                    Image = GetIcon("ChevronDown"),
                    ImageColor3 = Config.SecondaryTextColor,
                    Size = UDim2.new(0, 16, 0, 16),
                    Position = UDim2.new(1, -26, 0.5, -8),
                    Parent = DropdownButton
                })
                
                local OptionsFrame = Create("Frame", {
                    BackgroundColor3 = Config.MainColor,
                    Size = UDim2.new(1, -20, 0, 0),
                    Position = UDim2.new(0, 10, 0, 63),
                    ClipsDescendants = true,
                    Parent = DropdownFrame
                })
                AddCorner(OptionsFrame, 6)
                
                local OptionsLayout = Create("UIListLayout", {
                    Padding = UDim.new(0, 2),
                    Parent = OptionsFrame
                })
                
                local OptionsPadding = Create("UIPadding", {
                    PaddingTop = UDim.new(0, 4),
                    PaddingBottom = UDim.new(0, 4),
                    PaddingLeft = UDim.new(0, 4),
                    PaddingRight = UDim.new(0, 4),
                    Parent = OptionsFrame
                })
                
                local isOpen = false
                local selected = multi and {} or nil
                
                if default and not multi then
                    selected = default
                    SelectedLabel.Text = default
                    SelectedLabel.TextColor3 = Config.TextColor
                end
                
                local function UpdateDropdownSize()
                    local contentSize = OptionsLayout.AbsoluteContentSize.Y + 8
                    if isOpen then
                        Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 68 + contentSize)})
                        Tween(OptionsFrame, {Size = UDim2.new(1, -20, 0, contentSize)})
                        Tween(ArrowIcon, {Rotation = 180})
                    else
                        Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 65)})
                        Tween(OptionsFrame, {Size = UDim2.new(1, -20, 0, 0)})
                        Tween(ArrowIcon, {Rotation = 0})
                    end
                end
                
                local function CreateOption(item)
                    local OptionButton = Create("TextButton", {
                        BackgroundColor3 = Config.SecondaryColor,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, 28),
                        Text = "",
                        AutoButtonColor = false,
                        Parent = OptionsFrame
                    })
                    AddCorner(OptionButton, 4)
                    
                    local OptionLabel = Create("TextLabel", {
                        BackgroundTransparency = 1,
                        Text = item,
                        TextColor3 = Config.TextColor,
                        Font = Config.Font,
                        TextSize = 12,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Position = UDim2.new(0, 8, 0, 0),
                        Size = UDim2.new(1, -16, 1, 0),
                        Parent = OptionButton
                    })
                    
                    OptionButton.MouseEnter:Connect(function()
                        Tween(OptionButton, {BackgroundTransparency = 0})
                    end)
                    OptionButton.MouseLeave:Connect(function()
                        Tween(OptionButton, {BackgroundTransparency = 1})
                    end)
                    
                    OptionButton.MouseButton1Click:Connect(function()
                        if multi then
                            if table.find(selected, item) then
                                table.remove(selected, table.find(selected, item))
                            else
                                table.insert(selected, item)
                            end
                            SelectedLabel.Text = #selected > 0 and table.concat(selected, ", ") or "Select..."
                            SelectedLabel.TextColor3 = #selected > 0 and Config.TextColor or Config.SecondaryTextColor
                            callback(selected)
                        else
                            selected = item
                            SelectedLabel.Text = item
                            SelectedLabel.TextColor3 = Config.TextColor
                            isOpen = false
                            UpdateDropdownSize()
                            callback(item)
                        end
                    end)
                    
                    return OptionButton
                end
                
                for _, item in ipairs(items) do
                    CreateOption(item)
                end
                
                DropdownButton.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    UpdateDropdownSize()
                end)
                
                local DropdownObj = {}
                function DropdownObj:SetItems(newItems)
                    for _, child in ipairs(OptionsFrame:GetChildren()) do
                        if child:IsA("TextButton") then
                            child:Destroy()
                        end
                    end
                    items = newItems
                    for _, item in ipairs(items) do
                        CreateOption(item)
                    end
                    UpdateDropdownSize()
                end
                function DropdownObj:SetValue(value)
                    if multi then
                        selected = type(value) == "table" and value or {value}
                        SelectedLabel.Text = #selected > 0 and table.concat(selected, ", ") or "Select..."
                    else
                        selected = value
                        SelectedLabel.Text = value
                    end
                    SelectedLabel.TextColor3 = Config.TextColor
                    callback(selected)
                end
                function DropdownObj:GetValue()
                    return selected
                end
                return DropdownObj
            end
            
            -- ColorPicker
            function Section:CreateColorPicker(options)
                options = options or {}
                local text = options.Text or "Color Picker"
                local default = options.Default or Color3.fromRGB(255, 255, 255)
                local callback = options.Callback or function() end
                local icon = options.Icon
                
                local ColorPickerFrame = Create("Frame", {
                    BackgroundColor3 = Config.SecondaryColor,
                    Size = UDim2.new(1, 0, 0, 40),
                    ClipsDescendants = true,
                    Parent = SectionContent
                })
                AddCorner(ColorPickerFrame, 6)
                
                local xOffset = 0
                if icon then
                    local IconImg = Create("ImageLabel", {
                        BackgroundTransparency = 1,
                        Image = GetIcon(icon),
                        ImageColor3 = Config.AccentColor,
                        Size = UDim2.new(0, 18, 0, 18),
                        Position = UDim2.new(0, 10, 0, 11),
                        Parent = ColorPickerFrame
                    })
                    xOffset = 25
                end
                
                local ColorLabel = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    Text = text,
                    TextColor3 = Config.TextColor,
                    Font = Config.Font,
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Position = UDim2.new(0, 10 + xOffset, 0, 0),
                    Size = UDim2.new(1, -80 - xOffset, 1, 0),
                    Parent = ColorPickerFrame
                })
                
                local ColorPreview = Create("TextButton", {
                    BackgroundColor3 = default,
                    Size = UDim2.new(0, 50, 0, 24),
                    Position = UDim2.new(1, -60, 0.5, -12),
                    Text = "",
                    AutoButtonColor = false,
                    Parent = ColorPickerFrame
                })
                AddCorner(ColorPreview, 6)
                AddStroke(ColorPreview, Config.BorderColor, 1)
                
                -- Color Picker Panel
                local PickerPanel = Create("Frame", {
                    BackgroundColor3 = Config.MainColor,
                    Size = UDim2.new(1, -20, 0, 150),
                    Position = UDim2.new(0, 10, 0, 45),
                    Visible = false,
                    Parent = ColorPickerFrame
                })
                AddCorner(PickerPanel, 6)
                
                -- Saturation/Value picker
                local SVPicker = Create("ImageLabel", {
                    BackgroundColor3 = Color3.fromRGB(255, 0, 0),
                    Size = UDim2.new(1, -60, 1, -40),
                    Position = UDim2.new(0, 5, 0, 5),
                    Image = "rbxassetid://4155801252",
                    Parent = PickerPanel
                })
                AddCorner(SVPicker, 4)
                
                local SVCursor = Create("Frame", {
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Size = UDim2.new(0, 12, 0, 12),
                    Position = UDim2.new(1, -6, 0, -6),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Parent = SVPicker
                })
                AddCorner(SVCursor, 6)
                AddStroke(SVCursor, Color3.fromRGB(0, 0, 0), 2)
                
                -- Hue slider
                local HueSlider = Create("ImageLabel", {
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Size = UDim2.new(0, 20, 1, -40),
                    Position = UDim2.new(1, -50, 0, 5),
                    Image = "rbxassetid://4155801252",
                    ImageColor3 = Color3.fromRGB(255, 255, 255),
                    Parent = PickerPanel
                })
                AddCorner(HueSlider, 4)
                
                -- Create hue gradient
                local HueGradient = Create("UIGradient", {
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
                    Size = UDim2.new(1, 4, 0, 6),
                    Position = UDim2.new(0, -2, 0, -3),
                    Parent = HueSlider
                })
                AddCorner(HueCursor, 3)
                AddStroke(HueCursor, Color3.fromRGB(0, 0, 0), 1)
                
                -- RGB Input
                local RGBFrame = Create("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -10, 0, 25),
                    Position = UDim2.new(0, 5, 1, -30),
                    Parent = PickerPanel
                })
                
                local RGBLayout = Create("UIListLayout", {
                    FillDirection = Enum.FillDirection.Horizontal,
                    Padding = UDim.new(0, 5),
                    Parent = RGBFrame
                })
                
                local currentColor = default
                local h, s, v = Color3.toHSV(default)
                
                local function UpdateColor()
                    currentColor = Color3.fromHSV(h, s, v)
                    ColorPreview.BackgroundColor3 = currentColor
                    SVPicker.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                    SVCursor.Position = UDim2.new(s, 0, 1 - v, 0)
                    HueCursor.Position = UDim2.new(0, -2, h, -3)
                    callback(currentColor)
                end
                
                -- SV Picker interaction
                local svDragging = false
                SVPicker.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        svDragging = true
                    end
                end)
                SVPicker.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        svDragging = false
                    end
                end)
                
                -- Hue Slider interaction
                local hueDragging = false
                HueSlider.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        hueDragging = true
                    end
                end)
                HueSlider.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        hueDragging = false
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement then
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
                
                local isOpen = false
                ColorPreview.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    PickerPanel.Visible = isOpen
                    Tween(ColorPickerFrame, {Size = UDim2.new(1, 0, 0, isOpen and 200 or 40)})
                end)
                
                UpdateColor()
                
                local ColorPickerObj = {}
                function ColorPickerObj:SetColor(color)
                    h, s, v = Color3.toHSV(color)
                    UpdateColor()
                end
                function ColorPickerObj:GetColor()
                    return currentColor
                end
                return ColorPickerObj
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
        
        local NotifContainer = ScreenGui:FindFirstChild("NotificationContainer")
        if not NotifContainer then
            NotifContainer = Create("Frame", {
                Name = "NotificationContainer",
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 300, 1, -20),
                Position = UDim2.new(1, -310, 0, 10),
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
            Size = UDim2.new(1, 0, 0, 70),
            Position = UDim2.new(1, 0, 0, 0),
            Parent = NotifContainer
        })
        AddCorner(NotifFrame, 8)
        AddShadow(NotifFrame)
        
        local NotifIcon = Create("ImageLabel", {
            BackgroundTransparency = 1,
            Image = GetIcon(icon),
            ImageColor3 = Config.AccentColor,
            Size = UDim2.new(0, 24, 0, 24),
            Position = UDim2.new(0, 15, 0, 15),
            Parent = NotifFrame
        })
        
        local NotifTitle = Create("TextLabel", {
            BackgroundTransparency = 1,
            Text = title,
            TextColor3 = Config.TextColor,
            Font = Enum.Font.GothamBold,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            Position = UDim2.new(0, 50, 0, 12),
            Size = UDim2.new(1, -60, 0, 20),
            Parent = NotifFrame
        })
        
        local NotifContent = Create("TextLabel", {
            BackgroundTransparency = 1,
            Text = content,
            TextColor3 = Config.SecondaryTextColor,
            Font = Config.Font,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            Position = UDim2.new(0, 50, 0, 32),
            Size = UDim2.new(1, -60, 0, 30),
            Parent = NotifFrame
        })
        
        local ProgressBar = Create("Frame", {
            BackgroundColor3 = Config.AccentColor,
            Size = UDim2.new(1, 0, 0, 3),
            Position = UDim2.new(0, 0, 1, -3),
            Parent = NotifFrame
        })
        
        -- Animate in
        NotifFrame.Position = UDim2.new(1, 20, 0, 0)
        Tween(NotifFrame, {Position = UDim2.new(0, 0, 0, 0)}, 0.3)
        Tween(ProgressBar, {Size = UDim2.new(0, 0, 0, 3)}, duration)
        
        task.delay(duration, function()
            Tween(NotifFrame, {Position = UDim2.new(1, 20, 0, 0)}, 0.3)
            task.delay(0.3, function()
                NotifFrame:Destroy()
            end)
        end)
    end
    
    -- Toggle UI visibility
    function Window:Toggle()
        MainFrame.Visible = not MainFrame.Visible
    end
    
    -- Destroy UI
    function Window:Destroy()
        ScreenGui:Destroy()
    end
    
    return Window
end

-- Return Library
return Library
