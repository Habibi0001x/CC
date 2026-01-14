local Library = {}

local cloneref = cloneref or function(service) return service end
local TweenService = cloneref(game:GetService("TweenService"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local RunService = cloneref(game:GetService("RunService"))
local CoreGui = cloneref(game:GetService("CoreGui"))
local Players = cloneref(game:GetService("Players"))
local HttpService = cloneref(game:GetService("HttpService"))

local Player = Players.LocalPlayer
local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

local Theme = {
    Primary = Color3.fromRGB(25, 25, 35),
    Secondary = Color3.fromRGB(30, 30, 42),
    Tertiary = Color3.fromRGB(35, 35, 50),
    Accent = Color3.fromRGB(100, 120, 255),
    AccentDark = Color3.fromRGB(80, 100, 220),
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(180, 180, 200),
    TextDisabled = Color3.fromRGB(100, 100, 120),
    Success = Color3.fromRGB(80, 200, 120),
    Error = Color3.fromRGB(255, 80, 80),
    Warning = Color3.fromRGB(255, 180, 50),
    Border = Color3.fromRGB(50, 50, 70),
    Shadow = Color3.fromRGB(0, 0, 0),
    Locked = Color3.fromRGB(60, 60, 80),
    CornerRadius = UDim.new(0, 8),
    CornerRadiusSmall = UDim.new(0, 4),
    Font = Enum.Font.GothamMedium,
    FontBold = Enum.Font.GothamBold,
    FontSize = IsMobile and 16 or 14,
    FontSizeSmall = IsMobile and 14 or 12,
    FontSizeLarge = IsMobile and 20 or 18,
    Padding = IsMobile and 12 or 8,
    ElementHeight = IsMobile and 44 or 36,
    AnimationSpeed = 0.2
}

local LucideIcons = {
    Check = "rbxassetid://7733960981",
    X = "rbxassetid://7743878857",
    ChevronDown = "rbxassetid://7733717447",
    ChevronUp = "rbxassetid://7733715557",
    Lock = "rbxassetid://7733756584",
    Unlock = "rbxassetid://7734053495",
    Search = "rbxassetid://7733972100",
    Settings = "rbxassetid://7734053113",
    Home = "rbxassetid://7733718307",
    User = "rbxassetid://7734053759",
    Bell = "rbxassetid://7733658504",
    Info = "rbxassetid://7733716133",
    AlertCircle = "rbxassetid://7733658175",
    CheckCircle = "rbxassetid://7733716589",
    XCircle = "rbxassetid://7743878648",
    Minimize = "rbxassetid://7733756803",
    Maximize = "rbxassetid://7733756311",
    Menu = "rbxassetid://7733756440",
    Plus = "rbxassetid://7733756967",
    Minus = "rbxassetid://7733756655",
    Edit = "rbxassetid://7733717590",
    Trash = "rbxassetid://7734053253",
    Save = "rbxassetid://7733972252",
    Download = "rbxassetid://7733717774",
    Upload = "rbxassetid://7734053627",
    Refresh = "rbxassetid://7733971840",
    Eye = "rbxassetid://7733717992",
    EyeOff = "rbxassetid://7733718119",
    Keyboard = "rbxassetid://7733756236"
}

local function SafeCall(callback, ...)
    if type(callback) == "function" then
        local success, result = pcall(callback, ...)
        if not success then
            warn("[UI Library] Callback error: " .. tostring(result))
        end
        return success, result
    end
    return false, nil
end

local function Tween(instance, properties, duration, easingStyle, easingDirection)
    local tweenInfo = TweenInfo.new(
        duration or Theme.AnimationSpeed,
        easingStyle or Enum.EasingStyle.Quart,
        easingDirection or Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(instance, tweenInfo, properties)
    tween:Play()
    return tween
end

local function Create(className, properties, children)
    local instance = Instance.new(className)
    for prop, value in pairs(properties or {}) do
        if prop ~= "Parent" then
            local success = pcall(function()
                instance[prop] = value
            end)
        end
    end
    for _, child in pairs(children or {}) do
        child.Parent = instance
    end
    if properties and properties.Parent then
        instance.Parent = properties.Parent
    end
    return instance
end

local function AddCorner(parent, radius)
    return Create("UICorner", {
        CornerRadius = radius or Theme.CornerRadius,
        Parent = parent
    })
end

local function AddStroke(parent, color, thickness)
    return Create("UIStroke", {
        Color = color or Theme.Border,
        Thickness = thickness or 1,
        Parent = parent
    })
end

local function AddPadding(parent, padding)
    return Create("UIPadding", {
        PaddingTop = UDim.new(0, padding or Theme.Padding),
        PaddingBottom = UDim.new(0, padding or Theme.Padding),
        PaddingLeft = UDim.new(0, padding or Theme.Padding),
        PaddingRight = UDim.new(0, padding or Theme.Padding),
        Parent = parent
    })
end

local function AddListLayout(parent, padding, direction, horizontalAlignment, verticalAlignment)
    return Create("UIListLayout", {
        Padding = UDim.new(0, padding or Theme.Padding),
        FillDirection = direction or Enum.FillDirection.Vertical,
        HorizontalAlignment = horizontalAlignment or Enum.HorizontalAlignment.Left,
        VerticalAlignment = verticalAlignment or Enum.VerticalAlignment.Top,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = parent
    })
end

local function GetTextSize(text, fontSize, font, maxWidth)
    local textService = cloneref(game:GetService("TextService"))
    local success, size = pcall(function()
        return textService:GetTextSize(text, fontSize, font, Vector2.new(maxWidth or 9999, 9999))
    end)
    return success and size or Vector2.new(100, 20)
end

local NotificationSystem = {}
NotificationSystem.Notifications = {}
NotificationSystem.Container = nil

function NotificationSystem:Init(parent)
    self.Container = Create("Frame", {
        Name = "NotificationContainer",
        Size = UDim2.new(0, IsMobile and 280 or 320, 1, 0),
        Position = UDim2.new(1, -(IsMobile and 290 or 330), 0, 0),
        BackgroundTransparency = 1,
        Parent = parent
    })
    
    AddListLayout(self.Container, 8, Enum.FillDirection.Vertical, Enum.HorizontalAlignment.Right, Enum.VerticalAlignment.Bottom)
    AddPadding(self.Container, 10)
end

function NotificationSystem:Notify(options)
    if not self.Container then return end
    
    local title = options.Title or "Notification"
    local message = options.Message or ""
    local duration = options.Duration or 3
    local notifType = options.Type or "Info"
    local icon = options.Icon
    
    local typeColors = {
        Info = Theme.Accent,
        Success = Theme.Success,
        Warning = Theme.Warning,
        Error = Theme.Error
    }
    
    local typeIcons = {
        Info = LucideIcons.Info,
        Success = LucideIcons.CheckCircle,
        Warning = LucideIcons.AlertCircle,
        Error = LucideIcons.XCircle
    }
    
    local accentColor = typeColors[notifType] or Theme.Accent
    local notifIcon = icon or typeIcons[notifType] or LucideIcons.Info
    
    local notification = Create("Frame", {
        Name = "Notification",
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundColor3 = Theme.Secondary,
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Parent = self.Container
    })
    
    AddCorner(notification)
    AddStroke(notification, accentColor)
    
    local accentBar = Create("Frame", {
        Size = UDim2.new(0, 3, 1, 0),
        BackgroundColor3 = accentColor,
        BorderSizePixel = 0,
        Parent = notification
    })
    
    local content = Create("Frame", {
        Size = UDim2.new(1, -15, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        Parent = notification
    })
    
    AddPadding(content, 10)
    
    local iconImage = Create("ImageLabel", {
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Image = notifIcon,
        ImageColor3 = accentColor,
        Parent = content
    })
    
    local titleLabel = Create("TextLabel", {
        Size = UDim2.new(1, -30, 0, 18),
        Position = UDim2.new(0, 28, 0, 0),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Theme.Text,
        TextSize = Theme.FontSize,
        Font = Theme.FontBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = content
    })
    
    local messageLabel = Create("TextLabel", {
        Size = UDim2.new(1, -30, 0, 0),
        Position = UDim2.new(0, 28, 0, 22),
        BackgroundTransparency = 1,
        Text = message,
        TextColor3 = Theme.TextDark,
        TextSize = Theme.FontSizeSmall,
        Font = Theme.Font,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true,
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent = content
    })
    
    local totalHeight = 22 + GetTextSize(message, Theme.FontSizeSmall, Theme.Font, notification.AbsoluteSize.X - 60).Y + 20
    notification.Size = UDim2.new(1, 0, 0, math.max(60, totalHeight))
    
    Tween(notification, {BackgroundTransparency = 0}, 0.3)
    
    task.delay(duration, function()
        Tween(notification, {BackgroundTransparency = 1}, 0.3)
        task.wait(0.3)
        pcall(function()
            notification:Destroy()
        end)
    end)
    
    return notification
end

local TooltipSystem = {}
TooltipSystem.Tooltip = nil
TooltipSystem.Active = false

function TooltipSystem:Init(parent)
    self.Tooltip = Create("Frame", {
        Name = "Tooltip",
        Size = UDim2.new(0, 200, 0, 30),
        BackgroundColor3 = Theme.Tertiary,
        Visible = false,
        ZIndex = 100,
        Parent = parent
    })
    
    AddCorner(self.Tooltip, Theme.CornerRadiusSmall)
    AddStroke(self.Tooltip, Theme.Border)
    
    self.Label = Create("TextLabel", {
        Size = UDim2.new(1, -16, 1, 0),
        Position = UDim2.new(0, 8, 0, 0),
        BackgroundTransparency = 1,
        Text = "",
        TextColor3 = Theme.Text,
        TextSize = Theme.FontSizeSmall,
        Font = Theme.Font,
        TextWrapped = true,
        ZIndex = 101,
        Parent = self.Tooltip
    })
end

function TooltipSystem:Show(text, position)
    if not self.Tooltip then return end
    
    local textSize = GetTextSize(text, Theme.FontSizeSmall, Theme.Font, 200)
    self.Tooltip.Size = UDim2.new(0, math.min(textSize.X + 16, 250), 0, textSize.Y + 12)
    self.Label.Text = text
    
    local xPos = math.clamp(position.X, 0, workspace.CurrentCamera.ViewportSize.X - self.Tooltip.AbsoluteSize.X)
    local yPos = math.clamp(position.Y + 20, 0, workspace.CurrentCamera.ViewportSize.Y - self.Tooltip.AbsoluteSize.Y)
    
    self.Tooltip.Position = UDim2.new(0, xPos, 0, yPos)
    self.Tooltip.Visible = true
    self.Active = true
end

function TooltipSystem:Hide()
    if self.Tooltip then
        self.Tooltip.Visible = false
        self.Active = false
    end
end

local ElementFactory = {}

function ElementFactory.CreateButton(parent, options)
    local text = options.Text or "Button"
    local callback = options.Callback or function() end
    local icon = options.Icon
    local locked = options.Locked or false
    local tooltip = options.Tooltip
    
    local element = {
        Type = "Button",
        Locked = locked,
        Enabled = true
    }
    
    local button = Create("TextButton", {
        Name = "Button",
        Size = UDim2.new(1, 0, 0, Theme.ElementHeight),
        BackgroundColor3 = Theme.Tertiary,
        Text = "",
        AutoButtonColor = false,
        Parent = parent
    })
    
    AddCorner(button)
    AddStroke(button, Theme.Border)
    
    local contentFrame = Create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Parent = button
    })
    
    local iconOffset = 0
    if icon then
        local iconImage = Create("ImageLabel", {
            Name = "Icon",
            Size = UDim2.new(0, 18, 0, 18),
            Position = UDim2.new(0, 12, 0.5, -9),
            BackgroundTransparency = 1,
            Image = LucideIcons[icon] or icon,
            ImageColor3 = Theme.Text,
            Parent = contentFrame
        })
        iconOffset = 28
    end
    
    local label = Create("TextLabel", {
        Name = "Label",
        Size = UDim2.new(1, -(iconOffset + 24), 1, 0),
        Position = UDim2.new(0, iconOffset + 12, 0, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Theme.Text,
        TextSize = Theme.FontSize,
        Font = Theme.Font,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = contentFrame
    })
    
    local lockIcon = Create("ImageLabel", {
        Name = "LockIcon",
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(1, -28, 0.5, -8),
        BackgroundTransparency = 1,
        Image = LucideIcons.Lock,
        ImageColor3 = Theme.TextDisabled,
        Visible = locked,
        Parent = contentFrame
    })
    
    local function UpdateLockState()
        if element.Locked then
            button.BackgroundColor3 = Theme.Locked
            label.TextColor3 = Theme.TextDisabled
            lockIcon.Visible = true
            if contentFrame:FindFirstChild("Icon") then
                contentFrame.Icon.ImageColor3 = Theme.TextDisabled
            end
        else
            button.BackgroundColor3 = Theme.Tertiary
            label.TextColor3 = Theme.Text
            lockIcon.Visible = false
            if contentFrame:FindFirstChild("Icon") then
                contentFrame.Icon.ImageColor3 = Theme.Text
            end
        end
    end
    
    button.MouseEnter:Connect(function()
        if not element.Locked and element.Enabled then
            Tween(button, {BackgroundColor3 = Theme.Accent}, 0.15)
        end
        if tooltip then
            TooltipSystem:Show(tooltip, UserInputService:GetMouseLocation())
        end
    end)
    
    button.MouseLeave:Connect(function()
        if not element.Locked and element.Enabled then
            Tween(button, {BackgroundColor3 = Theme.Tertiary}, 0.15)
        end
        TooltipSystem:Hide()
    end)
    
    button.MouseButton1Click:Connect(function()
        if not element.Locked and element.Enabled then
            Tween(button, {BackgroundColor3 = Theme.AccentDark}, 0.05)
            task.wait(0.05)
            Tween(button, {BackgroundColor3 = Theme.Accent}, 0.1)
            SafeCall(callback)
        end
    end)
    
    function element:SetLocked(state)
        element.Locked = state
        UpdateLockState()
    end
    
    function element:SetEnabled(state)
        element.Enabled = state
        button.Visible = state
    end
    
    function element:SetText(newText)
        label.Text = newText
    end
    
    function element:Destroy()
        pcall(function()
            button:Destroy()
        end)
    end
    
    element.Instance = button
    UpdateLockState()
    
    return element
end

function ElementFactory.CreateToggle(parent, options)
    local text = options.Text or "Toggle"
    local default = options.Default or false
    local callback = options.Callback or function() end
    local icon = options.Icon
    local locked = options.Locked or false
    local tooltip = options.Tooltip
    
    local element = {
        Type = "Toggle",
        Value = default,
        Locked = locked,
        Enabled = true
    }
    
    local toggle = Create("TextButton", {
        Name = "Toggle",
        Size = UDim2.new(1, 0, 0, Theme.ElementHeight),
        BackgroundColor3 = Theme.Tertiary,
        Text = "",
        AutoButtonColor = false,
        Parent = parent
    })
    
    AddCorner(toggle)
    AddStroke(toggle, Theme.Border)
    
    local iconOffset = 0
    if icon then
        local iconImage = Create("ImageLabel", {
            Name = "Icon",
            Size = UDim2.new(0, 18, 0, 18),
            Position = UDim2.new(0, 12, 0.5, -9),
            BackgroundTransparency = 1,
            Image = LucideIcons[icon] or icon,
            ImageColor3 = Theme.Text,
            Parent = toggle
        })
        iconOffset = 28
    end
    
    local label = Create("TextLabel", {
        Name = "Label",
        Size = UDim2.new(1, -(iconOffset + 70), 1, 0),
        Position = UDim2.new(0, iconOffset + 12, 0, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Theme.Text,
        TextSize = Theme.FontSize,
        Font = Theme.Font,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = toggle
    })
    
    local switchContainer = Create("Frame", {
        Name = "Switch",
        Size = UDim2.new(0, 44, 0, 24),
        Position = UDim2.new(1, -56, 0.5, -12),
        BackgroundColor3 = Theme.Secondary,
        Parent = toggle
    })
    
    AddCorner(switchContainer, UDim.new(0, 12))
    
    local switchCircle = Create("Frame", {
        Name = "Circle",
        Size = UDim2.new(0, 18, 0, 18),
        Position = UDim2.new(0, 3, 0.5, -9),
        BackgroundColor3 = Theme.TextDark,
        Parent = switchContainer
    })
    
    AddCorner(switchCircle, UDim.new(0, 9))
    
    local lockIcon = Create("ImageLabel", {
        Name = "LockIcon",
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(1, -75, 0.5, -8),
        BackgroundTransparency = 1,
        Image = LucideIcons.Lock,
        ImageColor3 = Theme.TextDisabled,
        Visible = locked,
        Parent = toggle
    })
    
    local function UpdateVisual()
        if element.Value then
            Tween(switchContainer, {BackgroundColor3 = Theme.Accent}, 0.2)
            Tween(switchCircle, {Position = UDim2.new(0, 23, 0.5, -9), BackgroundColor3 = Theme.Text}, 0.2)
        else
            Tween(switchContainer, {BackgroundColor3 = Theme.Secondary}, 0.2)
            Tween(switchCircle, {Position = UDim2.new(0, 3, 0.5, -9), BackgroundColor3 = Theme.TextDark}, 0.2)
        end
    end
    
    local function UpdateLockState()
        if element.Locked then
            toggle.BackgroundColor3 = Theme.Locked
            label.TextColor3 = Theme.TextDisabled
            lockIcon.Visible = true
        else
            toggle.BackgroundColor3 = Theme.Tertiary
            label.TextColor3 = Theme.Text
            lockIcon.Visible = false
        end
    end
    
    toggle.MouseEnter:Connect(function()
        if not element.Locked and element.Enabled then
            Tween(toggle, {BackgroundColor3 = Color3.fromRGB(40, 40, 55)}, 0.15)
        end
        if tooltip then
            TooltipSystem:Show(tooltip, UserInputService:GetMouseLocation())
        end
    end)
    
    toggle.MouseLeave:Connect(function()
        if not element.Locked and element.Enabled then
            Tween(toggle, {BackgroundColor3 = Theme.Tertiary}, 0.15)
        end
        TooltipSystem:Hide()
    end)
    
    toggle.MouseButton1Click:Connect(function()
        if not element.Locked and element.Enabled then
            element.Value = not element.Value
            UpdateVisual()
            SafeCall(callback, element.Value)
        end
    end)
    
    function element:SetValue(value)
        element.Value = value
        UpdateVisual()
    end
    
    function element:GetValue()
        return element.Value
    end
    
    function element:SetLocked(state)
        element.Locked = state
        UpdateLockState()
    end
    
    function element:SetEnabled(state)
        element.Enabled = state
        toggle.Visible = state
    end
    
    function element:Destroy()
        pcall(function()
            toggle:Destroy()
        end)
    end
    
    element.Instance = toggle
    UpdateVisual()
    UpdateLockState()
    
    return element
end

function ElementFactory.CreateSlider(parent, options)
    local text = options.Text or "Slider"
    local min = options.Min or 0
    local max = options.Max or 100
    local default = options.Default or min
    local increment = options.Increment or 1
    local callback = options.Callback or function() end
    local suffix = options.Suffix or ""
    local locked = options.Locked or false
    local tooltip = options.Tooltip
    
    local element = {
        Type = "Slider",
        Value = default,
        Locked = locked,
        Enabled = true
    }
    
    local slider = Create("Frame", {
        Name = "Slider",
        Size = UDim2.new(1, 0, 0, Theme.ElementHeight + 20),
        BackgroundColor3 = Theme.Tertiary,
        Parent = parent
    })
    
    AddCorner(slider)
    AddStroke(slider, Theme.Border)
    
    local label = Create("TextLabel", {
        Name = "Label",
        Size = UDim2.new(0.6, -12, 0, 20),
        Position = UDim2.new(0, 12, 0, 8),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Theme.Text,
        TextSize = Theme.FontSize,
        Font = Theme.Font,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = slider
    })
    
    local valueLabel = Create("TextLabel", {
        Name = "Value",
        Size = UDim2.new(0.4, -12, 0, 20),
        Position = UDim2.new(0.6, 0, 0, 8),
        BackgroundTransparency = 1,
        Text = tostring(default) .. suffix,
        TextColor3 = Theme.Accent,
        TextSize = Theme.FontSize,
        Font = Theme.FontBold,
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = slider
    })
    
    local sliderBar = Create("Frame", {
        Name = "Bar",
        Size = UDim2.new(1, -24, 0, 6),
        Position = UDim2.new(0, 12, 0, 38),
        BackgroundColor3 = Theme.Secondary,
        Parent = slider
    })
    
    AddCorner(sliderBar, UDim.new(0, 3))
    
    local sliderFill = Create("Frame", {
        Name = "Fill",
        Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
        BackgroundColor3 = Theme.Accent,
        Parent = sliderBar
    })
    
    AddCorner(sliderFill, UDim.new(0, 3))
    
    local sliderKnob = Create("Frame", {
        Name = "Knob",
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8),
        BackgroundColor3 = Theme.Text,
        Parent = sliderBar
    })
    
    AddCorner(sliderKnob, UDim.new(0, 8))
    
    local lockIcon = Create("ImageLabel", {
        Name = "LockIcon",
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(1, -28, 0, 10),
        BackgroundTransparency = 1,
        Image = LucideIcons.Lock,
        ImageColor3 = Theme.TextDisabled,
        Visible = locked,
        Parent = slider
    })
    
    local dragging = false
    
    local function UpdateSlider(input)
        if element.Locked or not element.Enabled then return end
        
        local barPos = sliderBar.AbsolutePosition.X
        local barSize = sliderBar.AbsoluteSize.X
        local mousePos = input.Position.X
        
        local percent = math.clamp((mousePos - barPos) / barSize, 0, 1)
        local value = min + (max - min) * percent
        value = math.floor(value / increment + 0.5) * increment
        value = math.clamp(value, min, max)
        
        element.Value = value
        
        local displayPercent = (value - min) / (max - min)
        sliderFill.Size = UDim2.new(displayPercent, 0, 1, 0)
        sliderKnob.Position = UDim2.new(displayPercent, -8, 0.5, -8)
        valueLabel.Text = tostring(value) .. suffix
        
        SafeCall(callback, value)
    end
    
    local function UpdateLockState()
        if element.Locked then
            slider.BackgroundColor3 = Theme.Locked
            label.TextColor3 = Theme.TextDisabled
            valueLabel.TextColor3 = Theme.TextDisabled
            sliderFill.BackgroundColor3 = Theme.TextDisabled
            lockIcon.Visible = true
        else
            slider.BackgroundColor3 = Theme.Tertiary
            label.TextColor3 = Theme.Text
            valueLabel.TextColor3 = Theme.Accent
            sliderFill.BackgroundColor3 = Theme.Accent
            lockIcon.Visible = false
        end
    end
    
    sliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if not element.Locked and element.Enabled then
                dragging = true
                UpdateSlider(input)
            end
        end
    end)
    
    sliderKnob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if not element.Locked and element.Enabled then
                dragging = true
            end
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            UpdateSlider(input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    slider.MouseEnter:Connect(function()
        if tooltip then
            TooltipSystem:Show(tooltip, UserInputService:GetMouseLocation())
        end
    end)
    
    slider.MouseLeave:Connect(function()
        TooltipSystem:Hide()
    end)
    
    function element:SetValue(value)
        value = math.clamp(value, min, max)
        element.Value = value
        local displayPercent = (value - min) / (max - min)
        sliderFill.Size = UDim2.new(displayPercent, 0, 1, 0)
        sliderKnob.Position = UDim2.new(displayPercent, -8, 0.5, -8)
        valueLabel.Text = tostring(value) .. suffix
    end
    
    function element:GetValue()
        return element.Value
    end
    
    function element:SetLocked(state)
        element.Locked = state
        UpdateLockState()
    end
    
    function element:SetEnabled(state)
        element.Enabled = state
        slider.Visible = state
    end
    
    function element:Destroy()
        pcall(function()
            slider:Destroy()
        end)
    end
    
    element.Instance = slider
    UpdateLockState()
    
    return element
end

function ElementFactory.CreateDropdown(parent, options)
    local text = options.Text or "Dropdown"
    local items = options.Items or {}
    local default = options.Default
    local callback = options.Callback or function() end
    local multi = options.Multi or false
    local searchable = options.Searchable or false
    local locked = options.Locked or false
    local tooltip = options.Tooltip
    
    local element = {
        Type = multi and "MultiDropdown" or "Dropdown",
        Value = multi and {} or default,
        Items = items,
        Locked = locked,
        Enabled = true,
        Open = false
    }
    
    if multi and default then
        for _, item in ipairs(default) do
            element.Value[item] = true
        end
    end
    
    local dropdown = Create("Frame", {
        Name = "Dropdown",
        Size = UDim2.new(1, 0, 0, Theme.ElementHeight),
        BackgroundColor3 = Theme.Tertiary,
        ClipsDescendants = false,
        Parent = parent
    })
    
    AddCorner(dropdown)
    AddStroke(dropdown, Theme.Border)
    
    local mainButton = Create("TextButton", {
        Name = "MainButton",
        Size = UDim2.new(1, 0, 0, Theme.ElementHeight),
        BackgroundTransparency = 1,
        Text = "",
        Parent = dropdown
    })
    
    local label = Create("TextLabel", {
        Name = "Label",
        Size = UDim2.new(0.5, -12, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Theme.Text,
        TextSize = Theme.FontSize,
        Font = Theme.Font,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = mainButton
    })
    
    local function GetDisplayText()
        if multi then
            local selected = {}
            for item, isSelected in pairs(element.Value) do
                if isSelected then
                    table.insert(selected, item)
                end
            end
            if #selected == 0 then
                return "None"
            elseif #selected <= 2 then
                return table.concat(selected, ", ")
            else
                return #selected .. " selected"
            end
        else
            return element.Value or "Select..."
        end
    end
    
    local valueLabel = Create("TextLabel", {
        Name = "Value",
        Size = UDim2.new(0.5, -36, 1, 0),
        Position = UDim2.new(0.5, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = GetDisplayText(),
        TextColor3 = Theme.TextDark,
        TextSize = Theme.FontSize,
        Font = Theme.Font,
        TextXAlignment = Enum.TextXAlignment.Right,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = mainButton
    })
    
    local arrowIcon = Create("ImageLabel", {
        Name = "Arrow",
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(1, -28, 0.5, -8),
        BackgroundTransparency = 1,
        Image = LucideIcons.ChevronDown,
        ImageColor3 = Theme.TextDark,
        Parent = mainButton
    })
    
    local lockIcon = Create("ImageLabel", {
        Name = "LockIcon",
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(1, -48, 0.5, -8),
        BackgroundTransparency = 1,
        Image = LucideIcons.Lock,
        ImageColor3 = Theme.TextDisabled,
        Visible = locked,
        Parent = mainButton
    })
    
    local dropdownContainer = Create("Frame", {
        Name = "Container",
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 1, 4),
        BackgroundColor3 = Theme.Secondary,
        ClipsDescendants = true,
        Visible = false,
        ZIndex = 50,
        Parent = dropdown
    })
    
    AddCorner(dropdownContainer)
    AddStroke(dropdownContainer, Theme.Border)
    
    local scrollFrame = Create("ScrollingFrame", {
        Name = "Scroll",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = Theme.Accent,
        BorderSizePixel = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ZIndex = 51,
        Parent = dropdownContainer
    })
    
    AddPadding(scrollFrame, 4)
    local scrollLayout = AddListLayout(scrollFrame, 2)
    
    local searchBox
    if searchable then
        local searchContainer = Create("Frame", {
            Name = "SearchContainer",
            Size = UDim2.new(1, -8, 0, 28),
            BackgroundColor3 = Theme.Tertiary,
            LayoutOrder = -1,
            ZIndex = 52,
            Parent = scrollFrame
        })
        
        AddCorner(searchContainer, Theme.CornerRadiusSmall)
        
        local searchIcon = Create("ImageLabel", {
            Size = UDim2.new(0, 14, 0, 14),
            Position = UDim2.new(0, 8, 0.5, -7),
            BackgroundTransparency = 1,
            Image = LucideIcons.Search,
            ImageColor3 = Theme.TextDark,
            ZIndex = 53,
            Parent = searchContainer
        })
        
        searchBox = Create("TextBox", {
            Name = "SearchBox",
            Size = UDim2.new(1, -30, 1, 0),
            Position = UDim2.new(0, 26, 0, 0),
            BackgroundTransparency = 1,
            Text = "",
            PlaceholderText = "Search...",
            PlaceholderColor3 = Theme.TextDisabled,
            TextColor3 = Theme.Text,
            TextSize = Theme.FontSizeSmall,
            Font = Theme.Font,
            TextXAlignment = Enum.TextXAlignment.Left,
            ClearTextOnFocus = false,
            ZIndex = 53,
            Parent = searchContainer
        })
    end
    
    local itemButtons = {}
    
    local function CreateItems(filter)
        for _, btn in pairs(itemButtons) do
            pcall(function() btn:Destroy() end)
        end
        itemButtons = {}
        
        local filteredItems = {}
        for _, item in ipairs(element.Items) do
            if not filter or filter == "" or string.find(string.lower(item), string.lower(filter)) then
                table.insert(filteredItems, item)
            end
        end
        
        for i, item in ipairs(filteredItems) do
            local itemBtn = Create("TextButton", {
                Name = "Item_" .. item,
                Size = UDim2.new(1, -8, 0, 28),
                BackgroundColor3 = Theme.Tertiary,
                BackgroundTransparency = 0.5,
                Text = "",
                AutoButtonColor = false,
                LayoutOrder = i,
                ZIndex = 52,
                Parent = scrollFrame
            })
            
            AddCorner(itemBtn, Theme.CornerRadiusSmall)
            
            local itemLabel = Create("TextLabel", {
                Size = UDim2.new(1, -36, 1, 0),
                Position = UDim2.new(0, 8, 0, 0),
                BackgroundTransparency = 1,
                Text = item,
                TextColor3 = Theme.Text,
                TextSize = Theme.FontSizeSmall,
                Font = Theme.Font,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 53,
                Parent = itemBtn
            })
            
            local checkIcon
            if multi then
                checkIcon = Create("ImageLabel", {
                    Size = UDim2.new(0, 14, 0, 14),
                    Position = UDim2.new(1, -22, 0.5, -7),
                    BackgroundTransparency = 1,
                    Image = LucideIcons.Check,
                    ImageColor3 = Theme.Accent,
                    Visible = element.Value[item] == true,
                    ZIndex = 53,
                    Parent = itemBtn
                })
            end
            
            itemBtn.MouseEnter:Connect(function()
                Tween(itemBtn, {BackgroundTransparency = 0}, 0.1)
            end)
            
            itemBtn.MouseLeave:Connect(function()
                Tween(itemBtn, {BackgroundTransparency = 0.5}, 0.1)
            end)
            
            itemBtn.MouseButton1Click:Connect(function()
                if multi then
                    element.Value[item] = not element.Value[item]
                    if checkIcon then
                        checkIcon.Visible = element.Value[item]
                    end
                    valueLabel.Text = GetDisplayText()
                    SafeCall(callback, element.Value)
                else
                    element.Value = item
                    valueLabel.Text = item
                    element.Open = false
                    Tween(arrowIcon, {Rotation = 0}, 0.2)
                    Tween(dropdownContainer, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
                    task.wait(0.2)
                    dropdownContainer.Visible = false
                    SafeCall(callback, item)
                end
            end)
            
            table.insert(itemButtons, itemBtn)
        end
        
        local totalHeight = #filteredItems * 30 + (searchable and 32 or 0) + 8
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
        
        return math.min(totalHeight, 200)
    end
    
    if searchable and searchBox then
        searchBox:GetPropertyChangedSignal("Text"):Connect(function()
            local newHeight = CreateItems(searchBox.Text)
            if element.Open then
                Tween(dropdownContainer, {Size = UDim2.new(1, 0, 0, newHeight)}, 0.15)
            end
        end)
    end
    
    local function UpdateLockState()
        if element.Locked then
            dropdown.BackgroundColor3 = Theme.Locked
            label.TextColor3 = Theme.TextDisabled
            valueLabel.TextColor3 = Theme.TextDisabled
            lockIcon.Visible = true
        else
            dropdown.BackgroundColor3 = Theme.Tertiary
            label.TextColor3 = Theme.Text
            valueLabel.TextColor3 = Theme.TextDark
            lockIcon.Visible = false
        end
    end
    
    mainButton.MouseButton1Click:Connect(function()
        if element.Locked or not element.Enabled then return end
        
        element.Open = not element.Open
        
        if element.Open then
            dropdownContainer.Visible = true
            local height = CreateItems(searchable and searchBox and searchBox.Text or nil)
            Tween(arrowIcon, {Rotation = 180}, 0.2)
            Tween(dropdownContainer, {Size = UDim2.new(1, 0, 0, height)}, 0.2)
        else
            Tween(arrowIcon, {Rotation = 0}, 0.2)
            Tween(dropdownContainer, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
            task.wait(0.2)
            dropdownContainer.Visible = false
        end
    end)
    
    mainButton.MouseEnter:Connect(function()
        if tooltip then
            TooltipSystem:Show(tooltip, UserInputService:GetMouseLocation())
        end
    end)
    
    mainButton.MouseLeave:Connect(function()
        TooltipSystem:Hide()
    end)
    
    function element:SetValue(value)
        if multi then
            element.Value = {}
            if type(value) == "table" then
                for _, item in ipairs(value) do
                    element.Value[item] = true
                end
            end
        else
            element.Value = value
        end
        valueLabel.Text = GetDisplayText()
    end
    
    function element:GetValue()
        if multi then
            local selected = {}
            for item, isSelected in pairs(element.Value) do
                if isSelected then
                    table.insert(selected, item)
                end
            end
            return selected
        else
            return element.Value
        end
    end
    
    function element:SetItems(newItems)
        element.Items = newItems
        if element.Open then
            CreateItems(searchable and searchBox and searchBox.Text or nil)
        end
    end
    
    function element:SetLocked(state)
        element.Locked = state
        UpdateLockState()
    end
    
    function element:SetEnabled(state)
        element.Enabled = state
        dropdown.Visible = state
    end
    
    function element:Destroy()
        pcall(function()
            dropdown:Destroy()
        end)
    end
    
    element.Instance = dropdown
    UpdateLockState()
    
    return element
end

function ElementFactory.CreateTextbox(parent, options)
    local text = options.Text or "Textbox"
    local placeholder = options.Placeholder or "Enter text..."
    local default = options.Default or ""
    local callback = options.Callback or function() end
    local validate = options.Validate
    local clearOnFocus = options.ClearOnFocus or false
    local locked = options.Locked or false
    local tooltip = options.Tooltip
    
    local element = {
        Type = "Textbox",
        Value = default,
        Locked = locked,
        Enabled = true
    }
    
    local textboxContainer = Create("Frame", {
        Name = "Textbox",
        Size = UDim2.new(1, 0, 0, Theme.ElementHeight),
        BackgroundColor3 = Theme.Tertiary,
        Parent = parent
    })
    
    AddCorner(textboxContainer)
    AddStroke(textboxContainer, Theme.Border)
    
    local label = Create("TextLabel", {
        Name = "Label",
        Size = UDim2.new(0.4, -12, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Theme.Text,
        TextSize = Theme.FontSize,
        Font = Theme.Font,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = textboxContainer
    })
    
    local inputContainer = Create("Frame", {
        Name = "InputContainer",
        Size = UDim2.new(0.6, -16, 0, 26),
        Position = UDim2.new(0.4, 4, 0.5, -13),
        BackgroundColor3 = Theme.Secondary,
        Parent = textboxContainer
    })
    
    AddCorner(inputContainer, Theme.CornerRadiusSmall)
    
    local textbox = Create("TextBox", {
        Name = "Input",
        Size = UDim2.new(1, -16, 1, 0),
        Position = UDim2.new(0, 8, 0, 0),
        BackgroundTransparency = 1,
        Text = default,
        PlaceholderText = placeholder,
        PlaceholderColor3 = Theme.TextDisabled,
        TextColor3 = Theme.Text,
        TextSize = Theme.FontSize,
        Font = Theme.Font,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = clearOnFocus,
        Parent = inputContainer
    })
    
    local lockIcon = Create("ImageLabel", {
        Name = "LockIcon",
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(1, -28, 0.5, -8),
        BackgroundTransparency = 1,
        Image = LucideIcons.Lock,
        ImageColor3 = Theme.TextDisabled,
        Visible = locked,
        Parent = textboxContainer
    })
    
    local function UpdateLockState()
        if element.Locked then
            textboxContainer.BackgroundColor3 = Theme.Locked
            label.TextColor3 = Theme.TextDisabled
            textbox.TextEditable = false
            lockIcon.Visible = true
        else
            textboxContainer.BackgroundColor3 = Theme.Tertiary
            label.TextColor3 = Theme.Text
            textbox.TextEditable = true
            lockIcon.Visible = false
        end
    end
    
    textbox.Focused:Connect(function()
        if not element.Locked and element.Enabled then
            Tween(inputContainer, {BackgroundColor3 = Theme.Accent}, 0.15)
        end
    end)
    
    textbox.FocusLost:Connect(function(enterPressed)
        Tween(inputContainer, {BackgroundColor3 = Theme.Secondary}, 0.15)
        
        if element.Locked or not element.Enabled then return end
        
        local newValue = textbox.Text
        
        if validate then
            local valid, result = SafeCall(validate, newValue)
            if valid and result == false then
                textbox.Text = element.Value
                return
            end
        end
        
        element.Value = newValue
        SafeCall(callback, newValue, enterPressed)
    end)
    
    textboxContainer.MouseEnter:Connect(function()
        if tooltip then
            TooltipSystem:Show(tooltip, UserInputService:GetMouseLocation())
        end
    end)
    
    textboxContainer.MouseLeave:Connect(function()
        TooltipSystem:Hide()
    end)
    
    function element:SetValue(value)
        element.Value = value
        textbox.Text = value
    end
    
    function element:GetValue()
        return element.Value
    end
    
    function element:SetLocked(state)
        element.Locked = state
        UpdateLockState()
    end
    
    function element:SetEnabled(state)
        element.Enabled = state
        textboxContainer.Visible = state
    end
    
    function element:Destroy()
        pcall(function()
            textboxContainer:Destroy()
        end)
    end
    
    element.Instance = textboxContainer
    UpdateLockState()
    
    return element
end

function ElementFactory.CreateLabel(parent, options)
    local text = options.Text or "Label"
    local icon = options.Icon
    local color = options.Color or Theme.Text
    
    local element = {
        Type = "Label",
        Enabled = true
    }
    
    local labelContainer = Create("Frame", {
        Name = "Label",
        Size = UDim2.new(1, 0, 0, 24),
        BackgroundTransparency = 1,
        Parent = parent
    })
    
    local iconOffset = 0
    if icon then
        local iconImage = Create("ImageLabel", {
            Name = "Icon",
            Size = UDim2.new(0, 16, 0, 16),
            Position = UDim2.new(0, 0, 0.5, -8),
            BackgroundTransparency = 1,
            Image = LucideIcons[icon] or icon,
            ImageColor3 = color,
            Parent = labelContainer
        })
        iconOffset = 22
    end
    
    local label = Create("TextLabel", {
        Name = "Text",
        Size = UDim2.new(1, -iconOffset, 1, 0),
        Position = UDim2.new(0, iconOffset, 0, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = color,
        TextSize = Theme.FontSize,
        Font = Theme.Font,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        Parent = labelContainer
    })
    
    function element:SetText(newText)
        label.Text = newText
    end
    
    function element:SetColor(newColor)
        label.TextColor3 = newColor
        if labelContainer:FindFirstChild("Icon") then
            labelContainer.Icon.ImageColor3 = newColor
        end
    end
    
    function element:SetEnabled(state)
        element.Enabled = state
        labelContainer.Visible = state
    end
    
    function element:Destroy()
        pcall(function()
            labelContainer:Destroy()
        end)
    end
    
    element.Instance = labelContainer
    
    return element
end

function ElementFactory.CreateParagraph(parent, options)
    local title = options.Title or "Title"
    local content = options.Content or "Content"
    local icon = options.Icon
    
    local element = {
        Type = "Paragraph",
        Enabled = true
    }
    
    local textSize = GetTextSize(content, Theme.FontSizeSmall, Theme.Font, 300)
    local totalHeight = 24 + textSize.Y + 8
    
    local paragraphContainer = Create("Frame", {
        Name = "Paragraph",
        Size = UDim2.new(1, 0, 0, totalHeight),
        BackgroundColor3 = Theme.Tertiary,
        Parent = parent
    })
    
    AddCorner(paragraphContainer)
    AddPadding(paragraphContainer, 10)
    
    local iconOffset = 0
    if icon then
        local iconImage = Create("ImageLabel", {
            Name = "Icon",
            Size = UDim2.new(0, 18, 0, 18),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1,
            Image = LucideIcons[icon] or icon,
            ImageColor3 = Theme.Accent,
            Parent = paragraphContainer
        })
        iconOffset = 24
    end
    
    local titleLabel = Create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -iconOffset, 0, 18),
        Position = UDim2.new(0, iconOffset, 0, 0),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Theme.Text,
        TextSize = Theme.FontSize,
        Font = Theme.FontBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = paragraphContainer
    })
    
    local contentLabel = Create("TextLabel", {
        Name = "Content",
        Size = UDim2.new(1, 0, 0, textSize.Y),
        Position = UDim2.new(0, 0, 0, 24),
        BackgroundTransparency = 1,
        Text = content,
        TextColor3 = Theme.TextDark,
        TextSize = Theme.FontSizeSmall,
        Font = Theme.Font,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true,
        Parent = paragraphContainer
    })
    
    function element:SetTitle(newTitle)
        titleLabel.Text = newTitle
    end
    
    function element:SetContent(newContent)
        contentLabel.Text = newContent
        local newSize = GetTextSize(newContent, Theme.FontSizeSmall, Theme.Font, paragraphContainer.AbsoluteSize.X - 20)
        contentLabel.Size = UDim2.new(1, 0, 0, newSize.Y)
        paragraphContainer.Size = UDim2.new(1, 0, 0, 24 + newSize.Y + 20)
    end
    
    function element:SetEnabled(state)
        element.Enabled = state
        paragraphContainer.Visible = state
    end
    
    function element:Destroy()
        pcall(function()
            paragraphContainer:Destroy()
        end)
    end
    
    element.Instance = paragraphContainer
    
    return element
end

function ElementFactory.CreateKeybind(parent, options)
    local text = options.Text or "Keybind"
    local default = options.Default or Enum.KeyCode.Unknown
    local callback = options.Callback or function() end
    local changedCallback = options.ChangedCallback or function() end
    local locked = options.Locked or false
    local tooltip = options.Tooltip
    
    local element = {
        Type = "Keybind",
        Value = default,
        Locked = locked,
        Enabled = true,
        Binding = false
    }
    
    local keybindContainer = Create("Frame", {
        Name = "Keybind",
        Size = UDim2.new(1, 0, 0, Theme.ElementHeight),
        BackgroundColor3 = Theme.Tertiary,
        Parent = parent
    })
    
    AddCorner(keybindContainer)
    AddStroke(keybindContainer, Theme.Border)
    
    local keyIcon = Create("ImageLabel", {
        Name = "KeyIcon",
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(0, 12, 0.5, -8),
        BackgroundTransparency = 1,
        Image = LucideIcons.Keyboard,
        ImageColor3 = Theme.TextDark,
        Parent = keybindContainer
    })
    
    local label = Create("TextLabel", {
        Name = "Label",
        Size = UDim2.new(0.6, -40, 1, 0),
        Position = UDim2.new(0, 34, 0, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Theme.Text,
        TextSize = Theme.FontSize,
        Font = Theme.Font,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = keybindContainer
    })
    
    local keyButton = Create("TextButton", {
        Name = "KeyButton",
        Size = UDim2.new(0.4, -16, 0, 24),
        Position = UDim2.new(0.6, 4, 0.5, -12),
        BackgroundColor3 = Theme.Secondary,
        Text = default == Enum.KeyCode.Unknown and "None" or default.Name,
        TextColor3 = Theme.Accent,
        TextSize = Theme.FontSizeSmall,
        Font = Theme.FontBold,
        AutoButtonColor = false,
        Parent = keybindContainer
    })
    
    AddCorner(keyButton, Theme.CornerRadiusSmall)
    
    local lockIcon = Create("ImageLabel", {
        Name = "LockIcon",
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(1, -28, 0.5, -8),
        BackgroundTransparency = 1,
        Image = LucideIcons.Lock,
        ImageColor3 = Theme.TextDisabled,
        Visible = locked,
        Parent = keybindContainer
    })
    
    local function UpdateLockState()
        if element.Locked then
            keybindContainer.BackgroundColor3 = Theme.Locked
            label.TextColor3 = Theme.TextDisabled
            keyButton.TextColor3 = Theme.TextDisabled
            lockIcon.Visible = true
        else
            keybindContainer.BackgroundColor3 = Theme.Tertiary
            label.TextColor3 = Theme.Text
            keyButton.TextColor3 = Theme.Accent
            lockIcon.Visible = false
        end
    end
    
    keyButton.MouseButton1Click:Connect(function()
        if element.Locked or not element.Enabled then return end
        
        element.Binding = true
        keyButton.Text = "..."
        Tween(keyButton, {BackgroundColor3 = Theme.Accent}, 0.15)
    end)
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if element.Binding then
            if input.UserInputType == Enum.UserInputType.Keyboard then
                element.Value = input.KeyCode
                keyButton.Text = input.KeyCode.Name
                element.Binding = false
                Tween(keyButton, {BackgroundColor3 = Theme.Secondary}, 0.15)
                SafeCall(changedCallback, input.KeyCode)
            end
        elseif not gameProcessed and element.Enabled and not element.Locked then
            if input.KeyCode == element.Value then
                SafeCall(callback, element.Value)
            end
        end
    end)
    
    keybindContainer.MouseEnter:Connect(function()
        if tooltip then
            TooltipSystem:Show(tooltip, UserInputService:GetMouseLocation())
        end
    end)
    
    keybindContainer.MouseLeave:Connect(function()
        TooltipSystem:Hide()
    end)
    
    function element:SetValue(keyCode)
        element.Value = keyCode
        keyButton.Text = keyCode == Enum.KeyCode.Unknown and "None" or keyCode.Name
    end
    
    function element:GetValue()
        return element.Value
    end
    
    function element:SetLocked(state)
        element.Locked = state
        UpdateLockState()
    end
    
    function element:SetEnabled(state)
        element.Enabled = state
        keybindContainer.Visible = state
    end
    
    function element:Destroy()
        pcall(function()
            keybindContainer:Destroy()
        end)
    end
    
    element.Instance = keybindContainer
    UpdateLockState()
    
    return element
end

local Section = {}
Section.__index = Section

function Section.new(parent, options)
    local self = setmetatable({}, Section)
    
    self.Title = options.Title or "Section"
    self.Description = options.Description
    self.Locked = options.Locked or false
    self.Elements = {}
    self.Enabled = true
    
    self.Container = Create("Frame", {
        Name = "Section_" .. self.Title,
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundColor3 = Theme.Secondary,
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent = parent
    })
    
    AddCorner(self.Container)
    AddStroke(self.Container, Theme.Border)
    
    local headerHeight = self.Description and 50 or 32
    
    self.Header = Create("Frame", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, headerHeight),
        BackgroundTransparency = 1,
        Parent = self.Container
    })
    
    self.TitleLabel = Create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -48, 0, 20),
        Position = UDim2.new(0, 12, 0, 8),
        BackgroundTransparency = 1,
        Text = self.Title,
        TextColor3 = Theme.Text,
        TextSize = Theme.FontSize,
        Font = Theme.FontBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = self.Header
    })
    
    if self.Description then
        self.DescLabel = Create("TextLabel", {
            Name = "Description",
            Size = UDim2.new(1, -24, 0, 16),
            Position = UDim2.new(0, 12, 0, 28),
            BackgroundTransparency = 1,
            Text = self.Description,
            TextColor3 = Theme.TextDark,
            TextSize = Theme.FontSizeSmall,
            Font = Theme.Font,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            Parent = self.Header
        })
    end
    
    self.LockIcon = Create("ImageLabel", {
        Name = "LockIcon",
        Size = UDim2.new(0, 18, 0, 18),
        Position = UDim2.new(1, -30, 0, 8),
        BackgroundTransparency = 1,
        Image = LucideIcons.Lock,
        ImageColor3 = Theme.TextDisabled,
        Visible = self.Locked,
        Parent = self.Header
    })
    
    self.Content = Create("Frame", {
        Name = "Content",
        Size = UDim2.new(1, -24, 0, 0),
        Position = UDim2.new(0, 12, 0, headerHeight),
        BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent = self.Container
    })
    
    AddListLayout(self.Content, 8)
    
    local bottomPadding = Create("Frame", {
        Name = "BottomPadding",
        Size = UDim2.new(1, 0, 0, 12),
        BackgroundTransparency = 1,
        LayoutOrder = 999999,
        Parent = self.Content
    })
    
    self:UpdateLockState()
    
    return self
end

function Section:UpdateLockState()
    if self.Locked then
        self.Container.BackgroundColor3 = Theme.Locked
        self.TitleLabel.TextColor3 = Theme.TextDisabled
        if self.DescLabel then
            self.DescLabel.TextColor3 = Theme.TextDisabled
        end
        self.LockIcon.Visible = true
        
        for _, element in pairs(self.Elements) do
            if element.SetLocked then
                element:SetLocked(true)
            end
        end
    else
        self.Container.BackgroundColor3 = Theme.Secondary
        self.TitleLabel.TextColor3 = Theme.Text
        if self.DescLabel then
            self.DescLabel.TextColor3 = Theme.TextDark
        end
        self.LockIcon.Visible = false
    end
end

function Section:SetLocked(state)
    self.Locked = state
    self:UpdateLockState()
end

function Section:SetEnabled(state)
    self.Enabled = state
    self.Container.Visible = state
end

function Section:AddButton(options)
    options.Locked = options.Locked or self.Locked
    local element = ElementFactory.CreateButton(self.Content, options)
    table.insert(self.Elements, element)
    return element
end

function Section:AddToggle(options)
    options.Locked = options.Locked or self.Locked
    local element = ElementFactory.CreateToggle(self.Content, options)
    table.insert(self.Elements, element)
    return element
end

function Section:AddSlider(options)
    options.Locked = options.Locked or self.Locked
    local element = ElementFactory.CreateSlider(self.Content, options)
    table.insert(self.Elements, element)
    return element
end

function Section:AddDropdown(options)
    options.Locked = options.Locked or self.Locked
    local element = ElementFactory.CreateDropdown(self.Content, options)
    table.insert(self.Elements, element)
    return element
end

function Section:AddTextbox(options)
    options.Locked = options.Locked or self.Locked
    local element = ElementFactory.CreateTextbox(self.Content, options)
    table.insert(self.Elements, element)
    return element
end

function Section:AddLabel(options)
    local element = ElementFactory.CreateLabel(self.Content, options)
    table.insert(self.Elements, element)
    return element
end

function Section:AddParagraph(options)
    local element = ElementFactory.CreateParagraph(self.Content, options)
    table.insert(self.Elements, element)
    return element
end

function Section:AddKeybind(options)
    options.Locked = options.Locked or self.Locked
    local element = ElementFactory.CreateKeybind(self.Content, options)
    table.insert(self.Elements, element)
    return element
end

function Section:Destroy()
    for _, element in pairs(self.Elements) do
        if element.Destroy then
            element:Destroy()
        end
    end
    pcall(function()
        self.Container:Destroy()
    end)
end

local Tab = {}
Tab.__index = Tab

function Tab.new(parent, tabButton, options)
    local self = setmetatable({}, Tab)
    
    self.Name = options.Name or "Tab"
    self.Icon = options.Icon
    self.Sections = {}
    self.Enabled = true
    self.Active = false
    
    self.Button = tabButton
    
    self.Container = Create("ScrollingFrame", {
        Name = "Tab_" .. self.Name,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = Theme.Accent,
        BorderSizePixel = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Visible = false,
        Parent = parent
    })
    
    AddPadding(self.Container, 12)
    local layout = AddListLayout(self.Container, 12)
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.Container.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 24)
    end)
    
    return self
end

function Tab:SetActive(state)
    self.Active = state
    self.Container.Visible = state
    
    if state then
        Tween(self.Button, {BackgroundColor3 = Theme.Accent}, 0.2)
        self.Button.TextLabel.TextColor3 = Theme.Text
        if self.Button:FindFirstChild("Icon") then
            self.Button.Icon.ImageColor3 = Theme.Text
        end
    else
        Tween(self.Button, {BackgroundColor3 = Theme.Tertiary}, 0.2)
        self.Button.TextLabel.TextColor3 = Theme.TextDark
        if self.Button:FindFirstChild("Icon") then
            self.Button.Icon.ImageColor3 = Theme.TextDark
        end
    end
end

function Tab:AddSection(options)
    local section = Section.new(self.Container, options)
    table.insert(self.Sections, section)
    return section
end

function Tab:SetEnabled(state)
    self.Enabled = state
    self.Button.Visible = state
    if not state and self.Active then
        self:SetActive(false)
    end
end

function Tab:Destroy()
    for _, section in pairs(self.Sections) do
        section:Destroy()
    end
    pcall(function()
        self.Container:Destroy()
        self.Button:Destroy()
    end)
end

local Window = {}
Window.__index = Window

function Window.new(screenGui, options)
    local self = setmetatable({}, Window)
    
    self.Title = options.Title or "Window"
    self.Subtitle = options.Subtitle or ""
    self.Size = options.Size or (IsMobile and UDim2.new(0.95, 0, 0.85, 0) or UDim2.new(0, 600, 0, 450))
    self.Tabs = {}
    self.ActiveTab = nil
    self.Minimized = false
    self.Visible = true
    
    local centerX = IsMobile and 0.025 or 0.5
    local centerY = IsMobile and 0.075 or 0.5
    local anchorX = IsMobile and 0 or 0.5
    local anchorY = IsMobile and 0 or 0.5
    
    self.MainFrame = Create("Frame", {
        Name = "Window",
        Size = self.Size,
        Position = UDim2.new(centerX, 0, centerY, 0),
        AnchorPoint = Vector2.new(anchorX, anchorY),
        BackgroundColor3 = Theme.Primary,
        Parent = screenGui
    })
    
    AddCorner(self.MainFrame, UDim.new(0, 12))
    AddStroke(self.MainFrame, Theme.Border, 2)
    
    local shadow = Create("ImageLabel", {
        Name = "Shadow",
        Size = UDim2.new(1, 40, 1, 40),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Image = "rbxassetid://5554236805",
        ImageColor3 = Theme.Shadow,
        ImageTransparency = 0.5,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(23, 23, 277, 277),
        ZIndex = -1,
        Parent = self.MainFrame
    })
    
    self.TitleBar = Create("Frame", {
        Name = "TitleBar",
        Size = UDim2.new(1, 0, 0, IsMobile and 50 or 40),
        BackgroundColor3 = Theme.Secondary,
        Parent = self.MainFrame
    })
    
    Create("UICorner", {
        CornerRadius = UDim.new(0, 12),
        Parent = self.TitleBar
    })
    
    local titleBarCover = Create("Frame", {
        Size = UDim2.new(1, 0, 0.5, 0),
        Position = UDim2.new(0, 0, 0.5, 0),
        BackgroundColor3 = Theme.Secondary,
        BorderSizePixel = 0,
        Parent = self.TitleBar
    })
    
    self.TitleLabel = Create("TextLabel", {
        Name = "Title",
        Size = UDim2.new(0.6, -12, 1, 0),
        Position = UDim2.new(0, 16, 0, 0),
        BackgroundTransparency = 1,
        Text = self.Title,
        TextColor3 = Theme.Text,
        TextSize = IsMobile and 18 or 16,
        Font = Theme.FontBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = self.TitleBar
    })
    
    if self.Subtitle ~= "" then
        self.SubtitleLabel = Create("TextLabel", {
            Name = "Subtitle",
            Size = UDim2.new(0.4, -60, 1, 0),
            Position = UDim2.new(0.6, -48, 0, 0),
            BackgroundTransparency = 1,
            Text = self.Subtitle,
            TextColor3 = Theme.TextDark,
            TextSize = IsMobile and 14 or 12,
            Font = Theme.Font,
            TextXAlignment = Enum.TextXAlignment.Right,
            Parent = self.TitleBar
        })
    end
    
    local buttonContainer = Create("Frame", {
        Name = "Buttons",
        Size = UDim2.new(0, IsMobile and 90 or 70, 0, IsMobile and 30 or 24),
        Position = UDim2.new(1, -(IsMobile and 100 or 80), 0.5, -(IsMobile and 15 or 12)),
        BackgroundTransparency = 1,
        Parent = self.TitleBar
    })
    
    AddListLayout(buttonContainer, 6, Enum.FillDirection.Horizontal, Enum.HorizontalAlignment.Right)
    
    local closeButton = Create("TextButton", {
        Name = "Close",
        Size = UDim2.new(0, IsMobile and 30 or 24, 0, IsMobile and 30 or 24),
        BackgroundColor3 = Theme.Error,
        Text = "",
        AutoButtonColor = false,
        LayoutOrder = 2,
        Parent = buttonContainer
    })
    
    AddCorner(closeButton, UDim.new(0, 6))
    
    local closeIcon = Create("ImageLabel", {
        Size = UDim2.new(0, 14, 0, 14),
        Position = UDim2.new(0.5, -7, 0.5, -7),
        BackgroundTransparency = 1,
        Image = LucideIcons.X,
        ImageColor3 = Theme.Text,
        Parent = closeButton
    })
    
    local minimizeButton = Create("TextButton", {
        Name = "Minimize",
        Size = UDim2.new(0, IsMobile and 30 or 24, 0, IsMobile and 30 or 24),
        BackgroundColor3 = Theme.Warning,
        Text = "",
        AutoButtonColor = false,
        LayoutOrder = 1,
        Parent = buttonContainer
    })
    
    AddCorner(minimizeButton, UDim.new(0, 6))
    
    local minimizeIcon = Create("ImageLabel", {
        Size = UDim2.new(0, 14, 0, 14),
        Position = UDim2.new(0.5, -7, 0.5, -7),
        BackgroundTransparency = 1,
        Image = LucideIcons.Minus,
        ImageColor3 = Theme.Text,
        Parent = minimizeButton
    })
    
    closeButton.MouseEnter:Connect(function()
        Tween(closeButton, {BackgroundColor3 = Color3.fromRGB(255, 100, 100)}, 0.15)
    end)
    
    closeButton.MouseLeave:Connect(function()
        Tween(closeButton, {BackgroundColor3 = Theme.Error}, 0.15)
    end)
    
    closeButton.MouseButton1Click:Connect(function()
        self:Close()
    end)
    
    minimizeButton.MouseEnter:Connect(function()
        Tween(minimizeButton, {BackgroundColor3 = Color3.fromRGB(255, 200, 70)}, 0.15)
    end)
    
    minimizeButton.MouseLeave:Connect(function()
        Tween(minimizeButton, {BackgroundColor3 = Theme.Warning}, 0.15)
    end)
    
    minimizeButton.MouseButton1Click:Connect(function()
        self:ToggleMinimize()
    end)
    
    self.ContentContainer = Create("Frame", {
        Name = "Content",
        Size = UDim2.new(1, 0, 1, -(IsMobile and 52 or 42)),
        Position = UDim2.new(0, 0, 0, IsMobile and 52 or 42),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Parent = self.MainFrame
    })
    
    local tabListWidth = IsMobile and 100 or 120
    
    self.TabList = Create("ScrollingFrame", {
        Name = "TabList",
        Size = UDim2.new(0, tabListWidth, 1, -16),
        Position = UDim2.new(0, 8, 0, 8),
        BackgroundColor3 = Theme.Secondary,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Theme.Accent,
        BorderSizePixel = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Parent = self.ContentContainer
    })
    
    AddCorner(self.TabList)
    AddPadding(self.TabList, 6)
    local tabLayout = AddListLayout(self.TabList, 4)
    
    tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self.TabList.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y + 12)
    end)
    
    self.TabContent = Create("Frame", {
        Name = "TabContent",
        Size = UDim2.new(1, -(tabListWidth + 20), 1, -16),
        Position = UDim2.new(0, tabListWidth + 12, 0, 8),
        BackgroundTransparency = 1,
        Parent = self.ContentContainer
    })
    
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    self.TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = self.MainFrame.Position
        end
    end)
    
    self.TitleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            local newPos = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
            self.MainFrame.Position = newPos
        end
    end)
    
    return self
end

function Window:AddTab(options)
    local tabButton = Create("TextButton", {
        Name = "Tab_" .. (options.Name or "Tab"),
        Size = UDim2.new(1, 0, 0, IsMobile and 40 or 32),
        BackgroundColor3 = Theme.Tertiary,
        Text = "",
        AutoButtonColor = false,
        Parent = self.TabList
    })
    
    AddCorner(tabButton, Theme.CornerRadiusSmall)
    
    local iconOffset = 0
    if options.Icon then
        local tabIcon = Create("ImageLabel", {
            Name = "Icon",
            Size = UDim2.new(0, 16, 0, 16),
            Position = UDim2.new(0, 8, 0.5, -8),
            BackgroundTransparency = 1,
            Image = LucideIcons[options.Icon] or options.Icon,
            ImageColor3 = Theme.TextDark,
            Parent = tabButton
        })
        iconOffset = 22
    end
    
    local tabLabel = Create("TextLabel", {
        Name = "TextLabel",
        Size = UDim2.new(1, -(iconOffset + 12), 1, 0),
        Position = UDim2.new(0, iconOffset + 8, 0, 0),
        BackgroundTransparency = 1,
        Text = options.Name or "Tab",
        TextColor3 = Theme.TextDark,
        TextSize = IsMobile and 14 or 12,
        Font = Theme.Font,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = tabButton
    })
    
    local tab = Tab.new(self.TabContent, tabButton, options)
    table.insert(self.Tabs, tab)
    
    tabButton.MouseEnter:Connect(function()
        if not tab.Active then
            Tween(tabButton, {BackgroundColor3 = Color3.fromRGB(45, 45, 60)}, 0.15)
        end
    end)
    
    tabButton.MouseLeave:Connect(function()
        if not tab.Active then
            Tween(tabButton, {BackgroundColor3 = Theme.Tertiary}, 0.15)
        end
    end)
    
    tabButton.MouseButton1Click:Connect(function()
        self:SetActiveTab(tab)
    end)
    
    if #self.Tabs == 1 then
        self:SetActiveTab(tab)
    end
    
    return tab
end

function Window:SetActiveTab(tab)
    if self.ActiveTab then
        self.ActiveTab:SetActive(false)
    end
    self.ActiveTab = tab
    tab:SetActive(true)
end

function Window:ToggleMinimize()
    self.Minimized = not self.Minimized
    
    if self.Minimized then
        Tween(self.MainFrame, {Size = UDim2.new(self.Size.X.Scale, self.Size.X.Offset, 0, IsMobile and 50 or 40)}, 0.3)
        self.ContentContainer.Visible = false
    else
        Tween(self.MainFrame, {Size = self.Size}, 0.3)
        task.wait(0.1)
        self.ContentContainer.Visible = true
    end
end

function Window:SetVisible(state)
    self.Visible = state
    self.MainFrame.Visible = state
end

function Window:Close()
    Tween(self.MainFrame, {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}, 0.3)
    task.wait(0.3)
    self:Destroy()
end

function Window:Destroy()
    for _, tab in pairs(self.Tabs) do
        tab:Destroy()
    end
    pcall(function()
        self.MainFrame:Destroy()
    end)
end

function Library:CreateWindow(options)
    options = options or {}
    
    if self.ScreenGui then
        pcall(function()
            self.ScreenGui:Destroy()
        end)
    end
    
    self.ScreenGui = Create("ScreenGui", {
        Name = options.Name or "UILibrary",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true
    })
    
    local success = pcall(function()
        self.ScreenGui.Parent = CoreGui
    end)
    
    if not success then
        pcall(function()
            if syn and syn.protect_gui then
                syn.protect_gui(self.ScreenGui)
                self.ScreenGui.Parent = CoreGui
            elseif gethui then
                self.ScreenGui.Parent = gethui()
            else
                self.ScreenGui.Parent = Player:WaitForChild("PlayerGui")
            end
        end)
    end
    
    NotificationSystem:Init(self.ScreenGui)
    TooltipSystem:Init(self.ScreenGui)
    
    local window = Window.new(self.ScreenGui, options)
    self.Window = window
    
    return window
end

function Library:Notify(options)
    return NotificationSystem:Notify(options)
end

function Library:SetTheme(newTheme)
    for key, value in pairs(newTheme) do
        if Theme[key] ~= nil then
            Theme[key] = value
        end
    end
end

function Library:GetTheme()
    return Theme
end

function Library:Destroy()
    if self.Window then
        self.Window:Destroy()
    end
    if self.ScreenGui then
        pcall(function()
            self.ScreenGui:Destroy()
        end)
    end
end

local ConfigSystem = {}
ConfigSystem.Folder = "UILibraryConfigs"

function ConfigSystem:Init()
    if not isfolder then return false end
    
    local success = pcall(function()
        if not isfolder(self.Folder) then
            makefolder(self.Folder)
        end
    end)
    
    return success
end

function ConfigSystem:Save(name, data)
    if not writefile then return false end
    
    local success = pcall(function()
        local json = HttpService:JSONEncode(data)
        writefile(self.Folder .. "/" .. name .. ".json", json)
    end)
    
    return success
end

function ConfigSystem:Load(name)
    if not readfile or not isfile then return nil end
    
    local data = nil
    pcall(function()
        if isfile(self.Folder .. "/" .. name .. ".json") then
            local json = readfile(self.Folder .. "/" .. name .. ".json")
            data = HttpService:JSONDecode(json)
        end
    end)
    
    return data
end

function ConfigSystem:Delete(name)
    if not delfile or not isfile then return false end
    
    local success = pcall(function()
        if isfile(self.Folder .. "/" .. name .. ".json") then
            delfile(self.Folder .. "/" .. name .. ".json")
        end
    end)
    
    return success
end

function ConfigSystem:List()
    if not listfiles then return {} end
    
    local files = {}
    pcall(function()
        local allFiles = listfiles(self.Folder)
        for _, file in ipairs(allFiles) do
            if string.sub(file, -5) == ".json" then
                local name = string.match(file, "([^/\\]+)%.json$")
                if name then
                    table.insert(files, name)
                end
            end
        end
    end)
    
    return files
end

Library.Config = ConfigSystem
ConfigSystem:Init()

return Library
