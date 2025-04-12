-- RobloxUI Library
-- A sleek dark UI library with purple accents

local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Settings
local settings = {
    mainColor = Color3.fromRGB(30, 30, 30),
    accentColor = Color3.fromRGB(147, 75, 255),
    textColor = Color3.fromRGB(255, 255, 255),
    secondaryColor = Color3.fromRGB(50, 50, 50),
    toggleOnColor = Color3.fromRGB(147, 75, 255),
    toggleOffColor = Color3.fromRGB(80, 80, 80),
    cornerRadius = UDim.new(0, 8),
    fontSize = Enum.FontSize.Size14,
    font = Enum.Font.GothamMedium,
    tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
}

-- Utility Functions
local function createTween(instance, properties)
    local tween = TweenService:Create(instance, settings.tweenInfo, properties)
    return tween
end

function Library:CreateWindow(title)
    title = title or "RobloxUI"
    
    -- Create ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "RobloxUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = game.CoreGui
    
    -- Create Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 450, 0, 300)
    MainFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
    MainFrame.BackgroundColor3 = settings.mainColor
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui
    
    -- Add corner radius
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = settings.cornerRadius
    UICorner.Parent = MainFrame
    
    -- Add gradient border glow
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = settings.accentColor
    UIStroke.Thickness = 1.5
    UIStroke.Parent = MainFrame
    
    -- Create Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 30)
    TitleBar.BackgroundColor3 = settings.secondaryColor
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 8)
    TitleCorner.Parent = TitleBar
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "TitleLabel"
    TitleLabel.Size = UDim2.new(1, -10, 1, 0)
    TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title
    TitleLabel.TextColor3 = settings.textColor
    TitleLabel.TextSize = 16
    TitleLabel.Font = settings.font
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TitleBar
    
    -- Create Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 24, 0, 24)
    CloseButton.Position = UDim2.new(1, -27, 0, 3)
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
    CloseButton.Text = ""
    CloseButton.BorderSizePixel = 0
    CloseButton.Parent = TitleBar
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 12)
    CloseCorner.Parent = CloseButton
    
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    -- Create Tab Container
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(0, 120, 1, -30)
    TabContainer.Position = UDim2.new(0, 0, 0, 30)
    TabContainer.BackgroundColor3 = settings.secondaryColor
    TabContainer.BorderSizePixel = 0
    TabContainer.Parent = MainFrame
    
    local TabContainerCorner = Instance.new("UICorner")
    TabContainerCorner.CornerRadius = UDim.new(0, 8)
    TabContainerCorner.Parent = TabContainer
    
    -- Create Content Container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -130, 1, -40)
    ContentContainer.Position = UDim2.new(0, 125, 0, 35)
    ContentContainer.BackgroundColor3 = settings.mainColor
    ContentContainer.BorderSizePixel = 0
    ContentContainer.Parent = MainFrame
    
    -- Create Command Bar (Search)
    local CommandBar = Instance.new("Frame")
    CommandBar.Name = "CommandBar"
    CommandBar.Size = UDim2.new(1, -10, 0, 30)
    CommandBar.Position = UDim2.new(0, 5, 0, 5)
    CommandBar.BackgroundColor3 = settings.secondaryColor
    CommandBar.BorderSizePixel = 0
    CommandBar.Parent = ContentContainer
    
    local CommandBarCorner = Instance.new("UICorner")
    CommandBarCorner.CornerRadius = UDim.new(0, 8)
    CommandBarCorner.Parent = CommandBar
    
    local SearchIcon = Instance.new("TextLabel")
    SearchIcon.Name = "SearchIcon"
    SearchIcon.Size = UDim2.new(0, 30, 0, 30)
    SearchIcon.BackgroundTransparency = 1
    SearchIcon.Text = "🔍"
    SearchIcon.TextColor3 = settings.textColor
    SearchIcon.TextSize = 16
    SearchIcon.Parent = CommandBar
    
    local SearchBox = Instance.new("TextBox")
    SearchBox.Name = "SearchBox"
    SearchBox.Size = UDim2.new(1, -40, 1, 0)
    SearchBox.Position = UDim2.new(0, 35, 0, 0)
    SearchBox.BackgroundTransparency = 1
    SearchBox.Text = ""
    SearchBox.PlaceholderText = "Type a command or search..."
    SearchBox.TextColor3 = settings.textColor
    SearchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    SearchBox.TextSize = 14
    SearchBox.Font = settings.font
    SearchBox.TextXAlignment = Enum.TextXAlignment.Left
    SearchBox.Parent = CommandBar
    
    -- Create ScrollingFrame for tabs 
    local TabButtonsContainer = Instance.new("ScrollingFrame")
    TabButtonsContainer.Name = "TabButtonsContainer"
    TabButtonsContainer.Size = UDim2.new(1, -10, 1, -15)
    TabButtonsContainer.Position = UDim2.new(0, 5, 0, 10)
    TabButtonsContainer.BackgroundTransparency = 1
    TabButtonsContainer.ScrollBarThickness = 2
    TabButtonsContainer.ScrollBarImageColor3 = settings.accentColor
    TabButtonsContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabButtonsContainer.Parent = TabContainer
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 5)
    UIListLayout.Parent = TabButtonsContainer
    
    local UIPadding = Instance.new("UIPadding")
    UIPadding.PaddingTop = UDim.new(0, 5)
    UIPadding.PaddingLeft = UDim.new(0, 5)
    UIPadding.PaddingRight = UDim.new(0, 5)
    UIPadding.Parent = TabButtonsContainer
    
    -- Window object
    local Window = {}
    Window.Tabs = {}
    Window.ActiveTab = nil
    
    function Window:CreateTab(name)
        -- Create tab button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name .. "TabButton"
        TabButton.Size = UDim2.new(1, 0, 0, 30)
        TabButton.BackgroundColor3 = settings.secondaryColor
        TabButton.Text = name
        TabButton.TextColor3 = settings.textColor
        TabButton.Font = settings.font
        TabButton.TextSize = 14
        TabButton.Parent = TabButtonsContainer
        
        local TabButtonCorner = Instance.new("UICorner")
        TabButtonCorner.CornerRadius = UDim.new(0, 6)
        TabButtonCorner.Parent = TabButton
        
        -- Create tab content frame
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = name .. "TabContent"
        TabContent.Size = UDim2.new(1, -10, 1, -45)
        TabContent.Position = UDim2.new(0, 5, 0, 40)
        TabContent.BackgroundTransparency = 1
        TabContent.ScrollBarThickness = 3
        TabContent.ScrollBarImageColor3 = settings.accentColor
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.Visible = false
        TabContent.Parent = ContentContainer
        
        local ContentUIListLayout = Instance.new("UIListLayout")
        ContentUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ContentUIListLayout.Padding = UDim.new(0, 8)
        ContentUIListLayout.Parent = TabContent
        
        local ContentUIPadding = Instance.new("UIPadding")
        ContentUIPadding.PaddingTop = UDim.new(0, 5)
        ContentUIPadding.PaddingLeft = UDim.new(0, 5)
        ContentUIPadding.PaddingRight = UDim.new(0, 5)
        ContentUIPadding.Parent = TabContent
        
        -- Auto-adjust canvas size
        ContentUIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentUIListLayout.AbsoluteContentSize.Y + 10)
        end)
        
        -- Tab button click
        TabButton.MouseButton1Click:Connect(function()
            if Window.ActiveTab then
                Window.ActiveTab.Content.Visible = false
                Window.ActiveTab.Button.BackgroundColor3 = settings.secondaryColor
            end
            
            TabContent.Visible = true
            TabButton.BackgroundColor3 = settings.accentColor
            
            Window.ActiveTab = {
                Content = TabContent,
                Button = TabButton
            }
        end)
        
        -- Tab object
        local Tab = {}
        Tab.Button = TabButton
        Tab.Content = TabContent
        
        -- Add tab to window tabs
        table.insert(Window.Tabs, Tab)
        
        -- If this is the first tab, activate it
        if #Window.Tabs == 1 then
            TabButton.BackgroundColor3 = settings.accentColor
            TabContent.Visible = true
            Window.ActiveTab = {
                Content = TabContent,
                Button = TabButton
            }
        end
        
        -- Tab components
        function Tab:CreateButton(text, callback)
            callback = callback or function() end
            
            local Button = Instance.new("TextButton")
            Button.Name = text .. "Button"
            Button.Size = UDim2.new(1, 0, 0, 32)
            Button.BackgroundColor3 = settings.secondaryColor
            Button.Text = text
            Button.TextColor3 = settings.textColor
            Button.Font = settings.font
            Button.TextSize = 14
            Button.Parent = TabContent
            
            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 6)
            ButtonCorner.Parent = Button
            
            -- Button effects
            Button.MouseEnter:Connect(function()
                createTween(Button, {BackgroundColor3 = settings.accentColor}):Play()
            end)
            
            Button.MouseLeave:Connect(function()
                createTween(Button, {BackgroundColor3 = settings.secondaryColor}):Play()
            end)
            
            Button.MouseButton1Click:Connect(function()
                callback()
            end)
            
            return Button
        end
        
        function Tab:CreateToggle(text, default, callback)
            default = default or false
            callback = callback or function() end
            
            local Toggle = Instance.new("Frame")
            Toggle.Name = text .. "Toggle"
            Toggle.Size = UDim2.new(1, 0, 0, 32)
            Toggle.BackgroundColor3 = settings.secondaryColor
            Toggle.Parent = TabContent
            
            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(0, 6)
            ToggleCorner.Parent = Toggle
            
            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Name = "ToggleLabel"
            ToggleLabel.Size = UDim2.new(1, -50, 1, 0)
            ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Text = text
            ToggleLabel.TextColor3 = settings.textColor
            ToggleLabel.Font = settings.font
            ToggleLabel.TextSize = 14
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            ToggleLabel.Parent = Toggle
            
            local ToggleButton = Instance.new("Frame")
            ToggleButton.Name = "ToggleButton"
            ToggleButton.Size = UDim2.new(0, 36, 0, 18)
            ToggleButton.Position = UDim2.new(1, -46, 0.5, -9)
            ToggleButton.BackgroundColor3 = default and settings.toggleOnColor or settings.toggleOffColor
            ToggleButton.Parent = Toggle
            
            local ToggleButtonCorner = Instance.new("UICorner")
            ToggleButtonCorner.CornerRadius = UDim.new(1, 0)
            ToggleButtonCorner.Parent = ToggleButton
            
            local ToggleCircle = Instance.new("Frame")
            ToggleCircle.Name = "ToggleCircle"
            ToggleCircle.Size = UDim2.new(0, 14, 0, 14)
            ToggleCircle.Position = UDim2.new(0, default and 19 or 2, 0.5, -7)
            ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ToggleCircle.Parent = ToggleButton
            
            local ToggleCircleCorner = Instance.new("UICorner")
            ToggleCircleCorner.CornerRadius = UDim.new(1, 0)
            ToggleCircleCorner.Parent = ToggleCircle
            
            local toggled = default
            
            local function updateToggle()
                toggled = not toggled
                
                if toggled then
                    createTween(ToggleButton, {BackgroundColor3 = settings.toggleOnColor}):Play()
                    createTween(ToggleCircle, {Position = UDim2.new(0, 19, 0.5, -7)}):Play()
                else
                    createTween(ToggleButton, {BackgroundColor3 = settings.toggleOffColor}):Play()
                    createTween(ToggleCircle, {Position = UDim2.new(0, 2, 0.5, -7)}):Play()
                end
                
                callback(toggled)
            end
            
            -- Toggle clickable
            Toggle.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    updateToggle()
                end
            end)
            
            return {
                Set = function(value)
                    if value ~= toggled then
                        updateToggle()
                    end
                end,
                Get = function()
                    return toggled
                end
            }
        end
        
        function Tab:CreateSlider(text, min, max, default, callback)
            min = min or 0
            max = max or 100
            default = default or min
            callback = callback or function() end
            
            default = math.clamp(default, min, max)
            
            local Slider = Instance.new("Frame")
            Slider.Name = text .. "Slider"
            Slider.Size = UDim2.new(1, 0, 0, 45)
            Slider.BackgroundColor3 = settings.secondaryColor
            Slider.Parent = TabContent
            
            local SliderCorner = Instance.new("UICorner")
            SliderCorner.CornerRadius = UDim.new(0, 6)
            SliderCorner.Parent = Slider
            
            local SliderLabel = Instance.new("TextLabel")
            SliderLabel.Name = "SliderLabel"
            SliderLabel.Size = UDim2.new(1, -10, 0, 20)
            SliderLabel.Position = UDim2.new(0, 10, 0, 5)
            SliderLabel.BackgroundTransparency = 1
            SliderLabel.Text = text
            SliderLabel.TextColor3 = settings.textColor
            SliderLabel.Font = settings.font
            SliderLabel.TextSize = 14
            SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            SliderLabel.Parent = Slider
            
            local SliderValue = Instance.new("TextLabel")
            SliderValue.Name = "SliderValue"
            SliderValue.Size = UDim2.new(0, 30, 0, 20)
            SliderValue.Position = UDim2.new(1, -40, 0, 5)
            SliderValue.BackgroundTransparency = 1
            SliderValue.Text = tostring(default)
            SliderValue.TextColor3 = settings.textColor
            SliderValue.Font = settings.font
            SliderValue.TextSize = 14
            SliderValue.TextXAlignment = Enum.TextXAlignment.Right
            SliderValue.Parent = Slider
            
            local SliderBackground = Instance.new("Frame")
            SliderBackground.Name = "SliderBackground"
            SliderBackground.Size = UDim2.new(1, -20, 0, 6)
            SliderBackground.Position = UDim2.new(0, 10, 0, 30)
            SliderBackground.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            SliderBackground.BorderSizePixel = 0
            SliderBackground.Parent = Slider
            
            local SliderBackgroundCorner = Instance.new("UICorner")
            SliderBackgroundCorner.CornerRadius = UDim.new(1, 0)
            SliderBackgroundCorner.Parent = SliderBackground
            
            local SliderFill = Instance.new("Frame")
            SliderFill.Name = "SliderFill"
            SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            SliderFill.BackgroundColor3 = settings.accentColor
            SliderFill.BorderSizePixel = 0
            SliderFill.Parent = SliderBackground
            
            local SliderFillCorner = Instance.new("UICorner")
            SliderFillCorner.CornerRadius = UDim.new(1, 0)
            SliderFillCorner.Parent = SliderFill
            
            local SliderThumb = Instance.new("Frame")
            SliderThumb.Name = "SliderThumb"
            SliderThumb.Size = UDim2.new(0, 12, 0, 12)
            SliderThumb.Position = UDim2.new((default - min) / (max - min), -6, 0.5, -6)
            SliderThumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SliderThumb.Parent = SliderBackground
            
            local SliderThumbCorner = Instance.new("UICorner")
            SliderThumbCorner.CornerRadius = UDim.new(1, 0)
            SliderThumbCorner.Parent = SliderThumb
            
            local dragging = false
            
            local function updateSlider(input)
                local pos = math.clamp((input.Position.X - SliderBackground.AbsolutePosition.X) / SliderBackground.AbsoluteSize.X, 0, 1)
                local value = math.floor(min + (max - min) * pos)
                
                SliderValue.Text = tostring(value)
                SliderFill.Size = UDim2.new(pos, 0, 1, 0)
                SliderThumb.Position = UDim2.new(pos, -6, 0.5, -6)
                
                callback(value)
            end
            
            SliderBackground.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    updateSlider(input)
                end
            end)
            
            SliderBackground.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    updateSlider(input)
                end
            end)
            
            return {
                Set = function(value)
                    value = math.clamp(value, min, max)
                    local pos = (value - min) / (max - min)
                    
                    SliderValue.Text = tostring(value)
                    SliderFill.Size = UDim2.new(pos, 0, 1, 0)
                    SliderThumb.Position = UDim2.new(pos, -6, 0.5, -6)
                    
                    callback(value)
                end,
                Get = function()
                    return tonumber(SliderValue.Text)
                end
            }
        end
        
        function Tab:CreateLabel(text)
            local Label = Instance.new("TextLabel")
            Label.Name = "Label"
            Label.Size = UDim2.new(1, 0, 0, 25)
            Label.BackgroundColor3 = settings.secondaryColor
            Label.Text = text
            Label.TextColor3 = settings.textColor
            Label.Font = settings.font
            Label.TextSize = 14
            Label.Parent = TabContent
            
            local LabelCorner = Instance.new("UICorner")
            LabelCorner.CornerRadius = UDim.new(0, 6)
            LabelCorner.Parent = Label
            
            return Label
        end
        
        function Tab:CreateDropdown(text, options, callback)
            options = options or {}
            callback = callback or function() end
            
            local Dropdown = Instance.new("Frame")
            Dropdown.Name = text .. "Dropdown"
            Dropdown.Size = UDim2.new(1, 0, 0, 32)
            Dropdown.BackgroundColor3 = settings.secondaryColor
            Dropdown.ClipsDescendants = true
            Dropdown.Parent = TabContent
            
            local DropdownCorner = Instance.new("UICorner")
            DropdownCorner.CornerRadius = UDim.new(0, 6)
            DropdownCorner.Parent = Dropdown
            
            local DropdownLabel = Instance.new("TextLabel")
            DropdownLabel.Name = "DropdownLabel"
            DropdownLabel.Size = UDim2.new(1, -50, 1, 0)
            DropdownLabel.Position = UDim2.new(0, 10, 0, 0)
            DropdownLabel.BackgroundTransparency = 1
            DropdownLabel.Text = text
            DropdownLabel.TextColor3 = settings.textColor
            DropdownLabel.Font = settings.font
            DropdownLabel.TextSize = 14
            DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
            DropdownLabel.Parent = Dropdown
            
            local DropdownArrow = Instance.new("TextLabel")
            DropdownArrow.Name = "DropdownArrow"
            DropdownArrow.Size = UDim2.new(0, 30, 0, 30)
            DropdownArrow.Position = UDim2.new(1, -35, 0, 0)
            DropdownArrow.BackgroundTransparency = 1
            DropdownArrow.Text = "▼"
            DropdownArrow.TextColor3 = settings.textColor
            DropdownArrow.Font = settings.font
            DropdownArrow.TextSize = 14
            DropdownArrow.Parent = Dropdown
            
            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Name = "DropdownButton"
            DropdownButton.Size = UDim2.new(1, 0, 0, 32)
            DropdownButton.BackgroundTransparency = 1
            DropdownButton.Text = ""
            DropdownButton.Parent = Dropdown
            
            local OptionContainer = Instance.new("Frame")
            OptionContainer.Name = "OptionContainer"
            OptionContainer.Size = UDim2.new(1, -10, 0, 0)
            OptionContainer.Position = UDim2.new(0, 5, 0, 35)
            OptionContainer.BackgroundTransparency = 1
            OptionContainer.Parent = Dropdown
            
            local OptionUIListLayout = Instance.new("UIListLayout")
            OptionUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            OptionUIListLayout.Padding = UDim.new(0, 5)
            OptionUIListLayout.Parent = OptionContainer
            
            -- Create option buttons
            local function refreshOptions(opts)
                -- Clear existing options
                for _, child in pairs(OptionContainer:GetChildren()) do
                    if child:IsA("TextButton") then
                        child:Destroy()
                    end
                end
                
                -- Add new options
                for _, option in ipairs(opts) do
                    local OptionButton = Instance.new("TextButton")
                    OptionButton.Name = option .. "Option"
                    OptionButton.Size = UDim2.new(1, 0, 0, 25)
                    OptionButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                    OptionButton.Text = option
                    OptionButton.TextColor3 = settings.textColor
                    OptionButton.Font = settings.font
                    OptionButton.TextSize = 12
                    OptionButton.Parent = OptionContainer
                    
                    local OptionCorner = Instance.new("UICorner")
                    OptionCorner.CornerRadius = UDim.new(0, 4)
                    OptionCorner.Parent = OptionButton
                    
                    OptionButton.MouseButton1Click:Connect(function()
                        DropdownLabel.Text = text .. ": " .. option
                        callback(option)
                        
                        -- Close dropdown
                        createTween(Dropdown, {Size = UDim2.new(1, 0, 0, 32)}):Play()
                        createTween(DropdownArrow, {Rotation = 0}):Play()
                    end)
                end
            end
            
            refreshOptions(options)
            
            local expanded = false
            
            DropdownButton.MouseButton1Click:Connect(function()
                expanded = not expanded
                
                if expanded then
                    local optionsHeight = (#options * 30)
                    createTween(Dropdown, {Size = UDim2.new(1, 0, 0, 40 + optionsHeight)}):Play()
                    createTween(DropdownArrow, {Rotation = 180}):Play()
                else
                    createTween(Dropdown, {Size = UDim2.new(1, 0, 0, 32)}):Play()
                    createTween(DropdownArrow, {Rotation = 0}):Play()
                end
            end)
            
            return {
                Refresh = function(newOptions)
                    options = newOptions
                    refreshOptions(newOptions)
                    
                    -- Close dropdown
                    expanded = false
                    createTween(Dropdown, {Size = UDim2.new(1, 0, 0, 32)}):Play()
                    createTween(DropdownArrow, {Rotation = 0}):Play()
                end,
                SetText = function(newText)
                    DropdownLabel.Text = newText
                end
            }
        end
        
        return Tab
    end
    
    return Window
end

return Library
