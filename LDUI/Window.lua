local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local Library = {}
Library.__index = Library

-- Utility Functions
local function CreateTween(obj, props, duration, easingStyle, easingDirection)
    duration = duration or 0.3
    easingStyle = easingStyle or Enum.EasingStyle.Quad
    easingDirection = easingDirection or Enum.EasingDirection.Out
    
    local tweenInfo = TweenInfo.new(duration, easingStyle, easingDirection)
    return TweenService:Create(obj, tweenInfo, props)
end

local function MakeDraggable(frame, handle)
    local dragging = false
    local dragStart = nil
    local startPos = nil

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)

    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    handle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

-- Window Class
local Window = {}
Window.__index = Window

function Window.new(config)
    local self = setmetatable({}, Window)
    
    self.Title = config.Title or "Noctis UI"
    self.Subtitle = config.Subtitle or ""
    self.Icon = config.Icon or ""
    self.Size = config.Size or UDim2.fromOffset(600, 400)
    self.Resizeable = config.Resizeable ~= false
    self.OnDestroy = config.OnDestroy or function() end
    
    self.IsMinimized = false
    self.IsMaximized = false
    self.OriginalSize = self.Size
    self.OriginalPosition = nil
    
    self:CreateGUI()
    self:SetupEvents()
    
    return self
end

function Window:CreateGUI()
    -- Main ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "NoctisUI"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.IgnoreGuiInset = true
    
    if syn and syn.protect_gui then
        syn.protect_gui(self.ScreenGui)
    elseif gethui then
        self.ScreenGui.Parent = gethui()
    else
        self.ScreenGui.Parent = CoreGui
    end
    
    -- Main Frame
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = self.Size
    self.MainFrame.Position = UDim2.fromScale(0.5, 0.5)
    self.MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    self.MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.ClipsDescendants = true
    self.MainFrame.Parent = self.ScreenGui
    
    -- Main Frame Corner
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 8)
    mainCorner.Parent = self.MainFrame
    
    -- Main Frame Border
    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = Color3.fromRGB(60, 60, 65)
    mainStroke.Thickness = 1
    mainStroke.Parent = self.MainFrame
    
    -- Title Bar
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Name = "TitleBar"
    self.TitleBar.Size = UDim2.new(1, 0, 0, 40)
    self.TitleBar.Position = UDim2.fromOffset(0, 0)
    self.TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    self.TitleBar.BorderSizePixel = 0
    self.TitleBar.Parent = self.MainFrame
    
    -- Title Bar Corner
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = self.TitleBar
    
    -- Title Bar Bottom Cover
    local titleCover = Instance.new("Frame")
    titleCover.Size = UDim2.new(1, 0, 0, 8)
    titleCover.Position = UDim2.new(0, 0, 1, -8)
    titleCover.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    titleCover.BorderSizePixel = 0
    titleCover.Parent = self.TitleBar
    
    -- Icon
    if self.Icon ~= "" then
        self.IconImage = Instance.new("ImageLabel")
        self.IconImage.Name = "Icon"
        self.IconImage.Size = UDim2.fromOffset(20, 20)
        self.IconImage.Position = UDim2.fromOffset(10, 10)
        self.IconImage.BackgroundTransparency = 1
        self.IconImage.Image = self.Icon
        self.IconImage.ImageColor3 = Color3.fromRGB(255, 255, 255)
        self.IconImage.Parent = self.TitleBar
    end
    
    -- Title Label
    self.TitleLabel = Instance.new("TextLabel")
    self.TitleLabel.Name = "Title"
    self.TitleLabel.Size = UDim2.new(1, -120, 0, 20)
    self.TitleLabel.Position = UDim2.fromOffset(self.Icon ~= "" and 35 or 10, 5)
    self.TitleLabel.BackgroundTransparency = 1
    self.TitleLabel.Text = self.Title
    self.TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.TitleLabel.TextSize = 14
    self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleLabel.Font = Enum.Font.GothamBold
    self.TitleLabel.Parent = self.TitleBar
    
    -- Subtitle Label
    if self.Subtitle ~= "" then
        self.SubtitleLabel = Instance.new("TextLabel")
        self.SubtitleLabel.Name = "Subtitle"
        self.SubtitleLabel.Size = UDim2.new(1, -120, 0, 15)
        self.SubtitleLabel.Position = UDim2.fromOffset(self.Icon ~= "" and 35 or 10, 20)
        self.SubtitleLabel.BackgroundTransparency = 1
        self.SubtitleLabel.Text = self.Subtitle
        self.SubtitleLabel.TextColor3 = Color3.fromRGB(170, 170, 170)
        self.SubtitleLabel.TextSize = 11
        self.SubtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        self.SubtitleLabel.Font = Enum.Font.Gotham
        self.SubtitleLabel.Parent = self.TitleBar
    end
    
    -- Control Buttons Container
    self.ControlsFrame = Instance.new("Frame")
    self.ControlsFrame.Name = "Controls"
    self.ControlsFrame.Size = UDim2.fromOffset(90, 30)
    self.ControlsFrame.Position = UDim2.new(1, -95, 0, 5)
    self.ControlsFrame.BackgroundTransparency = 1
    self.ControlsFrame.Parent = self.TitleBar
    
    local controlsLayout = Instance.new("UIListLayout")
    controlsLayout.FillDirection = Enum.FillDirection.Horizontal
    controlsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    controlsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    controlsLayout.Padding = UDim.new(0, 5)
    controlsLayout.Parent = self.ControlsFrame
    
    -- Minimize Button
    self.MinimizeButton = self:CreateControlButton("−", Color3.fromRGB(255, 193, 7))
    self.MinimizeButton.Parent = self.ControlsFrame
    
    -- Maximize Button
    self.MaximizeButton = self:CreateControlButton("☐", Color3.fromRGB(40, 167, 69))
    self.MaximizeButton.Parent = self.ControlsFrame
    
    -- Close Button
    self.CloseButton = self:CreateControlButton("×", Color3.fromRGB(220, 53, 69))
    self.CloseButton.Parent = self.ControlsFrame
    
    -- Content Area
    self.ContentFrame = Instance.new("ScrollingFrame")
    self.ContentFrame.Name = "Content"
    self.ContentFrame.Size = UDim2.new(1, -20, 1, -50)
    self.ContentFrame.Position = UDim2.fromOffset(10, 45)
    self.ContentFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    self.ContentFrame.BorderSizePixel = 0
    self.ContentFrame.ScrollBarThickness = 4
    self.ContentFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 85)
    self.ContentFrame.CanvasSize = UDim2.fromOffset(0, 0)
    self.ContentFrame.Parent = self.MainFrame
    
    -- Content Corner
    local contentCorner = Instance.new("UICorner")
    contentCorner.CornerRadius = UDim.new(0, 6)
    contentCorner.Parent = self.ContentFrame
    
    -- Content Layout
    self.ContentLayout = Instance.new("UIListLayout")
    self.ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    self.ContentLayout.Padding = UDim.new(0, 5)
    self.ContentLayout.Parent = self.ContentFrame
    
    -- Sidebar
    self.Sidebar = Instance.new("Frame")
    self.Sidebar.Name = "Sidebar"
    self.Sidebar.Size = UDim2.fromOffset(180, 0)
    self.Sidebar.Position = UDim2.fromOffset(10, 45)
    self.Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    self.Sidebar.BorderSizePixel = 0
    self.Sidebar.Parent = self.MainFrame
    
    -- Sidebar Corner
    local sidebarCorner = Instance.new("UICorner")
    sidebarCorner.CornerRadius = UDim.new(0, 6)
    sidebarCorner.Parent = self.Sidebar
    
    -- Adjust content frame for sidebar
    self.ContentFrame.Size = UDim2.new(1, -210, 1, -50)
    self.ContentFrame.Position = UDim2.fromOffset(200, 45)
    
    -- Update sidebar height
    self:UpdateSidebarHeight()
    
    -- Minimized Icon (initially hidden)
    self.MinimizedIcon = Instance.new("Frame")
    self.MinimizedIcon.Name = "MinimizedIcon"
    self.MinimizedIcon.Size = UDim2.fromOffset(50, 50)
    self.MinimizedIcon.Position = UDim2.fromOffset(20, 20)
    self.MinimizedIcon.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    self.MinimizedIcon.BorderSizePixel = 0
    self.MinimizedIcon.Visible = false
    self.MinimizedIcon.Parent = self.ScreenGui
    
    local minIconCorner = Instance.new("UICorner")
    minIconCorner.CornerRadius = UDim.new(0, 8)
    minIconCorner.Parent = self.MinimizedIcon
    
    local minIconStroke = Instance.new("UIStroke")
    minIconStroke.Color = Color3.fromRGB(60, 60, 65)
    minIconStroke.Thickness = 1
    minIconStroke.Parent = self.MinimizedIcon
    
    if self.Icon ~= "" then
        local minIconImage = Instance.new("ImageLabel")
        minIconImage.Size = UDim2.fromOffset(30, 30)
        minIconImage.Position = UDim2.fromScale(0.5, 0.5)
        minIconImage.AnchorPoint = Vector2.new(0.5, 0.5)
        minIconImage.BackgroundTransparency = 1
        minIconImage.Image = self.Icon
        minIconImage.ImageColor3 = Color3.fromRGB(255, 255, 255)
        minIconImage.Parent = self.MinimizedIcon
    end
    
    self.OriginalPosition = self.MainFrame.Position
    self:CreateSidebarItems()
end

function Window:CreateControlButton(text, color)
    local button = Instance.new("TextButton")
    button.Size = UDim2.fromOffset(20, 20)
    button.BackgroundColor3 = color
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    button.Font = Enum.Font.GothamBold
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 3)
    corner.Parent = button
    
    button.MouseEnter:Connect(function()
        CreateTween(button, {BackgroundColor3 = Color3.new(color.R * 1.2, color.G * 1.2, color.B * 1.2)}, 0.1):Play()
    end)
    
    button.MouseLeave:Connect(function()
        CreateTween(button, {BackgroundColor3 = color}, 0.1):Play()
    end)
    
    return button
end

function Window:CreateSidebarItems()
    local items = {
        {Icon = "🏠", Text = "Home", Active = false},
        {Icon = "🎮", Text = "Main", Active = false},
        {Icon = "🎒", Text = "Backpack", Active = true},
        {Icon = "⚙️", Text = "Automation", Active = false},
        {Icon = "🛒", Text = "Shop", Active = false},
        {Icon = "📡", Text = "Teleport", Active = false},
        {Icon = "⚙️", Text = "Misc", Active = false}
    }
    
    for i, item in pairs(items) do
        local itemFrame = Instance.new("Frame")
        itemFrame.Size = UDim2.new(1, -10, 0, 35)
        itemFrame.Position = UDim2.fromOffset(5, 5 + (i - 1) * 40)
        itemFrame.BackgroundColor3 = item.Active and Color3.fromRGB(40, 120, 200) or Color3.fromRGB(25, 25, 30)
        itemFrame.BorderSizePixel = 0
        itemFrame.Parent = self.Sidebar
        
        local itemCorner = Instance.new("UICorner")
        itemCorner.CornerRadius = UDim.new(0, 4)
        itemCorner.Parent = itemFrame
        
        if item.Active then
            local activeBar = Instance.new("Frame")
            activeBar.Size = UDim2.fromOffset(3, 20)
            activeBar.Position = UDim2.fromOffset(0, 7.5)
            activeBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            activeBar.BorderSizePixel = 0
            activeBar.Parent = itemFrame
            
            local activeCorner = Instance.new("UICorner")
            activeCorner.CornerRadius = UDim.new(0, 2)
            activeCorner.Parent = activeBar
        end
        
        local iconLabel = Instance.new("TextLabel")
        iconLabel.Size = UDim2.fromOffset(20, 20)
        iconLabel.Position = UDim2.fromOffset(15, 7.5)
        iconLabel.BackgroundTransparency = 1
        iconLabel.Text = item.Icon
        iconLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        iconLabel.TextSize = 16
        iconLabel.Font = Enum.Font.Gotham
        iconLabel.Parent = itemFrame
        
        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, -45, 1, 0)
        textLabel.Position = UDim2.fromOffset(40, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = item.Text
        textLabel.TextColor3 = item.Active and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180)
        textLabel.TextSize = 13
        textLabel.TextXAlignment = Enum.TextXAlignment.Left
        textLabel.Font = item.Active and Enum.Font.GothamBold or Enum.Font.Gotham
        textLabel.Parent = itemFrame
        
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, 0, 1, 0)
        button.BackgroundTransparency = 1
        button.Text = ""
        button.Parent = itemFrame
        
        button.MouseEnter:Connect(function()
            if not item.Active then
                CreateTween(itemFrame, {BackgroundColor3 = Color3.fromRGB(35, 35, 40)}, 0.1):Play()
            end
        end)
        
        button.MouseLeave:Connect(function()
            if not item.Active then
                CreateTween(itemFrame, {BackgroundColor3 = Color3.fromRGB(25, 25, 30)}, 0.1):Play()
            end
        end)
    end
end

function Window:UpdateSidebarHeight()
    local totalHeight = self.MainFrame.AbsoluteSize.Y - 50
    self.Sidebar.Size = UDim2.fromOffset(180, totalHeight)
end

function Window:SetupEvents()
    -- Make window draggable
    MakeDraggable(self.MainFrame, self.TitleBar)
    
    -- Minimize button
    self.MinimizeButton.MouseButton1Click:Connect(function()
        self:ToggleMinimize()
    end)
    
    -- Maximize button
    self.MaximizeButton.MouseButton1Click:Connect(function()
        self:ToggleMaximize()
    end)
    
    -- Close button
    self.CloseButton.MouseButton1Click:Connect(function()
        self:Destroy()
    end)
    
    -- Minimized icon click
    if self.MinimizedIcon then
        local iconButton = Instance.new("TextButton")
        iconButton.Size = UDim2.new(1, 0, 1, 0)
        iconButton.BackgroundTransparency = 1
        iconButton.Text = ""
        iconButton.Parent = self.MinimizedIcon
        
        iconButton.MouseButton1Click:Connect(function()
            self:ToggleMinimize()
        end)
        
        MakeDraggable(self.MinimizedIcon, iconButton)
    end
    
    -- Update sidebar height when window is resized
    self.MainFrame:GetPropertyChangedSignal("Size"):Connect(function()
        self:UpdateSidebarHeight()
    end)
    
    -- Resizing (if enabled)
    if self.Resizeable then
        self:SetupResizing()
    end
end

function Window:SetupResizing()
    local resizeHandle = Instance.new("Frame")
    resizeHandle.Size = UDim2.fromOffset(15, 15)
    resizeHandle.Position = UDim2.new(1, -15, 1, -15)
    resizeHandle.BackgroundColor3 = Color3.fromRGB(80, 80, 85)
    resizeHandle.BorderSizePixel = 0
    resizeHandle.Parent = self.MainFrame
    
    local resizeCorner = Instance.new("UICorner")
    resizeCorner.CornerRadius = UDim.new(0, 4)
    resizeCorner.Parent = resizeHandle
    
    local resizing = false
    local startSize = nil
    local startPos = nil
    
    resizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = true
            startSize = self.MainFrame.AbsoluteSize
            startPos = input.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and resizing then
            local delta = input.Position - startPos
            local newSize = Vector2.new(
                math.max(300, startSize.X + delta.X),
                math.max(200, startSize.Y + delta.Y)
            )
            self.MainFrame.Size = UDim2.fromOffset(newSize.X, newSize.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            resizing = false
        end
    end)
end

function Window:ToggleMinimize()
    self.IsMinimized = not self.IsMinimized
    
    if self.IsMinimized then
        CreateTween(self.MainFrame, {
            Size = UDim2.fromOffset(0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }, 0.3, Enum.EasingStyle.Back):Play()
        
        wait(0.3)
        self.MainFrame.Visible = false
        self.MinimizedIcon.Visible = true
        
        CreateTween(self.MinimizedIcon, {
            Size = UDim2.fromOffset(50, 50)
        }, 0.2):Play()
    else
        self.MinimizedIcon.Visible = false
        self.MainFrame.Visible = true
        self.MainFrame.Size = UDim2.fromOffset(0, 0)
        self.MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        
        CreateTween(self.MainFrame, {
            Size = self.IsMaximized and UDim2.fromScale(1, 1) or self.OriginalSize,
            Position = self.IsMaximized and UDim2.fromScale(0, 0) or self.OriginalPosition
        }, 0.3, Enum.EasingStyle.Back):Play()
    end
end

function Window:ToggleMaximize()
    self.IsMaximized = not self.IsMaximized
    
    if self.IsMaximized then
        CreateTween(self.MainFrame, {
            Size = UDim2.fromScale(1, 1),
            Position = UDim2.fromScale(0, 0)
        }, 0.3):Play()
        self.MaximizeButton.Text = "❐"
    else
        CreateTween(self.MainFrame, {
            Size = self.OriginalSize,
            Position = self.OriginalPosition or UDim2.fromScale(0.5, 0.5)
        }, 0.3):Play()
        self.MaximizeButton.Text = "☐"
    end
end

function Window:Destroy()
    if self.OnDestroy then
        self.OnDestroy()
    end
    
    CreateTween(self.MainFrame, {
        Size = UDim2.fromOffset(0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In):Play()
    
    CreateTween(self.MinimizedIcon, {
        Size = UDim2.fromOffset(0, 0)
    }, 0.2):Play()
    
    wait(0.3)
    self.ScreenGui:Destroy()
end

-- Library Functions
function Library:CreateWindow(config)
    return Window.new(config)
end

return Library