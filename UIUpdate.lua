local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Cấu hình mặc định
local settings = {
    mainColor = Color3.fromRGB(25, 25, 25),
    accentColor = Color3.fromRGB(157, 78, 221), -- Màu tím đậm đẹp hơn
    secondaryColor = Color3.fromRGB(35, 35, 35),
    tertiaryColor = Color3.fromRGB(45, 45, 45),
    textColor = Color3.fromRGB(255, 255, 255),
    subTextColor = Color3.fromRGB(180, 180, 180),
    font = Enum.Font.GothamSemibold, -- Font hiện đại hơn
    titleFont = Enum.Font.GothamBold, -- Font cho tiêu đề
    textSize = 14,
    titleSize = 16,
    toggleOn = Color3.fromRGB(157, 78, 221),
    toggleOff = Color3.fromRGB(60, 60, 60),
    sliderColor = Color3.fromRGB(157, 78, 221),
    sliderBackground = Color3.fromRGB(40, 40, 40),
    dropdownBackground = Color3.fromRGB(40, 40, 40),
    buttonColor = Color3.fromRGB(40, 40, 40),
    buttonHoverColor = Color3.fromRGB(50, 50, 50),
    buttonPressedColor = Color3.fromRGB(35, 35, 35),
    windowCornerRadius = UDim.new(0, 6),
    elementCornerRadius = UDim.new(0, 4),
    shadow = true,
    configFolder = "UI_Configs"
}

-- Utility Functions
local function CreateTween(instance, properties, duration, easingStyle, easingDirection, delay, callback)
    delay = delay or 0
    local tween = TweenService:Create(
        instance,
        TweenInfo.new(duration or 0.3, easingStyle or Enum.EasingStyle.Quart, easingDirection or Enum.EasingDirection.Out, 0, false, delay),
        properties
    )
    
    if callback then
        tween.Completed:Connect(callback)
    end
    
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

local function AddShadow(instance, size, transparency)
    local shadow = CreateInstance("ImageLabel", {
        Name = "Shadow",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(1, size or 20, 1, size or 20),
        ZIndex = -1,
        Image = "rbxassetid://5554236805",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = transparency or 0.6,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(23, 23, 277, 277),
        Parent = instance
    })
    return shadow
end

local function AddRippleEffect(button, rippleColor)
    button.ClipsDescendants = true
    rippleColor = rippleColor or Color3.fromRGB(255, 255, 255)
    
    local function CreateRipple(x, y)
        local ripple = CreateInstance("Frame", {
            Name = "Ripple",
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = rippleColor,
            BackgroundTransparency = 0.8,
            Position = UDim2.new(0, x, 0, y),
            Size = UDim2.new(0, 0, 0, 0),
            ZIndex = button.ZIndex + 1,
            Parent = button
        })
        
        AddCorners(ripple, UDim.new(1, 0))
        
        local maxSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2
        
        CreateTween(ripple, {
            Size = UDim2.new(0, maxSize, 0, maxSize),
            BackgroundTransparency = 1
        }, 0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, 0, function()
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

local function CreateStroke(instance, color, thickness, transparency)
    local stroke = CreateInstance("UIStroke", {
        Color = color or Color3.fromRGB(80, 80, 80),
        Thickness = thickness or 1,
        Transparency = transparency or 0,
        Parent = instance
    })
    return stroke
end

local function AddGlow(instance, color, size, transparency)
    local glow = CreateInstance("ImageLabel", {
        Name = "Glow",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(1, size or 30, 1, size or 30),
        ZIndex = -1,
        Image = "rbxassetid://5028857084",
        ImageColor3 = color or settings.accentColor,
        ImageTransparency = transparency or 0.7,
        Parent = instance
    })
    return glow
end

local function CreateGradient(instance, colorSequence, rotation)
    local gradient = CreateInstance("UIGradient", {
        Color = colorSequence or ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 200))
        },
        Rotation = rotation or 0,
        Parent = instance
    })
    return gradient
end

-- Config System
local ConfigSystem = {}

function ConfigSystem:SaveConfig(name, data)
    local success, errorMessage = pcall(function()
        if not isfolder(settings.configFolder) then
            makefolder(settings.configFolder)
        end
        
        writefile(settings.configFolder .. "/" .. name .. ".json", HttpService:JSONEncode(data))
    end)
    
    return success, errorMessage
end

function ConfigSystem:LoadConfig(name)
    local success, result = pcall(function()
        if isfile(settings.configFolder .. "/" .. name .. ".json") then
            return HttpService:JSONDecode(readfile(settings.configFolder .. "/" .. name .. ".json"))
        end
        return nil
    end)
    
    if success then
        return result
    else
        return nil
    end
end

function ConfigSystem:GetConfigList()
    local configList = {}
    
    local success, files = pcall(function()
        if isfolder(settings.configFolder) then
            return listfiles(settings.configFolder)
        end
        return {}
    end)
    
    if success then
        for _, file in ipairs(files) do
            local fileName = file:match("([^/\\]+)%.json$")
            if fileName then
                table.insert(configList, fileName)
            end
        end
    end
    
    return configList
end

function ConfigSystem:DeleteConfig(name)
    local success = pcall(function()
        if isfile(settings.configFolder .. "/" .. name .. ".json") then
            delfile(settings.configFolder .. "/" .. name .. ".json")
        end
    end)
    
    return success
end

-- Animation Functions
local function PlayEnterAnimation(instance, direction)
    direction = direction or "Right"
    
    local originalPosition = instance.Position
    local originalSize = instance.Size
    local originalTransparency = instance.BackgroundTransparency
    
    if direction == "Right" then
        instance.Position = originalPosition + UDim2.new(0.05, 0, 0, 0)
    elseif direction == "Left" then
        instance.Position = originalPosition - UDim2.new(0.05, 0, 0, 0)
    elseif direction == "Up" then
        instance.Position = originalPosition + UDim2.new(0, 0, 0.05, 0)
    elseif direction == "Down" then
        instance.Position = originalPosition - UDim2.new(0, 0, 0.05, 0)
    elseif direction == "Fade" then
        instance.BackgroundTransparency = 1
        
        -- Also fade all children
        for _, child in pairs(instance:GetChildren()) do
            if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
                child.TextTransparency = 1
            elseif child:IsA("ImageLabel") or child:IsA("ImageButton") then
                child.ImageTransparency = 1
            elseif child:IsA("Frame") or child:IsA("ScrollingFrame") then
                child.BackgroundTransparency = 1
            end
        end
    elseif direction == "Scale" then
        instance.Size = UDim2.new(0, 0, 0, 0)
        instance.AnchorPoint = Vector2.new(0.5, 0.5)
        instance.Position = UDim2.new(0.5, 0, 0.5, 0)
    end
    
    -- Animation
    if direction == "Fade" then
        CreateTween(instance, {
            BackgroundTransparency = originalTransparency
        }, 0.3)
        
        for _, child in pairs(instance:GetChildren()) do
            if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
                CreateTween(child, {
                    TextTransparency = 0
                }, 0.3)
            elseif child:IsA("ImageLabel") or child:IsA("ImageButton") then
                CreateTween(child, {
                    ImageTransparency = 0
                }, 0.3)
            elseif child:IsA("Frame") or child:IsA("ScrollingFrame") then
                CreateTween(child, {
                    BackgroundTransparency = 0
                }, 0.3)
            end
        end
    elseif direction == "Scale" then
        CreateTween(instance, {
            Size = originalSize
        }, 0.3, Enum.EasingStyle.Back)
    else
        CreateTween(instance, {
            Position = originalPosition
        }, 0.3, Enum.EasingStyle.Back)
    end
end

-- Window Creation
function Library:CreateWindow(title, size)
    local window = {}
    local dragToggle, dragInput, dragStart, startPos
    local configData = {}
    
    -- MainFrame
    local screenGui = CreateInstance("ScreenGui", {
        Name = "EnhancedUILibrary",
        Parent = game.CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false
    })
    
    local mainFrame = CreateInstance("Frame", {
        Name = "MainFrame",
        Size = size or UDim2.new(0, 550, 0, 400),
        Position = UDim2.new(0.5, -275, 0.5, -200),
        BackgroundColor3 = settings.mainColor,
        BorderSizePixel = 0,
        Parent = screenGui
    })
    
    AddCorners(mainFrame, settings.windowCornerRadius)
    
    if settings.shadow then
        AddShadow(mainFrame, 30)
    end
    
    -- TitleBar
    local titleBar = CreateInstance("Frame", {
        Name = "TitleBar",
        Size = UDim2.new(1, 0, 0, 40),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = settings.secondaryColor,
        BorderSizePixel = 0,
        Parent = mainFrame
    })
    
    local titleCorners = AddCorners(titleBar, UDim.new(0, 6))
    
    local titleCornerFix = CreateInstance("Frame", {
        Name = "CornerFix",
        Size = UDim2.new(1, 0, 0.5, 0),
        Position = UDim2.new(0, 0, 0.5, 0),
        BackgroundColor3 = settings.secondaryColor,
        BorderSizePixel = 0,
        ZIndex = titleBar.ZIndex,
        Parent = titleBar
    })
    
    local titleLabel = CreateInstance("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -120, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        TextColor3 = settings.textColor,
        TextSize = settings.titleSize,
        Font = settings.titleFont,
        Text = title or "Enhanced UI Library",
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = titleBar
    })
    
    -- Add a nice accent indicator
    local titleAccent = CreateInstance("Frame", {
        Name = "TitleAccent",
        Size = UDim2.new(0, 3, 0, 20),
        Position = UDim2.new(0, 8, 0.5, -10),
        BackgroundColor3 = settings.accentColor,
        BorderSizePixel = 0,
        Parent = titleBar
    })
    
    AddCorners(titleAccent, UDim.new(1, 0))
    AddGlow(titleAccent, settings.accentColor, 10, 0.7)
    
    local closeButton = CreateInstance("TextButton", {
        Name = "CloseButton",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -35, 0, 5),
        BackgroundColor3 = Color3.fromRGB(255, 70, 70),
        Text = "",
        TextColor3 = settings.textColor,
        TextSize = settings.textSize,
        Font = settings.font,
        Parent = titleBar
    })
    
    local closeIcon = CreateInstance("ImageLabel", {
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(0.5, -8, 0.5, -8),
        BackgroundTransparency = 1,
        Image = "rbxassetid://7743878857",
        ImageColor3 = Color3.fromRGB(255, 255, 255),
        Parent = closeButton
    })
    
    AddCorners(closeButton, UDim.new(0, 6))
    AddRippleEffect(closeButton, Color3.fromRGB(255, 100, 100))
    
    local minimizeButton = CreateInstance("TextButton", {
        Name = "MinimizeButton",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -70, 0, 5),
        BackgroundColor3 = Color3.fromRGB(60, 60, 60),
        Text = "",
        TextColor3 = settings.textColor,
        TextSize = settings.textSize,
        Font = settings.font,
        Parent = titleBar
    })
    
    local minimizeIcon = CreateInstance("ImageLabel", {
        Size = UDim2.new(0, 16, 0, 2),
        Position = UDim2.new(0.5, -8, 0.5, -1),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        Image = "",
        Parent = minimizeButton
    })
    
    AddCorners(minimizeButton, UDim.new(0, 6))
    AddCorners(minimizeIcon, UDim.new(1, 0))
    AddRippleEffect(minimizeButton)
    
    -- Tab Container
    local tabContainer = CreateInstance("Frame", {
        Name = "TabContainer",
        Size = UDim2.new(0, 140, 1, -40),
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
    
    local tabScrollFrame = CreateInstance("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Parent = tabContainer
    })
    
    local tabList = CreateInstance("UIListLayout", {
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = tabScrollFrame
    })
    
    AddPadding(tabScrollFrame, 10)
    
    tabList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabScrollFrame.CanvasSize = UDim2.new(0, 0, 0, tabList.AbsoluteContentSize.Y + 20)
    end)
    
    -- Content Frame
    local contentFrame = CreateInstance("Frame", {
        Name = "ContentFrame",
        Size = UDim2.new(1, -140, 1, -40),
        Position = UDim2.new(0, 140, 0, 40),
        BackgroundColor3 = settings.mainColor,
        BorderSizePixel = 0,
        ClipsDescendants = true,
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
        CreateTween(mainFrame, {
            Size = UDim2.new(0, mainFrame.Size.X.Offset, 0, 0),
            Position = UDim2.new(mainFrame.Position.X.Scale, mainFrame.Position.X.Offset, mainFrame.Position.Y.Scale, mainFrame.Position.Y.Offset + mainFrame.Size.Y.Offset/2)
        }, 0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In, 0, function()
            screenGui:Destroy()
        end)
    end)
    
    local minimized = false
    minimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            CreateTween(mainFrame, {
                Size = UDim2.new(0, mainFrame.Size.X.Offset, 0, 40)
            }, 0.4, Enum.EasingStyle.Quart)
            tabContainer.Visible = false
            contentFrame.Visible = false
        else
            CreateTween(mainFrame, {
                Size = size or UDim2.new(0, 550, 0, 400)
            }, 0.4, Enum.EasingStyle.Quart)
            tabContainer.Visible = true
            contentFrame.Visible = true
        end
    end)
    
    -- Tab Functions
    local tabs = {}
    local activeTab = nil
    
    function window:CreateTab(tabName, icon)
        local tab = {}
        local tabIcon = icon or "rbxassetid://7733765398" -- Default is a gear icon
        
        -- Tab Button
        local tabButtonFrame = CreateInstance("Frame", {
            Name = tabName,
            Size = UDim2.new(1, -20, 0, 36),
            BackgroundColor3 = settings.buttonColor,
            BackgroundTransparency = 1,
            Parent = tabScrollFrame
        })
        
        local tabButton = CreateInstance("TextButton", {
            Name = "Button",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundColor3 = settings.buttonColor,
            Text = "",
            Parent = tabButtonFrame
        })
        
        AddCorners(tabButton)
        AddRippleEffect(tabButton)
        
        local iconImage = CreateInstance("ImageLabel", {
            Name = "Icon",
            Size = UDim2.new(0, 20, 0, 20),
            Position = UDim2.new(0, 8, 0.5, -10),
            BackgroundTransparency = 1,
            Image = tabIcon,
            ImageColor3 = settings.textColor,
            Parent = tabButton
        })
        
        local tabText = CreateInstance("TextLabel", {
            Name = "Text",
            Size = UDim2.new(1, -40, 1, 0),
            Position = UDim2.new(0, 36, 0, 0),
            BackgroundTransparency = 1,
            Text = tabName,
            TextColor3 = settings.textColor,
            TextSize = settings.textSize,
            Font = settings.font,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = tabButton
        })
        
        local activeIndicator = CreateInstance("Frame", {
            Name = "ActiveIndicator",
            Size = UDim2.new(0, 3, 0, 0),
            Position = UDim2.new(0, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundColor3 = settings.accentColor,
            Visible = false,
            Parent = tabButton
        })
        
        AddCorners(activeIndicator, UDim.new(0, 2))
        
        -- Tab Content
        local tabContent = CreateInstance("ScrollingFrame", {
            Name = tabName.."Content",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            BorderSizePixel = 0,
            Visible = false,
            Parent = contentFrame
        })
        
        local elementsLayout = CreateInstance("UIListLayout", {
            Padding = UDim.new(0, 12),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = tabContent
        })
        
        AddPadding(tabContent, 15)
        
        elementsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabContent.CanvasSize = UDim2.new(0, 0, 0, elementsLayout.AbsoluteContentSize.Y + 30)
        end)
        
        -- Tab Selection Logic
        tabButton.MouseButton1Click:Connect(function()
            if activeTab == tabName then return end
            
            if activeTab then
                -- Deactivate the previous tab
                local prevTabButton = tabs[activeTab].Button
                local prevTabContent = tabs[activeTab].Content
                local prevIndicator = prevTabButton:FindFirstChild("ActiveIndicator")
                
                CreateTween(prevTabButton, {
                    BackgroundColor3 = settings.buttonColor
                }, 0.3)
                
                CreateTween(prevTabButton.Icon, {
                    ImageColor3 = settings.textColor
                }, 0.3)
                
                if prevIndicator then
                    CreateTween(prevIndicator, {
                        Size = UDim2.new(0, 3, 0, 0)
                    }, 0.3)
                end
                
                prevTabContent.Visible = false
            end
            
            -- Activate this tab
            CreateTween(tabButton, {
                BackgroundColor3 = settings.accentColor
            }, 0.3)
            
            CreateTween(iconImage, {
                ImageColor3 = Color3.fromRGB(255, 255, 255)
            }, 0.3)
            
            activeIndicator.Visible = true
            CreateTween(activeIndicator, {
                Size = UDim2.new(0, 3, 0.7, 0)
            }, 0.3)
            
            tabContent.Visible = true
            activeTab = tabName
            
            -- Play enter animation for content
            tabContent.ClipsDescendants = true
            for _, child in pairs(tabContent:GetChildren()) do
                if child:IsA("Frame") then
                    PlayEnterAnimation(child, "Right")
                end
            end
        end)
        
        tab.Content = tabContent
        tab.Button = tabButton
        tabs[tabName] = tab
        
        -- If this is the first tab, activate it
        if not activeTab then
            CreateTween(tabButton, {
                BackgroundColor3 = settings.accentColor
            }, 0.3)
            
            CreateTween(iconImage, {
                ImageColor3 = Color3.fromRGB(255, 255, 255)
            }, 0.3)
            
            activeIndicator.Visible = true
            CreateTween(activeIndicator, {
                Size = UDim2.new(0, 3, 0.7, 0)
            }, 0.3)
            
            tabContent.Visible = true
            activeTab = tabName
            
            -- Play enter animation for first tab
            for _, child in pairs(tabContent:GetChildren()) do
                if child:IsA("Frame") then
                    PlayEnterAnimation(child, "Right")
                end
            end
        end
        
        -- Section Function
        function tab:CreateSection(sectionName)
            local section = {}
            
            local sectionFrame = CreateInstance("Frame", {
                Name = sectionName.."Section",
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = settings.secondaryColor,
                ClipsDescendants = true,
                Parent = tabContent
            })
            
            AddCorners(sectionFrame)
            if settings.shadow then
                AddShadow(sectionFrame, 15, 0.75)
            end
            
            local sectionHeader = CreateInstance("Frame", {
                Name = "Header",
                Size = UDim2.new(1, 0, 0, 40),
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
                Font = settings.titleFont,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = sectionHeader
            })
            
            -- Add a nice accent line
            local sectionAccent = CreateInstance("Frame", {
                Name = "Accent",
                Size = UDim2.new(0, 3, 0, 20),
                Position = UDim2.new(0, 3, 0.5, -10),
                BackgroundColor3 = settings.accentColor,
                BorderSizePixel = 0,
                Parent = sectionHeader
            })
            
AddCorners(sectionAccent, UDim.new(1, 0))
            AddGlow(sectionAccent, settings.accentColor, 10, 0.7)
            
            local sectionContent = CreateInstance("Frame", {
                Name = "Content",
                Size = UDim2.new(1, 0, 0, 0),
                Position = UDim2.new(0, 0, 0, 40),
                BackgroundTransparency = 1,
                ClipsDescendants = true,
                Parent = sectionFrame
            })
            
            local contentLayout = CreateInstance("UIListLayout", {
                Padding = UDim.new(0, 10),
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = sectionContent
            })
            
            AddPadding(sectionContent, 10)
            
            -- Section expand/collapse logic
            local expanded = false
            
            local function UpdateSectionSize()
                local contentHeight = contentLayout.AbsoluteContentSize.Y + 20
                
                if expanded then
                    CreateTween(sectionFrame, {
                        Size = UDim2.new(1, 0, 0, 40 + contentHeight)
                    }, 0.3, Enum.EasingStyle.Quint)
                    
                    CreateTween(sectionContent, {
                        Size = UDim2.new(1, 0, 0, contentHeight)
                    }, 0.3, Enum.EasingStyle.Quint)
                else
                    CreateTween(sectionFrame, {
                        Size = UDim2.new(1, 0, 0, 40)
                    }, 0.3, Enum.EasingStyle.Quint)
                    
                    CreateTween(sectionContent, {
                        Size = UDim2.new(1, 0, 0, 0)
                    }, 0.3, Enum.EasingStyle.Quint)
                end
            end
            
            -- Automatically expand when created
            expanded = true
            UpdateSectionSize()
            
            contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateSectionSize)
            
            sectionHeader.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    expanded = not expanded
                    UpdateSectionSize()
                end
            end)
            
            -- UI Elements
            function section:AddLabel(text)
                local labelFrame = CreateInstance("Frame", {
                    Name = "Label",
                    Size = UDim2.new(1, 0, 0, 30),
                    BackgroundTransparency = 1,
                    Parent = sectionContent
                })
                
                local label = CreateInstance("TextLabel", {
                    Size = UDim2.new(1, -10, 1, 0),
                    Position = UDim2.new(0, 5, 0, 0),
                    BackgroundTransparency = 1,
                    Text = text,
                    TextColor3 = settings.subTextColor,
                    TextSize = settings.textSize,
                    Font = settings.font,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = labelFrame
                })
                
                local labelObject = {}
                
                function labelObject:Update(newText)
                    label.Text = newText
                end
                
                return labelObject
            end
            
            function section:AddButton(text, callback)
                callback = callback or function() end
                
                local buttonFrame = CreateInstance("Frame", {
                    Name = "Button",
                    Size = UDim2.new(1, 0, 0, 38),
                    BackgroundTransparency = 1,
                    Parent = sectionContent
                })
                
                local button = CreateInstance("TextButton", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundColor3 = settings.buttonColor,
                    Text = "",
                    Parent = buttonFrame
                })
                
                AddCorners(button)
                AddRippleEffect(button)
                
                local buttonText = CreateInstance("TextLabel", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = text,
                    TextColor3 = settings.textColor,
                    TextSize = settings.textSize,
                    Font = settings.font,
                    Parent = button
                })
                
                -- Button hover/press effects
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
                
                button.MouseButton1Down:Connect(function()
                    CreateTween(button, {
                        BackgroundColor3 = settings.buttonPressedColor
                    }, 0.1)
                end)
                
                button.MouseButton1Up:Connect(function()
                    CreateTween(button, {
                        BackgroundColor3 = settings.buttonHoverColor
                    }, 0.1)
                end)
                
                button.MouseButton1Click:Connect(function()
                    callback()
                end)
                
                local buttonObject = {}
                
                function buttonObject:Update(newText)
                    buttonText.Text = newText
                end
                
                function buttonObject:UpdateCallback(newCallback)
                    callback = newCallback
                end
                
                return buttonObject
            end
            
            function section:AddToggle(text, default, callback)
                default = default or false
                callback = callback or function() end
                
                local toggleFrame = CreateInstance("Frame", {
                    Name = "Toggle",
                    Size = UDim2.new(1, 0, 0, 36),
                    BackgroundTransparency = 1,
                    Parent = sectionContent
                })
                
                local toggleLabel = CreateInstance("TextLabel", {
                    Size = UDim2.new(1, -60, 1, 0),
                    Position = UDim2.new(0, 5, 0, 0),
                    BackgroundTransparency = 1,
                    Text = text,
                    TextColor3 = settings.textColor,
                    TextSize = settings.textSize,
                    Font = settings.font,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = toggleFrame
                })
                
                local toggleBackground = CreateInstance("Frame", {
                    Name = "Background",
                    Size = UDim2.new(0, 44, 0, 24),
                    Position = UDim2.new(1, -50, 0.5, -12),
                    BackgroundColor3 = default and settings.toggleOn or settings.toggleOff,
                    Parent = toggleFrame
                })
                
                AddCorners(toggleBackground, UDim.new(1, 0))
                
                local toggleCircle = CreateInstance("Frame", {
                    Name = "Circle",
                    Size = UDim2.new(0, 20, 0, 20),
                    Position = UDim2.new(0, default and 21 or 2, 0.5, -10),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Parent = toggleBackground
                })
                
                AddCorners(toggleCircle, UDim.new(1, 0))
                AddShadow(toggleCircle, 5, 0.8)
                
                local toggleValue = default
                
                -- Add to config data
                configData[text .. "_Toggle"] = toggleValue
                
                local function UpdateToggle()
                    toggleValue = not toggleValue
                    configData[text .. "_Toggle"] = toggleValue
                    
                    local targetPosition = toggleValue and UDim2.new(0, 21, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
                    local targetColor = toggleValue and settings.toggleOn or settings.toggleOff
                    
                    CreateTween(toggleCircle, {
                        Position = targetPosition
                    }, 0.2, Enum.EasingStyle.Quint)
                    
                    CreateTween(toggleBackground, {
                        BackgroundColor3 = targetColor
                    }, 0.2)
                    
                    callback(toggleValue)
                end
                
                toggleBackground.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        UpdateToggle()
                    end
                end)
                
                local toggleObject = {}
                
                function toggleObject:Set(value)
                    if toggleValue ~= value then
                        UpdateToggle()
                    end
                end
                
                function toggleObject:Get()
                    return toggleValue
                end
                
                return toggleObject
            end
            
            function section:AddSlider(text, min, max, default, decimal, callback)
                min = min or 0
                max = max or 100
                default = default or min
                decimal = decimal or 0
                callback = callback or function() end
                
                local sliderFrame = CreateInstance("Frame", {
                    Name = "Slider",
                    Size = UDim2.new(1, 0, 0, 60),
                    BackgroundTransparency = 1,
                    Parent = sectionContent
                })
                
                local sliderLabel = CreateInstance("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 25),
                    Position = UDim2.new(0, 5, 0, 0),
                    BackgroundTransparency = 1,
                    Text = text,
                    TextColor3 = settings.textColor,
                    TextSize = settings.textSize,
                    Font = settings.font,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = sliderFrame
                })
                
                local valueLabel = CreateInstance("TextLabel", {
                    Size = UDim2.new(0, 60, 0, 25),
                    Position = UDim2.new(1, -70, 0, 0),
                    BackgroundTransparency = 1,
                    Text = tostring(default),
                    TextColor3 = settings.subTextColor,
                    TextSize = settings.textSize,
                    Font = settings.font,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    Parent = sliderFrame
                })
                
                local sliderBackground = CreateInstance("Frame", {
                    Name = "Background",
                    Size = UDim2.new(1, 0, 0, 8),
                    Position = UDim2.new(0, 0, 0, 35),
                    BackgroundColor3 = settings.sliderBackground,
                    Parent = sliderFrame
                })
                
                AddCorners(sliderBackground, UDim.new(1, 0))
                
                local sliderFill = CreateInstance("Frame", {
                    Name = "Fill",
                    Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
                    BackgroundColor3 = settings.sliderColor,
                    Parent = sliderBackground
                })
                
                AddCorners(sliderFill, UDim.new(1, 0))
                
                local sliderCircle = CreateInstance("Frame", {
                    Name = "Circle",
                    Size = UDim2.new(0, 18, 0, 18),
                    Position = UDim2.new((default - min) / (max - min), 0, 0.5, -9),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    ZIndex = 2,
                    Parent = sliderBackground
                })
                
                AddCorners(sliderCircle, UDim.new(1, 0))
                AddShadow(sliderCircle, 5, 0.8)
                
                -- Add to config data
                configData[text .. "_Slider"] = default
                
                local sliderValue = default
                local dragging = false
                
                local function SetValue(value)
                    value = math.clamp(value, min, max)
                    
                    if decimal > 0 then
                        value = math.floor(value * (10 ^ decimal)) / (10 ^ decimal)
                    else
                        value = math.floor(value)
                    end
                    
                    sliderValue = value
                    configData[text .. "_Slider"] = value
                    
                    local percent = (value - min) / (max - min)
                    
                    valueLabel.Text = tostring(value)
                    
                    CreateTween(sliderFill, {
                        Size = UDim2.new(percent, 0, 1, 0)
                    }, 0.1)
                    
                    CreateTween(sliderCircle, {
                        Position = UDim2.new(percent, 0, 0.5, -9)
                    }, 0.1)
                    
                    callback(value)
                end
                
                -- Fix slider circle tracking with mouse
                sliderBackground.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        
                        local relativeX = math.clamp(input.Position.X - sliderBackground.AbsolutePosition.X, 0, sliderBackground.AbsoluteSize.X)
                        local percent = relativeX / sliderBackground.AbsoluteSize.X
                        local value = min + ((max - min) * percent)
                        
                        SetValue(value)
                    end
                end)
                
                sliderBackground.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local relativeX = math.clamp(input.Position.X - sliderBackground.AbsolutePosition.X, 0, sliderBackground.AbsoluteSize.X)
                        local percent = relativeX / sliderBackground.AbsoluteSize.X
                        local value = min + ((max - min) * percent)
                        
                        SetValue(value)
                    end
                end)
                
                SetValue(default)
                
                local sliderObject = {}
                
                function sliderObject:Set(value)
                    SetValue(value)
                end
                
                function sliderObject:Get()
                    return sliderValue
                end
                
                return sliderObject
            end
            
            function section:AddDropdown(text, options, default, callback)
                options = options or {}
                default = default or ""
                callback = callback or function() end
                
                local dropdownFrame = CreateInstance("Frame", {
                    Name = "Dropdown",
                    Size = UDim2.new(1, 0, 0, 40),
                    BackgroundTransparency = 1,
                    ClipsDescendants = true,
                    Parent = sectionContent
                })
                
                local dropdownLabel = CreateInstance("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 25),
                    Position = UDim2.new(0, 5, 0, 0),
                    BackgroundTransparency = 1,
                    Text = text,
                    TextColor3 = settings.textColor,
                    TextSize = settings.textSize,
                    Font = settings.font,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = dropdownFrame
                })
                
                local dropdownButton = CreateInstance("TextButton", {
                    Name = "Button",
                    Size = UDim2.new(1, 0, 0, 35),
                    Position = UDim2.new(0, 0, 0, 25),
                    BackgroundColor3 = settings.dropdownBackground,
                    Text = "",
                    Parent = dropdownFrame
                })
                
                AddCorners(dropdownButton)
                
                local selectedLabel = CreateInstance("TextLabel", {
                    Size = UDim2.new(1, -30, 1, 0),
                    Position = UDim2.new(0, 10, 0, 0),
                    BackgroundTransparency = 1,
                    Text = default,
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
                    Image = "rbxassetid://7072706663", -- Arrow icon
                    ImageColor3 = settings.textColor,
                    Parent = dropdownButton
                })
                
                local dropdownContainer = CreateInstance("Frame", {
                    Name = "Container",
                    Size = UDim2.new(1, 0, 0, 0),
                    Position = UDim2.new(0, 0, 0, 65),
                    BackgroundColor3 = settings.dropdownBackground,
                    BorderSizePixel = 0,
                    ClipsDescendants = true,
                    Parent = dropdownFrame
                })
                
                AddCorners(dropdownContainer)
                
                local optionList = CreateInstance("ScrollingFrame", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    ScrollBarThickness = 3,
                    ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100),
                    CanvasSize = UDim2.new(0, 0, 0, 0),
                    Parent = dropdownContainer
                })
                
                local optionLayout = CreateInstance("UIListLayout", {
                    Padding = UDim.new(0, 2),
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Parent = optionList
                })
                
                AddPadding(optionList, 5)
                
                -- Add to config data
                configData[text .. "_Dropdown"] = default
                
                local dropdownOpen = false
                local selectedOption = default
                
                local function ToggleDropdown()
                    dropdownOpen = not dropdownOpen
                    
                    local containerSize = dropdownOpen and UDim2.new(1, 0, 0, math.min(120, #options * 30)) or UDim2.new(1, 0, 0, 0)
                    local frameSize = dropdownOpen and UDim2.new(1, 0, 0, 70 + math.min(120, #options * 30)) or UDim2.new(1, 0, 0, 65)
                    local iconRotation = dropdownOpen and 180 or 0
                    
                    CreateTween(dropdownContainer, {
                        Size = containerSize
                    }, 0.3, Enum.EasingStyle.Quint)
                    
                    CreateTween(dropdownFrame, {
                        Size = frameSize
                    }, 0.3, Enum.EasingStyle.Quint)
                    
                    CreateTween(dropdownIcon, {
                        Rotation = iconRotation
                    }, 0.3, Enum.EasingStyle.Quint)
                    
                    -- Update section size after dropdown animation
                    wait(0.3)
                    UpdateSectionSize()
                end
                
                local function CreateOption(optionText)
                    local optionButton = CreateInstance("TextButton", {
                        Size = UDim2.new(1, -10, 0, 30),
                        BackgroundColor3 = settings.tertiaryColor,
                        BackgroundTransparency = 0.8,
                        Text = "",
                        Parent = optionList
                    })
                    
                    AddCorners(optionButton)
                    AddRippleEffect(optionButton)
                    
                    local optionLabel = CreateInstance("TextLabel", {
                        Size = UDim2.new(1, -10, 1, 0),
                        Position = UDim2.new(0, 10, 0, 0),
                        BackgroundTransparency = 1,
                        Text = optionText,
                        TextColor3 = settings.textColor,
                        TextSize = settings.textSize,
                        Font = settings.font,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Parent = optionButton
                    })
                    
                    -- Hover effect
                    optionButton.MouseEnter:Connect(function()
                        CreateTween(optionButton, {
                            BackgroundTransparency = 0.5
                        }, 0.2)
                    end)
                    
                    optionButton.MouseLeave:Connect(function()
                        CreateTween(optionButton, {
                            BackgroundTransparency = 0.8
                        }, 0.2)
                    end)
                    
                    optionButton.MouseButton1Click:Connect(function()
                        selectedOption = optionText
                        configData[text .. "_Dropdown"] = optionText
                        selectedLabel.Text = optionText
                        ToggleDropdown()
                        callback(optionText)
                    end)
                end
                
                -- Populate dropdown
                for _, option in ipairs(options) do
                    CreateOption(option)
                end
                
                optionLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    optionList.CanvasSize = UDim2.new(0, 0, 0, optionLayout.AbsoluteContentSize.Y + 10)
                end)
                
                dropdownButton.MouseButton1Click:Connect(ToggleDropdown)
                
                local dropdownObject = {}
                
                function dropdownObject:Set(option)
                    if table.find(options, option) then
                        selectedOption = option
                        configData[text .. "_Dropdown"] = option
                        selectedLabel.Text = option
                        callback(option)
                    end
                end
                
                function dropdownObject:Get()
                    return selectedOption
                end
                
                function dropdownObject:Refresh(newOptions, keepSelected)
                    options = newOptions
                    
                    -- Clear existing options
                    for _, child in pairs(optionList:GetChildren()) do
                        if child:IsA("TextButton") then
                            child:Destroy()
                        end
                    end
                    
                    -- Repopulate dropdown
                    for _, option in ipairs(options) do
                        CreateOption(option)
                    end
                    
                    -- Update selected option
                    if not keepSelected or not table.find(options, selectedOption) then
                        selectedOption = options[1] or ""
                        configData[text .. "_Dropdown"] = selectedOption
                        selectedLabel.Text = selectedOption
                    end
                    
                    -- Update size
                    if dropdownOpen then
                        dropdownContainer.Size = UDim2.new(1, 0, 0, math.min(120, #options * 30))
                        dropdownFrame.Size = UDim2.new(1, 0, 0, 70 + math.min(120, #options * 30))
                        UpdateSectionSize()
                    end
                end
                
                return dropdownObject
            end
            
            function section:AddTextBox(text, default, placeholder, clearOnFocus, callback)
                default = default or ""
                placeholder = placeholder or "Enter text..."
                clearOnFocus = clearOnFocus == nil and true or clearOnFocus
                callback = callback or function() end
                
                local textboxFrame = CreateInstance("Frame", {
                    Name = "TextBox",
                    Size = UDim2.new(1, 0, 0, 60),
                    BackgroundTransparency = 1,
                    Parent = sectionContent
                })
                
                local textboxLabel = CreateInstance("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 25),
                    Position = UDim2.new(0, 5, 0, 0),
                    BackgroundTransparency = 1,
                    Text = text,
                    TextColor3 = settings.textColor,
                    TextSize = settings.textSize,
                    Font = settings.font,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = textboxFrame
                })
                
                local textboxContainer = CreateInstance("Frame", {
                    Size = UDim2.new(1, 0, 0, 35),
                    Position = UDim2.new(0, 0, 0, 25),
                    BackgroundColor3 = settings.tertiaryColor,
                    BorderSizePixel = 0,
                    Parent = textboxFrame
                })
                
                AddCorners(textboxContainer)
                
                local textbox = CreateInstance("TextBox", {
                    Size = UDim2.new(1, -20, 1, 0),
                    Position = UDim2.new(0, 10, 0, 0),
                    BackgroundTransparency = 1,
                    Text = default,
                    PlaceholderText = placeholder,
                    TextColor3 = settings.textColor,
                    PlaceholderColor3 = Color3.fromRGB(120, 120, 120),
                    TextSize = settings.textSize,
                    Font = settings.font,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ClearTextOnFocus = clearOnFocus,
                    Parent = textboxContainer
                })
                
                -- Add subtle border animation on focus
                local textboxBorder = CreateStroke(textboxContainer, settings.accentColor, 1, 1)
                
                textbox.Focused:Connect(function()
                    CreateTween(textboxBorder, {
                        Transparency = 0
                    }, 0.2)
                end)
                
                textbox.FocusLost:Connect(function(enterPressed)
                    CreateTween(textboxBorder, {
                        Transparency = 1
                    }, 0.2)
                    
                    callback(textbox.Text, enterPressed)
                end)
                
                local textboxObject = {}
                
                function textboxObject:Get()
                    return textbox.Text
                end
                
                function textboxObject:Set(value)
                    textbox.Text = value
                    callback(value, false)
                end
                
                return textboxObject
            end
            
            function section:AddColorPicker(text, default, callback)
                default = default or Color3.fromRGB(255, 255, 255)
                callback = callback or function() end
                
                local colorPickerFrame = CreateInstance("Frame", {
                    Name = "ColorPicker",
                    Size = UDim2.new(1, 0, 0, 40),
                    BackgroundTransparency = 1,
                    Parent = sectionContent
                })
                
                local colorLabel = CreateInstance("TextLabel", {
                    Size = UDim2.new(1, -70, 1, 0),
                    Position = UDim2.new(0, 5, 0, 0),
                    BackgroundTransparency = 1,
                    Text = text,
                    TextColor3 = settings.textColor,
                    TextSize = settings.textSize,
                    Font = settings.font,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = colorPickerFrame
                })
                
                local colorPreview = CreateInstance("TextButton", {
                    Size = UDim2.new(0, 60, 0, 30),
                    Position = UDim2.new(1, -65, 0.5, -15),
                    BackgroundColor3 = default,
                    Text = "",
                    Parent = colorPickerFrame
                })
                
                AddCorners(colorPreview)
                AddRippleEffect(colorPreview)
                CreateStroke(colorPreview, Color3.fromRGB(80, 80, 80), 1)
                
                -- Create the full color picker (initially hidden)
                local pickerFrame = CreateInstance("Frame", {
                    Name = "PickerFrame",
                    Size = UDim2.new(0, 240, 0, 200),
                    Position = UDim2.new(1, 10, 0, 0),
                    BackgroundColor3 = settings.secondaryColor,
                    BorderSizePixel = 0,
                    Visible = false,
                    ZIndex = 100,
                    Parent = colorPreview
                })
                
                AddCorners(pickerFrame)
                AddShadow(pickerFrame)
                
                -- H (Hue) component
                local h, s, v = Color3.toHSV(default)
                local selectedColor = default
                local colorData = {H = h, S = s, V = v}
                
                -- Add to config data as RGB values for easier storage
                configData[text .. "_ColorR"] = math.floor(default.R * 255 + 0.5)
                configData[text .. "_ColorG"] = math.floor(default.G * 255 + 0.5)
                configData[text .. "_ColorB"] = math.floor(default.B * 255 + 0.5)
                
                -- Color components
                local colorSpace = CreateInstance("ImageButton", {
                    Name = "ColorSpace",
                    Size = UDim2.new(1, -30, 0, 140),
                    Position = UDim2.new(0, 15, 0, 15),
                    BackgroundColor3 = Color3.fromHSV(h, 1, 1),
                    Image = "rbxassetid://4155801252",
                    ZIndex = 101,
                    Parent = pickerFrame
                })
                
                AddCorners(colorSpace)
                
                local colorSelector = CreateInstance("Frame", {
                    Name = "Selector",
                    Size = UDim2.new(0, 10, 0, 10),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(s, 0, 1 - v, 0),
                    ZIndex = 102,
                    Parent = colorSpace
                })
                
                AddCorners(colorSelector, UDim.new(1, 0))
                CreateStroke(colorSelector, Color3.fromRGB(0, 0, 0), 1)
local hueSlider = CreateInstance("ImageButton", {
                    Name = "HueSlider",
                    Size = UDim2.new(0, 20, 0, 140),
                    Position = UDim2.new(1, -25, 0, 15),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BorderSizePixel = 0,
                    Image = "rbxassetid://3641079629",
                    ZIndex = 101,
                    Parent = pickerFrame
                })
                
                AddCorners(hueSlider)
                
                local hueSelector = CreateInstance("Frame", {
                    Name = "HueSelector",
                    Size = UDim2.new(1, 0, 0, 4),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0.5, 0, h, 0),
                    ZIndex = 102,
                    Parent = hueSlider
                })
                
                AddCorners(hueSelector)
                
                -- RGB display
                local rgbBox = CreateInstance("TextBox", {
                    Name = "RGBBox",
                    Size = UDim2.new(1, -30, 0, 25),
                    Position = UDim2.new(0, 15, 1, -40),
                    BackgroundColor3 = settings.tertiaryColor,
                    PlaceholderText = "RGB Value",
                    PlaceholderColor3 = Color3.fromRGB(120, 120, 120),
                    Text = string.format("%d, %d, %d", 
                        math.floor(default.R * 255 + 0.5), 
                        math.floor(default.G * 255 + 0.5), 
                        math.floor(default.B * 255 + 0.5)),
                    TextColor3 = settings.textColor,
                    TextSize = settings.textSize,
                    Font = settings.font,
                    ZIndex = 101,
                    Parent = pickerFrame
                })
                
                AddCorners(rgbBox)
                CreateStroke(rgbBox, Color3.fromRGB(80, 80, 80), 1)
                
                -- Helper functions
                local function UpdateColorDisplay()
                    local color = Color3.fromHSV(colorData.H, colorData.S, colorData.V)
                    
                    -- Update visual elements
                    colorSpace.BackgroundColor3 = Color3.fromHSV(colorData.H, 1, 1)
                    colorPreview.BackgroundColor3 = color
                    
                    -- Update RGB text box
                    local r, g, b = math.floor(color.R * 255 + 0.5), math.floor(color.G * 255 + 0.5), math.floor(color.B * 255 + 0.5)
                    rgbBox.Text = string.format("%d, %d, %d", r, g, b)
                    
                    -- Update config data
                    configData[text .. "_ColorR"] = r
                    configData[text .. "_ColorG"] = g
                    configData[text .. "_ColorB"] = b
                    
                    selectedColor = color
                    callback(color)
                end
                
                -- Color space selection logic
                local selectingColor = false
                
                colorSpace.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        selectingColor = true
                    end
                end)
                
                colorSpace.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        selectingColor = false
                    end
                end)
                
                local function UpdateColorSpace(input)
                    local sizeX = colorSpace.AbsoluteSize.X
                    local sizeY = colorSpace.AbsoluteSize.Y
                    local offsetX = colorSpace.AbsolutePosition.X
                    local offsetY = colorSpace.AbsolutePosition.Y
                    
                    local x = math.clamp(input.Position.X - offsetX, 0, sizeX) / sizeX
                    local y = math.clamp(input.Position.Y - offsetY, 0, sizeY) / sizeY
                    
                    colorData.S = x
                    colorData.V = 1 - y
                    
                    colorSelector.Position = UDim2.new(x, 0, y, 0)
                    UpdateColorDisplay()
                end
                
                colorSpace.InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement and selectingColor then
                        UpdateColorSpace(input)
                    end
                end)
                
                -- Hue selection logic
                local selectingHue = false
                
                hueSlider.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        selectingHue = true
                    end
                end)
                
                hueSlider.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        selectingHue = false
                    end
                end)
                
                local function UpdateHue(input)
                    local size = hueSlider.AbsoluteSize.Y
                    local offset = hueSlider.AbsolutePosition.Y
                    local y = math.clamp(input.Position.Y - offset, 0, size) / size
                    
                    colorData.H = y
                    hueSelector.Position = UDim2.new(0.5, 0, y, 0)
                    UpdateColorDisplay()
                end
                
                hueSlider.InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement and selectingHue then
                        UpdateHue(input)
                    end
                end)
                
                -- RGB input handling
                rgbBox.FocusLost:Connect(function()
                    local r, g, b = rgbBox.Text:match("(%d+),%s*(%d+),%s*(%d+)")
                    
                    if r and g and b then
                        r, g, b = tonumber(r), tonumber(g), tonumber(b)
                        r, g, b = math.clamp(r, 0, 255), math.clamp(g, 0, 255), math.clamp(b, 0, 255)
                        
                        local color = Color3.fromRGB(r, g, b)
                        local h, s, v = Color3.toHSV(color)
                        
                        colorData.H, colorData.S, colorData.V = h, s, v
                        colorSelector.Position = UDim2.new(s, 0, 1 - v, 0)
                        hueSelector.Position = UDim2.new(0.5, 0, h, 0)
                        
                        UpdateColorDisplay()
                    else
                        -- Reset text box if input is invalid
                        local color = selectedColor
                        rgbBox.Text = string.format("%d, %d, %d", 
                            math.floor(color.R * 255 + 0.5), 
                            math.floor(color.G * 255 + 0.5), 
                            math.floor(color.B * 255 + 0.5))
                    end
                end)
                
                -- Toggle color picker visibility
                local pickerVisible = false
                
                colorPreview.MouseButton1Click:Connect(function()
                    pickerVisible = not pickerVisible
                    pickerFrame.Visible = pickerVisible
                end)
                
                -- Close picker when clicking elsewhere
                UserInputService.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        local mousePos = input.Position
                        if pickerVisible then
                            -- Check if click is outside the picker frame
                            local pickerPosX = pickerFrame.AbsolutePosition.X
                            local pickerPosY = pickerFrame.AbsolutePosition.Y
                            local pickerSizeX = pickerFrame.AbsoluteSize.X
                            local pickerSizeY = pickerFrame.AbsoluteSize.Y
                            
                            if mousePos.X < pickerPosX or mousePos.X > pickerPosX + pickerSizeX or
                               mousePos.Y < pickerPosY or mousePos.Y > pickerPosY + pickerSizeY then
                                if not (mousePos.X >= colorPreview.AbsolutePosition.X and 
                                       mousePos.X <= colorPreview.AbsolutePosition.X + colorPreview.AbsoluteSize.X and
                                       mousePos.Y >= colorPreview.AbsolutePosition.Y and
                                       mousePos.Y <= colorPreview.AbsolutePosition.Y + colorPreview.AbsoluteSize.Y) then
                                    pickerVisible = false
                                    pickerFrame.Visible = false
                                end
                            end
                        end
                    end
                end)
                
                local colorPickerObject = {}
                
                function colorPickerObject:Set(color)
                    local h, s, v = Color3.toHSV(color)
                    colorData.H, colorData.S, colorData.V = h, s, v
                    
                    colorSelector.Position = UDim2.new(s, 0, 1 - v, 0)
                    hueSelector.Position = UDim2.new(0.5, 0, h, 0)
                    
                    UpdateColorDisplay()
                end
                
                function colorPickerObject:Get()
                    return selectedColor
                end
                
                UpdateColorDisplay()
                return colorPickerObject
            end
            
            function section:AddKeybind(text, default, callback, changedCallback)
                default = default or Enum.KeyCode.Unknown
                callback = callback or function() end
                changedCallback = changedCallback or function() end
                
                local keyBindFrame = CreateInstance("Frame", {
                    Name = "KeyBind",
                    Size = UDim2.new(1, 0, 0, 36),
                    BackgroundTransparency = 1,
                    Parent = sectionContent
                })
                
                local keyBindLabel = CreateInstance("TextLabel", {
                    Size = UDim2.new(1, -100, 1, 0),
                    Position = UDim2.new(0, 5, 0, 0),
                    BackgroundTransparency = 1,
                    Text = text,
                    TextColor3 = settings.textColor,
                    TextSize = settings.textSize,
                    Font = settings.font,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = keyBindFrame
                })
                
                local keyDisplayFrame = CreateInstance("Frame", {
                    Size = UDim2.new(0, 90, 0, 30),
                    Position = UDim2.new(1, -95, 0.5, -15),
                    BackgroundColor3 = settings.tertiaryColor,
                    Parent = keyBindFrame
                })
                
                AddCorners(keyDisplayFrame)
                
                local keyDisplay = CreateInstance("TextButton", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = default.Name == "Unknown" and "None" or default.Name,
                    TextColor3 = settings.textColor,
                    TextSize = settings.textSize,
                    Font = settings.font,
                    Parent = keyDisplayFrame
                })
                
                local listeningForKey = false
                local selectedKey = default
                
                -- Add to config data
                configData[text .. "_Keybind"] = default.Name
                
                local function StartListening()
                    listeningForKey = true
                    keyDisplay.Text = "..."
                    CreateTween(keyDisplayFrame, {
                        BackgroundColor3 = settings.accentColor
                    }, 0.3)
                end
                
                local function StopListening(key)
                    listeningForKey = false
                    selectedKey = key or selectedKey
                    keyDisplay.Text = selectedKey.Name == "Unknown" and "None" or selectedKey.Name
                    configData[text .. "_Keybind"] = selectedKey.Name
                    
                    CreateTween(keyDisplayFrame, {
                        BackgroundColor3 = settings.tertiaryColor
                    }, 0.3)
                    
                    changedCallback(selectedKey)
                end
                
                keyDisplay.MouseButton1Click:Connect(function()
                    if listeningForKey then
                        StopListening(Enum.KeyCode.Unknown)
                    else
                        StartListening()
                    end
                end)
                
                UserInputService.InputBegan:Connect(function(input)
                    if listeningForKey and input.UserInputType == Enum.UserInputType.Keyboard then
                        StopListening(input.KeyCode)
                    elseif not listeningForKey and input.KeyCode == selectedKey then
                        callback(selectedKey)
                    end
                end)
                
                local keyBindObject = {}
                
                function keyBindObject:Set(key)
                    selectedKey = key
                    keyDisplay.Text = selectedKey.Name == "Unknown" and "None" or selectedKey.Name
                    configData[text .. "_Keybind"] = selectedKey.Name
                end
                
                function keyBindObject:Get()
                    return selectedKey
                end
                
                return keyBindObject
            end
            
            return section
        end
        
        return tab
    end
    
    -- Config management functions
    function window:SaveConfig(name)
        local success, errorMessage = ConfigSystem:SaveConfig(name, configData)
        return success, errorMessage
    end
    
    function window:LoadConfig(name)
        local data = ConfigSystem:LoadConfig(name)
        
        if data then
            for key, value in pairs(data) do
                configData[key] = value
                
                local elementType = key:match("_(%a+)$")
                local elementName = key:sub(1, -(elementType:len() + 2))
                
                -- Reload UI elements based on config data
                -- This would need to be implemented when UI elements are created
                -- For now it just loads the data into configData
            end
            
            return true
        end
        
        return false
    end
    
    function window:GetConfigList()
        return ConfigSystem:GetConfigList()
    end
    
    function window:DeleteConfig(name)
        return ConfigSystem:DeleteConfig(name)
    end
    
    -- Play enter animation for main frame
    PlayEnterAnimation(mainFrame, "Scale")
    
    return window
end

-- Apply custom settings
function Library:ApplyCustomSettings(customSettings)
    for setting, value in pairs(customSettings) do
        if settings[setting] ~= nil then
            settings[setting] = value
        end
    end
end

-- Utility functions that can be used outside the library
Library.Utilities = {
    CreateTween = CreateTween,
    AddRippleEffect = AddRippleEffect,
    AddCorners = AddCorners,
    AddShadow = AddShadow,
    AddGlow = AddGlow,
    CreateStroke = CreateStroke,
    CreateGradient = CreateGradient
}

-- Return library
return Library
