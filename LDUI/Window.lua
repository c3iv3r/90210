local Library = {}

function Library:CreateWindow(config)
    -- Create the main ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "NatHub"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    
    -- Handle GUI protection and parenting
    if protect_gui then
        protect_gui(ScreenGui)
    elseif gethui then
        ScreenGui.Parent = gethui()
    elseif pcall(function()
        game.CoreGui:GetChildren()
    end) then
        ScreenGui.Parent = game:GetService("CoreGui")
    else
        ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    end
    
    -- Create the main Window Frame
    local Window = Instance.new("Frame")
    Window.Name = "Window"
    Window.ZIndex = 0
    Window.BorderSizePixel = 2
    Window.BackgroundColor3 = Color3.fromRGB(37, 40, 47)
    Window.AnchorPoint = Vector2.new(0.5, 0.5)
    Window.Size = config.Size or UDim2.new(0, 528, 0, 334)
    Window.Position = UDim2.new(0.5, 0, 0.5, 0)
    Window.BorderColor3 = Color3.fromRGB(61, 61, 75)
    Window.Parent = ScreenGui
    
    -- Add UICorner
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = Window
    
    -- Add UIStroke
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Transparency = 0.5
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Color = Color3.fromRGB(95, 95, 117)
    UIStroke.Parent = Window
    
    -- Create TopFrame (Title Bar)
    local TopFrame = Instance.new("Frame")
    TopFrame.Name = "TopFrame"
    TopFrame.BorderSizePixel = 0
    TopFrame.BackgroundColor3 = Color3.fromRGB(37, 40, 47)
    TopFrame.ClipsDescendants = true
    TopFrame.Size = UDim2.new(1, 0, 0, 35)
    TopFrame.BorderColor3 = Color3.fromRGB(61, 61, 75)
    TopFrame.Parent = Window
    
    -- Add UICorner to TopFrame
    local TopFrameUICorner = Instance.new("UICorner")
    TopFrameUICorner.CornerRadius = UDim.new(0, 6)
    TopFrameUICorner.Parent = TopFrame
    
    -- Add Border to TopFrame
    local TopFrameBorder = Instance.new("Frame")
    TopFrameBorder.Name = "Border"
    TopFrameBorder.ZIndex = 2
    TopFrameBorder.BorderSizePixel = 0
    TopFrameBorder.BackgroundColor3 = Color3.fromRGB(61, 61, 75)
    TopFrameBorder.AnchorPoint = Vector2.new(0, 1)
    TopFrameBorder.Size = UDim2.new(1, 0, 0, 2)
    TopFrameBorder.Position = UDim2.new(0, 0, 1, 0)
    TopFrameBorder.Parent = TopFrame
    
    -- Add Icon
    local Icon = Instance.new("ImageButton")
    Icon.Name = "Icon"
    Icon.Active = false
    Icon.Interactable = false
    Icon.BorderSizePixel = 0
    Icon.BackgroundTransparency = 1
    Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Icon.AnchorPoint = Vector2.new(0, 0.5)
    Icon.Image = config.Icon or "rbxassetid://113216930555884"
    Icon.Size = UDim2.new(0, 25, 0, 25)
    Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Icon.Position = UDim2.new(0, 10, 0.5, 0)
    Icon.Parent = TopFrame
    
    -- Add UIAspectRatioConstraint to Icon
    local IconAspectRatio = Instance.new("UIAspectRatioConstraint")
    IconAspectRatio.Parent = Icon
    
    -- Add Title
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.TextWrapped = true
    Title.Interactable = false
    Title.BorderSizePixel = 0
    Title.TextSize = 14
    Title.TextScaled = true
    Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Title.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
    Title.TextColor3 = Color3.fromRGB(197, 204, 219)
    Title.BackgroundTransparency = 1
    Title.AnchorPoint = Vector2.new(0.5, 0.5)
    Title.Size = UDim2.new(1, 0, 0, 16)
    Title.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Title.Text = config.Title or "NatHub - v1.2.3"
    Title.Position = UDim2.new(0.5, 0, 0.5, -1)
    Title.Parent = TopFrame
    
    -- Add Subtitle if provided
    if config.Subtitle then
        local Subtitle = Instance.new("TextLabel")
        Subtitle.Name = "Subtitle"
        Subtitle.TextWrapped = true
        Subtitle.Interactable = false
        Subtitle.BorderSizePixel = 0
        Subtitle.TextSize = 12
        Subtitle.TextScaled = true
        Subtitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Subtitle.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
        Subtitle.TextColor3 = Color3.fromRGB(135, 140, 150)
        Subtitle.BackgroundTransparency = 1
        Subtitle.AnchorPoint = Vector2.new(0.5, 0.5)
        Subtitle.Size = UDim2.new(1, 0, 0, 14)
        Subtitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
        Subtitle.Text = config.Subtitle
        Subtitle.Position = UDim2.new(0.5, 0, 0.5, 10)
        Subtitle.Parent = TopFrame
    end
    
    -- Add Close button
    local CloseButton = Instance.new("ImageButton")
    CloseButton.Name = "Close"
    CloseButton.BorderSizePixel = 0
    CloseButton.BackgroundTransparency = 1
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.ImageColor3 = Color3.fromRGB(197, 204, 219)
    CloseButton.AnchorPoint = Vector2.new(1, 0.5)
    CloseButton.Image = "rbxassetid://132453323679056"
    CloseButton.Size = UDim2.new(0, 20, 0, 20)
    CloseButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
    CloseButton.Position = UDim2.new(1, -15, 0.5, 0)
    CloseButton.Parent = TopFrame
    
    -- Add Maximize button if Resizeable
    if config.Resizeable then
        local MaximizeButton = Instance.new("ImageButton")
        MaximizeButton.Name = "Maximize"
        MaximizeButton.BorderSizePixel = 0
        MaximizeButton.BackgroundTransparency = 1
        MaximizeButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        MaximizeButton.ImageColor3 = Color3.fromRGB(197, 204, 219)
        MaximizeButton.AnchorPoint = Vector2.new(1, 0.5)
        MaximizeButton.Image = "rbxassetid://108285848026510"
        MaximizeButton.Size = UDim2.new(0, 15, 0, 15)
        MaximizeButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
        MaximizeButton.Position = UDim2.new(1, -55, 0.5, 0)
        MaximizeButton.Parent = TopFrame
    end
    
    -- Add Hide button
    local HideButton = Instance.new("ImageButton")
    HideButton.Name = "Hide"
    HideButton.BorderSizePixel = 0
    HideButton.BackgroundTransparency = 1
    HideButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    HideButton.ImageColor3 = Color3.fromRGB(197, 204, 219)
    HideButton.AnchorPoint = Vector2.new(1, 0.5)
    HideButton.Image = "rbxassetid://128209591224511"
    HideButton.Size = UDim2.new(0, 20, 0, 20)
    HideButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
    HideButton.Position = UDim2.new(1, -90, 0.5, 0)
    HideButton.Parent = TopFrame
    
    -- Create TabButtons (Left Side Navigation)
    local TabButtons = Instance.new("Frame")
    TabButtons.Name = "TabButtons"
    TabButtons.BorderSizePixel = 0
    TabButtons.BackgroundColor3 = Color3.fromRGB(37, 40, 47)
    TabButtons.ClipsDescendants = true
    TabButtons.Size = UDim2.new(0, 165, 1, -35)
    TabButtons.Position = UDim2.new(0, 0, 0, 35)
    TabButtons.BorderColor3 = Color3.fromRGB(61, 61, 75)
    TabButtons.SelectionGroup = true
    TabButtons.Parent = Window
    
    -- Add UICorner to TabButtons
    local TabButtonsUICorner = Instance.new("UICorner")
    TabButtonsUICorner.CornerRadius = UDim.new(0, 6)
    TabButtonsUICorner.Parent = TabButtons
    
    -- Add AntiCornerTop to TabButtons
    local TabButtonsAntiCornerTop = Instance.new("Frame")
    TabButtonsAntiCornerTop.Name = "AntiCornerTop"
    TabButtonsAntiCornerTop.BorderSizePixel = 0
    TabButtonsAntiCornerTop.BackgroundColor3 = Color3.fromRGB(37, 40, 47)
    TabButtonsAntiCornerTop.Size = UDim2.new(1, 0, 0, 5)
    TabButtonsAntiCornerTop.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TabButtonsAntiCornerTop.Parent = TabButtons
    
    -- Add AntiCornerRight to TabButtons
    local TabButtonsAntiCornerRight = Instance.new("Frame")
    TabButtonsAntiCornerRight.Name = "AntiCornerRight"
    TabButtonsAntiCornerRight.BorderSizePixel = 0
    TabButtonsAntiCornerRight.BackgroundColor3 = Color3.fromRGB(37, 40, 47)
    TabButtonsAntiCornerRight.AnchorPoint = Vector2.new(0.5, 0)
    TabButtonsAntiCornerRight.Size = UDim2.new(0, 2, 1, 0)
    TabButtonsAntiCornerRight.Position = UDim2.new(1, 1, 0, 0)
    TabButtonsAntiCornerRight.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TabButtonsAntiCornerRight.Parent = TabButtons
    
    -- Add Border to TabButtons
    local TabButtonsBorder = Instance.new("Frame")
    TabButtonsBorder.Name = "Border"
    TabButtonsBorder.ZIndex = 2
    TabButtonsBorder.BorderSizePixel = 0
    TabButtonsBorder.BackgroundColor3 = Color3.fromRGB(61, 61, 75)
    TabButtonsBorder.AnchorPoint = Vector2.new(1, 0)
    TabButtonsBorder.Size = UDim2.new(0, 2, 1, 0)
    TabButtonsBorder.Position = UDim2.new(1, 0, 0, 0)
    TabButtonsBorder.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TabButtonsBorder.Parent = TabButtons
    
    -- Create ScrollingFrame for TabButtons
    local TabButtonsList = Instance.new("ScrollingFrame")
    TabButtonsList.Name = "Lists"
    TabButtonsList.Active = true
    TabButtonsList.ScrollingDirection = Enum.ScrollingDirection.Y
    TabButtonsList.BorderSizePixel = 0
    TabButtonsList.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabButtonsList.ElasticBehavior = Enum.ElasticBehavior.Never
    TabButtonsList.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
    TabButtonsList.BackgroundColor3 = Color3.fromRGB(37, 40, 47)
    TabButtonsList.Selectable = false
    TabButtonsList.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
    TabButtonsList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabButtonsList.Size = UDim2.new(1, 0, 1, 0)
    TabButtonsList.BorderColor3 = Color3.fromRGB(61, 61, 75)
    TabButtonsList.ScrollBarThickness = 4
    TabButtonsList.BackgroundTransparency = 1
    TabButtonsList.Parent = TabButtons
    
    -- Add UIListLayout to TabButtonsList
    local TabButtonsListLayout = Instance.new("UIListLayout")
    TabButtonsListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabButtonsListLayout.Parent = TabButtonsList
    
    -- Add UIPadding to TabButtonsList
    local TabButtonsListPadding = Instance.new("UIPadding")
    TabButtonsListPadding.PaddingTop = UDim.new(0, 8)
    TabButtonsListPadding.Parent = TabButtonsList
    
    -- Create Tabs (Content Area)
    local Tabs = Instance.new("Frame")
    Tabs.Name = "Tabs"
    Tabs.BorderSizePixel = 0
    Tabs.BackgroundColor3 = Color3.fromRGB(32, 35, 41)
    Tabs.Size = UDim2.new(1, -165, 1, -35)
    Tabs.Position = UDim2.new(0, 165, 0, 35)
    Tabs.BorderColor3 = Color3.fromRGB(61, 61, 75)
    Tabs.Parent = Window
    
    -- Add UICorner to Tabs
    local TabsUICorner = Instance.new("UICorner")
    TabsUICorner.CornerRadius = UDim.new(0, 6)
    TabsUICorner.Parent = Tabs
    
    -- Add AntiCornerLeft to Tabs
    local TabsAntiCornerLeft = Instance.new("Frame")
    TabsAntiCornerLeft.Name = "AntiCornerLeft"
    TabsAntiCornerLeft.Visible = false
    TabsAntiCornerLeft.BorderSizePixel = 0
    TabsAntiCornerLeft.BackgroundColor3 = Color3.fromRGB(32, 35, 41)
    TabsAntiCornerLeft.Size = UDim2.new(0, 5, 1, 0)
    TabsAntiCornerLeft.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TabsAntiCornerLeft.Parent = Tabs
    
    -- Add AntiCornerTop to Tabs
    local TabsAntiCornerTop = Instance.new("Frame")
    TabsAntiCornerTop.Name = "AntiCornerTop"
    TabsAntiCornerTop.BorderSizePixel = 0
    TabsAntiCornerTop.BackgroundColor3 = Color3.fromRGB(32, 35, 41)
    TabsAntiCornerTop.Size = UDim2.new(1, 0, 0, 5)
    TabsAntiCornerTop.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TabsAntiCornerTop.Parent = Tabs
    
    -- Add NoObjectFoundText to Tabs
    local NoObjectFoundText = Instance.new("TextLabel")
    NoObjectFoundText.Name = "NoObjectFoundText"
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
    NoObjectFoundText.Position = UDim2.new(0.5, 0, 0.45, 0)
    NoObjectFoundText.Parent = Tabs
    
    -- Create NotificationFrame
    local NotificationFrame = Instance.new("Frame")
    NotificationFrame.Name = "NotificationFrame"
    NotificationFrame.BorderSizePixel = 0
    NotificationFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NotificationFrame.ClipsDescendants = true
    NotificationFrame.Size = UDim2.new(1, 0, 1, 0)
    NotificationFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    NotificationFrame.BackgroundTransparency = 1
    NotificationFrame.Parent = Window
    
    -- Create NotificationList
    local NotificationList = Instance.new("Frame")
    NotificationList.Name = "NotificationList"
    NotificationList.ZIndex = 5
    NotificationList.BorderSizePixel = 0
    NotificationList.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NotificationList.AnchorPoint = Vector2.new(0.5, 0)
    NotificationList.ClipsDescendants = true
    NotificationList.Size = UDim2.new(0, 630, 1, -35)
    NotificationList.Position = UDim2.new(1, 0, 0, 35)
    NotificationList.BorderColor3 = Color3.fromRGB(0, 0, 0)
    NotificationList.BackgroundTransparency = 1
    NotificationList.Parent = NotificationFrame
    
    -- Add UIListLayout to NotificationList
    local NotificationListLayout = Instance.new("UIListLayout")
    NotificationListLayout.Padding = UDim.new(0, 12)
    NotificationListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    NotificationListLayout.Parent = NotificationList
    
    -- Add UIPadding to NotificationList
    local NotificationListPadding = Instance.new("UIPadding")
    NotificationListPadding.PaddingTop = UDim.new(0, 10)
    NotificationListPadding.PaddingRight = UDim.new(0, 40)
    NotificationListPadding.PaddingLeft = UDim.new(0, 40)
    NotificationListPadding.PaddingBottom = UDim.new(0, 10)
    NotificationListPadding.Parent = NotificationList
    
    -- Create DarkOverlay
    local DarkOverlay = Instance.new("Frame")
    DarkOverlay.Name = "DarkOverlay"
    DarkOverlay.Visible = false
    DarkOverlay.BorderSizePixel = 0
    DarkOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    DarkOverlay.Size = UDim2.new(1, 0, 1, 0)
    DarkOverlay.BorderColor3 = Color3.fromRGB(0, 0, 0)
    DarkOverlay.BackgroundTransparency = 0.6
    DarkOverlay.Parent = Window
    
    -- Add UICorner to DarkOverlay
    local DarkOverlayUICorner = Instance.new("UICorner")
    DarkOverlayUICorner.CornerRadius = UDim.new(0, 10)
    DarkOverlayUICorner.Parent = DarkOverlay
    
    -- Create DropdownSelection
    local DropdownSelection = Instance.new("Frame")
    DropdownSelection.Name = "DropdownSelection"
    DropdownSelection.Visible = false
    DropdownSelection.ZIndex = 4
    DropdownSelection.BorderSizePixel = 0
    DropdownSelection.BackgroundColor3 = Color3.fromRGB(32, 35, 41)
    DropdownSelection.AnchorPoint = Vector2.new(0.5, 0.5)
    DropdownSelection.ClipsDescendants = true
    DropdownSelection.Size = UDim2.new(0.7281, 0, 0.68367, 0)
    DropdownSelection.Position = UDim2.new(0.5, 0, 0.5, 0)
    DropdownSelection.BorderColor3 = Color3.fromRGB(61, 61, 75)
    DropdownSelection.Parent = Window
    
    -- Add UICorner to DropdownSelection
    local DropdownSelectionUICorner = Instance.new("UICorner")
    DropdownSelectionUICorner.CornerRadius = UDim.new(0, 6)
    DropdownSelectionUICorner.Parent = DropdownSelection
    
    -- Add UIStroke to DropdownSelection
    local DropdownSelectionStroke = Instance.new("UIStroke")
    DropdownSelectionStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    DropdownSelectionStroke.Thickness = 1.5
    DropdownSelectionStroke.Color = Color3.fromRGB(61, 61, 75)
    DropdownSelectionStroke.Parent = DropdownSelection
    
    -- Create TopBar for DropdownSelection
    local DropdownTopBar = Instance.new("Frame")
    DropdownTopBar.Name = "TopBar"
    DropdownTopBar.BorderSizePixel = 0
    DropdownTopBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    DropdownTopBar.Size = UDim2.new(1, 0, 0, 50)
    DropdownTopBar.Position = UDim2.new(0, 0, 0, 0)
    DropdownTopBar.BorderColor3 = Color3.fromRGB(0, 0, 0)
    DropdownTopBar.BackgroundTransparency = 1
    DropdownTopBar.Parent = DropdownSelection
    
    -- Create BoxFrame for DropdownTopBar
    local BoxFrame = Instance.new("Frame")
    BoxFrame.Name = "BoxFrame"
    BoxFrame.BorderSizePixel = 0
    BoxFrame.AnchorPoint = Vector2.new(1, 0.5)
    BoxFrame.Size = UDim2.new(0, 120, 0, 25)
    BoxFrame.Position = UDim2.new(1, -50, 0.5, 0)
    BoxFrame.BackgroundTransparency = 1
    BoxFrame.Parent = DropdownTopBar
    
    -- Create DropShadow for BoxFrame
    local BoxFrameDropShadow = Instance.new("ImageLabel")
    BoxFrameDropShadow.Name = "DropShadow"
    BoxFrameDropShadow.ZIndex = 0
    BoxFrameDropShadow.BorderSizePixel = 0
    BoxFrameDropShadow.SliceCenter = Rect.new(49, 49, 450, 450)
    BoxFrameDropShadow.ScaleType = Enum.ScaleType.Slice
    BoxFrameDropShadow.ImageTransparency = 0.75
    BoxFrameDropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    BoxFrameDropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    BoxFrameDropShadow.Image = "rbxassetid://6014261993"
    BoxFrameDropShadow.Size = UDim2.new(1, 30, 1, 30)
    BoxFrameDropShadow.BackgroundTransparency = 1
    BoxFrameDropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    BoxFrameDropShadow.Parent = BoxFrame
    
    -- Create Box for BoxFrame
    local Box = Instance.new("Frame")
    Box.BorderSizePixel = 0
    Box.BackgroundColor3 = Color3.fromRGB(43, 46, 53)
    Box.AutomaticSize = Enum.AutomaticSize.Y
    Box.Size = UDim2.new(1, 0, 1, 0)
    Box.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Box.Parent = BoxFrame
    
    -- Add UICorner to Box
    local BoxUICorner = Instance.new("UICorner")
    BoxUICorner.CornerRadius = UDim.new(0, 5)
    BoxUICorner.Parent = Box
    
    -- Add UIStroke to Box
    local BoxStroke = Instance.new("UIStroke")
    BoxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    BoxStroke.Thickness = 1.5
    BoxStroke.Color = Color3.fromRGB(61, 61, 75)
    BoxStroke.Parent = Box
    
    -- Create TextBox for Box
    local DropdownTextBox = Instance.new("TextBox")
    DropdownTextBox.TextXAlignment = Enum.TextXAlignment.Left
    DropdownTextBox.BorderSizePixel = 0
    DropdownTextBox.TextWrapped = true
    DropdownTextBox.TextTruncate = Enum.TextTruncate.AtEnd
    DropdownTextBox.TextSize = 14
    DropdownTextBox.TextColor3 = Color3.fromRGB(197, 204, 219)
    DropdownTextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    DropdownTextBox.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    DropdownTextBox.ClipsDescendants = true
    DropdownTextBox.PlaceholderText = "Input here..."
    DropdownTextBox.Size = UDim2.new(1, -25, 1, 0)
    DropdownTextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
    DropdownTextBox.Text = ""
    DropdownTextBox.BackgroundTransparency = 1
    DropdownTextBox.Parent = Box
    
    -- Add UIPadding to DropdownTextBox
    local DropdownTextBoxPadding = Instance.new("UIPadding")
    DropdownTextBoxPadding.PaddingTop = UDim.new(0, 10)
    DropdownTextBoxPadding.PaddingRight = UDim.new(0, 10)
    DropdownTextBoxPadding.PaddingLeft = UDim.new(0, 10)
    DropdownTextBoxPadding.PaddingBottom = UDim.new(0, 10)
    DropdownTextBoxPadding.Parent = DropdownTextBox
    
    -- Create SearchIcon for Box
    local SearchIcon = Instance.new("ImageButton")
    SearchIcon.BorderSizePixel = 0
    SearchIcon.BackgroundTransparency = 1
    SearchIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SearchIcon.ImageColor3 = Color3.fromRGB(197, 204, 219)
    SearchIcon.AnchorPoint = Vector2.new(1, 0.5)
    SearchIcon.Image = "rbxassetid://86928976705683"
    SearchIcon.Size = UDim2.new(0, 15, 0, 15)
    SearchIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
    SearchIcon.Position = UDim2.new(1, -5, 0.5, 0)
    SearchIcon.Parent = Box
    
    -- Create CloseButton for DropdownTopBar
    local DropdownCloseButton = Instance.new("ImageButton")
    DropdownCloseButton.Name = "Close"
    DropdownCloseButton.BorderSizePixel = 0
    DropdownCloseButton.BackgroundTransparency = 1
    DropdownCloseButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    DropdownCloseButton.ImageColor3 = Color3.fromRGB(197, 204, 219)
    DropdownCloseButton.ZIndex = 0
    DropdownCloseButton.AnchorPoint = Vector2.new(1, 0.5)
    DropdownCloseButton.Image = "rbxassetid://132453323679056"
    DropdownCloseButton.Size = UDim2.new(0, 25, 0, 25)
    DropdownCloseButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
    DropdownCloseButton.Position = UDim2.new(1, -12, 0.5, 0)
    DropdownCloseButton.Parent = DropdownTopBar
    
    -- Create Title for DropdownTopBar
    local DropdownTitle = Instance.new("TextLabel")
    DropdownTitle.Name = "Title"
    DropdownTitle.TextWrapped = true
    DropdownTitle.Interactable = false
    DropdownTitle.ZIndex = 0
    DropdownTitle.BorderSizePixel = 0
    DropdownTitle.TextSize = 18
    DropdownTitle.TextXAlignment = Enum.TextXAlignment.Left
    DropdownTitle.TextScaled = true
    DropdownTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    DropdownTitle.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
    DropdownTitle.TextColor3 = Color3.fromRGB(197, 204, 219)
    DropdownTitle.BackgroundTransparency = 1
    DropdownTitle.AnchorPoint = Vector2.new(0, 0.5)
    DropdownTitle.Size = UDim2.new(0.5, 0, 0, 18)
    DropdownTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
    DropdownTitle.Text = "Dropdown"
    DropdownTitle.Position = UDim2.new(0, 12, 0.5, 0)
    DropdownTitle.Parent = DropdownTopBar
    
    -- Create Dropdowns folder for DropdownSelection
    local Dropdowns = Instance.new("Folder")
    Dropdowns.Name = "Dropdowns"
    Dropdowns.Parent = DropdownSelection
    
    -- Create Templates folder
    local Templates = Instance.new("Folder")
    Templates.Name = "Templates"
    Templates.Parent = ScreenGui
    
    -- Create Divider template
    local DividerTemplate = Instance.new("Frame")
    DividerTemplate.Name = "Divider"
    DividerTemplate.Visible = false
    DividerTemplate.BorderSizePixel = 0
    DividerTemplate.BackgroundColor3 = Color3.fromRGB(61, 61, 75)
    DividerTemplate.Size = UDim2.new(1, 0, 0, 1)
    DividerTemplate.BorderColor3 = Color3.fromRGB(61, 61, 75)
    DividerTemplate.Parent = Templates
    
    -- Create Tab template
    local TabTemplate = Instance.new("ScrollingFrame")
    TabTemplate.Name = "Tab"
    TabTemplate.Visible = false
    TabTemplate.Active = true
    TabTemplate.ScrollingDirection = Enum.ScrollingDirection.Y
    TabTemplate.BorderSizePixel = 0
    TabTemplate.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabTemplate.ElasticBehavior = Enum.ElasticBehavior.Never
    TabTemplate.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
    TabTemplate.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TabTemplate.Selectable = false
    TabTemplate.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
    TabTemplate.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabTemplate.Size = UDim2.new(1, 0, 1, 0)
    TabTemplate.ScrollBarImageColor3 = Color3.fromRGB(99, 106, 122)
    TabTemplate.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TabTemplate.ScrollBarThickness = 5
    TabTemplate.BackgroundTransparency = 1
    TabTemplate.Parent = Templates
    
    -- Add UIListLayout to TabTemplate
    local TabTemplateLayout = Instance.new("UIListLayout")
    TabTemplateLayout.Padding = UDim.new(0, 15)
    TabTemplateLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabTemplateLayout.Parent = TabTemplate
    
    -- Add UIPadding to TabTemplate
    local TabTemplatePadding = Instance.new("UIPadding")
    TabTemplatePadding.PaddingTop = UDim.new(0, 10)
    TabTemplatePadding.PaddingRight = UDim.new(0, 14)
    TabTemplatePadding.PaddingLeft = UDim.new(0, 10)
    TabTemplatePadding.PaddingBottom = UDim.new(0, 10)
    TabTemplatePadding.Parent = TabTemplate
    
    -- Create TabButton template
    local TabButtonTemplate = Instance.new("ImageButton")
    TabButtonTemplate.Name = "TabButton"
    TabButtonTemplate.BorderSizePixel = 0
    TabButtonTemplate.AutoButtonColor = false
    TabButtonTemplate.Visible = false
    TabButtonTemplate.BackgroundTransparency = 1
    TabButtonTemplate.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TabButtonTemplate.Selectable = false
    TabButtonTemplate.Size = UDim2.new(1, 0, 0, 36)
    TabButtonTemplate.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TabButtonTemplate.Parent = Templates
    
    -- Create Icon for TabButtonTemplate
    local TabButtonIcon = Instance.new("ImageButton")
    TabButtonIcon.BorderSizePixel = 0
    TabButtonIcon.ImageTransparency = 0.5
    TabButtonIcon.BackgroundTransparency = 1
    TabButtonIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TabButtonIcon.ImageColor3 = Color3.fromRGB(197, 204, 219)
    TabButtonIcon.AnchorPoint = Vector2.new(0, 0.5)
    TabButtonIcon.Image = "rbxassetid://113216930555884"
    TabButtonIcon.Size = UDim2.new(0, 20, 0, 20)
    TabButtonIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TabButtonIcon.Position = UDim2.new(0, 12, 0, 18)
    TabButtonIcon.Parent = TabButtonTemplate
    
    -- Add UIAspectRatioConstraint to TabButtonIcon
    local TabButtonIconAspect = Instance.new("UIAspectRatioConstraint")
    TabButtonIconAspect.Parent = TabButtonIcon
    
    -- Create Title for TabButtonTemplate
    local TabButtonTitle = Instance.new("TextLabel")
    TabButtonTitle.TextWrapped = true
    TabButtonTitle.BorderSizePixel = 0
    TabButtonTitle.TextSize = 14
    TabButtonTitle.TextXAlignment = Enum.TextXAlignment.Left
    TabButtonTitle.TextTransparency = 0.5
    TabButtonTitle.TextScaled = true
    TabButtonTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TabButtonTitle.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    TabButtonTitle.TextColor3 = Color3.fromRGB(197, 204, 219)
    TabButtonTitle.BackgroundTransparency = 1
    TabButtonTitle.AnchorPoint = Vector2.new(0, 0.5)
    TabButtonTitle.Size = UDim2.new(0, 103, 0, 16)
    TabButtonTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TabButtonTitle.Text = ""
    TabButtonTitle.Position = UDim2.new(0, 42, 0.5, 0)
    TabButtonTitle.Parent = TabButtonTemplate
    
    -- Create Bar for TabButtonTemplate
    local TabButtonBar = Instance.new("Frame")
    TabButtonBar.Name = "Bar"
    TabButtonBar.BorderSizePixel = 0
    TabButtonBar.BackgroundColor3 = Color3.fromRGB(197, 204, 219)
    TabButtonBar.AnchorPoint = Vector2.new(0, 0.5)
    TabButtonBar.Size = UDim2.new(0, 5, 0, 0)
    TabButtonBar.Position = UDim2.new(0, 8, 0, 18)
    TabButtonBar.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TabButtonBar.BackgroundTransparency = 1
    TabButtonBar.Parent = TabButtonTemplate
    
    -- Add UICorner to TabButtonBar
    local TabButtonBarCorner = Instance.new("UICorner")
    TabButtonBarCorner.CornerRadius = UDim.new(0, 100)
    TabButtonBarCorner.Parent = TabButtonBar
    
    -- Create Button template
    local ButtonTemplate = Instance.new("ImageButton")
    ButtonTemplate.Name = "Button"
    ButtonTemplate.BorderSizePixel = 0
    ButtonTemplate.AutoButtonColor = false
    ButtonTemplate.Visible = false
    ButtonTemplate.BackgroundColor3 = Color3.fromRGB(43, 46, 53)
    ButtonTemplate.Selectable = false
    ButtonTemplate.AutomaticSize = Enum.AutomaticSize.Y
    ButtonTemplate.Size = UDim2.new(1, 0, 0, 35)
    ButtonTemplate.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ButtonTemplate.Position = UDim2.new(0, 0, 0.384, 0)
    ButtonTemplate.Parent = Templates
    
    -- Add UICorner to ButtonTemplate
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 6)
    ButtonCorner.Parent = ButtonTemplate
    
    -- Add UIStroke to ButtonTemplate
    local ButtonStroke = Instance.new("UIStroke")
    ButtonStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    ButtonStroke.Thickness = 1.5
    ButtonStroke.Color = Color3.fromRGB(61, 61, 75)
    ButtonStroke.Parent = ButtonTemplate
    
    -- Create ButtonContent for ButtonTemplate
    local ButtonContent = Instance.new("Frame")
    ButtonContent.BorderSizePixel = 0
    ButtonContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ButtonContent.AutomaticSize = Enum.AutomaticSize.Y
    ButtonContent.Size = UDim2.new(1, 0, 0, 35)
    ButtonContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ButtonContent.BackgroundTransparency = 1
    ButtonContent.Parent = ButtonTemplate
    
    -- Add UIListLayout to ButtonContent
    local ButtonContentLayout = Instance.new("UIListLayout")
    ButtonContentLayout.Padding = UDim.new(0, 5)
    ButtonContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ButtonContentLayout.Parent = ButtonContent
    
    -- Add UIPadding to ButtonContent
    local ButtonContentPadding = Instance.new("UIPadding")
    ButtonContentPadding.PaddingTop = UDim.new(0, 10)
    ButtonContentPadding.PaddingRight = UDim.new(0, 10)
    ButtonContentPadding.PaddingLeft = UDim.new(0, 10)
    ButtonContentPadding.PaddingBottom = UDim.new(0, 10)
    ButtonContentPadding.Parent = ButtonContent
    
    -- Create ButtonTitle for ButtonContent
    local ButtonTitle = Instance.new("TextLabel")
    ButtonTitle.Name = "Title"
    ButtonTitle.TextWrapped = true
    ButtonTitle.Interactable = false
    ButtonTitle.BorderSizePixel = 0
    ButtonTitle.TextSize = 16
    ButtonTitle.TextXAlignment = Enum.TextXAlignment.Left
    ButtonTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ButtonTitle.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
    ButtonTitle.TextColor3 = Color3.fromRGB(197, 204, 219)
    ButtonTitle.BackgroundTransparency = 1
    ButtonTitle.Size = UDim2.new(1, 0, 0, 15)
    ButtonTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ButtonTitle.Text = "Button"
    ButtonTitle.Parent = ButtonContent
    
    -- Create ClickIcon for ButtonTitle
    local ClickIcon = Instance.new("ImageButton")
    ClickIcon.Name = "ClickIcon"
    ClickIcon.BorderSizePixel = 0
    ClickIcon.AutoButtonColor = false
    ClickIcon.BackgroundTransparency = 1
    ClickIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ClickIcon.ImageColor3 = Color3.fromRGB(197, 204, 219)
    ClickIcon.AnchorPoint = Vector2.new(1, 0.5)
    ClickIcon.Image = "rbxassetid://91877599529856"
    ClickIcon.Size = UDim2.new(0, 23, 0, 23)
    ClickIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ClickIcon.Position = UDim2.new(1, 0, 0.5, 0)
    ClickIcon.Parent = ButtonTitle
    
    -- Create ButtonDescription for ButtonContent
    local ButtonDescription = Instance.new("TextLabel")
    ButtonDescription.Name = "Description"
    ButtonDescription.TextWrapped = true
    ButtonDescription.Interactable = false
    ButtonDescription.BorderSizePixel = 0
    ButtonDescription.TextSize = 16
    ButtonDescription.TextXAlignment = Enum.TextXAlignment.Left
    ButtonDescription.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ButtonDescription.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    ButtonDescription.TextColor3 = Color3.fromRGB(197, 204, 219)
    ButtonDescription.BackgroundTransparency = 1
    ButtonDescription.Size = UDim2.new(1, 0, 0, 15)
    ButtonDescription.Visible = false
    ButtonDescription.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ButtonDescription.Text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus placerat lacus in enim congue, fermentum euismod leo ultricies. Nulla sodales."
    ButtonDescription.LayoutOrder = 1
    ButtonDescription.AutomaticSize = Enum.AutomaticSize.Y
    ButtonDescription.Parent = ButtonContent
    
    -- Add UIGradient to ButtonContent
    local ButtonGradient1 = Instance.new("UIGradient")
    ButtonGradient1.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 5, 255)),
        ColorSequenceKeypoint.new(0.16, Color3.fromRGB(0, 158, 255)),
        ColorSequenceKeypoint.new(0.32, Color3.fromRGB(0, 158, 255)),
        ColorSequenceKeypoint.new(0.54, Color3.fromRGB(0, 5, 255)),
        ColorSequenceKeypoint.new(0.782, Color3.fromRGB(0, 158, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 158, 255))
    }
    ButtonGradient1.Parent = ButtonContent
    
    local ButtonGradient2 = Instance.new("UIGradient")
    ButtonGradient2.Enabled = false
    ButtonGradient2.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 158, 255)),
        ColorSequenceKeypoint.new(0.16, Color3.fromRGB(0, 235, 255)),
        ColorSequenceKeypoint.new(0.32, Color3.fromRGB(0, 158, 255)),
        ColorSequenceKeypoint.new(0.54, Color3.fromRGB(0, 5, 255)),
        ColorSequenceKeypoint.new(0.782, Color3.fromRGB(0, 235, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 158, 255))
    }
    ButtonGradient2.Parent = ButtonContent
    
    local ButtonGradient3 = Instance.new("UIGradient")
    ButtonGradient3.Enabled = false
    ButtonGradient3.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 158, 255)),
        ColorSequenceKeypoint.new(0.16, Color3.fromRGB(0, 5, 255)),
        ColorSequenceKeypoint.new(0.32, Color3.fromRGB(0, 158, 255)),
        ColorSequenceKeypoint.new(0.54, Color3.fromRGB(0, 235, 255)),
        ColorSequenceKeypoint.new(0.782, Color3.fromRGB(0, 5, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 158, 255))
    }
    ButtonGradient3.Parent = ButtonContent
    
    -- Add UICorner to ButtonContent
    local ButtonContentCorner = Instance.new("UICorner")
    ButtonContentCorner.CornerRadius = UDim.new(0, 6)
    ButtonContentCorner.Parent = ButtonContent
    
    -- Create Paragraph template
    local ParagraphTemplate = Instance.new("Frame")
    ParagraphTemplate.Name = "Paragraph"
    ParagraphTemplate.Visible = false
    ParagraphTemplate.BorderSizePixel = 0
    ParagraphTemplate.BackgroundColor3 = Color3.fromRGB(43, 46, 53)
    ParagraphTemplate.AutomaticSize = Enum.AutomaticSize.Y
    ParagraphTemplate.Size = UDim2.new(1, 0, 0, 35)
    ParagraphTemplate.Position = UDim2.new(-0.0375, 0, 0.38434, 0)
    ParagraphTemplate.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ParagraphTemplate.Parent = Templates
    
    -- Add UICorner to ParagraphTemplate
    local ParagraphCorner = Instance.new("UICorner")
    ParagraphCorner.CornerRadius = UDim.new(0, 6)
    ParagraphCorner.Parent = ParagraphTemplate
    
    -- Add UIStroke to ParagraphTemplate
    local ParagraphStroke = Instance.new("UIStroke")
    ParagraphStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    ParagraphStroke.Thickness = 1.5
    ParagraphStroke.Color = Color3.fromRGB(61, 61, 75)
    ParagraphStroke.Parent = ParagraphTemplate
    
    -- Create ParagraphTitle for ParagraphTemplate
    local ParagraphTitle = Instance.new("TextLabel")
    ParagraphTitle.Name = "Title"
    ParagraphTitle.TextWrapped = true
    ParagraphTitle.Interactable = false
    ParagraphTitle.BorderSizePixel = 0
    ParagraphTitle.TextSize = 16
    ParagraphTitle.TextXAlignment = Enum.TextXAlignment.Left
    ParagraphTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ParagraphTitle.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    ParagraphTitle.TextColor3 = Color3.fromRGB(197, 204, 219)
    ParagraphTitle.BackgroundTransparency = 1
    ParagraphTitle.Size = UDim2.new(1, 0, 0, 15)
    ParagraphTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ParagraphTitle.Text = "Title"
    ParagraphTitle.AutomaticSize = Enum.AutomaticSize.Y
    ParagraphTitle.Parent = ParagraphTemplate
    
    -- Add UIPadding to ParagraphTemplate
    local ParagraphPadding = Instance.new("UIPadding")
    ParagraphPadding.PaddingTop = UDim.new(0, 10)
    ParagraphPadding.PaddingRight = UDim.new(0, 10)
    ParagraphPadding.PaddingLeft = UDim.new(0, 10)
    ParagraphPadding.PaddingBottom = UDim.new(0, 10)
    ParagraphPadding.Parent = ParagraphTemplate
    
    -- Add UIListLayout to ParagraphTemplate
    local ParagraphLayout = Instance.new("UIListLayout")
    ParagraphLayout.Padding = UDim.new(0, 5)
    ParagraphLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ParagraphLayout.Parent = ParagraphTemplate
    
    -- Create ParagraphDescription for ParagraphTemplate
    local ParagraphDescription = Instance.new("TextLabel")
    ParagraphDescription.Name = "Description"
    ParagraphDescription.TextWrapped = true
    ParagraphDescription.Interactable = false
    ParagraphDescription.BorderSizePixel = 0
    ParagraphDescription.TextSize = 16
    ParagraphDescription.TextXAlignment = Enum.TextXAlignment.Left
    ParagraphDescription.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ParagraphDescription.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    ParagraphDescription.TextColor3 = Color3.fromRGB(197, 204, 219)
    ParagraphDescription.BackgroundTransparency = 1
    ParagraphDescription.Size = UDim2.new(1, 0, 0, 15)
    ParagraphDescription.Visible = false
    ParagraphDescription.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ParagraphDescription.Text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus placerat lacus in enim congue, fermentum euismod leo ultricies. Nulla sodales."
    ParagraphDescription.LayoutOrder = 1
    ParagraphDescription.AutomaticSize = Enum.AutomaticSize.Y
    ParagraphDescription.Parent = ParagraphTemplate
    
    -- Create Toggle template
    local ToggleTemplate = Instance.new("ImageButton")
    ToggleTemplate.Name = "Toggle"
    ToggleTemplate.BorderSizePixel = 0
    ToggleTemplate.AutoButtonColor = false
    ToggleTemplate.Visible = false
    ToggleTemplate.BackgroundColor3 = Color3.fromRGB(43, 46, 53)
    ToggleTemplate.Selectable = false
    ToggleTemplate.AutomaticSize = Enum.AutomaticSize.Y
    ToggleTemplate.Size = UDim2.new(1, 0, 0, 35)
    ToggleTemplate.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ToggleTemplate.Position = UDim2.new(-0.0375, 0, 0.38434, 0)
    ToggleTemplate.Parent = Templates
    
    -- Add UICorner to ToggleTemplate
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 6)
    ToggleCorner.Parent = ToggleTemplate
    
    -- Add UIStroke to ToggleTemplate
    local ToggleStroke = Instance.new("UIStroke")
    ToggleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    ToggleStroke.Thickness = 1.5
    ToggleStroke.Color = Color3.fromRGB(61, 61, 75)
    ToggleStroke.Parent = ToggleTemplate
    
    -- Add UIPadding to ToggleTemplate
    local TogglePadding = Instance.new("UIPadding")
    TogglePadding.PaddingTop = UDim.new(0, 10)
    TogglePadding.PaddingRight = UDim.new(0, 10)
    TogglePadding.PaddingLeft = UDim.new(0, 10)
    TogglePadding.PaddingBottom = UDim.new(0, 10)
    TogglePadding.Parent = ToggleTemplate
    
    -- Add UIListLayout to ToggleTemplate
    local ToggleLayout = Instance.new("UIListLayout")
    ToggleLayout.Padding = UDim.new(0, 5)
    ToggleLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ToggleLayout.Parent = ToggleTemplate
    
    -- Create ToggleDescription for ToggleTemplate
    local ToggleDescription = Instance.new("TextLabel")
    ToggleDescription.Name = "Description"
    ToggleDescription.TextWrapped = true
    ToggleDescription.Interactable = false
    ToggleDescription.BorderSizePixel = 0
    ToggleDescription.TextSize = 16
    ToggleDescription.TextXAlignment = Enum.TextXAlignment.Left
    ToggleDescription.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ToggleDescription.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    ToggleDescription.TextColor3 = Color3.fromRGB(197, 204, 219)
    ToggleDescription.BackgroundTransparency = 1
    ToggleDescription.Size = UDim2.new(1, 0, 0, 15)
    ToggleDescription.Visible = false
    ToggleDescription.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ToggleDescription.Text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus placerat lacus in enim congue, fermentum euismod leo ultricies. Nulla sodales."
    ToggleDescription.LayoutOrder = 1
    ToggleDescription.AutomaticSize = Enum.AutomaticSize.Y
    ToggleDescription.Parent = ToggleTemplate
    
    -- Create ToggleTitle for ToggleTemplate
    local ToggleTitle = Instance.new("TextLabel")
    ToggleTitle.Name = "Title"
    ToggleTitle.TextWrapped = true
    ToggleTitle.BorderSizePixel = 0
    ToggleTitle.TextSize = 16
    ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left
    ToggleTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ToggleTitle.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
    ToggleTitle.TextColor3 = Color3.fromRGB(197, 204, 219)
    ToggleTitle.BackgroundTransparency = 1
    ToggleTitle.Size = UDim2.new(1, 0, 0, 15)
    ToggleTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ToggleTitle.Text = "Toggle"
    ToggleTitle.Parent = ToggleTemplate
    
    -- Create ToggleFill for ToggleTitle
    local ToggleFill = Instance.new("ImageButton")
    ToggleFill.Name = "Fill"
    ToggleFill.BorderSizePixel = 0
    ToggleFill.AutoButtonColor = false
    ToggleFill.BackgroundColor3 = Color3.fromRGB(54, 57, 63)
    ToggleFill.ImageColor3 = Color3.fromRGB(197, 204, 219)
    ToggleFill.AnchorPoint = Vector2.new(1, 0.5)
    ToggleFill.Size = UDim2.new(0, 45, 0, 25)
    ToggleFill.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ToggleFill.Position = UDim2.new(1, 0, 0.5, 0)
    ToggleFill.Parent = ToggleTitle
    
    -- Add UICorner to ToggleFill
    local ToggleFillCorner = Instance.new("UICorner")
    ToggleFillCorner.CornerRadius = UDim.new(100, 0)
    ToggleFillCorner.Parent = ToggleFill
    
    -- Create ToggleBall for ToggleFill
    local ToggleBall = Instance.new("ImageButton")
    ToggleBall.Name = "Ball"
    ToggleBall.Active = false
    ToggleBall.Interactable = false
    ToggleBall.BorderSizePixel = 0
    ToggleBall.AutoButtonColor = false
    ToggleBall.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ToggleBall.ImageColor3 = Color3.fromRGB(197, 204, 219)
    ToggleBall.AnchorPoint = Vector2.new(0, 0.5)
    ToggleBall.Size = UDim2.new(0, 20, 0, 20)
    ToggleBall.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ToggleBall.Position = UDim2.new(0, 0, 0.5, 0)
    ToggleBall.Parent = ToggleFill
    
    -- Add UICorner to ToggleBall
    local ToggleBallCorner = Instance.new("UICorner")
    ToggleBallCorner.CornerRadius = UDim.new(100, 0)
    ToggleBallCorner.Parent = ToggleBall
    
    -- Create ToggleIcon for ToggleBall
    local ToggleIcon = Instance.new("ImageLabel")
    ToggleIcon.Name = "Icon"
    ToggleIcon.BorderSizePixel = 0
    ToggleIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ToggleIcon.ImageColor3 = Color3.fromRGB(54, 57, 63)
    ToggleIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    ToggleIcon.Size = UDim2.new(1, -5, 1, -5)
    ToggleIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ToggleIcon.BackgroundTransparency = 1
    ToggleIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
    ToggleIcon.Parent = ToggleBall
    
    -- Add UIPadding to ToggleFill
    local ToggleFillPadding = Instance.new("UIPadding")
    ToggleFillPadding.PaddingTop = UDim.new(0, 2)
    ToggleFillPadding.PaddingRight = UDim.new(0, 2)
    ToggleFillPadding.PaddingLeft = UDim.new(0, 2)
    ToggleFillPadding.PaddingBottom = UDim.new(0, 2)
    ToggleFillPadding.Parent = ToggleFill
    
    -- Create Notification template
    local NotificationTemplate = Instance.new("Frame")
    NotificationTemplate.Name = "Notification"
    NotificationTemplate.Visible = false
    NotificationTemplate.BorderSizePixel = 0
    NotificationTemplate.BackgroundColor3 = Color3.fromRGB(37, 40, 47)
    NotificationTemplate.AnchorPoint = Vector2.new(0.5, 0.5)
    NotificationTemplate.AutomaticSize = Enum.AutomaticSize.Y
    NotificationTemplate.Size = UDim2.new(1, 0, 0, 65)
    NotificationTemplate.Position = UDim2.new(0.8244, 0, 0.88221, 0)
    NotificationTemplate.BorderColor3 = Color3.fromRGB(0, 0, 0)
    NotificationTemplate.BackgroundTransparency = 1
    NotificationTemplate.Parent = Templates
    
    -- Create NotificationItems for NotificationTemplate
    local NotificationItems = Instance.new("CanvasGroup")
    NotificationItems.Name = "Items"
    NotificationItems.ZIndex = 2
    NotificationItems.BorderSizePixel = 0
    NotificationItems.BackgroundColor3 = Color3.fromRGB(37, 40, 47)
    NotificationItems.AutomaticSize = Enum.AutomaticSize.Y
    NotificationItems.Size = UDim2.new(0, 265, 0, 70)
    NotificationItems.BorderColor3 = Color3.fromRGB(0, 0, 0)
    NotificationItems.Parent = NotificationTemplate
    
    -- Add UIStroke to NotificationItems
    local NotificationItemsStroke = Instance.new("UIStroke")
    NotificationItemsStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    NotificationItemsStroke.Thickness = 1.5
    NotificationItemsStroke.Color = Color3.fromRGB(61, 61, 75)
    NotificationItemsStroke.Parent = NotificationItems
    
    -- Add UICorner to NotificationItems
    local NotificationItemsCorner = Instance.new("UICorner")
    NotificationItemsCorner.CornerRadius = UDim.new(0, 6)
    NotificationItemsCorner.Parent = NotificationItems
    
    -- Create NotificationContent for NotificationItems
    local NotificationContent = Instance.new("Frame")
    NotificationContent.BorderSizePixel = 0
    NotificationContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NotificationContent.AutomaticSize = Enum.AutomaticSize.Y
    NotificationContent.Size = UDim2.new(0, 265, 0, 70)
    NotificationContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
    NotificationContent.BackgroundTransparency = 1
    NotificationContent.Parent = NotificationItems
    
    -- Add UIListLayout to NotificationContent
    local NotificationContentLayout = Instance.new("UIListLayout")
    NotificationContentLayout.Padding = UDim.new(0, 5)
    NotificationContentLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    NotificationContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    NotificationContentLayout.Parent = NotificationContent
    
    -- Add UIPadding to NotificationContent
    local NotificationContentPadding = Instance.new("UIPadding")
    NotificationContentPadding.PaddingTop = UDim.new(0, 15)
    NotificationContentPadding.PaddingLeft = UDim.new(0, 15)
    NotificationContentPadding.PaddingBottom = UDim.new(0, 15)
    NotificationContentPadding.Parent = NotificationContent
    
    -- Create NotificationSubContent for NotificationContent
    local NotificationSubContent = Instance.new("TextLabel")
    NotificationSubContent.Name = "SubContent"
    NotificationSubContent.TextWrapped = true
    NotificationSubContent.BorderSizePixel = 0
    NotificationSubContent.TextSize = 12
    NotificationSubContent.TextXAlignment = Enum.TextXAlignment.Left
    NotificationSubContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NotificationSubContent.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    NotificationSubContent.TextColor3 = Color3.fromRGB(181, 181, 181)
    NotificationSubContent.BackgroundTransparency = 1
    NotificationSubContent.AnchorPoint = Vector2.new(0, 0.5)
    NotificationSubContent.Size = UDim2.new(0, 218, 0, 10)
    NotificationSubContent.Visible = false
    NotificationSubContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
    NotificationSubContent.Text = "This is a notification"
    NotificationSubContent.LayoutOrder = 1
    NotificationSubContent.AutomaticSize = Enum.AutomaticSize.Y
    NotificationSubContent.Position = UDim2.new(0, 0, 0, 19)
    NotificationSubContent.Parent = NotificationContent
    
    -- Add UIGradient to NotificationSubContent
    local NotificationSubContentGradient = Instance.new("UIGradient")
    NotificationSubContentGradient.Enabled = false
    NotificationSubContentGradient.Rotation = -90
    NotificationSubContentGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(3, 100, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 226))
    }
    NotificationSubContentGradient.Parent = NotificationSubContent
    
    -- Create NotificationTitle for NotificationContent
    local NotificationTitle = Instance.new("TextLabel")
    NotificationTitle.Name = "Title"
    NotificationTitle.TextWrapped = true
    NotificationTitle.BorderSizePixel = 0
    NotificationTitle.TextSize = 16
    NotificationTitle.TextXAlignment = Enum.TextXAlignment.Left
    NotificationTitle.TextScaled = true
    NotificationTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NotificationTitle.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    NotificationTitle.TextColor3 = Color3.fromRGB(197, 204, 219)
    NotificationTitle.BackgroundTransparency = 1
    NotificationTitle.AnchorPoint = Vector2.new(0, 0.5)
    NotificationTitle.Size = UDim2.new(0, 235, 0, 18)
    NotificationTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
    NotificationTitle.Text = "Title"
    NotificationTitle.Position = UDim2.new(0, 0, 0, 9)
    NotificationTitle.Parent = NotificationContent
    
    -- Create NotificationClose for NotificationTitle
    local NotificationClose = Instance.new("ImageButton")
    NotificationClose.Name = "Close"
    NotificationClose.BorderSizePixel = 0
    NotificationClose.BackgroundTransparency = 1
    NotificationClose.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NotificationClose.ImageColor3 = Color3.fromRGB(197, 204, 219)
    NotificationClose.AnchorPoint = Vector2.new(0, 0.5)
    NotificationClose.Image = "rbxassetid://132453323679056"
    NotificationClose.Size = UDim2.new(0.09706, 0, 1.33333, 0)
    NotificationClose.BorderColor3 = Color3.fromRGB(0, 0, 0)
    NotificationClose.Position = UDim2.new(0.92, 0, 0.5, 0)
    NotificationClose.Parent = NotificationTitle
    
    -- Add UIAspectRatioConstraint to NotificationClose
    local NotificationCloseAspect = Instance.new("UIAspectRatioConstraint")
    NotificationCloseAspect.Parent = NotificationClose
    
    -- Add UIPadding to NotificationTitle
    local NotificationTitlePadding = Instance.new("UIPadding")
    NotificationTitlePadding.PaddingLeft = UDim.new(0, 30)
    NotificationTitlePadding.Parent = NotificationTitle
    
    -- Create NotificationIcon for NotificationTitle
    local NotificationIcon = Instance.new("ImageButton")
    NotificationIcon.Name = "Icon"
    NotificationIcon.BorderSizePixel = 0
    NotificationIcon.BackgroundTransparency = 1
    NotificationIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NotificationIcon.ImageColor3 = Color3.fromRGB(197, 204, 219)
    NotificationIcon.AnchorPoint = Vector2.new(0, 0.5)
    NotificationIcon.Image = "rbxassetid://92049322344253"
    NotificationIcon.Size = UDim2.new(0.09706, 0, 1.33333, 0)
    NotificationIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
    NotificationIcon.Position = UDim2.new(0, -30, 0.5, 0)
    NotificationIcon.Parent = NotificationTitle
    
    -- Add UIAspectRatioConstraint to NotificationIcon
    local NotificationIconAspect = Instance.new("UIAspectRatioConstraint")
    NotificationIconAspect.Parent = NotificationIcon
    
    -- Create NotificationContentText for NotificationContent
    local NotificationContentText = Instance.new("TextLabel")
    NotificationContentText.Name = "Content"
    NotificationContentText.TextWrapped = true
    NotificationContentText.BorderSizePixel = 0
    NotificationContentText.TextSize = 16
    NotificationContentText.TextXAlignment = Enum.TextXAlignment.Left
    NotificationContentText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NotificationContentText.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    NotificationContentText.TextColor3 = Color3.fromRGB(197, 204, 219)
    NotificationContentText.BackgroundTransparency = 1
    NotificationContentText.AnchorPoint = Vector2.new(0, 0.5)
    NotificationContentText.Size = UDim2.new(0, 218, 0, 10)
    NotificationContentText.BorderColor3 = Color3.fromRGB(0, 0, 0)
    NotificationContentText.Text = "Content"
    NotificationContentText.LayoutOrder = 2
    NotificationContentText.AutomaticSize = Enum.AutomaticSize.Y
    NotificationContentText.Position = UDim2.new(0, 0, 0, 19)
    NotificationContentText.Parent = NotificationContent
    
    -- Add UIGradient to NotificationContentText
    local NotificationContentGradient = Instance.new("UIGradient")
    NotificationContentGradient.Enabled = false
    NotificationContentGradient.Rotation = -90
    NotificationContentGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(3, 100, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 226))
    }
    NotificationContentGradient.Parent = NotificationContentText
    
    -- Create TimerBarFill for NotificationItems
    local TimerBarFill = Instance.new("Frame")
    TimerBarFill.Name = "TimerBarFill"
    TimerBarFill.BorderSizePixel = 0
    TimerBarFill.BackgroundColor3 = Color3.fromRGB(61, 61, 75)
    TimerBarFill.AnchorPoint = Vector2.new(0, 1)
    TimerBarFill.Size = UDim2.new(1, 0, 0, 5)
    TimerBarFill.Position = UDim2.new(0, 0, 1, 0)
    TimerBarFill.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TimerBarFill.BackgroundTransparency = 0.7
    TimerBarFill.Parent = NotificationItems
    
    -- Add UICorner to TimerBarFill
    local TimerBarFillCorner = Instance.new("UICorner")
    TimerBarFillCorner.CornerRadius = UDim.new(0, 6)
    TimerBarFillCorner.Parent = TimerBarFill
    
    -- Create TimerBar for TimerBarFill
    local TimerBar = Instance.new("Frame")
    TimerBar.Name = "Bar"
    TimerBar.BorderSizePixel = 0
    TimerBar.BackgroundColor3 = Color3.fromRGB(61, 61, 75)
    TimerBar.Size = UDim2.new(1, 0, 1, 0)
    TimerBar.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TimerBar.Parent = TimerBarFill
    
    -- Add UICorner to TimerBar
    local TimerBarCorner = Instance.new("UICorner")
    TimerBarCorner.CornerRadius = UDim.new(0, 6)
    TimerBarCorner.Parent = TimerBar
    
    -- Create Slider template
    local SliderTemplate = Instance.new("Frame")
    SliderTemplate.Name = "Slider"
    SliderTemplate.Visible = false
    SliderTemplate.BorderSizePixel = 0
    SliderTemplate.BackgroundColor3 = Color3.fromRGB(43, 46, 53)
    SliderTemplate.AutomaticSize = Enum.AutomaticSize.Y
    SliderTemplate.Size = UDim2.new(1, 0, 0, 35)
    SliderTemplate.Position = UDim2.new(-0.0375, 0, 0.38434, 0)
    SliderTemplate.BorderColor3 = Color3.fromRGB(0, 0, 0)
    SliderTemplate.Parent = Templates
    
    -- Add UICorner to SliderTemplate
    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 6)
    SliderCorner.Parent = SliderTemplate
    
    -- Add UIStroke to SliderTemplate
    local SliderStroke = Instance.new("UIStroke")
    SliderStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    SliderStroke.Thickness = 1.5
    SliderStroke.Color = Color3.fromRGB(61, 61, 75)
    SliderStroke.Parent = SliderTemplate
    
    -- Create SliderTitle for SliderTemplate
    local SliderTitle = Instance.new("TextLabel")
    SliderTitle.Name = "Title"
    SliderTitle.TextWrapped = true
    SliderTitle.Interactable = false
    SliderTitle.BorderSizePixel = 0
    SliderTitle.TextSize = 16
    SliderTitle.TextXAlignment = Enum.TextXAlignment.Left
    SliderTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SliderTitle.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    SliderTitle.TextColor3 = Color3.fromRGB(197, 204, 219)
    SliderTitle.BackgroundTransparency = 1
    SliderTitle.Size = UDim2.new(1, 0, 0, 15)
    SliderTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
    SliderTitle.Text = "Slider"
    SliderTitle.AutomaticSize = Enum.AutomaticSize.Y
    SliderTitle.Parent = SliderTemplate
    
    -- Add UIPadding to SliderTemplate
    local SliderPadding = Instance.new("UIPadding")
    SliderPadding.PaddingTop = UDim.new(0, 10)
    SliderPadding.PaddingRight = UDim.new(0, 10)
    SliderPadding.PaddingLeft = UDim.new(0, 10)
    SliderPadding.PaddingBottom = UDim.new(0, 10)
    SliderPadding.Parent = SliderTemplate
    
    -- Add UIListLayout to SliderTemplate
    local SliderLayout = Instance.new("UIListLayout")
    SliderLayout.Padding = UDim.new(0, 5)
    SliderLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SliderLayout.Parent = SliderTemplate
    
    -- Create SliderDescription for SliderTemplate
    local SliderDescription = Instance.new("TextLabel")
    SliderDescription.Name = "Description"
    SliderDescription.TextWrapped = true
    SliderDescription.Interactable = false
    SliderDescription.BorderSizePixel = 0
    SliderDescription.TextSize = 16
    SliderDescription.TextXAlignment = Enum.TextXAlignment.Left
    SliderDescription.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SliderDescription.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    SliderDescription.TextColor3 = Color3.fromRGB(197, 204, 219)
    SliderDescription.BackgroundTransparency = 1
    SliderDescription.Size = UDim2.new(1, 0, 0, 15)
    SliderDescription.Visible = false
    SliderDescription.BorderColor3 = Color3.fromRGB(0, 0, 0)
    SliderDescription.Text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus placerat lacus in enim congue, fermentum euismod leo ultricies. Nulla sodales."
    SliderDescription.LayoutOrder = 1
    SliderDescription.AutomaticSize = Enum.AutomaticSize.Y
    SliderDescription.Parent = SliderTemplate
    
    -- Create SliderFrame for SliderTemplate
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Name = "SliderFrame"
    SliderFrame.ZIndex = 0
    SliderFrame.BorderSizePixel = 0
    SliderFrame.Size = UDim2.new(1, 0, 0, 25)
    SliderFrame.LayoutOrder = 2
    SliderFrame.BackgroundTransparency = 1
    SliderFrame.Parent = SliderTemplate
    
    -- Create SliderContainer for SliderFrame
    local SliderContainer = Instance.new("Frame")
    SliderContainer.ZIndex = 0
    SliderContainer.BorderSizePixel = 0
    SliderContainer.AnchorPoint = Vector2.new(0, 0.5)
    SliderContainer.Size = UDim2.new(1, 0, 0, 20)
    SliderContainer.Position = UDim2.new(0, 0, 0.5, 0)
    SliderContainer.BackgroundTransparency = 1
    SliderContainer.Parent = SliderFrame
    
    -- Create DropShadow for SliderContainer
    local SliderDropShadow = Instance.new("ImageLabel")
    SliderDropShadow.Name = "DropShadow"
    SliderDropShadow.ZIndex = 0
    SliderDropShadow.BorderSizePixel = 0
    SliderDropShadow.SliceCenter = Rect.new(49, 49, 450, 450)
    SliderDropShadow.ScaleType = Enum.ScaleType.Slice
    SliderDropShadow.ImageTransparency = 0.75
    SliderDropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    SliderDropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    SliderDropShadow.Image = "rbxassetid://6014261993"
    SliderDropShadow.Size = UDim2.new(1, 25, 1, 25)
    SliderDropShadow.BackgroundTransparency = 1
    SliderDropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    SliderDropShadow.Parent = SliderContainer
    
    -- Create SliderTrack for SliderContainer
    local SliderTrack = Instance.new("CanvasGroup")
    SliderTrack.Name = "Slider"
    SliderTrack.BorderSizePixel = 0
    SliderTrack.BackgroundColor3 = Color3.fromRGB(43, 46, 53)
    SliderTrack.Size = UDim2.new(1, 0, 1, 0)
    SliderTrack.BorderColor3 = Color3.fromRGB(0, 0, 0)
    SliderTrack.Parent = SliderContainer
    
    -- Add UICorner to SliderTrack
    local SliderTrackCorner = Instance.new("UICorner")
    SliderTrackCorner.CornerRadius = UDim.new(0, 5)
    SliderTrackCorner.Parent = SliderTrack
    
    -- Add UIStroke to SliderTrack
    local SliderTrackStroke = Instance.new("UIStroke")
    SliderTrackStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    SliderTrackStroke.Thickness = 1.5
    SliderTrackStroke.Color = Color3.fromRGB(61, 61, 75)
    SliderTrackStroke.Parent = SliderTrack
    
    -- Add UIPadding to SliderTrack
    local SliderTrackPadding = Instance.new("UIPadding")
    SliderTrackPadding.PaddingTop = UDim.new(0, 2)
    SliderTrackPadding.PaddingRight = UDim.new(0, 2)
    SliderTrackPadding.PaddingLeft = UDim.new(0, 2)
    SliderTrackPadding.PaddingBottom = UDim.new(0, 2)
    SliderTrackPadding.Parent = SliderTrack
    
    -- Create Trigger for SliderTrack
    local SliderTrigger = Instance.new("TextButton")
    SliderTrigger.Name = "Trigger"
    SliderTrigger.BorderSizePixel = 0
    SliderTrigger.TextSize = 14
    SliderTrigger.AutoButtonColor = false
    SliderTrigger.TextColor3 = Color3.fromRGB(0, 0, 0)
    SliderTrigger.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SliderTrigger.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    SliderTrigger.BackgroundTransparency = 1
    SliderTrigger.Size = UDim2.new(1, 0, 1, 0)
    SliderTrigger.BorderColor3 = Color3.fromRGB(0, 0, 0)
    SliderTrigger.Text = ""
    SliderTrigger.Parent = SliderTrack
    
    -- Create SliderFill for SliderTrack
    local SliderFill = Instance.new("ImageButton")
    SliderFill.Name = "Fill"
    SliderFill.Active = false
    SliderFill.Interactable = false
    SliderFill.BorderSizePixel = 0
    SliderFill.AutoButtonColor = false
    SliderFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SliderFill.Selectable = false
    SliderFill.AnchorPoint = Vector2.new(0, 0.5)
    SliderFill.Size = UDim2.new(0, 0, 1, 0)
    SliderFill.ClipsDescendants = true
    SliderFill.BorderColor3 = Color3.fromRGB(0, 0, 0)
    SliderFill.Position = UDim2.new(0, 0, 0.5, 0)
    SliderFill.Parent = SliderTrack
    
    -- Add UICorner to SliderFill
    local SliderFillCorner = Instance.new("UICorner")
    SliderFillCorner.CornerRadius = UDim.new(0, 4)
    SliderFillCorner.Parent = SliderFill
    
    -- Add UIStroke to SliderFill
    local SliderFillStroke = Instance.new("UIStroke")
    SliderFillStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    SliderFillStroke.Thickness = 1.5
    SliderFillStroke.Color = Color3.fromRGB(11, 136, 214)
    SliderFillStroke.Parent = SliderFill
    
    -- Create BackgroundGradient for SliderFill
    local BackgroundGradient = Instance.new("ImageButton")
    BackgroundGradient.Name = "BackgroundGradient"
    BackgroundGradient.Active = false
    BackgroundGradient.Interactable = false
    BackgroundGradient.BorderSizePixel = 0
    BackgroundGradient.AutoButtonColor = false
    BackgroundGradient.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    BackgroundGradient.Selectable = false
    BackgroundGradient.AnchorPoint = Vector2.new(0, 0.5)
    BackgroundGradient.Size = UDim2.new(1, 0, 1, 0)
    BackgroundGradient.BorderColor3 = Color3.fromRGB(0, 0, 0)
    BackgroundGradient.Position = UDim2.new(0, 0, 0.5, 0)
    BackgroundGradient.Parent = SliderFill
    
    -- Add UICorner to BackgroundGradient
    local BackgroundGradientCorner = Instance.new("UICorner")
    BackgroundGradientCorner.CornerRadius = UDim.new(0, 4)
    BackgroundGradientCorner.Parent = BackgroundGradient
    
    -- Add UIGradient to BackgroundGradient
    local BackgroundGradient1 = Instance.new("UIGradient")
    BackgroundGradient1.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 158, 255)),
        ColorSequenceKeypoint.new(0.16, Color3.fromRGB(0, 235, 255)),
        ColorSequenceKeypoint.new(0.32, Color3.fromRGB(0, 158, 255)),
        ColorSequenceKeypoint.new(0.54, Color3.fromRGB(0, 5, 255)),
        ColorSequenceKeypoint.new(0.782, Color3.fromRGB(0, 235, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 158, 255))
    }
    BackgroundGradient1.Parent = BackgroundGradient
    
    local BackgroundGradient2 = Instance.new("UIGradient")
    BackgroundGradient2.Enabled = false
    BackgroundGradient2.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 158, 255)),
        ColorSequenceKeypoint.new(0.16, Color3.fromRGB(0, 5, 255)),
        ColorSequenceKeypoint.new(0.32, Color3.fromRGB(0, 158, 255)),
        ColorSequenceKeypoint.new(0.54, Color3.fromRGB(0, 235, 255)),
        ColorSequenceKeypoint.new(0.782, Color3.fromRGB(0, 5, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 158, 255))
    }
    BackgroundGradient2.Parent = BackgroundGradient
    
    local BackgroundGradient3 = Instance.new("UIGradient")
    BackgroundGradient3.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 5, 255)),
        ColorSequenceKeypoint.new(0.16, Color3.fromRGB(0, 158, 255)),
        ColorSequenceKeypoint.new(0.32, Color3.fromRGB(0, 158, 255)),
        ColorSequenceKeypoint.new(0.54, Color3.fromRGB(0, 5, 255)),
        ColorSequenceKeypoint.new(0.782, Color3.fromRGB(0, 158, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 158, 255))
    }
    BackgroundGradient3.Parent = BackgroundGradient
    
    -- Create ValueText for SliderContainer
    local ValueText = Instance.new("TextLabel")
    ValueText.Name = "ValueText"
    ValueText.TextWrapped = true
    ValueText.Interactable = false
    ValueText.ZIndex = 2
    ValueText.BorderSizePixel = 0
    ValueText.TextSize = 14
    ValueText.TextXAlignment = Enum.TextXAlignment.Left
    ValueText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ValueText.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    ValueText.TextColor3 = Color3.fromRGB(197, 204, 219)
    ValueText.BackgroundTransparency = 1
    ValueText.RichText = true
    ValueText.AnchorPoint = Vector2.new(0.5, 0.5)
    ValueText.Size = UDim2.new(1, -15, 1, 0)
    ValueText.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ValueText.Text = "0"
    ValueText.Position = UDim2.new(0.5, 0, 0.5, 0)
    ValueText.Parent = SliderContainer
    
    -- Create TextBox template
    local TextBoxTemplate = Instance.new("Frame")
    TextBoxTemplate.Name = "TextBox"
    TextBoxTemplate.Visible = false
    TextBoxTemplate.BorderSizePixel = 0
    TextBoxTemplate.BackgroundColor3 = Color3.fromRGB(43, 46, 53)
    TextBoxTemplate.AutomaticSize = Enum.AutomaticSize.Y
    TextBoxTemplate.Size = UDim2.new(1, 0, 0, 35)
    TextBoxTemplate.Position = UDim2.new(-0.0375, 0, 0.38434, 0)
    TextBoxTemplate.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TextBoxTemplate.Parent = Templates
    
    -- Add UICorner to TextBoxTemplate
    local TextBoxCorner = Instance.new("UICorner")
    TextBoxCorner.CornerRadius = UDim.new(0, 6)
    TextBoxCorner.Parent = TextBoxTemplate
    
    -- Add UIStroke to TextBoxTemplate
    local TextBoxStroke = Instance.new("UIStroke")
    TextBoxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    TextBoxStroke.Thickness = 1.5
    TextBoxStroke.Color = Color3.fromRGB(61, 61, 75)
    TextBoxStroke.Parent = TextBoxTemplate
    
    -- Create TextBoxTitle for TextBoxTemplate
    local TextBoxTitle = Instance.new("TextLabel")
    TextBoxTitle.Name = "Title"
    TextBoxTitle.TextWrapped = true
    TextBoxTitle.Interactable = false
    TextBoxTitle.BorderSizePixel = 0
    TextBoxTitle.TextSize = 16
    TextBoxTitle.TextXAlignment = Enum.TextXAlignment.Left
    TextBoxTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TextBoxTitle.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    TextBoxTitle.TextColor3 = Color3.fromRGB(197, 204, 219)
    TextBoxTitle.BackgroundTransparency = 1
    TextBoxTitle.Size = UDim2.new(1, 0, 0, 15)
    TextBoxTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TextBoxTitle.Text = "Input Textbox"
    TextBoxTitle.AutomaticSize = Enum.AutomaticSize.Y
    TextBoxTitle.Parent = TextBoxTemplate
    
    -- Add UIPadding to TextBoxTemplate
    local TextBoxPadding = Instance.new("UIPadding")
    TextBoxPadding.PaddingTop = UDim.new(0, 10)
    TextBoxPadding.PaddingRight = UDim.new(0, 10)
    TextBoxPadding.PaddingLeft = UDim.new(0, 10)
    TextBoxPadding.PaddingBottom = UDim.new(0, 10)
    TextBoxPadding.Parent = TextBoxTemplate
    
    -- Add UIListLayout to TextBoxTemplate
    local TextBoxLayout = Instance.new("UIListLayout")
    TextBoxLayout.Padding = UDim.new(0, 10)
    TextBoxLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TextBoxLayout.Parent = TextBoxTemplate
    
    -- Create InputTextBox for TextBoxTemplate
    local InputTextBox = Instance.new("TextBox")
    InputTextBox.TextXAlignment = Enum.TextXAlignment.Left
    InputTextBox.BorderSizePixel = 0
    InputTextBox.TextWrapped = true
    InputTextBox.TextTruncate = Enum.TextTruncate.AtEnd
    InputTextBox.TextSize = 14
    InputTextBox.TextColor3 = Color3.fromRGB(197, 204, 219)
    InputTextBox.BackgroundColor3 = Color3.fromRGB(43, 46, 53)
    InputTextBox.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    InputTextBox.ClipsDescendants = true
    InputTextBox.PlaceholderText = "Input here..."
    InputTextBox.Size = UDim2.new(1, 0, 0, 30)
    InputTextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
    InputTextBox.Text = ""
    InputTextBox.Parent = TextBoxTemplate
    
    -- Add UIPadding to InputTextBox
    local InputTextBoxPadding = Instance.new("UIPadding")
    InputTextBoxPadding.PaddingTop = UDim.new(0, 10)
    InputTextBoxPadding.PaddingRight = UDim.new(0, 10)
    InputTextBoxPadding.PaddingLeft = UDim.new(0, 10)
    InputTextBoxPadding.PaddingBottom = UDim.new(0, 10)
    InputTextBoxPadding.Parent = InputTextBox
    
    -- Create ModuleScript for Library
    local LibraryModule = Instance.new("ModuleScript")
    LibraryModule.Name = "Library"
    LibraryModule.Parent = ScreenGui
    
    -- Create IconModule for LibraryModule
    local IconModule = Instance.new("ModuleScript")
    IconModule.Name = "IconModule"
    IconModule.Parent = LibraryModule
    
    -- Create Lucide for IconModule
    local Lucide = Instance.new("ModuleScript")
    Lucide.Name = "Lucide"
    Lucide.Parent = IconModule
    
    -- Window behavior functions
    local WindowBehavior = {}
    
    -- Dragging functionality
    local isDragging = false
    local dragStart
    local startPos
    
    local function updateInput(input)
        local delta = input.Position - dragStart
        Window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    TopFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            dragStart = input.Position
            startPos = Window.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    isDragging = false
                end
            end)
        end
    end)
    
    TopFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if isDragging then
                updateInput(input)
            end
        end
    end)
    
    -- Close button functionality
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    -- Hide button functionality
    local isHidden = false
    local originalSize
    
    HideButton.MouseButton1Click:Connect(function()
        isHidden = not isHidden
        
        if isHidden then
            originalSize = Window.Size
            Window.Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset, 0, 35)
            TabButtons.Visible = false
            Tabs.Visible = false
            NotificationFrame.Visible = false
            DarkOverlay.Visible = false
            DropdownSelection.Visible = false
        else
            Window.Size = originalSize
            TabButtons.Visible = true
            Tabs.Visible = true
            NotificationFrame.Visible = true
        end
    end)
    
    -- Maximize button functionality
    local isMaximized = false
    local originalPos
    local originalWindowSize
    
    if config.Resizeable then
        local MaximizeButton = TopFrame:FindFirstChild("Maximize")
        if MaximizeButton then
            MaximizeButton.MouseButton1Click:Connect(function()
                isMaximized = not isMaximized
                
                if isMaximized then
                    originalPos = Window.Position
                    originalWindowSize = Window.Size
                    Window.Position = UDim2.new(0.5, 0, 0.5, 0)
                    Window.Size = UDim2.new(1, -50, 1, -50)
                else
                    Window.Position = originalPos
                    Window.Size = originalWindowSize
                end
            end)
        end
    end
    
    -- Window object to return
    local WindowObj = {
        ScreenGui = ScreenGui,
        Window = Window,
        TopFrame = TopFrame,
        TabButtons = TabButtons,
        TabButtonsList = TabButtonsList,
        Tabs = Tabs,
        NotificationFrame = NotificationFrame,
        NotificationList = NotificationList,
        DarkOverlay = DarkOverlay,
        DropdownSelection = DropdownSelection,
        DropdownTopBar = DropdownTopBar,
        BoxFrame = BoxFrame,
        DropdownTextBox = DropdownTextBox,
        DropdownCloseButton = DropdownCloseButton,
        DropdownTitle = DropdownTitle,
        Dropdowns = Dropdowns,
        Templates = Templates,
        
        -- Add tab function
        AddTab = function(self, tabConfig)
            local TabButton = TabButtonTemplate:Clone()
            TabButton.Visible = true
            TabButton.Parent = TabButtonsList
            
            local Tab = TabTemplate:Clone()
            Tab.Visible = false
            Tab.Name = tabConfig.Name or "Tab"
            Tab.Parent = Tabs
            
            -- Update tab button title and icon
            local TabButtonTitle = TabButton:FindFirstChild("Title")
            if TabButtonTitle then
                TabButtonTitle.Text = tabConfig.Title or "Tab"
            end
            
            local TabButtonIcon = TabButton:FindFirstChild("Icon")
            if TabButtonIcon and tabConfig.Icon then
                TabButtonIcon.Image = tabConfig.Icon
            end
            
            -- Tab button click handler
            TabButton.MouseButton1Click:Connect(function()
                -- Hide all tabs
                for _, tab in pairs(Tabs:GetChildren()) do
                    if tab:IsA("ScrollingFrame") then
                        tab.Visible = false
                    end
                end
                
                -- Show current tab
                Tab.Visible = true
                
                -- Update tab button appearance
                for _, button in pairs(TabButtonsList:GetChildren()) do
                    if button:IsA("ImageButton") then
                        local Bar = button:FindFirstChild("Bar")
                        if Bar then
                            Bar.BackgroundTransparency = 1
                        end
                    end
                end
                
                local Bar = TabButton:FindFirstChild("Bar")
                if Bar then
                    Bar.BackgroundTransparency = 0
                end
            end)
            
            return {
                Tab = Tab,
                TabButton = TabButton,
                
                -- Add button function
                AddButton = function(self, buttonConfig)
                    local Button = ButtonTemplate:Clone()
                    Button.Visible = true
                    Button.Parent = Tab
                    
                    local ButtonTitle = Button:FindFirstChild("Content"):FindFirstChild("Title")
                    if ButtonTitle then
                        ButtonTitle.Text = buttonConfig.Title or "Button"
                    end
                    
                    local ButtonDescription = Button:FindFirstChild("Content"):FindFirstChild("Description")
                    if ButtonDescription and buttonConfig.Description then
                        ButtonDescription.Text = buttonConfig.Description
                        ButtonDescription.Visible = true
                    end
                    
                    Button.MouseButton1Click:Connect(function()
                        if buttonConfig.Callback then
                            buttonConfig.Callback()
                        end
                    end)
                    
                    return Button
                end,
                
                -- Add paragraph function
                AddParagraph = function(self, paragraphConfig)
                    local Paragraph = ParagraphTemplate:Clone()
                    Paragraph.Visible = true
                    Paragraph.Parent = Tab
                    
                    local ParagraphTitle = Paragraph:FindFirstChild("Title")
                    if ParagraphTitle then
                        ParagraphTitle.Text = paragraphConfig.Title or "Paragraph"
                    end
                    
                    local ParagraphDescription = Paragraph:FindFirstChild("Description")
                    if ParagraphDescription and paragraphConfig.Content then
                        ParagraphDescription.Text = paragraphConfig.Content
                        ParagraphDescription.Visible = true
                    end
                    
                    return Paragraph
                end,
                
                -- Add toggle function
                AddToggle = function(self, toggleConfig)
                    local Toggle = ToggleTemplate:Clone()
                    Toggle.Visible = true
                    Toggle.Parent = Tab
                    
                    local ToggleTitle = Toggle:FindFirstChild("Title")
                    if ToggleTitle then
                        ToggleTitle.Text = toggleConfig.Title or "Toggle"
                    end
                    
                    local ToggleDescription = Toggle:FindFirstChild("Description")
                    if ToggleDescription and toggleConfig.Description then
                        ToggleDescription.Text = toggleConfig.Description
                        ToggleDescription.Visible = true
                    end
                    
                    local ToggleFill = ToggleTitle:FindFirstChild("Fill")
                    local ToggleBall = ToggleFill:FindFirstChild("Ball")
                    local ToggleIcon = ToggleBall:FindFirstChild("Icon")
                    
                    local isToggled = toggleConfig.Default or false
                    
                    local function updateToggle()
                        if isToggled then
                            ToggleFill.BackgroundColor3 = Color3.fromRGB(11, 136, 214)
                            ToggleBall.Position = UDim2.new(1, -20, 0.5, 0)
                            ToggleIcon.ImageTransparency = 0
                        else
                            ToggleFill.BackgroundColor3 = Color3.fromRGB(54, 57, 63)
                            ToggleBall.Position = UDim2.new(0, 0, 0.5, 0)
                            ToggleIcon.ImageTransparency = 1
                        end
                    end
                    
                    updateToggle()
                    
                    Toggle.MouseButton1Click:Connect(function()
                        isToggled = not isToggled
                        updateToggle()
                        
                        if toggleConfig.Callback then
                            toggleConfig.Callback(isToggled)
                        end
                    end)
                    
                    return {
                        Toggle = Toggle,
                        SetValue = function(self, value)
                            isToggled = value
                            updateToggle()
                        end,
                        GetValue = function(self)
                            return isToggled
                        end
                    }
                end,
                
                -- Add slider function
                AddSlider = function(self, sliderConfig)
                    local Slider = SliderTemplate:Clone()
                    Slider.Visible = true
                    Slider.Parent = Tab
                    
                    local SliderTitle = Slider:FindFirstChild("Title")
                    if SliderTitle then
                        SliderTitle.Text = sliderConfig.Title or "Slider"
                    end
                    
                    local SliderDescription = Slider:FindFirstChild("Description")
                    if SliderDescription and sliderConfig.Description then
                        SliderDescription.Text = sliderConfig.Description
                        SliderDescription.Visible = true
                    end
                    
                    local SliderFrame = Slider:FindFirstChild("SliderFrame")
                    local SliderContainer = SliderFrame:FindFirstChild("SliderContainer")
                    local ValueText = SliderContainer:FindFirstChild("ValueText")
                    local SliderTrack = SliderContainer:FindFirstChild("Slider")
                    local SliderTrigger = SliderTrack:FindFirstChild("Trigger")
                    local SliderFill = SliderTrack:FindFirstChild("Fill")
                    
                    local min = sliderConfig.Min or 0
                    local max = sliderConfig.Max or 100
                    local default = sliderConfig.Default or 50
                    local decimals = sliderConfig.Decimals or 0
                    local suffix = sliderConfig.Suffix or ""
                    
                    local function updateSlider(value)
                        value = math.clamp(value, min, max)
                        local percentage = (value - min) / (max - min)
                        SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
                        ValueText.Text = string.format("%." .. tostring(decimals) .. "f%s", value, suffix)
                        return value
                    end
                    
                    updateSlider(default)
                    
                    SliderTrigger.MouseButton1Down:Connect(function()
                        local connection
                        connection = game:GetService("UserInputService").InputChanged:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.MouseMovement then
                                local mousePos = input.Position
                                local sliderPos = SliderTrack.AbsolutePosition
                                local sliderSize = SliderTrack.AbsoluteSize
                                local percentage = math.clamp((mousePos.X - sliderPos.X) / sliderSize.X, 0, 1)
                                local value = min + percentage * (max - min)
                                value = updateSlider(value)
                                
                                if sliderConfig.Callback then
                                    sliderConfig.Callback(value)
                                end
                            end
                        end)
                        
                        SliderTrigger.MouseButton1Up:Connect(function()
                            connection:Disconnect()
                        end)
                        
                        game:GetService("UserInputService").InputEnded:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                                connection:Disconnect()
                            end
                        end)
                    end)
                    
                    return {
                        Slider = Slider,
                        SetValue = function(self, value)
                            updateSlider(value)
                        end,
                        GetValue = function(self)
                            local percentage = SliderFill.Size.X.Scale
                            return min + percentage * (max - min)
                        end
                    }
                end,
                
                -- Add textbox function
                AddTextBox = function(self, textBoxConfig)
                    local TextBox = TextBoxTemplate:Clone()
                    TextBox.Visible = true
                    TextBox.Parent = Tab
                    
                    local TextBoxTitle = TextBox:FindFirstChild("Title")
                    if TextBoxTitle then
                        TextBoxTitle.Text = textBoxConfig.Title or "Input Textbox"
                    end
                    
                    local InputTextBox = TextBox:FindFirstChild("InputTextBox")
                    if InputTextBox then
                        InputTextBox.PlaceholderText = textBoxConfig.Placeholder or "Input here..."
                        InputTextBox.Text = textBoxConfig.Default or ""
                        
                        InputTextBox.FocusLost:Connect(function(enterPressed)
                            if textBoxConfig.Callback then
                                textBoxConfig.Callback(InputTextBox.Text, enterPressed)
                            end
                        end)
                    end
                    
                    return {
                        TextBox = TextBox,
                        SetValue = function(self, value)
                            InputTextBox.Text = value
                        end,
                        GetValue = function(self)
                            return InputTextBox.Text
                        end
                    }
                end,
                
                -- Add dropdown function
                AddDropdown = function(self, dropdownConfig)
                    local Dropdown = ButtonTemplate:Clone()
                    Dropdown.Visible = true
                    Dropdown.Parent = Tab
                    
                    local DropdownTitle = Dropdown:FindFirstChild("Content"):FindFirstChild("Title")
                    if DropdownTitle then
                        DropdownTitle.Text = dropdownConfig.Title or "Dropdown"
                    end
                    
                    local DropdownDescription = Dropdown:FindFirstChild("Content"):FindFirstChild("Description")
                    if DropdownDescription and dropdownConfig.Description then
                        DropdownDescription.Text = dropdownConfig.Description
                        DropdownDescription.Visible = true
                    end
                    
                    local ClickIcon = DropdownTitle:FindFirstChild("ClickIcon")
                    if ClickIcon then
                        ClickIcon.Rotation = 0
                    end
                    
                    Dropdown.MouseButton1Click:Connect(function()
                        -- Show dropdown selection
                        DropdownSelection.Visible = true
                        DarkOverlay.Visible = true
                        
                        -- Update dropdown title
                        DropdownTitle.Text = dropdownConfig.Title or "Dropdown"
                        
                        -- Clear existing dropdowns
                        for _, dropdown in pairs(Dropdowns:GetChildren()) do
                            dropdown:Destroy()
                        end
                        
                        -- Add dropdown options
                        for i, option in pairs(dropdownConfig.Options or {}) do
                            local Option = ButtonTemplate:Clone()
                            Option.Visible = true
                            Option.Parent = Dropdowns
                            Option.LayoutOrder = i
                            
                            local OptionTitle = Option:FindFirstChild("Content"):FindFirstChild("Title")
                            if OptionTitle then
                                OptionTitle.Text = option
                            end
                            
                            Option.MouseButton1Click:Connect(function()
                                -- Update dropdown title
                                DropdownTitle.Text = option
                                
                                -- Hide dropdown selection
                                DropdownSelection.Visible = false
                                DarkOverlay.Visible = false
                                
                                -- Call callback
                                if dropdownConfig.Callback then
                                    dropdownConfig.Callback(option)
                                end
                            end)
                        end
                    end)
                    
                    return {
                        Dropdown = Dropdown,
                        SetValue = function(self, value)
                            DropdownTitle.Text = value
                        end,
                        GetValue = function(self)
                            return DropdownTitle.Text
                        end
                    }
                end,
                
                -- Add label function
                AddLabel = function(self, labelConfig)
                    local Label = ParagraphTemplate:Clone()
                    Label.Visible = true
                    Label.Parent = Tab
                    
                    local LabelTitle = Label:FindFirstChild("Title")
                    if LabelTitle then
                        LabelTitle.Text = labelConfig.Text or "Label"
                        LabelTitle.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
                    end
                    
                    return Label
                end,
                
                -- Add divider function
                AddDivider = function(self)
                    local Divider = DividerTemplate:Clone()
                    Divider.Visible = true
                    Divider.Parent = Tab
                    return Divider
                end
            }
        end,
        
        -- Show notification function
        ShowNotification = function(self, notificationConfig)
            local Notification = NotificationTemplate:Clone()
            Notification.Visible = true
            Notification.Parent = NotificationList
            
            local NotificationTitle = Notification:FindFirstChild("Items"):FindFirstChild("NotificationContent"):FindFirstChild("Title")
            if NotificationTitle then
                NotificationTitle.Text = notificationConfig.Title or "Notification"
            end
            
            local NotificationContentText = Notification:FindFirstChild("Items"):FindFirstChild("NotificationContent"):FindFirstChild("Content")
            if NotificationContentText then
                NotificationContentText.Text = notificationConfig.Content or "This is a notification"
            end
            
            local NotificationIcon = NotificationTitle:FindFirstChild("Icon")
            if NotificationIcon and notificationConfig.Icon then
                NotificationIcon.Image = notificationConfig.Icon
            end
            
            local NotificationClose = NotificationTitle:FindFirstChild("Close")
            if NotificationClose then
                NotificationClose.MouseButton1Click:Connect(function()
                    Notification:Destroy()
                end)
            end
            
            local TimerBarFill = Notification:FindFirstChild("Items"):FindFirstChild("TimerBarFill")
            local TimerBar = TimerBarFill:FindFirstChild("Bar")
            
            if notificationConfig.Duration then
                local startTime = tick()
                local duration = notificationConfig.Duration
                
                local connection
                connection = game:GetService("RunService").Heartbeat:Connect(function()
                    local elapsed = tick() - startTime
                    local remaining = math.max(0, duration - elapsed)
                    TimerBar.Size = UDim2.new(remaining / duration, 0, 1, 0)
                    
                    if remaining <= 0 then
                        connection:Disconnect()
                        Notification:Destroy()
                    end
                end)
            else
                TimerBarFill.Visible = false
            end
            
            return Notification
        end,
        
        -- Show dropdown function
        ShowDropdown = function(self, dropdownConfig)
            DropdownSelection.Visible = true
            DarkOverlay.Visible = true
            
            -- Update dropdown title
            DropdownTitle.Text = dropdownConfig.Title or "Dropdown"
            
            -- Clear existing dropdowns
            for _, dropdown in pairs(Dropdowns:GetChildren()) do
                dropdown:Destroy()
            end
            
            -- Add dropdown options
            for i, option in pairs(dropdownConfig.Options or {}) do
                local Option = ButtonTemplate:Clone()
                Option.Visible = true
                Option.Parent = Dropdowns
                Option.LayoutOrder = i
                
                local OptionTitle = Option:FindFirstChild("Content"):FindFirstChild("Title")
                if OptionTitle then
                    OptionTitle.Text = option
                end
                
                Option.MouseButton1Click:Connect(function()
                    -- Hide dropdown selection
                    DropdownSelection.Visible = false
                    DarkOverlay.Visible = false
                    
                    -- Call callback
                    if dropdownConfig.Callback then
                        dropdownConfig.Callback(option)
                    end
                end)
            end
        end,
        
        -- Close dropdown function
        CloseDropdown = function(self)
            DropdownSelection.Visible = false
            DarkOverlay.Visible = false
        end,
        
        -- Toggle visibility function
        Toggle = function(self)
            isHidden = not isHidden
            
            if isHidden then
                originalSize = Window.Size
                Window.Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset, 0, 35)
                TabButtons.Visible = false
                Tabs.Visible = false
                NotificationFrame.Visible = false
                DarkOverlay.Visible = false
                DropdownSelection.Visible = false
            else
                Window.Size = originalSize
                TabButtons.Visible = true
                Tabs.Visible = true
                NotificationFrame.Visible = true
            end
        end,
        
        -- Destroy function
        Destroy = function(self)
            ScreenGui:Destroy()
        end
    }
    
    -- Set default tab
    if config.DefaultTab then
        -- This would be implemented to set the default tab
        -- For now, we'll just create a default tab
        WindowObj:AddTab({
            Title = "Main",
            Icon = "rbxassetid://113216930555884"
        })
    end
    
    return WindowObj
end

return Library