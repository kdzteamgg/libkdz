-- SimpleUI
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local SimpleUI = {}
SimpleUI.__index = SimpleUI

-- Cài đặt màu sắc chủ đạo
SimpleUI.Colors = {
    Background = Color3.fromRGB(30, 30, 30),
    DarkBackground = Color3.fromRGB(20, 20, 20),
    LightBackground = Color3.fromRGB(40, 40, 40),
    TextColor = Color3.fromRGB(255, 255, 255),
    AccentColor = Color3.fromRGB(0, 120, 255),
    ErrorColor = Color3.fromRGB(255, 0, 0),
    SuccessColor = Color3.fromRGB(0, 255, 0)
}

function SimpleUI.new(title)
    local UILibrary = {}
    setmetatable(UILibrary, SimpleUI)
    
    -- Tạo giao diện chính
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SimpleUI"
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    
    -- Main Frame
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Parent = ScreenGui
    Main.BackgroundColor3 = SimpleUI.Colors.Background
    Main.BorderSizePixel = 0
    Main.Position = UDim2.new(0.5, -300, 0.5, -175)
    Main.Size = UDim2.new(0, 600, 0, 350)
    Main.Active = true
    Main.Draggable = true
    
    -- Round corners
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = Main
    
    -- Header
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Parent = Main
    Header.BackgroundColor3 = SimpleUI.Colors.DarkBackground
    Header.BorderSizePixel = 0
    Header.Size = UDim2.new(1, 0, 0, 30)
    
    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 6)
    HeaderCorner.Parent = Header
    
    local HeaderFix = Instance.new("Frame")
    HeaderFix.Name = "HeaderFix"
    HeaderFix.Parent = Header
    HeaderFix.BackgroundColor3 = SimpleUI.Colors.DarkBackground
    HeaderFix.BorderSizePixel = 0
    HeaderFix.Position = UDim2.new(0, 0, 0.5, 0)
    HeaderFix.Size = UDim2.new(1, 0, 0.5, 0)
    
    -- Title
    local TitleText = Instance.new("TextLabel")
    TitleText.Name = "Title"
    TitleText.Parent = Header
    TitleText.BackgroundTransparency = 1
    TitleText.Position = UDim2.new(0, 10, 0, 0)
    TitleText.Size = UDim2.new(1, -40, 1, 0)
    TitleText.Font = Enum.Font.SourceSansBold
    TitleText.Text = title or "SimpleUI Library"
    TitleText.TextColor3 = SimpleUI.Colors.TextColor
    TitleText.TextSize = 18
    TitleText.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Parent = Header
    CloseButton.BackgroundTransparency = 1
    CloseButton.Position = UDim2.new(1, -30, 0, 0)
    CloseButton.Size = UDim2.new(0, 30, 1, 0)
    CloseButton.Font = Enum.Font.SourceSansBold
    CloseButton.Text = "X"
    CloseButton.TextColor3 = SimpleUI.Colors.TextColor
    CloseButton.TextSize = 18
    
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    -- Tab Container
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Parent = Main
    TabContainer.BackgroundColor3 = SimpleUI.Colors.DarkBackground
    TabContainer.BorderSizePixel = 0
    TabContainer.Position = UDim2.new(0, 0, 0, 30)
    TabContainer.Size = UDim2.new(0, 150, 1, -30)
    
    local TabContainerCorner = Instance.new("UICorner")
    TabContainerCorner.CornerRadius = UDim.new(0, 6)
    TabContainerCorner.Parent = TabContainer
    
    local TabContainerFix = Instance.new("Frame")
    TabContainerFix.Name = "TabContainerFix"
    TabContainerFix.Parent = TabContainer
    TabContainerFix.BackgroundColor3 = SimpleUI.Colors.DarkBackground
    TabContainerFix.BorderSizePixel = 0
    TabContainerFix.Position = UDim2.new(0.5, 0, 0, 0)
    TabContainerFix.Size = UDim2.new(0.5, 0, 1, 0)
    
    -- Tab Buttons List
    local TabButtonsList = Instance.new("ScrollingFrame")
    TabButtonsList.Name = "TabButtonsList"
    TabButtonsList.Parent = TabContainer
    TabButtonsList.BackgroundTransparency = 1
    TabButtonsList.Position = UDim2.new(0, 0, 0, 10)
    TabButtonsList.Size = UDim2.new(1, 0, 1, -10)
    TabButtonsList.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabButtonsList.ScrollBarThickness = 2
    TabButtonsList.ScrollBarImageColor3 = SimpleUI.Colors.AccentColor
    TabButtonsList.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Left
    
    local TabButtonsListLayout = Instance.new("UIListLayout")
    TabButtonsListLayout.Parent = TabButtonsList
    TabButtonsListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TabButtonsListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabButtonsListLayout.Padding = UDim.new(0, 5)
    
    -- Content Container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Parent = Main
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Position = UDim2.new(0, 150, 0, 30)
    ContentContainer.Size = UDim2.new(1, -150, 1, -30)
    
    -- Store references
    UILibrary.ScreenGui = ScreenGui
    UILibrary.Main = Main
    UILibrary.Header = Header
    UILibrary.TabContainer = TabContainer
    UILibrary.TabButtonsList = TabButtonsList
    UILibrary.ContentContainer = ContentContainer
    UILibrary.Tabs = {}
    UILibrary.ActiveTab = nil
    
    return UILibrary
end

function SimpleUI:CreateTab(name)
    local TabButton = Instance.new("TextButton")
    TabButton.Name = name
    TabButton.Parent = self.TabButtonsList
    TabButton.BackgroundColor3 = SimpleUI.Colors.LightBackground
    TabButton.BorderSizePixel = 0
    TabButton.Size = UDim2.new(0.9, 0, 0, 30)
    TabButton.Font = Enum.Font.SourceSansBold
    TabButton.Text = name
    TabButton.TextColor3 = SimpleUI.Colors.TextColor
    TabButton.TextSize = 16
    TabButton.AutoButtonColor = false
    
    local TabButtonCorner = Instance.new("UICorner")
    TabButtonCorner.CornerRadius = UDim.new(0, 4)
    TabButtonCorner.Parent = TabButton
    
    -- Content Frame
    local TabContent = Instance.new("ScrollingFrame")
    TabContent.Name = name.."Content"
    TabContent.Parent = self.ContentContainer
    TabContent.BackgroundTransparency = 1
    TabContent.BorderSizePixel = 0
    TabContent.Size = UDim2.new(1, 0, 1, 0)
    TabContent.ScrollBarThickness = 2
    TabContent.ScrollBarImageColor3 = SimpleUI.Colors.AccentColor
    TabContent.Visible = false
    TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    
    local TabContentPadding = Instance.new("UIPadding")
    TabContentPadding.Parent = TabContent
    TabContentPadding.PaddingLeft = UDim.new(0, 10)
    TabContentPadding.PaddingRight = UDim.new(0, 10)
    TabContentPadding.PaddingTop = UDim.new(0, 10)
    TabContentPadding.PaddingBottom = UDim.new(0, 10)
    
    local TabContentLayout = Instance.new("UIListLayout")
    TabContentLayout.Parent = TabContent
    TabContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabContentLayout.Padding = UDim.new(0, 8)
    
    -- Auto update canvas size
    TabContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContent.CanvasSize = UDim2.new(0, 0, 0, TabContentLayout.AbsoluteContentSize.Y + 20)
    end)
    
    -- Tab logic
    TabButton.MouseButton1Click:Connect(function()
        for _, tab in pairs(self.Tabs) do
            tab.Button.BackgroundColor3 = SimpleUI.Colors.LightBackground
            tab.Content.Visible = false
        end
        
        TabButton.BackgroundColor3 = SimpleUI.Colors.AccentColor
        TabContent.Visible = true
        self.ActiveTab = name
    end)
    
    -- Store tab references
    local Tab = {
        Button = TabButton,
        Content = TabContent,
        ContentLayout = TabContentLayout,
        Elements = {}
    }
    
    self.Tabs[name] = Tab
    
    -- Activate this tab if it's the first one
    if self.ActiveTab == nil then
        TabButton.BackgroundColor3 = SimpleUI.Colors.AccentColor
        TabContent.Visible = true
        self.ActiveTab = name
    end
    
    -- Tab API
    local TabAPI = {}

    function TabAPI:CreateSlider(title, min, max, default, callback)
        default = default or min
        callback = callback or function() end
    
        local SliderFrame = Instance.new("Frame")
        SliderFrame.Name = title.."SliderFrame"
        SliderFrame.Parent = TabContent
        SliderFrame.BackgroundColor3 = SimpleUI.Colors.LightBackground
        SliderFrame.Size = UDim2.new(1, 0, 0, 35)
    
        local SliderCorner = Instance.new("UICorner")
        SliderCorner.CornerRadius = UDim.new(0, 4)
        SliderCorner.Parent = SliderFrame
    
        local SliderLabel = Instance.new("TextLabel")
        SliderLabel.Name = "Label"
        SliderLabel.Parent = SliderFrame
        SliderLabel.BackgroundTransparency = 1
        SliderLabel.Position = UDim2.new(0, 10, 0, 0)
        SliderLabel.Size = UDim2.new(0.5, -10, 1, 0)
        SliderLabel.Font = Enum.Font.SourceSansSemibold
        SliderLabel.Text = title
        SliderLabel.TextColor3 = SimpleUI.Colors.TextColor
        SliderLabel.TextSize = 16
        SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    
        -- Thêm ValueLabel để hiển thị giá trị hiện tại
        local ValueLabel = Instance.new("TextLabel")
        ValueLabel.Name = "ValueLabel"
        ValueLabel.Parent = SliderFrame
        ValueLabel.BackgroundTransparency = 1
        ValueLabel.Position = UDim2.new(0.9, 0, 0, 0)
        ValueLabel.Size = UDim2.new(0.1, 0, 1, 0)
        ValueLabel.Font = Enum.Font.SourceSansSemibold
        ValueLabel.Text = tostring(math.floor(default * 10) / 10)
        ValueLabel.TextColor3 = SimpleUI.Colors.TextColor
        ValueLabel.TextSize = 16
        ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    
        local SliderBar = Instance.new("Frame")
        SliderBar.Name = "Bar"
        SliderBar.Parent = SliderFrame
        SliderBar.BackgroundColor3 = SimpleUI.Colors.DarkBackground
        SliderBar.Position = UDim2.new(0.5, 0, 0.5, -5)
        SliderBar.Size = UDim2.new(0.4, 0, 0, 10)
        
        local SliderBarCorner = Instance.new("UICorner")
        SliderBarCorner.CornerRadius = UDim.new(0, 4)
        SliderBarCorner.Parent = SliderBar
        
        -- Thêm thanh fill để hiển thị tiến trình
        local SliderFill = Instance.new("Frame")
        SliderFill.Name = "Fill"
        SliderFill.Parent = SliderBar
        SliderFill.BackgroundColor3 = SimpleUI.Colors.AccentColor
        SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        SliderFill.BorderSizePixel = 0
        
        local SliderFillCorner = Instance.new("UICorner")
        SliderFillCorner.CornerRadius = UDim.new(0, 4)
        SliderFillCorner.Parent = SliderFill
    
        local SliderHandle = Instance.new("Frame")
        SliderHandle.Name = "Handle"
        SliderHandle.Parent = SliderBar
        SliderHandle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        SliderHandle.Position = UDim2.new((default - min) / (max - min), -5, 0.5, -5)
        SliderHandle.Size = UDim2.new(0, 10, 0, 10)
        SliderHandle.ZIndex = 2
        
        local SliderHandleCorner = Instance.new("UICorner")
        SliderHandleCorner.CornerRadius = UDim.new(1, 0)
        SliderHandleCorner.Parent = SliderHandle
    
        -- Tạo hitbox lớn hơn cho slider để dễ kéo
        local SliderHitbox = Instance.new("TextButton")
        SliderHitbox.Name = "Hitbox"
        SliderHitbox.Parent = SliderBar
        SliderHitbox.BackgroundTransparency = 1
        SliderHitbox.Size = UDim2.new(1, 10, 1, 20)
        SliderHitbox.Position = UDim2.new(0, -5, 0, -10)
        SliderHitbox.Text = ""
        SliderHitbox.ZIndex = 1
    
        local value = default
        local isDragging = false
        
        local function UpdateValue(newValue)
            value = math.clamp(newValue, min, max)
            -- Làm tròn đến 1 chữ số thập phân cho hiển thị
            ValueLabel.Text = tostring(math.floor(value * 10) / 10)
            
            -- Cập nhật vị trí handle và fill
            local percent = (value - min) / (max - min)
            SliderHandle.Position = UDim2.new(percent, -5, 0.5, -5)
            SliderFill.Size = UDim2.new(percent, 0, 1, 0)
            
            callback(value)
        end
        
        -- Xử lý sự kiện kéo
        SliderHitbox.MouseButton1Down:Connect(function()
            isDragging = true
            
            -- Tính toán giá trị mới dựa trên vị trí chuột
            local mousePos = UserInputService:GetMouseLocation()
            local sliderPos = SliderBar.AbsolutePosition
            local sliderSize = SliderBar.AbsoluteSize
            
            local relativeX = math.clamp((mousePos.X - sliderPos.X) / sliderSize.X, 0, 1)
            local newValue = min + (max - min) * relativeX
            
            UpdateValue(newValue)
        end)
        
        -- Xử lý sự kiện di chuyển chuột khi đang kéo
        local moveConnection
        SliderHitbox.MouseButton1Down:Connect(function()
            if moveConnection then moveConnection:Disconnect() end
            
            moveConnection = UserInputService.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement and isDragging then
                    local mousePos = UserInputService:GetMouseLocation()
                    local sliderPos = SliderBar.AbsolutePosition
                    local sliderSize = SliderBar.AbsoluteSize
                    
                    local relativeX = math.clamp((mousePos.X - sliderPos.X) / sliderSize.X, 0, 1)
                    local newValue = min + (max - min) * relativeX
                    
                    UpdateValue(newValue)
                end
            end)
        end)
        
        -- Xử lý sự kiện nhả chuột
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 and isDragging then
                isDragging = false
                if moveConnection then
                    moveConnection:Disconnect()
                    moveConnection = nil
                end
            end
        end)
        
        -- Xử lý sự kiện khi người dùng click trực tiếp vào thanh
        SliderBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                local mousePos = UserInputService:GetMouseLocation()
                local sliderPos = SliderBar.AbsolutePosition
                local sliderSize = SliderBar.AbsoluteSize
                
                local relativeX = math.clamp((mousePos.X - sliderPos.X) / sliderSize.X, 0, 1)
                local newValue = min + (max - min) * relativeX
                
                UpdateValue(newValue)
            end
        end)
    
        -- API
        local SliderAPI = {}
    
        function SliderAPI:Set(newValue)
            UpdateValue(newValue)
        end
    
        function SliderAPI:Get()
            return value
        end
    
        return SliderAPI
    end

    -- Thêm nút thu nhỏ (-) vào Main
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.Parent = Header
    MinimizeButton.BackgroundTransparency = 1
    MinimizeButton.Position = UDim2.new(1, -60, 0, 0)
    MinimizeButton.Size = UDim2.new(0, 30, 1, 0)
    MinimizeButton.Font = Enum.Font.SourceSansBold
    MinimizeButton.Text = "-"
    MinimizeButton.TextColor3 = SimpleUI.Colors.TextColor
    MinimizeButton.TextSize = 18
    
    MinimizeButton.MouseButton1Click:Connect(function()
        Main.Visible = not Main.Visible
    end)

    -- Create Button
    function TabAPI:CreateButton(title, callback)
        callback = callback or function() end
        
        local ButtonFrame = Instance.new("Frame")
        ButtonFrame.Name = title.."ButtonFrame"
        ButtonFrame.Parent = TabContent
        ButtonFrame.BackgroundColor3 = SimpleUI.Colors.LightBackground
        ButtonFrame.Size = UDim2.new(1, 0, 0, 35)
        
        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 4)
        ButtonCorner.Parent = ButtonFrame
        
        local ButtonLabel = Instance.new("TextLabel")
        ButtonLabel.Name = "Label"
        ButtonLabel.Parent = ButtonFrame
        ButtonLabel.BackgroundTransparency = 1
        ButtonLabel.Position = UDim2.new(0, 10, 0, 0)
        ButtonLabel.Size = UDim2.new(1, -20, 1, 0)
        ButtonLabel.Font = Enum.Font.SourceSansSemibold
        ButtonLabel.Text = title
        ButtonLabel.TextColor3 = SimpleUI.Colors.TextColor
        ButtonLabel.TextSize = 16
        ButtonLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        local Button = Instance.new("TextButton")
        Button.Name = "Button"
        Button.Parent = ButtonFrame
        Button.BackgroundColor3 = SimpleUI.Colors.AccentColor
        Button.Position = UDim2.new(1, -80, 0.5, -12)
        Button.Size = UDim2.new(0, 70, 0, 24)
        Button.Font = Enum.Font.SourceSansBold
        Button.Text = "Click"
        Button.TextColor3 = SimpleUI.Colors.TextColor
        Button.TextSize = 14
        Button.AutoButtonColor = false
        
        local ButtonActionCorner = Instance.new("UICorner")
        ButtonActionCorner.CornerRadius = UDim.new(0, 4)
        ButtonActionCorner.Parent = Button
        
        -- Button animation
        Button.MouseEnter:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 150, 255)}):Play()
        end)
        
        Button.MouseLeave:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = SimpleUI.Colors.AccentColor}):Play()
        end)
        
        Button.MouseButton1Down:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(0, 80, 180)}):Play()
        end)
        
        Button.MouseButton1Up:Connect(function()
            TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(50, 150, 255)}):Play()
        end)
        
        Button.MouseButton1Click:Connect(function()
            callback()
        end)
        
        return Button
    end
    
    -- Create Toggle
    function TabAPI:CreateToggle(title, default, callback)
        default = default or false
        callback = callback or function() end
        
        local value = default
        
        local ToggleFrame = Instance.new("Frame")
        ToggleFrame.Name = title.."ToggleFrame"
        ToggleFrame.Parent = TabContent
        ToggleFrame.BackgroundColor3 = SimpleUI.Colors.LightBackground
        ToggleFrame.Size = UDim2.new(1, 0, 0, 35)
        
        local ToggleCorner = Instance.new("UICorner")
        ToggleCorner.CornerRadius = UDim.new(0, 4)
        ToggleCorner.Parent = ToggleFrame
        
        local ToggleLabel = Instance.new("TextLabel")
        ToggleLabel.Name = "Label"
        ToggleLabel.Parent = ToggleFrame
        ToggleLabel.BackgroundTransparency = 1
        ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
        ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
        ToggleLabel.Font = Enum.Font.SourceSansSemibold
        ToggleLabel.Text = title
        ToggleLabel.TextColor3 = SimpleUI.Colors.TextColor
        ToggleLabel.TextSize = 16
        ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        local ToggleBackground = Instance.new("Frame")
        ToggleBackground.Name = "Background"
        ToggleBackground.Parent = ToggleFrame
        ToggleBackground.BackgroundColor3 = SimpleUI.Colors.DarkBackground
        ToggleBackground.Position = UDim2.new(1, -50, 0.5, -10)
        ToggleBackground.Size = UDim2.new(0, 40, 0, 20)
        
        local ToggleBackgroundCorner = Instance.new("UICorner")
        ToggleBackgroundCorner.CornerRadius = UDim.new(1, 0)
        ToggleBackgroundCorner.Parent = ToggleBackground
        
        local ToggleIndicator = Instance.new("Frame")
        ToggleIndicator.Name = "Indicator"
        ToggleIndicator.Parent = ToggleBackground
        ToggleIndicator.BackgroundColor3 = SimpleUI.Colors.TextColor
        ToggleIndicator.Position = UDim2.new(0, 2, 0.5, -8)
        ToggleIndicator.Size = UDim2.new(0, 16, 0, 16)
        
        local ToggleIndicatorCorner = Instance.new("UICorner")
        ToggleIndicatorCorner.CornerRadius = UDim.new(1, 0)
        ToggleIndicatorCorner.Parent = ToggleIndicator
        
        local ToggleButton = Instance.new("TextButton")
        ToggleButton.Name = "Button"
        ToggleButton.Parent = ToggleFrame
        ToggleButton.BackgroundTransparency = 1
        ToggleButton.Position = UDim2.new(1, -50, 0.5, -10)
        ToggleButton.Size = UDim2.new(0, 40, 0, 20)
        ToggleButton.Font = Enum.Font.SourceSans
        ToggleButton.Text = ""
        ToggleButton.TextColor3 = SimpleUI.Colors.TextColor
        ToggleButton.TextSize = 14
        
        -- Update toggle appearance
        local function UpdateToggle()
            if value then
                TweenService:Create(ToggleBackground, TweenInfo.new(0.2), {BackgroundColor3 = SimpleUI.Colors.AccentColor}):Play()
                TweenService:Create(ToggleIndicator, TweenInfo.new(0.2), {Position = UDim2.new(0, 22, 0.5, -8)}):Play()
            else
                TweenService:Create(ToggleBackground, TweenInfo.new(0.2), {BackgroundColor3 = SimpleUI.Colors.DarkBackground}):Play()
                TweenService:Create(ToggleIndicator, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -8)}):Play()
            end
        end
        
        -- Set initial state
        UpdateToggle()
        
        ToggleButton.MouseButton1Click:Connect(function()
            value = not value
            UpdateToggle()
            callback(value)
        end)
        
        -- API
        local ToggleAPI = {}
        
        function ToggleAPI:Set(newValue)
            value = newValue
            UpdateToggle()
            callback(value)
        end
        
        function ToggleAPI:Get()
            return value
        end
        
        return ToggleAPI
    end
    
    -- Create Dropdown
    function TabAPI:CreateDropdown(title, options, default, callback)
        options = options or {}
        default = default or options[1] or ""
        callback = callback or function() end
        
        local value = default
        local opened = false
        
        local DropdownFrame = Instance.new("Frame")
        DropdownFrame.Name = title.."DropdownFrame"
        DropdownFrame.Parent = TabContent
        DropdownFrame.BackgroundColor3 = SimpleUI.Colors.LightBackground
        DropdownFrame.Size = UDim2.new(1, 0, 0, 35)
        DropdownFrame.ClipsDescendants = true
        
        local DropdownCorner = Instance.new("UICorner")
        DropdownCorner.CornerRadius = UDim.new(0, 4)
        DropdownCorner.Parent = DropdownFrame
        
        local DropdownLabel = Instance.new("TextLabel")
        DropdownLabel.Name = "Label"
        DropdownLabel.Parent = DropdownFrame
        DropdownLabel.BackgroundTransparency = 1
        DropdownLabel.Position = UDim2.new(0, 10, 0, 0)
        DropdownLabel.Size = UDim2.new(1, -20, 0, 35)
        DropdownLabel.Font = Enum.Font.SourceSansSemibold
        DropdownLabel.Text = title
        DropdownLabel.TextColor3 = SimpleUI.Colors.TextColor
        DropdownLabel.TextSize = 16
        DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        local SelectedText = Instance.new("TextLabel")
        SelectedText.Name = "Selected"
        SelectedText.Parent = DropdownFrame
        SelectedText.BackgroundTransparency = 1
        SelectedText.Position = UDim2.new(1, -130, 0, 0)
        SelectedText.Size = UDim2.new(0, 100, 0, 35)
        SelectedText.Font = Enum.Font.SourceSans
        SelectedText.Text = value
        SelectedText.TextColor3 = SimpleUI.Colors.TextColor
        SelectedText.TextSize = 15
        SelectedText.TextXAlignment = Enum.TextXAlignment.Right
        
        local DropdownIcon = Instance.new("TextLabel")
        DropdownIcon.Name = "Icon"
        DropdownIcon.Parent = DropdownFrame
        DropdownIcon.BackgroundTransparency = 1
        DropdownIcon.Position = UDim2.new(1, -30, 0, 0)
        DropdownIcon.Size = UDim2.new(0, 30, 0, 35)
        DropdownIcon.Font = Enum.Font.SourceSansBold
        DropdownIcon.Text = "▼"
        DropdownIcon.TextColor3 = SimpleUI.Colors.TextColor
        DropdownIcon.TextSize = 14
        DropdownIcon.TextYAlignment = Enum.TextYAlignment.Center
        
        local OptionContainer = Instance.new("Frame")
        OptionContainer.Name = "OptionContainer"
        OptionContainer.Parent = DropdownFrame
        OptionContainer.BackgroundColor3 = SimpleUI.Colors.DarkBackground
        OptionContainer.BorderSizePixel = 0
        OptionContainer.Position = UDim2.new(0, 0, 0, 35)
        OptionContainer.Size = UDim2.new(1, 0, 0, 0)
        
        local OptionList = Instance.new("UIListLayout")
        OptionList.Parent = OptionContainer
        OptionList.SortOrder = Enum.SortOrder.LayoutOrder
        
        -- Create options
        for i, option in ipairs(options) do
            local OptionButton = Instance.new("TextButton")
            OptionButton.Name = option
            OptionButton.Parent = OptionContainer
            OptionButton.BackgroundColor3 = SimpleUI.Colors.DarkBackground
            OptionButton.Size = UDim2.new(1, 0, 0, 25)
            OptionButton.Font = Enum.Font.SourceSans
            OptionButton.Text = option
            OptionButton.TextColor3 = SimpleUI.Colors.TextColor
            OptionButton.TextSize = 15
            OptionButton.BorderSizePixel = 0
            
            OptionButton.MouseEnter:Connect(function()
                TweenService:Create(OptionButton, TweenInfo.new(0.1), {BackgroundColor3 = SimpleUI.Colors.LightBackground}):Play()
            end)
            
            OptionButton.MouseLeave:Connect(function()
                TweenService:Create(OptionButton, TweenInfo.new(0.1), {BackgroundColor3 = SimpleUI.Colors.DarkBackground}):Play()
            end)
            
            OptionButton.MouseButton1Click:Connect(function()
                value = option
                SelectedText.Text = option
                callback(option)
                
                -- Close dropdown
                TweenService:Create(DropdownFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 35)}):Play()
                TweenService:Create(DropdownIcon, TweenInfo.new(0.2), {Rotation = 0}):Play()
                opened = false
            end)
        end
        
        -- Dropdown open/close button
        local DropdownButton = Instance.new("TextButton")
        DropdownButton.Name = "Button"
        DropdownButton.Parent = DropdownFrame
        DropdownButton.BackgroundTransparency = 1
        DropdownButton.Size = UDim2.new(1, 0, 0, 35)
        DropdownButton.Font = Enum.Font.SourceSans
        DropdownButton.Text = ""
        DropdownButton.TextColor3 = SimpleUI.Colors.TextColor
        DropdownButton.TextSize = 14
        
        DropdownButton.MouseButton1Click:Connect(function()
            opened = not opened
            
            if opened then
                local optionsHeight = #options * 25
                TweenService:Create(DropdownFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 35 + optionsHeight)}):Play()
                TweenService:Create(DropdownIcon, TweenInfo.new(0.2), {Rotation = 180}):Play()
            else
                TweenService:Create(DropdownFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 35)}):Play()
                TweenService:Create(DropdownIcon, TweenInfo.new(0.2), {Rotation = 0}):Play()
            end
        end)
        
        -- API
        local DropdownAPI = {}
        
        function DropdownAPI:Set(newValue)
            if table.find(options, newValue) then
                value = newValue
                SelectedText.Text = newValue
                callback(value)
            end
        end
        
        function DropdownAPI:Get()
            return value
        end
        
        function DropdownAPI:Refresh(newOptions, keepCurrent)
            options = newOptions
            
            -- Clear option container
            for _, child in pairs(OptionContainer:GetChildren()) do
                if child:IsA("TextButton") then
                    child:Destroy()
                end
            end
            
            -- Create new options
            for i, option in ipairs(options) do
                local OptionButton = Instance.new("TextButton")
                OptionButton.Name = option
                OptionButton.Parent = OptionContainer
                OptionButton.BackgroundColor3 = SimpleUI.Colors.DarkBackground
                OptionButton.Size = UDim2.new(1, 0, 0, 25)
                OptionButton.Font = Enum.Font.SourceSans
                OptionButton.Text = option
                OptionButton.TextColor3 = SimpleUI.Colors.TextColor
                OptionButton.TextSize = 15
                OptionButton.BorderSizePixel = 0
                
                OptionButton.MouseEnter:Connect(function()
                    TweenService:Create(OptionButton, TweenInfo.new(0.1), {BackgroundColor3 = SimpleUI.Colors.LightBackground}):Play()
                end)
                
                OptionButton.MouseLeave:Connect(function()
                    TweenService:Create(OptionButton, TweenInfo.new(0.1), {BackgroundColor3 = SimpleUI.Colors.DarkBackground}):Play()
                end)
                
                OptionButton.MouseButton1Click:Connect(function()
                    value = option
                    SelectedText.Text = option
                    callback(option)
                    
                    -- Close dropdown
                    TweenService:Create(DropdownFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 35)}):Play()
                    TweenService:Create(DropdownIcon, TweenInfo.new(0.2), {Rotation = 0}):Play()
                    opened = false
                end)
            end
            
            -- Update value if needed
            if not keepCurrent or not table.find(options, value) then
                value = options[1] or ""
                SelectedText.Text = value
                callback(value)
            end
        end
        
        return DropdownAPI
    end
    
    -- Create Input
    function TabAPI:CreateInput(title, placeholder, default, callback)
        placeholder = placeholder or "Nhập văn bản..."
        default = default or ""
        callback = callback or function() end
        
        local InputFrame = Instance.new("Frame")
        InputFrame.Name = title.."InputFrame"
        InputFrame.Parent = TabContent
        InputFrame.BackgroundColor3 = SimpleUI.Colors.LightBackground
        InputFrame.Size = UDim2.new(1, 0, 0, 35)
        
        local InputCorner = Instance.new("UICorner")
        InputCorner.CornerRadius = UDim.new(0, 4)
        InputCorner.Parent = InputFrame
        
        local InputLabel = Instance.new("TextLabel")
        InputLabel.Name = "Label"
        InputLabel.Parent = InputFrame
        InputLabel.BackgroundTransparency = 1
        InputLabel.Position = UDim2.new(0, 10, 0, 0)
        InputLabel.Size = UDim2.new(0.5, -10, 1, 0)
        InputLabel.Font = Enum.Font.SourceSansSemibold
        InputLabel.Text = title
        InputLabel.TextColor3 = SimpleUI.Colors.TextColor
        InputLabel.TextSize = 16
        InputLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        local InputBox = Instance.new("TextBox")
        InputBox.Name = "Input"
        InputBox.Parent = InputFrame
        InputBox.BackgroundColor3 = SimpleUI.Colors.DarkBackground
        InputBox.Position = UDim2.new(0.5, 0, 0.5, -12)
        InputBox.Size = UDim2.new(0.5, -10, 0, 24)
        InputBox.Font = Enum.Font.SourceSans
        InputBox.PlaceholderText = placeholder
        InputBox.Text = default
        InputBox.TextColor3 = SimpleUI.Colors.TextColor
        InputBox.TextSize = 14
        InputBox.PlaceholderColor3 = Color3.fromRGB(180, 180, 180)
        InputBox.ClearTextOnFocus = false
        
        local InputBoxCorner = Instance.new("UICorner")
        InputBoxCorner.CornerRadius = UDim.new(0, 4)
        InputBoxCorner.Parent = InputBox
        
        -- Input box interactions
        InputBox.Focused:Connect(function()
            TweenService:Create(InputBox, TweenInfo.new(0.2), {BorderSizePixel = 1, BorderColor3 = SimpleUI.Colors.AccentColor}):Play()
        end)
        
        InputBox.FocusLost:Connect(function(enterPressed)
            TweenService:Create(InputBox, TweenInfo.new(0.2), {BorderSizePixel = 0}):Play()
            if enterPressed then
                callback(InputBox.Text)
            end
        end)
        
        -- API
        local InputAPI = {}
        
        function InputAPI:Set(text)
            InputBox.Text = text
            callback(text)
        end
        
        function InputAPI:Get()
            return InputBox.Text
        end
        
        return InputAPI
    end
    
    -- Create Label
    function TabAPI:CreateLabel(text)
        local LabelFrame = Instance.new("Frame")
        LabelFrame.Name = "LabelFrame"
        LabelFrame.Parent = TabContent
        LabelFrame.BackgroundTransparency = 1
        LabelFrame.Size = UDim2.new(1, 0, 0, 25)
        
        local Label = Instance.new("TextLabel")
        Label.Name = "Label"
        Label.Parent = LabelFrame
        Label.BackgroundTransparency = 1
        Label.Size = UDim2.new(1, 0, 1, 0)
        Label.Font = Enum.Font.SourceSansSemibold
        Label.Text = text
        Label.TextColor3 = SimpleUI.Colors.TextColor
        Label.TextSize = 16
        Label.TextXAlignment = Enum.TextXAlignment.Left
        
        -- API
        local LabelAPI = {}
        
        function LabelAPI:Set(newText)
            Label.Text = newText
        end
        
        function LabelAPI:Get()
            return Label.Text
        end
        
        return LabelAPI
    end
    
    -- Create Separator
    function TabAPI:CreateSeparator()
        local Separator = Instance.new("Frame")
        Separator.Name = "Separator"
        Separator.Parent = TabContent
        Separator.BackgroundColor3 = SimpleUI.Colors.DarkBackground
        Separator.BorderSizePixel = 0
        Separator.Size = UDim2.new(1, 0, 0, 1)
        
        return Separator
    end
    
    return TabAPI
end

-- Notifikacje
function SimpleUI:Notify(title, message, duration)
    title = title or "Thông báo"
    message = message or ""
    duration = duration or 3
    
    local NotifyContainer = Instance.new("Frame")
    NotifyContainer.Name = "NotifyContainer"
    NotifyContainer.Parent = self.ScreenGui
    NotifyContainer.BackgroundColor3 = SimpleUI.Colors.DarkBackground
    NotifyContainer.Position = UDim2.new(1, -30, 0, 30)
    NotifyContainer.Size = UDim2.new(0, 250, 0, 0)
    NotifyContainer.AnchorPoint = Vector2.new(1, 0)
    NotifyContainer.BackgroundTransparency = 0.1
    NotifyContainer.ClipsDescendants = true
    
    local NotifyCorner = Instance.new("UICorner")
    NotifyCorner.CornerRadius = UDim.new(0, 4)
    NotifyCorner.Parent = NotifyContainer
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Parent = NotifyContainer
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 10, 0, 5)
    TitleLabel.Size = UDim2.new(1, -20, 0, 20)
    TitleLabel.Font = Enum.Font.SourceSansBold
    TitleLabel.Text = title
    TitleLabel.TextColor3 = SimpleUI.Colors.TextColor
    TitleLabel.TextSize = 16
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local MessageLabel = Instance.new("TextLabel")
    MessageLabel.Name = "Message"
    MessageLabel.Parent = NotifyContainer
    MessageLabel.BackgroundTransparency = 1
    MessageLabel.Position = UDim2.new(0, 10, 0, 25)
    MessageLabel.Size = UDim2.new(1, -20, 0, 50)
    MessageLabel.Font = Enum.Font.SourceSans
    MessageLabel.Text = message
    MessageLabel.TextColor3 = SimpleUI.Colors.TextColor
    MessageLabel.TextSize = 14
    MessageLabel.TextXAlignment = Enum.TextXAlignment.Left
    MessageLabel.TextYAlignment = Enum.TextYAlignment.Top
    MessageLabel.TextWrapped = true
    
    local LineAccent = Instance.new("Frame")
    LineAccent.Name = "LineAccent"
    LineAccent.Parent = NotifyContainer
    LineAccent.BackgroundColor3 = SimpleUI.Colors.AccentColor
    LineAccent.Position = UDim2.new(0, 0, 0, 0)
    LineAccent.Size = UDim2.new(0, 4, 1, 0)
    
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Parent = NotifyContainer
    CloseButton.BackgroundTransparency = 1
    CloseButton.Position = UDim2.new(1, -25, 0, 5)
    CloseButton.Size = UDim2.new(0, 20, 0, 20)
    CloseButton.Font = Enum.Font.SourceSansBold
    CloseButton.Text = "×"
    CloseButton.TextColor3 = SimpleUI.Colors.TextColor
    CloseButton.TextSize = 20
    
    -- Animation
    NotifyContainer.Size = UDim2.new(0, 250, 0, 0)
    TweenService:Create(NotifyContainer, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Size = UDim2.new(0, 250, 0, 80)}):Play()
    
    -- Close automatically after duration
    local closeConnection
    closeConnection = CloseButton.MouseButton1Click:Connect(function()
        TweenService:Create(NotifyContainer, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Size = UDim2.new(0, 250, 0, 0)}):Play()
        wait(0.3)
        NotifyContainer:Destroy()
        closeConnection:Disconnect()
    end)
    
    delay(duration, function()
        if NotifyContainer and NotifyContainer.Parent then
            TweenService:Create(NotifyContainer, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Size = UDim2.new(0, 250, 0, 0)}):Play()
            wait(0.3)
            if NotifyContainer and NotifyContainer.Parent then
                NotifyContainer:Destroy()
            end
        end
    end)
end

-- Destroy UI
function SimpleUI:Destroy()
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
end

return SimpleUI
