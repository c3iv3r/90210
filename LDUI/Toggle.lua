-- OGLIB Recreation
-- Library UI lengkap untuk Roblox dengan semua elemen Window

local Library = {}

-- Utility functions
local function MakeDraggable(Frame, DragFrame)
    local Dragging = false
    local DragInput, MousePos, FramePos

    DragFrame.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true
            MousePos = Input.Position
            FramePos = Frame.Position

            Input.Changed:Connect(function()
                if Input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)

    DragFrame.InputChanged:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseMovement and Dragging then
            local Delta = Input.Position - MousePos
            Frame.Position = UDim2.new(FramePos.X.Scale, FramePos.X.Offset + Delta.X, FramePos.Y.Scale, FramePos.Y.Offset + Delta.Y)
        end
    end)
end

local function CreateElement(Type, Properties)
    local Element = Instance.new(Type)
    for Property, Value in pairs(Properties or {}) do
        Element[Property] = Value
    end
    return Element
end

local function ApplyCorner(Object, Radius)
    local Corner = CreateElement("UICorner", { CornerRadius = UDim.new(0, Radius or 5) })
    Corner.Parent = Object
    return Corner
end

local function ApplyStroke(Object, Color, Transparency, Thickness)
    local Stroke = CreateElement("UIStroke", {
        Color = Color or Color3.fromRGB(61, 61, 75),
        Transparency = Transparency or 0,
        Thickness = Thickness or 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    })
    Stroke.Parent = Object
    return Stroke
end

local function ApplyPadding(Object, Top, Bottom, Left, Right)
    local Padding = CreateElement("UIPadding", {
        PaddingTop = UDim.new(0, Top or 0),
        PaddingBottom = UDim.new(0, Bottom or 0),
        PaddingLeft = UDim.new(0, Left or 0),
        PaddingRight = UDim.new(0, Right or 0)
    })
    Padding.Parent = Object
    return Padding
end

local function ApplyListLayout(Object, Padding, FillDirection, HorizontalAlignment, SortOrder, VerticalAlignment)
    local ListLayout = CreateElement("UIListLayout", {
        Padding = UDim.new(0, Padding or 0),
        FillDirection = FillDirection or Enum.FillDirection.Vertical,
        HorizontalAlignment = HorizontalAlignment or Enum.HorizontalAlignment.Left,
        SortOrder = SortOrder or Enum.SortOrder.LayoutOrder,
        VerticalAlignment = VerticalAlignment or Enum.VerticalAlignment.Top
    })
    ListLayout.Parent = Object
    return ListLayout
end

-- Button Template
local function CreateButton(Config)
    local Button = CreateElement("TextButton", {
        Text = Config.Text or "Button",
        Size = Config.Size or UDim2.new(0, 100, 0, 30),
        BackgroundColor3 = Config.BackgroundColor or Color3.fromRGB(43, 46, 53),
        TextColor3 = Color3.fromRGB(197, 204, 219),
        FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
        Parent = Config.Parent
    })
    ApplyCorner(Button, 6)
    ApplyStroke(Button)
    if Config.Callback then
        Button.MouseButton1Click:Connect(Config.Callback)
    end
    return Button
end

-- Toggle Template
local function CreateToggle(Config)
    local Toggle = CreateElement("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        Parent = Config.Parent
    })
    
    local ToggleButton = CreateElement("TextButton", {
        Text = Config.Text or "Toggle",
        Size = UDim2.new(1, -50, 1, 0),
        BackgroundTransparency = 1,
        TextColor3 = Color3.fromRGB(197, 204, 219),
        FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Toggle
    })
    
    local ToggleFrame = CreateElement("Frame", {
        Size = UDim2.new(0, 45, 0, 25),
        Position = UDim2.new(1, -50, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = Color3.fromRGB(54, 57, 63),
        Parent = Toggle
    })
    ApplyCorner(ToggleFrame, 100)
    
    local ToggleBall = CreateElement("Frame", {
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(0, 2, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = Color3.fromRGB(197, 204, 219),
        Parent = ToggleFrame
    })
    ApplyCorner(ToggleBall, 100)
    
    local Toggled = false
    ToggleButton.MouseButton1Click:Connect(function()
        Toggled = not Toggled
        if Toggled then
            ToggleBall.Position = UDim2.new(1, -22, 0.5, 0)
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(11, 136, 214)
        else
            ToggleBall.Position = UDim2.new(0, 2, 0.5, 0)
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(54, 57, 63)
        end
        if Config.Callback then
            Config.Callback(Toggled)
        end
    end)
    
    return Toggle
end

-- Slider Template
local function CreateSlider(Config)
    local Slider = CreateElement("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1,
        Parent = Config.Parent
    })
    
    local SliderLabel = CreateElement("TextLabel", {
        Text = Config.Text or "Slider",
        Size = UDim2.new(1, -100, 0, 20),
        BackgroundTransparency = 1,
        TextColor3 = Color3.fromRGB(197, 204, 219),
        FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Slider
    })
    
    local SliderValue = CreateElement("TextLabel", {
        Text = tostring(Config.Default or 50),
        Size = UDim2.new(0, 80, 0, 20),
        Position = UDim2.new(1, -80, 0, 0),
        BackgroundTransparency = 1,
        TextColor3 = Color3.fromRGB(197, 204, 219),
        FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = Slider
    })
    
    local SliderBar = CreateElement("Frame", {
        Size = UDim2.new(1, 0, 0, 10),
        Position = UDim2.new(0, 0, 1, -10),
        BackgroundColor3 = Color3.fromRGB(43, 46, 53),
        Parent = Slider
    })
    ApplyCorner(SliderBar, 5)
    ApplyStroke(SliderBar)
    
    local SliderFill = CreateElement("Frame", {
        Size = UDim2.new((Config.Default or 50) / 100, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Color3.fromRGB(11, 136, 214),
        Parent = SliderBar
    })
    ApplyCorner(SliderFill, 5)
    
    local SliderButton = CreateElement("TextButton", {
        Text = "",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Parent = SliderBar
    })
    
    local Dragging = false
    SliderButton.MouseButton1Down:Connect(function()
        Dragging = true
    end)
    
    game:GetService("UserInputService").InputEnded:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = false
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(Input)
        if Dragging and Input.UserInputType == Enum.UserInputType.MouseMovement then
            local MousePos = game.Players.LocalPlayer:GetMouse().X
            local SliderPos = SliderBar.AbsolutePosition.X
            local SliderSize = SliderBar.AbsoluteSize.X
            local Percent = math.clamp((MousePos - SliderPos) / SliderSize, 0, 1)
            SliderFill.Size = UDim2.new(Percent, 0, 1, 0)
            local Value = math.floor(Percent * (Config.Max or 100))
            SliderValue.Text = tostring(Value)
            if Config.Callback then
                Config.Callback(Value)
            end
        end
    end)
    
    return Slider
end

-- Label Template
local function CreateLabel(Config)
    local Label = CreateElement("TextLabel", {
        Text = Config.Text or "Label",
        Size = Config.Size or UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        TextColor3 = Color3.fromRGB(197, 204, 219),
        FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        Parent = Config.Parent
    })
    return Label
end

-- TextBox Template
local function CreateTextBox(Config)
    local TextBox = CreateElement("Frame", {
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = Color3.fromRGB(43, 46, 53),
        Parent = Config.Parent
    })
    ApplyCorner(TextBox, 6)
    ApplyStroke(TextBox)
    
    local Input = CreateElement("TextBox", {
        Text = Config.Text or "",
        PlaceholderText = Config.Placeholder or "Enter text...",
        Size = UDim2.new(1, -20, 1, -10),
        Position = UDim2.new(0, 10, 0, 5),
        BackgroundTransparency = 1,
        TextColor3 = Color3.fromRGB(197, 204, 219),
        PlaceholderColor3 = Color3.fromRGB(135, 140, 150),
        FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
        Parent = TextBox
    })
    
    if Config.Callback then
        Input.FocusLost:Connect(function(EnterPressed)
            Config.Callback(Input.Text, EnterPressed)
        end)
    end
    
    return TextBox
end

-- Dropdown Template
local function CreateDropdown(Config)
    local Dropdown = CreateElement("Frame", {
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = Color3.fromRGB(43, 46, 53),
        Parent = Config.Parent
    })
    ApplyCorner(Dropdown, 6)
    ApplyStroke(Dropdown)
    
    local DropdownButton = CreateElement("TextButton", {
        Text = Config.Default or "Select Option",
        Size = UDim2.new(1, -30, 1, 0),
        BackgroundTransparency = 1,
        TextColor3 = Color3.fromRGB(197, 204, 219),
        FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Dropdown
    })
    
    local DropdownIcon = CreateElement("ImageLabel", {
        Image = "rbxassetid://6031068421",
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -25, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundTransparency = 1,
        Parent = Dropdown
    })
    
    local DropdownList = CreateElement("ScrollingFrame", {
        Size = UDim2.new(1, 0, 0, 150),
        Position = UDim2.new(0, 0, 1, 5),
        BackgroundColor3 = Color3.fromRGB(32, 35, 41),
        Visible = false,
        ScrollBarThickness = 4,
        Parent = Dropdown
    }
    ApplyCorner(DropdownList, 6)
    ApplyStroke(DropdownList)
    ApplyListLayout(DropdownList, 5)
    
    for i, Option in ipairs(Config.Options or {}) do
        local OptionButton = CreateElement("TextButton", {
            Text = Option,
            Size = UDim2.new(1, -10, 0, 30),
            BackgroundTransparency = 1,
            TextColor3 = Color3.fromRGB(197, 204, 219),
            FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
            Parent = DropdownList
        })
        
        OptionButton.MouseButton1Click:Connect(function()
            DropdownButton.Text = Option
            DropdownList.Visible = false
            if Config.Callback then
                Config.Callback(Option)
            end
        end)
    end
    
    DropdownButton.MouseButton1Click:Connect(function()
        DropdownList.Visible = not DropdownList.Visible
    end)
    
    return Dropdown
end

-- Main Library Function
function Library:CreateWindow(Config)
    local ScreenGui = CreateElement("ScreenGui", {
        Name = Config.Title or "OGLIB_Window",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })

    -- Handle GUI Protection and Parenting
    local cloneref = cloneref or function(obj) return obj end
    if protect_gui then
        protect_gui(ScreenGui)
    elseif gethui then
        ScreenGui.Parent = gethui()
    elseif pcall(function() game:GetService("CoreGui"):GetChildren() end) then
        ScreenGui.Parent = cloneref(game:GetService("CoreGui"))
    else
        ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    end

    -- Main Window Frame
    local Window = CreateElement("Frame", {
        Name = "Window",
        BackgroundColor3 = Color3.fromRGB(37, 40, 47),
        BorderColor3 = Color3.fromRGB(61, 61, 75),
        BorderSizePixel = 2,
        Position = Config.Position or UDim2.new(0.5, 0, 0.5, 0),
        Size = Config.Size or UDim2.new(0, 528, 0, 334),
        AnchorPoint = Vector2.new(0.5, 0.5),
        ZIndex = 0
    })
    ApplyCorner(Window, 10)
    ApplyStroke(Window, Color3.fromRGB(95, 95, 117), 0.5, 1.5)
    Window.Parent = ScreenGui

    -- Top Frame (Title Bar)
    local TopFrame = CreateElement("Frame", {
        Name = "TopFrame",
        BackgroundColor3 = Color3.fromRGB(37, 40, 47),
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 35),
        ZIndex = 1
    })
    ApplyCorner(TopFrame, 6)
    local TopBorder = CreateElement("Frame", {
        Name = "Border",
        BackgroundColor3 = Color3.fromRGB(61, 61, 75),
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 2),
        Position = UDim2.new(0, 0, 1, 0),
        ZIndex = 2
    })
    TopBorder.Parent = TopFrame
    TopFrame.Parent = Window

    -- Icon
    local Icon = CreateElement("ImageButton", {
        Name = "Icon",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 25, 0, 25),
        Position = UDim2.new(0, 10, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        Image = Config.Icon or "rbxassetid://113216930555884",
        ImageColor3 = Color3.fromRGB(197, 204, 219),
        ZIndex = 3
    })
    CreateElement("UIAspectRatioConstraint").Parent = Icon
    Icon.Parent = TopFrame

    -- Title
    local Title = CreateElement("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Text = Config.Title or "OGLIB Window",
        TextColor3 = Color3.fromRGB(197, 204, 219),
        TextScaled = true,
        TextSize = 14,
        FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
        Size = UDim2.new(1, -120, 1),
        Position = UDim2.new(0, 40, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 3
    })
    Title.Parent = TopFrame

    -- Subtitle
    if Config.Subtitle then
        local Subtitle = CreateElement("TextLabel", {
            Name = "Subtitle",
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Text = Config.Subtitle,
            TextColor3 = Color3.fromRGB(135, 140, 150),
            TextScaled = true,
            TextSize = 12,
            FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
            Size = UDim2.new(1, -120, 0, 15),
            Position = UDim2.new(0, 40, 0, 18),
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 3
        })
        Subtitle.Parent = TopFrame
    end

    -- Window Controls (Hide, Maximize, Close)
    local HideButton = CreateElement("ImageButton", {
        Name = "Hide",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -90, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        Image = "rbxassetid://128209591224511",
        ImageColor3 = Color3.fromRGB(197, 204, 219),
        ZIndex = 3
    })
    HideButton.Parent = TopFrame

    if Config.Resizeable ~= false then
        local MaximizeButton = CreateElement("ImageButton", {
            Name = "Maximize",
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(0, 15, 0, 15),
            Position = UDim2.new(1, -55, 0.5, 0),
            AnchorPoint = Vector2.new(1, 0.5),
            Image = "rbxassetid://108285848026510",
            ImageColor3 = Color3.fromRGB(197, 204, 219),
            ZIndex = 3
        })
        MaximizeButton.Parent = TopFrame
    end

    local CloseButton = CreateElement("ImageButton", {
        Name = "Close",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -15, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        Image = "rbxassetid://132453323679056",
        ImageColor3 = Color3.fromRGB(197, 204, 219),
        ZIndex = 3
    })
    CloseButton.Parent = TopFrame

    -- Tab Buttons Container
    local TabButtonsContainer = CreateElement("Frame", {
        Name = "TabButtons",
        BackgroundColor3 = Color3.fromRGB(37, 40, 47),
        BorderColor3 = Color3.fromRGB(61, 61, 75),
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 35),
        Size = UDim2.new(0, 165, 1, -35),
        ClipsDescendants = true,
        ZIndex = 1
    })
    ApplyCorner(TabButtonsContainer, 6)
    
    -- AntiCorner frames for TabButtonsContainer
    local AntiCornerTop_TabButtons = CreateElement("Frame", {
        Name = "AntiCornerTop",
        BackgroundColor3 = Color3.fromRGB(37, 40, 47),
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 5),
        Position = UDim2.new(0, 0, 0, 0),
        ZIndex = 0
    })
    AntiCornerTop_TabButtons.Parent = TabButtonsContainer
    
    local AntiCornerRight_TabButtons = CreateElement("Frame", {
        Name = "AntiCornerRight",
        BackgroundColor3 = Color3.fromRGB(37, 40, 47),
        BorderSizePixel = 0,
        Size = UDim2.new(0, 2, 1, 0),
        Position = UDim2.new(1, 1, 0, 0),
        ZIndex = 0
    })
    AntiCornerRight_TabButtons.Parent = TabButtonsContainer
    
    local Border_TabButtons = CreateElement("Frame", {
        Name = "Border",
        BackgroundColor3 = Color3.fromRGB(61, 61, 75),
        BorderSizePixel = 0,
        Size = UDim2.new(0, 2, 1, 0),
        Position = UDim2.new(1, 0, 0, 0),
        ZIndex = 2
    })
    Border_TabButtons.Parent = TabButtonsContainer
    TabButtonsContainer.Parent = Window

    -- Tab Buttons List (ScrollingFrame)
    local TabButtonsList = CreateElement("ScrollingFrame", {
        Name = "Lists",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 4,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ElasticBehavior = Enum.ElasticBehavior.Never,
        TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
        BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
        ScrollBarImageColor3 = Color3.fromRGB(99, 106, 122)
    })
    ApplyListLayout(TabButtonsList, 8, nil, nil, Enum.SortOrder.LayoutOrder)
    TabButtonsList.Parent = TabButtonsContainer

    -- Tabs Container
    local TabsContainer = CreateElement("Frame", {
        Name = "Tabs",
        BackgroundColor3 = Color3.fromRGB(32, 35, 41),
        BorderColor3 = Color3.fromRGB(61, 61, 75),
        BorderSizePixel = 0,
        Position = UDim2.new(0, 165, 0, 35),
        Size = UDim2.new(1, -165, 1, -35),
        ZIndex = 1
    })
    ApplyCorner(TabsContainer, 6)
    
    -- AntiCorner frames for TabsContainer
    local AntiCornerLeft_Tabs = CreateElement("Frame", {
        Name = "AntiCornerLeft",
        BackgroundColor3 = Color3.fromRGB(32, 35, 41),
        BorderSizePixel = 0,
        Size = UDim2.new(0, 5, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        Visible = false,
        ZIndex = 0
    })
    AntiCornerLeft_Tabs.Parent = TabsContainer
    
    local AntiCornerTop_Tabs = CreateElement("Frame", {
        Name = "AntiCornerTop",
        BackgroundColor3 = Color3.fromRGB(32, 35, 41),
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 5),
        Position = UDim2.new(0, 0, 0, 0),
        ZIndex = 0
    })
    AntiCornerTop_Tabs.Parent = TabsContainer
    TabsContainer.Parent = Window

    -- Notification Frame
    local NotificationFrame = CreateElement("Frame", {
        Name = "NotificationFrame",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0),
        ClipsDescendants = true,
        ZIndex = 5
    })
    NotificationFrame.Parent = Window
    
    local NotificationList = CreateElement("Frame", {
        Name = "NotificationList",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(1, 0, 0, 35),
        Size = UDim2.new(0, 630, 1, -35),
        ClipsDescendants = true,
        ZIndex = 5
    })
    ApplyListLayout(NotificationList, 12, nil, nil, Enum.SortOrder.LayoutOrder)
    ApplyPadding(NotificationList, 10, 10, 40, 40)
    NotificationList.Parent = NotificationFrame

    -- Dark Overlay (for modals/dropdowns)
    local DarkOverlay = CreateElement("Frame", {
        Name = "DarkOverlay",
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.6,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0),
        Visible = false,
        ZIndex = 3
    })
    ApplyCorner(DarkOverlay, 10)
    DarkOverlay.Parent = Window

    -- Dropdown Selection (Modal)
    local DropdownSelection = CreateElement("Frame", {
        Name = "DropdownSelection",
        BackgroundColor3 = Color3.fromRGB(32, 35, 41),
        BorderColor3 = Color3.fromRGB(61, 61, 75),
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 350, 0, 200),
        Visible = false,
        ClipsDescendants = true,
        ZIndex = 4
    })
    ApplyCorner(DropdownSelection, 6)
    ApplyStroke(DropdownSelection)
    DropdownSelection.Parent = Window

    -- Dropdown Top Bar
    local DropdownTopBar = CreateElement("Frame", {
        Name = "TopBar",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 50),
        ZIndex = 5
    })
    DropdownTopBar.Parent = DropdownSelection
    
    local DropdownTitle = CreateElement("TextLabel", {
        Name = "Title",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Text = "Dropdown Title",
        TextColor3 = Color3.fromRGB(197, 204, 219),
        TextScaled = true,
        TextSize = 18,
        FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
        Size = UDim2.new(0.5, 0, 0, 18),
        Position = UDim2.new(0, 12, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 5
    })
    DropdownTitle.Parent = DropdownTopBar
    
    local DropdownCloseButton = CreateElement("ImageButton", {
        Name = "Close",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 25, 0, 25),
        Position = UDim2.new(1, -12, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        Image = "rbxassetid://132453323679056",
        ImageColor3 = Color3.fromRGB(197, 204, 219),
        ZIndex = 5
    })
    DropdownCloseButton.Parent = DropdownTopBar

    -- Dropdown Options Container (ScrollingFrame)
    local DropdownOptionsContainer = CreateElement("ScrollingFrame", {
        Name = "DropdownOptions",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 50),
        Size = UDim2.new(1, 0, 1, -50),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = 4,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ElasticBehavior = Enum.ElasticBehavior.Never,
        ZIndex = 5
    })
    ApplyListLayout(DropdownOptionsContainer, 5)
    ApplyPadding(DropdownOptionsContainer, 10, 10, 10, 10)
    DropdownOptionsContainer.Parent = DropdownSelection

    -- Window Logic
    MakeDraggable(Window, TopFrame)
    local isHidden = false
    local originalWindowSize = Window.Size
    local isMaximized = false
    local originalWindowPos = Window.Position

    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    HideButton.MouseButton1Click:Connect(function()
        isHidden = not isHidden
        if isHidden then
            originalWindowSize = Window.Size
            Window.Size = UDim2.new(originalWindowSize.X.Scale, originalWindowSize.X.Offset, 0, 35)
            TabButtonsContainer.Visible = false
            TabsContainer.Visible = false
            NotificationFrame.Visible = false
        else
            Window.Size = originalWindowSize
            TabButtonsContainer.Visible = true
            TabsContainer.Visible = true
            NotificationFrame.Visible = true
        end
    end)

    if Window:FindFirstChild("Maximize") then
        Window.Maximize.MouseButton1Click:Connect(function()
            isMaximized = not isMaximized
            if isMaximized then
                originalWindowPos = Window.Position
                originalWindowSize = Window.Size
                Window.Position = UDim2.new(0, 0, 0, 0)
                Window.Size = UDim2.new(1, 0, 1, 0)
            else
                Window.Position = originalWindowPos
                Window.Size = originalWindowSize
            end
        end)
    end

    DropdownCloseButton.MouseButton1Click:Connect(function()
        DropdownSelection.Visible = false
        DarkOverlay.Visible = false
    end)

    DarkOverlay.MouseButton1Click:Connect(function()
        DropdownSelection.Visible = false
        DarkOverlay.Visible = false
    end)

    -- Window Object with Methods
    local WindowObj = {}

    local Tabs = {}
    local ActiveTab = nil

    function WindowObj:AddTab(TabConfig)
        local TabName = TabConfig.Name or "New Tab"
        local TabIcon = TabConfig.Icon or "rbxassetid://113216930555884"

        local NewTabButton = CreateElement("ImageButton", {
            Name = "TabButton",
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 36),
            AutoButtonColor = false,
            ZIndex = 1
        })
        
        local TabButtonIcon = CreateElement("ImageLabel", {
            Name = "Icon",
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(0, 20, 0, 20),
            Position = UDim2.new(0, 12, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            Image = TabIcon,
            ImageColor3 = Color3.fromRGB(197, 204, 219),
            ImageTransparency = 0.5,
            ZIndex = 1
        })
        CreateElement("UIAspectRatioConstraint").Parent = TabButtonIcon
        TabButtonIcon.Parent = NewTabButton
        
        local TabButtonText = CreateElement("TextLabel", {
            Name = "Text",
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Text = TabName,
            TextColor3 = Color3.fromRGB(197, 204, 219),
            TextScaled = true,
            TextSize = 14,
            FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
            Size = UDim2.new(1, -42, 0, 16),
            Position = UDim2.new(0, 42, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTransparency = 0.5,
            ZIndex = 1
        })
        TabButtonText.Parent = NewTabButton
        
        local TabButtonBar = CreateElement("Frame", {
            Name = "Bar",
            BackgroundColor3 = Color3.fromRGB(197, 204, 219),
            BorderSizePixel = 0,
            Size = UDim2.new(0, 5, 0, 25),
            Position = UDim2.new(0, 8, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundTransparency = 1,
            ZIndex = 1
        })
        ApplyCorner(TabButtonBar, 100)
        TabButtonBar.Parent = NewTabButton
        
        NewTabButton.Parent = TabButtonsList

        local NewTabContent = CreateElement("ScrollingFrame", {
            Name = TabName .. "_Content",
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 1, 0),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollBarThickness = 5,
            ScrollingDirection = Enum.ScrollingDirection.Y,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ElasticBehavior = Enum.ElasticBehavior.Never,
            ScrollBarImageColor3 = Color3.fromRGB(99, 106, 122),
            Visible = false,
            ZIndex = 1
        })
        ApplyListLayout(NewTabContent, 15)
        ApplyPadding(NewTabContent, 10, 10, 10, 14)
        NewTabContent.Parent = TabsContainer

        local TabObj = {
            Name = TabName,
            Button = NewTabButton,
            Container = NewTabContent,
            AddButton = function(ButtonConfig)
                ButtonConfig.Parent = NewTabContent
                return CreateButton(ButtonConfig)
            end,
            AddToggle = function(ToggleConfig)
                ToggleConfig.Parent = NewTabContent
                return CreateToggle(ToggleConfig)
            end,
            AddSlider = function(SliderConfig)
                SliderConfig.Parent = NewTabContent
                return CreateSlider(SliderConfig)
            end,
            AddLabel = function(LabelConfig)
                LabelConfig.Parent = NewTabContent
                return CreateLabel(LabelConfig)
            end,
            AddTextBox = function(TextBoxConfig)
                TextBoxConfig.Parent = NewTabContent
                return CreateTextBox(TextBoxConfig)
            end,
            AddDropdown = function(DropdownConfig)
                DropdownConfig.Parent = NewTabContent
                return CreateDropdown(DropdownConfig)
            end
        }

        Tabs[TabName] = TabObj

        NewTabButton.MouseButton1Click:Connect(function()
            if ActiveTab then
                ActiveTab.Container.Visible = false
                ActiveTab.Button.Bar.BackgroundTransparency = 1
                ActiveTab.Button.Icon.ImageTransparency = 0.5
                ActiveTab.Button.Text.TextTransparency = 0.5
            end
            ActiveTab = TabObj
            ActiveTab.Container.Visible = true
            ActiveTab.Button.Bar.BackgroundTransparency = 0
            ActiveTab.Button.Icon.ImageTransparency = 0
            ActiveTab.Button.Text.TextTransparency = 0
        end)

        if not ActiveTab then
            NewTabButton.MouseButton1Click:Fire()
        end

        return TabObj
    end

    function WindowObj:Notify(Config)
        local Notification = CreateElement("Frame", {
            Name = "Notification",
            BackgroundColor3 = Color3.fromRGB(37, 40, 47),
            Size = UDim2.new(0, 300, 0, 60),
            ZIndex = 6
        })
        ApplyCorner(Notification, 6)
        ApplyStroke(Notification)
        
        local NotificationTitle = CreateElement("TextLabel", {
            Text = Config.Title or "Notification",
            Size = UDim2.new(1, -20, 0, 25),
            Position = UDim2.new(0, 10, 0, 5),
            BackgroundTransparency = 1,
            TextColor3 = Color3.fromRGB(197, 204, 219),
            FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            ZIndex = 7
        })
        NotificationTitle.Parent = Notification
        
        local NotificationText = CreateElement("TextLabel", {
            Text = Config.Text or "Notification message",
            Size = UDim2.new(1, -20, 0, 25),
            Position = UDim2.new(0, 10, 0, 30),
            BackgroundTransparency = 1,
            TextColor3 = Color3.fromRGB(197, 204, 219),
            FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Medium, Enum.FontStyle.Normal),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            ZIndex = 7
        })
        NotificationText.Parent = Notification
        
        local NotificationClose = CreateElement("TextButton", {
            Text = "X",
            Size = UDim2.new(0, 20, 0, 20),
            Position = UDim2.new(1, -10, 0, 5),
            BackgroundTransparency = 1,
            TextColor3 = Color3.fromRGB(197, 204, 219),
            FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
            ZIndex = 7
        })
        NotificationClose.Parent = Notification
        
        Notification.Parent = NotificationList
        
        NotificationClose.MouseButton1Click:Connect(function()
            Notification:Destroy()
        end)
        
        if Config.Duration then
            game:GetService("Debris"):AddItem(Notification, Config.Duration)
        end
        
        return Notification
    end

    return WindowObj
end

return Library