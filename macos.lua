local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local MacOSLib = {}
MacOSLib.__index = MacOSLib

-- Constants
local ANIMATION_TIME = 0.2
local ROUNDED_CORNER = UDim.new(0, 8)
local BACKGROUND_COLOR = Color3.fromRGB(245, 245, 245)
local BORDER_COLOR = Color3.fromRGB(200, 200, 200)
local BUTTON_COLOR = Color3.fromRGB(255, 255, 255) 
local TEXT_COLOR = Color3.fromRGB(50, 50, 50)
local SHADOW_COLOR = Color3.fromRGB(150, 150, 150)
local ACCENT_COLOR = Color3.fromRGB(0, 122, 255) -- macOS blue accent
local TRANSPARENCY = 0.05 -- For glass effect

-- Utility Functions
local function CreateShadow(parent, size, position, radius)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://6014261993" -- Shadow image
    shadow.ImageColor3 = SHADOW_COLOR
    shadow.ImageTransparency = 0.5
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    shadow.SliceScale = 0.1
    shadow.Size = size or UDim2.new(1, 10, 1, 10)
    shadow.Position = position or UDim2.new(0, -5, 0, -5)
    shadow.ZIndex = 0
    shadow.Parent = parent
    return shadow
end

-- Initialize the library with a parent frame
function MacOSLib.new(parent)
    local self = setmetatable({}, MacOSLib)
    
    -- Create main container
    self.Container = Instance.new("Frame")
    self.Container.Name = "MacOSContainer"
    self.Container.BackgroundColor3 = BACKGROUND_COLOR
    self.Container.BackgroundTransparency = TRANSPARENCY
    self.Container.BorderSizePixel = 0
    self.Container.Size = UDim2.new(1, 0, 1, 0)
    self.Container.Parent = parent
    
    -- Apply glass effect
    local glassEffect = Instance.new("UIGradient")
    glassEffect.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.2),
        NumberSequenceKeypoint.new(1, 0.4)
    })
    glassEffect.Rotation = 45
    glassEffect.Parent = self.Container
    
    -- Create a UICorner for rounded corners
    local corner = Instance.new("UICorner")
    corner.CornerRadius = ROUNDED_CORNER
    corner.Parent = self.Container
    
    -- Create shadow
    CreateShadow(self.Container)
    
    return self
end

-- Button Component
function MacOSLib:CreateButton(text, position, size, callback)
    local button = Instance.new("TextButton")
    button.Name = "MacOSButton"
    button.BackgroundColor3 = BUTTON_COLOR
    button.BackgroundTransparency = 0.1
    button.BorderSizePixel = 0
    button.Size = size or UDim2.new(0, 120, 0, 30)
    button.Position = position or UDim2.new(0, 0, 0, 0)
    button.Font = Enum.Font.SourceSansSemibold
    button.TextColor3 = TEXT_COLOR
    button.TextSize = 14
    button.Text = text or "Button"
    button.AutoButtonColor = false
    button.Parent = self.Container
    
    -- Add rounded corners
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button
    
    -- Add subtle border
    local border = Instance.new("UIStroke")
    border.Color = BORDER_COLOR
    border.Thickness = 1
    border.Transparency = 0.5
    border.Parent = button
    
    -- Add shadow
    local shadow = CreateShadow(button, UDim2.new(1, 6, 1, 6), UDim2.new(0, -3, 0, -3))
    
    -- Animation effects
    local originalSize = button.Size
    local originalPos = button.Position
    
    button.MouseEnter:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.2), {BackgroundTransparency = 0})
        tween:Play()
    end)
    
    button.MouseLeave:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.2), {BackgroundTransparency = 0.1})
        tween:Play()
    end)
    
    button.MouseButton1Down:Connect(function()
        -- Shrink effect
        local shrinkTween = TweenService:Create(button, TweenInfo.new(0.05), {
            Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset * 0.95, originalSize.Y.Scale, originalSize.Y.Offset * 0.95),
            Position = UDim2.new(originalPos.X.Scale, originalPos.X.Offset + (originalSize.X.Offset * 0.025), originalPos.Y.Scale, originalPos.Y.Offset + (originalSize.Y.Offset * 0.025))
        })
        shrinkTween:Play()
    end)
    
    button.MouseButton1Up:Connect(function()
        -- Return to original size
        local expandTween = TweenService:Create(button, TweenInfo.new(0.1), {
            Size = originalSize,
            Position = originalPos
        })
        expandTween:Play()
        
        if callback then
            callback()
        end
    end)
    
    return button
end

-- Label Component
function MacOSLib:CreateLabel(text, position, size, textSize)
    local label = Instance.new("TextLabel")
    label.Name = "MacOSLabel"
    label.BackgroundTransparency = 1
    label.Size = size or UDim2.new(0, 200, 0, 30)
    label.Position = position or UDim2.new(0, 0, 0, 0)
    label.Font = Enum.Font.SourceSans
    label.TextColor3 = TEXT_COLOR
    label.TextSize = textSize or 14
    label.Text = text or "Label"
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = self.Container
    
    return label
end

-- Toggle Component
function MacOSLib:CreateToggle(text, position, callback)
    local toggleContainer = Instance.new("Frame")
    toggleContainer.Name = "MacOSToggleContainer"
    toggleContainer.BackgroundTransparency = 1
    toggleContainer.Size = UDim2.new(0, 200, 0, 30)
    toggleContainer.Position = position or UDim2.new(0, 0, 0, 0)
    toggleContainer.Parent = self.Container
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(0, 150, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.Font = Enum.Font.SourceSans
    label.TextColor3 = TEXT_COLOR
    label.TextSize = 14
    label.Text = text or "Toggle"
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggleContainer
    
    local toggleBackground = Instance.new("Frame")
    toggleBackground.Name = "Background"
    toggleBackground.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    toggleBackground.BorderSizePixel = 0
    toggleBackground.Size = UDim2.new(0, 40, 0, 20)
    toggleBackground.Position = UDim2.new(1, -40, 0.5, -10)
    toggleBackground.Parent = toggleContainer
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggleBackground
    
    local toggleCircle = Instance.new("Frame")
    toggleCircle.Name = "Circle"
    toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    toggleCircle.BorderSizePixel = 0
    toggleCircle.Size = UDim2.new(0, 16, 0, 16)
    toggleCircle.Position = UDim2.new(0, 2, 0.5, -8)
    toggleCircle.Parent = toggleBackground
    
    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = toggleCircle
    
    -- Add a subtle shadow to the circle
    CreateShadow(toggleCircle, UDim2.new(1, 4, 1, 4), UDim2.new(0, -2, 0, -2))
    
    local enabled = false
    
    local function updateToggle()
        if enabled then
            TweenService:Create(toggleBackground, TweenInfo.new(ANIMATION_TIME), {
                BackgroundColor3 = ACCENT_COLOR
            }):Play()
            
            TweenService:Create(toggleCircle, TweenInfo.new(ANIMATION_TIME), {
                Position = UDim2.new(0, 22, 0.5, -8)
            }):Play()
        else
            TweenService:Create(toggleBackground, TweenInfo.new(ANIMATION_TIME), {
                BackgroundColor3 = Color3.fromRGB(200, 200, 200)
            }):Play()
            
            TweenService:Create(toggleCircle, TweenInfo.new(ANIMATION_TIME), {
                Position = UDim2.new(0, 2, 0.5, -8)
            }):Play()
        end
        
        if callback then
            callback(enabled)
        end
    end
    
    toggleBackground.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            enabled = not enabled
            updateToggle()
        end
    end)
    
    toggleCircle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            enabled = not enabled
            updateToggle()
        end
    end)
    
    return {
        Container = toggleContainer,
        SetEnabled = function(value)
            enabled = value
            updateToggle()
        end,
        GetEnabled = function()
            return enabled
        end
    }
end

-- Tab Component
function MacOSLib:CreateTabSystem(position, size, tabNames)
    local tabSystem = Instance.new("Frame")
    tabSystem.Name = "MacOSTabSystem"
    tabSystem.BackgroundColor3 = BACKGROUND_COLOR
    tabSystem.BackgroundTransparency = 0.2
    tabSystem.BorderSizePixel = 0
    tabSystem.Size = size or UDim2.new(0, 400, 0, 300)
    tabSystem.Position = position or UDim2.new(0, 0, 0, 0)
    tabSystem.Parent = self.Container
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = ROUNDED_CORNER
    corner.Parent = tabSystem
    
    -- Create the tab buttons
    local tabButtons = Instance.new("Frame")
    tabButtons.Name = "TabButtons"
    tabButtons.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
    tabButtons.BackgroundTransparency = 0.1
    tabButtons.BorderSizePixel = 0
    tabButtons.Size = UDim2.new(1, 0, 0, 30)
    tabButtons.Position = UDim2.new(0, 0, 0, 0)
    tabButtons.Parent = tabSystem
    
    local tabButtonsCorner = Instance.new("UICorner")
    tabButtonsCorner.CornerRadius = UDim.new(0, 8)
    tabButtonsCorner.Parent = tabButtons
    
    -- Clip the corners to match macOS style
    local bottomFrame = Instance.new("Frame")
    bottomFrame.Name = "BottomFrame"
    bottomFrame.BackgroundColor3 = tabButtons.BackgroundColor3
    bottomFrame.BackgroundTransparency = tabButtons.BackgroundTransparency
    bottomFrame.BorderSizePixel = 0
    bottomFrame.Size = UDim2.new(1, 0, 0.5, 0)
    bottomFrame.Position = UDim2.new(0, 0, 0.5, 0)
    bottomFrame.Parent = tabButtons
    
    -- Create content frame
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentFrame"
    contentFrame.BackgroundColor3 = BACKGROUND_COLOR
    contentFrame.BackgroundTransparency = 0.1
    contentFrame.BorderSizePixel = 0
    contentFrame.Size = UDim2.new(1, 0, 1, -30)
    contentFrame.Position = UDim2.new(0, 0, 0, 30)
    contentFrame.Parent = tabSystem
    
    local contentCorner = Instance.new("UICorner")
    contentCorner.CornerRadius = UDim.new(0, 8)
    contentCorner.Parent = contentFrame
    
    -- Create thin line separator
    local separator = Instance.new("Frame")
    separator.Name = "Separator"
    separator.BackgroundColor3 = BORDER_COLOR
    separator.BorderSizePixel = 0
    separator.Size = UDim2.new(1, 0, 0, 1)
    separator.Position = UDim2.new(0, 0, 1, 0)
    separator.Parent = tabButtons
    
    CreateShadow(tabSystem)
    
    local tabs = {}
    local buttons = {}
    local selected = 1
    
    -- Function to update tab visibility
    local function updateTabs()
        for i, tab in ipairs(tabs) do
            tab.Visible = (i == selected)
            
            if i == selected then
                TweenService:Create(buttons[i], TweenInfo.new(ANIMATION_TIME), {
                    BackgroundTransparency = 0.1,
                    TextColor3 = ACCENT_COLOR
                }):Play()
            else
                TweenService:Create(buttons[i], TweenInfo.new(ANIMATION_TIME), {
                    BackgroundTransparency = 1,
                    TextColor3 = TEXT_COLOR
                }):Play()
            end
        end
    end
    
    -- Create tab buttons and content frames
    local buttonWidth = 1 / #tabNames
    
    for i, tabName in ipairs(tabNames) do
        -- Create tab button
        local button = Instance.new("TextButton")
        button.Name = tabName .. "Button"
        button.BackgroundColor3 = BACKGROUND_COLOR
        button.BackgroundTransparency = i == 1 and 0.1 or 1
        button.BorderSizePixel = 0
        button.Size = UDim2.new(buttonWidth, 0, 1, 0)
        button.Position = UDim2.new(buttonWidth * (i-1), 0, 0, 0)
        button.Font = Enum.Font.SourceSansSemibold
        button.TextColor3 = i == 1 and ACCENT_COLOR or TEXT_COLOR
        button.TextSize = 14
        button.Text = tabName
        button.Parent = tabButtons
        table.insert(buttons, button)
        
        -- Create tab content
        local content = Instance.new("ScrollingFrame")
        content.Name = tabName .. "Content"
        content.BackgroundTransparency = 1
        content.BorderSizePixel = 0
        content.Size = UDim2.new(1, -20, 1, -20)
        content.Position = UDim2.new(0, 10, 0, 10)
        content.CanvasSize = UDim2.new(0, 0, 0, 0)
        content.ScrollBarThickness = 6
        content.ScrollBarImageColor3 = Color3.fromRGB(180, 180, 180)
        content.Visible = i == 1
        content.Parent = contentFrame
        
        -- Create smooth scroll effect
        local scrollingEnabled = false
        local momentum = 0
        local targetPosition = 0

        content.MouseEnter:Connect(function()
            scrollingEnabled = true
        end)

        content.MouseLeave:Connect(function()
            scrollingEnabled = false
        end)
        
        -- Make tab clickable
        button.MouseButton1Click:Connect(function()
            selected = i
            updateTabs()
        end)
        
        table.insert(tabs, content)
    end
    
    return {
        TabSystem = tabSystem,
        GetContentFrame = function(index)
            return tabs[index]
        end,
        SelectTab = function(index)
            if tabs[index] then
                selected = index
                updateTabs()
            end
        end
    }
end

-- Slider Component
function MacOSLib:CreateSlider(text, position, min, max, default, callback)
    min = min or 0
    max = max or 100
    default = default or min
    
    local sliderContainer = Instance.new("Frame")
    sliderContainer.Name = "MacOSSliderContainer"
    sliderContainer.BackgroundTransparency = 1
    sliderContainer.Size = UDim2.new(0, 200, 0, 40)
    sliderContainer.Position = position or UDim2.new(0, 0, 0, 0)
    sliderContainer.Parent = self.Container
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.Font = Enum.Font.SourceSans
    label.TextColor3 = TEXT_COLOR
    label.TextSize = 14
    label.Text = text or "Slider"
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = sliderContainer
    
    local valueDisplay = Instance.new("TextLabel")
    valueDisplay.Name = "Value"
    valueDisplay.BackgroundTransparency = 1
    valueDisplay.Size = UDim2.new(0, 50, 0, 20)
    valueDisplay.Position = UDim2.new(1, -50, 0, 0)
    valueDisplay.Font = Enum.Font.SourceSans
    valueDisplay.TextColor3 = TEXT_COLOR
    valueDisplay.TextSize = 14
    valueDisplay.Text = tostring(default)
    valueDisplay.TextXAlignment = Enum.TextXAlignment.Right
    valueDisplay.Parent = sliderContainer
    
    local sliderTrack = Instance.new("Frame")
    sliderTrack.Name = "Track"
    sliderTrack.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    sliderTrack.BorderSizePixel = 0
    sliderTrack.Size = UDim2.new(1, 0, 0, 4)
    sliderTrack.Position = UDim2.new(0, 0, 0.7, 0)
    sliderTrack.Parent = sliderContainer
    
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(1, 0)
    trackCorner.Parent = sliderTrack
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Name = "Fill"
    sliderFill.BackgroundColor3 = ACCENT_COLOR
    sliderFill.BorderSizePixel = 0
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.Position = UDim2.new(0, 0, 0, 0)
    sliderFill.Parent = sliderTrack
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = sliderFill
    
    local sliderKnob = Instance.new("Frame")
    sliderKnob.Name = "Knob"
    sliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderKnob.BorderSizePixel = 0
    sliderKnob.Size = UDim2.new(0, 16, 0, 16)
    sliderKnob.Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8)
    sliderKnob.Parent = sliderTrack
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = sliderKnob
    
    -- Add shadow to knob
    CreateShadow(sliderKnob, UDim2.new(1, 6, 1, 6), UDim2.new(0, -3, 0, -3))
    
    local dragging = false
    local value = default
    
    local function updateSlider(newValue)
        value = math.clamp(newValue, min, max)
        local percentage = (value - min) / (max - min)
        
        sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
        sliderKnob.Position = UDim2.new(percentage, -8, 0.5, -8)
        valueDisplay.Text = string.format("%.0f", value)
        
        if callback then
            callback(value)
        end
    end
    
    sliderTrack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            local percentage = math.clamp((input.Position.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X, 0, 1)
            updateSlider(min + (max - min) * percentage)
        end
    end)
    
    sliderKnob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            
            -- Animation for pressed state
            TweenService:Create(sliderKnob, TweenInfo.new(0.1), {
                Size = UDim2.new(0, 18, 0, 18),
                Position = UDim2.new(sliderKnob.Position.X.Scale, -9, 0.5, -9)
            }):Play()
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local percentage = math.clamp((input.Position.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X, 0, 1)
            updateSlider(min + (max - min) * percentage)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging then
            dragging = false
            
            -- Animation for released state
            TweenService:Create(sliderKnob, TweenInfo.new(0.1), {
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new(sliderKnob.Position.X.Scale, -8, 0.5, -8)
            }):Play()
        end
    end)
    
    return {
        Container = sliderContainer,
        SetValue = function(newValue)
            updateSlider(newValue)
        end,
        GetValue = function()
            return value
        end
    }
end

-- Dropdown Component
function MacOSLib:CreateDropdown(text, position, options, callback)
    local dropdownContainer = Instance.new("Frame")
    dropdownContainer.Name = "MacOSDropdownContainer"
    dropdownContainer.BackgroundTransparency = 1
    dropdownContainer.Size = UDim2.new(0, 200, 0, 60)
    dropdownContainer.Position = position or UDim2.new(0, 0, 0, 0)
    dropdownContainer.Parent = self.Container
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.Font = Enum.Font.SourceSans
    label.TextColor3 = TEXT_COLOR
    label.TextSize = 14
    label.Text = text or "Dropdown"
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = dropdownContainer
    
    local dropdownButton = Instance.new("TextButton")
    dropdownButton.Name = "Button"
    dropdownButton.BackgroundColor3 = BUTTON_COLOR
    dropdownButton.BackgroundTransparency = 0.1
    dropdownButton.BorderSizePixel = 0
    dropdownButton.Size = UDim2.new(1, 0, 0, 30)
    dropdownButton.Position = UDim2.new(0, 0, 0, 20)
    dropdownButton.Font = Enum.Font.SourceSans
    dropdownButton.TextColor3 = TEXT_COLOR
    dropdownButton.TextSize = 14
    dropdownButton.Text = options and options[1] or "Select option"
    dropdownButton.TextXAlignment = Enum.TextXAlignment.Left
    dropdownButton.TextTruncate = Enum.TextTruncate.AtEnd
    dropdownButton.AutoButtonColor = false
    dropdownButton.Parent = dropdownContainer
    
    -- Add padding to text
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 10)
    padding.Parent = dropdownButton
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = dropdownButton
    
    -- Add subtle border
    local border = Instance.new("UIStroke")
    border.Color = BORDER_COLOR
    border.Thickness = 1
    border.Parent = dropdownButton
    
    -- Create arrow icon
    local arrow = Instance.new("ImageLabel")
    arrow.Name = "Arrow"
    arrow.BackgroundTransparency = 1
    arrow.Size = UDim2.new(0, 16, 0, 16)
    arrow.Position = UDim2.new(1, -26, 0.5, -8)
    arrow.Image = "rbxassetid://6031091004" -- Down arrow
    arrow.ImageColor3 = TEXT_COLOR
    arrow.Parent = dropdownButton
    
    -- Create dropdown menu
    local dropdownMenu = Instance.new("Frame")
    dropdownMenu.Name = "Menu"
    dropdownMenu.BackgroundColor3 = BUTTON_COLOR
    dropdownMenu.BackgroundTransparency = 0.1
    dropdownMenu.BorderSizePixel = 0
    dropdownMenu.Size = UDim2.new(1, 0, 0, 0) -- Start with no height
    dropdownMenu.Position = UDim2.new(0, 0, 1, 5)
    dropdownMenu.ClipsDescendants = true
    dropdownMenu.Visible = false
    dropdownMenu.ZIndex = 10
    dropdownMenu.Parent = dropdownContainer
    
    local menuCorner = Instance.new("UICorner")
    menuCorner.CornerRadius = UDim.new(0, 6)
    menuCorner.Parent = dropdownMenu
    
    -- Add shadow to menu
    CreateShadow(dropdownMenu, UDim2.new(1, 10, 1, 10), UDim2.new(0, -5, 0, -5))
    
    -- Add options to the menu
    local selected = options and options[1] or ""
    local menuHeight = 0
    local isOpen = false
    
    if options then
        for i, option in ipairs(options) do
            local optionButton = Instance.new("TextButton")
            optionButton.Name = option
            optionButton.BackgroundTransparency = 1
            optionButton.Size = UDim2.new(1, 0, 0, 30)
            optionButton.Position = UDim2.new(0, 0, 0, (i-1) * 30)
            optionButton.Font = Enum.Font.SourceSans
            optionButton.TextColor3 = TEXT_COLOR
            optionButton.TextSize = 14
            optionButton.Text = option
            optionButton.TextXAlignment = Enum.TextXAlignment.Left
            optionButton.ZIndex = 11
            optionButton.Parent = dropdownMenu
            
            -- Add padding to text
            local optionPadding = Instance.new("UIPadding")
            optionPadding.PaddingLeft = UDim.new(0, 10)
            optionPadding.Parent = optionButton
            
            -- Highlight when selected
            if option == selected then
                optionButton.TextColor3 = ACCENT_COLOR
            end
            
            optionButton.MouseEnter:Connect(function()
                if option ~= selected then
                    TweenService:Create(optionButton, TweenInfo.new(0.1), {
                        BackgroundTransparency = 0.9
                    }):Play()
                end
            end)
            
optionButton.MouseLeave:Connect(function()
                if option ~= selected then
                    TweenService:Create(optionButton, TweenInfo.new(0.1), {
                        BackgroundTransparency = 1
                    }):Play()
                end
            end)
            
            optionButton.MouseButton1Click:Connect(function()
                selected = option
                dropdownButton.Text = option
                
                -- Update the highlight
                for _, child in pairs(dropdownMenu:GetChildren()) do
                    if child:IsA("TextButton") then
                        if child.Text == selected then
                            child.TextColor3 = ACCENT_COLOR
                        else
                            child.TextColor3 = TEXT_COLOR
                        end
                    end
                end
                
                -- Close the dropdown
                isOpen = false
                
                -- Animation
                TweenService:Create(dropdownMenu, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                    Size = UDim2.new(1, 0, 0, 0)
                }):Play()
                
                TweenService:Create(arrow, TweenInfo.new(0.2), {
                    Rotation = 0
                }):Play()
                
                if callback then
                    callback(selected)
                end
                
                -- Hide menu after animation
                delay(0.2, function()
                    if not isOpen then
                        dropdownMenu.Visible = false
                    end
                end)
            end)
            
            menuHeight = menuHeight + 30
        end
    end
    
    dropdownButton.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        
        if isOpen then
            dropdownMenu.Visible = true
            
            -- Animation
            TweenService:Create(dropdownMenu, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(1, 0, 0, menuHeight)
            }):Play()
            
            TweenService:Create(arrow, TweenInfo.new(0.2), {
                Rotation = 180
            }):Play()
        else
            -- Animation
            TweenService:Create(dropdownMenu, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(1, 0, 0, 0)
            }):Play()
            
            TweenService:Create(arrow, TweenInfo.new(0.2), {
                Rotation = 0
            }):Play()
            
            -- Hide menu after animation
            delay(0.2, function()
                if not isOpen then
                    dropdownMenu.Visible = false
                end
            end)
        end
    end)
    
    -- Hover effects
    dropdownButton.MouseEnter:Connect(function()
        TweenService:Create(dropdownButton, TweenInfo.new(0.1), {
            BackgroundTransparency = 0
        }):Play()
    end)
    
    dropdownButton.MouseLeave:Connect(function()
        TweenService:Create(dropdownButton, TweenInfo.new(0.1), {
            BackgroundTransparency = 0.1
        }):Play()
    end)
    
    return {
        Container = dropdownContainer,
        SetValue = function(value)
            if table.find(options, value) then
                selected = value
                dropdownButton.Text = value
                
                -- Update the highlight
                for _, child in pairs(dropdownMenu:GetChildren()) do
                    if child:IsA("TextButton") then
                        if child.Text == selected then
                            child.TextColor3 = ACCENT_COLOR
                        else
                            child.TextColor3 = TEXT_COLOR
                        end
                    end
                end
                
                if callback then
                    callback(selected)
                end
            end
        end,
        GetValue = function()
            return selected
        end,
        AddOption = function(option)
            if not table.find(options, option) then
                table.insert(options, option)
                
                local optionButton = Instance.new("TextButton")
                optionButton.Name = option
                optionButton.BackgroundTransparency = 1
                optionButton.Size = UDim2.new(1, 0, 0, 30)
                optionButton.Position = UDim2.new(0, 0, 0, (#options-1) * 30)
                optionButton.Font = Enum.Font.SourceSans
                optionButton.TextColor3 = TEXT_COLOR
                optionButton.TextSize = 14
                optionButton.Text = option
                optionButton.TextXAlignment = Enum.TextXAlignment.Left
                optionButton.ZIndex = 11
                optionButton.Parent = dropdownMenu
                
                -- Add padding to text
                local optionPadding = Instance.new("UIPadding")
                optionPadding.PaddingLeft = UDim.new(0, 10)
                optionPadding.Parent = optionButton
                
                optionButton.MouseEnter:Connect(function()
                    if option ~= selected then
                        TweenService:Create(optionButton, TweenInfo.new(0.1), {
                            BackgroundTransparency = 0.9
                        }):Play()
                    end
                end)
                
                optionButton.MouseLeave:Connect(function()
                    if option ~= selected then
                        TweenService:Create(optionButton, TweenInfo.new(0.1), {
                            BackgroundTransparency = 1
                        }):Play()
                    end
                end)
                
                optionButton.MouseButton1Click:Connect(function()
                    selected = option
                    dropdownButton.Text = option
                    
                    -- Update the highlight
                    for _, child in pairs(dropdownMenu:GetChildren()) do
                        if child:IsA("TextButton") then
                            if child.Text == selected then
                                child.TextColor3 = ACCENT_COLOR
                            else
                                child.TextColor3 = TEXT_COLOR
                            end
                        end
                    end
                    
                    -- Close the dropdown
                    isOpen = false
                    
                    -- Animation
                    TweenService:Create(dropdownMenu, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                        Size = UDim2.new(1, 0, 0, 0)
                    }):Play()
                    
                    TweenService:Create(arrow, TweenInfo.new(0.2), {
                        Rotation = 0
                    }):Play()
                    
                    if callback then
                        callback(selected)
                    end
                    
                    -- Hide menu after animation
                    delay(0.2, function()
                        if not isOpen then
                            dropdownMenu.Visible = false
                        end
                    end)
                end)
                
                menuHeight = menuHeight + 30
                return true
            end
            return false
        end,
        RemoveOption = function(option)
            local index = table.find(options, option)
            if index then
                table.remove(options, index)
                
                -- Remove from UI
                for _, child in pairs(dropdownMenu:GetChildren()) do
                    if child:IsA("TextButton") and child.Text == option then
                        child:Destroy()
                        break
                    end
                end
                
                -- Reposition remaining options
                local pos = 0
                for _, child in pairs(dropdownMenu:GetChildren()) do
                    if child:IsA("TextButton") then
                        child.Position = UDim2.new(0, 0, 0, pos)
                        pos = pos + 30
                    end
                end
                
                menuHeight = menuHeight - 30
                
                -- Update selected if removed
                if selected == option then
                    selected = options[1] or ""
                    dropdownButton.Text = selected
                    
                    if callback then
                        callback(selected)
                    end
                end
                
                return true
            end
            return false
        end
    }
end

-- Create a window (frame with title and close button)
function MacOSLib:CreateWindow(title, position, size)
    local window = Instance.new("Frame")
    window.Name = "MacOSWindow"
    window.BackgroundColor3 = BACKGROUND_COLOR
    window.BackgroundTransparency = TRANSPARENCY
    window.BorderSizePixel = 0
    window.Size = size or UDim2.new(0, 400, 0, 300)
    window.Position = position or UDim2.new(0.5, -200, 0.5, -150)
    window.Parent = self.Container
    
    local windowCorner = Instance.new("UICorner")
    windowCorner.CornerRadius = ROUNDED_CORNER
    windowCorner.Parent = window
    
    -- Create window shadow
    CreateShadow(window)
    
    -- Add window titlebar
    local titlebar = Instance.new("Frame")
    titlebar.Name = "Titlebar"
    titlebar.BackgroundColor3 = Color3.fromRGB(235, 235, 235)
    titlebar.BackgroundTransparency = 0.1
    titlebar.BorderSizePixel = 0
    titlebar.Size = UDim2.new(1, 0, 0, 30)
    titlebar.Position = UDim2.new(0, 0, 0, 0)
    titlebar.Parent = window
    
    local titlebarCorner = Instance.new("UICorner")
    titlebarCorner.CornerRadius = UDim.new(0, 8)
    titlebarCorner.Parent = titlebar
    
    -- Clip the corners to match macOS style
    local bottomFrame = Instance.new("Frame")
    bottomFrame.Name = "BottomFrame"
    bottomFrame.BackgroundColor3 = titlebar.BackgroundColor3
    bottomFrame.BackgroundTransparency = titlebar.BackgroundTransparency
    bottomFrame.BorderSizePixel = 0
    bottomFrame.Size = UDim2.new(1, 0, 0.5, 0)
    bottomFrame.Position = UDim2.new(0, 0, 0.5, 0)
    bottomFrame.Parent = titlebar
    
    -- Add title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.BackgroundTransparency = 1
    titleLabel.Size = UDim2.new(1, -100, 1, 0)
    titleLabel.Position = UDim2.new(0.5, -50, 0, 0)
    titleLabel.Font = Enum.Font.SourceSansSemibold
    titleLabel.TextColor3 = TEXT_COLOR
    titleLabel.TextSize = 14
    titleLabel.Text = title or "Window"
    titleLabel.Parent = titlebar
    
    -- Add window buttons (close, minimize, maximize)
    local buttonContainer = Instance.new("Frame")
    buttonContainer.Name = "WindowButtons"
    buttonContainer.BackgroundTransparency = 1
    buttonContainer.Size = UDim2.new(0, 70, 0, 20)
    buttonContainer.Position = UDim2.new(0, 10, 0.5, -10)
    buttonContainer.Parent = titlebar
    
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 95, 87)
    closeButton.BorderSizePixel = 0
    closeButton.Size = UDim2.new(0, 12, 0, 12)
    closeButton.Position = UDim2.new(0, 0, 0, 4)
    closeButton.Text = ""
    closeButton.Parent = buttonContainer
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(1, 0)
    closeCorner.Parent = closeButton
    
    local minimizeButton = Instance.new("TextButton")
    minimizeButton.Name = "MinimizeButton"
    minimizeButton.BackgroundColor3 = Color3.fromRGB(255, 189, 46)
    minimizeButton.BorderSizePixel = 0
    minimizeButton.Size = UDim2.new(0, 12, 0, 12)
    minimizeButton.Position = UDim2.new(0, 26, 0, 4)
    minimizeButton.Text = ""
    minimizeButton.Parent = buttonContainer
    
    local minimizeCorner = Instance.new("UICorner")
    minimizeCorner.CornerRadius = UDim.new(1, 0)
    minimizeCorner.Parent = minimizeButton
    
    local maximizeButton = Instance.new("TextButton")
    maximizeButton.Name = "MaximizeButton"
    maximizeButton.BackgroundColor3 = Color3.fromRGB(41, 204, 65)
    maximizeButton.BorderSizePixel = 0
    maximizeButton.Size = UDim2.new(0, 12, 0, 12)
    maximizeButton.Position = UDim2.new(0, 52, 0, 4)
    maximizeButton.Text = ""
    maximizeButton.Parent = buttonContainer
    
    local maximizeCorner = Instance.new("UICorner")
    maximizeCorner.CornerRadius = UDim.new(1, 0)
    maximizeCorner.Parent = maximizeButton
    
    -- Content container
    local content = Instance.new("Frame")
    content.Name = "Content"
    content.BackgroundTransparency = 1
    content.Size = UDim2.new(1, -20, 1, -40)
    content.Position = UDim2.new(0, 10, 0, 35)
    content.Parent = window
    
    -- Make window draggable
    local dragging = false
    local dragInput
    local dragStart
    local startPos
    
    titlebar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = window.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    titlebar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    -- Add hover effects for window buttons
    closeButton.MouseEnter:Connect(function()
        -- Add X symbol on hover
        local xSymbol = Instance.new("TextLabel")
        xSymbol.Name = "XSymbol"
        xSymbol.BackgroundTransparency = 1
        xSymbol.Size = UDim2.new(1, 0, 1, 0)
        xSymbol.Position = UDim2.new(0, 0, 0, 0)
        xSymbol.Font = Enum.Font.SourceSansBold
        xSymbol.TextColor3 = Color3.fromRGB(80, 80, 80)
        xSymbol.TextSize = 12
        xSymbol.Text = "×"
        xSymbol.Parent = closeButton
    end)
    
    closeButton.MouseLeave:Connect(function()
        -- Remove X symbol
        for _, child in pairs(closeButton:GetChildren()) do
            if child.Name == "XSymbol" then
                child:Destroy()
            end
        end
    end)
    
    minimizeButton.MouseEnter:Connect(function()
        -- Add minimize symbol
        local minSymbol = Instance.new("Frame")
        minSymbol.Name = "MinSymbol"
        minSymbol.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        minSymbol.BorderSizePixel = 0
        minSymbol.Size = UDim2.new(0, 6, 0, 1)
        minSymbol.Position = UDim2.new(0.5, -3, 0.5, 0)
        minSymbol.Parent = minimizeButton
    end)
    
    minimizeButton.MouseLeave:Connect(function()
        -- Remove minimize symbol
        for _, child in pairs(minimizeButton:GetChildren()) do
            if child.Name == "MinSymbol" then
                child:Destroy()
            end
        end
    end)
    
    maximizeButton.MouseEnter:Connect(function()
        -- Add maximize symbol
        local maxSymbol = Instance.new("Frame")
        maxSymbol.Name = "MaxSymbol"
        maxSymbol.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        maxSymbol.BorderSizePixel = 0
        maxSymbol.Size = UDim2.new(0, 6, 0, 6)
        maxSymbol.Position = UDim2.new(0.5, -3, 0.5, -3)
        maxSymbol.Parent = maximizeButton
    end)
    
    maximizeButton.MouseLeave:Connect(function()
        -- Remove maximize symbol
        for _, child in pairs(maximizeButton:GetChildren()) do
            if child.Name == "MaxSymbol" then
                child:Destroy()
            end
        end
    end)
    
    -- Button functionality
    local isMinimized = false
    local isMaximized = false
    local originalSize = window.Size
    local originalPos = window.Position
    
    closeButton.MouseButton1Click:Connect(function()
        -- Animation for closing
        TweenService:Create(window, TweenInfo.new(0.2), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(window.Position.X.Scale, window.Position.X.Offset + window.Size.X.Offset/2, 
                                window.Position.Y.Scale, window.Position.Y.Offset + window.Size.Y.Offset/2),
            BackgroundTransparency = 1
        }):Play()
        
        -- Destroy after animation
        delay(0.2, function()
            window:Destroy()
        end)
    end)
    
    minimizeButton.MouseButton1Click:Connect(function()
        if not isMinimized then
            -- Save current size and minimize
            if not isMaximized then
                originalSize = window.Size
                originalPos = window.Position
            end
            isMinimized = true
            isMaximized = false
            
            -- Animation for minimizing
            TweenService:Create(window, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Size = UDim2.new(0, window.Size.X.Offset, 0, 30),
                Position = UDim2.new(window.Position.X.Scale, window.Position.X.Offset, 
                                    window.Position.Y.Scale, window.Position.Y.Offset + window.Size.Y.Offset - 30)
            }):Play()
        else
            -- Restore original size
            isMinimized = false
            
            -- Animation for restoring
            TweenService:Create(window, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Size = originalSize,
                Position = originalPos
            }):Play()
        end
    end)
    
    maximizeButton.MouseButton1Click:Connect(function()
        if not isMaximized then
            -- Save current size if not minimized
            if not isMinimized then
                originalSize = window.Size
                originalPos = window.Position
            end
            isMaximized = true
            isMinimized = false
            
            -- Animation for maximizing
            TweenService:Create(window, TweenInfo.new(0.3), {
                Size = UDim2.new(1, -50, 1, -50),
                Position = UDim2.new(0, 25, 0, 25)
            }):Play()
        else
            -- Restore original size
            isMaximized = false
            
            -- Animation for restoring
            TweenService:Create(window, TweenInfo.new(0.3), {
                Size = originalSize,
                Position = originalPos
            }):Play()
        end
    end)
    
    return {
        Window = window,
        Content = content,
        SetTitle = function(newTitle)
            titleLabel.Text = newTitle
        end
    }
end

-- Example usage
-- local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
-- local screenGui = Instance.new("ScreenGui")
-- screenGui.Parent = playerGui

-- local macOS = MacOSLib.new(screenGui)
-- local window = macOS:CreateWindow("macOS UI Demo", UDim2.new(0.5, -250, 0.5, -200), UDim2.new(0, 500, 0, 400))

-- -- Creating examples of all components
-- local label = macOS:CreateLabel("Welcome to macOS UI", UDim2.new(0, 20, 0, 20), UDim2.new(0, 300, 0, 30), 18)
-- label.Parent = window.Content

-- local button = macOS:CreateButton("Click Me", UDim2.new(0, 20, 0, 60), UDim2.new(0, 120, 0, 30), function()
--     print("Button clicked!")
-- end)
-- button.Parent = window.Content

-- local toggle = macOS:CreateToggle("Enable Feature", UDim2.new(0, 20, 0, 100), function(enabled)
--     print("Toggle:", enabled)
-- end)
-- toggle.Container.Parent = window.Content

-- local slider = macOS:CreateSlider("Volume", UDim2.new(0, 20, 0, 140), 0, 100, 50, function(value)
--     print("Slider value:", value)
-- end)
-- slider.Container.Parent = window.Content

-- local dropdown = macOS:CreateDropdown("Select Option", UDim2.new(0, 20, 0, 190), {"Option 1", "Option 2", "Option 3"}, function(selected)
--     print("Selected:", selected)
-- end)
-- dropdown.Container.Parent = window.Content

-- local tabSystem = macOS:CreateTabSystem(UDim2.new(0, 20, 0, 260), UDim2.new(0, 460, 0, 120), {"Tab 1", "Tab 2", "Tab 3"})
-- tabSystem.TabSystem.Parent = window.Content

-- -- Add content to tabs
-- local tab1Content = macOS:CreateLabel("This is Tab 1 content", UDim2.new(0, 10, 0, 10), UDim2.new(0, 200, 0, 30))
-- tab1Content.Parent = tabSystem.GetContentFrame(1)

-- local tab2Content = macOS:CreateButton("Tab 2 Button", UDim2.new(0, 10, 0, 10), UDim2.new(0, 120, 0, 30))
-- tab2Content.Parent = tabSystem.GetContentFrame(2)

-- local tab3Content = macOS:CreateToggle("Tab 3 Toggle", UDim2.new(0, 10, 0, 10))
-- tab3Content.Container.Parent = tabSystem.GetContentFrame(3)

return MacOSLib
