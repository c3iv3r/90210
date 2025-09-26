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

-- Tambahan BARU untuk mendukung Tab:Section()
function SectionModule:Section(config)
    -- "self" adalah Tab yang memanggil
    local parent = self.Content or self.Frame or self
    return SectionModule.CreateSection(parent, config)
end

return SectionModule