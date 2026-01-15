local cloneref = cloneref or function(a) return a end
local CoreGui = cloneref(game:GetService("CoreGui"))
local TweenService = cloneref(game:GetService("TweenService"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local HttpService = cloneref(game:GetService("HttpService"))
local Players = cloneref(game:GetService("Players"))

local KeySystem = {}
KeySystem.__index = KeySystem

local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled

local Config = {
    MainColor = Color3.fromRGB(0, 0, 0),
    SecondaryColor = Color3.fromRGB(10, 10, 10),
    AccentColor = Color3.fromRGB(255, 255, 255),
    TextColor = Color3.fromRGB(255, 255, 255),
    SecondaryTextColor = Color3.fromRGB(160, 160, 160),
    BorderColor = Color3.fromRGB(40, 40, 40),
    SuccessColor = Color3.fromRGB(74, 222, 128),
    ErrorColor = Color3.fromRGB(248, 113, 113),
    WarningColor = Color3.fromRGB(251, 191, 36),
    TweenSpeed = 0.15
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
    local success, result = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/lucide/dist/Icons.lua"))()
    end)
    if success and type(result) == "table" then
        Icons = result
        iconsLoaded = true
    end
end
LoadIcons()

local function GetIcon(name)
    if not name then return "" end
    local lower = string.lower(tostring(name))
    if Icons[lower] then return Icons[lower] end
    if Icons[name] then return Icons[name] end
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

function KeySystem:Create(options)
    options = options or {}
    
    local title = options.Title or "Key System"
    local description = options.Description or "Please enter your key to continue"
    local icon = options.Icon or "key"
    local keys = options.Keys or {}
    local keyLink = options.KeyLink or ""
    local savePath = options.SavePath or "KeyData.json"
    local onSuccess = options.OnSuccess or function() end
    local onFailed = options.OnFailed or function() end
    local maxAttempts = options.MaxAttempts or 5
    local lockoutTime = options.LockoutTime or 60
    
    -- Remove existing key system
    local existing = CoreGui:FindFirstChild("KeySystemUI")
    if existing then existing:Destroy() end
    
    local attempts = 0
    local lockedOut = false
    
    -- Check for saved key
    local function CheckSavedKey()
        if not isfile then return nil end
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
    
    -- Check saved key first
    if CheckSavedKey() then
        task.spawn(onSuccess)
        return
    end
    
    -- Create UI
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
        Size = isMobile and UDim2.new(0, 340, 0, 320) or UDim2.new(0, 400, 0, 340),
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
    
    local IconLabel = Create("ImageLabel", {
        Name = "Icon",
        BackgroundTransparency = 1,
        Image = GetIcon(icon),
        ImageColor3 = Config.AccentColor,
        Size = UDim2.new(0, isMobile and 24 or 22, 0, isMobile and 24 or 22),
        Position = UDim2.new(0, 16, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Parent = TitleBar
    })
    
    local TitleLabel = Create("TextLabel", {
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
    
    -- Lock Icon
    local LockContainer = Create("Frame", {
        Name = "LockContainer",
        BackgroundColor3 = Config.SecondaryColor,
        Size = UDim2.new(0, isMobile and 64 or 56, 0, isMobile and 64 or 56),
        Position = UDim2.new(0.5, 0, 0, 0),
        AnchorPoint = Vector2.new(0.5, 0),
        Parent = Content
    })
    AddCorner(LockContainer, isMobile and 32 or 28)
    
    local LockIcon = Create("ImageLabel", {
        Name = "LockIcon",
        BackgroundTransparency = 1,
        Image = GetIcon("lock"),
        ImageColor3 = Config.AccentColor,
        Size = UDim2.new(0, isMobile and 28 or 24, 0, isMobile and 28 or 24),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Parent = LockContainer
    })
    
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
        Position = UDim2.new(0, 0, 0, isMobile and 76 or 68),
        Parent = Content
    })
    
    -- Input Container
    local InputContainer = Create("Frame", {
        Name = "InputContainer",
        BackgroundColor3 = Config.SecondaryColor,
        Size = UDim2.new(1, 0, 0, isMobile and 48 or 44),
        Position = UDim2.new(0, 0, 0, isMobile and 128 or 118),
        Parent = Content
    })
    AddCorner(InputContainer, 8)
    
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
        Size = UDim2.new(1, -24, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        Parent = InputContainer
    })
    
    KeyInput.Focused:Connect(function()
        Tween(InputContainer, {BackgroundColor3 = Config.BorderColor})
    end)
    
    KeyInput.FocusLost:Connect(function()
        Tween(InputContainer, {BackgroundColor3 = Config.SecondaryColor})
    end)
    
    -- Status Label
    local StatusLabel = Create("TextLabel", {
        Name = "Status",
        BackgroundTransparency = 1,
        Text = "",
        TextColor3 = Config.SecondaryTextColor,
        FontFace = Fonts.Regular,
        TextSize = isMobile and 11 or 10,
        Size = UDim2.new(1, 0, 0, 16),
        Position = UDim2.new(0, 0, 0, isMobile and 182 or 168),
        Parent = Content
    })
    
    -- Buttons Container
    local ButtonsContainer = Create("Frame", {
        Name = "Buttons",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, isMobile and 44 or 40),
        Position = UDim2.new(0, 0, 1, isMobile and -44 or -40),
        Parent = Content
    })
    
    Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0, 10),
        Parent = ButtonsContainer
    })
    
    -- Get Key Button
    local GetKeyButton = Create("TextButton", {
        Name = "GetKey",
        BackgroundColor3 = Config.SecondaryColor,
        Size = UDim2.new(0, isMobile and 140 or 130, 1, 0),
        Text = "",
        AutoButtonColor = false,
        Parent = ButtonsContainer
    })
    AddCorner(GetKeyButton, 8)
    
    local GetKeyIcon = Create("ImageLabel", {
        BackgroundTransparency = 1,
        Image = GetIcon("external-link"),
        ImageColor3 = Config.TextColor,
        Size = UDim2.new(0, isMobile and 16 or 14, 0, isMobile and 16 or 14),
        Position = UDim2.new(0, 14, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Parent = GetKeyButton
    })
    
    local GetKeyLabel = Create("TextLabel", {
        BackgroundTransparency = 1,
        Text = "Get Key",
        TextColor3 = Config.TextColor,
        FontFace = Fonts.Medium,
        TextSize = isMobile and 13 or 12,
        Size = UDim2.new(1, -44, 1, 0),
        Position = UDim2.new(0, isMobile and 38 or 34, 0, 0),
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
        if keyLink ~= "" then
            if setclipboard then
                setclipboard(keyLink)
                StatusLabel.Text = "Link copied to clipboard!"
                StatusLabel.TextColor3 = Config.SuccessColor
            end
        end
    end)
    
    -- Verify Button
    local VerifyButton = Create("TextButton", {
        Name = "Verify",
        BackgroundColor3 = Config.AccentColor,
        Size = UDim2.new(0, isMobile and 140 or 130, 1, 0),
        Text = "",
        AutoButtonColor = false,
        Parent = ButtonsContainer
    })
    AddCorner(VerifyButton, 8)
    
    local VerifyIcon = Create("ImageLabel", {
        BackgroundTransparency = 1,
        Image = GetIcon("check"),
        ImageColor3 = Config.MainColor,
        Size = UDim2.new(0, isMobile and 16 or 14, 0, isMobile and 16 or 14),
        Position = UDim2.new(0, 14, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Parent = VerifyButton
    })
    
    local VerifyLabel = Create("TextLabel", {
        BackgroundTransparency = 1,
        Text = "Verify",
        TextColor3 = Config.MainColor,
        FontFace = Fonts.Medium,
        TextSize = isMobile and 13 or 12,
        Size = UDim2.new(1, -44, 1, 0),
        Position = UDim2.new(0, isMobile and 38 or 34, 0, 0),
        Parent = VerifyButton
    })
    
    VerifyButton.MouseEnter:Connect(function()
        if not lockedOut then
            Tween(VerifyButton, {BackgroundColor3 = Config.TextColor})
        end
    end)
    
    VerifyButton.MouseLeave:Connect(function()
        if not lockedOut then
            Tween(VerifyButton, {BackgroundColor3 = Config.AccentColor})
        end
    end)
    
    local function VerifyKey()
        if lockedOut then
            StatusLabel.Text = "Too many attempts! Please wait..."
            StatusLabel.TextColor3 = Config.ErrorColor
            return
        end
        
        local inputKey = KeyInput.Text
        
        if inputKey == "" then
            StatusLabel.Text = "Please enter a key!"
            StatusLabel.TextColor3 = Config.WarningColor
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
            -- Success animation
            StatusLabel.Text = "Key verified successfully!"
            StatusLabel.TextColor3 = Config.SuccessColor
            LockIcon.Image = GetIcon("unlock")
            Tween(LockIcon, {ImageColor3 = Config.SuccessColor})
            Tween(LockContainer, {BackgroundColor3 = Color3.fromRGB(30, 60, 30)})
            
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
            attempts = attempts + 1
            StatusLabel.Text = string.format("Invalid key! (%d/%d attempts)", attempts, maxAttempts)
            StatusLabel.TextColor3 = Config.ErrorColor
            
            -- Shake animation
            local originalPos = InputContainer.Position
            for i = 1, 4 do
                Tween(InputContainer, {Position = originalPos + UDim2.new(0, i % 2 == 0 and 8 or -8, 0, 0)}, 0.05)
                task.wait(0.05)
            end
            Tween(InputContainer, {Position = originalPos}, 0.05)
            
            if attempts >= maxAttempts then
                lockedOut = true
                StatusLabel.Text = string.format("Locked out! Wait %d seconds...", lockoutTime)
                Tween(VerifyButton, {BackgroundColor3 = Config.BorderColor})
                VerifyLabel.TextColor3 = Config.SecondaryTextColor
                
                task.spawn(function()
                    for i = lockoutTime, 1, -1 do
                        if not ScreenGui.Parent then return end
                        StatusLabel.Text = string.format("Locked out! Wait %d seconds...", i)
                        task.wait(1)
                    end
                    lockedOut = false
                    attempts = 0
                    StatusLabel.Text = "You can try again now"
                    StatusLabel.TextColor3 = Config.SecondaryTextColor
                    Tween(VerifyButton, {BackgroundColor3 = Config.AccentColor})
                    VerifyLabel.TextColor3 = Config.MainColor
                end)
            end
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
    
    -- Make draggable
    MakeDraggable(MainFrame, TitleBar)
    
    -- Entrance animation
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    Background.BackgroundTransparency = 1
    
    Tween(Background, {BackgroundTransparency = 0.3}, 0.2)
    Tween(MainFrame, {Size = isMobile and UDim2.new(0, 340, 0, 320) or UDim2.new(0, 400, 0, 340)}, 0.3)
    
    return {
        Destroy = function()
            ScreenGui:Destroy()
        end,
        SetStatus = function(text, color)
            StatusLabel.Text = text
            StatusLabel.TextColor3 = color or Config.SecondaryTextColor
        end
    }
end

return KeySystem
