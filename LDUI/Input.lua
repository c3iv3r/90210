local Library = {}

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
    },
    Section = {
        Duration = 0.25,
        EasingStyle = Enum.EasingStyle.Quart,
        EasingDirection = Enum.EasingDirection.Out
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

-- Dialog Module
local function CreateDialog(parent, config)
    local DialogData = {
        Title = config.Title or "Dialog",
        Content = config.Content or "",
        Icon = config.Icon,
        Buttons = config.Buttons or {},
        Size = nil,
        PressDecreaseSize = UDim2.fromOffset(5, 5)
    }

    local DialogMethods = {}

    -- Dark Overlay
    local DarkOverlay = Instance.new("Frame")
    DarkOverlay.Visible = false
    DarkOverlay.BorderSizePixel = 0
    DarkOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    DarkOverlay.Size = UDim2.new(1, 0, 1, 0)
    DarkOverlay.BorderColor3 = Color3.fromRGB(0, 0, 0)
    DarkOverlay.Name = "DarkOverlayDialog"
    DarkOverlay.BackgroundTransparency = 0.6
    DarkOverlay.Parent = parent

    local DarkOverlayCorner = Instance.new("UICorner")
    DarkOverlayCorner.CornerRadius = UDim.new(0, 10)
    DarkOverlayCorner.Parent = DarkOverlay

    -- Main Dialog Frame
    local DialogFrame = Instance.new("Frame")
    DialogFrame.Visible = false
    DialogFrame.ZIndex = 4
    DialogFrame.BorderSizePixel = 0
    DialogFrame.BackgroundColor3 = Color3.fromRGB(32, 35, 41)
    DialogFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    DialogFrame.ClipsDescendants = true
    DialogFrame.AutomaticSize = Enum.AutomaticSize.Y
    DialogFrame.Size = UDim2.new(0, 250, 0, 0)
    DialogFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    DialogFrame.BorderColor3 = Color3.fromRGB(61, 61, 75)
    DialogFrame.Name = "Dialog"
    DialogFrame.Parent = parent

    local DialogCorner = Instance.new("UICorner")
    DialogCorner.CornerRadius = UDim.new(0, 6)
    DialogCorner.Parent = DialogFrame

    local DialogStroke = Instance.new("UIStroke")
    DialogStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    DialogStroke.Thickness = 1.5
    DialogStroke.Color = Color3.fromRGB(61, 61, 75)
    DialogStroke.Parent = DialogFrame

    local DialogLayout = Instance.new("UIListLayout")
    DialogLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    DialogLayout.SortOrder = Enum.SortOrder.LayoutOrder
    DialogLayout.Parent = DialogFrame

    local DialogPadding = Instance.new("UIPadding")
    DialogPadding.PaddingTop = UDim.new(0, 10)
    DialogPadding.PaddingBottom = UDim.new(0, 10)
    DialogPadding.Parent = DialogFrame

    -- Title Frame
    local TitleFrame = Instance.new("Frame")
    TitleFrame.BorderSizePixel = 0
    TitleFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TitleFrame.AutomaticSize = Enum.AutomaticSize.Y
    TitleFrame.Size = UDim2.new(1, 0, 0, 25)
    TitleFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TitleFrame.Name = "Title"
    TitleFrame.BackgroundTransparency = 1
    TitleFrame.Parent = DialogFrame

    local TitleLayout = Instance.new("UIListLayout")
    TitleLayout.Padding = UDim.new(0, 10)
    TitleLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    TitleLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TitleLayout.FillDirection = Enum.FillDirection.Horizontal
    TitleLayout.Parent = TitleFrame

    local TitlePadding = Instance.new("UIPadding")
    TitlePadding.PaddingTop = UDim.new(0, 5)
    TitlePadding.PaddingRight = UDim.new(0, 15)
    TitlePadding.PaddingLeft = UDim.new(0, 15)
    TitlePadding.PaddingBottom = UDim.new(0, 5)
    TitlePadding.Parent = TitleFrame

    -- Title Icon (optional)
    local TitleIcon = nil
    if DialogData.Icon then
        TitleIcon = Instance.new("ImageButton")
        TitleIcon.BorderSizePixel = 0
        TitleIcon.Visible = true
        TitleIcon.BackgroundTransparency = 1
        TitleIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TitleIcon.ImageColor3 = Color3.fromRGB(197, 204, 219)
        TitleIcon.Size = UDim2.new(0, 33, 0, 25)
        TitleIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
        TitleIcon.Name = "Icon"
        TitleIcon.Position = UDim2.new(0, 0, 0.2125, 0)
        TitleIcon.Image = DialogData.Icon
        TitleIcon.Parent = TitleFrame

        local IconAspectRatio = Instance.new("UIAspectRatioConstraint")
        IconAspectRatio.Parent = TitleIcon
    end

    -- Title Label
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Interactable = false
    TitleLabel.ZIndex = 0
    TitleLabel.BorderSizePixel = 0
    TitleLabel.TextSize = 20
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
    TitleLabel.TextColor3 = Color3.fromRGB(197, 204, 219)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.AnchorPoint = Vector2.new(0, 0.5)
    TitleLabel.Size = UDim2.new(0, 0, 0, 20)
    TitleLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TitleLabel.Text = DialogData.Title
    TitleLabel.LayoutOrder = 1
    TitleLabel.AutomaticSize = Enum.AutomaticSize.XY
    TitleLabel.Position = UDim2.new(-0.05455, 12, 0.5, 0)
    TitleLabel.Parent = TitleFrame

    -- Content Frame (optional)
    local ContentFrame = nil
    local ContentLabel = nil
    if DialogData.Content and DialogData.Content ~= "" then
        ContentFrame = Instance.new("Frame")
        ContentFrame.Visible = true
        ContentFrame.ZIndex = 2
        ContentFrame.BorderSizePixel = 0
        ContentFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ContentFrame.AutomaticSize = Enum.AutomaticSize.Y
        ContentFrame.Size = UDim2.new(1, 0, 0, 0)
        ContentFrame.Position = UDim2.new(0, 0, 0.21886, 0)
        ContentFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
        ContentFrame.Name = "Content"
        ContentFrame.BackgroundTransparency = 1
        ContentFrame.Parent = DialogFrame

        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ContentLayout.Parent = ContentFrame

        local ContentPadding = Instance.new("UIPadding")
        ContentPadding.PaddingTop = UDim.new(0, 5)
        ContentPadding.PaddingRight = UDim.new(0, 15)
        ContentPadding.PaddingLeft = UDim.new(0, 15)
        ContentPadding.PaddingBottom = UDim.new(0, 5)
        ContentPadding.Parent = ContentFrame

        ContentLabel = Instance.new("TextLabel")
        ContentLabel.TextWrapped = true
        ContentLabel.Interactable = false
        ContentLabel.BorderSizePixel = 0
        ContentLabel.TextSize = 15
        ContentLabel.TextXAlignment = Enum.TextXAlignment.Left
        ContentLabel.TextYAlignment = Enum.TextYAlignment.Top
        ContentLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ContentLabel.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
        ContentLabel.TextColor3 = Color3.fromRGB(145, 154, 173)
        ContentLabel.BackgroundTransparency = 1
        ContentLabel.Size = UDim2.new(1, 0, 0, 0)
        ContentLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
        ContentLabel.Text = DialogData.Content
        ContentLabel.AutomaticSize = Enum.AutomaticSize.Y
        ContentLabel.Position = UDim2.new(0, 0, 0.125, 0)
        ContentLabel.Parent = ContentFrame
    end

    -- Buttons Frame
    local ButtonsFrame = Instance.new("Frame")
    ButtonsFrame.ZIndex = 3
    ButtonsFrame.BorderSizePixel = 0
    ButtonsFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ButtonsFrame.AutomaticSize = Enum.AutomaticSize.Y
    ButtonsFrame.Size = UDim2.new(1, 0, 0, 0)
    ButtonsFrame.Position = UDim2.new(0, 0, 0.53017, 0)
    ButtonsFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ButtonsFrame.Name = "Buttons"
    ButtonsFrame.BackgroundTransparency = 1
    ButtonsFrame.Parent = DialogFrame

    local ButtonsLayout = Instance.new("UIListLayout")
    ButtonsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    ButtonsLayout.Padding = UDim.new(0, 10)
    ButtonsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ButtonsLayout.Parent = ButtonsFrame

    local ButtonsPadding = Instance.new("UIPadding")
    ButtonsPadding.PaddingTop = UDim.new(0, 5)
    ButtonsPadding.PaddingRight = UDim.new(0, 10)
    ButtonsPadding.PaddingLeft = UDim.new(0, 10)
    ButtonsPadding.Parent = ButtonsFrame

    -- Create Dialog Buttons
    for index, buttonConfig in ipairs(DialogData.Buttons) do
        local ButtonData = {
            Title = buttonConfig.Title or "Button",
            Callback = buttonConfig.Callback or function() end
        }

        -- Button Container
        local ButtonContainer = Instance.new("Frame")
        ButtonContainer.Visible = true
        ButtonContainer.BorderSizePixel = 0
        ButtonContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ButtonContainer.AnchorPoint = Vector2.new(0.5, 1)
        ButtonContainer.Size = UDim2.new(1, 0, 0, 30)
        ButtonContainer.Position = UDim2.new(0.5, 0, 0.327, 0)
        ButtonContainer.BorderColor3 = Color3.fromRGB(0, 0, 0)
        ButtonContainer.Name = "DialogButton"
        ButtonContainer.BackgroundTransparency = 1
        ButtonContainer.Parent = ButtonsFrame

        -- Button
        local DialogButton = Instance.new("TextButton")
        DialogButton.BorderSizePixel = 0
        DialogButton.AutoButtonColor = false
        DialogButton.BackgroundColor3 = Color3.fromRGB(43, 46, 53)
        DialogButton.Selectable = false
        DialogButton.AnchorPoint = Vector2.new(0.5, 0.5)
        DialogButton.Size = UDim2.new(1, 0, 1, 0)
        DialogButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
        DialogButton.Name = "Button"
        DialogButton.Position = UDim2.new(0.5, 0, 0.5, 0)
        DialogButton.Text = ""
        DialogButton.Parent = ButtonContainer

        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 5)
        ButtonCorner.Parent = DialogButton

        local ButtonStroke = Instance.new("UIStroke")
        ButtonStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        ButtonStroke.Thickness = 1.5
        ButtonStroke.Color = Color3.fromRGB(61, 61, 75)
        ButtonStroke.Parent = DialogButton

        local ButtonLayout = Instance.new("UIListLayout")
        ButtonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        ButtonLayout.Padding = UDim.new(0, 5)
        ButtonLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        ButtonLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ButtonLayout.Parent = DialogButton

        -- Button Label
        local ButtonLabel = Instance.new("TextLabel")
        ButtonLabel.TextWrapped = true
        ButtonLabel.Interactable = false
        ButtonLabel.BorderSizePixel = 0
        ButtonLabel.TextSize = 14
        ButtonLabel.TextScaled = true
        ButtonLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ButtonLabel.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        ButtonLabel.TextColor3 = Color3.fromRGB(197, 204, 219)
        ButtonLabel.BackgroundTransparency = 1
        ButtonLabel.Size = UDim2.new(1, 0, 0.45, 0)
        ButtonLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
        ButtonLabel.Text = ButtonData.Title
        ButtonLabel.Name = "Label"
        ButtonLabel.Position = UDim2.new(0, 45, 0.083, 0)
        ButtonLabel.Parent = DialogButton

        -- Store original size for press effect
        local originalSize = DialogButton.Size

        -- Button Events
        DialogButton.MouseButton1Click:Connect(function()
            ButtonData.Callback()
            -- Close dialog after button click
            local closeTween = CreateTween(DarkOverlay, {BackgroundTransparency = 1}, AnimationConfig.Global)
            DialogFrame:Destroy()
            closeTween.Completed:Wait()
            DarkOverlay:Destroy()
        end)

        DialogButton.MouseButton1Down:Connect(function()
            CreateTween(DialogButton, {Size = originalSize - DialogData.PressDecreaseSize}, AnimationConfig.Global)
        end)

        DialogButton.MouseButton1Up:Connect(function()
            CreateTween(DialogButton, {Size = originalSize}, AnimationConfig.Global)
        end)

        DialogButton.MouseLeave:Connect(function()
            CreateTween(DialogButton, {Size = originalSize}, AnimationConfig.Global)
        end)
    end

    -- Store dialog size
    DialogData.Size = UDim2.fromOffset(DialogFrame.AbsoluteSize.X, DialogFrame.AbsoluteSize.Y)

    -- Show Dialog with animation
    DarkOverlay.BackgroundTransparency = 1
    DarkOverlay.Visible = true
    DialogFrame.Visible = true

    CreateTween(DarkOverlay, {BackgroundTransparency = 0.6}, AnimationConfig.Global)

    return DialogMethods
end

-- Notification Module
function Library:Notify(config)
    local NotificationData = {
        Title = config.Title or "Notification",
        Content = config.Content or "This is a notification",
        Icon = config.Icon or "rbxassetid://92049322344253",
        Duration = config.Duration or 5
    }
    
    local NotificationMethods = {}

    -- Find notification parent (prioritize window if visible, otherwise global)
    local notificationParent = nil
    for _, window in pairs(game.Players.LocalPlayer.PlayerGui:GetChildren()) do
        if window:IsA("ScreenGui") and window:FindFirstChild("Window") then
            local windowFrame = window.Window
            if windowFrame.Visible and windowFrame.Tabs.Visible then
                notificationParent = windowFrame.NotificationFrame.NotificationList
                break
            end
        end
    end
    
    -- If no window found or not visible, create global notification list
    if not notificationParent then
        local globalNotificationGui = game.Players.LocalPlayer.PlayerGui:FindFirstChild("GlobalNotifications")
        if not globalNotificationGui then
            globalNotificationGui = Instance.new("ScreenGui")
            globalNotificationGui.Name = "GlobalNotifications"
            globalNotificationGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            globalNotificationGui.ResetOnSpawn = false
            
            -- Parent to appropriate location
            if gethui then
                globalNotificationGui.Parent = gethui()
            elseif pcall(function() game.CoreGui:GetChildren() end) then
                globalNotificationGui.Parent = game.CoreGui
            else
                globalNotificationGui.Parent = game.Players.LocalPlayer.PlayerGui
            end
            
            local globalList = Instance.new("Frame")
            globalList.ZIndex = 10
            globalList.BorderSizePixel = 0
            globalList.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            globalList.AnchorPoint = Vector2.new(0.5, 0)
            globalList.Size = UDim2.new(0, 630, 1, 0)
            globalList.Position = UDim2.new(1, 0, 0, 0)
            globalList.BorderColor3 = Color3.fromRGB(0, 0, 0)
            globalList.Name = "NotificationList"
            globalList.BackgroundTransparency = 1
            globalList.Parent = globalNotificationGui
            
            local globalLayout = Instance.new("UIListLayout")
            globalLayout.Padding = UDim.new(0, 12)
            globalLayout.SortOrder = Enum.SortOrder.LayoutOrder
            globalLayout.Parent = globalList
            
            local globalPadding = Instance.new("UIPadding")
            globalPadding.PaddingTop = UDim.new(0, 10)
            globalPadding.PaddingRight = UDim.new(0, 40)
            globalPadding.PaddingLeft = UDim.new(0, 40)
            globalPadding.Parent = globalList
        end
        notificationParent = globalNotificationGui.NotificationList
    end

    -- Create Notification Frame
    local Notification = Instance.new("Frame")
    Notification.Visible = false
    Notification.BorderSizePixel = 0
    Notification.BackgroundColor3 = Color3.fromRGB(37, 40, 47)
    Notification.AnchorPoint = Vector2.new(0.5, 0.5)
    Notification.AutomaticSize = Enum.AutomaticSize.Y
    Notification.Size = UDim2.new(1, 0, 0, 65)
    Notification.Position = UDim2.new(0.8244, 0, 0.88221, 0)
    Notification.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Notification.Name = "Notification"
    Notification.BackgroundTransparency = 1
    Notification.Parent = notificationParent

    -- Create Items Container (CanvasGroup for group transparency)
    local NotificationItems = Instance.new("CanvasGroup")
    NotificationItems.ZIndex = 2
    NotificationItems.BorderSizePixel = 0
    NotificationItems.BackgroundColor3 = Color3.fromRGB(37, 40, 47)
    NotificationItems.AutomaticSize = Enum.AutomaticSize.Y
    NotificationItems.Size = UDim2.new(0, 265, 0, 70)
    NotificationItems.BorderColor3 = Color3.fromRGB(0, 0, 0)
    NotificationItems.Name = "Items"
    NotificationItems.Parent = Notification

    -- Create Content Frame
    local NotificationContent = Instance.new("Frame")
    NotificationContent.BorderSizePixel = 0
    NotificationContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NotificationContent.AutomaticSize = Enum.AutomaticSize.Y
    NotificationContent.Size = UDim2.new(0, 265, 0, 70)
    NotificationContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
    NotificationContent.BackgroundTransparency = 1
    NotificationContent.Parent = NotificationItems

    local NotificationLayout = Instance.new("UIListLayout")
    NotificationLayout.Padding = UDim.new(0, 5)
    NotificationLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    NotificationLayout.SortOrder = Enum.SortOrder.LayoutOrder
    NotificationLayout.Parent = NotificationContent

    local NotificationPadding = Instance.new("UIPadding")
    NotificationPadding.PaddingTop = UDim.new(0, 15)
    NotificationPadding.PaddingLeft = UDim.new(0, 15)
    NotificationPadding.PaddingBottom = UDim.new(0, 15)
    NotificationPadding.Parent = NotificationContent

    -- Create SubContent (Optional - for additional info)
    local NotificationSubContent = Instance.new("TextLabel")
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
    NotificationSubContent.Name = "SubContent"
    NotificationSubContent.Position = UDim2.new(0, 0, 0, 19)
    NotificationSubContent.Parent = NotificationContent

    -- Create SubContent Gradient (matching OGLIB)
    local SubContentGradient = Instance.new("UIGradient")
    SubContentGradient.Enabled = false
    SubContentGradient.Rotation = -90
    SubContentGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(3, 100, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 226))
    }
    SubContentGradient.Parent = NotificationSubContent

    -- Create Title
    local NotificationTitle = Instance.new("TextLabel")
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
    NotificationTitle.Text = NotificationData.Title
    NotificationTitle.Name = "Title"
    NotificationTitle.Position = UDim2.new(0, 0, 0, 9)
    NotificationTitle.Parent = NotificationContent

    -- Create Close Button
    local CloseButton = Instance.new("ImageButton")
    CloseButton.BorderSizePixel = 0
    CloseButton.BackgroundTransparency = 1
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.ImageColor3 = Color3.fromRGB(197, 204, 219)
    CloseButton.AnchorPoint = Vector2.new(0, 0.5)
    CloseButton.Image = "rbxassetid://132453323679056"
    CloseButton.Size = UDim2.new(0.09706, 0, 1.33333, 0)
    CloseButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
    CloseButton.Name = "Close"
    CloseButton.Position = UDim2.new(0.92, 0, 0.5, 0)
    CloseButton.Parent = NotificationTitle

    local CloseAspect = Instance.new("UIAspectRatioConstraint")
    CloseAspect.Parent = CloseButton

    -- Create Title Padding
    local TitlePadding = Instance.new("UIPadding")
    TitlePadding.PaddingLeft = UDim.new(0, 30)
    TitlePadding.Parent = NotificationTitle

    -- Create Icon
    local NotificationIcon = Instance.new("ImageButton")
    NotificationIcon.BorderSizePixel = 0
    NotificationIcon.BackgroundTransparency = 1
    NotificationIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NotificationIcon.ImageColor3 = Color3.fromRGB(197, 204, 219)
    NotificationIcon.AnchorPoint = Vector2.new(0, 0.5)
    NotificationIcon.Image = NotificationData.Icon
    NotificationIcon.Size = UDim2.new(0.09706, 0, 1.33333, 0)
    NotificationIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
    NotificationIcon.Name = "Icon"
    NotificationIcon.Position = UDim2.new(0, -30, 0.5, 0)
    NotificationIcon.Parent = NotificationTitle

    local IconAspect = Instance.new("UIAspectRatioConstraint")
    IconAspect.Parent = NotificationIcon

    -- Create Content Text
    local NotificationContentText = Instance.new("TextLabel")
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
    NotificationContentText.Text = NotificationData.Content
    NotificationContentText.LayoutOrder = 2
    NotificationContentText.AutomaticSize = Enum.AutomaticSize.Y
    NotificationContentText.Name = "Content"
    NotificationContentText.Position = UDim2.new(0, 0, 0, 19)
    NotificationContentText.Parent = NotificationContent

    -- Create Content Gradient (matching OGLIB)
    local ContentGradient = Instance.new("UIGradient")
    ContentGradient.Enabled = false
    ContentGradient.Rotation = -90
    ContentGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(3, 100, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 226))
    }
    ContentGradient.Parent = NotificationContentText

    -- Create Timer Bar Container
    local TimerBarFill = Instance.new("Frame")
    TimerBarFill.BorderSizePixel = 0
    TimerBarFill.BackgroundColor3 = Color3.fromRGB(61, 61, 75)
    TimerBarFill.AnchorPoint = Vector2.new(0, 1)
    TimerBarFill.Size = UDim2.new(1, 0, 0, 5)
    TimerBarFill.Position = UDim2.new(0, 0, 1, 0)
    TimerBarFill.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TimerBarFill.Name = "TimerBarFill"
    TimerBarFill.BackgroundTransparency = 0.7
    TimerBarFill.Parent = NotificationItems

    local TimerCorner = Instance.new("UICorner")
    TimerCorner.Parent = TimerBarFill

    -- Create Timer Bar
    local TimerBar = Instance.new("Frame")
    TimerBar.BorderSizePixel = 0
    TimerBar.BackgroundColor3 = Color3.fromRGB(61, 61, 75)
    TimerBar.Size = UDim2.new(1, 0, 1, 0)
    TimerBar.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TimerBar.Name = "Bar"
    TimerBar.Parent = TimerBarFill

    local TimerBarCorner = Instance.new("UICorner")
    TimerBarCorner.Parent = TimerBar

    -- Create Stroke for Items
    local ItemsStroke = Instance.new("UIStroke")
    ItemsStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    ItemsStroke.Thickness = 1.5
    ItemsStroke.Color = Color3.fromRGB(61, 61, 75)
    ItemsStroke.Parent = NotificationItems

    local ItemsCorner = Instance.new("UICorner")
    ItemsCorner.Parent = NotificationItems

    -- Close Function
    local function CloseNotification()
        if Notification then
            CreateTween(NotificationItems, {
                Position = UDim2.new(0.75, 0, 0, 0)
            }, AnimationConfig.Notification)
            task.wait(AnimationConfig.Notification.Duration - (AnimationConfig.Notification.Duration / 2))
            if Notification then
                Notification:Destroy()
            end
            Notification = nil
        end
    end

    -- Close Button Event
    CloseButton.MouseButton1Click:Connect(CloseNotification)

    -- Show Notification Animation
    NotificationItems.Position = UDim2.new(0.75, 0, 0, 0)
    Notification.Visible = true
    
    local showTween = CreateTween(NotificationItems, {
        Position = UDim2.new(0, 0, 0, 0)
    }, AnimationConfig.Notification)
    
    showTween.Completed:Connect(function()
        -- Start timer bar animation
        CreateTween(TimerBar, {
            Size = UDim2.new(0, 0, 1, 0)
        }, {
            Duration = NotificationData.Duration
        })
        
        -- Auto close after duration
        task.delay(NotificationData.Duration, CloseNotification)
    end)

    -- Notification Methods
    function NotificationMethods:Close()
        CloseNotification()
    end

    return NotificationMethods
end

-- Paragraph Module
local function CreateParagraph(parent, config)
    local ParagraphData = {
        Title = config.Title or "Title",
        Desc = config.Desc,
        RichText = config.RichText or false
    }
    
    local ParagraphMethods = {}

    -- Create Main Paragraph Frame
    local ParagraphFrame = Instance.new("Frame")
    ParagraphFrame.Visible = false
    ParagraphFrame.BorderSizePixel = 0
    ParagraphFrame.BackgroundColor3 = Color3.fromRGB(43, 46, 53)
    ParagraphFrame.AutomaticSize = Enum.AutomaticSize.Y
    ParagraphFrame.Size = UDim2.new(1, 0, 0, 35)
    ParagraphFrame.Position = UDim2.new(-0.0375, 0, 0.38434, 0)
    ParagraphFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ParagraphFrame.Name = "Paragraph"
    ParagraphFrame.Parent = parent

    local ParagraphCorner = Instance.new("UICorner")
    ParagraphCorner.CornerRadius = UDim.new(0, 6)
    ParagraphCorner.Parent = ParagraphFrame

    local ParagraphStroke = Instance.new("UIStroke")
    ParagraphStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    ParagraphStroke.Thickness = 1.5
    ParagraphStroke.Color = Color3.fromRGB(61, 61, 75)
    ParagraphStroke.Parent = ParagraphFrame

    local ParagraphPadding = Instance.new("UIPadding")
    ParagraphPadding.PaddingTop = UDim.new(0, 10)
    ParagraphPadding.PaddingRight = UDim.new(0, 10)
    ParagraphPadding.PaddingLeft = UDim.new(0, 10)
    ParagraphPadding.PaddingBottom = UDim.new(0, 10)
    ParagraphPadding.Parent = ParagraphFrame

    local ParagraphLayout = Instance.new("UIListLayout")
    ParagraphLayout.Padding = UDim.new(0, 5)
    ParagraphLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ParagraphLayout.Parent = ParagraphFrame

    -- Create Title
    local ParagraphTitle = Instance.new("TextLabel")
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
    ParagraphTitle.Text = ParagraphData.Title
    ParagraphTitle.AutomaticSize = Enum.AutomaticSize.Y
    ParagraphTitle.Name = "Title"
    ParagraphTitle.RichText = ParagraphData.RichText
    ParagraphTitle.Parent = ParagraphFrame

    -- Create Description (if provided)
    local ParagraphDescription = nil
    if ParagraphData.Desc and ParagraphData.Desc ~= "" then
        ParagraphDescription = Instance.new("TextLabel")
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
        ParagraphDescription.Visible = true
        ParagraphDescription.BorderColor3 = Color3.fromRGB(0, 0, 0)
        ParagraphDescription.Text = ParagraphData.Desc
        ParagraphDescription.LayoutOrder = 1
        ParagraphDescription.AutomaticSize = Enum.AutomaticSize.Y
        ParagraphDescription.Name = "Description"
        ParagraphDescription.RichText = ParagraphData.RichText
        ParagraphDescription.Parent = ParagraphFrame
    else
        -- If no description, hide the description placeholder
        ParagraphDescription = Instance.new("TextLabel")
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
        ParagraphDescription.Text = ""
        ParagraphDescription.LayoutOrder = 1
        ParagraphDescription.AutomaticSize = Enum.AutomaticSize.Y
        ParagraphDescription.Name = "Description"
        ParagraphDescription.RichText = ParagraphData.RichText
        ParagraphDescription.Parent = ParagraphFrame
    end

    -- Make visible
    ParagraphFrame.Visible = true

    -- Paragraph Methods
    function ParagraphMethods:SetTitle(title)
        ParagraphData.Title = title
        ParagraphTitle.Text = title
    end

    function ParagraphMethods:SetDesc(desc)
        ParagraphData.Desc = desc
        ParagraphDescription.Text = desc
        if desc and desc ~= "" then
            ParagraphDescription.Visible = true
        else
            ParagraphDescription.Visible = false
        end
    end

    function ParagraphMethods:SetRichText(enabled)
        ParagraphData.RichText = enabled
        ParagraphTitle.RichText = enabled
        ParagraphDescription.RichText = enabled
    end

    function ParagraphMethods:Destroy()
        ParagraphFrame:Destroy()
    end

    return ParagraphMethods
end

-- Slider Module
local function CreateSlider(parent, config)
    local SliderData = {
        Title = config.Title or "Slider",
        Desc = config.Desc,
        Step = config.Step or 1,
        Value = {
            Min = config.Value.Min or 0,
            Max = config.Value.Max or 100,
            Default = nil
        },
        Locked = config.Locked or false,
        Callback = config.Callback or function() end
    }
    
    SliderData.Value.Default = config.Value.Default or config.Default or SliderData.Value.Min
    
    local SliderMethods = {}
    local Mouse = Players.LocalPlayer:GetMouse()
    
    -- Create Main Slider Frame
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Visible = false
    SliderFrame.BorderSizePixel = 0
    SliderFrame.BackgroundColor3 = Color3.fromRGB(43, 46, 53)
    SliderFrame.AutomaticSize = Enum.AutomaticSize.Y
    SliderFrame.Size = UDim2.new(1, 0, 0, 35)
    SliderFrame.Position = UDim2.new(-0.0375, 0, 0.38434, 0)
    SliderFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    SliderFrame.Name = "Slider"
    SliderFrame.Parent = parent
    
    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 6)
    SliderCorner.Parent = SliderFrame
    
    local SliderStroke = Instance.new("UIStroke")
    SliderStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    SliderStroke.Thickness = 1.5
    SliderStroke.Color = Color3.fromRGB(61, 61, 75)
    SliderStroke.Parent = SliderFrame
    
    local SliderPadding = Instance.new("UIPadding")
    SliderPadding.PaddingTop = UDim.new(0, 10)
    SliderPadding.PaddingRight = UDim.new(0, 10)
    SliderPadding.PaddingLeft = UDim.new(0, 10)
    SliderPadding.PaddingBottom = UDim.new(0, 10)
    SliderPadding.Parent = SliderFrame
    
    local SliderLayout = Instance.new("UIListLayout")
    SliderLayout.Padding = UDim.new(0, 5)
    SliderLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SliderLayout.Parent = SliderFrame
    
    -- Create Slider Title
    local SliderTitle = Instance.new("TextLabel")
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
    SliderTitle.Text = SliderData.Title
    SliderTitle.AutomaticSize = Enum.AutomaticSize.Y
    SliderTitle.Name = "Title"
    SliderTitle.Parent = SliderFrame
    
    -- Create Description (if provided)
    local SliderDescription = nil
    if SliderData.Desc and SliderData.Desc ~= "" then
        SliderDescription = Instance.new("TextLabel")
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
        SliderDescription.Visible = true
        SliderDescription.BorderColor3 = Color3.fromRGB(0, 0, 0)
        SliderDescription.Text = SliderData.Desc
        SliderDescription.LayoutOrder = 1
        SliderDescription.AutomaticSize = Enum.AutomaticSize.Y
        SliderDescription.Name = "Description"
        SliderDescription.Parent = SliderFrame
    end
    
    -- Create Slider Container Frame
    local SliderContainer = Instance.new("Frame")
    SliderContainer.ZIndex = 0
    SliderContainer.BorderSizePixel = 0
    SliderContainer.Size = UDim2.new(1, 0, 0, 25)
    SliderContainer.Name = "SliderFrame"
    SliderContainer.LayoutOrder = 2
    SliderContainer.BackgroundTransparency = 1
    SliderContainer.Parent = SliderFrame
    
    -- Create Slider Track Container
    local SliderTrackContainer = Instance.new("Frame")
    SliderTrackContainer.ZIndex = 0
    SliderTrackContainer.BorderSizePixel = 0
    SliderTrackContainer.AnchorPoint = Vector2.new(0, 0.5)
    SliderTrackContainer.Size = UDim2.new(1, 0, 0, 20)
    SliderTrackContainer.Position = UDim2.new(0, 0, 0.5, 0)
    SliderTrackContainer.BackgroundTransparency = 1
    SliderTrackContainer.Parent = SliderContainer
    
    -- Create Drop Shadow
    local SliderShadow = Instance.new("ImageLabel")
    SliderShadow.ZIndex = 0
    SliderShadow.BorderSizePixel = 0
    SliderShadow.SliceCenter = Rect.new(49, 49, 450, 450)
    SliderShadow.ScaleType = Enum.ScaleType.Slice
    SliderShadow.ImageTransparency = 0.75
    SliderShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    SliderShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    SliderShadow.Image = "rbxassetid://6014261993"
    SliderShadow.Size = UDim2.new(1, 25, 1, 25)
    SliderShadow.BackgroundTransparency = 1
    SliderShadow.Name = "DropShadow"
    SliderShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    SliderShadow.Parent = SliderTrackContainer
    
    -- Create Slider Track
    local SliderTrack = Instance.new("CanvasGroup")
    SliderTrack.BorderSizePixel = 0
    SliderTrack.BackgroundColor3 = Color3.fromRGB(43, 46, 53)
    SliderTrack.Size = UDim2.new(1, 0, 1, 0)
    SliderTrack.BorderColor3 = Color3.fromRGB(0, 0, 0)
    SliderTrack.Name = "Slider"
    SliderTrack.Parent = SliderTrackContainer
    
    local SliderTrackCorner = Instance.new("UICorner")
    SliderTrackCorner.CornerRadius = UDim.new(0, 5)
    SliderTrackCorner.Parent = SliderTrack
    
    local SliderTrackStroke = Instance.new("UIStroke")
    SliderTrackStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    SliderTrackStroke.Thickness = 1.5
    SliderTrackStroke.Color = Color3.fromRGB(61, 61, 75)
    SliderTrackStroke.Parent = SliderTrack
    
    local SliderTrackPadding = Instance.new("UIPadding")
    SliderTrackPadding.PaddingTop = UDim.new(0, 2)
    SliderTrackPadding.PaddingRight = UDim.new(0, 2)
    SliderTrackPadding.PaddingLeft = UDim.new(0, 2)
    SliderTrackPadding.PaddingBottom = UDim.new(0, 2)
    SliderTrackPadding.Parent = SliderTrack
    
    -- Create Invisible Trigger Button
    local SliderTrigger = Instance.new("TextButton")
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
    SliderTrigger.Name = "Trigger"
    SliderTrigger.Parent = SliderTrack
    
    -- Create Slider Fill
    local SliderFill = Instance.new("ImageButton")
    SliderFill.Active = false
    SliderFill.Interactable = false
    SliderFill.BorderSizePixel = 0
    SliderFill.AutoButtonColor = false
    SliderFill.BackgroundTransparency = 1
    SliderFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SliderFill.Selectable = false
    SliderFill.AnchorPoint = Vector2.new(0, 0.5)
    SliderFill.Size = UDim2.new(0, 0, 1, 0)
    SliderFill.ClipsDescendants = true
    SliderFill.BorderColor3 = Color3.fromRGB(0, 0, 0)
    SliderFill.Name = "Fill"
    SliderFill.Position = UDim2.new(0, 0, 0.5, 0)
    SliderFill.Parent = SliderTrack
    
    local SliderFillCorner = Instance.new("UICorner")
    SliderFillCorner.CornerRadius = UDim.new(0, 4)
    SliderFillCorner.Parent = SliderFill
    
    local SliderFillStroke = Instance.new("UIStroke")
    SliderFillStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    SliderFillStroke.Thickness = 1.5
    SliderFillStroke.Color = Color3.fromRGB(11, 136, 214)
    SliderFillStroke.Parent = SliderFill
    
    -- Create Fill Background with Gradient
    local SliderFillBackground = Instance.new("ImageButton")
    SliderFillBackground.Active = false
    SliderFillBackground.Interactable = false
    SliderFillBackground.BorderSizePixel = 0
    SliderFillBackground.AutoButtonColor = false
    SliderFillBackground.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SliderFillBackground.Selectable = false
    SliderFillBackground.AnchorPoint = Vector2.new(0, 0.5)
    SliderFillBackground.Size = UDim2.new(1, 0, 1, 0)
    SliderFillBackground.BorderColor3 = Color3.fromRGB(0, 0, 0)
    SliderFillBackground.Name = "BackgroundGradient"
    SliderFillBackground.Position = UDim2.new(0, 0, 0.5, 0)
    SliderFillBackground.Parent = SliderFill
    
    local SliderFillBgCorner = Instance.new("UICorner")
    SliderFillBgCorner.CornerRadius = UDim.new(0, 4)
    SliderFillBgCorner.Parent = SliderFillBackground
    
    -- Create Fill Gradients
    local FillGradients = {}
    
    local FillGradient1 = Instance.new("UIGradient")
    FillGradient1.Enabled = false
    FillGradient1.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 158, 255)),
        ColorSequenceKeypoint.new(0.16, Color3.fromRGB(0, 235, 255)),
        ColorSequenceKeypoint.new(0.32, Color3.fromRGB(0, 158, 255)),
        ColorSequenceKeypoint.new(0.54, Color3.fromRGB(0, 5, 255)),
        ColorSequenceKeypoint.new(0.782, Color3.fromRGB(0, 235, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 158, 255))
    }
    FillGradient1.Parent = SliderFillBackground
    table.insert(FillGradients, FillGradient1)
    
    local FillGradient2 = Instance.new("UIGradient")
    FillGradient2.Enabled = false
    FillGradient2.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 158, 255)),
        ColorSequenceKeypoint.new(0.16, Color3.fromRGB(0, 5, 255)),
        ColorSequenceKeypoint.new(0.32, Color3.fromRGB(0, 158, 255)),
        ColorSequenceKeypoint.new(0.54, Color3.fromRGB(0, 235, 255)),
        ColorSequenceKeypoint.new(0.782, Color3.fromRGB(0, 5, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 158, 255))
    }
    FillGradient2.Parent = SliderFillBackground
    table.insert(FillGradients, FillGradient2)
    
    local FillGradient3 = Instance.new("UIGradient")
    FillGradient3.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 5, 255)),
        ColorSequenceKeypoint.new(0.16, Color3.fromRGB(0, 158, 255)),
        ColorSequenceKeypoint.new(0.32, Color3.fromRGB(0, 158, 255)),
        ColorSequenceKeypoint.new(0.54, Color3.fromRGB(0, 5, 255)),
        ColorSequenceKeypoint.new(0.782, Color3.fromRGB(0, 158, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 158, 255))
    }
    FillGradient3.Parent = SliderFillBackground
    table.insert(FillGradients, FillGradient3)
    
    -- Create Value Display
    local ValueText = Instance.new("TextLabel")
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
    ValueText.Text = tostring(SliderData.Value.Default)
    ValueText.Name = "ValueText"
    ValueText.Position = UDim2.new(0.5, 0, 0.5, 0)
    ValueText.Parent = SliderTrackContainer
    
    -- Slider Logic Variables
    local currentValue = SliderData.Value.Default
    local isDragging = false
    local isHovering = false
    local dragRatio = 0
    
    -- Gradient cycling function
    local function CycleGradient()
        for _, gradient in ipairs(FillGradients) do
            gradient.Enabled = false
        end
        local randomGradient = FillGradients[math.random(1, #FillGradients)]
        randomGradient.Enabled = true
        return randomGradient
    end
    
    -- Initialize gradient and fill size
    CycleGradient()
    SliderFillBackground.Size = UDim2.new(0, SliderTrack.AbsoluteSize.X, 1, 0)
    SliderTrack:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        SliderFillBackground.Size = UDim2.new(0, SliderTrack.AbsoluteSize.X, 1, 0)
    end)
    
    -- Monitor fill size changes for gradient cycling
    local lastFillSize = nil
    SliderFill:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        if SliderFill.AbsoluteSize.X <= 3 then
            lastFillSize = SliderFill.AbsoluteSize.X
        end
        if lastFillSize and SliderFill.AbsoluteSize.X > lastFillSize then
            CycleGradient()
            lastFillSize = nil
        end
    end)
    
    -- Apply locked state if needed
    if SliderData.Locked then
        SliderStroke.Color = Color3.fromRGB(47, 47, 58)
        SliderFrame.BackgroundColor3 = Color3.fromRGB(32, 35, 40)
        SliderTitle.TextColor3 = Color3.fromRGB(75, 77, 83)
        if SliderDescription then
            SliderDescription.TextColor3 = Color3.fromRGB(75, 77, 83)
        end
        SliderTrackStroke.Color = Color3.fromRGB(47, 47, 58)
        SliderTrack.BackgroundTransparency = 0.5
        SliderFillStroke.Transparency = 0.5
        SliderFillBackground.BackgroundTransparency = 0.5
        ValueText.TextTransparency = 0.6
    end
    
    -- Helper Functions
    local function GetValueRatio(value)
        return (value - SliderData.Value.Min) / (SliderData.Value.Max - SliderData.Value.Min)
    end
    
    local function SetSliderValue(value)
        if not value or value > SliderData.Value.Max or value < SliderData.Value.Min then
            return
        end
        local steppedValue = math.round(value / SliderData.Step) * SliderData.Step
        currentValue = math.clamp(steppedValue, SliderData.Value.Min, SliderData.Value.Max)
        
        CreateTween(SliderFill, {
            Size = UDim2.fromScale(GetValueRatio(currentValue), 1)
        }, AnimationConfig.Global)
        
        ValueText.Text = tostring(currentValue)
        -- HAPUS BARIS INI: SliderData.Value = currentValue
        task.spawn(SliderData.Callback, currentValue)
    end
    
    local function StartDragging()
        isDragging = true
        if SliderData.Locked then
            return
        end
        
        repeat
            task.wait()
            dragRatio = math.clamp((Mouse.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X, 0, 1)
            local newValue = SliderData.Value.Min + (dragRatio * (SliderData.Value.Max - SliderData.Value.Min))
            local steppedValue = math.round(newValue / SliderData.Step) * SliderData.Step
            currentValue = math.clamp(steppedValue, SliderData.Value.Min, SliderData.Value.Max)
            
            CreateTween(SliderFill, {
                Size = UDim2.fromScale(GetValueRatio(currentValue), 1)
            }, AnimationConfig.Global)
            
            ValueText.Text = tostring(currentValue)
            -- HAPUS BARIS INI: SliderData.Value = currentValue
            task.spawn(SliderData.Callback, currentValue)
        until isDragging == false or SliderData.Locked == true
        
        if not isHovering then
            CreateTween(SliderStroke, {
                Color = Color3.fromRGB(60, 60, 74)
            }, AnimationConfig.Global)
        end
    end
    
    -- Set initial value
    ValueText.Text = tostring(currentValue)
    SliderFill.Size = UDim2.fromScale(GetValueRatio(currentValue), 1)
    
    -- Mouse Events
    SliderTrigger.MouseEnter:Connect(function()
        isHovering = true
        if not SliderData.Locked then
            CreateTween(SliderStroke, {
                Color = Color3.fromRGB(10, 135, 213)
            }, AnimationConfig.Global)
        end
    end)
    
    SliderTrigger.MouseLeave:Connect(function()
        isHovering = false
        if not SliderData.Locked and not isDragging then
            CreateTween(SliderStroke, {
                Color = Color3.fromRGB(60, 60, 74)
            }, AnimationConfig.Global)
        end
    end)
    
    SliderTrigger.MouseButton1Down:Connect(function()
        StartDragging()
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
        end
    end)
    
    -- Show slider
    SliderFrame.Visible = true
    
    -- Slider Methods
    function SliderMethods:SetTitle(title)
        SliderData.Title = title
        SliderTitle.Text = title
    end
    
    function SliderMethods:SetDesc(desc)
        if desc and desc ~= "" then
            SliderData.Desc = desc
            if not SliderDescription then
                SliderDescription = Instance.new("TextLabel")
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
                SliderDescription.BorderColor3 = Color3.fromRGB(0, 0, 0)
                SliderDescription.LayoutOrder = 1
                SliderDescription.AutomaticSize = Enum.AutomaticSize.Y
                SliderDescription.Name = "Description"
                SliderDescription.Parent = SliderFrame
            end
            SliderDescription.Text = desc
            SliderDescription.Visible = true
        elseif SliderDescription then
            SliderDescription.Visible = false
        end
    end
    
    function SliderMethods:Set(value)
        SetSliderValue(value)
    end
    
    function SliderMethods:Lock()
        SliderData.Locked = true
        CreateTween(SliderFrame, {
            BackgroundColor3 = Color3.fromRGB(32, 35, 40)
        }, AnimationConfig.Global)
        CreateTween(SliderStroke, {
            Color = Color3.fromRGB(47, 47, 58)
        }, AnimationConfig.Global)
        CreateTween(SliderTitle, {
            TextColor3 = Color3.fromRGB(75, 77, 83)
        }, AnimationConfig.Global)
        if SliderDescription then
            CreateTween(SliderDescription, {
                TextColor3 = Color3.fromRGB(75, 77, 83)
            }, AnimationConfig.Global)
        end
        CreateTween(SliderTrackStroke, {
            Color = Color3.fromRGB(47, 47, 58)
        }, AnimationConfig.Global)
        CreateTween(SliderTrack, {
            BackgroundTransparency = 0.5
        }, AnimationConfig.Global)
        CreateTween(SliderFillStroke, {
            Transparency = 0.5
        }, AnimationConfig.Global)
        CreateTween(SliderFillBackground, {
            BackgroundTransparency = 0.5
        }, AnimationConfig.Global)
        CreateTween(ValueText, {
            TextTransparency = 0.6
        }, AnimationConfig.Global)
    end
    
    function SliderMethods:Unlock()
        SliderData.Locked = false
        CreateTween(SliderFrame, {
            BackgroundColor3 = Color3.fromRGB(42, 45, 52)
        }, AnimationConfig.Global)
        CreateTween(SliderStroke, {
            Color = Color3.fromRGB(60, 60, 74)
        }, AnimationConfig.Global)
        CreateTween(SliderTitle, {
            TextColor3 = Color3.fromRGB(196, 203, 218)
        }, AnimationConfig.Global)
        if SliderDescription then
            CreateTween(SliderDescription, {
                TextColor3 = Color3.fromRGB(196, 203, 218)
            }, AnimationConfig.Global)
        end
        CreateTween(SliderTrackStroke, {
            Color = Color3.fromRGB(60, 60, 74)
        }, AnimationConfig.Global)
        CreateTween(SliderTrack, {
            BackgroundTransparency = 0
        }, AnimationConfig.Global)
        CreateTween(SliderFillStroke, {
            Transparency = 0
        }, AnimationConfig.Global)
        CreateTween(SliderFillBackground, {
            BackgroundTransparency = 0
        }, AnimationConfig.Global)
        CreateTween(ValueText, {
            TextTransparency = 0
        }, AnimationConfig.Global)
    end
    
    function SliderMethods:Destroy()
        SliderFrame:Destroy()
    end
    
    -- Call callback with initial value
    SliderData.Callback(currentValue)
    
    return SliderMethods
end

-- TextBox Module
local function CreateTextBox(parent, config)
    local TextBoxData = {
        Title = config.Title or "Input Textbox",
        Desc = config.Desc,
        Placeholder = config.Placeholder or "Input here...",
        Default = config.Default or config.Value or "",
        Text = config.Default or config.Value or "",
        ClearTextOnFocus = config.ClearTextOnFocus or false,
        Locked = config.Locked or false,
        MultiLine = config.MultiLine or false,
        Callback = config.Callback or function() end
    }

    local TextBoxMethods = {}

    -- Main TextBox Frame
    local TextBoxFrame = Instance.new("Frame")
    TextBoxFrame.Visible = false
    TextBoxFrame.BorderSizePixel = 0
    TextBoxFrame.BackgroundColor3 = Color3.fromRGB(43, 46, 53)
    TextBoxFrame.AutomaticSize = Enum.AutomaticSize.Y
    TextBoxFrame.Size = UDim2.new(1, 0, 0, 35)
    TextBoxFrame.Position = UDim2.new(-0.0375, 0, 0.38434, 0)
    TextBoxFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TextBoxFrame.Name = "TextBox"
    TextBoxFrame.Parent = parent

    local TextBoxCorner = Instance.new("UICorner")
    TextBoxCorner.CornerRadius = UDim.new(0, 6)
    TextBoxCorner.Parent = TextBoxFrame

    local TextBoxStroke = Instance.new("UIStroke")
    TextBoxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    TextBoxStroke.Thickness = 1.5
    TextBoxStroke.Color = Color3.fromRGB(61, 61, 75)
    TextBoxStroke.Parent = TextBoxFrame

    -- Title Label
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.TextWrapped = true
    TitleLabel.Interactable = false
    TitleLabel.BorderSizePixel = 0
    TitleLabel.TextSize = 16
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    TitleLabel.TextColor3 = Color3.fromRGB(197, 204, 219)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Size = UDim2.new(1, 0, 0, 15)
    TitleLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
    TitleLabel.Text = TextBoxData.Title
    TitleLabel.AutomaticSize = Enum.AutomaticSize.Y
    TitleLabel.Name = "Title"
    TitleLabel.Parent = TextBoxFrame

    -- Padding for the main frame
    local MainPadding = Instance.new("UIPadding")
    MainPadding.PaddingTop = UDim.new(0, 10)
    MainPadding.PaddingRight = UDim.new(0, 10)
    MainPadding.PaddingLeft = UDim.new(0, 10)
    MainPadding.PaddingBottom = UDim.new(0, 10)
    MainPadding.Parent = TextBoxFrame

    -- Layout for main frame
    local MainLayout = Instance.new("UIListLayout")
    MainLayout.Padding = UDim.new(0, 10)
    MainLayout.SortOrder = Enum.SortOrder.LayoutOrder
    MainLayout.Parent = TextBoxFrame

    -- Description Label (if provided)
    local DescriptionLabel = nil
    if TextBoxData.Desc and TextBoxData.Desc ~= "" then
        DescriptionLabel = Instance.new("TextLabel")
        DescriptionLabel.TextWrapped = true
        DescriptionLabel.Interactable = false
        DescriptionLabel.BorderSizePixel = 0
        DescriptionLabel.TextSize = 16
        DescriptionLabel.TextXAlignment = Enum.TextXAlignment.Left
        DescriptionLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        DescriptionLabel.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
        DescriptionLabel.TextColor3 = Color3.fromRGB(197, 204, 219)
        DescriptionLabel.BackgroundTransparency = 1
        DescriptionLabel.Size = UDim2.new(1, 0, 0, 15)
        DescriptionLabel.Visible = true
        DescriptionLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
        DescriptionLabel.Text = TextBoxData.Desc
        DescriptionLabel.LayoutOrder = 1
        DescriptionLabel.AutomaticSize = Enum.AutomaticSize.Y
        DescriptionLabel.Name = "Description"
        DescriptionLabel.Parent = TextBoxFrame
    end

    -- Box Frame Container
    local BoxFrame = Instance.new("Frame")
    BoxFrame.ZIndex = 0
    BoxFrame.BorderSizePixel = 0
    BoxFrame.AutomaticSize = Enum.AutomaticSize.Y
    BoxFrame.Size = UDim2.new(1, 0, 0, 25)
    BoxFrame.Name = "BoxFrame"
    BoxFrame.LayoutOrder = 2
    BoxFrame.BackgroundTransparency = 1
    BoxFrame.Parent = TextBoxFrame

    -- Drop Shadow for Box
    local DropShadow = Instance.new("ImageLabel")
    DropShadow.ZIndex = 0
    DropShadow.BorderSizePixel = 0
    DropShadow.SliceCenter = Rect.new(49, 49, 450, 450)
    DropShadow.ScaleType = Enum.ScaleType.Slice
    DropShadow.ImageTransparency = 0.75
    DropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    DropShadow.Image = "rbxassetid://6014261993"
    DropShadow.Size = UDim2.new(1, 35, 1, 30)
    DropShadow.BackgroundTransparency = 1
    DropShadow.Name = "DropShadow"
    DropShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    DropShadow.Parent = BoxFrame

    -- Input Box Container
    local InputBox = Instance.new("Frame")
    InputBox.BorderSizePixel = 0
    InputBox.BackgroundColor3 = Color3.fromRGB(43, 46, 53)
    InputBox.AutomaticSize = Enum.AutomaticSize.Y
    InputBox.Size = UDim2.new(1, 0, 0, 25)
    InputBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
    InputBox.Parent = BoxFrame

    local InputBoxCorner = Instance.new("UICorner")
    InputBoxCorner.CornerRadius = UDim.new(0, 5)
    InputBoxCorner.Parent = InputBox

    local InputBoxStroke = Instance.new("UIStroke")
    InputBoxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    InputBoxStroke.Thickness = 1.5
    InputBoxStroke.Color = Color3.fromRGB(61, 61, 75)
    InputBoxStroke.Parent = InputBox

    -- Layout for Input Box
    local InputBoxLayout = Instance.new("UIListLayout")
    InputBoxLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    InputBoxLayout.Padding = UDim.new(0, 5)
    InputBoxLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    InputBoxLayout.SortOrder = Enum.SortOrder.LayoutOrder
    InputBoxLayout.Parent = InputBox

    -- Actual TextBox
    local ActualTextBox = Instance.new("TextBox")
    ActualTextBox.TextXAlignment = Enum.TextXAlignment.Left
    ActualTextBox.PlaceholderColor3 = Color3.fromRGB(140, 140, 140)
    ActualTextBox.BorderSizePixel = 0
    ActualTextBox.TextWrapped = true
    ActualTextBox.TextTruncate = Enum.TextTruncate.AtEnd
    ActualTextBox.TextSize = 14
    ActualTextBox.TextColor3 = Color3.fromRGB(197, 204, 219)
    ActualTextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ActualTextBox.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    ActualTextBox.AutomaticSize = Enum.AutomaticSize.Y
    ActualTextBox.ClipsDescendants = true
    ActualTextBox.PlaceholderText = TextBoxData.Placeholder
    ActualTextBox.Size = UDim2.new(1, 0, 0, 25)
    ActualTextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ActualTextBox.Text = TextBoxData.Default
    ActualTextBox.BackgroundTransparency = 1
    ActualTextBox.MultiLine = TextBoxData.MultiLine
    ActualTextBox.ClearTextOnFocus = TextBoxData.ClearTextOnFocus
    ActualTextBox.Parent = InputBox

    -- TextBox Padding
    local TextBoxPadding = Instance.new("UIPadding")
    TextBoxPadding.PaddingTop = UDim.new(0, 5)
    TextBoxPadding.PaddingRight = UDim.new(0, 10)
    TextBoxPadding.PaddingLeft = UDim.new(0, 10)
    TextBoxPadding.PaddingBottom = UDim.new(0, 5)
    TextBoxPadding.Parent = ActualTextBox

    -- Apply MultiLine settings
    if TextBoxData.MultiLine then
        ActualTextBox.AutomaticSize = Enum.AutomaticSize.Y
    else
        ActualTextBox.AutomaticSize = Enum.AutomaticSize.None
    end

    -- Apply locked state if needed
    if TextBoxData.Locked then
        TextBoxStroke.Color = Color3.fromRGB(47, 47, 58)
        TextBoxFrame.BackgroundColor3 = Color3.fromRGB(32, 35, 40)
        TitleLabel.TextColor3 = Color3.fromRGB(75, 77, 83)
        if DescriptionLabel then
            DescriptionLabel.TextColor3 = Color3.fromRGB(75, 77, 83)
        end
        InputBox.BackgroundColor3 = Color3.fromRGB(32, 35, 40)
        InputBoxStroke.Color = Color3.fromRGB(47, 47, 58)
        ActualTextBox.TextColor3 = Color3.fromRGB(75, 77, 83)
        ActualTextBox.PlaceholderColor3 = Color3.fromRGB(75, 77, 83)
        ActualTextBox.Active = false
        ActualTextBox.Interactable = false
        ActualTextBox.TextEditable = false
    end

    -- TextBox Interaction Events
    ActualTextBox.MouseEnter:Connect(function()
        if not TextBoxData.Locked then
            CreateTween(TextBoxStroke, {Color = Color3.fromRGB(10, 135, 213)}, AnimationConfig.Global)
        end
    end)

    ActualTextBox.MouseLeave:Connect(function()
        if not TextBoxData.Locked then
            CreateTween(TextBoxStroke, {Color = Color3.fromRGB(60, 60, 74)}, AnimationConfig.Global)
        end
    end)

    ActualTextBox.Focused:Connect(function()
        if not TextBoxData.Locked then
            CreateTween(TextBoxStroke, {Color = Color3.fromRGB(60, 60, 74)}, AnimationConfig.Global)
            CreateTween(InputBoxStroke, {Color = Color3.fromRGB(10, 135, 213)}, AnimationConfig.Global)
        end
    end)

    ActualTextBox.FocusLost:Connect(function()
        if not TextBoxData.Locked then
            CreateTween(InputBoxStroke, {Color = Color3.fromRGB(60, 60, 74)}, AnimationConfig.Global)
            TextBoxData.Text = ActualTextBox.Text
            TextBoxData.Callback(TextBoxData.Text)
        end
    end)

    -- Show TextBox
    TextBoxFrame.Visible = true

    -- TextBox Methods
    function TextBoxMethods:Set(text)
        ActualTextBox.Text = text
        TextBoxData.Text = text
        TextBoxData.Callback(text)
    end

    function TextBoxMethods:SetTitle(title)
        TextBoxData.Title = title
        TitleLabel.Text = title
    end

    function TextBoxMethods:SetDesc(desc)
        if desc and desc ~= "" then
            TextBoxData.Desc = desc
            if not DescriptionLabel then
                -- Create description label if it doesn't exist
                DescriptionLabel = Instance.new("TextLabel")
                DescriptionLabel.TextWrapped = true
                DescriptionLabel.Interactable = false
                DescriptionLabel.BorderSizePixel = 0
                DescriptionLabel.TextSize = 16
                DescriptionLabel.TextXAlignment = Enum.TextXAlignment.Left
                DescriptionLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                DescriptionLabel.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
                DescriptionLabel.TextColor3 = Color3.fromRGB(197, 204, 219)
                DescriptionLabel.BackgroundTransparency = 1
                DescriptionLabel.Size = UDim2.new(1, 0, 0, 15)
                DescriptionLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
                DescriptionLabel.LayoutOrder = 1
                DescriptionLabel.AutomaticSize = Enum.AutomaticSize.Y
                DescriptionLabel.Name = "Description"
                DescriptionLabel.Parent = TextBoxFrame
            end
            DescriptionLabel.Text = desc
            DescriptionLabel.Visible = true
        elseif DescriptionLabel then
            DescriptionLabel.Visible = false
        end
    end

    function TextBoxMethods:SetPlaceholder(placeholder)
        if placeholder then
            TextBoxData.Placeholder = placeholder
            ActualTextBox.PlaceholderText = placeholder
        end
    end

    function TextBoxMethods:Lock()
        TextBoxData.Locked = true
        CreateTween(TextBoxStroke, {Color = Color3.fromRGB(47, 47, 58)}, AnimationConfig.Global)
        CreateTween(TextBoxFrame, {BackgroundColor3 = Color3.fromRGB(32, 35, 40)}, AnimationConfig.Global)
        CreateTween(TitleLabel, {TextColor3 = Color3.fromRGB(75, 77, 83)}, AnimationConfig.Global)
        if DescriptionLabel then
            CreateTween(DescriptionLabel, {TextColor3 = Color3.fromRGB(75, 77, 83)}, AnimationConfig.Global)
        end
        CreateTween(InputBox, {BackgroundColor3 = Color3.fromRGB(32, 35, 40)}, AnimationConfig.Global)
        CreateTween(InputBoxStroke, {Color = Color3.fromRGB(47, 47, 58)}, AnimationConfig.Global)
        CreateTween(ActualTextBox, {
            TextColor3 = Color3.fromRGB(75, 77, 83),
            PlaceholderColor3 = Color3.fromRGB(75, 77, 83)
        }, AnimationConfig.Global)
        ActualTextBox.Active = false
        ActualTextBox.Interactable = false
        ActualTextBox.TextEditable = false
    end

    function TextBoxMethods:Unlock()
        TextBoxData.Locked = false
        CreateTween(TextBoxStroke, {Color = Color3.fromRGB(60, 60, 74)}, AnimationConfig.Global)
        CreateTween(TextBoxFrame, {BackgroundColor3 = Color3.fromRGB(42, 45, 52)}, AnimationConfig.Global)
        CreateTween(TitleLabel, {TextColor3 = Color3.fromRGB(196, 203, 218)}, AnimationConfig.Global)
        if DescriptionLabel then
            CreateTween(DescriptionLabel, {TextColor3 = Color3.fromRGB(196, 203, 218)}, AnimationConfig.Global)
        end
        CreateTween(InputBox, {BackgroundColor3 = Color3.fromRGB(42, 45, 52)}, AnimationConfig.Global)
        CreateTween(InputBoxStroke, {Color = Color3.fromRGB(60, 60, 74)}, AnimationConfig.Global)
        CreateTween(ActualTextBox, {
            TextColor3 = Color3.fromRGB(196, 203, 218),
            PlaceholderColor3 = Color3.fromRGB(139, 139, 139)
        }, AnimationConfig.Global)
        ActualTextBox.Active = true
        ActualTextBox.Interactable = true
        ActualTextBox.TextEditable = true
    end

    function TextBoxMethods:Destroy()
        TextBoxFrame:Destroy()
    end

    -- Initialize callback with current text
    TextBoxData.Callback(TextBoxData.Text)

    return TextBoxMethods
end

-- Toggle Module
local function CreateToggle(parent, config)
    local ToggleData = {
        Title = config.Title or "Toggle",
        Desc = config.Desc,
        State = config.Default or config.Value or false,
        Locked = config.Locked or false,
        Icon = config.Icon,
        Callback = config.Callback or function() end
    }

    local ToggleMethods = {}

    -- Main Toggle Frame
    local ToggleFrame = Instance.new("ImageButton")
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.AutoButtonColor = false
    ToggleFrame.Visible = false
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(43, 46, 53)
    ToggleFrame.Selectable = false
    ToggleFrame.AutomaticSize = Enum.AutomaticSize.Y
    ToggleFrame.Size = UDim2.new(1, 0, 0, 35)
    ToggleFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ToggleFrame.Name = "Toggle"
    ToggleFrame.Position = UDim2.new(-0.0375, 0, 0.38434, 0)
    ToggleFrame.Parent = parent

    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 6)
    ToggleCorner.Parent = ToggleFrame

    local ToggleStroke = Instance.new("UIStroke")
    ToggleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    ToggleStroke.Thickness = 1.5
    ToggleStroke.Color = Color3.fromRGB(61, 61, 75)
    ToggleStroke.Parent = ToggleFrame

    local TogglePadding = Instance.new("UIPadding")
    TogglePadding.PaddingTop = UDim.new(0, 10)
    TogglePadding.PaddingRight = UDim.new(0, 10)
    TogglePadding.PaddingLeft = UDim.new(0, 10)
    TogglePadding.PaddingBottom = UDim.new(0, 10)
    TogglePadding.Parent = ToggleFrame

    local ToggleLayout = Instance.new("UIListLayout")
    ToggleLayout.Padding = UDim.new(0, 5)
    ToggleLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ToggleLayout.Parent = ToggleFrame

    -- Description Label (if provided)
    local DescriptionLabel = nil
    if ToggleData.Desc and ToggleData.Desc ~= "" then
        DescriptionLabel = Instance.new("TextLabel")
        DescriptionLabel.TextWrapped = true
        DescriptionLabel.Interactable = false
        DescriptionLabel.BorderSizePixel = 0
        DescriptionLabel.TextSize = 16
        DescriptionLabel.TextXAlignment = Enum.TextXAlignment.Left
        DescriptionLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        DescriptionLabel.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
        DescriptionLabel.TextColor3 = Color3.fromRGB(197, 204, 219)
        DescriptionLabel.BackgroundTransparency = 1
        DescriptionLabel.Size = UDim2.new(1, 0, 0, 15)
        DescriptionLabel.Visible = true
        DescriptionLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
        DescriptionLabel.Text = ToggleData.Desc
        DescriptionLabel.LayoutOrder = 1
        DescriptionLabel.AutomaticSize = Enum.AutomaticSize.Y
        DescriptionLabel.Name = "Description"
        DescriptionLabel.Parent = ToggleFrame
    end

    -- Toggle Title with Switch
    local ToggleTitle = Instance.new("TextLabel")
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
    ToggleTitle.Text = ToggleData.Title
    ToggleTitle.Name = "Title"
    ToggleTitle.Parent = ToggleFrame

    -- Toggle Switch Container
    local ToggleSwitch = Instance.new("ImageButton")
    ToggleSwitch.BorderSizePixel = 0
    ToggleSwitch.AutoButtonColor = false
    ToggleSwitch.BackgroundColor3 = Color3.fromRGB(54, 57, 63)
    ToggleSwitch.ImageColor3 = Color3.fromRGB(197, 204, 219)
    ToggleSwitch.AnchorPoint = Vector2.new(1, 0.5)
    ToggleSwitch.Size = UDim2.new(0, 45, 0, 25)
    ToggleSwitch.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ToggleSwitch.Name = "Fill"
    ToggleSwitch.Position = UDim2.new(1, 0, 0.5, 0)
    ToggleSwitch.Parent = ToggleTitle

    local ToggleSwitchCorner = Instance.new("UICorner")
    ToggleSwitchCorner.CornerRadius = UDim.new(100, 0)
    ToggleSwitchCorner.Parent = ToggleSwitch

    local ToggleSwitchPadding = Instance.new("UIPadding")
    ToggleSwitchPadding.PaddingTop = UDim.new(0, 2)
    ToggleSwitchPadding.PaddingRight = UDim.new(0, 2)
    ToggleSwitchPadding.PaddingLeft = UDim.new(0, 2)
    ToggleSwitchPadding.PaddingBottom = UDim.new(0, 2)
    ToggleSwitchPadding.Parent = ToggleSwitch

    -- Toggle Ball (the sliding part)
    local ToggleBall = Instance.new("ImageButton")
    ToggleBall.Active = false
    ToggleBall.Interactable = false
    ToggleBall.BorderSizePixel = 0
    ToggleBall.AutoButtonColor = false
    ToggleBall.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ToggleBall.ImageColor3 = Color3.fromRGB(197, 204, 219)
    ToggleBall.AnchorPoint = Vector2.new(0, 0.5)
    ToggleBall.Size = UDim2.new(0, 20, 0, 20)
    ToggleBall.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ToggleBall.Name = "Ball"
    ToggleBall.Position = UDim2.new(0, 0, 0.5, 0)
    ToggleBall.Parent = ToggleSwitch

    local ToggleBallCorner = Instance.new("UICorner")
    ToggleBallCorner.CornerRadius = UDim.new(100, 0)
    ToggleBallCorner.Parent = ToggleBall

    -- Toggle Icon (inside the ball)
    local ToggleIcon = Instance.new("ImageLabel")
    ToggleIcon.BorderSizePixel = 0
    ToggleIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ToggleIcon.ImageColor3 = Color3.fromRGB(54, 57, 63)
    ToggleIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    ToggleIcon.Size = UDim2.new(1, -5, 1, -5)
    ToggleIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ToggleIcon.BackgroundTransparency = 1
    ToggleIcon.Name = "Icon"
    ToggleIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
    ToggleIcon.Parent = ToggleBall

    -- Set icon if provided
    if ToggleData.Icon then
        if string.find(ToggleData.Icon, "rbxassetid") or string.match(ToggleData.Icon, "%d") then
            ToggleIcon.Image = ToggleData.Icon
        else
            -- For non-rbxassetid icons, assume it's a placeholder
            ToggleIcon.Image = ""
        end
    end

    -- Helper Functions
    local function UpdateToggleVisual(state)
        if state == true then
            -- ON state
            CreateTween(ToggleBall, {Position = UDim2.new(0.5, 0, 0.5, 0)}, AnimationConfig.Global)
            CreateTween(ToggleSwitch, {BackgroundColor3 = Color3.fromRGB(192, 209, 199)}, AnimationConfig.Global)
            CreateTween(ToggleIcon, {ImageTransparency = 0}, AnimationConfig.Global)
        elseif state == false then
            -- OFF state
            CreateTween(ToggleBall, {Position = UDim2.new(0, 0, 0.5, 0)}, AnimationConfig.Global)
            CreateTween(ToggleSwitch, {BackgroundColor3 = Color3.fromRGB(53, 56, 62)}, AnimationConfig.Global)
            CreateTween(ToggleIcon, {ImageTransparency = 1}, AnimationConfig.Global)
        end
    end

    local function SetToggleState(state)
        if state ~= nil then
            UpdateToggleVisual(state)
        else
            UpdateToggleVisual(not ToggleData.State)
        end
        ToggleData.State = state or not ToggleData.State
        ToggleData.Callback(ToggleData.State)
    end

    -- Apply initial state
    UpdateToggleVisual(ToggleData.State)

    -- Apply locked state if needed
    if ToggleData.Locked then
        ToggleStroke.Color = Color3.fromRGB(47, 47, 58)
        ToggleFrame.BackgroundColor3 = Color3.fromRGB(32, 35, 40)
        ToggleTitle.TextColor3 = Color3.fromRGB(75, 77, 83)
        if DescriptionLabel then
            DescriptionLabel.TextColor3 = Color3.fromRGB(75, 77, 83)
        end
        ToggleSwitch.BackgroundTransparency = 0.7
        ToggleBall.BackgroundTransparency = 0.7
    end

    -- Toggle Interaction Events
    ToggleSwitch.MouseEnter:Connect(function()
        if not ToggleData.Locked then
            CreateTween(ToggleStroke, {Color = Color3.fromRGB(10, 135, 213)}, AnimationConfig.Global)
        end
    end)

    ToggleSwitch.MouseLeave:Connect(function()
        if not ToggleData.Locked then
            CreateTween(ToggleStroke, {Color = Color3.fromRGB(60, 60, 74)}, AnimationConfig.Global)
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(42, 45, 52)
            CreateTween(ToggleTitle, {TextColor3 = Color3.fromRGB(196, 203, 218)}, AnimationConfig.Global)
            if DescriptionLabel then
                CreateTween(DescriptionLabel, {TextColor3 = Color3.fromRGB(196, 203, 218)}, AnimationConfig.Global)
            end
        end
    end)

    ToggleSwitch.MouseButton1Click:Connect(function()
        if not ToggleData.Locked then
            SetToggleState()
        end
    end)

    -- Show toggle
    ToggleFrame.Visible = true

    -- Toggle Methods
    function ToggleMethods:SetTitle(title)
        ToggleData.Title = title
        ToggleTitle.Text = title
    end

    function ToggleMethods:SetDesc(desc)
        if desc and desc ~= "" then
            ToggleData.Desc = desc
            if not DescriptionLabel then
                -- Create description label if it doesn't exist
                DescriptionLabel = Instance.new("TextLabel")
                DescriptionLabel.TextWrapped = true
                DescriptionLabel.Interactable = false
                DescriptionLabel.BorderSizePixel = 0
                DescriptionLabel.TextSize = 16
                DescriptionLabel.TextXAlignment = Enum.TextXAlignment.Left
                DescriptionLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                DescriptionLabel.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
                DescriptionLabel.TextColor3 = Color3.fromRGB(197, 204, 219)
                DescriptionLabel.BackgroundTransparency = 1
                DescriptionLabel.Size = UDim2.new(1, 0, 0, 15)
                DescriptionLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
                DescriptionLabel.LayoutOrder = 1
                DescriptionLabel.AutomaticSize = Enum.AutomaticSize.Y
                DescriptionLabel.Name = "Description"
                DescriptionLabel.Parent = ToggleFrame
            end
            DescriptionLabel.Text = desc
            DescriptionLabel.Visible = true
        elseif DescriptionLabel then
            DescriptionLabel.Visible = false
        end
    end

    function ToggleMethods:Set(state)
        SetToggleState(state)
    end

    function ToggleMethods:GetValue()
        return ToggleData.State
    end

    function ToggleMethods:Lock()
        ToggleData.Locked = true
        CreateTween(ToggleFrame, {BackgroundColor3 = Color3.fromRGB(32, 35, 40)}, AnimationConfig.Global)
        CreateTween(ToggleStroke, {Color = Color3.fromRGB(47, 47, 58)}, AnimationConfig.Global)
        CreateTween(ToggleTitle, {TextColor3 = Color3.fromRGB(75, 77, 83)}, AnimationConfig.Global)
        if DescriptionLabel then
            CreateTween(DescriptionLabel, {TextColor3 = Color3.fromRGB(75, 77, 83)}, AnimationConfig.Global)
        end
        CreateTween(ToggleSwitch, {BackgroundTransparency = 0.7}, AnimationConfig.Global)
        CreateTween(ToggleBall, {BackgroundTransparency = 0.7}, AnimationConfig.Global)
    end

    function ToggleMethods:Unlock()
        ToggleData.Locked = false
        CreateTween(ToggleFrame, {BackgroundColor3 = Color3.fromRGB(42, 45, 52)}, AnimationConfig.Global)
        CreateTween(ToggleStroke, {Color = Color3.fromRGB(60, 60, 74)}, AnimationConfig.Global)
        CreateTween(ToggleTitle, {TextColor3 = Color3.fromRGB(196, 203, 218)}, AnimationConfig.Global)
        if DescriptionLabel then
            CreateTween(DescriptionLabel, {TextColor3 = Color3.fromRGB(196, 203, 218)}, AnimationConfig.Global)
        end
        CreateTween(ToggleSwitch, {BackgroundTransparency = 0}, AnimationConfig.Global)
        CreateTween(ToggleBall, {BackgroundTransparency = 0}, AnimationConfig.Global)
    end

    function ToggleMethods:Destroy()
        ToggleFrame:Destroy()
    end

    -- Initial callback
    ToggleData.Callback(ToggleData.State)

    return ToggleMethods
end

-- Button Module
local function CreateButton(parent, config)
    local ButtonData = {
        Title = config.Title or "Button",
        Desc = config.Desc,
        Locked = config.Locked or false,
        Callback = config.Callback or function() end
    }

    local ButtonMethods = {}

    -- Main Button Frame
    local ButtonFrame = Instance.new("ImageButton")
    ButtonFrame.BorderSizePixel = 0
    ButtonFrame.AutoButtonColor = false
    ButtonFrame.Visible = false
    ButtonFrame.BackgroundColor3 = Color3.fromRGB(43, 46, 53)
    ButtonFrame.Selectable = false
    ButtonFrame.AutomaticSize = Enum.AutomaticSize.Y
    ButtonFrame.Size = UDim2.new(1, 0, 0, 35)
    ButtonFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ButtonFrame.Name = "Button"
    ButtonFrame.Position = UDim2.new(0, 0, 0.384, 0)
    ButtonFrame.Parent = parent

    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 6)
    ButtonCorner.Parent = ButtonFrame

    local ButtonStroke = Instance.new("UIStroke")
    ButtonStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    ButtonStroke.Thickness = 1.5
    ButtonStroke.Color = Color3.fromRGB(61, 61, 75)
    ButtonStroke.Parent = ButtonFrame

    -- Button Content Frame
    local ButtonContent = Instance.new("Frame")
    ButtonContent.BorderSizePixel = 0
    ButtonContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ButtonContent.AutomaticSize = Enum.AutomaticSize.Y
    ButtonContent.Size = UDim2.new(1, 0, 0, 35)
    ButtonContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ButtonContent.BackgroundTransparency = 1
    ButtonContent.Parent = ButtonFrame

    local ButtonLayout = Instance.new("UIListLayout")
    ButtonLayout.Padding = UDim.new(0, 5)
    ButtonLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ButtonLayout.Parent = ButtonContent

    local ButtonPadding = Instance.new("UIPadding")
    ButtonPadding.PaddingTop = UDim.new(0, 10)
    ButtonPadding.PaddingRight = UDim.new(0, 10)
    ButtonPadding.PaddingLeft = UDim.new(0, 10)
    ButtonPadding.PaddingBottom = UDim.new(0, 10)
    ButtonPadding.Parent = ButtonContent

    -- Button Title
    local ButtonTitle = Instance.new("TextLabel")
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
    ButtonTitle.Text = ButtonData.Title
    ButtonTitle.Name = "Title"
    ButtonTitle.Parent = ButtonContent

    -- Click Icon (for visual feedback)
    local ClickIcon = Instance.new("ImageButton")
    ClickIcon.BorderSizePixel = 0
    ClickIcon.AutoButtonColor = false
    ClickIcon.BackgroundTransparency = 1
    ClickIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ClickIcon.ImageColor3 = Color3.fromRGB(197, 204, 219)
    ClickIcon.AnchorPoint = Vector2.new(1, 0.5)
    ClickIcon.Image = "rbxassetid://91877599529856"
    ClickIcon.Size = UDim2.new(0, 23, 0, 23)
    ClickIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ClickIcon.Name = "ClickIcon"
    ClickIcon.Position = UDim2.new(1, 0, 0.5, 0)
    ClickIcon.Parent = ButtonTitle

    -- Description Label (if provided)
    local DescriptionLabel = nil
    if ButtonData.Desc and ButtonData.Desc ~= "" then
        DescriptionLabel = Instance.new("TextLabel")
        DescriptionLabel.TextWrapped = true
        DescriptionLabel.Interactable = false
        DescriptionLabel.BorderSizePixel = 0
        DescriptionLabel.TextSize = 16
        DescriptionLabel.TextXAlignment = Enum.TextXAlignment.Left
        DescriptionLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        DescriptionLabel.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
        DescriptionLabel.TextColor3 = Color3.fromRGB(197, 204, 219)
        DescriptionLabel.BackgroundTransparency = 1
        DescriptionLabel.Size = UDim2.new(1, 0, 0, 15)
        DescriptionLabel.Visible = true
        DescriptionLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
        DescriptionLabel.Text = ButtonData.Desc
        DescriptionLabel.LayoutOrder = 1
        DescriptionLabel.AutomaticSize = Enum.AutomaticSize.Y
        DescriptionLabel.Name = "Description"
        DescriptionLabel.Parent = ButtonContent
    end

    -- Button Gradients (matching OGLIB style)
    local ButtonGradients = {}
    
    local ButtonGradient1 = Instance.new("UIGradient")
    ButtonGradient1.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 5, 255)),
        ColorSequenceKeypoint.new(0.16, Color3.fromRGB(0, 158, 255)),
        ColorSequenceKeypoint.new(0.32, Color3.fromRGB(0, 158, 255)),
        ColorSequenceKeypoint.new(0.54, Color3.fromRGB(0, 5, 255)),
        ColorSequenceKeypoint.new(0.782, Color3.fromRGB(0, 158, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 158, 255))
    }
    ButtonGradient1.Enabled = false
    ButtonGradient1.Parent = ButtonContent
    table.insert(ButtonGradients, ButtonGradient1)

    local ButtonGradient2 = Instance.new("UIGradient")
    ButtonGradient2.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 158, 255)),
        ColorSequenceKeypoint.new(0.16, Color3.fromRGB(0, 235, 255)),
        ColorSequenceKeypoint.new(0.32, Color3.fromRGB(0, 158, 255)),
        ColorSequenceKeypoint.new(0.54, Color3.fromRGB(0, 5, 255)),
        ColorSequenceKeypoint.new(0.782, Color3.fromRGB(0, 235, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 158, 255))
    }
    ButtonGradient2.Enabled = false
    ButtonGradient2.Parent = ButtonContent
    table.insert(ButtonGradients, ButtonGradient2)

    local ButtonGradient3 = Instance.new("UIGradient")
    ButtonGradient3.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 158, 255)),
        ColorSequenceKeypoint.new(0.16, Color3.fromRGB(0, 5, 255)),
        ColorSequenceKeypoint.new(0.32, Color3.fromRGB(0, 158, 255)),
        ColorSequenceKeypoint.new(0.54, Color3.fromRGB(0, 235, 255)),
        ColorSequenceKeypoint.new(0.782, Color3.fromRGB(0, 5, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 158, 255))
    }
    ButtonGradient3.Enabled = false
    ButtonGradient3.Parent = ButtonContent
    table.insert(ButtonGradients, ButtonGradient3)

    local ButtonContentCorner = Instance.new("UICorner")
    ButtonContentCorner.CornerRadius = UDim.new(0, 6)
    ButtonContentCorner.Parent = ButtonContent

    -- Gradient cycling function
    local function CycleGradient()
        -- Disable all gradients
        for _, gradient in ipairs(ButtonGradients) do
            gradient.Enabled = false
        end
        -- Enable random gradient
        local randomGradient = ButtonGradients[math.random(1, #ButtonGradients)]
        randomGradient.Enabled = true
        return randomGradient
    end

    -- Initialize with random gradient
    CycleGradient()

    -- Apply locked state if needed
    if ButtonData.Locked then
        ButtonStroke.Color = Color3.fromRGB(47, 47, 58)
        ButtonFrame.BackgroundColor3 = Color3.fromRGB(32, 35, 40)
        ButtonTitle.TextColor3 = Color3.fromRGB(75, 77, 83)
        ClickIcon.ImageColor3 = Color3.fromRGB(75, 77, 83)
        if DescriptionLabel then
            DescriptionLabel.TextColor3 = Color3.fromRGB(75, 77, 83)
        end
    end

    -- Button Interaction Events
    ButtonFrame.MouseEnter:Connect(function()
        if not ButtonData.Locked then
            CreateTween(ButtonStroke, {Color = Color3.fromRGB(10, 135, 213)}, AnimationConfig.Global)
        end
    end)

    ButtonFrame.MouseLeave:Connect(function()
        if not ButtonData.Locked then
            CreateTween(ButtonStroke, {Color = Color3.fromRGB(60, 60, 74)}, AnimationConfig.Global)
            ButtonFrame.BackgroundColor3 = Color3.fromRGB(42, 45, 52)
            CreateTween(ButtonTitle, {TextColor3 = Color3.fromRGB(196, 203, 218)}, AnimationConfig.Global)
            if DescriptionLabel then
                CreateTween(DescriptionLabel, {TextColor3 = Color3.fromRGB(196, 203, 218)}, AnimationConfig.Global)
            end
        end
    end)

    ButtonFrame.MouseButton1Down:Connect(function()
        if not ButtonData.Locked then
            CycleGradient()
            CreateTween(ButtonTitle, {TextColor3 = Color3.fromRGB(255, 255, 255)}, AnimationConfig.Global)
            CreateTween(ClickIcon, {ImageColor3 = Color3.fromRGB(255, 255, 255)}, AnimationConfig.Global)
            if DescriptionLabel then
                CreateTween(DescriptionLabel, {TextColor3 = Color3.fromRGB(255, 255, 255)}, AnimationConfig.Global)
            end
            CreateTween(ButtonContent, {BackgroundTransparency = 0}, AnimationConfig.Global)
        end
    end)

    ButtonFrame.MouseButton1Up:Connect(function()
        if not ButtonData.Locked then
            CreateTween(ButtonTitle, {TextColor3 = Color3.fromRGB(196, 203, 218)}, AnimationConfig.Global)
            CreateTween(ClickIcon, {ImageColor3 = Color3.fromRGB(196, 203, 218)}, AnimationConfig.Global)
            if DescriptionLabel then
                CreateTween(DescriptionLabel, {TextColor3 = Color3.fromRGB(196, 203, 218)}, AnimationConfig.Global)
            end
            CreateTween(ButtonContent, {BackgroundTransparency = 1}, AnimationConfig.Global)
        end
    end)

    ButtonFrame.MouseLeave:Connect(function()
        if not ButtonData.Locked then
            CreateTween(ButtonTitle, {TextColor3 = Color3.fromRGB(196, 203, 218)}, AnimationConfig.Global)
            CreateTween(ClickIcon, {ImageColor3 = Color3.fromRGB(196, 203, 218)}, AnimationConfig.Global)
            if DescriptionLabel then
                CreateTween(DescriptionLabel, {TextColor3 = Color3.fromRGB(196, 203, 218)}, AnimationConfig.Global)
            end
            CreateTween(ButtonContent, {BackgroundTransparency = 1}, AnimationConfig.Global)
        end
    end)

    ButtonFrame.MouseButton1Click:Connect(function()
        if not ButtonData.Locked then
            ButtonData.Callback()
        end
    end)

    -- Show button
    ButtonFrame.Visible = true

    -- Button Methods
    function ButtonMethods:SetTitle(title)
        ButtonData.Title = title
        ButtonTitle.Text = title
    end

    function ButtonMethods:SetDesc(desc)
        if desc and desc ~= "" then
            ButtonData.Desc = desc
            if not DescriptionLabel then
                -- Create description label if it doesn't exist
                DescriptionLabel = Instance.new("TextLabel")
                DescriptionLabel.TextWrapped = true
                DescriptionLabel.Interactable = false
                DescriptionLabel.BorderSizePixel = 0
                DescriptionLabel.TextSize = 16
                DescriptionLabel.TextXAlignment = Enum.TextXAlignment.Left
                DescriptionLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                DescriptionLabel.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
                DescriptionLabel.TextColor3 = Color3.fromRGB(197, 204, 219)
                DescriptionLabel.BackgroundTransparency = 1
                DescriptionLabel.Size = UDim2.new(1, 0, 0, 15)
                DescriptionLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
                DescriptionLabel.LayoutOrder = 1
                DescriptionLabel.AutomaticSize = Enum.AutomaticSize.Y
                DescriptionLabel.Name = "Description"
                DescriptionLabel.Parent = ButtonContent
            end
            DescriptionLabel.Text = desc
            DescriptionLabel.Visible = true
        elseif DescriptionLabel then
            DescriptionLabel.Visible = false
        end
    end

    function ButtonMethods:Lock()
        ButtonData.Locked = true
        CreateTween(ButtonFrame, {BackgroundColor3 = Color3.fromRGB(32, 35, 40)}, AnimationConfig.Global)
        CreateTween(ButtonStroke, {Color = Color3.fromRGB(47, 47, 58)}, AnimationConfig.Global)
        CreateTween(ButtonTitle, {TextColor3 = Color3.fromRGB(75, 77, 83)}, AnimationConfig.Global)
        CreateTween(ClickIcon, {ImageColor3 = Color3.fromRGB(75, 77, 83)}, AnimationConfig.Global)
        if DescriptionLabel then
            CreateTween(DescriptionLabel, {TextColor3 = Color3.fromRGB(75, 77, 83)}, AnimationConfig.Global)
        end
    end

    function ButtonMethods:Unlock()
        ButtonData.Locked = false
        CreateTween(ButtonFrame, {BackgroundColor3 = Color3.fromRGB(42, 45, 52)}, AnimationConfig.Global)
        CreateTween(ButtonStroke, {Color = Color3.fromRGB(60, 60, 74)}, AnimationConfig.Global)
        CreateTween(ButtonTitle, {TextColor3 = Color3.fromRGB(196, 203, 218)}, AnimationConfig.Global)
        CreateTween(ClickIcon, {ImageColor3 = Color3.fromRGB(196, 203, 218)}, AnimationConfig.Global)
        if DescriptionLabel then
            CreateTween(DescriptionLabel, {TextColor3 = Color3.fromRGB(196, 203, 218)}, AnimationConfig.Global)
        end
    end

    function ButtonMethods:Destroy()
        ButtonFrame:Destroy()
    end

    return ButtonMethods
end

-- Dropdown Module
local function CreateDropdown(parent, config)
    local DropdownData = {
        Title = config.Title or "Dropdown",
        Desc = config.Desc,
        Multi = config.Multi or false,
        Values = config.Values or {},
        Value = config.Value or config.Default,
        AllowNone = config.AllowNone or false,
        Locked = config.Locked or false,
        Callback = config.Callback or function() end
    }

    local DropdownMethods = {}
    local CurrentValue = DropdownData.Multi and (type(DropdownData.Value) == "table" and DropdownData.Value or {}) or DropdownData.Value
    local IsDropdownOpen = false

    -- Main Dropdown Frame
    local DropdownFrame = Instance.new("ImageButton")
    DropdownFrame.BorderSizePixel = 0
    DropdownFrame.AutoButtonColor = false
    DropdownFrame.Visible = false
    DropdownFrame.BackgroundColor3 = Color3.fromRGB(43, 46, 53)
    DropdownFrame.Selectable = false
    DropdownFrame.AutomaticSize = Enum.AutomaticSize.Y
    DropdownFrame.Size = UDim2.new(1, 0, 0, 35)
    DropdownFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    DropdownFrame.Name = "Dropdown"
    DropdownFrame.Position = UDim2.new(-0.0375, 0, 0.38434, 0)
    DropdownFrame.Parent = parent

    local DropdownCorner = Instance.new("UICorner")
    DropdownCorner.CornerRadius = UDim.new(0, 6)
    DropdownCorner.Parent = DropdownFrame

    local DropdownStroke = Instance.new("UIStroke")
    DropdownStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    DropdownStroke.Thickness = 1.5
    DropdownStroke.Color = Color3.fromRGB(61, 61, 75)
    DropdownStroke.Parent = DropdownFrame

    local DropdownPadding = Instance.new("UIPadding")
    DropdownPadding.PaddingTop = UDim.new(0, 10)
    DropdownPadding.PaddingRight = UDim.new(0, 10)
    DropdownPadding.PaddingLeft = UDim.new(0, 10)
    DropdownPadding.PaddingBottom = UDim.new(0, 10)
    DropdownPadding.Parent = DropdownFrame

    local DropdownLayout = Instance.new("UIListLayout")
    DropdownLayout.Padding = UDim.new(0, 5)
    DropdownLayout.SortOrder = Enum.SortOrder.LayoutOrder
    DropdownLayout.Parent = DropdownFrame

    -- Title Label
    local DropdownTitle = Instance.new("TextLabel")
    DropdownTitle.TextWrapped = true
    DropdownTitle.BorderSizePixel = 0
    DropdownTitle.TextSize = 16
    DropdownTitle.TextXAlignment = Enum.TextXAlignment.Left
    DropdownTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    DropdownTitle.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
    DropdownTitle.TextColor3 = Color3.fromRGB(197, 204, 219)
    DropdownTitle.BackgroundTransparency = 1
    DropdownTitle.Size = UDim2.new(1, 0, 0, 15)
    DropdownTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
    DropdownTitle.Text = DropdownData.Title
    DropdownTitle.Name = "Title"
    DropdownTitle.Position = UDim2.new(0.03135, 0, 0, 0)
    DropdownTitle.Parent = DropdownFrame

    -- Click Icon (Arrow)
    local DropdownArrow = Instance.new("ImageButton")
    DropdownArrow.BorderSizePixel = 0
    DropdownArrow.AutoButtonColor = false
    DropdownArrow.BackgroundTransparency = 1
    DropdownArrow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    DropdownArrow.ImageColor3 = Color3.fromRGB(197, 204, 219)
    DropdownArrow.AnchorPoint = Vector2.new(1, 0.5)
    DropdownArrow.Image = "rbxassetid://77563793724007"
    DropdownArrow.Size = UDim2.new(0, 23, 0, 23)
    DropdownArrow.BorderColor3 = Color3.fromRGB(0, 0, 0)
    DropdownArrow.Name = "ClickIcon"
    DropdownArrow.Position = UDim2.new(1, 0, 0.5, 0)
    DropdownArrow.Parent = DropdownTitle

    -- Selected Value Display
    local ValueDisplay = Instance.new("ImageButton")
    ValueDisplay.Active = false
    ValueDisplay.BorderSizePixel = 0
    ValueDisplay.BackgroundTransparency = 1
    ValueDisplay.Selectable = false
    ValueDisplay.ZIndex = 0
    ValueDisplay.AnchorPoint = Vector2.new(1, 0.5)
    ValueDisplay.AutomaticSize = Enum.AutomaticSize.X
    ValueDisplay.Size = UDim2.new(0, 20, 0, 20)
    ValueDisplay.Name = "BoxFrame"
    ValueDisplay.Position = UDim2.new(1, -33, 0.5, 0)
    ValueDisplay.Parent = DropdownTitle

    -- Value Display Shadow (Optional)
    local ValueShadow = Instance.new("ImageLabel")
    ValueShadow.Interactable = false
    ValueShadow.ZIndex = 0
    ValueShadow.BorderSizePixel = 0
    ValueShadow.SliceCenter = Rect.new(49, 49, 450, 450)
    ValueShadow.ScaleType = Enum.ScaleType.Slice
    ValueShadow.ImageTransparency = 0.75
    ValueShadow.AutomaticSize = Enum.AutomaticSize.X
    ValueShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    ValueShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    ValueShadow.Image = "rbxassetid://6014261993"
    ValueShadow.Size = UDim2.new(1, 28, 1, 28)
    ValueShadow.Visible = false
    ValueShadow.BackgroundTransparency = 1
    ValueShadow.Name = "DropShadow"
    ValueShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    ValueShadow.Parent = ValueDisplay

    -- Value Display Button
    local ValueButton = Instance.new("ImageButton")
    ValueButton.BorderSizePixel = 0
    ValueButton.AutoButtonColor = false
    ValueButton.BackgroundColor3 = Color3.fromRGB(43, 46, 53)
    ValueButton.Selectable = false
    ValueButton.AnchorPoint = Vector2.new(0.5, 0.5)
    ValueButton.AutomaticSize = Enum.AutomaticSize.X
    ValueButton.Size = UDim2.new(0, 20, 0, 20)
    ValueButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ValueButton.Name = "Trigger"
    ValueButton.Position = UDim2.new(0.5, 0, 0.5, 0)
    ValueButton.Parent = ValueDisplay

    local ValueCorner = Instance.new("UICorner")
    ValueCorner.CornerRadius = UDim.new(0, 5)
    ValueCorner.Parent = ValueButton

    local ValueStroke = Instance.new("UIStroke")
    ValueStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    ValueStroke.Thickness = 1.5
    ValueStroke.Color = Color3.fromRGB(61, 61, 75)
    ValueStroke.Parent = ValueButton

    local ValueLayout = Instance.new("UIListLayout")
    ValueLayout.Padding = UDim.new(0, 5)
    ValueLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    ValueLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ValueLayout.Parent = ValueButton

    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.TextWrapped = true
    ValueLabel.Interactable = false
    ValueLabel.BorderSizePixel = 0
    ValueLabel.TextSize = 16
    ValueLabel.TextScaled = true
    ValueLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ValueLabel.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    ValueLabel.TextColor3 = Color3.fromRGB(197, 204, 219)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.AnchorPoint = Vector2.new(0, 0.5)
    ValueLabel.Size = UDim2.new(0, 15, 0, 14)
    ValueLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ValueLabel.Text = ""
    ValueLabel.AutomaticSize = Enum.AutomaticSize.X
    ValueLabel.Name = "Title"
    ValueLabel.Position = UDim2.new(-0.00345, 0, 0.5, 0)
    ValueLabel.Parent = ValueButton

    local ValuePadding = Instance.new("UIPadding")
    ValuePadding.PaddingRight = UDim.new(0, 5)
    ValuePadding.PaddingLeft = UDim.new(0, 5)
    ValuePadding.Parent = ValueButton

    -- Description Label (if provided)
    local DescriptionLabel = nil
    if DropdownData.Desc and DropdownData.Desc ~= "" then
        DescriptionLabel = Instance.new("TextLabel")
        DescriptionLabel.TextWrapped = true
        DescriptionLabel.Interactable = false
        DescriptionLabel.BorderSizePixel = 0
        DescriptionLabel.TextSize = 16
        DescriptionLabel.TextXAlignment = Enum.TextXAlignment.Left
        DescriptionLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        DescriptionLabel.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
        DescriptionLabel.TextColor3 = Color3.fromRGB(197, 204, 219)
        DescriptionLabel.BackgroundTransparency = 1
        DescriptionLabel.Size = UDim2.new(1, 0, 0, 15)
        DescriptionLabel.Visible = true
        DescriptionLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
        DescriptionLabel.Text = DropdownData.Desc
        DescriptionLabel.LayoutOrder = 1
        DescriptionLabel.AutomaticSize = Enum.AutomaticSize.Y
        DescriptionLabel.Name = "Description"
        DescriptionLabel.Parent = DropdownFrame
    end

    -- Add Gradient Effects to main dropdown (matching OGLIB style)
    local DropdownGradient1 = Instance.new("UIGradient")
    DropdownGradient1.Enabled = false
    DropdownGradient1.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 5, 255)),
        ColorSequenceKeypoint.new(0.16, Color3.fromRGB(0, 158, 255)),
        ColorSequenceKeypoint.new(0.32, Color3.fromRGB(0, 158, 255)),
        ColorSequenceKeypoint.new(0.54, Color3.fromRGB(0, 5, 255)),
        ColorSequenceKeypoint.new(0.782, Color3.fromRGB(0, 158, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 158, 255))
    }
    DropdownGradient1.Parent = DropdownFrame

    local DropdownGradient2 = Instance.new("UIGradient")
    DropdownGradient2.Enabled = false
    DropdownGradient2.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 158, 255)),
        ColorSequenceKeypoint.new(0.16, Color3.fromRGB(0, 5, 255)),
        ColorSequenceKeypoint.new(0.32, Color3.fromRGB(0, 158, 255)),
        ColorSequenceKeypoint.new(0.54, Color3.fromRGB(0, 235, 255)),
        ColorSequenceKeypoint.new(0.782, Color3.fromRGB(0, 5, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 158, 255))
    }
    DropdownGradient2.Parent = DropdownFrame

    local DropdownGradient3 = Instance.new("UIGradient")
    DropdownGradient3.Enabled = false
    DropdownGradient3.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 158, 255)),
        ColorSequenceKeypoint.new(0.16, Color3.fromRGB(0, 235, 255)),
        ColorSequenceKeypoint.new(0.32, Color3.fromRGB(0, 158, 255)),
        ColorSequenceKeypoint.new(0.54, Color3.fromRGB(0, 5, 255)),
        ColorSequenceKeypoint.new(0.782, Color3.fromRGB(0, 235, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 158, 255))
    }
    DropdownGradient3.Parent = DropdownFrame

    -- Global popup management variables
    local GlobalDropdownSystem = nil
    local DropdownPopup = nil
    local PopupFrame = nil
    local PopupList = nil
    local PopupListSearch = nil
    local SearchBox = nil
    local DarkOverlay = nil

    -- Helper Functions
    local function FormatValueText(value)
        if DropdownData.Multi then
            if type(value) == "table" then
                return table.concat(value, ", ")
            else
                return tostring(value or "")
            end
        else
            return tostring(value or "")
        end
    end

    local function UpdateValueDisplay()
        ValueLabel.Text = FormatValueText(CurrentValue)
    end

    -- Handle duplicate values with counter (matching OGLIB logic)
    local function ProcessValues(values, reset)
        local processed = {}
        local counter = {}
        
        for _, value in ipairs(values) do
            if typeof(value) == "string" then
                if not counter[value] then
                    counter[value] = 1
                    table.insert(processed, value)
                else
                    counter[value] = counter[value] + 1
                    table.insert(processed, value .. " (" .. counter[value] .. ")")
                end
            end
        end
        
        if reset then
            DropdownData.Values = processed
        end
        
        return processed
    end

    -- Random gradient selector (matching OGLIB behavior)
    local function GetRandomGradient(frame)
        local gradients = {}
        for _, child in ipairs(frame:GetChildren()) do
            if child:IsA("UIGradient") then
                child.Enabled = false
                table.insert(gradients, child)
            end
        end
        if #gradients > 0 then
            local selected = gradients[math.random(1, #gradients)]
            selected.Enabled = true
            return selected
        end
    end

    local function CreateGlobalDropdownSystem()
        if GlobalDropdownSystem then return end

        -- Find the main window
        local window = parent
        while window and window.Name ~= "Window" do
            window = window.Parent
        end

        if not window then return end

        -- Create DropdownSelection system (matches OGLIB structure)
        DropdownPopup = Instance.new("Frame")
        DropdownPopup.Visible = false
        DropdownPopup.ZIndex = 51
        DropdownPopup.BorderSizePixel = 0
        DropdownPopup.BackgroundColor3 = Color3.fromRGB(32, 35, 41)
        DropdownPopup.AnchorPoint = Vector2.new(0.5, 0.5)
        DropdownPopup.ClipsDescendants = true
        DropdownPopup.Size = UDim2.new(0.7281, 0, 0.68367, 0)
        DropdownPopup.Position = UDim2.new(0.5, 0, 0.5, 0)
        DropdownPopup.BorderColor3 = Color3.fromRGB(61, 61, 75)
        DropdownPopup.Name = "DropdownSelection"
        DropdownPopup.Parent = window
        
        local function SetPopupZIndex()
    for _, child in pairs(DropdownPopup:GetDescendants()) do
        if child:IsA("GuiObject") then
            child.ZIndex = 51
        end
    end
end

        local PopupCorner = Instance.new("UICorner")
        PopupCorner.CornerRadius = UDim.new(0, 6)
        PopupCorner.Parent = DropdownPopup

        local PopupStroke = Instance.new("UIStroke")
        PopupStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        PopupStroke.Thickness = 1.5
        PopupStroke.Color = Color3.fromRGB(61, 61, 75)
        PopupStroke.Parent = DropdownPopup

        -- Create dark overlay
        DarkOverlay = Instance.new("TextButton") -- Ganti Frame jadi TextButton
DarkOverlay.Visible = false
DarkOverlay.BorderSizePixel = 0
DarkOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
DarkOverlay.Size = UDim2.new(1, 0, 1, 0)
DarkOverlay.BorderColor3 = Color3.fromRGB(0, 0, 0)
DarkOverlay.Name = "DarkOverlay"
DarkOverlay.BackgroundTransparency = 0.6
DarkOverlay.Text = ""
DarkOverlay.AutoButtonColor = false
DarkOverlay.ZIndex = 50 -- Set ZIndex tinggi
DarkOverlay.Parent = window

        local OverlayCorner = Instance.new("UICorner")
        OverlayCorner.CornerRadius = UDim.new(0, 10)
        OverlayCorner.Parent = DarkOverlay
        
        DarkOverlay.MouseButton1Click:Connect(function()
    CloseDropdown()
end)

        -- Popup Header
        local PopupHeader = Instance.new("Frame")
        PopupHeader.BorderSizePixel = 0
        PopupHeader.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        PopupHeader.Size = UDim2.new(1, 0, 0, 50)
        PopupHeader.Position = UDim2.new(0, 0, 0, 0)
        PopupHeader.BorderColor3 = Color3.fromRGB(0, 0, 0)
        PopupHeader.Name = "TopBar"
        PopupHeader.BackgroundTransparency = 1
        PopupHeader.Parent = DropdownPopup

        -- Search Box Frame (matching OGLIB structure)
        local SearchFrame = Instance.new("Frame")
        SearchFrame.BorderSizePixel = 0
        SearchFrame.AnchorPoint = Vector2.new(1, 0.5)
        SearchFrame.Size = UDim2.new(0, 120, 0, 25)
        SearchFrame.Position = UDim2.new(1, -50, 0.5, 0)
        SearchFrame.Name = "BoxFrame"
        SearchFrame.BackgroundTransparency = 1
        SearchFrame.Parent = PopupHeader

        -- Search Box Shadow
        local SearchShadow = Instance.new("ImageLabel")
        SearchShadow.ZIndex = 0
        SearchShadow.BorderSizePixel = 0
        SearchShadow.SliceCenter = Rect.new(49, 49, 450, 450)
        SearchShadow.ScaleType = Enum.ScaleType.Slice
        SearchShadow.ImageTransparency = 0.75
        SearchShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
        SearchShadow.AnchorPoint = Vector2.new(0.5, 0.5)
        SearchShadow.Image = "rbxassetid://6014261993"
        SearchShadow.Size = UDim2.new(1, 30, 1, 30)
        SearchShadow.BackgroundTransparency = 1
        SearchShadow.Name = "DropShadow"
        SearchShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
        SearchShadow.Parent = SearchFrame

        -- Search Box Container
        local SearchContainer = Instance.new("Frame")
        SearchContainer.BorderSizePixel = 0
        SearchContainer.BackgroundColor3 = Color3.fromRGB(43, 46, 53)
        SearchContainer.AutomaticSize = Enum.AutomaticSize.Y
        SearchContainer.Size = UDim2.new(1, 0, 1, 0)
        SearchContainer.BorderColor3 = Color3.fromRGB(0, 0, 0)
        SearchContainer.Parent = SearchFrame

        local SearchCorner = Instance.new("UICorner")
        SearchCorner.CornerRadius = UDim.new(0, 5)
        SearchCorner.Parent = SearchContainer

        local SearchStroke = Instance.new("UIStroke")
        SearchStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        SearchStroke.Thickness = 1.5
        SearchStroke.Color = Color3.fromRGB(61, 61, 75)
        SearchStroke.Parent = SearchContainer

        -- Search TextBox
        SearchBox = Instance.new("TextBox")
        SearchBox.TextXAlignment = Enum.TextXAlignment.Left
        SearchBox.BorderSizePixel = 0
        SearchBox.TextWrapped = true
        SearchBox.TextTruncate = Enum.TextTruncate.AtEnd
        SearchBox.TextSize = 14
        SearchBox.TextColor3 = Color3.fromRGB(197, 204, 219)
        SearchBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        SearchBox.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
        SearchBox.ClipsDescendants = true
        SearchBox.PlaceholderText = "Input here..."
        SearchBox.Size = UDim2.new(1, -25, 1, 0)
        SearchBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
        SearchBox.Text = ""
        SearchBox.BackgroundTransparency = 1
        SearchBox.Parent = SearchContainer

        local SearchPadding = Instance.new("UIPadding")
        SearchPadding.PaddingTop = UDim.new(0, 10)
        SearchPadding.PaddingRight = UDim.new(0, 10)
        SearchPadding.PaddingLeft = UDim.new(0, 10)
        SearchPadding.PaddingBottom = UDim.new(0, 10)
        SearchPadding.Parent = SearchBox

        -- Search Icon
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
        SearchIcon.Parent = SearchContainer

        -- Close Button
        local CloseButton = Instance.new("ImageButton")
        CloseButton.BorderSizePixel = 0
        CloseButton.BackgroundTransparency = 1
        CloseButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        CloseButton.ImageColor3 = Color3.fromRGB(197, 204, 219)
        CloseButton.ZIndex = 0
        CloseButton.AnchorPoint = Vector2.new(1, 0.5)
        CloseButton.Image = "rbxassetid://132453323679056"
        CloseButton.Size = UDim2.new(0, 25, 0, 25)
        CloseButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
        CloseButton.Name = "Close"
        CloseButton.Position = UDim2.new(1, -12, 0.5, 0)
        CloseButton.Parent = PopupHeader

        -- Title Label
        local PopupTitle = Instance.new("TextLabel")
        PopupTitle.TextWrapped = true
        PopupTitle.Interactable = false
        PopupTitle.ZIndex = 0
        PopupTitle.BorderSizePixel = 0
        PopupTitle.TextSize = 18
        PopupTitle.TextXAlignment = Enum.TextXAlignment.Left
        PopupTitle.TextScaled = true
        PopupTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        PopupTitle.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
        PopupTitle.TextColor3 = Color3.fromRGB(197, 204, 219)
        PopupTitle.BackgroundTransparency = 1
        PopupTitle.AnchorPoint = Vector2.new(0, 0.5)
        PopupTitle.Size = UDim2.new(0.5, 0, 0, 18)
        PopupTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
        PopupTitle.Text = "Dropdown"
        PopupTitle.Name = "Title"
        PopupTitle.Position = UDim2.new(0, 12, 0.5, 0)
        PopupTitle.Parent = PopupHeader

        -- Dropdowns Folder (matches OGLIB structure)
        local DropdownsFolder = Instance.new("Folder")
        DropdownsFolder.Name = "Dropdowns"
        DropdownsFolder.Parent = DropdownPopup

        -- Create dropdown-specific container
        local DropdownContainer = Instance.new("Folder")
        DropdownContainer.Name = DropdownData.Title
        DropdownContainer.Parent = DropdownsFolder

        -- Main Dropdown List
        PopupList = Instance.new("ScrollingFrame")
        PopupList.Visible = true
        PopupList.Active = true
        PopupList.ScrollingDirection = Enum.ScrollingDirection.Y
        PopupList.BorderSizePixel = 0
        PopupList.CanvasSize = UDim2.new(0, 0, 0, 0)
        PopupList.ElasticBehavior = Enum.ElasticBehavior.Never
        PopupList.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
        PopupList.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        PopupList.Name = "DropdownItems"
        PopupList.Selectable = false
        PopupList.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
        PopupList.AutomaticCanvasSize = Enum.AutomaticSize.Y
        PopupList.Size = UDim2.new(1, 0, 1, -50)
        PopupList.ScrollBarImageColor3 = Color3.fromRGB(99, 106, 122)
        PopupList.Position = UDim2.new(0, 0, 0, 50)
        PopupList.BorderColor3 = Color3.fromRGB(0, 0, 0)
        PopupList.ScrollBarThickness = 5
        PopupList.BackgroundTransparency = 1
        PopupList.Parent = DropdownContainer

        -- Search Results List (separate from main list)
        PopupListSearch = Instance.new("ScrollingFrame")
        PopupListSearch.Visible = false
        PopupListSearch.Active = true
        PopupListSearch.ScrollingDirection = Enum.ScrollingDirection.Y
        PopupListSearch.BorderSizePixel = 0
        PopupListSearch.CanvasSize = UDim2.new(0, 0, 0, 0)
        PopupListSearch.ElasticBehavior = Enum.ElasticBehavior.Never
        PopupListSearch.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
        PopupListSearch.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        PopupListSearch.Name = "DropdownItemsSearch"
        PopupListSearch.Selectable = false
        PopupListSearch.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
        PopupListSearch.AutomaticCanvasSize = Enum.AutomaticSize.Y
        PopupListSearch.Size = UDim2.new(1, 0, 1, -50)
        PopupListSearch.ScrollBarImageColor3 = Color3.fromRGB(99, 106, 122)
        PopupListSearch.Position = UDim2.new(0, 0, 0, 50)
        PopupListSearch.BorderColor3 = Color3.fromRGB(0, 0, 0)
        PopupListSearch.ScrollBarThickness = 5
        PopupListSearch.BackgroundTransparency = 1
        PopupListSearch.Parent = DropdownContainer

        local ListLayout = Instance.new("UIListLayout")
        ListLayout.Padding = UDim.new(0, 15)
        ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ListLayout.Parent = PopupList

        local ListPadding = Instance.new("UIPadding")
        ListPadding.PaddingTop = UDim.new(0, 2)
        ListPadding.PaddingRight = UDim.new(0, 10)
        ListPadding.PaddingLeft = UDim.new(0, 10)
        ListPadding.PaddingBottom = UDim.new(0, 10)
        ListPadding.Parent = PopupList

        local SearchListLayout = Instance.new("UIListLayout")
        SearchListLayout.Padding = UDim.new(0, 15)
        SearchListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        SearchListLayout.Parent = PopupListSearch

        local SearchListPadding = Instance.new("UIPadding")
        SearchListPadding.PaddingTop = UDim.new(0, 2)
        SearchListPadding.PaddingRight = UDim.new(0, 10)
        SearchListPadding.PaddingLeft = UDim.new(0, 10)
        SearchListPadding.PaddingBottom = UDim.new(0, 10)
        SearchListPadding.Parent = PopupListSearch

        -- Global events
        CloseButton.MouseButton1Click:Connect(function()
            CloseDropdown()
        end)

        -- Search functionality (matching OGLIB live search behavior)
        SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
            local searchText = SearchBox.Text
            if string.gsub(searchText, " ", "") ~= "" then
                PopupList.Visible = false
                PopupListSearch.Visible = true
                
                -- Filter search results
                for _, child in pairs(PopupListSearch:GetChildren()) do
                    if child:IsA("GuiButton") then
                        if string.find(child.Name:lower(), searchText:lower()) then
                            child.Visible = true
                        else
                            child.Visible = false
                        end
                    end
                end
            else
                PopupList.Visible = true
                PopupListSearch.Visible = false
            end
        end)

        GlobalDropdownSystem = {
            Popup = DropdownPopup,
            Overlay = DarkOverlay,
            Title = PopupTitle,
            SearchBox = SearchBox,
            CurrentDropdown = nil
        }
    end

    local function CreateDropdownItem(value, targetList)
        local ItemButton = Instance.new("ImageButton")
        ItemButton.BorderSizePixel = 0
        ItemButton.AutoButtonColor = false
        ItemButton.Visible = false
        ItemButton.BackgroundColor3 = Color3.fromRGB(43, 46, 53)
        ItemButton.Selectable = false
        ItemButton.AutomaticSize = Enum.AutomaticSize.Y
        ItemButton.Size = UDim2.new(1, 0, 0, 35)
        ItemButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
        ItemButton.Name = tostring(value)
        ItemButton.Position = UDim2.new(0, 0, 0.384, 0)
        ItemButton.Parent = targetList

        local ItemCorner = Instance.new("UICorner")
        ItemCorner.CornerRadius = UDim.new(0, 6)
        ItemCorner.Parent = ItemButton

        local ItemFrame = Instance.new("Frame")
        ItemFrame.BorderSizePixel = 0
        ItemFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ItemFrame.AutomaticSize = Enum.AutomaticSize.Y
        ItemFrame.Size = UDim2.new(1, 0, 0, 35)
        ItemFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
        ItemFrame.BackgroundTransparency = 1
        ItemFrame.Parent = ItemButton

        local ItemLayout = Instance.new("UIListLayout")
        ItemLayout.Padding = UDim.new(0, 5)
        ItemLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ItemLayout.Parent = ItemFrame

        local ItemPadding = Instance.new("UIPadding")
        ItemPadding.PaddingTop = UDim.new(0, 10)
        ItemPadding.PaddingRight = UDim.new(0, 10)
        ItemPadding.PaddingLeft = UDim.new(0, 10)
        ItemPadding.PaddingBottom = UDim.new(0, 10)
        ItemPadding.Parent = ItemFrame

        local ItemTitle = Instance.new("TextLabel")
        ItemTitle.TextWrapped = true
        ItemTitle.Interactable = false
        ItemTitle.BorderSizePixel = 0
        ItemTitle.TextSize = 16
        ItemTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ItemTitle.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
        ItemTitle.TextColor3 = Color3.fromRGB(197, 204, 219)
        ItemTitle.BackgroundTransparency = 1
        ItemTitle.Size = UDim2.new(1, 0, 0, 15)
        ItemTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
        ItemTitle.Text = tostring(value)
        ItemTitle.Name = "Title"
        ItemTitle.Parent = ItemFrame

        -- Item description (if needed)
        local ItemDescription = Instance.new("TextLabel")
        ItemDescription.TextWrapped = true
        ItemDescription.Interactable = false
        ItemDescription.BorderSizePixel = 0
        ItemDescription.TextSize = 16
        ItemDescription.TextXAlignment = Enum.TextXAlignment.Left
        ItemDescription.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ItemDescription.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
        ItemDescription.TextColor3 = Color3.fromRGB(197, 204, 219)
        ItemDescription.BackgroundTransparency = 1
        ItemDescription.Size = UDim2.new(1, 0, 0, 15)
        ItemDescription.Visible = false
        ItemDescription.BorderColor3 = Color3.fromRGB(0, 0, 0)
        ItemDescription.Text = ""
        ItemDescription.LayoutOrder = 1
        ItemDescription.AutomaticSize = Enum.AutomaticSize.Y
        ItemDescription.Name = "Description"
        ItemDescription.Parent = ItemFrame

        local ItemStroke = Instance.new("UIStroke")
        ItemStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        ItemStroke.Thickness = 1.5
        ItemStroke.Color = Color3.fromRGB(61, 61, 75)
        ItemStroke.Parent = ItemButton

        -- Item gradients (matching OGLIB style)
        local ItemGradient1 = Instance.new("UIGradient")
        ItemGradient1.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 5, 255)),
            ColorSequenceKeypoint.new(0.16, Color3.fromRGB(0, 158, 255)),
            ColorSequenceKeypoint.new(0.32, Color3.fromRGB(0, 158, 255)),
            ColorSequenceKeypoint.new(0.54, Color3.fromRGB(0, 5, 255)),
            ColorSequenceKeypoint.new(0.782, Color3.fromRGB(0, 158, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 158, 255))
        }
        ItemGradient1.Parent = ItemFrame

        local ItemGradient2 = Instance.new("UIGradient")
        ItemGradient2.Enabled = false
        ItemGradient2.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 158, 255)),
            ColorSequenceKeypoint.new(0.16, Color3.fromRGB(0, 235, 255)),
            ColorSequenceKeypoint.new(0.32, Color3.fromRGB(0, 158, 255)),
            ColorSequenceKeypoint.new(0.54, Color3.fromRGB(0, 5, 255)),
            ColorSequenceKeypoint.new(0.782, Color3.fromRGB(0, 235, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 158, 255))
        }
        ItemGradient2.Parent = ItemFrame

        local ItemGradient3 = Instance.new("UIGradient")
        ItemGradient3.Enabled = false
        ItemGradient3.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 158, 255)),
            ColorSequenceKeypoint.new(0.16, Color3.fromRGB(0, 5, 255)),
            ColorSequenceKeypoint.new(0.32, Color3.fromRGB(0, 158, 255)),
            ColorSequenceKeypoint.new(0.54, Color3.fromRGB(0, 235, 255)),
            ColorSequenceKeypoint.new(0.782, Color3.fromRGB(0, 5, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 158, 255))
        }
        ItemGradient3.Parent = ItemFrame

        local ItemFrameCorner = Instance.new("UICorner")
        ItemFrameCorner.CornerRadius = UDim.new(0, 6)
        ItemFrameCorner.Parent = ItemFrame

        ItemButton.Visible = true

        -- Random gradient selection (matching OGLIB behavior)
        GetRandomGradient(ItemFrame)

        -- Update visual based on selection
        local function UpdateItemVisual()
            local isSelected = false
            if DropdownData.Multi then
                isSelected = table.find(CurrentValue, value) ~= nil
            else
                isSelected = CurrentValue == value
            end

            if isSelected then
                CreateTween(ItemTitle, {TextColor3 = Color3.fromRGB(255, 255, 255)}, AnimationConfig.Global)
                CreateTween(ItemDescription, {TextColor3 = Color3.fromRGB(255, 255, 255)}, AnimationConfig.Global)
                CreateTween(ItemStroke, {Color = Color3.fromRGB(10, 135, 213)}, AnimationConfig.Global)
                CreateTween(ItemFrame, {BackgroundTransparency = 0}, AnimationConfig.Global)
            else
                CreateTween(ItemTitle, {TextColor3 = Color3.fromRGB(196, 203, 218)}, AnimationConfig.Global)
                CreateTween(ItemDescription, {TextColor3 = Color3.fromRGB(196, 203, 218)}, AnimationConfig.Global)
                CreateTween(ItemStroke, {Color = Color3.fromRGB(60, 60, 74)}, AnimationConfig.Global)
                CreateTween(ItemFrame, {BackgroundTransparency = 1}, AnimationConfig.Global)
            end
        end
        
        
        -- Item click handler
        ItemButton.MouseButton1Click:Connect(function()
            if not DropdownData.Locked then
                if DropdownData.Multi then
                    local index = table.find(CurrentValue, value)
                    if index then
                        if not DropdownData.AllowNone and #CurrentValue == 1 then
                            return -- Can't remove last item if AllowNone is false
                        end
                        table.remove(CurrentValue, index)
                    else
                        table.insert(CurrentValue, value)
                    end
                else
                    CurrentValue = value
                    CloseDropdown()
                end
                
                UpdateValueDisplay()
                UpdateItemVisual
                DropdownData.Callback(CurrentValue)
            end
        end)

        UpdateItemVisual()
        return ItemButton
    end

    local function RefreshDropdownItems()
        if not PopupList or not PopupListSearch then return end
        
        -- Clear existing items
        for _, child in ipairs(PopupList:GetChildren()) do
            if child:IsA("GuiButton") then
                child:Destroy()
            end
        end
        
        for _, child in ipairs(PopupListSearch:GetChildren()) do
            if child:IsA("GuiButton") then
                child:Destroy()
            end
        end

        -- Process and create new items
        local processedValues = ProcessValues(DropdownData.Values)
        for _, value in ipairs(processedValues) do
            CreateDropdownItem(value, PopupList)
            CreateDropdownItem(value, PopupListSearch)
        end
    end

    local function OpenDropdown()
        if not GlobalDropdownSystem then
            CreateGlobalDropdownSystem()
        end

        -- Set current dropdown context
        GlobalDropdownSystem.CurrentDropdown = DropdownData.Title
        GlobalDropdownSystem.Title.Text = DropdownData.Title
        
        -- Clear search
        GlobalDropdownSystem.SearchBox.Text = ""
        
        -- Show correct lists
        PopupList.Visible = true
        PopupListSearch.Visible = false

        RefreshDropdownItems()
        
        -- Show popup with animation (matching OGLIB)
        GlobalDropdownSystem.Overlay.BackgroundTransparency = 1
        GlobalDropdownSystem.Overlay.Visible = true
        GlobalDropdownSystem.Popup.Size = UDim2.new(0, 0, 0, 0)
        GlobalDropdownSystem.Popup.Visible = true
        
        CreateTween(GlobalDropdownSystem.Overlay, {BackgroundTransparency = 0.6}, AnimationConfig.PopupOpen)
        CreateTween(GlobalDropdownSystem.Popup, {Size = UDim2.new(0.7281, 0, 0.68367, 0)}, AnimationConfig.PopupOpen)
        
        IsDropdownOpen = true
    end

    function CloseDropdown()
        if not GlobalDropdownSystem then return end
        
        local closeTween = CreateTween(GlobalDropdownSystem.Overlay, {BackgroundTransparency = 1}, AnimationConfig.PopupClose)
        CreateTween(GlobalDropdownSystem.Popup, {Size = UDim2.new(0, 0, 0, 0)}, AnimationConfig.PopupClose)
        
        closeTween.Completed:Wait()
        GlobalDropdownSystem.Overlay.Visible = false
        GlobalDropdownSystem.Popup.Visible = false
        
        IsDropdownOpen = false
        GlobalDropdownSystem.CurrentDropdown = nil
    end

    -- Handle hover effects (matching OGLIB)
    DropdownFrame.MouseEnter:Connect(function()
        if not DropdownData.Locked then
            CreateTween(DropdownStroke, {Color = Color3.fromRGB(10, 135, 213)}, AnimationConfig.Global)
        end
    end)

    DropdownFrame.MouseLeave:Connect(function()
        if not DropdownData.Locked then
            CreateTween(DropdownStroke, {Color = Color3.fromRGB(60, 60, 74)}, AnimationConfig.Global)
        end
    end)

    -- Apply locked state
    if DropdownData.Locked then
        DropdownStroke.Color = Color3.fromRGB(47, 47, 58)
        DropdownFrame.BackgroundColor3 = Color3.fromRGB(32, 35, 40)
        DropdownTitle.TextColor3 = Color3.fromRGB(75, 77, 83)
        if DescriptionLabel then
            DescriptionLabel.TextColor3 = Color3.fromRGB(75, 77, 83)
        end
        DropdownArrow.ImageColor3 = Color3.fromRGB(75, 77, 83)
        ValueButton.BackgroundColor3 = Color3.fromRGB(32, 35, 40)
        ValueStroke.Color = Color3.fromRGB(47, 47, 58)
        ValueLabel.TextColor3 = Color3.fromRGB(75, 77, 83)
        DropdownFrame.Active = false
        DropdownFrame.Interactable = false
    end

    -- Update initial display
    UpdateValueDisplay()

    -- Multi icon support
    if DropdownData.Multi then
        DropdownArrow.Image = "rbxassetid://91415671397056"
    end

    -- Process initial values
    DropdownData.Values = ProcessValues(DropdownData.Values, true)

    -- Click events
    ValueButton.MouseButton1Click:Connect(function()
        if not DropdownData.Locked then
            if IsDropdownOpen then
                CloseDropdown()
            else
                OpenDropdown()
            end
        end
    end)

    DropdownArrow.MouseButton1Click:Connect(function()
        if not DropdownData.Locked then
            if IsDropdownOpen then
                CloseDropdown()
            else
                OpenDropdown()
            end
        end
    end)

    -- Show dropdown
    DropdownFrame.Visible = true

    -- Dropdown Methods
    function DropdownMethods:SetTitle(title)
        DropdownData.Title = title
        DropdownTitle.Text = title
        if GlobalDropdownSystem and GlobalDropdownSystem.CurrentDropdown == DropdownData.Title then
            GlobalDropdownSystem.Title.Text = title
        end
    end

    function DropdownMethods:SetDesc(desc)
        if DescriptionLabel and desc and desc ~= "" then
            DropdownData.Desc = desc
            DescriptionLabel.Text = desc
            DescriptionLabel.Visible = true
        elseif DescriptionLabel then
            DescriptionLabel.Visible = false
        elseif desc and desc ~= "" then
            -- Create description label if it doesn't exist
            DescriptionLabel = Instance.new("TextLabel")
            DescriptionLabel.TextWrapped = true
            DescriptionLabel.Interactable = false
            DescriptionLabel.BorderSizePixel = 0
            DescriptionLabel.TextSize = 16
            DescriptionLabel.TextXAlignment = Enum.TextXAlignment.Left
            DescriptionLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            DescriptionLabel.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
            DescriptionLabel.TextColor3 = Color3.fromRGB(197, 204, 219)
            DescriptionLabel.BackgroundTransparency = 1
            DescriptionLabel.Size = UDim2.new(1, 0, 0, 15)
            DescriptionLabel.Visible = true
            DescriptionLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
            DescriptionLabel.Text = desc
            DescriptionLabel.LayoutOrder = 1
            DescriptionLabel.AutomaticSize = Enum.AutomaticSize.Y
            DescriptionLabel.Name = "Description"
            DescriptionLabel.Parent = DropdownFrame
            
            DropdownData.Desc = desc
        end
    end

    function DropdownMethods:Refresh(values)
        DropdownData.Values = ProcessValues(values or DropdownData.Values, true)
        
        -- Reset current value if it's not in new values
        if DropdownData.Multi then
            local newValue = {}
            for _, val in ipairs(CurrentValue) do
                if table.find(DropdownData.Values, val) then
                    table.insert(newValue, val)
                end
            end
            CurrentValue = newValue
        else
            if not table.find(DropdownData.Values, CurrentValue) then
                CurrentValue = nil
            end
        end
        
        UpdateValueDisplay()
        if IsDropdownOpen then
            RefreshDropdownItems()
        end
        
        DropdownData.Callback(CurrentValue)
    end

    function DropdownMethods:Select(value)
        if DropdownData.Multi then
            if type(value) == "table" then
                CurrentValue = {}
                for _, val in ipairs(value) do
                    if table.find(DropdownData.Values, val) then
                        table.insert(CurrentValue, val)
                    end
                end
            else
                local index = table.find(CurrentValue, value)
                if index then
                    if not DropdownData.AllowNone and #CurrentValue == 1 then
                        return -- Can't remove last item if AllowNone is false
                    end
                    table.remove(CurrentValue, index)
                else
                    if table.find(DropdownData.Values, value) then
                        table.insert(CurrentValue, value)
                    end
                end
            end
        else
            if table.find(DropdownData.Values, value) then
                CurrentValue = value
            end
        end
        
        UpdateValueDisplay()
        if IsDropdownOpen then
            RefreshDropdownItems()
        end
        
        DropdownData.Callback(CurrentValue)
    end

    function DropdownMethods:GetValue()
        return CurrentValue
    end

    function DropdownMethods:Lock()
        DropdownData.Locked = true
        CreateTween(DropdownStroke, {Color = Color3.fromRGB(47, 47, 58)}, AnimationConfig.Global)
        CreateTween(DropdownFrame, {BackgroundColor3 = Color3.fromRGB(32, 35, 40)}, AnimationConfig.Global)
        CreateTween(DropdownTitle, {TextColor3 = Color3.fromRGB(75, 77, 83)}, AnimationConfig.Global)
        if DescriptionLabel then
            CreateTween(DescriptionLabel, {TextColor3 = Color3.fromRGB(75, 77, 83)}, AnimationConfig.Global)
        end
        CreateTween(DropdownArrow, {ImageColor3 = Color3.fromRGB(75, 77, 83)}, AnimationConfig.Global)
        CreateTween(ValueButton, {BackgroundColor3 = Color3.fromRGB(32, 35, 40)}, AnimationConfig.Global)
        CreateTween(ValueStroke, {Color = Color3.fromRGB(47, 47, 58)}, AnimationConfig.Global)
        CreateTween(ValueLabel, {TextColor3 = Color3.fromRGB(75, 77, 83)}, AnimationConfig.Global)
        DropdownFrame.Active = false
        DropdownFrame.Interactable = false
    end

    function DropdownMethods:Unlock()
        DropdownData.Locked = false
        CreateTween(DropdownStroke, {Color = Color3.fromRGB(60, 60, 74)}, AnimationConfig.Global)
        CreateTween(DropdownFrame, {BackgroundColor3 = Color3.fromRGB(42, 45, 52)}, AnimationConfig.Global)
        CreateTween(DropdownTitle, {TextColor3 = Color3.fromRGB(196, 203, 218)}, AnimationConfig.Global)
        if DescriptionLabel then
            CreateTween(DescriptionLabel, {TextColor3 = Color3.fromRGB(196, 203, 218)}, AnimationConfig.Global)
        end
        CreateTween(DropdownArrow, {ImageColor3 = Color3.fromRGB(196, 203, 218)}, AnimationConfig.Global)
        CreateTween(ValueButton, {BackgroundColor3 = Color3.fromRGB(42, 45, 52)}, AnimationConfig.Global)
        CreateTween(ValueStroke, {Color = Color3.fromRGB(60, 60, 74)}, AnimationConfig.Global)
        CreateTween(ValueLabel, {TextColor3 = Color3.fromRGB(196, 203, 218)}, AnimationConfig.Global)
        DropdownFrame.Active = true
        DropdownFrame.Interactable = true
    end

    function DropdownMethods:Destroy()
        if GlobalDropdownSystem and GlobalDropdownSystem.CurrentDropdown == DropdownData.Title then
            CloseDropdown()
        end
        DropdownFrame:Destroy()
    end

    -- Initial callback
    DropdownData.Callback(CurrentValue)

    return DropdownMethods
end

-- Section Module
local function CreateSection(parent, config)
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
            CreateTween(ArrowIcon, {Rotation = 0}, AnimationConfig.Section)
            SectionData.State = false
        else
            -- Open Section
            SectionContent.Visible = true
            CreateTween(ArrowIcon, {Rotation = 90}, AnimationConfig.Section)
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

    function SectionMethods:Dropdown(config)
        return CreateDropdown(SectionContent, config)
    end

    function SectionMethods:Button(config)
    return CreateButton(SectionContent, config)
end
 
    function SectionMethods:Toggle(config)
    return CreateToggle(SectionContent, config)
end


    function SectionMethods:Input(config)
    return CreateTextBox(SectionContent, config)
end

    function SectionMethods:Slider(config)
    return CreateSlider(SectionContent, config)
end
    
    function SectionMethods:Paragraph(config)
    return CreateParagraph(SectionContent, config)
end

    return SectionMethods
end

-- Create Window Function
function Library:CreateWindow(config)
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
        WindowMethods:Dialog({
        Title   = "Close Window",
        Content = "Do you want to close this window? You will not able to open it again.",
        Buttons = {
            {
                Title = "Cancel" -- cukup tutup dialog
            },
            {
                Title = "Close",
                Callback = function()
                    if ScreenGui and ScreenGui.Destroy then ScreenGui:Destroy() end
                    if Container and Container.Destroy then Container:Destroy() end
                end
            },
        }
    })
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
    function WindowMethods:Tab(config)
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
        RegisterTab(TabConfig.Title, TabContent, TabButton, true)
        TabButton.Visible = true

        -- Set as current tab if it's the first one
        if #TabList == 1 then
            CurrentTab = TabConfig.Title
            SwitchToTab(TabConfig.Title)
        end

        -- Tab Button Click Handler
        TabButton.MouseButton1Click:Connect(function()
            SwitchToTab(TabConfig.Title)
        end)

        -- Tab Content Change Monitoring
        TabContent.ChildAdded:Connect(function()
            if CurrentTab == TabConfig.Title then
                local childCount = 0
                for _, child in ipairs(TabContent:GetChildren()) do
                    if child:IsA("GuiObject") and child.Name ~= "UIListLayout" and child.Name ~= "UIPadding" then
                        childCount = childCount + 1
                    end
                end
                NoObjectFoundText.Visible = (childCount == 0)
            end
        end)

        TabContent.ChildRemoved:Connect(function()
            if CurrentTab == TabConfig.Title then
                local childCount = 0
                for _, child in ipairs(TabContent:GetChildren()) do
                    if child:IsA("GuiObject") and child.Name ~= "UIListLayout" and child.Name ~= "UIPadding" then
                        childCount = childCount + 1
                    end
                end
                NoObjectFoundText.Visible = (childCount == 0)
            end
        end)

        -- Tab Methods
        function TabMethods:Section(config)
            return CreateSection(TabContent, config)
        end

        function TabMethods:GetContainer()
            return TabContent
        end

        return TabMethods
    end

    function WindowMethods:SelectTab(tabIndex)
        local tabInfo = TabList[tabIndex]
        if tabInfo then
            SwitchToTab(tabInfo.Name)
        end
    end

    function WindowMethods:Divider()
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

    function WindowMethods:SetToggleKey(keyCode)
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
    
    function WindowMethods:Dialog(config)
    return CreateDialog(Window, config)
end

    return WindowMethods
end

return Library
