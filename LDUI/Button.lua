local WindowModule = {}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

-- Animation Configs
local AnimationConfig = {
    Global = {
        Duration = 0.25,
        EasingStyle = Enum.EasingStyle.Quart,
        EasingDirection = Enum.EasingDirection.Out
    },
    Notification = {
        Duration = 0.5,
        EasingStyle = Enum.EasingStyle.Back,
        EasingDirection = Enum.EasingDirection.Out
    },
    PopupOpen = {
        Duration = 0.4,
        EasingStyle = Enum.EasingStyle.Back,
        EasingDirection = Enum.EasingDirection.Out
    },
    PopupClose = {
        Duration = 0.4,
        EasingStyle = Enum.EasingStyle.Back,
        EasingDirection = Enum.EasingDirection.In
    }
}

-- Tween Helper Function
local function CreateTween(object, properties, config)
    local tweenInfo = TweenInfo.new(
        config.Duration,
        config.EasingStyle or Enum.EasingStyle.Linear,
        config.EasingDirection or Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

-- Dragging System
local function CreateDraggable(dragHandle, targetFrame)
    local dragData = {}
    local isDragging = false
    local dragStart = nil
    local startPos = nil
    local allowDragging = true
    
    local function updateDrag(input)
        local delta = input.Position - dragStart
        local newPosition = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
        CreateTween(targetFrame, {Position = newPosition}, {Duration = 0.2, EasingStyle = Enum.EasingStyle.Quart})
    end
    
    dragHandle.InputBegan:Connect(function(input)
        if allowDragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            isDragging = true
            dragStart = input.Position
            startPos = targetFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    isDragging = false
                end
            end)
        end
    end)
    
    dragHandle.InputChanged:Connect(function(input)
        if allowDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            dragData.LastInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if allowDragging and input == dragData.LastInput and isDragging then
            updateDrag(input)
        end
    end)
    
    function dragData.SetAllowDragging(_, state)
        allowDragging = state
    end
    
    return dragData
end

-- Create Window Function
function WindowModule.CreateWindow(config)
    local WindowData = {
        Title = config.Title or "Window",
        Icon = config.Icon or "rbxassetid://113216930555884",
        Version = config.Author or config.Version or "v1.0.0",
        Size = config.Size or UDim2.new(0, 528, 0, 334),
        ToggleKey = config.ToggleKey or Enum.KeyCode.RightShift,
        LiveSearchDropdown = config.LiveSearchDropdown or false
    }
    
    -- Create container folder
    local Container = Instance.new("Folder")
    Container.Name = WindowData.Title
    Container.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    -- Create ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = WindowData.Title
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = Container
    
    -- Parent to appropriate location
    local function getParent()
        if gethui then
            return gethui()
        elseif pcall(function() game.CoreGui:GetChildren() end) then
            return game.CoreGui
        else
            return game.Players.LocalPlayer.PlayerGui
        end
    end
    
    if protect_gui then
        protect_gui(ScreenGui)
    end
    ScreenGui.Parent = getParent()
    
    -- Create Float Icon (Minimized State)
    local FloatIcon = Instance.new("Frame")
    FloatIcon.Name = "FloatIcon"
    FloatIcon.Visible = false
    FloatIcon.ZIndex = 0
    FloatIcon.BorderSizePixel = 2
    FloatIcon.BackgroundColor3 = Color3.fromRGB(37, 40, 47)
    FloatIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    FloatIcon.ClipsDescendants = true
    FloatIcon.AutomaticSize = Enum.AutomaticSize.X
    FloatIcon.Size = UDim2.new(0, 85, 0, 45)
    FloatIcon.Position = UDim2.new(0.5, 0, 0, 45)
    FloatIcon.BorderColor3 = Color3.fromRGB(61, 61, 75)
    FloatIcon.Parent = ScreenGui
    
    local FloatCorner = Instance.new("UICorner")
    FloatCorner.CornerRadius = UDim.new(0, 10)
    FloatCorner.Parent = FloatIcon
    
    local FloatStroke = Instance.new("UIStroke")
    FloatStroke.Transparency = 0.5
    FloatStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    FloatStroke.Thickness = 1.5
    FloatStroke.Color = Color3.fromRGB(95, 95, 117)
    FloatStroke.Parent = FloatIcon
    
    local FloatPadding = Instance.new("UIPadding")
    FloatPadding.PaddingTop = UDim.new(0, 8)
    FloatPadding.PaddingRight = UDim.new(0, 10)
    FloatPadding.PaddingLeft = UDim.new(0, 10)
    FloatPadding.PaddingBottom = UDim.new(0, 8)
    FloatPadding.Parent = FloatIcon
    
    local FloatLayout = Instance.new("UIListLayout")
    FloatLayout.Padding = UDim.new(0, 8)
    FloatLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    FloatLayout.SortOrder = Enum.SortOrder.LayoutOrder
    FloatLayout.FillDirection = Enum.FillDirection.Horizontal
    FloatLayout.Parent = FloatIcon
    
    local FloatIconImage = Instance.new("ImageButton")
    FloatIconImage.Active = false
    FloatIconImage.Interactable = false
    FloatIconImage.BorderSizePixel = 0
    FloatIconImage.AutoButtonColor = false
    FloatIconImage.BackgroundTransparency = 1
    FloatIconImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    FloatIconImage.AnchorPoint = Vector2.new(0, 0.5)
    FloatIconImage.Image = WindowData.Icon
    FloatIconImage.Size = UDim2.new(1, 0, 1, 0)
    FloatIconImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
    FloatIconImage.Name = "Icon"
    FloatIconImage.Position = UDim2.new(0, 10, 0.5, 0)
    FloatIconImage.Parent = FloatIcon
    
    local FloatAspect = Instance.new("UIAspectRatioConstraint")
    FloatAspect.Parent = FloatIconImage
    
    local FloatLabel = Instance.new("TextLabel")
    FloatLabel.Interactable = false
    FloatLabel.BorderSizePixel = 0
    FloatLabel.TextSize = 16
    FloatLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    FloatLabel.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
    FloatLabel.TextColor3 = Color3.fromRGB(197, 204, 219)
    FloatLabel.BackgroundTransparency = 1
    FloatLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    FloatLabel.Size = UDim2.new(0, 20, 0, 20)
    FloatLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
    FloatLabel.Text = WindowData.Title
    FloatLabel.AutomaticSize = Enum.AutomaticSize.X
    FloatLabel.Position = UDim2.new(0.38615, 0, 0.53448, -1)
    FloatLabel.Parent = FloatIcon
    
    local FloatOpenButton = Instance.new("ImageButton")
    FloatOpenButton.BorderSizePixel = 0
    FloatOpenButton.AutoButtonColor = false
    FloatOpenButton.BackgroundTransparency = 1
    FloatOpenButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    FloatOpenButton.ImageColor3 = Color3.fromRGB(197, 204, 219)
    FloatOpenButton.Selectable = false
    FloatOpenButton.AnchorPoint = Vector2.new(0, 0.5)
    FloatOpenButton.Image = "rbxassetid://122219713887461"
    FloatOpenButton.Size = UDim2.new(0, 20, 0, 20)
    FloatOpenButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
    FloatOpenButton.Name = "Open"
    FloatOpenButton.Position = UDim2.new(0, 128, 0.5, 0)
    FloatOpenButton.Parent = FloatIcon
    
    local FloatOpenAspect = Instance.new("UIAspectRatioConstraint")
    FloatOpenAspect.Parent = FloatOpenButton
    
    local FloatOpenCorner = Instance.new("UICorner")
    FloatOpenCorner.Parent = FloatOpenButton
    
    -- Create Main Window
    local Window = Instance.new("Frame")
    Window.Name = "Window"
    Window.ZIndex = 0
    Window.BorderSizePixel = 2
    Window.BackgroundColor3 = Color3.fromRGB(37, 40, 47)
    Window.AnchorPoint = Vector2.new(0.5, 0.5)
    Window.Size = WindowData.Size
    Window.Position = UDim2.new(0.5278, 0, 0.5, 0)
    Window.BorderColor3 = Color3.fromRGB(61, 61, 75)
    Window.Visible = false
    Window.Parent = ScreenGui
    
    local WindowCorner = Instance.new("UICorner")
    WindowCorner.CornerRadius = UDim.new(0, 10)
    WindowCorner.Parent = Window
    
    local WindowStroke = Instance.new("UIStroke")
    WindowStroke.Transparency = 0.5
    WindowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    WindowStroke.Color = Color3.fromRGB(95, 95, 117)
    WindowStroke.Parent = Window
    
    -- Create TopFrame
    local TopFrame = Instance.new("Frame")
    TopFrame.BorderSizePixel = 0
    TopFrame.BackgroundColor3 = Color3.fromRGB(37, 40, 47)
    TopFrame.ClipsDescendants = true
    TopFrame.Size = UDim2.new(1, 0, 0, 35)
    TopFrame.BorderColor3 = Color3.fromRGB(61, 61, 75)
    TopFrame.Name = "TopFrame"
    TopFrame.Parent = Window
    
    local TopCorner = Instance.new("UICorner")
    TopCorner.CornerRadius = UDim.new(0, 6)
    TopCorner.Parent = TopFrame
    
    local TopBorder = Instance.new("Frame")
    TopBorder.ZIndex = 2
    TopBorder.BorderSizePixel = 0
    TopBorder.BackgroundColor3 = Color3.fromRGB(61, 61, 75)
    TopBorder.AnchorPoint = Vector2.new(0, 0.5)
    TopBorder.Size = UDim2.new(1, 0, 0, 2)
    TopBorder.Position = UDim2.new(0, 0, 1, 0)
    TopBorder.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TopBorder.Name = "Border"
    TopBorder.Parent = TopFrame
    
    -- TopFrame Icon
    local TopIcon = Instance.new("ImageButton")
    TopIcon.Active = false
    TopIcon.Interactable = false
    TopIcon.BorderSizePixel = 0
    TopIcon.BackgroundTransparency = 1
    TopIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TopIcon.AnchorPoint = Vector2.new(0, 0.5)
    TopIcon.Image = WindowData.Icon
    TopIcon.Size = UDim2.new(0, 25, 0, 25)
    TopIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TopIcon.Name = "Icon"
    TopIcon.Position = UDim2.new(0, 10, 0.5, 0)
    TopIcon.Parent = TopFrame
    
    local TopIconAspect = Instance.new("UIAspectRatioConstraint")
    TopIconAspect.Parent = TopIcon
    
    -- TopFrame Title
    local TopTitle = Instance.new("TextLabel")
    TopTitle.TextWrapped = true
    TopTitle.Interactable = false
    TopTitle.BorderSizePixel = 0
    TopTitle.TextSize = 14
    TopTitle.TextScaled = true
    TopTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TopTitle.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
    TopTitle.TextColor3 = Color3.fromRGB(197, 204, 219)
    TopTitle.BackgroundTransparency = 1
    TopTitle.AnchorPoint = Vector2.new(0.5, 0.5)
    TopTitle.Size = UDim2.new(1, 0, 0, 16)
    TopTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TopTitle.Text = WindowData.Title .. " - " .. WindowData.Version
    TopTitle.Position = UDim2.new(0.5, 0, 0.5, -1)
    TopTitle.Parent = TopFrame
    
    -- TopFrame Buttons
    local CloseButton = Instance.new("ImageButton")
    CloseButton.BorderSizePixel = 0
    CloseButton.BackgroundTransparency = 1
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.ImageColor3 = Color3.fromRGB(197, 204, 219)
    CloseButton.AnchorPoint = Vector2.new(1, 0.5)
    CloseButton.Image = "rbxassetid://132453323679056"
    CloseButton.Size = UDim2.new(0, 20, 0, 20)
    CloseButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
    CloseButton.Name = "Close"
    CloseButton.Position = UDim2.new(1, -15, 0.5, 0)
    CloseButton.Parent = TopFrame
    
    local MaximizeButton = Instance.new("ImageButton")
    MaximizeButton.BorderSizePixel = 0
    MaximizeButton.BackgroundTransparency = 1
    MaximizeButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    MaximizeButton.ImageColor3 = Color3.fromRGB(197, 204, 219)
    MaximizeButton.AnchorPoint = Vector2.new(1, 0.5)
    MaximizeButton.Image = "rbxassetid://108285848026510"
    MaximizeButton.Size = UDim2.new(0, 15, 0, 15)
    MaximizeButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
    MaximizeButton.Name = "Maximize"
    MaximizeButton.Position = UDim2.new(1, -55, 0.5, 0)
    MaximizeButton.Parent = TopFrame
    
    local HideButton = Instance.new("ImageButton")
    HideButton.BorderSizePixel = 0
    HideButton.BackgroundTransparency = 1
    HideButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    HideButton.ImageColor3 = Color3.fromRGB(197, 204, 219)
    HideButton.AnchorPoint = Vector2.new(1, 0.5)
    HideButton.Image = "rbxassetid://128209591224511"
    HideButton.Size = UDim2.new(0, 20, 0, 20)
    HideButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
    HideButton.Name = "Hide"
    HideButton.Position = UDim2.new(1, -90, 0.5, 0)
    HideButton.Parent = TopFrame
    
    -- Create TabButtons (Sidebar)
    local TabButtons = Instance.new("Frame")
    TabButtons.BorderSizePixel = 0
    TabButtons.BackgroundColor3 = Color3.fromRGB(37, 40, 47)
    TabButtons.ClipsDescendants = true
    TabButtons.Size = UDim2.new(0, 165, 1, -35)
    TabButtons.Position = UDim2.new(0, 0, 0, 35)
    TabButtons.BorderColor3 = Color3.fromRGB(61, 61, 75)
    TabButtons.Name = "TabButtons"
    TabButtons.SelectionGroup = true
    TabButtons.Parent = Window
    
    local TabButtonsCorner = Instance.new("UICorner")
    TabButtonsCorner.CornerRadius = UDim.new(0, 6)
    TabButtonsCorner.Parent = TabButtons
    
    local TabButtonsAntiTop = Instance.new("Frame")
    TabButtonsAntiTop.BorderSizePixel = 0
    TabButtonsAntiTop.BackgroundColor3 = Color3.fromRGB(37, 40, 47)
    TabButtonsAntiTop.Size = UDim2.new(1, 0, 0, 5)
    TabButtonsAntiTop.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TabButtonsAntiTop.Name = "AntiCornerTop"
    TabButtonsAntiTop.Parent = TabButtons
    
    local TabButtonsAntiRight = Instance.new("Frame")
    TabButtonsAntiRight.BorderSizePixel = 0
    TabButtonsAntiRight.BackgroundColor3 = Color3.fromRGB(37, 40, 47)
    TabButtonsAntiRight.AnchorPoint = Vector2.new(0.5, 0)
    TabButtonsAntiRight.Size = UDim2.new(0, 2, 1, 0)
    TabButtonsAntiRight.Position = UDim2.new(1, 1, 0, 0)
    TabButtonsAntiRight.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TabButtonsAntiRight.Name = "AntiCornerRight"
    TabButtonsAntiRight.Parent = TabButtons
    
    local TabButtonsBorder = Instance.new("Frame")
    TabButtonsBorder.ZIndex = 2
    TabButtonsBorder.BorderSizePixel = 0
    TabButtonsBorder.BackgroundColor3 = Color3.fromRGB(61, 61, 75)
    TabButtonsBorder.AnchorPoint = Vector2.new(1, 0)
    TabButtonsBorder.Size = UDim2.new(0, 2, 1, 0)
    TabButtonsBorder.Position = UDim2.new(1, 0, 0, 0)
    TabButtonsBorder.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TabButtonsBorder.Name = "Border"
    TabButtonsBorder.Parent = TabButtons
    
    local TabButtonsList = Instance.new("ScrollingFrame")
    TabButtonsList.Active = true
    TabButtonsList.ScrollingDirection = Enum.ScrollingDirection.Y
    TabButtonsList.BorderSizePixel = 0
    TabButtonsList.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabButtonsList.ElasticBehavior = Enum.ElasticBehavior.Never
    TabButtonsList.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
    TabButtonsList.BackgroundColor3 = Color3.fromRGB(37, 40, 47)
    TabButtonsList.Name = "Lists"
    TabButtonsList.Selectable = false
    TabButtonsList.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
    TabButtonsList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabButtonsList.Size = UDim2.new(1, 0, 1, 0)
    TabButtonsList.BorderColor3 = Color3.fromRGB(61, 61, 75)
    TabButtonsList.ScrollBarThickness = 4
    TabButtonsList.BackgroundTransparency = 1
    TabButtonsList.Parent = TabButtons
    
    local TabButtonsLayout = Instance.new("UIListLayout")
    TabButtonsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabButtonsLayout.Parent = TabButtonsList
    
    local TabButtonsPadding = Instance.new("UIPadding")
    TabButtonsPadding.PaddingTop = UDim.new(0, 8)
    TabButtonsPadding.Parent = TabButtonsList
    
    -- Create Tabs (Content Area)
    local Tabs = Instance.new("Frame")
    Tabs.BorderSizePixel = 0
    Tabs.BackgroundColor3 = Color3.fromRGB(32, 35, 41)
    Tabs.Size = UDim2.new(1, -165, 1, -35)
    Tabs.Position = UDim2.new(0, 165, 0, 35)
    Tabs.BorderColor3 = Color3.fromRGB(61, 61, 75)
    Tabs.Name = "Tabs"
    Tabs.Parent = Window
    
    local TabsCorner = Instance.new("UICorner")
    TabsCorner.CornerRadius = UDim.new(0, 6)
    TabsCorner.Parent = Tabs
    
    local TabsAntiLeft = Instance.new("Frame")
    TabsAntiLeft.Visible = false
    TabsAntiLeft.BorderSizePixel = 0
    TabsAntiLeft.BackgroundColor3 = Color3.fromRGB(32, 35, 41)
    TabsAntiLeft.Size = UDim2.new(0, 5, 1, 0)
    TabsAntiLeft.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TabsAntiLeft.Name = "AntiCornerLeft"
    TabsAntiLeft.Parent = Tabs
    
    local TabsAntiTop = Instance.new("Frame")
    TabsAntiTop.BorderSizePixel = 0
    TabsAntiTop.BackgroundColor3 = Color3.fromRGB(32, 35, 41)
    TabsAntiTop.Size = UDim2.new(1, 0, 0, 5)
    TabsAntiTop.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TabsAntiTop.Name = "AntiCornerTop"
    TabsAntiTop.Parent = Tabs
    
    local NoObjectFoundText = Instance.new("TextLabel")
    NoObjectFoundText.TextWrapped = true
    NoObjectFoundText.Interactable = false
    NoObjectFoundText.BorderSizePixel = 0
    NoObjectFoundText.TextSize = 14
    NoObjectFoundText.TextScaled = true
    NoObjectFoundText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NoObjectFoundText.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
    NoObjectFoundText.TextColor3 = Color3.fromRGB(135, 140, 150)
    NoObjectFoundText.BackgroundTransparency = 1
    NoObjectFoundText.AnchorPoint = Vector2.new(0.5, 0.5)
    NoObjectFoundText.Size = UDim2.new(1, 0, 0, 16)
    NoObjectFoundText.Visible = false
    NoObjectFoundText.BorderColor3 = Color3.fromRGB(0, 0, 0)
    NoObjectFoundText.Text = "This tab is empty :("
    NoObjectFoundText.Name = "NoObjectFoundText"
    NoObjectFoundText.Position = UDim2.new(0.5, 0, 0.45, 0)
    NoObjectFoundText.Parent = Tabs
    
    -- Create Notification Frame
    local NotificationFrame = Instance.new("Frame")
    NotificationFrame.BorderSizePixel = 0
    NotificationFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NotificationFrame.ClipsDescendants = true
    NotificationFrame.Size = UDim2.new(1, 0, 1, 0)
    NotificationFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    NotificationFrame.Name = "NotificationFrame"
    NotificationFrame.BackgroundTransparency = 1
    NotificationFrame.Parent = Window
    
    local NotificationList = Instance.new("Frame")
    NotificationList.ZIndex = 5
    NotificationList.BorderSizePixel = 0
    NotificationList.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NotificationList.AnchorPoint = Vector2.new(0.5, 0)
    NotificationList.ClipsDescendants = true
    NotificationList.Size = UDim2.new(0, 630, 1, -35)
    NotificationList.Position = UDim2.new(1, 0, 0, 35)
    NotificationList.BorderColor3 = Color3.fromRGB(0, 0, 0)
    NotificationList.Name = "NotificationList"
    NotificationList.BackgroundTransparency = 1
    NotificationList.Parent = NotificationFrame
    
    local NotificationLayout = Instance.new("UIListLayout")
    NotificationLayout.Padding = UDim.new(0, 12)
    NotificationLayout.SortOrder = Enum.SortOrder.LayoutOrder
    NotificationLayout.Parent = NotificationList
    
    local NotificationPadding = Instance.new("UIPadding")
    NotificationPadding.PaddingTop = UDim.new(0, 10)
    NotificationPadding.PaddingRight = UDim.new(0, 40)
    NotificationPadding.PaddingLeft = UDim.new(0, 40)
    NotificationPadding.Parent = NotificationList
    
    -- Create Dark Overlay
    local DarkOverlay = Instance.new("Frame")
    DarkOverlay.Visible = false
    DarkOverlay.BorderSizePixel = 0
    DarkOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    DarkOverlay.Size = UDim2.new(1, 0, 1, 0)
    DarkOverlay.BorderColor3 = Color3.fromRGB(0, 0, 0)
    DarkOverlay.Name = "DarkOverlay"
    DarkOverlay.BackgroundTransparency = 0.6
    DarkOverlay.Parent = Window
    
    local DarkOverlayCorner = Instance.new("UICorner")
    DarkOverlayCorner.CornerRadius = UDim.new(0, 10)
    DarkOverlayCorner.Parent = DarkOverlay
    
    -- Window Logic Variables
    local WindowMethods = {}
    local TabData = {}
    local TabList = {}
    local CurrentTab = nil
    local IsVisible = false
    local IsMaximized = false
    local OriginalSize = WindowData.Size
    local OriginalPosition = Window.Position
    local IsAnimating = false
    
    -- Setup Dragging
    local DragSystem = CreateDraggable(TopFrame, Window)
    
    -- Window Toggle System
    local function ToggleWindow(state)
        if state == true then
            -- Show Window, Hide Float
            local floatSize = FloatIcon.Size
            Window.Size = UDim2.fromOffset(0, 0)
            Window.Visible = true
            CreateTween(FloatIcon, {Size = UDim2.new(0, 0, 0, 0)}, AnimationConfig.Global)
            CreateTween(Window, {Size = OriginalSize}, AnimationConfig.Global).Completed:Wait()
            Window.Tabs.Visible = true
            Window.TabButtons.Visible = true
            FloatIcon.Visible = false
            IsVisible = true
        elseif state == false then
            -- Hide Window, Show Float
            OriginalSize = Window.Size
            FloatIcon.Size = UDim2.fromOffset(0, 0)
            FloatIcon.Visible = true
            Window.Tabs.Visible = false
            Window.TabButtons.Visible = false
            CreateTween(FloatIcon, {Size = UDim2.new(0, 85, 0, 45)}, AnimationConfig.Global)
            CreateTween(Window, {Size = UDim2.fromOffset(0, 0)}, AnimationConfig.Global).Completed:Wait()
            Window.Visible = false
            IsVisible = false
        else
            -- Toggle current state
            if IsVisible then
                ToggleWindow(false)
            else
                ToggleWindow(true)
            end
        end
    end
    
    -- Tab Management Functions
    local function RegisterTab(name, tabObject, tabButton, hasIcon)
        local tabInfo = {
            Name = name,
            TabObject = tabObject,
            TabButton = tabButton,
            HasIcon = hasIcon or false
        }
        TabData[name] = tabInfo
        table.insert(TabList, TabData[name])
    end
    
    local function SwitchToTab(tabName)
        for name, tabInfo in pairs(TabData) do
            if name ~= tabName then
                -- Hide inactive tabs
                tabInfo.TabObject.Visible = false
                CreateTween(tabInfo.TabButton.TextLabel, {
                    Position = UDim2.new(0, 42, 0.5, 0),
                    Size = UDim2.new(0, 103, 0, 16),
                    TextTransparency = 0.5
                }, AnimationConfig.Global)
                CreateTween(tabInfo.TabButton.ImageButton, {
                    Position = UDim2.new(0, 12, 0, 18),
                    ImageTransparency = 0.5
                }, AnimationConfig.Global)
                CreateTween(tabInfo.TabButton.Bar, {
                    Size = UDim2.new(0, 5, 0, 0),
                    BackgroundTransparency = 1
                }, AnimationConfig.Global)
            elseif name == tabName then
                -- Show active tab
                CurrentTab = tabName
                tabInfo.TabObject.Visible = true
                CreateTween(tabInfo.TabButton.TextLabel, {
                    Position = UDim2.new(0, 57, 0.5, 0),
                    Size = UDim2.new(0, 88, 0, 16),
                    TextTransparency = 0
                }, AnimationConfig.Global)
                CreateTween(tabInfo.TabButton.ImageButton, {
                    Position = UDim2.new(0, 25, 0, 18),
                    ImageTransparency = 0
                }, AnimationConfig.Global)
                CreateTween(tabInfo.TabButton.Bar, {
                    Size = UDim2.new(0, 5, 0, 25),
                    BackgroundTransparency = 0
                }, AnimationConfig.Global)
                
                -- Check if tab is empty
                local childCount = 0
                for _, child in ipairs(tabInfo.TabObject:GetChildren()) do
                    if child:IsA("GuiObject") then
                        childCount = childCount + 1
                    end
                end
                
                if childCount == 0 then
                    NoObjectFoundText.Visible = true
                else
                    NoObjectFoundText.Visible = false
                end
            end
        end
    end
    
    -- Button Event Connections
    HideButton.MouseButton1Click:Connect(function()
        if not IsAnimating then
            IsAnimating = true
            ToggleWindow(false)
            task.delay(AnimationConfig.Global.Duration, function()
                IsAnimating = false
            end)
        end
    end)
    
    FloatOpenButton.MouseButton1Click:Connect(function()
        if not IsAnimating then
            IsAnimating = true
            ToggleWindow(true)
            task.delay(AnimationConfig.Global.Duration, function()
                IsAnimating = false
            end)
        end
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        -- Create close dialog (will be implemented when dialog module is ready)
        Container.Parent = nil
    end)
    
    MaximizeButton.MouseButton1Click:Connect(function()
        if not IsMaximized then
            DragSystem:SetAllowDragging(false)
            OriginalSize = Window.Size
            OriginalPosition = Window.Position
            CreateTween(Window, {
                Size = UDim2.new(1, 0, 1, 0)
            }, AnimationConfig.Global)
            CreateTween(Window, {
                Position = UDim2.new(0.5, 0, 0.5, 0)
            }, AnimationConfig.Global)
            CreateTween(WindowCorner, {
                CornerRadius = UDim.new(0, 0)
            }, AnimationConfig.Global)
            IsMaximized = true
        else
            DragSystem:SetAllowDragging(true)
            CreateTween(Window, {
                Size = OriginalSize
            }, AnimationConfig.Global)
            CreateTween(Window, {
                Position = OriginalPosition
            }, AnimationConfig.Global)
            CreateTween(WindowCorner, {
                CornerRadius = UDim.new(0, 10)
            }, AnimationConfig.Global)
            IsMaximized = false
        end
    end)
    
    -- Toggle Key Handler
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not IsAnimating and not gameProcessed and input.KeyCode == WindowData.ToggleKey then
            IsAnimating = true
            ToggleWindow()
            task.delay(AnimationConfig.Global.Duration, function()
                IsAnimating = false
            end)
        end
    end)
    
    -- Window Methods
    function WindowMethods.Tab(_, config)
        local TabMethods = {}
        local TabConfig = {
            Title = config.Title or "Tab",
            Icon = config.Icon or "rbxassetid://113216930555884"
        }
        
        -- Create Tab Button
        local TabButton = Instance.new("ImageButton")
        TabButton.Active = false
        TabButton.BorderSizePixel = 0
        TabButton.AutoButtonColor = false
        TabButton.Visible = false
        TabButton.BackgroundTransparency = 1
        TabButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TabButton.Selectable = false
        TabButton.Size = UDim2.new(1, 0, 0, 36)
        TabButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
        TabButton.Name = "TabButton"
        TabButton.Parent = TabButtonsList
        
        local TabButtonIcon = Instance.new("ImageButton")
        TabButtonIcon.BorderSizePixel = 0
        TabButtonIcon.ImageTransparency = 0.5
        TabButtonIcon.BackgroundTransparency = 1
        TabButtonIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TabButtonIcon.ImageColor3 = Color3.fromRGB(197, 204, 219)
        TabButtonIcon.AnchorPoint = Vector2.new(0, 0.5)
        TabButtonIcon.Image = TabConfig.Icon
        TabButtonIcon.Size = UDim2.new(0, 31, 0, 30)
        TabButtonIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
        TabButtonIcon.Position = UDim2.new(0, 6, 0, 18)
        TabButtonIcon.Parent = TabButton
        
        local TabButtonAspect = Instance.new("UIAspectRatioConstraint")
        TabButtonAspect.Parent = TabButtonIcon
        
        local TabButtonLabel = Instance.new("TextLabel")
        TabButtonLabel.TextWrapped = true
        TabButtonLabel.BorderSizePixel = 0
        TabButtonLabel.TextSize = 14
        TabButtonLabel.TextXAlignment = Enum.TextXAlignment.Left
        TabButtonLabel.TextTransparency = 0.5
        TabButtonLabel.TextScaled = true
        TabButtonLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TabButtonLabel.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
        TabButtonLabel.TextColor3 = Color3.fromRGB(197, 204, 219)
        TabButtonLabel.BackgroundTransparency = 1
        TabButtonLabel.AnchorPoint = Vector2.new(0, 0.5)
        TabButtonLabel.Size = UDim2.new(0, 103, 0, 16)
        TabButtonLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
        TabButtonLabel.Text = TabConfig.Title
        TabButtonLabel.Position = UDim2.new(0, 42, 0.5, 0)
        TabButtonLabel.Parent = TabButton
        
        local TabButtonBar = Instance.new("Frame")
        TabButtonBar.BorderSizePixel = 0
        TabButtonBar.BackgroundColor3 = Color3.fromRGB(197, 204, 219)
        TabButtonBar.AnchorPoint = Vector2.new(0, 0.5)
        TabButtonBar.Size = UDim2.new(0, 5, 0, 0)
        TabButtonBar.Position = UDim2.new(0, 8, 0, 18)
        TabButtonBar.BorderColor3 = Color3.fromRGB(0, 0, 0)
        TabButtonBar.Name = "Bar"
        TabButtonBar.BackgroundTransparency = 1
        TabButtonBar.Parent = TabButton
        
        local TabButtonBarCorner = Instance.new("UICorner")
        TabButtonBarCorner.CornerRadius = UDim.new(0, 100)
        TabButtonBarCorner.Parent = TabButtonBar
        
        -- Create Tab Content
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Visible = false
        TabContent.Active = true
        TabContent.ScrollingDirection = Enum.ScrollingDirection.Y
        TabContent.BorderSizePixel = 0
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.ElasticBehavior = Enum.ElasticBehavior.Never
        TabContent.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
        TabContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TabContent.Name = "Tab"
        TabContent.Selectable = false
        TabContent.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
        TabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.ScrollBarImageColor3 = Color3.fromRGB(99, 106, 122)
        TabContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
        TabContent.ScrollBarThickness = 5
        TabContent.BackgroundTransparency = 1
        TabContent.Parent = Tabs
        
        local TabContentLayout = Instance.new("UIListLayout")
        TabContentLayout.Padding = UDim.new(0, 15)
        TabContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        TabContentLayout.Parent = TabContent
        
        local TabContentPadding = Instance.new("UIPadding")
        TabContentPadding.PaddingTop = UDim.new(0, 10)
        TabContentPadding.PaddingRight = UDim.new(0, 14)
        TabContentPadding.PaddingLeft = UDim.new(0, 10)
        TabContentPadding.PaddingBottom = UDim.new(0, 10)
        TabContentPadding.Parent = TabContent
        
        -- Register Tab
        RegisterTab(config.Title, TabContent, TabButton, true)
        TabButton.Visible = true
        
        -- Set as current tab if it's the first one
        if CurrentTab == config.Title then
            TabContent.Visible = true
            TabButtonLabel.Position = UDim2.new(0, 57, 0.5, 0)
            TabButtonLabel.Size = UDim2.new(0, 88, 0, 16)
            TabButtonLabel.TextTransparency = 0
            TabButtonIcon.Position = UDim2.new(0, 25, 0, 18)
            TabButtonIcon.ImageTransparency = 0
            TabButtonBar.Size = UDim2.new(0, 5, 0, 25)
            TabButtonBar.BackgroundTransparency = 0
        else
            TabButtonLabel.Position = UDim2.new(0, 42, 0.5, 0)
            TabButtonLabel.Size = UDim2.new(0, 103, 0, 16)
            TabButtonLabel.TextTransparency = 0.5
            TabButtonIcon.Position = UDim2.new(0, 12, 0, 18)
            TabButtonIcon.ImageTransparency = 0.5
            TabButtonBar.Size = UDim2.new(0, 5, 0, 0)
            TabButtonBar.BackgroundTransparency = 1
        end
        
        -- Tab Button Click Handler
        TabButton.MouseButton1Click:Connect(function()
            SwitchToTab(config.Title)
        end)
        
        -- Tab Content Change Monitoring
        TabContent.ChildAdded:Connect(function()
            local childCount = 0
            for _, child in ipairs(TabContent:GetChildren()) do
                if child:IsA("GuiObject") then
                    childCount = childCount + 1
                end
            end
            if childCount > 0 then
                NoObjectFoundText.Visible = false
            else
                NoObjectFoundText.Visible = true
            end
        end)
        
        TabContent.ChildRemoved:Connect(function()
            local childCount = 0
            for _, child in ipairs(TabContent:GetChildren()) do
                if child:IsA("GuiObject") then
                    childCount = childCount + 1
                end
            end
            if childCount > 0 then
                NoObjectFoundText.Visible = false
            else
                NoObjectFoundText.Visible = true
            end
        end)
        
        -- Tab Methods (for future element additions)
        function TabMethods.GetContainer()
            return TabContent
        end
        
        return TabMethods
    end
    
    function WindowMethods.SelectTab(_, tabIndex)
        local tabInfo = TabList[tabIndex]
        if tabInfo then
            SwitchToTab(tabInfo.Name)
        end
    end
    
    function WindowMethods.Divider(_)
        local Divider = Instance.new("Frame")
        Divider.Visible = false
        Divider.BorderSizePixel = 0
        Divider.BackgroundColor3 = Color3.fromRGB(61, 61, 75)
        Divider.Size = UDim2.new(1, 0, 0, 1)
        Divider.BorderColor3 = Color3.fromRGB(61, 61, 75)
        Divider.Name = "Divider"
        Divider.Parent = TabButtonsList
        Divider.Visible = true
    end
    
    function WindowMethods.SetToggleKey(_, keyCode)
        if type(keyCode) == "string" then
            WindowData.ToggleKey = Enum.KeyCode[keyCode]
        else
            WindowData.ToggleKey = keyCode
        end
    end
    
    -- Initialize Window
    Window.Size = UDim2.fromOffset(0, 0)
    CreateTween(Window, {Size = WindowData.Size}, AnimationConfig.Global)
    Window.Visible = true
    IsVisible = true
    
    return WindowMethods
end

return WindowModule

local SectionModule = {}

-- Services
local TweenService = game:GetService("TweenService")

-- Animation Config
local AnimationConfig = {
    Duration = 0.25,
    EasingStyle = Enum.EasingStyle.Quart,
    EasingDirection = Enum.EasingDirection.Out
}

-- Tween Helper Function
local function CreateTween(object, properties, config)
    config = config or AnimationConfig
    local tweenInfo = TweenInfo.new(
        config.Duration,
        config.EasingStyle or Enum.EasingStyle.Linear,
        config.EasingDirection or Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

-- Create Section Function
function SectionModule.CreateSection(parent, config)
    local SectionData = {
        Title = config.Title or "Section",
        State = config.Default or false,
        TextXAlignment = config.TextXAlignment or "Left"
    }
    
    local SectionMethods = {}
    
    -- Create Main Section Frame
    local Section = Instance.new("Frame")
    Section.Visible = false
    Section.BorderSizePixel = 0
    Section.BackgroundColor3 = Color3.fromRGB(43, 46, 53)
    Section.AutomaticSize = Enum.AutomaticSize.Y
    Section.Size = UDim2.new(1, 0, 0, 35)
    Section.Position = UDim2.new(0, 0, 0.43728, 0)
    Section.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Section.Name = "Section"
    Section.BackgroundTransparency = 1
    Section.Parent = parent
    
    -- Create Section Button (Header)
    local SectionButton = Instance.new("ImageButton")
    SectionButton.BorderSizePixel = 0
    SectionButton.AutoButtonColor = false
    SectionButton.BackgroundColor3 = Color3.fromRGB(43, 46, 53)
    SectionButton.Selectable = false
    SectionButton.AutomaticSize = Enum.AutomaticSize.Y
    SectionButton.Size = UDim2.new(1, 0, 0, 35)
    SectionButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
    SectionButton.Name = "Button"
    SectionButton.Parent = Section
    
    local SectionButtonCorner = Instance.new("UICorner")
    SectionButtonCorner.CornerRadius = UDim.new(0, 6)
    SectionButtonCorner.Parent = SectionButton
    
    local SectionButtonStroke = Instance.new("UIStroke")
    SectionButtonStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    SectionButtonStroke.Thickness = 1.5
    SectionButtonStroke.Color = Color3.fromRGB(61, 61, 75)
    SectionButtonStroke.Parent = SectionButton
    
    local SectionButtonPadding = Instance.new("UIPadding")
    SectionButtonPadding.PaddingTop = UDim.new(0, 10)
    SectionButtonPadding.PaddingRight = UDim.new(0, 10)
    SectionButtonPadding.PaddingLeft = UDim.new(0, 10)
    SectionButtonPadding.PaddingBottom = UDim.new(0, 10)
    SectionButtonPadding.Parent = SectionButton
    
    local SectionButtonLayout = Instance.new("UIListLayout")
    SectionButtonLayout.Padding = UDim.new(0, 5)
    SectionButtonLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SectionButtonLayout.Parent = SectionButton
    
    -- Create Section Title
    local SectionTitle = Instance.new("TextLabel")
    SectionTitle.TextWrapped = true
    SectionTitle.Interactable = false
    SectionTitle.BorderSizePixel = 0
    SectionTitle.TextSize = 16
    SectionTitle.TextXAlignment = Enum.TextXAlignment[SectionData.TextXAlignment]
    SectionTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SectionTitle.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
    SectionTitle.TextColor3 = Color3.fromRGB(197, 204, 219)
    SectionTitle.BackgroundTransparency = 1
    SectionTitle.Size = UDim2.new(1, 0, 0, 15)
    SectionTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
    SectionTitle.Text = SectionData.Title
    SectionTitle.Name = "Title"
    SectionTitle.Parent = SectionButton
    
    -- Create Arrow Icon
    local ArrowIcon = Instance.new("ImageButton")
    ArrowIcon.BorderSizePixel = 0
    ArrowIcon.AutoButtonColor = false
    ArrowIcon.BackgroundTransparency = 1
    ArrowIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ArrowIcon.ImageColor3 = Color3.fromRGB(197, 204, 219)
    ArrowIcon.AnchorPoint = Vector2.new(1, 0.5)
    ArrowIcon.Image = "rbxassetid://120292618616139"
    ArrowIcon.Size = UDim2.new(0, 23, 0, 23)
    ArrowIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ArrowIcon.Name = "Arrow"
    ArrowIcon.Position = UDim2.new(1, 0, 0.5, 0)
    ArrowIcon.Parent = SectionTitle
    
    -- Create Section Description (if provided)
    local SectionDescription = nil
    if config.Desc and config.Desc ~= "" then
        SectionDescription = Instance.new("TextLabel")
        SectionDescription.TextWrapped = true
        SectionDescription.Interactable = false
        SectionDescription.BorderSizePixel = 0
        SectionDescription.TextSize = 16
        SectionDescription.TextXAlignment = Enum.TextXAlignment.Left
        SectionDescription.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        SectionDescription.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
        SectionDescription.TextColor3 = Color3.fromRGB(197, 204, 219)
        SectionDescription.BackgroundTransparency = 1
        SectionDescription.Size = UDim2.new(1, 0, 0, 15)
        SectionDescription.Visible = false
        SectionDescription.BorderColor3 = Color3.fromRGB(0, 0, 0)
        SectionDescription.Text = config.Desc
        SectionDescription.LayoutOrder = 1
        SectionDescription.AutomaticSize = Enum.AutomaticSize.Y
        SectionDescription.Name = "Description"
        SectionDescription.Parent = SectionButton
    end
    
    -- Create Section Content Frame
    local SectionContent = Instance.new("Frame")
    SectionContent.Visible = false
    SectionContent.ZIndex = 2
    SectionContent.BorderSizePixel = 0
    SectionContent.BackgroundColor3 = Color3.fromRGB(207, 222, 255)
    SectionContent.AutomaticSize = Enum.AutomaticSize.Y
    SectionContent.Size = UDim2.new(1, 0, 0, 30)
    SectionContent.Position = UDim2.new(0, 0, 0, 35)
    SectionContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
    SectionContent.BackgroundTransparency = 1
    SectionContent.Name = "Frame"
    SectionContent.Parent = Section
    
    local SectionContentLayout = Instance.new("UIListLayout")
    SectionContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    SectionContentLayout.Padding = UDim.new(0, 10)
    SectionContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SectionContentLayout.Parent = SectionContent
    
    local SectionContentPadding = Instance.new("UIPadding")
    SectionContentPadding.PaddingTop = UDim.new(0, 10)
    SectionContentPadding.PaddingRight = UDim.new(0, 8)
    SectionContentPadding.PaddingLeft = UDim.new(0, 8)
    SectionContentPadding.Parent = SectionContent
    
    -- Create Divider
    local SectionDivider = Instance.new("Frame")
    SectionDivider.BorderSizePixel = 0
    SectionDivider.BackgroundColor3 = Color3.fromRGB(61, 61, 75)
    SectionDivider.Size = UDim2.new(1, 0, 0, 3)
    SectionDivider.BorderColor3 = Color3.fromRGB(61, 61, 75)
    SectionDivider.Name = "Divider"
    SectionDivider.Parent = SectionContent
    
    -- Section Toggle Logic
    local function ToggleSection()
        if SectionData.State == true then
            -- Close Section
            SectionContent.Visible = false
            CreateTween(ArrowIcon, {Rotation = 0}, AnimationConfig)
            SectionData.State = false
        else
            -- Open Section
            SectionContent.Visible = true
            CreateTween(ArrowIcon, {Rotation = 90}, AnimationConfig)
            SectionData.State = true
        end
    end
    
    -- Set initial state
    if SectionData.State then
        SectionContent.Visible = true
        ArrowIcon.Rotation = 90
    else
        SectionContent.Visible = false
        ArrowIcon.Rotation = 0
    end
    
    -- Button Click Event
    SectionButton.MouseButton1Click:Connect(function()
        ToggleSection()
    end)
    
    -- Gradient effects (matching OGLIB style)
    local SectionGradient1 = Instance.new("UIGradient")
    SectionGradient1.Enabled = false
    SectionGradient1.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 5, 255)),
        ColorSequenceKeypoint.new(0.16, Color3.fromRGB(0, 158, 255)),
        ColorSequenceKeypoint.new(0.32, Color3.fromRGB(0, 158, 255)),
        ColorSequenceKeypoint.new(0.54, Color3.fromRGB(0, 5, 255)),
        ColorSequenceKeypoint.new(0.782, Color3.fromRGB(0, 158, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 158, 255))
    }
    SectionGradient1.Parent = SectionButton
    
    local SectionGradient2 = Instance.new("UIGradient")
    SectionGradient2.Enabled = false
    SectionGradient2.Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(1, 1)
    }
    SectionGradient2.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 158, 255)),
        ColorSequenceKeypoint.new(0.16, Color3.fromRGB(0, 5, 255)),
        ColorSequenceKeypoint.new(0.32, Color3.fromRGB(0, 158, 255)),
        ColorSequenceKeypoint.new(0.54, Color3.fromRGB(0, 235, 255)),
        ColorSequenceKeypoint.new(0.782, Color3.fromRGB(0, 5, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 158, 255))
    }
    SectionGradient2.Parent = SectionButton
    
    local SectionGradient3 = Instance.new("UIGradient")
    SectionGradient3.Enabled = false
    SectionGradient3.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 158, 255)),
        ColorSequenceKeypoint.new(0.16, Color3.fromRGB(0, 235, 255)),
        ColorSequenceKeypoint.new(0.32, Color3.fromRGB(0, 158, 255)),
        ColorSequenceKeypoint.new(0.54, Color3.fromRGB(0, 5, 255)),
        ColorSequenceKeypoint.new(0.782, Color3.fromRGB(0, 235, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 158, 255))
    }
    SectionGradient3.Parent = SectionButton
    
    local SectionStroke2 = Instance.new("UIStroke")
    SectionStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    SectionStroke2.Thickness = 1.5
    SectionStroke2.Color = Color3.fromRGB(61, 61, 75)
    SectionStroke2.Parent = SectionButton
    
    -- Make section visible
    Section.Visible = true
    
    -- Section Methods
    function SectionMethods.SetTitle(_, title)
        SectionData.Title = title
        SectionTitle.Text = title
    end
    
    function SectionMethods.SetDesc(_, desc)
        if SectionDescription and desc and desc ~= "" then
            SectionDescription.Text = desc
            SectionDescription.Visible = true
        end
    end
    
    function SectionMethods.Open(_)
        if not SectionData.State then
            ToggleSection()
        end
    end
    
    function SectionMethods.Close(_)
        if SectionData.State then
            ToggleSection()
        end
    end
    
    function SectionMethods.Toggle(_)
        ToggleSection()
    end
    
    function SectionMethods.GetContainer(_)
        return SectionContent
    end
    
    function SectionMethods.Destroy(_)
        Section:Destroy()
    end
    
    return SectionMethods
end

return SectionModule