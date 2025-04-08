local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Cài đặt mặc định
local settings = {
    mainColor = Color3.fromRGB(30, 30, 30),
    accentColor = Color3.fromRGB(157, 78, 221), -- Màu tím giống trong ảnh
    secondaryColor = Color3.fromRGB(40, 40, 40),
    textColor = Color3.fromRGB(255, 255, 255),
    font = Enum.Font.SourceSansBold,
    textSize = 16,
    toggleOn = Color3.fromRGB(157, 78, 221),
    toggleOff = Color3.fromRGB(60, 60, 60),
    sliderColor = Color3.fromRGB(157, 78, 221),
    sliderBackground = Color3.fromRGB(60, 60, 60),
    dropdownBackground = Color3.fromRGB(40, 40, 40),
    buttonColor = Color3.fromRGB(50, 50, 50),
    buttonHoverColor = Color3.fromRGB(60, 60, 60),
    windowCornerRadius = UDim.new(0, 6),
    elementCornerRadius = UDim.new(0, 4)
}

-- Utility Functions
local function CreateTween(instance, properties, duration, easingStyle, easingDirection, delay)
    delay = delay or 0
    local tween = TweenService:Create(
        instance,
        TweenInfo.new(duration or 0.3, easingStyle or Enum.EasingStyle.Quad, easingDirection or Enum.EasingDirection.Out, 0, false, delay),
        properties
    )
    tween:Play()
    return tween
end

local function CreateInstance(instanceType, properties)
    local instance = Instance.new(instanceType)
    for property, value in pairs(properties) do
        instance[property] = value
    end
    return instance
end

local function AddCorners(instance, radius)
    local corner = CreateInstance("UICorner", {
        CornerRadius = radius or settings.elementCornerRadius,
        Parent = instance
    })
    return corner
end

local function AddPadding(instance, padding)
    local uiPadding = CreateInstance("UIPadding", {
        PaddingLeft = UDim.new(0, padding or 8),
        PaddingRight = UDim.new(0, padding or 8),
        PaddingTop = UDim.new(0, padding or 8),
        PaddingBottom = UDim.new(0, padding or 8),
        Parent = instance
    })
    return uiPadding
end

local function AddRippleEffect(button)
    button.ClipsDescendants = true
    
    local function CreateRipple(x, y)
        local ripple = CreateInstance("Frame", {
            Name = "Ripple",
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 0.7,
            Position = UDim2.new(0, x, 0, y),
            Size = UDim2.new(0, 0, 0, 0),
            Parent = button
        })
        
        AddCorners(ripple, UDim.new(1, 0))
        
        local maxSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2
        
        CreateTween(ripple, {
            Size = UDim2.new(0, maxSize, 0, maxSize),
            BackgroundTransparency = 1
        }, 0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        
        delay(0.5, function()
            if ripple and ripple.Parent then
                ripple:Destroy()
            end
        end)
    end
    
    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local x = input.Position.X - button.AbsolutePosition.X
            local y = input.Position.Y - button.AbsolutePosition.Y
            CreateRipple(x, y)
        end
    end)
end

-- Window Creation
function Library:CreateWindow(title, size)
    local window = {}
    local dragToggle, dragInput, dragStart, startPos
    
    -- MainFrame
    local screenGui = CreateInstance("ScreenGui", {
        Name = "RobloxUILibrary",
        Parent = game.CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false
    })
    
    local mainFrame = CreateInstance("Frame", {
        Name = "MainFrame",
        Size = size or UDim2.new(0, 500, 0, 350),
        Position = UDim2.new(0.5, -250, 0.5, -175),
        BackgroundColor3 = settings.mainColor,
        BorderSizePixel = 0,
        Parent = screenGui
    })
    
    AddCorners(mainFrame, settings.windowCornerRadius)
    
    -- TitleBar
    local titleBar = CreateInstance("Frame", {
        Name = "TitleBar",
        Size = UDim2.new(1, 0, 0, 40),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = settings.secondaryColor,
        BorderSizePixel = 0,
        Parent = mainFrame
    })
    
    AddCorners(titleBar, UDim.new(0, 6))
    
    local titleLabel = CreateInstance("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -80, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        TextColor3 = settings.textColor,
        TextSize = settings.textSize,
        Font = settings.font,
        Text = title or "Live Example",
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = titleBar
    })
    
    local closeButton = CreateInstance("TextButton", {
        Name = "CloseButton",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -35, 0, 5),
        BackgroundColor3 = Color3.fromRGB(255, 85, 85),
        Text = "X",
        TextColor3 = settings.textColor,
        TextSize = settings.textSize,
        Font = settings.font,
        Parent = titleBar
    })
    
    AddCorners(closeButton, UDim.new(0, 4))
    AddRippleEffect(closeButton)
    
    local minimizeButton = CreateInstance("TextButton", {
        Name = "MinimizeButton",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -70, 0, 5),
        BackgroundColor3 = Color3.fromRGB(60, 60, 60),
        Text = "-",
        TextColor3 = settings.textColor,
        TextSize = settings.textSize,
        Font = settings.font,
        Parent = titleBar
    })
    
    AddCorners(minimizeButton, UDim.new(0, 4))
    AddRippleEffect(minimizeButton)
    
    -- Search Bar
    local searchBar = CreateInstance("TextBox", {
        Name = "SearchBar",
        Size = UDim2.new(0, 150, 0, 30),
        Position = UDim2.new(0.5, -75, 0, 5),
        BackgroundColor3 = settings.secondaryColor,
        TextColor3 = settings.textColor,
        PlaceholderText = "Search...",
        Text = "",
        TextSize = settings.textSize,
        Font = settings.font,
        Parent = titleBar
    })
    
    AddCorners(searchBar, UDim.new(0, 15))
    
    local searchIcon = CreateInstance("ImageLabel", {
        Name = "SearchIcon",
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(0, 8, 0.5, -8),
        BackgroundTransparency = 1,
        Image = "rbxassetid://3605509925",
        Parent = searchBar
    })
    
    searchBar.Position = searchBar.Position + UDim2.new(0, 20, 0, 0)
    AddPadding(searchBar, 30)
    
    -- Tab Container
    local tabContainer = CreateInstance("Frame", {
        Name = "TabContainer",
        Size = UDim2.new(0, 120, 1, -40),
        Position = UDim2.new(0, 0, 0, 40),
        BackgroundColor3 = settings.secondaryColor,
        BorderSizePixel = 0,
        Parent = mainFrame
    })
    
    local tabListLayout = CreateInstance("UIListLayout", {
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = tabContainer
    })
    
    AddPadding(tabContainer)
    
    -- Content Frame
    local contentFrame = CreateInstance("Frame", {
        Name = "ContentFrame",
        Size = UDim2.new(1, -120, 1, -40),
        Position = UDim2.new(0, 120, 0, 40),
        BackgroundColor3 = settings.mainColor,
        BorderSizePixel = 0,
        Parent = mainFrame
    })
    
    -- Make Window Draggable
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragToggle = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)
    
    titleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragToggle = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragToggle then
            dragInput = input
        end
    end)
    
    RunService.RenderStepped:Connect(function()
        if dragToggle and dragInput then
            local delta = dragInput.Position - dragStart
            mainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    local minimized = false
    minimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            CreateTween(mainFrame, {
                Size = UDim2.new(0, mainFrame.Size.X.Offset, 0, 40)
            }, 0.3)
            tabContainer.Visible = false
            contentFrame.Visible = false
        else
            CreateTween(mainFrame, {
                Size = size or UDim2.new(0, 500, 0, 350)
            }, 0.3)
            tabContainer.Visible = true
            contentFrame.Visible = true
        end
    end)
    
    -- Tab Functions
    local tabs = {}
    local activeTab = nil
    
    function window:CreateTab(tabName)
        local tab = {}
        
        -- Tab Button
        local tabButton = CreateInstance("TextButton", {
            Name = tabName,
            Size = UDim2.new(1, -10, 0, 30),
            BackgroundColor3 = settings.buttonColor,
            Text = tabName,
            TextColor3 = settings.textColor,
            TextSize = settings.textSize,
            Font = settings.font,
            Parent = tabContainer
        })
        
        AddCorners(tabButton)
        AddRippleEffect(tabButton)
        
        -- Tab Content
        local tabContent = CreateInstance("ScrollingFrame", {
            Name = tabName.."Content",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = settings.accentColor,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Visible = false,
            Parent = contentFrame
        })
        
        local elementsLayout = CreateInstance("UIListLayout", {
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = tabContent
        })
        
        AddPadding(tabContent)
        
        elementsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabContent.CanvasSize = UDim2.new(0, 0, 0, elementsLayout.AbsoluteContentSize.Y + 16)
        end)
        
        -- Auto-update canvas size
        local function UpdateCanvasSize()
            tabContent.CanvasSize = UDim2.new(0, 0, 0, elementsLayout.AbsoluteContentSize.Y + 16)
        end
        
        -- Tab Selection Logic
        tabButton.MouseButton1Click:Connect(function()
            if activeTab then
                -- Highlight the previous tab button
                CreateTween(tabs[activeTab].Button, {
                    BackgroundColor3 = settings.buttonColor
                }, 0.2)
                tabs[activeTab].Content.Visible = false
            end
            
            -- Highlight this tab button
            CreateTween(tabButton, {
                BackgroundColor3 = settings.accentColor
            }, 0.2)
            tabContent.Visible = true
            activeTab = tabName
        end)
        
        tab.Content = tabContent
        tab.Button = tabButton
        tabs[tabName] = tab
        
        -- If this is the first tab, activate it
        if not activeTab then
            CreateTween(tabButton, {
                BackgroundColor3 = settings.accentColor  
            }, 0.2)
            tabContent.Visible = true
            activeTab = tabName
        end
        
        -- Section Function
        function tab:CreateSection(sectionName)
            local section = {}
            
            local sectionFrame = CreateInstance("Frame", {
                Name = sectionName.."Section",
                Size = UDim2.new(1, 0, 0, 36), -- Initial size, will grow
                BackgroundColor3 = settings.secondaryColor,
                Parent = tabContent
            })
            
            AddCorners(sectionFrame)
            
            local sectionHeader = CreateInstance("Frame", {
                Name = "Header",
                Size = UDim2.new(1, 0, 0, 36),
                BackgroundTransparency = 1,
                Parent = sectionFrame
            })
            
            local sectionTitle = CreateInstance("TextLabel", {
                Name = "Title",
                Size = UDim2.new(1, -10, 1, 0),
                Position = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text = sectionName,
                TextColor3 = settings.textColor,
                TextSize = settings.textSize,
                Font = settings.font,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = sectionHeader
            })
            
            local sectionContent = CreateInstance("Frame", {
                Name = "Content",
                Size = UDim2.new(1, -20, 1, -36),
                Position = UDim2.new(0, 10, 0, 36),
                BackgroundTransparency = 1,
                Parent = sectionFrame
            })
            
            local sectionLayout = CreateInstance("UIListLayout", {
                Padding = UDim.new(0, 8),
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = sectionContent
            })
            
            -- Auto-adjust section height
            sectionLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                sectionFrame.Size = UDim2.new(1, 0, 0, sectionLayout.AbsoluteContentSize.Y + 44)
                UpdateCanvasSize()
            end)
            
            -- Label Element
            function section:CreateLabel(text)
                local label = CreateInstance("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 30),
                    BackgroundTransparency = 1,
                    Text = text,
                    TextColor3 = settings.textColor,
                    TextSize = settings.textSize,
                    Font = settings.font,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = sectionContent
                })
                
                UpdateCanvasSize()
                return label
            end
            
            -- Button Element
            function section:CreateButton(text, callback)
                callback = callback or function() end
                
                local buttonFrame = CreateInstance("Frame", {
                    Size = UDim2.new(1, 0, 0, 36),
                    BackgroundTransparency = 1,
                    Parent = sectionContent
                })
                
                local button = CreateInstance("TextButton", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundColor3 = settings.buttonColor,
                    Text = text,
                    TextColor3 = settings.textColor,
                    TextSize = settings.textSize,
                    Font = settings.font,
                    Parent = buttonFrame
                })
                
                AddCorners(button)
                AddRippleEffect(button)
                
                -- Button hover and click effects
                button.MouseEnter:Connect(function()
                    CreateTween(button, {
                        BackgroundColor3 = settings.buttonHoverColor
                    }, 0.2)
                end)
                
                button.MouseLeave:Connect(function()
                    CreateTween(button, {
                        BackgroundColor3 = settings.buttonColor
                    }, 0.2)
                end)
                
                button.MouseButton1Click:Connect(function()
                    callback()
                end)
                
                UpdateCanvasSize()
                return button
            end
            
            -- Toggle Element
            function section:CreateToggle(text, callback)
                callback = callback or function() end
                local toggled = false
                
                local toggleFrame = CreateInstance("Frame", {
                    Size = UDim2.new(1, 0, 0, 36),
                    BackgroundTransparency = 1,
                    Parent = sectionContent
                })
                
                local toggleLabel = CreateInstance("TextLabel", {
                    Size = UDim2.new(1, -50, 1, 0),
                    Position = UDim2.new(0, 0, 0, 0),
                    BackgroundTransparency = 1,
                    Text = text,
                    TextColor3 = settings.textColor,
                    TextSize = settings.textSize,
                    Font = settings.font,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = toggleFrame
                })
                
                local toggleButton = CreateInstance("Frame", {
                    Size = UDim2.new(0, 40, 0, 20),
                    Position = UDim2.new(1, -40, 0.5, -10),
                    BackgroundColor3 = settings.toggleOff,
                    Parent = toggleFrame
                })
                
                AddCorners(toggleButton, UDim.new(1, 0))
                
                local toggleIndicator = CreateInstance("Frame", {
                    Size = UDim2.new(0, 16, 0, 16),
                    Position = UDim2.new(0, 2, 0.5, -8),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Parent = toggleButton
                })
                
                AddCorners(toggleIndicator, UDim.new(1, 0))
                
                local toggleClick = CreateInstance("TextButton", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = "",
                    Parent = toggleFrame
                })
                
                local function UpdateToggle()
                    if toggled then
                        CreateTween(toggleButton, {
                            BackgroundColor3 = settings.toggleOn
                        }, 0.2)
                        CreateTween(toggleIndicator, {
                            Position = UDim2.new(0, 22, 0.5, -8)
                        }, 0.2)
                    else
                        CreateTween(toggleButton, {
                            BackgroundColor3 = settings.toggleOff
                        }, 0.2)
                        CreateTween(toggleIndicator, {
                            Position = UDim2.new(0, 2, 0.5, -8)
                        }, 0.2)
                    end
                    callback(toggled)
                end
                
                toggleClick.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    UpdateToggle()
                end)
                
                UpdateCanvasSize()
                
                -- Return toggle with methods to get/set state
                local toggleObject = {}
                
                function toggleObject:SetState(state)
                    toggled = state
                    UpdateToggle()
                end
                
                function toggleObject:GetState()
                    return toggled
                end
                
                return toggleObject
            end
            
            -- Slider Element
            function section:CreateSlider(text, options, callback)
                options = options or {}
                options.min = options.min or 0
                options.max = options.max or 100
                options.default = options.default or options.min
                callback = callback or function() end
                
                local sliderFrame = CreateInstance("Frame", {
                    Size = UDim2.new(1, 0, 0, 50),
                    BackgroundTransparency = 1,
                    Parent = sectionContent
                })
                
                local sliderLabel = CreateInstance("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 20),
                    Position = UDim2.new(0, 0, 0, 0),
                    BackgroundTransparency = 1,
                    Text = text,
                    TextColor3 = settings.textColor,
                    TextSize = settings.textSize,
                    Font = settings.font,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = sliderFrame
                })
                
                local sliderContainer = CreateInstance("Frame", {
                    Name = "SliderContainer",
                    Size = UDim2.new(1, -50, 0, 6),
                    Position = UDim2.new(0, 0, 0, 30),
                    BackgroundColor3 = settings.sliderBackground,
                    Parent = sliderFrame
                })
                
                AddCorners(sliderContainer, UDim.new(1, 0))
                
                local sliderFill = CreateInstance("Frame", {
                    Name = "SliderFill",
                    Size = UDim2.new(0, 0, 1, 0),
                    BackgroundColor3 = settings.sliderColor,
                    Parent = sliderContainer
                })
                
                AddCorners(sliderFill, UDim.new(1, 0))
                
                local sliderHandle = CreateInstance("Frame", {
                    Name = "SliderHandle",
                    Size = UDim2.new(0, 14, 0, 14),
                    Position = UDim2.new(0, -7, 0.5, -7),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Parent = sliderFill
                })
                
                AddCorners(sliderHandle, UDim.new(1, 0))
                
                local sliderValue = CreateInstance("TextLabel", {
                    Name = "SliderValue",
                    Size = UDim2.new(0, 40, 0, 20),
                    Position = UDim2.new(1, 5, 0, 20),
                    BackgroundTransparency = 1,
                    Text = tostring(options.default),
                    TextColor3 = settings.textColor,
                    TextSize = settings.textSize - 2,
                    Font = settings.font,
                    TextXAlignment = Enum.TextXAlignment.Center,
                    Parent = sliderFrame
                })
                
                local sliderButton = CreateInstance("TextButton", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = "",
                    Parent = sliderContainer
                })
                
                local dragging = false
                
                local function UpdateSlider(value)
                    value = math.clamp(value, options.min, options.max)
                    local percent = (value - options.min) / (options.max - options.min)
                    
                    CreateTween(sliderFill, {
                        Size = UDim2.new(percent, 0, 1, 0)
                    }, 0.1)
                    
                    sliderValue.Text = tostring(math.floor(value))
                    callback(value)
                end
                
                -- Set default value
                UpdateSlider(options.default)
                
                sliderButton.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                    end
                end)
                
                sliderButton.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local percent = math.clamp((input.Position.X - sliderContainer.AbsolutePosition.X) / sliderContainer.AbsoluteSize.X, 0, 1)
                        local value = options.min + (options.max - options.min) * percent
                        UpdateSlider(value)
                    end
                end)
                
                UpdateCanvasSize()
                
                -- Return slider with methods to get/set value
                local sliderObject = {}
                
                function sliderObject:SetValue(value)
                    UpdateSlider(value)
                end
                
                function sliderObject:GetValue()
                    return tonumber(sliderValue.Text)
                end
                
                return sliderObject
            end
            
            -- Dropdown Element
            function section:CreateDropdown(text, options, callback)
                options = options or {}
                callback = callback or function() end
                
                local isOpen = false
                local selected = options[1] or ""
                
                local dropdownFrame = CreateInstance("Frame", {
                    Size = UDim2.new(1, 0, 0, 36),
                    BackgroundTransparency = 1,
                    ClipsDescendants = true,
                    Parent = sectionContent
                })
                
                local dropdownButton = CreateInstance("TextButton", {
                    Size = UDim2.new(1, 0, 0, 36),
                    BackgroundColor3 = settings.buttonColor,
                    Text = "",
                    Parent = dropdownFrame
                })
                
                AddCorners(dropdownButton)
                
                local dropdownLabel = CreateInstance("TextLabel", {
                    Size = UDim2.new(1, -30, 1, 0),
                    Position = UDim2.new(0, 10, 0, 0),
                    BackgroundTransparency = 1,
                    Text = text,
                    TextColor3 = settings.textColor,
                    TextSize = settings.textSize,
                    Font = settings.font,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = dropdownButton
                })
                
                local selectedText = CreateInstance("TextLabel", {
                    Size = UDim2.new(0.5, 0, 1, 0),
                    Position = UDim2.new(0.5, 0, 0, 0),
                    BackgroundTransparency = 1,
                    Text = selected,
                    TextColor3 = settings.textColor,
                    TextSize = settings.textSize,
                    Font = settings.font,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = dropdownButton
                })
                
                local dropdownIcon = CreateInstance("ImageLabel", {
                    Size = UDim2.new(0, 20, 0, 20),
                    Position = UDim2.new(1, -25, 0.5, -10),
                    BackgroundTransparency = 1,
                    Image = "rbxassetid://3926305904",
                    ImageRectOffset = Vector2.new(964, 324),
                    ImageRectSize = Vector2.new(36, 36),
                    Parent = dropdownButton
                })
                
                local dropdownContainer = CreateInstance("Frame", {
                    Size = UDim2.new(1, 0, 0, #options * 30),
                    Position = UDim2.new(0, 0, 0, 36),
                    BackgroundColor3 = settings.dropdownBackground,
                    Visible = false,
                    Parent = dropdownFrame
                })
                
                AddCorners(dropdownContainer)
                
                -- Create dropdown options
                for i, option in ipairs(options) do
                    local optionButton = CreateInstance("TextButton", {
                        Size = UDim2.new(1, 0, 0, 30),
                        Position = UDim2.new(0, 0, 0, (i-1) * 30),
                        BackgroundTransparency = 1,
                        Text = option,
                        TextColor3 = settings.textColor,
                        TextSize = settings.textSize,
                        Font = settings.font,
                        -- Tiếp tục từ phần dropdown option buttons
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Parent = dropdownContainer
                    })
                    
                    AddPadding(optionButton)
                    
                    -- Hover effect
                    optionButton.MouseEnter:Connect(function()
                        CreateTween(optionButton, {
                            BackgroundTransparency = 0.9
                        }, 0.2)
                    end)
                    
                    optionButton.MouseLeave:Connect(function()
                        CreateTween(optionButton, {
                            BackgroundTransparency = 1
                        }, 0.2)
                    end)
                    
                    -- Option selection
                    optionButton.MouseButton1Click:Connect(function()
                        selected = option
                        selectedText.Text = option
                        callback(option)
                        
                        -- Close dropdown
                        isOpen = false
                        CreateTween(dropdownFrame, {
                            Size = UDim2.new(1, 0, 0, 36)
                        }, 0.2)
                        CreateTween(dropdownIcon, {
                            Rotation = 0
                        }, 0.2)
                        delay(0.2, function()
                            dropdownContainer.Visible = false
                        end)
                    end)
                end
                
                -- Toggle dropdown
                dropdownButton.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    
                    if isOpen then
                        dropdownContainer.Visible = true
                        CreateTween(dropdownFrame, {
                            Size = UDim2.new(1, 0, 0, 36 + dropdownContainer.Size.Y.Offset)
                        }, 0.2)
                        CreateTween(dropdownIcon, {
                            Rotation = 180
                        }, 0.2)
                    else
                        CreateTween(dropdownFrame, {
                            Size = UDim2.new(1, 0, 0, 36)
                        }, 0.2)
                        CreateTween(dropdownIcon, {
                            Rotation = 0
                        }, 0.2)
                        delay(0.2, function()
                            dropdownContainer.Visible = false
                        end)
                    end
                    
                    UpdateCanvasSize()
                end)
                
                UpdateCanvasSize()
                
                -- Return dropdown with methods
                local dropdownObject = {}
                
                function dropdownObject:Select(option)
                    for i, opt in ipairs(options) do
                        if opt == option then
                            selected = option
                            selectedText.Text = option
                            callback(option)
                            return
                        end
                    end
                end
                
                function dropdownObject:GetSelected()
                    return selected
                end
                
                function dropdownObject:AddOption(option)
                    if table.find(options, option) then return end
                    
                    table.insert(options, option)
                    
                    local optionButton = CreateInstance("TextButton", {
                        Size = UDim2.new(1, 0, 0, 30),
                        Position = UDim2.new(0, 0, 0, (#options-1) * 30),
                        BackgroundTransparency = 1,
                        Text = option,
                        TextColor3 = settings.textColor,
                        TextSize = settings.textSize,
                        Font = settings.font,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Parent = dropdownContainer
                    })
                    
                    AddPadding(optionButton)
                    
                    -- Hover effect
                    optionButton.MouseEnter:Connect(function()
                        CreateTween(optionButton, {
                            BackgroundTransparency = 0.9
                        }, 0.2)
                    end)
                    
                    optionButton.MouseLeave:Connect(function()
                        CreateTween(optionButton, {
                            BackgroundTransparency = 1
                        }, 0.2)
                    end)
                    
                    -- Option selection
                    optionButton.MouseButton1Click:Connect(function()
                        selected = option
                        selectedText.Text = option
                        callback(option)
                        
                        -- Close dropdown
                        isOpen = false
                        CreateTween(dropdownFrame, {
                            Size = UDim2.new(1, 0, 0, 36)
                        }, 0.2)
                        CreateTween(dropdownIcon, {
                            Rotation = 0
                        }, 0.2)
                        delay(0.2, function()
                            dropdownContainer.Visible = false
                        end)
                    end)
                    
                    -- Update container size
                    dropdownContainer.Size = UDim2.new(1, 0, 0, #options * 30)
                    UpdateCanvasSize()
                end
                
                function dropdownObject:RemoveOption(option)
                    local index = table.find(options, option)
                    if not index then return end
                    
                    table.remove(options, index)
                    
                    -- Remove all option buttons and recreate them
                    for _, child in pairs(dropdownContainer:GetChildren()) do
                        if child:IsA("TextButton") then
                            child:Destroy()
                        end
                    end
                    
                    for i, opt in ipairs(options) do
                        local optionButton = CreateInstance("TextButton", {
                            Size = UDim2.new(1, 0, 0, 30),
                            Position = UDim2.new(0, 0, 0, (i-1) * 30),
                            BackgroundTransparency = 1,
                            Text = opt,
                            TextColor3 = settings.textColor,
                            TextSize = settings.textSize,
                            Font = settings.font,
                            TextXAlignment = Enum.TextXAlignment.Left,
                            Parent = dropdownContainer
                        })
                        
                        AddPadding(optionButton)
                        
                        -- Hover effect
                        optionButton.MouseEnter:Connect(function()
                            CreateTween(optionButton, {
                                BackgroundTransparency = 0.9
                            }, 0.2)
                        end)
                        
                        optionButton.MouseLeave:Connect(function()
                            CreateTween(optionButton, {
                                BackgroundTransparency = 1
                            }, 0.2)
                        end)
                        
                        -- Option selection
                        optionButton.MouseButton1Click:Connect(function()
                            selected = opt
                            selectedText.Text = opt
                            callback(opt)
                            
                            -- Close dropdown
                            isOpen = false
                            CreateTween(dropdownFrame, {
                                Size = UDim2.new(1, 0, 0, 36)
                            }, 0.2)
                            CreateTween(dropdownIcon, {
                                Rotation = 0
                            }, 0.2)
                            delay(0.2, function()
                                dropdownContainer.Visible = false
                            end)
                        end)
                    end
                    
                    -- Update container size
                    dropdownContainer.Size = UDim2.new(1, 0, 0, #options * 30)
                    
                    -- If selected option was removed, select the first one
                    if option == selected and #options > 0 then
                        selected = options[1]
                        selectedText.Text = selected
                        callback(selected)
                    elseif #options == 0 then
                        selected = ""
                        selectedText.Text = ""
                    end
                    
                    UpdateCanvasSize()
                end
                
                return dropdownObject
            end
            
            -- Bind Key Element
            function section:CreateKeybind(text, defaultKey, callback)
                defaultKey = defaultKey or Enum.KeyCode.Unknown
                callback = callback or function() end
                
                local bindFrame = CreateInstance("Frame", {
                    Size = UDim2.new(1, 0, 0, 36),
                    BackgroundTransparency = 1,
                    Parent = sectionContent
                })
                
                local bindLabel = CreateInstance("TextLabel", {
                    Size = UDim2.new(1, -80, 1, 0),
                    Position = UDim2.new(0, 0, 0, 0),
                    BackgroundTransparency = 1,
                    Text = text,
                    TextColor3 = settings.textColor,
                    TextSize = settings.textSize,
                    Font = settings.font,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = bindFrame
                })
                
                local bindButton = CreateInstance("TextButton", {
                    Size = UDim2.new(0, 70, 0, 30),
                    Position = UDim2.new(1, -75, 0.5, -15),
                    BackgroundColor3 = settings.buttonColor,
                    Text = defaultKey.Name,
                    TextColor3 = settings.textColor,
                    TextSize = settings.textSize,
                    Font = settings.font,
                    Parent = bindFrame
                })
                
                AddCorners(bindButton)
                
                local binding = false
                local key = defaultKey
                
                bindButton.MouseButton1Click:Connect(function()
                    binding = true
                    bindButton.Text = "..."
                    
                    -- Create visual effect
                    CreateTween(bindButton, {
                        BackgroundColor3 = settings.accentColor
                    }, 0.2)
                end)
                
                UserInputService.InputBegan:Connect(function(input, gameProcessed)
                    if gameProcessed then return end
                    
                    -- If waiting for binding
                    if binding then
                        if input.UserInputType == Enum.UserInputType.Keyboard then
                            key = input.KeyCode
                            bindButton.Text = input.KeyCode.Name
                            binding = false
                            
                            -- Remove visual effect
                            CreateTween(bindButton, {
                                BackgroundColor3 = settings.buttonColor
                            }, 0.2)
                        end
                    -- Otherwise check for bound key press
                    elseif input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == key then
                        callback(key)
                    end
                end)
                
                UpdateCanvasSize()
                
                -- Return keybind with methods
                local keybindObject = {}
                
                function keybindObject:SetKey(newKey)
                    key = newKey
                    bindButton.Text = newKey.Name
                end
                
                function keybindObject:GetKey()
                    return key
                end
                
                return keybindObject
            end
            
            -- TextBox Element
            function section:CreateTextbox(text, placeholder, callback)
                placeholder = placeholder or ""
                callback = callback or function() end
                
                local textboxFrame = CreateInstance("Frame", {
                    Size = UDim2.new(1, 0, 0, 36),
                    BackgroundTransparency = 1,
                    Parent = sectionContent
                })
                
                local textboxLabel = CreateInstance("TextLabel", {
                    Size = UDim2.new(0.5, -5, 1, 0),
                    Position = UDim2.new(0, 0, 0, 0),
                    BackgroundTransparency = 1,
                    Text = text,
                    TextColor3 = settings.textColor,
                    TextSize = settings.textSize,
                    Font = settings.font,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = textboxFrame
                })
                
                local textbox = CreateInstance("TextBox", {
                    Size = UDim2.new(0.5, 0, 1, -6),
                    Position = UDim2.new(0.5, 0, 0, 3),
                    BackgroundColor3 = settings.buttonColor,
                    Text = "",
                    PlaceholderText = placeholder,
                    TextColor3 = settings.textColor,
                    PlaceholderColor3 = Color3.fromRGB(150, 150, 150),
                    TextSize = settings.textSize,
                    Font = settings.font,
                    Parent = textboxFrame
                })
                
                AddCorners(textbox)
                AddPadding(textbox)
                
                -- Textbox focused visual effect
                textbox.Focused:Connect(function()
                    CreateTween(textbox, {
                        BackgroundColor3 = settings.buttonHoverColor
                    }, 0.2)
                end)
                
                textbox.FocusLost:Connect(function(enterPressed)
                    CreateTween(textbox, {
                        BackgroundColor3 = settings.buttonColor
                    }, 0.2)
                    
                    if enterPressed then
                        callback(textbox.Text)
                    end
                end)
                
                UpdateCanvasSize()
                
                -- Return textbox with methods
                local textboxObject = {}
                
                function textboxObject:SetText(newText)
                    textbox.Text = newText
                end
                
                function textboxObject:GetText()
                    return textbox.Text
                end
                
                return textboxObject
            end
            
            -- Color Picker Element
            function section:CreateColorPicker(text, defaultColor, callback)
                defaultColor = defaultColor or Color3.fromRGB(255, 255, 255)
                callback = callback or function() end
                
                local colorPickerFrame = CreateInstance("Frame", {
                    Size = UDim2.new(1, 0, 0, 36),
                    BackgroundTransparency = 1,
                    Parent = sectionContent
                })
                
                local colorPickerLabel = CreateInstance("TextLabel", {
                    Size = UDim2.new(1, -40, 1, 0),
                    Position = UDim2.new(0, 0, 0, 0),
                    BackgroundTransparency = 1,
                    Text = text,
                    TextColor3 = settings.textColor,
                    TextSize = settings.textSize,
                    Font = settings.font,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = colorPickerFrame
                })
                
                local colorDisplay = CreateInstance("Frame", {
                    Size = UDim2.new(0, 30, 0, 30),
                    Position = UDim2.new(1, -35, 0.5, -15),
                    BackgroundColor3 = defaultColor,
                    Parent = colorPickerFrame
                })
                
                AddCorners(colorDisplay)
                
                local colorPickerButton = CreateInstance("TextButton", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = "",
                    Parent = colorPickerFrame
                })
                
                -- Implement a simple color selector
                local colorPickerExpanded = false
                local colorPicker = CreateInstance("Frame", {
                    Size = UDim2.new(1, 0, 0, 120),
                    Position = UDim2.new(0, 0, 0, 36),
                    BackgroundColor3 = settings.secondaryColor,
                    Visible = false,
                    Parent = colorPickerFrame
                })
                
                AddCorners(colorPicker)
                
                -- Create RGB sliders
                local function CreateColorSlider(name, color, defaultValue, yPos)
                    local sliderFrame = CreateInstance("Frame", {
                        Name = name.."Slider",
                        Size = UDim2.new(1, -20, 0, 20),
                        Position = UDim2.new(0, 10, 0, yPos),
                        BackgroundTransparency = 1,
                        Parent = colorPicker
                    })
                    
                    local sliderLabel = CreateInstance("TextLabel", {
                        Size = UDim2.new(0, 20, 1, 0),
                        BackgroundTransparency = 1,
                        Text = name,
                        TextColor3 = settings.textColor,
                        TextSize = settings.textSize - 2,
                        Font = settings.font,
                        Parent = sliderFrame
                    })
                    
                    local sliderBackground = CreateInstance("Frame", {
                        Size = UDim2.new(1, -30, 0, 6),
                        Position = UDim2.new(0, 25, 0.5, -3),
                        BackgroundColor3 = settings.sliderBackground,
                        Parent = sliderFrame
                    })
                    
                    AddCorners(sliderBackground, UDim.new(1, 0))
                    
                    local sliderFill = CreateInstance("Frame", {
                        Size = UDim2.new(defaultValue/255, 0, 1, 0),
                        BackgroundColor3 = color,
                        Parent = sliderBackground
                    })
                    
                    AddCorners(sliderFill, UDim.new(1, 0))
                    
                    local sliderValue = CreateInstance("TextLabel", {
                        Size = UDim2.new(0, 30, 1, 0),
                        Position = UDim2.new(1, -25, 0, 0),
                        BackgroundTransparency = 1,
                        Text = tostring(defaultValue),
                        TextColor3 = settings.textColor,
                        TextSize = settings.textSize - 2,
                        Font = settings.font,
                        Parent = sliderFrame
                    })
                    
                    local sliderButton = CreateInstance("TextButton", {
                        Size = UDim2.new(1, 0, 1, 0),
                        BackgroundTransparency = 1,
                        Text = "",
                        Parent = sliderBackground
                    })
                    
                    local dragging = false
                    
                    sliderButton.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            dragging = true
                        end
                    end)
                    
                    sliderButton.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            dragging = false
                        end
                    end)
                    
                    UserInputService.InputChanged:Connect(function(input)
                        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                            local percent = math.clamp((input.Position.X - sliderBackground.AbsolutePosition.X) / sliderBackground.AbsoluteSize.X, 0, 1)
                            local value = math.floor(percent * 255)
                            
                            sliderFill.Size = UDim2.new(percent, 0, 1, 0)
                            sliderValue.Text = tostring(value)
                            
                            -- Update color display
                            local r = tonumber(colorPicker.RSlider.TextLabel.Text)
                            local g = tonumber(colorPicker.GSlider.TextLabel.Text)
                            local b = tonumber(colorPicker.BSlider.TextLabel.Text)
                            
                            local newColor = Color3.fromRGB(r, g, b)
                            colorDisplay.BackgroundColor3 = newColor
                            callback(newColor)
                        end
                    end)
                    
                    return sliderFrame
                end
                
                local r = math.floor(defaultColor.R * 255)
                local g = math.floor(defaultColor.G * 255)
                local b = math.floor(defaultColor.B * 255)
                
                local rSlider = CreateColorSlider("R", Color3.fromRGB(255, 0, 0), r, 10)
                rSlider.Name = "RSlider"
                
                local gSlider = CreateColorSlider("G", Color3.fromRGB(0, 255, 0), g, 40)
                gSlider.Name = "GSlider"
                
                local bSlider = CreateColorSlider("B", Color3.fromRGB(0, 0, 255), b, 70)
                bSlider.Name = "BSlider"
                
                -- Button to toggle color picker
                colorPickerButton.MouseButton1Click:Connect(function()
                    colorPickerExpanded = not colorPickerExpanded
                    colorPicker.Visible = colorPickerExpanded
                    UpdateCanvasSize()
                end)
                
                UpdateCanvasSize()
                
                -- Return color picker with methods
                local colorPickerObject = {}
                
                function colorPickerObject:SetColor(color)
                    colorDisplay.BackgroundColor3 = color
                    
                    local r = math.floor(color.R * 255)
                    local g = math.floor(color.G * 255)
                    local b = math.floor(color.B * 255)
                    
                    -- Update sliders
                    colorPicker.RSlider.TextLabel.Text = tostring(r)
                    colorPicker.GSlider.TextLabel.Text = tostring(g)
                    colorPicker.BSlider.TextLabel.Text = tostring(b)
                    
                    colorPicker.RSlider.Frame.Frame.Size = UDim2.new(r/255, 0, 1, 0)
                    colorPicker.GSlider.Frame.Frame.Size = UDim2.new(g/255, 0, 1, 0)
                    colorPicker.BSlider.Frame.Frame.Size = UDim2.new(b/255, 0, 1, 0)
                    
                    callback(color)
                end
                
                function colorPickerObject:GetColor()
                    return colorDisplay.BackgroundColor3
                end
                
                return colorPickerObject
            end
            
            return section
        end
        
        return tab
    end
    
    return window
end

-- Cài đặt thư viện
function Library:SetSettings(newSettings)
    for key, value in pairs(newSettings) do
        settings[key] = value
    end
end

-- Ví dụ sử dụng
function Library:Example()
    local window = Library:CreateWindow("Roblox UI Library")
    
    local mainTab = window:CreateTab("Example Tab 1")
    local settingsTab = window:CreateTab("Example Tab 2")
    
    local mainSection = mainTab:CreateSection("Random Elements")
    mainSection:CreateLabel("Test us!")
    
    local button = mainSection:CreateButton("foo", function()
        print("Button clicked!")
    end)
    
    local toggle = mainSection:CreateToggle("random toggle", function(state)
        print("Toggle state:", state)
    end)
    
    local button2 = mainSection:CreateButton("fooo", function()
        print("Button 2 clicked!")
    end)
    
    local dropdown = mainSection:CreateDropdown("Dropdown Example", {"Option 1", "Option 2", "Option 3"}, function(selected)
        print("Selected:", selected)
    end)
    
    local slider = mainSection:CreateSlider("Slider Example", {min = 0, max = 100, default = 50}, function(value)
        print("Slider value:", value)
    end)
    
    local controlSection = mainTab:CreateSection("Control Panel")
    controlSection:CreateLabel("Control other elements!")
    
    controlSection:CreateButton("Delete 'foo'", function()
        button.Visible = false
    end)
    
    local settingsSection = settingsTab:CreateSection("Settings")
    
    local keybind = settingsSection:CreateKeybind("Toggle UI", Enum.KeyCode.RightControl, function()
        print("Keybind pressed!")
    end)
    
    local colorPicker = settingsSection:CreateColorPicker("UI Color", settings.accentColor, function(color)
        settings.accentColor = color
        print("New color:", color)
    end)
    
    local textbox = settingsSection:CreateTextbox("Username", "Enter your name", function(text)
        print("Entered text:", text)
    end)
end

return Library
