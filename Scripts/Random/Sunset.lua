-- cloneref: executor-provided global (Studio fallback below)
if not rawget(getfenv(), "cloneref") then cloneref = function(x) return x end end
local UIS = cloneref(game:GetService("UserInputService"))
local TweenService = cloneref(game:GetService("TweenService"))
local CoreGui = cloneref(game:GetService("CoreGui"))

local IsMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled
local ScaleFactor = IsMobile and 1.2 or 1

local Sunset = {
    Theme = {
        MainBackground = Color3.fromRGB(15, 15, 22),
        SecondaryBackground = Color3.fromRGB(22, 22, 32),
        TertiaryBackground = Color3.fromRGB(30, 30, 42),
        Accent = Color3.fromRGB(90, 120, 255),
        Text = Color3.fromRGB(255, 255, 255),
        TextMuted = Color3.fromRGB(160, 160, 180),
        Border = Color3.fromRGB(45, 45, 60),
        Gradient = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 110, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(140, 80, 255))
        })
    },
    Icons = {
        Home = "rbxassetid://10723343321",
        Settings = "rbxassetid://10723346959",
        User = "rbxassetid://10723344002",
        Lock = "rbxassetid://10734951475",
        ChevronRight = "rbxassetid://10709791437",
        Search = "rbxassetid://10723343658"
    },
    Components = {}
}

-- Utility Functions
local function Tween(obj, props, time)
    local tween = TweenService:Create(obj, TweenInfo.new(time or 0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props)
    tween:Play()
    return tween
end

local function AddLock(frame)
    local LockOverlay = Instance.new("Frame")
    LockOverlay.Name = "LockOverlay"
    LockOverlay.Visible = false
    LockOverlay.Parent = frame
    LockOverlay.BackgroundColor3 = Color3.new(0, 0, 0)
    LockOverlay.BackgroundTransparency = 0.5
    LockOverlay.Size = UDim2.new(1, 0, 1, 0)
    LockOverlay.ZIndex = 10
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = LockOverlay
    
    local Icon = Instance.new("ImageLabel")
    Icon.Parent = LockOverlay
    Icon.BackgroundTransparency = 1
    Icon.AnchorPoint = Vector2.new(0.5, 0.5)
    Icon.Position = UDim2.new(0.5, 0, 0.5, 0)
    Icon.Size = UDim2.new(0, 16, 0, 16)
    Icon.Image = Sunset.Icons.Lock
    Icon.ImageColor3 = Color3.new(1, 1, 1)

    return function(state)
        LockOverlay.Visible = state
    end
end

local function MakeDraggable(frame, handle)
    local dragging, dragInput, dragStart, startPos

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
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
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

function Sunset:CreateWindow(title)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SunsetUI"
    ScreenGui.Parent = CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = self.Theme.MainBackground
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, -math.floor(275 * ScaleFactor), 0.5, -math.floor(175 * ScaleFactor))
    MainFrame.Size = UDim2.new(0, math.floor(550 * ScaleFactor), 0, math.floor(350 * ScaleFactor))
    MainFrame.ClipsDescendants = true

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = MainFrame

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = self.Theme.Border
    Stroke.Thickness = 1.5
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    Stroke.Parent = MainFrame

    -- Side Bar
    local SideBar = Instance.new("Frame")
    SideBar.Name = "SideBar"
    SideBar.Parent = MainFrame
    SideBar.BackgroundColor3 = self.Theme.SecondaryBackground
    SideBar.BorderSizePixel = 0
    SideBar.Size = UDim2.new(0, math.floor(160 * ScaleFactor), 1, 0)

    local SideCorner = Instance.new("UICorner")
    SideCorner.CornerRadius = UDim.new(0, 10)
    SideCorner.Parent = SideBar

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Parent = SideBar
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 15, 0, 15)
    Title.Size = UDim2.new(1, -30, 0, 30)
    Title.Font = Enum.Font.GothamBold
    Title.Text = title or "SUNSET"
    Title.TextColor3 = self.Theme.Text
    Title.TextSize = 18 * ScaleFactor
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = SideBar
    TabContainer.Active = true
    TabContainer.BackgroundTransparency = 1
    TabContainer.BorderSizePixel = 0
    TabContainer.Position = UDim2.new(0, 10, 0, 60)
    TabContainer.Size = UDim2.new(1, -20, 1, -70)
    TabContainer.ScrollBarThickness = 0

    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Parent = TabContainer
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Padding = UDim.new(0, 5)

    -- Content Area
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Parent = MainFrame
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Position = UDim2.new(0, math.floor(170 * ScaleFactor), 0, 50)
    ContentContainer.Size = UDim2.new(1, -math.floor(180 * ScaleFactor), 1, -60)

    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Parent = MainFrame
    TopBar.BackgroundTransparency = 1
    TopBar.Size = UDim2.new(1, 0, 0, 50)

    MakeDraggable(MainFrame, TopBar)

    return {
        _tabs = {},
        _activeTab = nil,
        
        CreateTab = function(self_win, name, icon)
            local TabButton = Instance.new("TextButton")
            TabButton.Name = name.."Tab"
            TabButton.Parent = TabContainer
            TabButton.BackgroundColor3 = Sunset.Theme.TertiaryBackground
            TabButton.BackgroundTransparency = 1
            TabButton.Size = UDim2.new(1, 0, 0, 32 * ScaleFactor)
            TabButton.AutoButtonColor = false
            TabButton.Font = Enum.Font.GothamMedium
            TabButton.Text = "      " .. name
            TabButton.TextColor3 = Sunset.Theme.TextMuted
            TabButton.TextSize = 14
            TabButton.TextXAlignment = Enum.TextXAlignment.Left

            local TabIcon = Instance.new("ImageLabel")
            TabIcon.Parent = TabButton
            TabIcon.BackgroundTransparency = 1
            TabIcon.Position = UDim2.new(0, 8, 0.5, -8)
            TabIcon.Size = UDim2.new(0, 16, 0, 16)
            TabIcon.Image = icon or Sunset.Icons.Home
            TabIcon.ImageColor3 = Sunset.Theme.TextMuted

            local TabCorner = Instance.new("UICorner")
            TabCorner.CornerRadius = UDim.new(0, 6)
            TabCorner.Parent = TabButton

            local Page = Instance.new("ScrollingFrame")
            Page.Name = name.."Page"
            Page.Parent = ContentContainer
            Page.BackgroundTransparency = 1
            Page.Size = UDim2.new(1, 0, 1, 0)
            Page.Visible = false
            Page.ScrollBarThickness = 2
            Page.ScrollBarImageColor3 = Sunset.Theme.Accent

            local PageLayout = Instance.new("UIListLayout")
            PageLayout.Parent = Page
            PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
            PageLayout.Padding = UDim.new(0, 10)

            local function Activate()
                if self_win._activeTab then
                    self_win._activeTab.Button.TextColor3 = Sunset.Theme.TextMuted
                    self_win._activeTab.Icon.ImageColor3 = Sunset.Theme.TextMuted
                    Tween(self_win._activeTab.Button, {BackgroundTransparency = 1})
                    self_win._activeTab.Page.Visible = false
                end
                self_win._activeTab = {Button = TabButton, Icon = TabIcon, Page = Page}
                TabButton.TextColor3 = Sunset.Theme.Text
                TabIcon.ImageColor3 = Sunset.Theme.Text
                Tween(TabButton, {BackgroundTransparency = 0})
                Page.Visible = true
            end

            TabButton.MouseButton1Click:Connect(Activate)

            if not self_win._activeTab then Activate() end

            return {
                CreateSection = function(self_tab, title)
                    local SectionFrame = Instance.new("Frame")
                    SectionFrame.Name = title.."Section"
                    SectionFrame.Parent = Page
                    SectionFrame.BackgroundColor3 = Sunset.Theme.SecondaryBackground
                    SectionFrame.Size = UDim2.new(1, -10, 0, 40)
                    
                    local SectionCorner = Instance.new("UICorner")
                    SectionCorner.CornerRadius = UDim.new(0, 8)
                    SectionCorner.Parent = SectionFrame

                    local SectionTitle = Instance.new("TextLabel")
                    SectionTitle.Name = "SectionTitle"
                    SectionTitle.Parent = SectionFrame
                    SectionTitle.BackgroundTransparency = 1
                    SectionTitle.Position = UDim2.new(0, 10, 0, 5)
                    SectionTitle.Size = UDim2.new(1, -20, 0, 20)
                    SectionTitle.Font = Enum.Font.GothamBold
                    SectionTitle.Text = title:upper()
                    SectionTitle.TextColor3 = Sunset.Theme.Accent
                    SectionTitle.TextSize = 12
                    SectionTitle.TextXAlignment = Enum.TextXAlignment.Left

                    local ElementContainer = Instance.new("Frame")
                    ElementContainer.Name = "ElementContainer"
                    ElementContainer.Parent = SectionFrame
                    ElementContainer.BackgroundTransparency = 1
                    ElementContainer.Position = UDim2.new(0, 10, 0, 30)
                    ElementContainer.Size = UDim2.new(1, -20, 0, 0)

                    local ElementLayout = Instance.new("UIListLayout")
                    ElementLayout.Parent = ElementContainer
                    ElementLayout.SortOrder = Enum.SortOrder.LayoutOrder
                    ElementLayout.Padding = UDim.new(0, 5)

                    ElementLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                        ElementContainer.Size = UDim2.new(1, -20, 0, ElementLayout.AbsoluteContentSize.Y)
                        SectionFrame.Size = UDim2.new(1, -10, 0, ElementLayout.AbsoluteContentSize.Y + 40)
                        Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y)
                    end)

                    return {
                        CreateButton = function(self_sec, text, callback)
                            local ButtonObj = Instance.new("TextButton")
                            ButtonObj.Name = text.."Button"
                            ButtonObj.Parent = ElementContainer
                            ButtonObj.BackgroundColor3 = Sunset.Theme.TertiaryBackground
                            ButtonObj.Size = UDim2.new(1, 0, 0, 35 * ScaleFactor)
                            ButtonObj.AutoButtonColor = false
                            ButtonObj.Font = Enum.Font.GothamMedium
                            ButtonObj.Text = text
                            ButtonObj.TextColor3 = Sunset.Theme.Text
                            ButtonObj.TextSize = 13

                            local bCorner = Instance.new("UICorner")
                            bCorner.CornerRadius = UDim.new(0, 6)
                            bCorner.Parent = ButtonObj

                            local Lock = AddLock(ButtonObj)

                            ButtonObj.MouseEnter:Connect(function()
                                Tween(ButtonObj, {BackgroundColor3 = Sunset.Theme.Accent, TextColor3 = Sunset.Theme.MainBackground})
                            end)
                            ButtonObj.MouseLeave:Connect(function()
                                Tween(ButtonObj, {BackgroundColor3 = Sunset.Theme.TertiaryBackground, TextColor3 = Sunset.Theme.Text})
                            end)
                            ButtonObj.MouseButton1Click:Connect(callback)

                            return {SetLocked = Lock}
                        end,

                        CreateToggle = function(self_sec, text, default, callback)
                            local ToggleValue = default or false
                            
                            local ToggleFrame = Instance.new("Frame")
                            ToggleFrame.Name = text.."Toggle"
                            ToggleFrame.Parent = ElementContainer
                            ToggleFrame.BackgroundTransparency = 1
                            ToggleFrame.Size = UDim2.new(1, 0, 0, 35 * ScaleFactor)

                            local ToggleLabel = Instance.new("TextLabel")
                            ToggleLabel.Name = "Label"
                            ToggleLabel.Parent = ToggleFrame
                            ToggleLabel.BackgroundTransparency = 1
                            ToggleLabel.Size = UDim2.new(1, -50, 1, 0)
                            ToggleLabel.Font = Enum.Font.Gotham
                            ToggleLabel.Text = text
                            ToggleLabel.TextColor3 = Sunset.Theme.Text
                            ToggleLabel.TextSize = 13
                            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left

                            local ToggleOuter = Instance.new("Frame")
                            ToggleOuter.Name = "Outer"
                            ToggleOuter.Parent = ToggleFrame
                            ToggleOuter.BackgroundColor3 = Sunset.Theme.TertiaryBackground
                            ToggleOuter.Position = UDim2.new(1, -45, 0.5, -10)
                            ToggleOuter.Size = UDim2.new(0, 40, 0, 20)

                            local oCorner = Instance.new("UICorner")
                            oCorner.CornerRadius = UDim.new(1, 0)
                            oCorner.Parent = ToggleOuter

                            local ToggleInner = Instance.new("Frame")
                            ToggleInner.Name = "Inner"
                            ToggleInner.Parent = ToggleOuter
                            ToggleInner.BackgroundColor3 = Sunset.Theme.TextMuted
                            ToggleInner.Position = UDim2.new(0, 2, 0.5, -8)
                            ToggleInner.Size = UDim2.new(0, 16, 0, 16)

                            local iCorner = Instance.new("UICorner")
                            iCorner.CornerRadius = UDim.new(1, 0)
                            iCorner.Parent = ToggleInner

                            local Lock = AddLock(ToggleFrame)

                            local function Update()
                                if ToggleValue then
                                    Tween(ToggleOuter, {BackgroundColor3 = Sunset.Theme.Accent})
                                    Tween(ToggleInner, {Position = UDim2.new(1, -18, 0.5, -8), BackgroundColor3 = Sunset.Theme.MainBackground})
                                else
                                    Tween(ToggleOuter, {BackgroundColor3 = Sunset.Theme.TertiaryBackground})
                                    Tween(ToggleInner, {Position = UDim2.new(0, 2, 0.5, -8), BackgroundColor3 = Sunset.Theme.TextMuted})
                                end
                                callback(ToggleValue)
                            end

                            ToggleFrame.InputBegan:Connect(function(input)
                                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                                    ToggleValue = not ToggleValue
                                    Update()
                                end
                            end)

                            if default then Update() end
                            return {SetLocked = Lock}
                        end,

                        CreateSlider = function(self_sec, text, min, max, default, callback)
                            local SliderValue = default or min
                            
                            local SliderFrame = Instance.new("Frame")
                            SliderFrame.Name = text.."Slider"
                            SliderFrame.Parent = ElementContainer
                            SliderFrame.BackgroundTransparency = 1
                            SliderFrame.Size = UDim2.new(1, 0, 0, 45 * ScaleFactor)

                            local SliderLabel = Instance.new("TextLabel")
                            SliderLabel.Name = "Label"
                            SliderLabel.Parent = SliderFrame
                            SliderLabel.BackgroundTransparency = 1
                            SliderLabel.Size = UDim2.new(1, 0, 0, 20)
                            SliderLabel.Font = Enum.Font.Gotham
                            SliderLabel.Text = text
                            SliderLabel.TextColor3 = Sunset.Theme.Text
                            SliderLabel.TextSize = 13
                            SliderLabel.TextXAlignment = Enum.TextXAlignment.Left

                            local ValueLabel = Instance.new("TextLabel")
                            ValueLabel.Name = "Value"
                            ValueLabel.Parent = SliderFrame
                            ValueLabel.BackgroundTransparency = 1
                            ValueLabel.Position = UDim2.new(1, -50, 0, 0)
                            ValueLabel.Size = UDim2.new(0, 50, 0, 20)
                            ValueLabel.Font = Enum.Font.GothamBold
                            ValueLabel.Text = tostring(SliderValue)
                            ValueLabel.TextColor3 = Sunset.Theme.Accent
                            ValueLabel.TextSize = 12
                            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right

                            local SliderBack = Instance.new("Frame")
                            SliderBack.Name = "Back"
                            SliderBack.Parent = SliderFrame
                            SliderBack.BackgroundColor3 = Sunset.Theme.TertiaryBackground
                            SliderBack.Position = UDim2.new(0, 0, 0, 25)
                            SliderBack.Size = UDim2.new(1, 0, 0, 6)

                            local sbCorner = Instance.new("UICorner")
                            sbCorner.CornerRadius = UDim.new(1, 0)
                            sbCorner.Parent = SliderBack

                            local SliderFill = Instance.new("Frame")
                            SliderFill.Name = "Fill"
                            SliderFill.Parent = SliderBack
                            SliderFill.BackgroundColor3 = Sunset.Theme.Accent
                            SliderFill.Size = UDim2.new((SliderValue - min) / (max - min), 0, 1, 0)

                            local sfCorner = Instance.new("UICorner")
                            sfCorner.CornerRadius = UDim.new(1, 0)
                            sfCorner.Parent = SliderFill

                            local Lock = AddLock(SliderFrame)

                            local function UpdateSlider(input)
                                local pos = math.clamp((input.Position.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
                                SliderValue = math.floor(min + (max - min) * pos)
                                ValueLabel.Text = tostring(SliderValue)
                                Tween(SliderFill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.1)
                                callback(SliderValue)
                            end

                            local dragging = false
                            SliderBack.InputBegan:Connect(function(input)
                                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                                    dragging = true
                                    UpdateSlider(input)
                                end
                            end)

                            UIS.InputEnded:Connect(function(input)
                                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                                    dragging = false
                                end
                            end)

                            UIS.InputChanged:Connect(function(input)
                                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                                    UpdateSlider(input)
                                end
                            end)

                            return {SetLocked = Lock}
                        end,

                        CreateInput = function(self_sec, text, placeholder, callback)
                            local InputFrame = Instance.new("Frame")
                            InputFrame.Name = text.."Input"
                            InputFrame.Parent = ElementContainer
                            InputFrame.BackgroundColor3 = Sunset.Theme.TertiaryBackground
                            InputFrame.Size = UDim2.new(1, 0, 0, 35 * ScaleFactor)

                            local iCorner = Instance.new("UICorner")
                            iCorner.CornerRadius = UDim.new(0, 6)
                            iCorner.Parent = InputFrame

                            local TextBox = Instance.new("TextBox")
                            TextBox.Name = "TextBox"
                            TextBox.Parent = InputFrame
                            TextBox.BackgroundTransparency = 1
                            TextBox.Position = UDim2.new(0, 10, 0, 0)
                            TextBox.Size = UDim2.new(1, -20, 1, 0)
                            TextBox.Font = Enum.Font.Gotham
                            TextBox.PlaceholderText = placeholder or text .. "..."
                            TextBox.PlaceholderColor3 = Sunset.Theme.TextMuted
                            TextBox.Text = ""
                            TextBox.TextColor3 = Sunset.Theme.Text
                            TextBox.TextSize = 13
                            TextBox.TextXAlignment = Enum.TextXAlignment.Left

                            local Lock = AddLock(InputFrame)

                            TextBox.FocusLost:Connect(function(enterPressed)
                                callback(TextBox.Text, enterPressed)
                            end)

                            return {SetLocked = Lock}
                        end,

                        CreateKeybind = function(self_sec, text, default, callback)
                            local Key = default or "None"
                            local Binding = false
                            
                            local BindFrame = Instance.new("Frame")
                            BindFrame.Name = text.."Keybind"
                            BindFrame.Parent = ElementContainer
                            BindFrame.BackgroundTransparency = 1
                            BindFrame.Size = UDim2.new(1, 0, 0, 35 * ScaleFactor)

                            local BindLabel = Instance.new("TextLabel")
                            BindLabel.Parent = BindFrame
                            BindLabel.BackgroundTransparency = 1
                            BindLabel.Size = UDim2.new(1, -100, 1, 0)
                            BindLabel.Font = Enum.Font.GothamMedium
                            BindLabel.Text = text
                            BindLabel.TextColor3 = Sunset.Theme.Text
                            BindLabel.TextSize = 13
                            BindLabel.TextXAlignment = Enum.TextXAlignment.Left

                            local BindButton = Instance.new("TextButton")
                            BindButton.Parent = BindFrame
                            BindButton.BackgroundColor3 = Sunset.Theme.TertiaryBackground
                            BindButton.Position = UDim2.new(1, -90 * ScaleFactor, 0.5, -12)
                            BindButton.Size = UDim2.new(0, 80 * ScaleFactor, 0, 24)
                            BindButton.AutoButtonColor = false
                            BindButton.Font = Enum.Font.GothamBold
                            BindButton.Text = (typeof(Key) == "EnumItem" and Key.Name) or tostring(Key)
                            BindButton.TextColor3 = Sunset.Theme.Accent
                            BindButton.TextSize = 12

                            local bCorner = Instance.new("UICorner")
                            bCorner.CornerRadius = UDim.new(0, 6)
                            bCorner.Parent = BindButton

                            local Lock = AddLock(BindFrame)

                            BindButton.MouseButton1Click:Connect(function()
                                Binding = true
                                BindButton.Text = "..."
                            end)

                            UIS.InputBegan:Connect(function(input)
                                if Binding and input.UserInputType == Enum.UserInputType.Keyboard then
                                    Key = input.KeyCode
                                    BindButton.Text = Key.Name
                                    Binding = false
                                    callback(Key)
                                end
                            end)

                            return {SetLocked = Lock}
                        end,

                        CreateColorpicker = function(self_sec, text, default, callback)
                            local Color = default or Color3.fromRGB(255, 255, 255)
                            
                            local ColorFrame = Instance.new("Frame")
                            ColorFrame.Name = text.."Colorpicker"
                            ColorFrame.Parent = ElementContainer
                            ColorFrame.BackgroundTransparency = 1
                            ColorFrame.Size = UDim2.new(1, 0, 0, 35 * ScaleFactor)

                            local ColorLabel = Instance.new("TextLabel")
                            ColorLabel.Parent = ColorFrame
                            ColorLabel.BackgroundTransparency = 1
                            ColorLabel.Size = UDim2.new(1, -60, 1, 0)
                            ColorLabel.Font = Enum.Font.GothamMedium
                            ColorLabel.Text = text
                            ColorLabel.TextColor3 = Sunset.Theme.Text
                            ColorLabel.TextSize = 13
                            ColorLabel.TextXAlignment = Enum.TextXAlignment.Left

                            local ColorDisplay = Instance.new("Frame")
                            ColorDisplay.Parent = ColorFrame
                            ColorDisplay.BackgroundColor3 = Color
                            ColorDisplay.Position = UDim2.new(1, -50, 0.5, -10)
                            ColorDisplay.Size = UDim2.new(0, 40, 0, 20)

                            local dCorner = Instance.new("UICorner")
                            dCorner.CornerRadius = UDim.new(0, 4)
                            dCorner.Parent = ColorDisplay

                            local Lock = AddLock(ColorFrame)

                            ColorDisplay.InputBegan:Connect(function(input)
                                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                                    Color = Color3.fromHSV(tick() % 5 / 5, 0.8, 1)
                                    ColorDisplay.BackgroundColor3 = Color
                                    callback(Color)
                                end
                            end)

                            return {SetLocked = Lock}
                        end,

                        CreateParagraph = function(self_sec, text)
                            local ParaLabel = Instance.new("TextLabel")
                            ParaLabel.Name = "Paragraph"
                            ParaLabel.Parent = ElementContainer
                            ParaLabel.BackgroundColor3 = Sunset.Theme.SecondaryBackground
                            ParaLabel.BackgroundTransparency = 0.5
                            ParaLabel.Size = UDim2.new(1, 0, 0, 30 * ScaleFactor)
                            ParaLabel.Font = Enum.Font.Gotham
                            ParaLabel.Text = "  " .. text
                            ParaLabel.TextColor3 = Sunset.Theme.TextMuted
                            ParaLabel.TextSize = 12
                            ParaLabel.TextXAlignment = Enum.TextXAlignment.Left
                            ParaLabel.TextWrapped = true

                            local pCorner = Instance.new("UICorner")
                            pCorner.CornerRadius = UDim.new(0, 6)
                            pCorner.Parent = ParaLabel

                            local Lock = AddLock(ParaLabel)

                            ParaLabel:GetPropertyChangedSignal("TextBounds"):Connect(function()
                                ParaLabel.Size = UDim2.new(1, 0, 0, (ParaLabel.TextBounds.Y + 10) * ScaleFactor)
                            end)

                            return {SetLocked = Lock}
                        end,

                        CreateDivider = function(self_sec)
                            local Div = Instance.new("Frame")
                            Div.Name = "Divider"
                            Div.Parent = ElementContainer
                            Div.BackgroundColor3 = Sunset.Theme.Border
                            Div.BackgroundTransparency = 0.5
                            Div.BorderSizePixel = 0
                            Div.Size = UDim2.new(1, 0, 0, 1)
                        end
                    }
                end
            }
        end
    }
end

-- Notification stack tracker
local _notifOffset = 0

function Sunset:Notify(title, text, duration)
    local ScreenGui = CoreGui:FindFirstChild("SunsetUI")
    if not ScreenGui then return end

    _notifOffset += 1
    local myOffset = _notifOffset
    local yOffset = -10 - (90 * (myOffset - 1))

    local NotificationFrame = Instance.new("Frame")
    NotificationFrame.Name = "Notification"
    NotificationFrame.Parent = ScreenGui
    NotificationFrame.BackgroundColor3 = self.Theme.SecondaryBackground
    NotificationFrame.BorderSizePixel = 0
    NotificationFrame.Position = UDim2.new(1, 20, 1, yOffset)
    NotificationFrame.Size = UDim2.new(0, 260, 0, 80)
    NotificationFrame.ZIndex = 50

    local nCorner = Instance.new("UICorner")
    nCorner.CornerRadius = UDim.new(0, 8)
    nCorner.Parent = NotificationFrame

    local nStroke = Instance.new("UIStroke")
    nStroke.Color = self.Theme.Border
    nStroke.Thickness = 1
    nStroke.Parent = NotificationFrame

    local Strike = Instance.new("Frame")
    Strike.Parent = NotificationFrame
    Strike.BackgroundColor3 = self.Theme.Accent
    Strike.BorderSizePixel = 0
    Strike.Size = UDim2.new(0, 4, 1, 0)
    Strike.ZIndex = 51
    local sCorner = Instance.new("UICorner")
    sCorner.CornerRadius = UDim.new(0, 8)
    sCorner.Parent = Strike

    local tLabel = Instance.new("TextLabel")
    tLabel.Parent = NotificationFrame
    tLabel.BackgroundTransparency = 1
    tLabel.Position = UDim2.new(0, 16, 0, 10)
    tLabel.Size = UDim2.new(1, -25, 0, 22)
    tLabel.Font = Enum.Font.GothamBold
    tLabel.Text = title
    tLabel.TextColor3 = self.Theme.Text
    tLabel.TextSize = 14
    tLabel.TextXAlignment = Enum.TextXAlignment.Left
    tLabel.ZIndex = 51

    local dLabel = Instance.new("TextLabel")
    dLabel.Parent = NotificationFrame
    dLabel.BackgroundTransparency = 1
    dLabel.Position = UDim2.new(0, 16, 0, 33)
    dLabel.Size = UDim2.new(1, -25, 0, 40)
    dLabel.Font = Enum.Font.Gotham
    dLabel.Text = text
    dLabel.TextColor3 = self.Theme.TextMuted
    dLabel.TextSize = 12
    dLabel.TextXAlignment = Enum.TextXAlignment.Left
    dLabel.TextWrapped = true
    dLabel.ZIndex = 51

    local ProgressBar = Instance.new("Frame")
    ProgressBar.Parent = NotificationFrame
    ProgressBar.BackgroundColor3 = self.Theme.Accent
    ProgressBar.BackgroundTransparency = 0.6
    ProgressBar.BorderSizePixel = 0
    ProgressBar.Position = UDim2.new(0, 0, 1, -2)
    ProgressBar.Size = UDim2.new(1, 0, 0, 2)
    ProgressBar.ZIndex = 51
    local pbCorner = Instance.new("UICorner")
    pbCorner.CornerRadius = UDim.new(1, 0)
    pbCorner.Parent = ProgressBar

    Tween(NotificationFrame, {Position = UDim2.new(1, -275, 1, yOffset)})
    Tween(ProgressBar, {Size = UDim2.new(0, 0, 0, 2)}, duration or 3)

    task.delay(duration or 3, function()
        Tween(NotificationFrame, {Position = UDim2.new(1, 20, 1, yOffset)})
        task.wait(0.35)
        NotificationFrame:Destroy()
        _notifOffset = math.max(0, _notifOffset - 1)
    end)
end

function Sunset:Popup(title, text, onConfirm, onCancel)
    local ScreenGui = CoreGui:FindFirstChild("SunsetUI")
    if not ScreenGui then return end

    local Overlay = Instance.new("Frame")
    Overlay.Name = "PopupOverlay"
    Overlay.Parent = ScreenGui
    Overlay.BackgroundColor3 = Color3.new(0, 0, 0)
    Overlay.BackgroundTransparency = 1
    Overlay.Size = UDim2.new(1, 0, 1, 0)
    Overlay.ZIndex = 100

    local PopupFrame = Instance.new("Frame")
    PopupFrame.Name = "Popup"
    PopupFrame.Parent = Overlay
    PopupFrame.BackgroundColor3 = self.Theme.MainBackground
    PopupFrame.BorderSizePixel = 0
    PopupFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    PopupFrame.Position = UDim2.new(0.5, 0, 0.6, 0)
    PopupFrame.Size = UDim2.new(0, 320, 0, 165)
    PopupFrame.ZIndex = 101

    local pCorner = Instance.new("UICorner")
    pCorner.CornerRadius = UDim.new(0, 10)
    pCorner.Parent = PopupFrame

    local pStroke = Instance.new("UIStroke")
    pStroke.Color = self.Theme.Border
    pStroke.Thickness = 1.5
    pStroke.Parent = PopupFrame

    local tLabel = Instance.new("TextLabel")
    tLabel.Parent = PopupFrame
    tLabel.BackgroundTransparency = 1
    tLabel.Position = UDim2.new(0, 20, 0, 20)
    tLabel.Size = UDim2.new(1, -40, 0, 25)
    tLabel.Font = Enum.Font.GothamBold
    tLabel.Text = title
    tLabel.TextColor3 = self.Theme.Text
    tLabel.TextSize = 16
    tLabel.TextXAlignment = Enum.TextXAlignment.Left
    tLabel.ZIndex = 102

    local dLabel = Instance.new("TextLabel")
    dLabel.Parent = PopupFrame
    dLabel.BackgroundTransparency = 1
    dLabel.Position = UDim2.new(0, 20, 0, 50)
    dLabel.Size = UDim2.new(1, -40, 0, 50)
    dLabel.Font = Enum.Font.Gotham
    dLabel.Text = text
    dLabel.TextColor3 = self.Theme.TextMuted
    dLabel.TextSize = 13
    dLabel.TextWrapped = true
    dLabel.ZIndex = 102

    local Confirm = Instance.new("TextButton")
    Confirm.Parent = PopupFrame
    Confirm.BackgroundColor3 = self.Theme.Accent
    Confirm.BorderSizePixel = 0
    Confirm.Position = UDim2.new(1, -150, 1, -45)
    Confirm.Size = UDim2.new(0, 130, 0, 32)
    Confirm.Font = Enum.Font.GothamBold
    Confirm.Text = "Confirm"
    Confirm.TextColor3 = Color3.new(1, 1, 1)
    Confirm.TextSize = 13
    Confirm.AutoButtonColor = false
    Confirm.ZIndex = 102
    local cCorner = Instance.new("UICorner")
    cCorner.CornerRadius = UDim.new(0, 6)
    cCorner.Parent = Confirm

    local Cancel = Instance.new("TextButton")
    Cancel.Parent = PopupFrame
    Cancel.BackgroundColor3 = self.Theme.TertiaryBackground
    Cancel.BorderSizePixel = 0
    Cancel.Position = UDim2.new(0, 20, 1, -45)
    Cancel.Size = UDim2.new(0, 100, 0, 32)
    Cancel.Font = Enum.Font.GothamMedium
    Cancel.Text = "Cancel"
    Cancel.TextColor3 = self.Theme.TextMuted
    Cancel.TextSize = 13
    Cancel.AutoButtonColor = false
    Cancel.ZIndex = 102
    local cancelCorner = Instance.new("UICorner")
    cancelCorner.CornerRadius = UDim.new(0, 6)
    cancelCorner.Parent = Cancel

    Tween(Overlay, {BackgroundTransparency = 0.55})
    Tween(PopupFrame, {Position = UDim2.new(0.5, 0, 0.5, 0)})

    local function Close()
        Tween(Overlay, {BackgroundTransparency = 1})
        Tween(PopupFrame, {Position = UDim2.new(0.5, 0, 0.6, 0)})
        task.wait(0.25)
        Overlay:Destroy()
    end

    Confirm.MouseButton1Click:Connect(function()
        if onConfirm then onConfirm() end
        Close()
    end)
    Cancel.MouseButton1Click:Connect(function()
        if onCancel then onCancel() end
        Close()
    end)
end

return Sunset
