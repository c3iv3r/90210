local uiElements = {}
uiElements['mainGui'] = Instance.new'ScreenGui'
uiElements['mainGui'].Name = 'NatHub'
uiElements['mainGui'].ZIndexBehavior = Enum.ZIndexBehavior.Sibling
uiElements['mainGui'].ResetOnSpawn = false

local cloneRef = cloneref or function(...)
    return ...
end

if protect_gui then
    protect_gui(uiElements['mainGui'])
elseif gethui then
    uiElements['mainGui'].Parent = gethui()
elseif pcall(function()
    game.CoreGui:GetChildren()
end) then
    uiElements['mainGui'].Parent = cloneRef(game:GetService'CoreGui')
else
    uiElements['mainGui'].Parent = game.Players.LocalPlayer:WaitForChild'PlayerGui'
end

uiElements['mainWindow'] = Instance.new('Frame', uiElements['mainGui'])
uiElements['mainWindow'].ZIndex = 0
uiElements['mainWindow'].BorderSizePixel = 2
uiElements['mainWindow'].BackgroundColor3 = Color3.fromRGB(37, 40, 47)
uiElements['mainWindow'].AnchorPoint = Vector2.new(0.5, 0.5)
uiElements['mainWindow'].Size = UDim2.new(0, 528, 0, 334)
uiElements['mainWindow'].Position = UDim2.new(0.5278, 0, 0.5, 0)
uiElements['mainWindow'].BorderColor3 = Color3.fromRGB(61, 61, 75)
uiElements['mainWindow'].Name = 'Window'

uiElements['mainCorner'] = Instance.new('UICorner', uiElements['mainWindow'])
uiElements['mainCorner'].CornerRadius = UDim.new(0, 10)

uiElements['dropdownSelection'] = Instance.new('Frame', uiElements['mainWindow'])
uiElements['dropdownSelection'].Visible = false
uiElements['dropdownSelection'].ZIndex = 4
uiElements['dropdownSelection'].BorderSizePixel = 0
uiElements['dropdownSelection'].BackgroundColor3 = Color3.fromRGB(32, 35, 41)
uiElements['dropdownSelection'].AnchorPoint = Vector2.new(0.5, 0.5)
uiElements['dropdownSelection'].ClipsDescendants = true
uiElements['dropdownSelection'].Size = UDim2.new(0.7281, 0, 0.68367, 0)
uiElements['dropdownSelection'].Position = UDim2.new(0.5, 0, 0.5, 0)
uiElements['dropdownSelection'].BorderColor3 = Color3.fromRGB(61, 61, 75)
uiElements['dropdownSelection'].Name = 'DropdownSelection'

uiElements['dropdownCorner'] = Instance.new('UICorner', uiElements['dropdownSelection'])
uiElements['dropdownCorner'].CornerRadius = UDim.new(0, 6)

uiElements['dropdownStroke'] = Instance.new('UIStroke', uiElements['dropdownSelection'])
uiElements['dropdownStroke'].ApplyStrokeMode = Enum.ApplyStrokeMode.Border
uiElements['dropdownStroke'].Thickness = 1.5
uiElements['dropdownStroke'].Color = Color3.fromRGB(61, 61, 75)

uiElements['dropdownTopBar'] = Instance.new('Frame', uiElements['dropdownSelection'])
uiElements['dropdownTopBar'].BorderSizePixel = 0
uiElements['dropdownTopBar'].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
uiElements['dropdownTopBar'].Size = UDim2.new(1, 0, 0, 50)
uiElements['dropdownTopBar'].Position = UDim2.new(0, 0, 0, 0)
uiElements['dropdownTopBar'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['dropdownTopBar'].Name = 'TopBar'
uiElements['dropdownTopBar'].BackgroundTransparency = 1

uiElements['dropdownBoxFrame'] = Instance.new('Frame', uiElements['dropdownTopBar'])
uiElements['dropdownBoxFrame'].BorderSizePixel = 0
uiElements['dropdownBoxFrame'].AnchorPoint = Vector2.new(1, 0.5)
uiElements['dropdownBoxFrame'].Size = UDim2.new(0, 120, 0, 25)
uiElements['dropdownBoxFrame'].Position = UDim2.new(1, - 50, 0.5, 0)
uiElements['dropdownBoxFrame'].Name = 'BoxFrame'
uiElements['dropdownBoxFrame'].BackgroundTransparency = 1

uiElements['dropdownShadow'] = Instance.new('ImageLabel', uiElements['dropdownBoxFrame'])
uiElements['dropdownShadow'].ZIndex = 0
uiElements['dropdownShadow'].BorderSizePixel = 0
uiElements['dropdownShadow'].SliceCenter = Rect.new(49, 49, 450, 450)
uiElements['dropdownShadow'].ScaleType = Enum.ScaleType.Slice
uiElements['dropdownShadow'].ImageTransparency = 0.75
uiElements['dropdownShadow'].ImageColor3 = Color3.fromRGB(0, 0, 0)
uiElements['dropdownShadow'].AnchorPoint = Vector2.new(0.5, 0.5)
uiElements['dropdownShadow'].Image = 'rbxassetid://6014261993'
uiElements['dropdownShadow'].Size = UDim2.new(1, 30, 1, 30)
uiElements['dropdownShadow'].BackgroundTransparency = 1
uiElements['dropdownShadow'].Name = 'DropShadow'
uiElements['dropdownShadow'].Position = UDim2.new(0.5, 0, 0.5, 0)

uiElements['dropdownInputFrame'] = Instance.new('Frame', uiElements['dropdownBoxFrame'])
uiElements['dropdownInputFrame'].BorderSizePixel = 0
uiElements['dropdownInputFrame'].BackgroundColor3 = Color3.fromRGB(43, 46, 53)
uiElements['dropdownInputFrame'].AutomaticSize = Enum.AutomaticSize.Y
uiElements['dropdownInputFrame'].Size = UDim2.new(1, 0, 1, 0)
uiElements['dropdownInputFrame'].BorderColor3 = Color3.fromRGB(0, 0, 0)

uiElements['dropdownInputCorner'] = Instance.new('UICorner', uiElements['dropdownInputFrame'])
uiElements['dropdownInputCorner'].CornerRadius = UDim.new(0, 5)

uiElements['dropdownInputStroke'] = Instance.new('UIStroke', uiElements['dropdownInputFrame'])
uiElements['dropdownInputStroke'].ApplyStrokeMode = Enum.ApplyStrokeMode.Border
uiElements['dropdownInputStroke'].Thickness = 1.5
uiElements['dropdownInputStroke'].Color = Color3.fromRGB(61, 61, 75)

uiElements['dropdownInputBox'] = Instance.new('TextBox', uiElements['dropdownInputFrame'])
uiElements['dropdownInputBox'].TextXAlignment = Enum.TextXAlignment.Left
uiElements['dropdownInputBox'].BorderSizePixel = 0
uiElements['dropdownInputBox'].TextWrapped = true
uiElements['dropdownInputBox'].TextTruncate = Enum.TextTruncate.AtEnd
uiElements['dropdownInputBox'].TextSize = 14
uiElements['dropdownInputBox'].TextColor3 = Color3.fromRGB(197, 204, 219)
uiElements['dropdownInputBox'].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
uiElements['dropdownInputBox'].FontFace = Font.new('rbxassetid://11702779517', Enum.FontWeight.Medium, Enum.FontStyle.Normal)
uiElements['dropdownInputBox'].ClipsDescendants = true
uiElements['dropdownInputBox'].PlaceholderText = 'Input here...'
uiElements['dropdownInputBox'].Size = UDim2.new(1, - 25, 1, 0)
uiElements['dropdownInputBox'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['dropdownInputBox'].Text = ''
uiElements['dropdownInputBox'].BackgroundTransparency = 1

uiElements['dropdownInputPadding'] = Instance.new('UIPadding', uiElements['dropdownInputBox'])
uiElements['dropdownInputPadding'].PaddingTop = UDim.new(0, 10)
uiElements['dropdownInputPadding'].PaddingRight = UDim.new(0, 10)
uiElements['dropdownInputPadding'].PaddingLeft = UDim.new(0, 10)
uiElements['dropdownInputPadding'].PaddingBottom = UDim.new(0, 10)

uiElements['dropdownClearButton'] = Instance.new('ImageButton', uiElements['dropdownInputFrame'])
uiElements['dropdownClearButton'].BorderSizePixel = 0
uiElements['dropdownClearButton'].BackgroundTransparency = 1
uiElements['dropdownClearButton'].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
uiElements['dropdownClearButton'].ImageColor3 = Color3.fromRGB(197, 204, 219)
uiElements['dropdownClearButton'].AnchorPoint = Vector2.new(1, 0.5)
uiElements['dropdownClearButton'].Image = 'rbxassetid://86928976705683'
uiElements['dropdownClearButton'].Size = UDim2.new(0, 15, 0, 15)
uiElements['dropdownClearButton'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['dropdownClearButton'].Position = UDim2.new(1, - 5, 0.5, 0)

uiElements['dropdownCloseButton'] = Instance.new('ImageButton', uiElements['dropdownTopBar'])
uiElements['dropdownCloseButton'].BorderSizePixel = 0
uiElements['dropdownCloseButton'].BackgroundTransparency = 1
uiElements['dropdownCloseButton'].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
uiElements['dropdownCloseButton'].ImageColor3 = Color3.fromRGB(197, 204, 219)
uiElements['dropdownCloseButton'].ZIndex = 0
uiElements['dropdownCloseButton'].AnchorPoint = Vector2.new(1, 0.5)
uiElements['dropdownCloseButton'].Image = 'rbxassetid://132453323679056'
uiElements['dropdownCloseButton'].Size = UDim2.new(0, 25, 0, 25)
uiElements['dropdownCloseButton'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['dropdownCloseButton'].Name = 'Close'
uiElements['dropdownCloseButton'].Position = UDim2.new(1, - 12, 0.5, 0)

uiElements['dropdownTitle'] = Instance.new('TextLabel', uiElements['dropdownTopBar'])
uiElements['dropdownTitle'].TextWrapped = true
uiElements['dropdownTitle'].Interactable = false
uiElements['dropdownTitle'].ZIndex = 0
uiElements['dropdownTitle'].BorderSizePixel = 0
uiElements['dropdownTitle'].TextSize = 18
uiElements['dropdownTitle'].TextXAlignment = Enum.TextXAlignment.Left
uiElements['dropdownTitle'].TextScaled = true
uiElements['dropdownTitle'].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
uiElements['dropdownTitle'].FontFace = Font.new('rbxassetid://11702779517', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
uiElements['dropdownTitle'].TextColor3 = Color3.fromRGB(197, 204, 219)
uiElements['dropdownTitle'].BackgroundTransparency = 1
uiElements['dropdownTitle'].AnchorPoint = Vector2.new(0, 0.5)
uiElements['dropdownTitle'].Size = UDim2.new(0.5, 0, 0, 18)
uiElements['dropdownTitle'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['dropdownTitle'].Text = 'Dropdown'
uiElements['dropdownTitle'].Name = 'Title'
uiElements['dropdownTitle'].Position = UDim2.new(0, 12, 0.5, 0)

uiElements['dropdownContainer'] = Instance.new('Folder', uiElements['dropdownSelection'])
uiElements['dropdownContainer'].Name = 'Dropdowns'

uiElements['tabButtonsContainer'] = Instance.new('Frame', uiElements['mainWindow'])
uiElements['tabButtonsContainer'].BorderSizePixel = 0
uiElements['tabButtonsContainer'].BackgroundColor3 = Color3.fromRGB(37, 40, 47)
uiElements['tabButtonsContainer'].ClipsDescendants = true
uiElements['tabButtonsContainer'].Size = UDim2.new(0, 165, 1, - 35)
uiElements['tabButtonsContainer'].Position = UDim2.new(0, 0, 0, 35)
uiElements['tabButtonsContainer'].BorderColor3 = Color3.fromRGB(61, 61, 75)
uiElements['tabButtonsContainer'].Name = 'TabButtons'
uiElements['tabButtonsContainer'].SelectionGroup = true

uiElements['tabScrollingFrame'] = Instance.new('ScrollingFrame', uiElements['tabButtonsContainer'])
uiElements['tabScrollingFrame'].Active = true
uiElements['tabScrollingFrame'].ScrollingDirection = Enum.ScrollingDirection.Y
uiElements['tabScrollingFrame'].BorderSizePixel = 0
uiElements['tabScrollingFrame'].CanvasSize = UDim2.new(0, 0, 0, 0)
uiElements['tabScrollingFrame'].ElasticBehavior = Enum.ElasticBehavior.Never
uiElements['tabScrollingFrame'].TopImage = 'rbxasset://textures/ui/Scroll/scroll-middle.png'
uiElements['tabScrollingFrame'].BackgroundColor3 = Color3.fromRGB(37, 40, 47)
uiElements['tabScrollingFrame'].Name = 'Lists'
uiElements['tabScrollingFrame'].Selectable = false
uiElements['tabScrollingFrame'].BottomImage = 'rbxasset://textures/ui/Scroll/scroll-middle.png'
uiElements['tabScrollingFrame'].AutomaticCanvasSize = Enum.AutomaticSize.Y
uiElements['tabScrollingFrame'].Size = UDim2.new(1, 0, 1, 0)
uiElements['tabScrollingFrame'].BorderColor3 = Color3.fromRGB(61, 61, 75)
uiElements['tabScrollingFrame'].ScrollBarThickness = 4
uiElements['tabScrollingFrame'].BackgroundTransparency = 1

uiElements['tabListLayout'] = Instance.new('UIListLayout', uiElements['tabScrollingFrame'])
uiElements['tabListLayout'].SortOrder = Enum.SortOrder.LayoutOrder

uiElements['tabButtonTemplate'] = Instance.new('Frame', uiElements['tabScrollingFrame'])
uiElements['tabButtonTemplate'].Visible = false
uiElements['tabButtonTemplate'].BorderSizePixel = 0
uiElements['tabButtonTemplate'].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
uiElements['tabButtonTemplate'].Size = UDim2.new(1, 0, 0, 36)
uiElements['tabButtonTemplate'].Position = UDim2.new(- 3.75E-2, 0, 0.38434, 0)
uiElements['tabButtonTemplate'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['tabButtonTemplate'].Name = 'TabButton'
uiElements['tabButtonTemplate'].BackgroundTransparency = 1

uiElements['tabButtonBar'] = Instance.new('Frame', uiElements['tabButtonTemplate'])
uiElements['tabButtonBar'].BorderSizePixel = 0
uiElements['tabButtonBar'].BackgroundColor3 = Color3.fromRGB(197, 204, 219)
uiElements['tabButtonBar'].AnchorPoint = Vector2.new(0, 0.5)
uiElements['tabButtonBar'].Size = UDim2.new(0, 5, 0, 25)
uiElements['tabButtonBar'].Position = UDim2.new(0, 8, 0, 18)
uiElements['tabButtonBar'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['tabButtonBar'].Name = 'Bar'

uiElements['tabButtonGradient'] = Instance.new('UIGradient', uiElements['tabButtonBar'])
uiElements['tabButtonGradient'].Enabled = false
uiElements['tabButtonGradient'].Rotation = 90
uiElements['tabButtonGradient'].Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(110, 212, 255)),
    ColorSequenceKeypoint.new(0.978, Color3.fromRGB(0, 124, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 218, 255))
}

uiElements['tabButtonBarCorner'] = Instance.new('UICorner', uiElements['tabButtonBar'])
uiElements['tabButtonBarCorner'].CornerRadius = UDim.new(0, 100)

uiElements['tabButtonIcon'] = Instance.new('ImageButton', uiElements['tabButtonTemplate'])
uiElements['tabButtonIcon'].BorderSizePixel = 0
uiElements['tabButtonIcon'].BackgroundTransparency = 1
uiElements['tabButtonIcon'].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
uiElements['tabButtonIcon'].ImageColor3 = Color3.fromRGB(197, 204, 219)
uiElements['tabButtonIcon'].AnchorPoint = Vector2.new(0, 0.5)
uiElements['tabButtonIcon'].Image = 'rbxassetid://113216930555884'
uiElements['tabButtonIcon'].Size = UDim2.new(0, 31, 0, 30)
uiElements['tabButtonIcon'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['tabButtonIcon'].Position = UDim2.new(0, 21, 0, 18)

uiElements['tabButtonIconRatio'] = Instance.new('UIAspectRatioConstraint', uiElements['tabButtonIcon'])

uiElements['tabButtonText'] = Instance.new('TextLabel', uiElements['tabButtonTemplate'])
uiElements['tabButtonText'].TextWrapped = true
uiElements['tabButtonText'].BorderSizePixel = 0
uiElements['tabButtonText'].TextSize = 14
uiElements['tabButtonText'].TextXAlignment = Enum.TextXAlignment.Left
uiElements['tabButtonText'].TextScaled = true
uiElements['tabButtonText'].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
uiElements['tabButtonText'].FontFace = Font.new('rbxassetid://11702779517', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
uiElements['tabButtonText'].TextColor3 = Color3.fromRGB(197, 204, 219)
uiElements['tabButtonText'].BackgroundTransparency = 1
uiElements['tabButtonText'].AnchorPoint = Vector2.new(0, 0.5)
uiElements['tabButtonText'].Size = UDim2.new(0, 88, 0, 16)
uiElements['tabButtonText'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['tabButtonText'].Text = 'NatHub'
uiElements['tabButtonText'].Position = UDim2.new(0, 57, 0.5, 0)

uiElements['tabScrollPadding'] = Instance.new('UIPadding', uiElements['tabScrollingFrame'])
uiElements['tabScrollPadding'].PaddingTop = UDim.new(0, 8)

uiElements['tabDivider'] = Instance.new('Frame', uiElements['tabScrollingFrame'])
uiElements['tabDivider'].Visible = false
uiElements['tabDivider'].BorderSizePixel = 0
uiElements['tabDivider'].BackgroundColor3 = Color3.fromRGB(61, 61, 75)
uiElements['tabDivider'].Size = UDim2.new(1, 0, 0, 1)
uiElements['tabDivider'].BorderColor3 = Color3.fromRGB(61, 61, 75)
uiElements['tabDivider'].Name = 'Divider'

uiElements['tabButtonInactive'] = Instance.new('ImageButton', uiElements['tabScrollingFrame'])
uiElements['tabButtonInactive'].Active = false
uiElements['tabButtonInactive'].BorderSizePixel = 0
uiElements['tabButtonInactive'].AutoButtonColor = false
uiElements['tabButtonInactive'].Visible = false
uiElements['tabButtonInactive'].BackgroundTransparency = 1
uiElements['tabButtonInactive'].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
uiElements['tabButtonInactive'].Selectable = false
uiElements['tabButtonInactive'].Size = UDim2.new(1, 0, 0, 36)
uiElements['tabButtonInactive'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['tabButtonInactive'].Name = 'TabButton'

uiElements['tabInactiveIcon'] = Instance.new('ImageButton', uiElements['tabButtonInactive'])
uiElements['tabInactiveIcon'].BorderSizePixel = 0
uiElements['tabInactiveIcon'].ImageTransparency = 0.5
uiElements['tabInactiveIcon'].BackgroundTransparency = 1
uiElements['tabInactiveIcon'].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
uiElements['tabInactiveIcon'].ImageColor3 = Color3.fromRGB(197, 204, 219)
uiElements['tabInactiveIcon'].AnchorPoint = Vector2.new(0, 0.5)
uiElements['tabInactiveIcon'].Image = 'rbxassetid://113216930555884'
uiElements['tabInactiveIcon'].Size = UDim2.new(0, 31, 0, 30)
uiElements['tabInactiveIcon'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['tabInactiveIcon'].Position = UDim2.new(0, 6, 0, 18)

uiElements['tabInactiveIconRatio'] = Instance.new('UIAspectRatioConstraint', uiElements['tabInactiveIcon'])

uiElements['tabInactiveText'] = Instance.new('TextLabel', uiElements['tabButtonInactive'])
uiElements['tabInactiveText'].TextWrapped = true
uiElements['tabInactiveText'].BorderSizePixel = 0
uiElements['tabInactiveText'].TextSize = 14
uiElements['tabInactiveText'].TextXAlignment = Enum.TextXAlignment.Left
uiElements['tabInactiveText'].TextTransparency = 0.5
uiElements['tabInactiveText'].TextScaled = true
uiElements['tabInactiveText'].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
uiElements['tabInactiveText'].FontFace = Font.new('rbxassetid://11702779517', Enum.FontWeight.Medium, Enum.FontStyle.Normal)
uiElements['tabInactiveText'].TextColor3 = Color3.fromRGB(197, 204, 219)
uiElements['tabInactiveText'].BackgroundTransparency = 1
uiElements['tabInactiveText'].AnchorPoint = Vector2.new(0, 0.5)
uiElements['tabInactiveText'].Size = UDim2.new(0, 103, 0, 16)
uiElements['tabInactiveText'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['tabInactiveText'].Text = 'NatHub'
uiElements['tabInactiveText'].Position = UDim2.new(0, 42, 0.5, 0)

uiElements['tabInactiveBar'] = Instance.new('Frame', uiElements['tabButtonInactive'])
uiElements['tabInactiveBar'].BorderSizePixel = 0
uiElements['tabInactiveBar'].BackgroundColor3 = Color3.fromRGB(197, 204, 219)
uiElements['tabInactiveBar'].AnchorPoint = Vector2.new(0, 0.5)
uiElements['tabInactiveBar'].Size = UDim2.new(0, 5, 0, 0)
uiElements['tabInactiveBar'].Position = UDim2.new(0, 8, 0, 18)
uiElements['tabInactiveBar'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['tabInactiveBar'].Name = 'Bar'
uiElements['tabInactiveBar'].BackgroundTransparency = 1

uiElements['tabInactiveBarCorner'] = Instance.new('UICorner', uiElements['tabInactiveBar'])
uiElements['tabInactiveBarCorner'].CornerRadius = UDim.new(0, 100)

uiElements['tabButtonsCorner'] = Instance.new('UICorner', uiElements['tabButtonsContainer'])
uiElements['tabButtonsCorner'].CornerRadius = UDim.new(0, 6)

uiElements['tabAntiCornerTop'] = Instance.new('Frame', uiElements['tabButtonsContainer'])
uiElements['tabAntiCornerTop'].BorderSizePixel = 0
uiElements['tabAntiCornerTop'].BackgroundColor3 = Color3.fromRGB(37, 40, 47)
uiElements['tabAntiCornerTop'].Size = UDim2.new(1, 0, 0, 5)
uiElements['tabAntiCornerTop'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['tabAntiCornerTop'].Name = 'AntiCornerTop'

uiElements['tabAntiCornerRight'] = Instance.new('Frame', uiElements['tabButtonsContainer'])
uiElements['tabAntiCornerRight'].BorderSizePixel = 0
uiElements['tabAntiCornerRight'].BackgroundColor3 = Color3.fromRGB(37, 40, 47)
uiElements['tabAntiCornerRight'].AnchorPoint = Vector2.new(0.5, 0)
uiElements['tabAntiCornerRight'].Size = UDim2.new(0, 2, 1, 0)
uiElements['tabAntiCornerRight'].Position = UDim2.new(1, 1, 0, 0)
uiElements['tabAntiCornerRight'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['tabAntiCornerRight'].Name = 'AntiCornerRight'

uiElements['tabBorder'] = Instance.new('Frame', uiElements['tabButtonsContainer'])
uiElements['tabBorder'].ZIndex = 2
uiElements['tabBorder'].BorderSizePixel = 0
uiElements['tabBorder'].BackgroundColor3 = Color3.fromRGB(61, 61, 75)
uiElements['tabBorder'].AnchorPoint = Vector2.new(1, 0)
uiElements['tabBorder'].Size = UDim2.new(0, 2, 1, 0)
uiElements['tabBorder'].Position = UDim2.new(1, 0, 0, 0)
uiElements['tabBorder'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['tabBorder'].Name = 'Border'

uiElements['topFrame'] = Instance.new('Frame', uiElements['mainWindow'])
uiElements['topFrame'].BorderSizePixel = 0
uiElements['topFrame'].BackgroundColor3 = Color3.fromRGB(37, 40, 47)
uiElements['topFrame'].ClipsDescendants = true
uiElements['topFrame'].Size = UDim2.new(1, 0, 0, 35)
uiElements['topFrame'].BorderColor3 = Color3.fromRGB(61, 61, 75)
uiElements['topFrame'].Name = 'TopFrame'

uiElements['topFrameIcon'] = Instance.new('ImageButton', uiElements['topFrame'])
uiElements['topFrameIcon'].Active = false
uiElements['topFrameIcon'].Interactable = false
uiElements['topFrameIcon'].BorderSizePixel = 0
uiElements['topFrameIcon'].BackgroundTransparency = 1
uiElements['topFrameIcon'].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
uiElements['topFrameIcon'].AnchorPoint = Vector2.new(0, 0.5)
uiElements['topFrameIcon'].Image = 'rbxassetid://113216930555884'
uiElements['topFrameIcon'].Size = UDim2.new(0, 25, 0, 25)
uiElements['topFrameIcon'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['topFrameIcon'].Name = 'Icon'
uiElements['topFrameIcon'].Position = UDim2.new(0, 10, 0.5, 0)

uiElements['topFrameIconRatio'] = Instance.new('UIAspectRatioConstraint', uiElements['topFrameIcon'])

uiElements['topFrameTitle'] = Instance.new('TextLabel', uiElements['topFrame'])
uiElements['topFrameTitle'].TextWrapped = true
uiElements['topFrameTitle'].Interactable = false
uiElements['topFrameTitle'].BorderSizePixel = 0
uiElements['topFrameTitle'].TextSize = 14
uiElements['topFrameTitle'].TextScaled = true
uiElements['topFrameTitle'].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
uiElements['topFrameTitle'].FontFace = Font.new('rbxassetid://11702779517', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
uiElements['topFrameTitle'].TextColor3 = Color3.fromRGB(197, 204, 219)
uiElements['topFrameTitle'].BackgroundTransparency = 1
uiElements['topFrameTitle'].AnchorPoint = Vector2.new(0.5, 0.5)
uiElements['topFrameTitle'].Size = UDim2.new(1, 0, 0, 16)
uiElements['topFrameTitle'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['topFrameTitle'].Text = 'NatHub - v1.2.3'
uiElements['topFrameTitle'].Position = UDim2.new(0.5, 0, 0.5, - 1)

uiElements['topFrameClose'] = Instance.new('ImageButton', uiElements['topFrame'])
uiElements['topFrameClose'].BorderSizePixel = 0
uiElements['topFrameClose'].BackgroundTransparency = 1
uiElements['topFrameClose'].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
uiElements['topFrameClose'].ImageColor3 = Color3.fromRGB(197, 204, 219)
uiElements['topFrameClose'].AnchorPoint = Vector2.new(1, 0.5)
uiElements['topFrameClose'].Image = 'rbxassetid://132453323679056'
uiElements['topFrameClose'].Size = UDim2.new(0, 20, 0, 20)
uiElements['topFrameClose'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['topFrameClose'].Name = 'Close'
uiElements['topFrameClose'].Position = UDim2.new(1, - 15, 0.5, 0)

uiElements['topFrameMaximize'] = Instance.new('ImageButton', uiElements['topFrame'])
uiElements['topFrameMaximize'].BorderSizePixel = 0
uiElements['topFrameMaximize'].BackgroundTransparency = 1
uiElements['topFrameMaximize'].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
uiElements['topFrameMaximize'].ImageColor3 = Color3.fromRGB(197, 204, 219)
uiElements['topFrameMaximize'].AnchorPoint = Vector2.new(1, 0.5)
uiElements['topFrameMaximize'].Image = 'rbxassetid://108285848026510'
uiElements['topFrameMaximize'].Size = UDim2.new(0, 15, 0, 15)
uiElements['topFrameMaximize'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['topFrameMaximize'].Name = 'Maximize'
uiElements['topFrameMaximize'].Position = UDim2.new(1, - 55, 0.5, 0)

uiElements['topFrameMinimize'] = Instance.new('ImageButton', uiElements['topFrame'])
uiElements['topFrameMinimize'].BorderSizePixel = 0
uiElements['topFrameMinimize'].BackgroundTransparency = 1
uiElements['topFrameMinimize'].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
uiElements['topFrameMinimize'].ImageColor3 = Color3.fromRGB(197, 204, 219)
uiElements['topFrameMinimize'].AnchorPoint = Vector2.new(1, 0.5)
uiElements['topFrameMinimize'].Image = 'rbxassetid://128209591224511'
uiElements['topFrameMinimize'].Size = UDim2.new(0, 20, 0, 20)
uiElements['topFrameMinimize'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['topFrameMinimize'].Name = 'Hide'
uiElements['topFrameMinimize'].Position = UDim2.new(1, - 90, 0.5, 0)

uiElements['topFrameCorner'] = Instance.new('UICorner', uiElements['topFrame'])
uiElements['topFrameCorner'].CornerRadius = UDim.new(0, 6)

uiElements['topFrameBorder'] = Instance.new('Frame', uiElements['topFrame'])
uiElements['topFrameBorder'].ZIndex = 2
uiElements['topFrameBorder'].BorderSizePixel = 0
uiElements['topFrameBorder'].BackgroundColor3 = Color3.fromRGB(61, 61, 75)
uiElements['topFrameBorder'].AnchorPoint = Vector2.new(0, 0.5)
uiElements['topFrameBorder'].Size = UDim2.new(1, 0, 0, 2)
uiElements['topFrameBorder'].Position = UDim2.new(0, 0, 1, 0)
uiElements['topFrameBorder'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['topFrameBorder'].Name = 'Border'

uiElements['mainWindowStroke'] = Instance.new('UIStroke', uiElements['mainWindow'])
uiElements['mainWindowStroke'].Transparency = 0.5
uiElements['mainWindowStroke'].ApplyStrokeMode = Enum.ApplyStrokeMode.Border
uiElements['mainWindowStroke'].Color = Color3.fromRGB(95, 95, 117)

uiElements['tabsContainer'] = Instance.new('Frame', uiElements['mainWindow'])
uiElements['tabsContainer'].BorderSizePixel = 0
uiElements['tabsContainer'].BackgroundColor3 = Color3.fromRGB(32, 35, 41)
uiElements['tabsContainer'].Size = UDim2.new(1, - 165, 1, - 35)
uiElements['tabsContainer'].Position = UDim2.new(0, 165, 0, 35)
uiElements['tabsContainer'].BorderColor3 = Color3.fromRGB(61, 61, 75)
uiElements['tabsContainer'].Name = 'Tabs'

uiElements['tabsCorner'] = Instance.new('UICorner', uiElements['tabsContainer'])
uiElements['tabsCorner'].CornerRadius = UDim.new(0, 6)

uiElements['tabsAntiCornerLeft'] = Instance.new('Frame', uiElements['tabsContainer'])
uiElements['tabsAntiCornerLeft'].Visible = false
uiElements['tabsAntiCornerLeft'].BorderSizePixel = 0
uiElements['tabsAntiCornerLeft'].BackgroundColor3 = Color3.fromRGB(32, 35, 41)
uiElements['tabsAntiCornerLeft'].Size = UDim2.new(0, 5, 1, 0)
uiElements['tabsAntiCornerLeft'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['tabsAntiCornerLeft'].Name = 'AntiCornerLeft'

uiElements['tabsAntiCornerTop'] = Instance.new('Frame', uiElements['tabsContainer'])
uiElements['tabsAntiCornerTop'].BorderSizePixel = 0
uiElements['tabsAntiCornerTop'].BackgroundColor3 = Color3.fromRGB(32, 35, 41)
uiElements['tabsAntiCornerTop'].Size = UDim2.new(1, 0, 0, 5)
uiElements['tabsAntiCornerTop'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['tabsAntiCornerTop'].Name = 'AntiCornerTop'

uiElements['noObjectText'] = Instance.new('TextLabel', uiElements['tabsContainer'])
uiElements['noObjectText'].TextWrapped = true
uiElements['noObjectText'].Interactable = false
uiElements['noObjectText'].BorderSizePixel = 0
uiElements['noObjectText'].TextSize = 14
uiElements['noObjectText'].TextScaled = true
uiElements['noObjectText'].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
uiElements['noObjectText'].FontFace = Font.new('rbxassetid://11702779517', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
uiElements['noObjectText'].TextColor3 = Color3.fromRGB(135, 140, 150)
uiElements['noObjectText'].BackgroundTransparency = 1
uiElements['noObjectText'].AnchorPoint = Vector2.new(0.5, 0.5)
uiElements['noObjectText'].Size = UDim2.new(1, 0, 0, 16)
uiElements['noObjectText'].Visible = false
uiElements['noObjectText'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['noObjectText'].Text = 'This tab is empty :('
uiElements['noObjectText'].Name = 'NoObjectFoundText'
uiElements['noObjectText'].Position = UDim2.new(0.5, 0, 0.45, 0)

uiElements['notificationFrame'] = Instance.new('Frame', uiElements['mainWindow'])
uiElements['notificationFrame'].BorderSizePixel = 0
uiElements['notificationFrame'].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
uiElements['notificationFrame'].ClipsDescendants = true
uiElements['notificationFrame'].Size = UDim2.new(1, 0, 1, 0)
uiElements['notificationFrame'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['notificationFrame'].Name = 'NotificationFrame'
uiElements['notificationFrame'].BackgroundTransparency = 1

uiElements['notificationList'] = Instance.new('Frame', uiElements['notificationFrame'])
uiElements['notificationList'].ZIndex = 5
uiElements['notificationList'].BorderSizePixel = 0
uiElements['notificationList'].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
uiElements['notificationList'].AnchorPoint = Vector2.new(0.5, 0)
uiElements['notificationList'].ClipsDescendants = true
uiElements['notificationList'].Size = UDim2.new(0, 630, 1, - 35)
uiElements['notificationList'].Position = UDim2.new(1, 0, 0, 35)
uiElements['notificationList'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['notificationList'].Name = 'NotificationList'
uiElements['notificationList'].BackgroundTransparency = 1

uiElements['notificationListLayout'] = Instance.new('UIListLayout', uiElements['notificationList'])
uiElements['notificationListLayout'].Padding = UDim.new(0, 12)
uiElements['notificationListLayout'].SortOrder = Enum.SortOrder.LayoutOrder

uiElements['notificationListPadding'] = Instance.new('UIPadding', uiElements['notificationList'])
uiElements['notificationListPadding'].PaddingTop = UDim.new(0, 10)
uiElements['notificationListPadding'].PaddingRight = UDim.new(0, 40)
uiElements['notificationListPadding'].PaddingLeft = UDim.new(0, 40)

uiElements['darkOverlay'] = Instance.new('Frame', uiElements['mainWindow'])
uiElements['darkOverlay'].Visible = false
uiElements['darkOverlay'].BorderSizePixel = 0
uiElements['darkOverlay'].BackgroundColor3 = Color3.fromRGB(0, 0, 0)
uiElements['darkOverlay'].Size = UDim2.new(1, 0, 1, 0)
uiElements['darkOverlay'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['darkOverlay'].Name = 'DarkOverlay'
uiElements['darkOverlay'].BackgroundTransparency = 0.6

uiElements['darkOverlayCorner'] = Instance.new('UICorner', uiElements['darkOverlay'])
uiElements['darkOverlayCorner'].CornerRadius = UDim.new(0, 10)

uiElements['libraryModule'] = Instance.new('ModuleScript', uiElements['mainGui'])
uiElements['libraryModule'].Name = 'Library'

uiElements['iconModule'] = Instance.new('ModuleScript', uiElements['libraryModule'])
uiElements['iconModule'].Name = 'IconModule'

uiElements['lucideModule'] = Instance.new('ModuleScript', uiElements['iconModule'])
uiElements['lucideModule'].Name = 'Lucide'

uiElements['templatesFolder'] = Instance.new('Folder', uiElements['mainGui'])
uiElements['templatesFolder'].Name = 'Templates'

uiElements['templateDivider'] = Instance.new('Frame', uiElements['templatesFolder'])
uiElements['templateDivider'].Visible = false
uiElements['templateDivider'].BorderSizePixel = 0
uiElements['templateDivider'].BackgroundColor3 = Color3.fromRGB(61, 61, 75)
uiElements['templateDivider'].Size = UDim2.new(1, 0, 0, 1)
uiElements['templateDivider'].BorderColor3 = Color3.fromRGB(61, 61, 75)
uiElements['templateDivider'].Name = 'Divider'

uiElements['templateTab'] = Instance.new('ScrollingFrame', uiElements['templatesFolder'])
uiElements['templateTab'].Visible = false
uiElements['templateTab'].Active = true
uiElements['templateTab'].ScrollingDirection = Enum.ScrollingDirection.Y
uiElements['templateTab'].BorderSizePixel = 0
uiElements['templateTab'].CanvasSize = UDim2.new(0, 0, 0, 0)
uiElements['templateTab'].ElasticBehavior = Enum.ElasticBehavior.Never
uiElements['templateTab'].TopImage = 'rbxasset://textures/ui/Scroll/scroll-middle.png'
uiElements['templateTab'].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
uiElements['templateTab'].Name = 'Tab'
uiElements['templateTab'].Selectable = false
uiElements['templateTab'].BottomImage = 'rbxasset://textures/ui/Scroll/scroll-middle.png'
uiElements['templateTab'].AutomaticCanvasSize = Enum.AutomaticSize.Y
uiElements['templateTab'].Size = UDim2.new(1, 0, 1, 0)
uiElements['templateTab'].ScrollBarImageColor3 = Color3.fromRGB(99, 106, 122)
uiElements['templateTab'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['templateTab'].ScrollBarThickness = 5
uiElements['templateTab'].BackgroundTransparency = 1

uiElements['templateTabLayout'] = Instance.new('UIListLayout', uiElements['templateTab'])
uiElements['templateTabLayout'].Padding = UDim.new(0, 15)
uiElements['templateTabLayout'].SortOrder = Enum.SortOrder.LayoutOrder

uiElements['templateTabPadding'] = Instance.new('UIPadding', uiElements['templateTab'])
uiElements['templateTabPadding'].PaddingTop = UDim.new(0, 10)
uiElements['templateTabPadding'].PaddingRight = UDim.new(0, 14)
uiElements['templateTabPadding'].PaddingLeft = UDim.new(0, 10)
uiElements['templateTabPadding'].PaddingBottom = UDim.new(0, 10)

uiElements['templateTabButton'] = Instance.new('ImageButton', uiElements['templatesFolder'])
uiElements['templateTabButton'].BorderSizePixel = 0
uiElements['templateTabButton'].AutoButtonColor = false
uiElements['templateTabButton'].Visible = false
uiElements['templateTabButton'].BackgroundTransparency = 1
uiElements['templateTabButton'].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
uiElements['templateTabButton'].Selectable = false
uiElements['templateTabButton'].Size = UDim2.new(1, 0, 0, 36)
uiElements['templateTabButton'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['templateTabButton'].Name = 'TabButton'

uiElements['templateTabButtonIcon'] = Instance.new('ImageButton', uiElements['templateTabButton'])
uiElements['templateTabButtonIcon'].BorderSizePixel = 0
uiElements['templateTabButtonIcon'].ImageTransparency = 0.5
uiElements['templateTabButtonIcon'].BackgroundTransparency = 1
uiElements['templateTabButtonIcon'].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
uiElements['templateTabButtonIcon'].ImageColor3 = Color3.fromRGB(197, 204, 219)
uiElements['templateTabButtonIcon'].AnchorPoint = Vector2.new(0, 0.5)
uiElements['templateTabButtonIcon'].Image = 'rbxassetid://113216930555884'
uiElements['templateTabButtonIcon'].Size = UDim2.new(0, 20, 0, 20)
uiElements['templateTabButtonIcon'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['templateTabButtonIcon'].Position = UDim2.new(0, 12, 0, 18)

uiElements['templateTabButtonIconRatio'] = Instance.new('UIAspectRatioConstraint', uiElements['templateTabButtonIcon'])

uiElements['templateTabButtonText'] = Instance.new('TextLabel', uiElements['templateTabButton'])
uiElements['templateTabButtonText'].TextWrapped = true
uiElements['templateTabButtonText'].BorderSizePixel = 0
uiElements['templateTabButtonText'].TextSize = 14
uiElements['templateTabButtonText'].TextXAlignment = Enum.TextXAlignment.Left
uiElements['templateTabButtonText'].TextTransparency = 0.5
uiElements['templateTabButtonText'].TextScaled = true
uiElements['templateTabButtonText'].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
uiElements['templateTabButtonText'].FontFace = Font.new('rbxassetid://11702779517', Enum.FontWeight.Medium, Enum.FontStyle.Normal)
uiElements['templateTabButtonText'].TextColor3 = Color3.fromRGB(197, 204, 219)
uiElements['templateTabButtonText'].BackgroundTransparency = 1
uiElements['templateTabButtonText'].AnchorPoint = Vector2.new(0, 0.5)
uiElements['templateTabButtonText'].Size = UDim2.new(0, 103, 0, 16)
uiElements['templateTabButtonText'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['templateTabButtonText'].Text = ''
uiElements['templateTabButtonText'].Position = UDim2.new(0, 42, 0.5, 0)

uiElements['templateTabButtonBar'] = Instance.new('Frame', uiElements['templateTabButton'])
uiElements['templateTabButtonBar'].BorderSizePixel = 0
uiElements['templateTabButtonBar'].BackgroundColor3 = Color3.fromRGB(197, 204, 219)
uiElements['templateTabButtonBar'].AnchorPoint = Vector2.new(0, 0.5)
uiElements['templateTabButtonBar'].Size = UDim2.new(0, 5, 0, 0)
uiElements['templateTabButtonBar'].Position = UDim2.new(0, 8, 0, 18)
uiElements['templateTabButtonBar'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['templateTabButtonBar'].Name = 'Bar'
uiElements['templateTabButtonBar'].BackgroundTransparency = 1

uiElements['templateTabButtonBarCorner'] = Instance.new('UICorner', uiElements['templateTabButtonBar'])
uiElements['templateTabButtonBarCorner'].CornerRadius = UDim.new(0, 100)

uiElements['templateButton'] = Instance.new('ImageButton', uiElements['templatesFolder'])
uiElements['templateButton'].BorderSizePixel = 0
uiElements['templateButton'].AutoButtonColor = false
uiElements['templateButton'].Visible = false
uiElements['templateButton'].BackgroundColor3 = Color3.fromRGB(43, 46, 53)
uiElements['templateButton'].Selectable = false
uiElements['templateButton'].AutomaticSize = Enum.AutomaticSize.Y
uiElements['templateButton'].Size = UDim2.new(1, 0, 0, 35)
uiElements['templateButton'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['templateButton'].Name = 'Button'
uiElements['templateButton'].Position = UDim2.new(0, 0, 0.384, 0)

uiElements['templateButtonCorner'] = Instance.new('UICorner', uiElements['templateButton'])
uiElements['templateButtonCorner'].CornerRadius = UDim.new(0, 6)

uiElements['templateButtonContent'] = Instance.new('Frame', uiElements['templateButton'])
uiElements['templateButtonContent'].BorderSizePixel = 0
uiElements['templateButtonContent'].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
uiElements['templateButtonContent'].AutomaticSize = Enum.AutomaticSize.Y
uiElements['templateButtonContent'].Size = UDim2.new(1, 0, 0, 35)
uiElements['templateButtonContent'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['templateButtonContent'].BackgroundTransparency = 1

uiElements['templateButtonLayout'] = Instance.new('UIListLayout', uiElements['templateButtonContent'])
uiElements['templateButtonLayout'].Padding = UDim.new(0, 5)
uiElements['templateButtonLayout'].SortOrder = Enum.SortOrder.LayoutOrder

uiElements['templateButtonPadding'] = Instance.new('UIPadding', uiElements['templateButtonContent'])
uiElements['templateButtonPadding'].PaddingTop = UDim.new(0, 10)
uiElements['templateButtonPadding'].PaddingRight = UDim.new(0, 10)
uiElements['templateButtonPadding'].PaddingLeft = UDim.new(0, 10)
uiElements['templateButtonPadding'].PaddingBottom = UDim.new(0, 10)

uiElements['templateButtonTitle'] = Instance.new('TextLabel', uiElements['templateButtonContent'])
uiElements['templateButtonTitle'].TextWrapped = true
uiElements['templateButtonTitle'].Interactable = false
uiElements['templateButtonTitle'].BorderSizePixel = 0
uiElements['templateButtonTitle'].TextSize = 16
uiElements['templateButtonTitle'].TextXAlignment = Enum.TextXAlignment.Left
uiElements['templateButtonTitle'].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
uiElements['templateButtonTitle'].FontFace = Font.new('rbxassetid://11702779517', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
uiElements['templateButtonTitle'].TextColor3 = Color3.fromRGB(197, 204, 219)
uiElements['templateButtonTitle'].BackgroundTransparency = 1
uiElements['templateButtonTitle'].Size = UDim2.new(1, 0, 0, 15)
uiElements['templateButtonTitle'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['templateButtonTitle'].Text = 'Button'
uiElements['templateButtonTitle'].Name = 'Title'

uiElements['templateButtonClickIcon'] = Instance.new('ImageButton', uiElements['templateButtonTitle'])
uiElements['templateButtonClickIcon'].BorderSizePixel = 0
uiElements['templateButtonClickIcon'].AutoButtonColor = false
uiElements['templateButtonClickIcon'].BackgroundTransparency = 1
uiElements['templateButtonClickIcon'].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
uiElements['templateButtonClickIcon'].ImageColor3 = Color3.fromRGB(197, 204, 219)
uiElements['templateButtonClickIcon'].AnchorPoint = Vector2.new(1, 0.5)
uiElements['templateButtonClickIcon'].Image = 'rbxassetid://91877599529856'
uiElements['templateButtonClickIcon'].Size = UDim2.new(0, 23, 0, 23)
uiElements['templateButtonClickIcon'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['templateButtonClickIcon'].Name = 'ClickIcon'
uiElements['templateButtonClickIcon'].Position = UDim2.new(1, 0, 0.5, 0)

uiElements['templateButtonDescription'] = Instance.new('TextLabel', uiElements['templateButtonContent'])
uiElements['templateButtonDescription'].TextWrapped = true
uiElements['templateButtonDescription'].Interactable = false
uiElements['templateButtonDescription'].BorderSizePixel = 0
uiElements['templateButtonDescription'].TextSize = 16
uiElements['templateButtonDescription'].TextXAlignment = Enum.TextXAlignment.Left
uiElements['templateButtonDescription'].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
uiElements['templateButtonDescription'].FontFace = Font.new('rbxassetid://11702779517', Enum.FontWeight.Medium, Enum.FontStyle.Normal)
uiElements['templateButtonDescription'].TextColor3 = Color3.fromRGB(197, 204, 219)
uiElements['templateButtonDescription'].BackgroundTransparency = 1
uiElements['templateButtonDescription'].Size = UDim2.new(1, 0, 0, 15)
uiElements['templateButtonDescription'].Visible = false
uiElements['templateButtonDescription'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['templateButtonDescription'].Text = [[Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus placerat lacus in enim congue, fermentum euismod leo ultricies. Nulla sodales. ]]
uiElements['templateButtonDescription'].LayoutOrder = 1
uiElements['templateButtonDescription'].AutomaticSize = Enum.AutomaticSize.Y
uiElements['templateButtonDescription'].Name = 'Description'

uiElements['templateButtonGradient1'] = Instance.new('UIGradient', uiElements['templateButtonContent'])
uiElements['templateButtonGradient1'].Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 5, 255)),
    ColorSequenceKeypoint.new(0.16, Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(0.32, Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(0.54, Color3.fromRGB(0, 5, 255)),
    ColorSequenceKeypoint.new(0.782, Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 158, 255))
}

uiElements['templateButtonGradient2'] = Instance.new('UIGradient', uiElements['templateButtonContent'])
uiElements['templateButtonGradient2'].Enabled = false
uiElements['templateButtonGradient2'].Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(0.16, Color3.fromRGB(0, 235, 255)),
    ColorSequenceKeypoint.new(0.32, Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(0.54, Color3.fromRGB(0, 5, 255)),
    ColorSequenceKeypoint.new(0.782, Color3.fromRGB(0, 235, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 158, 255))
}

uiElements['templateButtonGradient3'] = Instance.new('UIGradient', uiElements['templateButtonContent'])
uiElements['templateButtonGradient3'].Enabled = false
uiElements['templateButtonGradient3'].Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(0.16, Color3.fromRGB(0, 5, 255)),
    ColorSequenceKeypoint.new(0.32, Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(0.54, Color3.fromRGB(0, 235, 255)),
    ColorSequenceKeypoint.new(0.782, Color3.fromRGB(0, 5, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 158, 255))
}

uiElements['templateButtonContentCorner'] = Instance.new('UICorner', uiElements['templateButtonContent'])
uiElements['templateButtonContentCorner'].CornerRadius = UDim.new(0, 6)

uiElements['templateButtonStroke'] = Instance.new('UIStroke', uiElements['templateButton'])
uiElements['templateButtonStroke'].ApplyStrokeMode = Enum.ApplyStrokeMode.Border
uiElements['templateButtonStroke'].Thickness = 1.5
uiElements['templateButtonStroke'].Color = Color3.fromRGB(61, 61, 75)

uiElements['templateParagraph'] = Instance.new('Frame', uiElements['templatesFolder'])
uiElements['templateParagraph'].Visible = false
uiElements['templateParagraph'].BorderSizePixel = 0
uiElements['templateParagraph'].BackgroundColor3 = Color3.fromRGB(43, 46, 53)
uiElements['templateParagraph'].AutomaticSize = Enum.AutomaticSize.Y
uiElements['templateParagraph'].Size = UDim2.new(1, 0, 0, 35)
uiElements['templateParagraph'].Position = UDim2.new(- 3.75E-2, 0, 0.38434, 0)
uiElements['templateParagraph'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['templateParagraph'].Name = 'Paragraph'

uiElements['templateParagraphCorner'] = Instance.new('UICorner', uiElements['templateParagraph'])
uiElements['templateParagraphCorner'].CornerRadius = UDim.new(0, 6)

uiElements['templateParagraphStroke'] = Instance.new('UIStroke', uiElements['templateParagraph'])
uiElements['templateParagraphStroke'].ApplyStrokeMode = Enum.ApplyStrokeMode.Border
uiElements['templateParagraphStroke'].Thickness = 1.5
uiElements['templateParagraphStroke'].Color = Color3.fromRGB(61, 61, 75)

uiElements['templateParagraphTitle'] = Instance.new('TextLabel', uiElements['templateParagraph'])
uiElements['templateParagraphTitle'].TextWrapped = true
uiElements['templateParagraphTitle'].Interactable = false
uiElements['templateParagraphTitle'].BorderSizePixel = 0
uiElements['templateParagraphTitle'].TextSize = 16
uiElements['templateParagraphTitle'].TextXAlignment = Enum.TextXAlignment.Left
uiElements['templateParagraphTitle'].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
uiElements['templateParagraphTitle'].FontFace = Font.new('rbxassetid://11702779517', Enum.FontWeight.Bold, Enum.FontStyle.Normal)
uiElements['templateParagraphTitle'].TextColor3 = Color3.fromRGB(197, 204, 219)
uiElements['templateParagraphTitle'].BackgroundTransparency = 1
uiElements['templateParagraphTitle'].Size = UDim2.new(1, 0, 0, 15)
uiElements['templateParagraphTitle'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['templateParagraphTitle'].Text = 'Title'
uiElements['templateParagraphTitle'].AutomaticSize = Enum.AutomaticSize.Y
uiElements['templateParagraphTitle'].Name = 'Title'

uiElements['templateParagraphPadding'] = Instance.new('UIPadding', uiElements['templateParagraph'])
uiElements['templateParagraphPadding'].PaddingTop = UDim.new(0, 10)
uiElements['templateParagraphPadding'].PaddingRight = UDim.new(0, 10)
uiElements['templateParagraphPadding'].PaddingLeft = UDim.new(0, 10)
uiElements['templateParagraphPadding'].PaddingBottom = UDim.new(0, 10)

uiElements['templateParagraphLayout'] = Instance.new('UIListLayout', uiElements['templateParagraph'])
uiElements['templateParagraphLayout'].Padding = UDim.new(0, 5)
uiElements['templateParagraphLayout'].SortOrder = Enum.SortOrder.LayoutOrder

uiElements['templateParagraphDescription'] = Instance.new('TextLabel', uiElements['templateParagraph'])
uiElements['templateParagraphDescription'].TextWrapped = true
uiElements['templateParagraphDescription'].Interactable = false
uiElements['templateParagraphDescription'].BorderSizePixel = 0
uiElements['templateParagraphDescription'].TextSize = 16
uiElements['templateParagraphDescription'].TextXAlignment = Enum.TextXAlignment.Left
uiElements['templateParagraphDescription'].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
uiElements['templateParagraphDescription'].FontFace = Font.new('rbxassetid://11702779517', Enum.FontWeight.Medium, Enum.FontStyle.Normal)
uiElements['templateParagraphDescription'].TextColor3 = Color3.fromRGB(197, 204, 219)
uiElements['templateParagraphDescription'].BackgroundTransparency = 1
uiElements['templateParagraphDescription'].Size = UDim2.new(1, 0, 0, 15)
uiElements['templateParagraphDescription'].Visible = false
uiElements['templateParagraphDescription'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['templateParagraphDescription'].Text = [[Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus placerat lacus in enim congue, fermentum euismod leo ultricies. Nulla sodales. ]]
uiElements['templateParagraphDescription'].LayoutOrder = 1
uiElements['templateParagraphDescription'].AutomaticSize = Enum.AutomaticSize.Y
uiElements['templateParagraphDescription'].Name = 'Description'

uiElements['templateToggle'] = Instance.new('ImageButton', uiElements['templatesFolder'])
uiElements['templateToggle'].BorderSizePixel = 0
uiElements['templateToggle'].AutoButtonColor = false
uiElements['templateToggle'].Visible = false
uiElements['templateToggle'].BackgroundColor3 = Color3.fromRGB(43, 46, 53)
uiElements['templateToggle'].Selectable = false
uiElements['templateToggle'].AutomaticSize = Enum.AutomaticSize.Y
uiElements['templateToggle'].Size = UDim2.new(1, 0, 0, 35)
uiElements['templateToggle'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['templateToggle'].Name = 'Toggle'
uiElements['templateToggle'].Position = UDim2.new(- 3.75E-2, 0, 0.38434, 0)

uiElements['templateToggleCorner'] = Instance.new('UICorner', uiElements['templateToggle'])
uiElements['templateToggleCorner'].CornerRadius = UDim.new(0, 6)

uiElements['templateToggleStroke'] = Instance.new('UIStroke', uiElements['templateToggle'])
uiElements['templateToggleStroke'].ApplyStrokeMode = Enum.ApplyStrokeMode.Border
uiElements['templateToggleStroke'].Thickness = 1.5
uiElements['templateToggleStroke'].Color = Color3.fromRGB(61, 61, 75)

uiElements['templateTogglePadding'] = Instance.new('UIPadding', uiElements['templateToggle'])
uiElements['templateTogglePadding'].PaddingTop = UDim.new(0, 10)
uiElements['templateTogglePadding'].PaddingRight = UDim.new(0, 10)
uiElements['templateTogglePadding'].PaddingLeft = UDim.new(0, 10)
uiElements['templateTogglePadding'].PaddingBottom = UDim.new(0, 10)

uiElements['templateToggleLayout'] = Instance.new('UIListLayout', uiElements['templateToggle'])
uiElements['templateToggleLayout'].Padding = UDim.new(0, 5)
uiElements['templateToggleLayout'].SortOrder = Enum.SortOrder.LayoutOrder

uiElements['templateToggleDescription'] = Instance.new('TextLabel', uiElements['templateToggle'])
uiElements['templateToggleDescription'].TextWrapped = true
uiElements['templateToggleDescription'].Interactable = false
uiElements['templateToggleDescription'].BorderSizePixel = 0
uiElements['templateToggleDescription'].TextSize = 16
uiElements['templateToggleDescription'].TextXAlignment = Enum.TextXAlignment.Left
uiElements['templateToggleDescription'].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
uiElements['templateToggleDescription'].FontFace = Font.new('rbxassetid://11702779517', Enum.FontWeight.Medium, Enum.FontStyle.Normal)
uiElements['templateToggleDescription'].TextColor3 = Color3.fromRGB(197, 204, 219)
uiElements['templateToggleDescription'].BackgroundTransparency = 1
uiElements['templateToggleDescription'].Size = UDim2.new(1, 0, 0, 15)
uiElements['templateToggleDescription'].Visible = false
uiElements['templateToggleDescription'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['templateToggleDescription'].Text = [[Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus placerat lacus in enim congue, fermentum euismod leo ultricies. Nulla sodales. ]]
uiElements['templateToggleDescription'].LayoutOrder = 1
uiElements['templateToggleDescription'].AutomaticSize = Enum.AutomaticSize.Y
uiElements['templateToggleDescription'].Name = 'Description'

uiElements['templateToggleTitle'] = Instance.new('TextLabel', uiElements['templateToggle'])
uiElements['templateToggleTitle'].TextWrapped = true
uiElements['templateToggleTitle'].BorderSizePixel = 0
uiElements['templateToggleTitle'].TextSize = 16
uiElements['templateToggleTitle'].TextXAlignment = Enum.TextXAlignment.Left
uiElements['templateToggleTitle'].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
uiElements['templateToggleTitle'].FontFace = Font.new('rbxassetid://11702779517', Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
uiElements['templateToggleTitle'].TextColor3 = Color3.fromRGB(197, 204, 219)
uiElements['templateToggleTitle'].BackgroundTransparency = 1
uiElements['templateToggleTitle'].Size = UDim2.new(1, 0, 0, 15)
uiElements['templateToggleTitle'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['templateToggleTitle'].Text = 'Toggle'
uiElements['templateToggleTitle'].Name = 'Title'

uiElements['templateToggleFill'] = Instance.new('ImageButton', uiElements['templateToggleTitle'])
uiElements['templateToggleFill'].BorderSizePixel = 0
uiElements['templateToggleFill'].AutoButtonColor = false
uiElements['templateToggleFill'].BackgroundColor3 = Color3.fromRGB(54, 57, 63)
uiElements['templateToggleFill'].ImageColor3 = Color3.fromRGB(197, 204, 219)
uiElements['templateToggleFill'].AnchorPoint = Vector2.new(1, 0.5)
uiElements['templateToggleFill'].Size = UDim2.new(0, 45, 0, 25)
uiElements['templateToggleFill'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['templateToggleFill'].Name = 'Fill'
uiElements['templateToggleFill'].Position = UDim2.new(1, 0, 0.5, 0)

uiElements['templateToggleFillCorner'] = Instance.new('UICorner', uiElements['templateToggleFill'])
uiElements['templateToggleFillCorner'].CornerRadius = UDim.new(100, 0)

uiElements['templateToggleBall'] = Instance.new('ImageButton', uiElements['templateToggleFill'])
uiElements['templateToggleBall'].Active = false
uiElements['templateToggleBall'].Interactable = false
uiElements['templateToggleBall'].BorderSizePixel = 0
uiElements['templateToggleBall'].AutoButtonColor = false
uiElements['templateToggleBall'].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
uiElements['templateToggleBall'].ImageColor3 = Color3.fromRGB(197, 204, 219)
uiElements['templateToggleBall'].AnchorPoint = Vector2.new(0, 0.5)
uiElements['templateToggleBall'].Size = UDim2.new(0, 20, 0, 20)
uiElements['templateToggleBall'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['templateToggleBall'].Name = 'Ball'
uiElements['templateToggleBall'].Position = UDim2.new(0, 0, 0.5, 0)

uiElements['templateToggleBallCorner'] = Instance.new('UICorner', uiElements['templateToggleBall'])
uiElements['templateToggleBallCorner'].CornerRadius = UDim.new(100, 0)

uiElements['templateToggleBallIcon'] = Instance.new('ImageLabel', uiElements['templateToggleBall'])
uiElements['templateToggleBallIcon'].BorderSizePixel = 0
uiElements['templateToggleBallIcon'].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
uiElements['templateToggleBallIcon'].ImageColor3 = Color3.fromRGB(54, 57, 63)
uiElements['templateToggleBallIcon'].AnchorPoint = Vector2.new(0.5, 0.5)
uiElements['templateToggleBallIcon'].Size = UDim2.new(1, - 5, 1, - 5)
uiElements['templateToggleBallIcon'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['templateToggleBallIcon'].BackgroundTransparency = 1
uiElements['templateToggleBallIcon'].Name = 'Icon'
uiElements['templateToggleBallIcon'].Position = UDim2.new(0.5, 0, 0.5, 0)

uiElements['templateToggleFillPadding'] = Instance.new('UIPadding', uiElements['templateToggleFill'])
uiElements['templateToggleFillPadding'].PaddingTop = UDim.new(0, 2)
uiElements['templateToggleFillPadding'].PaddingRight = UDim.new(0, 2)
uiElements['templateToggleFillPadding'].PaddingLeft = UDim.new(0, 2)
uiElements['templateToggleFillPadding'].PaddingBottom = UDim.new(0, 2)

uiElements['templateNotification'] = Instance.new('Frame', uiElements['templatesFolder'])
uiElements['templateNotification'].Visible = false
uiElements['templateNotification'].BorderSizePixel = 0
uiElements['templateNotification'].BackgroundColor3 = Color3.fromRGB(37, 40, 47)
uiElements['templateNotification'].AnchorPoint = Vector2.new(0.5, 0.5)
uiElements['templateNotification'].AutomaticSize = Enum.AutomaticSize.Y
uiElements['templateNotification'].Size = UDim2.new(1, 0, 0, 65)
uiElements['templateNotification'].Position = UDim2.new(0.8244, 0, 0.88221, 0)
uiElements['templateNotification'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['templateNotification'].Name = 'Notification'
uiElements['templateNotification'].BackgroundTransparency = 1

uiElements['templateNotificationItems'] = Instance.new('CanvasGroup', uiElements['templateNotification'])
uiElements['templateNotificationItems'].ZIndex = 2
uiElements['templateNotificationItems'].BorderSizePixel = 0
uiElements['templateNotificationItems'].BackgroundColor3 = Color3.fromRGB(37, 40, 47)
uiElements['templateNotificationItems'].AutomaticSize = Enum.AutomaticSize.Y
uiElements['templateNotificationItems'].Size = UDim2.new(0, 265, 0, 70)
uiElements['templateNotificationItems'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['templateNotificationItems'].Name = 'Items'

uiElements['templateNotificationContent'] = Instance.new('Frame', uiElements['templateNotificationItems'])
uiElements['templateNotificationContent'].BorderSizePixel = 0
uiElements['templateNotificationContent'].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
uiElements['templateNotificationContent'].AutomaticSize = Enum.AutomaticSize.Y
uiElements['templateNotificationContent'].Size = UDim2.new(0, 265, 0, 70)
uiElements['templateNotificationContent'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['templateNotificationContent'].BackgroundTransparency = 1

uiElements['templateNotificationLayout'] = Instance.new('UIListLayout', uiElements['templateNotificationContent'])
uiElements['templateNotificationLayout'].Padding = UDim.new(0, 5)
uiElements['templateNotificationLayout'].VerticalAlignment = Enum.VerticalAlignment.Center
uiElements['templateNotificationLayout'].SortOrder = Enum.SortOrder.LayoutOrder

uiElements['templateNotificationPadding'] = Instance.new('UIPadding', uiElements['templateNotificationContent'])
uiElements['templateNotificationPadding'].PaddingTop = UDim.new(0, 15)
uiElements['templateNotificationPadding'].PaddingLeft = UDim.new(0, 15)
uiElements['templateNotificationPadding'].PaddingBottom = UDim.new(0, 15)

uiElements['templateNotificationSubContent'] = Instance.new('TextLabel', uiElements['templateNotificationContent'])
uiElements['templateNotificationSubContent'].TextWrapped = true
uiElements['templateNotificationSubContent'].BorderSizePixel = 0
uiElements['templateNotificationSubContent'].TextSize = 12
uiElements['templateNotificationSubContent'].TextXAlignment = Enum.TextXAlignment.Left
uiElements['templateNotificationSubContent'].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
uiElements['templateNotificationSubContent'].FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.Regular, Enum.FontStyle.Normal)
uiElements['templateNotificationSubContent'].TextColor3 = Color3.fromRGB(181, 181, 181)
uiElements['templateNotificationSubContent'].BackgroundTransparency = 1
uiElements['templateNotificationSubContent'].AnchorPoint = Vector2.new(0, 0.5)
uiElements['templateNotificationSubContent'].Size = UDim2.new(0, 218, 0, 10)
uiElements['templateNotificationSubContent'].Visible = false
uiElements['templateNotificationSubContent'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['templateNotificationSubContent'].Text = 'This is a notification'
uiElements['templateNotificationSubContent'].LayoutOrder = 1
uiElements['templateNotificationSubContent'].AutomaticSize = Enum.AutomaticSize.Y
uiElements['templateNotificationSubContent'].Name = 'SubContent'
uiElements['templateNotificationSubContent'].Position = UDim2.new(0, 0, 0, 19)

uiElements['templateNotificationSubGradient'] = Instance.new('UIGradient', uiElements['templateNotificationSubContent'])
uiElements['templateNotificationSubGradient'].Enabled = false
uiElements['templateNotificationSubGradient'].Rotation = - 90
uiElements['templateNotificationSubGradient'].Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(3, 100, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 226))
}

uiElements['templateNotificationTitle'] = Instance.new('TextLabel', uiElements['templateNotificationContent'])
uiElements['templateNotificationTitle'].TextWrapped = true
uiElements['templateNotificationTitle'].BorderSizePixel = 0
uiElements['templateNotificationTitle'].TextSize = 16
uiElements['templateNotificationTitle'].TextXAlignment = Enum.TextXAlignment.Left
uiElements['templateNotificationTitle'].TextScaled = true
uiElements['templateNotificationTitle'].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
uiElements['templateNotificationTitle'].FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.Bold, Enum.FontStyle.Normal)
uiElements['templateNotificationTitle'].TextColor3 = Color3.fromRGB(197, 204, 219)
uiElements['templateNotificationTitle'].BackgroundTransparency = 1
uiElements['templateNotificationTitle'].AnchorPoint = Vector2.new(0, 0.5)
uiElements['templateNotificationTitle'].Size = UDim2.new(0, 235, 0, 18)
uiElements['templateNotificationTitle'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['templateNotificationTitle'].Text = 'Title'
uiElements['templateNotificationTitle'].Name = 'Title'
uiElements['templateNotificationTitle'].Position = UDim2.new(0, 0, 0, 9)

uiElements['templateNotificationClose'] = Instance.new('ImageButton', uiElements['templateNotificationTitle'])
uiElements['templateNotificationClose'].BorderSizePixel = 0
uiElements['templateNotificationClose'].BackgroundTransparency = 1
uiElements['templateNotificationClose'].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
uiElements['templateNotificationClose'].ImageColor3 = Color3.fromRGB(197, 204, 219)
uiElements['templateNotificationClose'].AnchorPoint = Vector2.new(0, 0.5)
uiElements['templateNotificationClose'].Image = 'rbxassetid://132453323679056'
uiElements['templateNotificationClose'].Size = UDim2.new(0.09706, 0, 1.33333, 0)
uiElements['templateNotificationClose'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['templateNotificationClose'].Name = 'Close'
uiElements['templateNotificationClose'].Position = UDim2.new(0.92, 0, 0.5, 0)

uiElements['templateNotificationCloseRatio'] = Instance.new('UIAspectRatioConstraint', uiElements['templateNotificationClose'])

uiElements['templateNotificationTitlePadding'] = Instance.new('UIPadding', uiElements['templateNotificationTitle'])
uiElements['templateNotificationTitlePadding'].PaddingLeft = UDim.new(0, 30)

uiElements['templateNotificationIcon'] = Instance.new('ImageButton', uiElements['templateNotificationTitle'])
uiElements['templateNotificationIcon'].BorderSizePixel = 0
uiElements['templateNotificationIcon'].BackgroundTransparency = 1
uiElements['templateNotificationIcon'].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
uiElements['templateNotificationIcon'].ImageColor3 = Color3.fromRGB(197, 204, 219)
uiElements['templateNotificationIcon'].AnchorPoint = Vector2.new(0, 0.5)
uiElements['templateNotificationIcon'].Image = 'rbxassetid://92049322344253'
uiElements['templateNotificationIcon'].Size = UDim2.new(0.09706, 0, 1.33333, 0)
uiElements['templateNotificationIcon'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['templateNotificationIcon'].Name = 'Icon'
uiElements['templateNotificationIcon'].Position = UDim2.new(0, - 30, 0.5, 0)

uiElements['templateNotificationIconRatio'] = Instance.new('UIAspectRatioConstraint', uiElements['templateNotificationIcon'])

uiElements['templateNotificationContentText'] = Instance.new('TextLabel', uiElements['templateNotificationContent'])
uiElements['templateNotificationContentText'].TextWrapped = true
uiElements['templateNotificationContentText'].BorderSizePixel = 0
uiElements['templateNotificationContentText'].TextSize = 16
uiElements['templateNotificationContentText'].TextXAlignment = Enum.TextXAlignment.Left
uiElements['templateNotificationContentText'].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
uiElements['templateNotificationContentText'].FontFace = Font.new('rbxasset://fonts/families/GothamSSm.json', Enum.FontWeight.Medium, Enum.FontStyle.Normal)
uiElements['templateNotificationContentText'].TextColor3 = Color3.fromRGB(197, 204, 219)
uiElements['templateNotificationContentText'].BackgroundTransparency = 1
uiElements['templateNotificationContentText'].AnchorPoint = Vector2.new(0, 0.5)
uiElements['templateNotificationContentText'].Size = UDim2.new(0, 218, 0, 10)
uiElements['templateNotificationContentText'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['templateNotificationContentText'].Text = 'Content'
uiElements['templateNotificationContentText'].LayoutOrder = 2
uiElements['templateNotificationContentText'].AutomaticSize = Enum.AutomaticSize.Y
uiElements['templateNotificationContentText'].Name = 'Content'
uiElements['templateNotificationContentText'].Position = UDim2.new(0, 0, 0, 19)

uiElements['templateNotificationContentGradient'] = Instance.new('UIGradient', uiElements['templateNotificationContentText'])
uiElements['templateNotificationContentGradient'].Enabled = false
uiElements['templateNotificationContentGradient'].Rotation = - 90
uiElements['templateNotificationContentGradient'].Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(3, 100, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 226))
}

uiElements['templateNotificationTimerBar'] = Instance.new('Frame', uiElements['templateNotificationItems'])
uiElements['templateNotificationTimerBar'].BorderSizePixel = 0
uiElements['templateNotificationTimerBar'].BackgroundColor3 = Color3.fromRGB(61, 61, 75)
uiElements['templateNotificationTimerBar'].AnchorPoint = Vector2.new(0, 1)
uiElements['templateNotificationTimerBar'].Size = UDim2.new(1, 0, 0, 5)
uiElements['templateNotificationTimerBar'].Position = UDim2.new(0, 0, 1, 0)
uiElements['templateNotificationTimerBar'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['templateNotificationTimerBar'].Name = 'TimerBarFill'
uiElements['templateNotificationTimerBar'].BackgroundTransparency = 0.7

uiElements['templateNotificationTimerBarCorner'] = Instance.new('UICorner', uiElements['templateNotificationTimerBar'])

uiElements['templateNotificationTimerBarInner'] = Instance.new('Frame', uiElements['templateNotificationTimerBar'])
uiElements['templateNotificationTimerBarInner'].BorderSizePixel = 0
uiElements['templateNotificationTimerBarInner'].BackgroundColor3 = Color3.fromRGB(61, 61, 75)
uiElements['templateNotificationTimerBarInner'].Size = UDim2.new(1, 0, 1, 0)
uiElements['templateNotificationTimerBarInner'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['templateNotificationTimerBarInner'].Name = 'Bar'

uiElements['templateNotificationTimerBarInnerCorner'] = Instance.new('UICorner', uiElements['templateNotificationTimerBarInner'])

uiElements['templateNotificationStroke'] = Instance.new('UIStroke', uiElements['templateNotificationItems'])
uiElements['templateNotificationStroke'].ApplyStrokeMode = Enum.ApplyStrokeMode.Border
uiElements['templateNotificationStroke'].Thickness = 1.5
uiElements['templateNotificationStroke'].Color = Color3.fromRGB(61, 61, 75)

uiElements['templateNotificationCorner'] = Instance.new('UICorner', uiElements['templateNotificationItems'])

uiElements['templateSlider'] = Instance.new('Frame', uiElements['templatesFolder'])
uiElements['templateSlider'].Visible = false
uiElements['templateSlider'].BorderSizePixel = 0
uiElements['templateSlider'].BackgroundColor3 = Color3.fromRGB(43, 46, 53)
uiElements['templateSlider'].AutomaticSize = Enum.AutomaticSize.Y
uiElements['templateSlider'].Size = UDim2.new(1, 0, 0, 35)
uiElements['templateSlider'].Position = UDim2.new(- 3.75E-2, 0, 0.38434, 0)
uiElements['templateSlider'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['templateSlider'].Name = 'Slider'

uiElements['templateSliderCorner'] = Instance.new('UICorner', uiElements['templateSlider'])
uiElements['templateSliderCorner'].CornerRadius = UDim.new(0, 6)

uiElements['templateSliderStroke'] = Instance.new('UIStroke', uiElements['templateSlider'])
uiElements['templateSliderStroke'].ApplyStrokeMode = Enum.ApplyStrokeMode.Border
uiElements['templateSliderStroke'].Thickness = 1.5
uiElements['templateSliderStroke'].Color = Color3.fromRGB(61, 61, 75)

uiElements['templateSliderTitle'] = Instance.new('TextLabel', uiElements['templateSlider'])
uiElements['templateSliderTitle'].TextWrapped = true
uiElements['templateSliderTitle'].Interactable = false
uiElements['templateSliderTitle'].BorderSizePixel = 0
uiElements['templateSliderTitle'].TextSize = 16
uiElements['templateSliderTitle'].TextXAlignment = Enum.TextXAlignment.Left
uiElements['templateSliderTitle'].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
uiElements['templateSliderTitle'].FontFace = Font.new('rbxassetid://11702779517', Enum.FontWeight.Bold, Enum.FontStyle.Normal)
uiElements['templateSliderTitle'].TextColor3 = Color3.fromRGB(197, 204, 219)
uiElements['templateSliderTitle'].BackgroundTransparency = 1
uiElements['templateSliderTitle'].Size = UDim2.new(1, 0, 0, 15)
uiElements['templateSliderTitle'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['templateSliderTitle'].Text = 'Slider'
uiElements['templateSliderTitle'].AutomaticSize = Enum.AutomaticSize.Y
uiElements['templateSliderTitle'].Name = 'Title'

uiElements['templateSliderPadding'] = Instance.new('UIPadding', uiElements['templateSlider'])
uiElements['templateSliderPadding'].PaddingTop = UDim.new(0, 10)
uiElements['templateSliderPadding'].PaddingRight = UDim.new(0, 10)
uiElements['templateSliderPadding'].PaddingLeft = UDim.new(0, 10)
uiElements['templateSliderPadding'].PaddingBottom = UDim.new(0, 10)

uiElements['templateSliderLayout'] = Instance.new('UIListLayout', uiElements['templateSlider'])
uiElements['templateSliderLayout'].Padding = UDim.new(0, 5)
uiElements['templateSliderLayout'].SortOrder = Enum.SortOrder.LayoutOrder

uiElements['templateSliderDescription'] = Instance.new('TextLabel', uiElements['templateSlider'])
uiElements['templateSliderDescription'].TextWrapped = true
uiElements['templateSliderDescription'].Interactable = false
uiElements['templateSliderDescription'].BorderSizePixel = 0
uiElements['templateSliderDescription'].TextSize = 16
uiElements['templateSliderDescription'].TextXAlignment = Enum.TextXAlignment.Left
uiElements['templateSliderDescription'].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
uiElements['templateSliderDescription'].FontFace = Font.new('rbxassetid://11702779517', Enum.FontWeight.Medium, Enum.FontStyle.Normal)
uiElements['templateSliderDescription'].TextColor3 = Color3.fromRGB(197, 204, 219)
uiElements['templateSliderDescription'].BackgroundTransparency = 1
uiElements['templateSliderDescription'].Size = UDim2.new(1, 0, 0, 15)
uiElements['templateSliderDescription'].Visible = false
uiElements['templateSliderDescription'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['templateSliderDescription'].Text = [[Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus placerat lacus in enim congue, fermentum euismod leo ultricies. Nulla sodales. ]]
uiElements['templateSliderDescription'].LayoutOrder = 1
uiElements['templateSliderDescription'].AutomaticSize = Enum.AutomaticSize.Y
uiElements['templateSliderDescription'].Name = 'Description'

uiElements['templateSliderFrame'] = Instance.new('Frame', uiElements['templateSlider'])
uiElements['templateSliderFrame'].ZIndex = 0
uiElements['templateSliderFrame'].BorderSizePixel = 0
uiElements['templateSliderFrame'].Size = UDim2.new(1, 0, 0, 25)
uiElements['templateSliderFrame'].Name = 'SliderFrame'
uiElements['templateSliderFrame'].LayoutOrder = 2
uiElements['templateSliderFrame'].BackgroundTransparency = 1

uiElements['templateSliderTrack'] = Instance.new('Frame', uiElements['templateSliderFrame'])
uiElements['templateSliderTrack'].ZIndex = 0
uiElements['templateSliderTrack'].BorderSizePixel = 0
uiElements['templateSliderTrack'].AnchorPoint = Vector2.new(0, 0.5)
uiElements['templateSliderTrack'].Size = UDim2.new(1, 0, 0, 20)
uiElements['templateSliderTrack'].Position = UDim2.new(0, 0, 0.5, 0)
uiElements['templateSliderTrack'].BackgroundTransparency = 1

uiElements['templateSliderShadow'] = Instance.new('ImageLabel', uiElements['templateSliderTrack'])
uiElements['templateSliderShadow'].ZIndex = 0
uiElements['templateSliderShadow'].BorderSizePixel = 0
uiElements['templateSliderShadow'].SliceCenter = Rect.new(49, 49, 450, 450)
uiElements['templateSliderShadow'].ScaleType = Enum.ScaleType.Slice
uiElements['templateSliderShadow'].ImageTransparency = 0.75
uiElements['templateSliderShadow'].ImageColor3 = Color3.fromRGB(0, 0, 0)
uiElements['templateSliderShadow'].AnchorPoint = Vector2.new(0.5, 0.5)
uiElements['templateSliderShadow'].Image = 'rbxassetid://6014261993'
uiElements['templateSliderShadow'].Size = UDim2.new(1, 25, 1, 25)
uiElements['templateSliderShadow'].BackgroundTransparency = 1
uiElements['templateSliderShadow'].Name = 'DropShadow'
uiElements['templateSliderShadow'].Position = UDim2.new(0.5, 0, 0.5, 0)

uiElements['templateSliderCanvas'] = Instance.new('CanvasGroup', uiElements['templateSliderTrack'])
uiElements['templateSliderCanvas'].BorderSizePixel = 0
uiElements['templateSliderCanvas'].BackgroundColor3 = Color3.fromRGB(43, 46, 53)
uiElements['templateSliderCanvas'].Size = UDim2.new(1, 0, 1, 0)
uiElements['templateSliderCanvas'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['templateSliderCanvas'].Name = 'Slider'

uiElements['templateSliderCanvasCorner'] = Instance.new('UICorner', uiElements['templateSliderCanvas'])
uiElements['templateSliderCanvasCorner'].CornerRadius = UDim.new(0, 5)

uiElements['templateSliderCanvasStroke'] = Instance.new('UIStroke', uiElements['templateSliderCanvas'])
uiElements['templateSliderCanvasStroke'].ApplyStrokeMode = Enum.ApplyStrokeMode.Border
uiElements['templateSliderCanvasStroke'].Thickness = 1.5
uiElements['templateSliderCanvasStroke'].Color = Color3.fromRGB(61, 61, 75)

uiElements['templateSliderCanvasPadding'] = Instance.new('UIPadding', uiElements['templateSliderCanvas'])
uiElements['templateSliderCanvasPadding'].PaddingTop = UDim.new(0, 2)
uiElements['templateSliderCanvasPadding'].PaddingRight = UDim.new(0, 2)
uiElements['templateSliderCanvasPadding'].PaddingLeft = UDim.new(0, 2)
uiElements['templateSliderCanvasPadding'].PaddingBottom = UDim.new(0, 2)

uiElements['templateSliderTrigger'] = Instance.new('TextButton', uiElements['templateSliderCanvas'])
uiElements['templateSliderTrigger'].BorderSizePixel = 0
uiElements['templateSliderTrigger'].TextSize = 14
uiElements['templateSliderTrigger'].AutoButtonColor = false
uiElements['templateSliderTrigger'].TextColor3 = Color3.fromRGB(0, 0, 0)
uiElements['templateSliderTrigger'].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
uiElements['templateSliderTrigger'].FontFace = Font.new('rbxasset://fonts/families/SourceSansPro.json', Enum.FontWeight.Regular, Enum.FontStyle.Normal)
uiElements['templateSliderTrigger'].BackgroundTransparency = 1
uiElements['templateSliderTrigger'].Size = UDim2.new(1, 0, 1, 0)
uiElements['templateSliderTrigger'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['templateSliderTrigger'].Text = ''
uiElements['templateSliderTrigger'].Name = 'Trigger'

uiElements['templateSliderFill'] = Instance.new('ImageButton', uiElements['templateSliderCanvas'])
uiElements['templateSliderFill'].Active = false
uiElements['templateSliderFill'].Interactable = false
uiElements['templateSliderFill'].BorderSizePixel = 0
uiElements['templateSliderFill'].AutoButtonColor = false
uiElements['templateSliderFill'].BackgroundTransparency = 1
uiElements['templateSliderFill'].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
uiElements['templateSliderFill'].Selectable = false
uiElements['templateSliderFill'].AnchorPoint = Vector2.new(0, 0.5)
uiElements['templateSliderFill'].Size = UDim2.new(0, 0, 1, 0)
uiElements['templateSliderFill'].ClipsDescendants = true
uiElements['templateSliderFill'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['templateSliderFill'].Name = 'Fill'
uiElements['templateSliderFill'].Position = UDim2.new(0, 0, 0.5, 0)

uiElements['templateSliderFillCorner'] = Instance.new('UICorner', uiElements['templateSliderFill'])
uiElements['templateSliderFillCorner'].CornerRadius = UDim.new(0, 4)

uiElements['templateSliderFillStroke'] = Instance.new('UIStroke', uiElements['templateSliderFill'])
uiElements['templateSliderFillStroke'].ApplyStrokeMode = Enum.ApplyStrokeMode.Border
uiElements['templateSliderFillStroke'].Thickness = 1.5
uiElements['templateSliderFillStroke'].Color = Color3.fromRGB(11, 136, 214)

uiElements['templateSliderFillGradient'] = Instance.new('ImageButton', uiElements['templateSliderFill'])
uiElements['templateSliderFillGradient'].Active = false
uiElements['templateSliderFillGradient'].Interactable = false
uiElements['templateSliderFillGradient'].BorderSizePixel = 0
uiElements['templateSliderFillGradient'].AutoButtonColor = false
uiElements['templateSliderFillGradient'].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
uiElements['templateSliderFillGradient'].Selectable = false
uiElements['templateSliderFillGradient'].AnchorPoint = Vector2.new(0, 0.5)
uiElements['templateSliderFillGradient'].Size = UDim2.new(1, 0, 1, 0)
uiElements['templateSliderFillGradient'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['templateSliderFillGradient'].Name = 'BackgroundGradient'
uiElements['templateSliderFillGradient'].Position = UDim2.new(0, 0, 0.5, 0)

uiElements['templateSliderFillGradientCorner'] = Instance.new('UICorner', uiElements['templateSliderFillGradient'])
uiElements['templateSliderFillGradientCorner'].CornerRadius = UDim.new(0, 4)

uiElements['templateSliderGradient1'] = Instance.new('UIGradient', uiElements['templateSliderFillGradient'])
uiElements['templateSliderGradient1'].Enabled = false
uiElements['templateSliderGradient1'].Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(0.16, Color3.fromRGB(0, 235, 255)),
    ColorSequenceKeypoint.new(0.32, Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(0.54, Color3.fromRGB(0, 5, 255)),
    ColorSequenceKeypoint.new(0.782, Color3.fromRGB(0, 235, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 158, 255))
}

uiElements['templateSliderGradient2'] = Instance.new('UIGradient', uiElements['templateSliderFillGradient'])
uiElements['templateSliderGradient2'].Enabled = false
uiElements['templateSliderGradient2'].Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(0.16, Color3.fromRGB(0, 5, 255)),
    ColorSequenceKeypoint.new(0.32, Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(0.54, Color3.fromRGB(0, 235, 255)),
    ColorSequenceKeypoint.new(0.782, Color3.fromRGB(0, 5, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 158, 255))
}

uiElements['templateSliderGradient3'] = Instance.new('UIGradient', uiElements['templateSliderFillGradient'])
uiElements['templateSliderGradient3'].Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 5, 255)),
    ColorSequenceKeypoint.new(0.16, Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(0.32, Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(0.54, Color3.fromRGB(0, 5, 255)),
    ColorSequenceKeypoint.new(0.782, Color3.fromRGB(0, 158, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 158, 255))
}

uiElements['templateSliderValueText'] = Instance.new('TextLabel', uiElements['templateSliderTrack'])
uiElements['templateSliderValueText'].TextWrapped = true
uiElements['templateSliderValueText'].Interactable = false
uiElements['templateSliderValueText'].ZIndex = 2
uiElements['templateSliderValueText'].BorderSizePixel = 0
uiElements['templateSliderValueText'].TextSize = 14
uiElements['templateSliderValueText'].TextXAlignment = Enum.TextXAlignment.Left
uiElements['templateSliderValueText'].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
uiElements['templateSliderValueText'].FontFace = Font.new('rbxassetid://11702779517', Enum.FontWeight.Bold, Enum.FontStyle.Normal)
uiElements['templateSliderValueText'].TextColor3 = Color3.fromRGB(197, 204, 219)
uiElements['templateSliderValueText'].BackgroundTransparency = 1
uiElements['templateSliderValueText'].RichText = true
uiElements['templateSliderValueText'].AnchorPoint = Vector2.new(0.5, 0.5)
uiElements['templateSliderValueText'].Size = UDim2.new(1, - 15, 1, 0)
uiElements['templateSliderValueText'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['templateSliderValueText'].Text = '0'
uiElements['templateSliderValueText'].Name = 'ValueText'
uiElements['templateSliderValueText'].Position = UDim2.new(0.5, 0, 0.5, 0)

uiElements['templateTextBox'] = Instance.new('Frame', uiElements['templatesFolder'])
uiElements['templateTextBox'].Visible = false
uiElements['templateTextBox'].BorderSizePixel = 0
uiElements['templateTextBox'].BackgroundColor3 = Color3.fromRGB(43, 46, 53)
uiElements['templateTextBox'].AutomaticSize = Enum.AutomaticSize.Y
uiElements['templateTextBox'].Size = UDim2.new(1, 0, 0, 35)
uiElements['templateTextBox'].Position = UDim2.new(- 3.75E-2, 0, 0.38434, 0)
uiElements['templateTextBox'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['templateTextBox'].Name = 'TextBox'

uiElements['templateTextBoxCorner'] = Instance.new('UICorner', uiElements['templateTextBox'])
uiElements['templateTextBoxCorner'].CornerRadius = UDim.new(0, 6)

uiElements['templateTextBoxStroke'] = Instance.new('UIStroke', uiElements['templateTextBox'])
uiElements['templateTextBoxStroke'].ApplyStrokeMode = Enum.ApplyStrokeMode.Border
uiElements['templateTextBoxStroke'].Thickness = 1.5
uiElements['templateTextBoxStroke'].Color = Color3.fromRGB(61, 61, 75)

uiElements['templateTextBoxTitle'] = Instance.new('TextLabel', uiElements['templateTextBox'])
uiElements['templateTextBoxTitle'].TextWrapped = true
uiElements['templateTextBoxTitle'].Interactable = false
uiElements['templateTextBoxTitle'].BorderSizePixel = 0
uiElements['templateTextBoxTitle'].TextSize = 16
uiElements['templateTextBoxTitle'].TextXAlignment = Enum.TextXAlignment.Left
uiElements['templateTextBoxTitle'].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
uiElements['templateTextBoxTitle'].FontFace = Font.new('rbxassetid://11702779517', Enum.FontWeight.Bold, Enum.FontStyle.Normal)
uiElements['templateTextBoxTitle'].TextColor3 = Color3.fromRGB(197, 204, 219)
uiElements['templateTextBoxTitle'].BackgroundTransparency = 1
uiElements['templateTextBoxTitle'].Size = UDim2.new(1, 0, 0, 15)
uiElements['templateTextBoxTitle'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['templateTextBoxTitle'].Text = 'Input Textbox'
uiElements['templateTextBoxTitle'].AutomaticSize = Enum.AutomaticSize.Y
uiElements['templateTextBoxTitle'].Name = 'Title'

uiElements['templateTextBoxPadding'] = Instance.new('UIPadding', uiElements['templateTextBox'])
uiElements['templateTextBoxPadding'].PaddingTop = UDim.new(0, 10)
uiElements['templateTextBoxPadding'].PaddingRight = UDim.new(0, 10)
uiElements['templateTextBoxPadding'].PaddingLeft = UDim.new(0, 10)
uiElements['templateTextBoxPadding'].PaddingBottom = UDim.new(0, 10)

uiElements['templateTextBoxLayout'] = Instance.new('UIListLayout', uiElements['templateTextBox'])
uiElements['templateTextBoxLayout'].Padding = UDim.new(0, 10)
uiElements['templateTextBoxLayout'].SortOrder = Enum.SortOrder.LayoutOrder

uiElements['templateTextBoxDescription'] = Instance.new('TextLabel', uiElements['templateTextBox'])
uiElements['templateTextBoxDescription'].TextWrapped = true
uiElements['templateTextBoxDescription'].Interactable = false
uiElements['templateTextBoxDescription'].BorderSizePixel = 0
uiElements['templateTextBoxDescription'].TextSize = 16
uiElements['templateTextBoxDescription'].TextXAlignment = Enum.TextXAlignment.Left
uiElements['templateTextBoxDescription'].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
uiElements['templateTextBoxDescription'].FontFace = Font.new('rbxassetid://11702779517', Enum.FontWeight.Medium, Enum.FontStyle.Normal)
uiElements['templateTextBoxDescription'].TextColor3 = Color3.fromRGB(197, 204, 219)
uiElements['templateTextBoxDescription'].BackgroundTransparency = 1
uiElements['templateTextBoxDescription'].Size = UDim2.new(1, 0, 0, 15)
uiElements['templateTextBoxDescription'].Visible = false
uiElements['templateTextBoxDescription'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['templateTextBoxDescription'].Text = [[Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus placerat lacus in enim congue, fermentum euismod leo ultricies. Nulla sodales. ]]
uiElements['templateTextBoxDescription'].LayoutOrder = 1
uiElements['templateTextBoxDescription'].AutomaticSize = Enum.AutomaticSize.Y
uiElements['templateTextBoxDescription'].Name = 'Description'

uiElements['templateTextBoxInputFrame'] = Instance.new('Frame', uiElements['templateTextBox'])
uiElements['templateTextBoxInputFrame'].BorderSizePixel = 0
uiElements['templateTextBoxInputFrame'].BackgroundColor3 = Color3.fromRGB(54, 57, 63)
uiElements['templateTextBoxInputFrame'].Size = UDim2.new(1, 0, 0, 35)
uiElements['templateTextBoxInputFrame'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['templateTextBoxInputFrame'].Name = 'InputFrame'
uiElements['templateTextBoxInputFrame'].LayoutOrder = 2

uiElements['templateTextBoxInputCorner'] = Instance.new('UICorner', uiElements['templateTextBoxInputFrame'])
uiElements['templateTextBoxInputCorner'].CornerRadius = UDim.new(0, 5)

uiElements['templateTextBoxInputStroke'] = Instance.new('UIStroke', uiElements['templateTextBoxInputFrame'])
uiElements['templateTextBoxInputStroke'].ApplyStrokeMode = Enum.ApplyStrokeMode.Border
uiElements['templateTextBoxInputStroke'].Thickness = 1.5
uiElements['templateTextBoxInputStroke'].Color = Color3.fromRGB(61, 61, 75)

uiElements['templateTextBoxInput'] = Instance.new('TextBox', uiElements['templateTextBoxInputFrame'])
uiElements['templateTextBoxInput'].TextXAlignment = Enum.TextXAlignment.Left
uiElements['templateTextBoxInput'].BorderSizePixel = 0
uiElements['templateTextBoxInput'].TextWrapped = true
uiElements['templateTextBoxInput'].TextTruncate = Enum.TextTruncate.AtEnd
uiElements['templateTextBoxInput'].TextSize = 14
uiElements['templateTextBoxInput'].TextColor3 = Color3.fromRGB(197, 204, 219)
uiElements['templateTextBoxInput'].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
uiElements['templateTextBoxInput'].FontFace = Font.new('rbxassetid://11702779517', Enum.FontWeight.Medium, Enum.FontStyle.Normal)
uiElements['templateTextBoxInput'].ClipsDescendants = true
uiElements['templateTextBoxInput'].PlaceholderText = 'Input here...'
uiElements['templateTextBoxInput'].Size = UDim2.new(1, 0, 1, 0)
uiElements['templateTextBoxInput'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['templateTextBoxInput'].Text = ''
uiElements['templateTextBoxInput'].BackgroundTransparency = 1

uiElements['templateTextBoxInputPadding'] = Instance.new('UIPadding', uiElements['templateTextBoxInput'])
uiElements['templateTextBoxInputPadding'].PaddingTop = UDim.new(0, 10)
uiElements['templateTextBoxInputPadding'].PaddingRight = UDim.new(0, 10)
uiElements['templateTextBoxInputPadding'].PaddingLeft = UDim.new(0, 10)
uiElements['templateTextBoxInputPadding'].PaddingBottom = UDim.new(0, 10)

uiElements['templateKeybind'] = Instance.new('Frame', uiElements['templatesFolder'])
uiElements['templateKeybind'].Visible = false
uiElements['templateKeybind'].BorderSizePixel = 0
uiElements['templateKeybind'].BackgroundColor3 = Color3.fromRGB(43, 46, 53)
uiElements['templateKeybind'].AutomaticSize = Enum.AutomaticSize.Y
uiElements['templateKeybind'].Size = UDim2.new(1, 0, 0, 35)
uiElements['templateKeybind'].Position = UDim2.new(- 3.75E-2, 0, 0.38434, 0)
uiElements['templateKeybind'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['templateKeybind'].Name = 'Keybind'

uiElements['templateKeybindCorner'] = Instance.new('UICorner', uiElements['templateKeybind'])
uiElements['templateKeybindCorner'].CornerRadius = UDim.new(0, 6)

uiElements['templateKeybindStroke'] = Instance.new('UIStroke', uiElements['templateKeybind'])
uiElements['templateKeybindStroke'].ApplyStrokeMode = Enum.ApplyStrokeMode.Border
uiElements['templateKeybindStroke'].Thickness = 1.5
uiElements['templateKeybindStroke'].Color = Color3.fromRGB(61, 61, 75)

uiElements['templateKeybindTitle'] = Instance.new('TextLabel', uiElements['templateKeybind'])
uiElements['templateKeybindTitle'].TextWrapped = true
uiElements['templateKeybindTitle'].Interactable = false
uiElements['templateKeybindTitle'].BorderSizePixel = 0
uiElements['templateKeybindTitle'].TextSize = 16
uiElements['templateKeybindTitle'].TextXAlignment = Enum.TextXAlignment.Left
uiElements['templateKeybindTitle'].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
uiElements['templateKeybindTitle'].FontFace = Font.new('rbxassetid://11702779517', Enum.FontWeight.Bold, Enum.FontStyle.Normal)
uiElements['templateKeybindTitle'].TextColor3 = Color3.fromRGB(197, 204, 219)
uiElements['templateKeybindTitle'].BackgroundTransparency = 1
uiElements['templateKeybindTitle'].Size = UDim2.new(1, 0, 0, 15)
uiElements['templateKeybindTitle'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['templateKeybindTitle'].Text = 'Keybind'
uiElements['templateKeybindTitle'].AutomaticSize = Enum.AutomaticSize.Y
uiElements['templateKeybindTitle'].Name = 'Title'

uiElements['templateKeybindPadding'] = Instance.new('UIPadding', uiElements['templateKeybind'])
uiElements['templateKeybindPadding'].PaddingTop = UDim.new(0, 10)
uiElements['templateKeybindPadding'].PaddingRight = UDim.new(0, 10)
uiElements['templateKeybindPadding'].PaddingLeft = UDim.new(0, 10)
uiElements['templateKeybindPadding'].PaddingBottom = UDim.new(0, 10)

uiElements['templateKeybindLayout'] = Instance.new('UIListLayout', uiElements['templateKeybind'])
uiElements['templateKeybindLayout'].Padding = UDim.new(0, 5)
uiElements['templateKeybindLayout'].SortOrder = Enum.SortOrder.LayoutOrder

uiElements['templateKeybindDescription'] = Instance.new('TextLabel', uiElements['templateKeybind'])
uiElements['templateKeybindDescription'].TextWrapped = true
uiElements['templateKeybindDescription'].Interactable = false
uiElements['templateKeybindDescription'].BorderSizePixel = 0
uiElements['templateKeybindDescription'].TextSize = 16
uiElements['templateKeybindDescription'].TextXAlignment = Enum.TextXAlignment.Left
uiElements['templateKeybindDescription'].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
uiElements['templateKeybindDescription'].FontFace = Font.new('rbxassetid://11702779517', Enum.FontWeight.Medium, Enum.FontStyle.Normal)
uiElements['templateKeybindDescription'].TextColor3 = Color3.fromRGB(197, 204, 219)
uiElements['templateKeybindDescription'].BackgroundTransparency = 1
uiElements['templateKeybindDescription'].Size = UDim2.new(1, 0, 0, 15)
uiElements['templateKeybindDescription'].Visible = false
uiElements['templateKeybindDescription'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['templateKeybindDescription'].Text = [[Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus placerat lacus in enim congue, fermentum euismod leo ultricies. Nulla sodales. ]]
uiElements['templateKeybindDescription'].LayoutOrder = 1
uiElements['templateKeybindDescription'].AutomaticSize = Enum.AutomaticSize.Y
uiElements['templateKeybindDescription'].Name = 'Description'

uiElements['templateKeybindButton'] = Instance.new('TextButton', uiElements['templateKeybind'])
uiElements['templateKeybindButton'].TextXAlignment = Enum.TextXAlignment.Center
uiElements['templateKeybindButton'].BorderSizePixel = 0
uiElements['templateKeybindButton'].TextWrapped = true
uiElements['templateKeybindButton'].TextTruncate = Enum.TextTruncate.AtEnd
uiElements['templateKeybindButton'].TextSize = 14
uiElements['templateKeybindButton'].TextColor3 = Color3.fromRGB(197, 204, 219)
uiElements['templateKeybindButton'].BackgroundColor3 = Color3.fromRGB(54, 57, 63)
uiElements['templateKeybindButton'].FontFace = Font.new('rbxassetid://11702779517', Enum.FontWeight.Medium, Enum.FontStyle.Normal)
uiElements['templateKeybindButton'].ClipsDescendants = true
uiElements['templateKeybindButton'].Size = UDim2.new(0, 200, 0, 35)
uiElements['templateKeybindButton'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['templateKeybindButton'].Text = '[None]'
uiElements['templateKeybindButton'].Name = 'KeybindButton'
uiElements['templateKeybindButton'].LayoutOrder = 2

uiElements['templateKeybindButtonCorner'] = Instance.new('UICorner', uiElements['templateKeybindButton'])
uiElements['templateKeybindButtonCorner'].CornerRadius = UDim.new(0, 5)

uiElements['templateKeybindButtonStroke'] = Instance.new('UIStroke', uiElements['templateKeybindButton'])
uiElements['templateKeybindButtonStroke'].ApplyStrokeMode = Enum.ApplyStrokeMode.Border
uiElements['templateKeybindButtonStroke'].Thickness = 1.5
uiElements['templateKeybindButtonStroke'].Color = Color3.fromRGB(61, 61, 75)

uiElements['templateColorPicker'] = Instance.new('Frame', uiElements['templatesFolder'])
uiElements['templateColorPicker'].Visible = false
uiElements['templateColorPicker'].BorderSizePixel = 0
uiElements['templateColorPicker'].BackgroundColor3 = Color3.fromRGB(43, 46, 53)
uiElements['templateColorPicker'].AutomaticSize = Enum.AutomaticSize.Y
uiElements['templateColorPicker'].Size = UDim2.new(1, 0, 0, 35)
uiElements['templateColorPicker'].Position = UDim2.new(- 3.75E-2, 0, 0.38434, 0)
uiElements['templateColorPicker'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['templateColorPicker'].Name = 'ColorPicker'

uiElements['templateColorPickerCorner'] = Instance.new('UICorner', uiElements['templateColorPicker'])
uiElements['templateColorPickerCorner'].CornerRadius = UDim.new(0, 6)

uiElements['templateColorPickerStroke'] = Instance.new('UIStroke', uiElements['templateColorPicker'])
uiElements['templateColorPickerStroke'].ApplyStrokeMode = Enum.ApplyStrokeMode.Border
uiElements['templateColorPickerStroke'].Thickness = 1.5
uiElements['templateColorPickerStroke'].Color = Color3.fromRGB(61, 61, 75)

uiElements['templateColorPickerTitle'] = Instance.new('TextLabel', uiElements['templateColorPicker'])
uiElements['templateColorPickerTitle'].TextWrapped = true
uiElements['templateColorPickerTitle'].Interactable = false
uiElements['templateColorPickerTitle'].BorderSizePixel = 0
uiElements['templateColorPickerTitle'].TextSize = 16
uiElements['templateColorPickerTitle'].TextXAlignment = Enum.TextXAlignment.Left
uiElements['templateColorPickerTitle'].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
uiElements['templateColorPickerTitle'].FontFace = Font.new('rbxassetid://11702779517', Enum.FontWeight.Bold, Enum.FontStyle.Normal)
uiElements['templateColorPickerTitle'].TextColor3 = Color3.fromRGB(197, 204, 219)
uiElements['templateColorPickerTitle'].BackgroundTransparency = 1
uiElements['templateColorPickerTitle'].Size = UDim2.new(1, 0, 0, 15)
uiElements['templateColorPickerTitle'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['templateColorPickerTitle'].Text = 'Color Picker'
uiElements['templateColorPickerTitle'].AutomaticSize = Enum.AutomaticSize.Y
uiElements['templateColorPickerTitle'].Name = 'Title'

uiElements['templateColorPickerPadding'] = Instance.new('UIPadding', uiElements['templateColorPicker'])
uiElements['templateColorPickerPadding'].PaddingTop = UDim.new(0, 10)
uiElements['templateColorPickerPadding'].PaddingRight = UDim.new(0, 10)
uiElements['templateColorPickerPadding'].PaddingLeft = UDim.new(0, 10)
uiElements['templateColorPickerPadding'].PaddingBottom = UDim.new(0, 10)

uiElements['templateColorPickerLayout'] = Instance.new('UIListLayout', uiElements['templateColorPicker'])
uiElements['templateColorPickerLayout'].Padding = UDim.new(0, 5)
uiElements['templateColorPickerLayout'].SortOrder = Enum.SortOrder.LayoutOrder

uiElements['templateColorPickerDescription'] = Instance.new('TextLabel', uiElements['templateColorPicker'])
uiElements['templateColorPickerDescription'].TextWrapped = true
uiElements['templateColorPickerDescription'].Interactable = false
uiElements['templateColorPickerDescription'].BorderSizePixel = 0
uiElements['templateColorPickerDescription'].TextSize = 16
uiElements['templateColorPickerDescription'].TextXAlignment = Enum.TextXAlignment.Left
uiElements['templateColorPickerDescription'].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
uiElements['templateColorPickerDescription'].FontFace = Font.new('rbxassetid://11702779517', Enum.FontWeight.Medium, Enum.FontStyle.Normal)
uiElements['templateColorPickerDescription'].TextColor3 = Color3.fromRGB(197, 204, 219)
uiElements['templateColorPickerDescription'].BackgroundTransparency = 1
uiElements['templateColorPickerDescription'].Size = UDim2.new(1, 0, 0, 15)
uiElements['templateColorPickerDescription'].Visible = false
uiElements['templateColorPickerDescription'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['templateColorPickerDescription'].Text = [[Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus placerat lacus in enim congue, fermentum euismod leo ultricies. Nulla sodales. ]]
uiElements['templateColorPickerDescription'].LayoutOrder = 1
uiElements['templateColorPickerDescription'].AutomaticSize = Enum.AutomaticSize.Y
uiElements['templateColorPickerDescription'].Name = 'Description'

uiElements['templateColorPickerButton'] = Instance.new('TextButton', uiElements['templateColorPicker'])
uiElements['templateColorPickerButton'].TextXAlignment = Enum.TextXAlignment.Center
uiElements['templateColorPickerButton'].BorderSizePixel = 0
uiElements['templateColorPickerButton'].TextWrapped = true
uiElements['templateColorPickerButton'].TextTruncate = Enum.TextTruncate.AtEnd
uiElements['templateColorPickerButton'].TextSize = 14
uiElements['templateColorPickerButton'].TextColor3 = Color3.fromRGB(197, 204, 219)
uiElements['templateColorPickerButton'].BackgroundColor3 = Color3.fromRGB(54, 57, 63)
uiElements['templateColorPickerButton'].FontFace = Font.new('rbxassetid://11702779517', Enum.FontWeight.Medium, Enum.FontStyle.Normal)
uiElements['templateColorPickerButton'].ClipsDescendants = true
uiElements['templateColorPickerButton'].Size = UDim2.new(0, 200, 0, 35)
uiElements['templateColorPickerButton'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['templateColorPickerButton'].Text = 'Pick Color'
uiElements['templateColorPickerButton'].Name = 'ColorPickerButton'
uiElements['templateColorPickerButton'].LayoutOrder = 2

uiElements['templateColorPickerButtonCorner'] = Instance.new('UICorner', uiElements['templateColorPickerButton'])
uiElements['templateColorPickerButtonCorner'].CornerRadius = UDim.new(0, 5)

uiElements['templateColorPickerButtonStroke'] = Instance.new('UIStroke', uiElements['templateColorPickerButton'])
uiElements['templateColorPickerButtonStroke'].ApplyStrokeMode = Enum.ApplyStrokeMode.Border
uiElements['templateColorPickerButtonStroke'].Thickness = 1.5
uiElements['templateColorPickerButtonStroke'].Color = Color3.fromRGB(61, 61, 75)

uiElements['templateColorPickerPreview'] = Instance.new('Frame', uiElements['templateColorPickerButton'])
uiElements['templateColorPickerPreview'].BorderSizePixel = 0
uiElements['templateColorPickerPreview'].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
uiElements['templateColorPickerPreview'].AnchorPoint = Vector2.new(1, 0.5)
uiElements['templateColorPickerPreview'].Size = UDim2.new(0, 25, 0, 25)
uiElements['templateColorPickerPreview'].Position = UDim2.new(1, - 10, 0.5, 0)
uiElements['templateColorPickerPreview'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['templateColorPickerPreview'].Name = 'ColorPreview'

uiElements['templateColorPickerPreviewCorner'] = Instance.new('UICorner', uiElements['templateColorPickerPreview'])
uiElements['templateColorPickerPreviewCorner'].CornerRadius = UDim.new(0, 3)

uiElements['templateColorPickerPreviewStroke'] = Instance.new('UIStroke', uiElements['templateColorPickerPreview'])
uiElements['templateColorPickerPreviewStroke'].ApplyStrokeMode = Enum.ApplyStrokeMode.Border
uiElements['templateColorPickerPreviewStroke'].Thickness = 1
uiElements['templateColorPickerPreviewStroke'].Color = Color3.fromRGB(61, 61, 75)

uiElements['templateDropdown'] = Instance.new('Frame', uiElements['templatesFolder'])
uiElements['templateDropdown'].Visible = false
uiElements['templateDropdown'].BorderSizePixel = 0
uiElements['templateDropdown'].BackgroundColor3 = Color3.fromRGB(43, 46, 53)
uiElements['templateDropdown'].AutomaticSize = Enum.AutomaticSize.Y
uiElements['templateDropdown'].Size = UDim2.new(1, 0, 0, 35)
uiElements['templateDropdown'].Position = UDim2.new(- 3.75E-2, 0, 0.38434, 0)
uiElements['templateDropdown'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['templateDropdown'].Name = 'Dropdown'

uiElements['templateDropdownCorner'] = Instance.new('UICorner', uiElements['templateDropdown'])
uiElements['templateDropdownCorner'].CornerRadius = UDim.new(0, 6)

uiElements['templateDropdownStroke'] = Instance.new('UIStroke', uiElements['templateDropdown'])
uiElements['templateDropdownStroke'].ApplyStrokeMode = Enum.ApplyStrokeMode.Border
uiElements['templateDropdownStroke'].Thickness = 1.5
uiElements['templateDropdownStroke'].Color = Color3.fromRGB(61, 61, 75)

uiElements['templateDropdownTitle'] = Instance.new('TextLabel', uiElements['templateDropdown'])
uiElements['templateDropdownTitle'].TextWrapped = true
uiElements['templateDropdownTitle'].Interactable = false
uiElements['templateDropdownTitle'].BorderSizePixel = 0
uiElements['templateDropdownTitle'].TextSize = 16
uiElements['templateDropdownTitle'].TextXAlignment = Enum.TextXAlignment.Left
uiElements['templateDropdownTitle'].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
uiElements['templateDropdownTitle'].FontFace = Font.new('rbxassetid://11702779517', Enum.FontWeight.Bold, Enum.FontStyle.Normal)
uiElements['templateDropdownTitle'].TextColor3 = Color3.fromRGB(197, 204, 219)
uiElements['templateDropdownTitle'].BackgroundTransparency = 1
uiElements['templateDropdownTitle'].Size = UDim2.new(1, 0, 0, 15)
uiElements['templateDropdownTitle'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['templateDropdownTitle'].Text = 'Dropdown'
uiElements['templateDropdownTitle'].AutomaticSize = Enum.AutomaticSize.Y
uiElements['templateDropdownTitle'].Name = 'Title'

uiElements['templateDropdownPadding'] = Instance.new('UIPadding', uiElements['templateDropdown'])
uiElements['templateDropdownPadding'].PaddingTop = UDim.new(0, 10)
uiElements['templateDropdownPadding'].PaddingRight = UDim.new(0, 10)
uiElements['templateDropdownPadding'].PaddingLeft = UDim.new(0, 10)
uiElements['templateDropdownPadding'].PaddingBottom = UDim.new(0, 10)

uiElements['templateDropdownLayout'] = Instance.new('UIListLayout', uiElements['templateDropdown'])
uiElements['templateDropdownLayout'].Padding = UDim.new(0, 5)
uiElements['templateDropdownLayout'].SortOrder = Enum.SortOrder.LayoutOrder

uiElements['templateDropdownDescription'] = Instance.new('TextLabel', uiElements['templateDropdown'])
uiElements['templateDropdownDescription'].TextWrapped = true
uiElements['templateDropdownDescription'].Interactable = false
uiElements['templateDropdownDescription'].BorderSizePixel = 0
uiElements['templateDropdownDescription'].TextSize = 16
uiElements['templateDropdownDescription'].TextXAlignment = Enum.TextXAlignment.Left
uiElements['templateDropdownDescription'].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
uiElements['templateDropdownDescription'].FontFace = Font.new('rbxassetid://11702779517', Enum.FontWeight.Medium, Enum.FontStyle.Normal)
uiElements['templateDropdownDescription'].TextColor3 = Color3.fromRGB(197, 204, 219)
uiElements['templateDropdownDescription'].BackgroundTransparency = 1
uiElements['templateDropdownDescription'].Size = UDim2.new(1, 0, 0, 15)
uiElements['templateDropdownDescription'].Visible = false
uiElements['templateDropdownDescription'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['templateDropdownDescription'].Text = [[Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus placerat lacus in enim congue, fermentum euismod leo ultricies. Nulla sodales. ]]
uiElements['templateDropdownDescription'].LayoutOrder = 1
uiElements['templateDropdownDescription'].AutomaticSize = Enum.AutomaticSize.Y
uiElements['templateDropdownDescription'].Name = 'Description'

uiElements['templateDropdownButton'] = Instance.new('TextButton', uiElements['templateDropdown'])
uiElements['templateDropdownButton'].TextXAlignment = Enum.TextXAlignment.Left
uiElements['templateDropdownButton'].BorderSizePixel = 0
uiElements['templateDropdownButton'].TextWrapped = true
uiElements['templateDropdownButton'].TextTruncate = Enum.TextTruncate.AtEnd
uiElements['templateDropdownButton'].TextSize = 14
uiElements['templateDropdownButton'].TextColor3 = Color3.fromRGB(197, 204, 219)
uiElements['templateDropdownButton'].BackgroundColor3 = Color3.fromRGB(54, 57, 63)
uiElements['templateDropdownButton'].FontFace = Font.new('rbxassetid://11702779517', Enum.FontWeight.Medium, Enum.FontStyle.Normal)
uiElements['templateDropdownButton'].ClipsDescendants = true
uiElements['templateDropdownButton'].Size = UDim2.new(1, 0, 0, 35)
uiElements['templateDropdownButton'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['templateDropdownButton'].Text = 'Select Option'
uiElements['templateDropdownButton'].Name = 'DropdownButton'
uiElements['templateDropdownButton'].LayoutOrder = 2

uiElements['templateDropdownButtonCorner'] = Instance.new('UICorner', uiElements['templateDropdownButton'])
uiElements['templateDropdownButtonCorner'].CornerRadius = UDim.new(0, 5)

uiElements['templateDropdownButtonStroke'] = Instance.new('UIStroke', uiElements['templateDropdownButton'])
uiElements['templateDropdownButtonStroke'].ApplyStrokeMode = Enum.ApplyStrokeMode.Border
uiElements['templateDropdownButtonStroke'].Thickness = 1.5
uiElements['templateDropdownButtonStroke'].Color = Color3.fromRGB(61, 61, 75)

uiElements['templateDropdownArrow'] = Instance.new('ImageLabel', uiElements['templateDropdownButton'])
uiElements['templateDropdownArrow'].BorderSizePixel = 0
uiElements['templateDropdownArrow'].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
uiElements['templateDropdownArrow'].ImageColor3 = Color3.fromRGB(197, 204, 219)
uiElements['templateDropdownArrow'].AnchorPoint = Vector2.new(1, 0.5)
uiElements['templateDropdownArrow'].Image = 'rbxassetid://6031068421'
uiElements['templateDropdownArrow'].Size = UDim2.new(0, 20, 0, 20)
uiElements['templateDropdownArrow'].BorderColor3 = Color3.fromRGB(0, 0, 0)
uiElements['templateDropdownArrow'].Name = 'DropdownArrow'
uiElements['templateDropdownArrow'].Position = UDim2.new(1, - 10, 0.5, 0)

uiElements['templateDropdownArrowRatio'] = Instance.new('UIAspectRatioConstraint', uiElements['templateDropdownArrow'])

uiElements['templateDropdownButtonPadding'] = Instance.new('UIPadding', uiElements['templateDropdownButton'])
uiElements['templateDropdownButtonPadding'].PaddingTop = UDim.new(0, 10)
uiElements['templateDropdownButtonPadding'].PaddingRight = UDim.new(0, 10)
uiElements['templateDropdownButtonPadding'].PaddingLeft = UDim.new(0, 10)
uiElements['templateDropdownButtonPadding'].PaddingBottom = UDim.new(0, 10)

-- Library Functions and Animations
local library = {}
local tabs = {}
local notifications = {}
local currentTab = nil
local dragging = false
local dragStart = nil
local startPos = nil
local minimized = false
local maximized = false
local originalSize = uiElements['mainWindow'].Size
local originalPos = uiElements['mainWindow'].Position

-- Utility Functions
local function tween(object, info, goal)
    local tweenService = game:GetService('TweenService')
    local tween = tweenService:Create(object, info, goal)
    tween:Play()
    return tween
end

local function lerp(a, b, t)
    return a + (b - a) * t
end

local function clamp(value, min, max)
    return math.max(min, math.min(max, value))
end

-- Window Management
function library:Toggle()
    uiElements['mainGui'].Enabled = not uiElements['mainGui'].Enabled
end

function library:Minimize()
    if not minimized then
        minimized = true
        tween(uiElements['mainWindow'], TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 200, 0, 35)
        })
        uiElements['tabsContainer'].Visible = false
        uiElements['tabButtonsContainer'].Visible = false
    else
        minimized = false
        tween(uiElements['mainWindow'], TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = originalSize
        })
        uiElements['tabsContainer'].Visible = true
        uiElements['tabButtonsContainer'].Visible = true
    end
end

function library:Maximize()
    if not maximized then
        maximized = true
        originalSize = uiElements['mainWindow'].Size
        originalPos = uiElements['mainWindow'].Position
        tween(uiElements['mainWindow'], TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(1, -50, 1, -50),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        })
    else
        maximized = false
        tween(uiElements['mainWindow'], TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = originalSize,
            Position = originalPos
        })
    end
end

-- Tab Management
function library:AddTab(name, icon)
    local tab = {
        name = name,
        icon = icon or 'rbxassetid://113216930555884',
        elements = {},
        container = nil
    }
    
    -- Create tab button
    local tabButton = uiElements['tabButtonInactive']:Clone()
    tabButton.Visible = true
    tabButton.Name = name .. 'Tab'
    
    local tabIcon = tabButton:FindFirstChild('tabInactiveIcon')
    local tabText = tabButton:FindFirstChild('tabInactiveText')
    
    if tabIcon then
        tabIcon.Image = tab.icon
    end
    if tabText then
        tabText.Text = name
    end
    
    tabButton.Parent = uiElements['tabScrollingFrame']
    
    -- Create tab container
    local tabContainer = uiElements['templateTab']:Clone()
    tabContainer.Name = name .. 'Container'
    tabContainer.Parent = uiElements['tabsContainer']
    tabContainer.Visible = false
    
    tab.container = tabContainer
    tab.button = tabButton
    
    -- Tab button click handler
    tabButton.MouseButton1Click:Connect(function()
        library:SelectTab(tab)
    end)
    
    tabs[name] = tab
    
    if not currentTab then
        library:SelectTab(tab)
    end
    
    return tab
end

function library:SelectTab(tab)
    if currentTab == tab then return end
    
    -- Hide current tab
    if currentTab then
        currentTab.container.Visible = false
        currentTab.button:FindFirstChild('tabInactiveIcon').ImageTransparency = 0.5
        currentTab.button:FindFirstChild('tabInactiveText').TextTransparency = 0.5
        currentTab.button:FindFirstChild('tabInactiveBar').BackgroundTransparency = 1
    end
    
    -- Show new tab
    currentTab = tab
    tab.container.Visible = true
    tab.button:FindFirstChild('tabInactiveIcon').ImageTransparency = 0
    tab.button:FindFirstChild('tabInactiveText').TextTransparency = 0
    tab.button:FindFirstChild('tabInactiveBar').BackgroundTransparency = 0
end

-- UI Element Creation Functions
function library:AddButton(tab, text, callback, description)
    local button = uiElements['templateButton']:Clone()
    button.Visible = true
    button.Name = text .. 'Button'
    button.Parent = tab.container
    
    local buttonTitle = button:FindFirstChild('templateButtonTitle')
    local buttonDesc = button:FindFirstChild('templateButtonDescription')
    local clickIcon = buttonTitle:FindFirstChild('templateButtonClickIcon')
    
    buttonTitle.Text = text
    if description and description ~= '' then
        buttonDesc.Text = description
        buttonDesc.Visible = true
    end
    
    button.MouseButton1Click:Connect(function()
        if callback then
            callback()
        end
        -- Click animation
        tween(clickIcon, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Rotation = 360
        })
    end)
    
    table.insert(tab.elements, button)
    return button
end

function library:AddToggle(tab, text, default, callback, description)
    local toggle = uiElements['templateToggle']:Clone()
    toggle.Visible = true
    toggle.Name = text .. 'Toggle'
    toggle.Parent = tab.container
    
    local toggleTitle = toggle:FindFirstChild('templateToggleTitle')
    local toggleDesc = toggle:FindFirstChild('templateToggleDescription')
    local toggleFill = toggleTitle:FindFirstChild('templateToggleFill')
    local toggleBall = toggleFill:FindFirstChild('templateToggleBall')
    
    toggleTitle.Text = text
    if description and description ~= '' then
        toggleDesc.Text = description
        toggleDesc.Visible = true
    end
    
    local state = default or false
    
    local function updateToggle()
        if state then
            tween(toggleFill, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundColor3 = Color3.fromRGB(0, 162, 255)
            })
            tween(toggleBall, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(1, -22, 0.5, 0)
            })
        else
            tween(toggleFill, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundColor3 = Color3.fromRGB(54, 57, 63)
            })
            tween(toggleBall, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, 2, 0.5, 0)
            })
        end
    end
    
    toggle.MouseButton1Click:Connect(function()
        state = not state
        updateToggle()
        if callback then
            callback(state)
        end
    end)
    
    updateToggle()
    table.insert(tab.elements, toggle)
    return toggle
end

function library:AddSlider(tab, text, min, max, default, callback, description)
    local slider = uiElements['templateSlider']:Clone()
    slider.Visible = true
    slider.Name = text .. 'Slider'
    slider.Parent = tab.container
    
    local sliderTitle = slider:FindFirstChild('templateSliderTitle')
    local sliderDesc = slider:FindFirstChild('templateSliderDescription')
    local sliderFrame = slider:FindFirstChild('templateSliderFrame')
    local sliderTrack = sliderFrame:FindFirstChild('templateSliderTrack')
    local sliderCanvas = sliderTrack:FindFirstChild('templateSliderCanvas')
    local sliderTrigger = sliderCanvas:FindFirstChild('templateSliderTrigger')
    local sliderFill = sliderCanvas:FindFirstChild('templateSliderFill')
    local valueText = sliderTrack:FindFirstChild('templateSliderValueText')
    
    sliderTitle.Text = text
    if description and description ~= '' then
        sliderDesc.Text = description
        sliderDesc.Visible = true
    end
    
    local value = clamp(default or min, min, max)
    local draggingSlider = false
    
    local function updateSlider()
        local percentage = (value - min) / (max - min)
        sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
        valueText.Text = tostring(math.floor(value))
    end
    
    local function setValue(inputPosition)
        local sliderSize = sliderCanvas.AbsoluteSize.X
        local sliderPos = sliderCanvas.AbsolutePosition.X
        local percentage = clamp((inputPosition.X - sliderPos) / sliderSize, 0, 1)
        value = lerp(min, max, percentage)
        updateSlider()
        if callback then
            callback(value)
        end
    end
    
    sliderTrigger.MouseButton1Down:Connect(function()
        draggingSlider = true
    end)
    
    sliderTrigger.MouseButton1Up:Connect(function()
        draggingSlider = false
    end)
    
    game:GetService('UserInputService').InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingSlider = false
        end
    end)
    
    game:GetService('UserInputService').InputChanged:Connect(function(input)
        if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
            setValue(input.Position)
        end
    end)
    
    sliderTrigger.MouseButton1Click:Connect(function(input)
        setValue(input.Position)
    end)
    
    updateSlider()
    table.insert(tab.elements, slider)
    return slider
end

function library:AddTextBox(tab, text, placeholder, callback, description)
    local textBox = uiElements['templateTextBox']:Clone()
    textBox.Visible = true
    textBox.Name = text .. 'TextBox'
    textBox.Parent = tab.container
    
    local textBoxTitle = textBox:FindFirstChild('templateTextBoxTitle')
    local textBoxDesc = textBox:FindFirstChild('templateTextBoxDescription')
    local inputFrame = textBox:FindFirstChild('templateTextBoxInputFrame')
    local inputBox = inputFrame:FindFirstChild('templateTextBoxInput')
    
    textBoxTitle.Text = text
    if description and description ~= '' then
        textBoxDesc.Text = description
        textBoxDesc.Visible = true
    end
    inputBox.PlaceholderText = placeholder or 'Enter text...'
    
    inputBox.FocusLost:Connect(function(enterPressed)
        if callback then
            callback(inputBox.Text, enterPressed)
        end
    end)
    
    table.insert(tab.elements, textBox)
    return textBox
end

function library:AddKeybind(tab, text, defaultKey, callback, description)
    local keybind = uiElements['templateKeybind']:Clone()
    keybind.Visible = true
    keybind.Name = text .. 'Keybind'
    keybind.Parent = tab.container
    
    local keybindTitle = keybind:FindFirstChild('templateKeybindTitle')
    local keybindDesc = keybind:FindFirstChild('templateKeybindDescription')
    local keybindButton = keybind:FindFirstChild('templateKeybindButton')
    
    keybindTitle.Text = text
    if description and description ~= '' then
        keybindDesc.Text = description
        keybindDesc.Visible = true
    end
    
    local key = defaultKey or Enum.KeyCode.None
    local waitingForKey = false
    
    local function updateKeybindText()
        if key == Enum.KeyCode.None then
            keybindButton.Text = '[None]'
        else
            keybindButton.Text = '[' .. key.Name .. ']'
        end
    end
    
    keybindButton.MouseButton1Click:Connect(function()
        waitingForKey = true
        keybindButton.Text = '[Press Key]'
    end)
    
    game:GetService('UserInputService').InputBegan:Connect(function(input, gameProcessed)
        if waitingForKey and input.UserInputType == Enum.UserInputType.Keyboard then
            key = input.KeyCode
            waitingForKey = false
            updateKeybindText()
            if callback then
                callback(key)
            end
        elseif not gameProcessed and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == key then
            if callback then
                callback(key)
            end
        end
    end)
    
    updateKeybindText()
    table.insert(tab.elements, keybind)
    return keybind
end

function library:AddColorPicker(tab, text, defaultColor, callback, description)
    local colorPicker = uiElements['templateColorPicker']:Clone()
    colorPicker.Visible = true
    colorPicker.Name = text .. 'ColorPicker'
    colorPicker.Parent = tab.container
    
    local colorPickerTitle = colorPicker:FindFirstChild('templateColorPickerTitle')
    local colorPickerDesc = colorPicker:FindFirstChild('templateColorPickerDescription')
    local colorPickerButton = colorPicker:FindFirstChild('templateColorPickerButton')
    local colorPreview = colorPickerButton:FindFirstChild('templateColorPickerPreview')
    
    colorPickerTitle.Text = text
    if description and description ~= '' then
        colorPickerDesc.Text = description
        colorPickerDesc.Visible = true
    end
    
    local color = defaultColor or Color3.fromRGB(255, 255, 255)
    colorPreview.BackgroundColor3 = color
    
    local function updateColor()
        colorPreview.BackgroundColor3 = color
        if callback then
            callback(color)
        end
    end
    
    colorPickerButton.MouseButton1Click:Connect(function()
        -- Show color picker dropdown (simplified - in real implementation would show full color picker)
        uiElements['dropdownSelection'].Visible = true
        uiElements['dropdownTitle'].Text = text .. ' Color Picker'
        -- Add color picker implementation here
    end)
    
    table.insert(tab.elements, colorPicker)
    return colorPicker
end

function library:AddDropdown(tab, text, options, default, callback, description)
    local dropdown = uiElements['templateDropdown']:Clone()
    dropdown.Visible = true
    dropdown.Name = text .. 'Dropdown'
    dropdown.Parent = tab.container
    
    local dropdownTitle = dropdown:FindFirstChild('templateDropdownTitle')
    local dropdownDesc = dropdown:FindFirstChild('templateDropdownDescription')
    local dropdownButton = dropdown:FindFirstChild('templateDropdownButton')
    local dropdownArrow = dropdownButton:FindFirstChild('templateDropdownArrow')
    
    dropdownTitle.Text = text
    if description and description ~= '' then
        dropdownDesc.Text = description
        dropdownDesc.Visible = true
    end
    
    local selected = default or options[1]
    dropdownButton.Text = selected
    
    local function updateDropdown()
        dropdownButton.Text = selected
        if callback then
            callback(selected)
        end
    end
    
    dropdownButton.MouseButton1Click:Connect(function()
        -- Show dropdown selection
        uiElements['dropdownSelection'].Visible = true
        uiElements['dropdownTitle'].Text = text
        
        -- Clear existing options
        for _, child in pairs(uiElements['dropdownContainer']:GetChildren()) do
            child:Destroy()
        end
        
        -- Add options
        for i, option in pairs(options) do
            local optionButton = Instance.new('TextButton')
            optionButton.Name = 'Option' .. i
            optionButton.Text = option
            optionButton.Size = UDim2.new(1, 0, 0, 30)
            optionButton.BackgroundTransparency = 1
            optionButton.TextColor3 = Color3.fromRGB(197, 204, 219)
            optionButton.TextXAlignment = Enum.TextXAlignment.Left
            optionButton.Font = Font.new('rbxassetid://11702779517', Enum.FontWeight.Medium, Enum.FontStyle.Normal)
            optionButton.TextSize = 14
            optionButton.Parent = uiElements['dropdownContainer']
            
            local optionPadding = Instance.new('UIPadding', optionButton)
            optionPadding.PaddingLeft = UDim.new(0, 10)
            
            optionButton.MouseButton1Click:Connect(function()
                selected = option
                updateDropdown()
                uiElements['dropdownSelection'].Visible = false
            end)
            
            optionButton.MouseEnter:Connect(function()
                optionButton.BackgroundTransparency = 0.8
                optionButton.BackgroundColor3 = Color3.fromRGB(61, 61, 75)
            end)
            
            optionButton.MouseLeave:Connect(function()
                optionButton.BackgroundTransparency = 1
            end)
        end
    end)
    
    uiElements['dropdownCloseButton'].MouseButton1Click:Connect(function()
        uiElements['dropdownSelection'].Visible = false
    end)
    
    table.insert(tab.elements, dropdown)
    return dropdown
end

function library:AddLabel(tab, text, description)
    local label = uiElements['templateParagraph']:Clone()
    label.Visible = true
    label.Name = text .. 'Label'
    label.Parent = tab.container
    
    local labelTitle = label:FindFirstChild('templateParagraphTitle')
    local labelDesc = label:FindFirstChild('templateParagraphDescription')
    
    labelTitle.Text = text
    if description and description ~= '' then
        labelDesc.Text = description
        labelDesc.Visible = true
    end
    
    table.insert(tab.elements, label)
    return label
end

-- Notification System
function library:Notify(title, content, duration, type)
    local notification = uiElements['templateNotification']:Clone()
    notification.Visible = true
    notification.Name = 'Notification_' .. #notifications
    notification.Parent = uiElements['notificationList']
    
    local notificationItems = notification:FindFirstChild('templateNotificationItems')
    local notificationTitle = notificationItems:FindFirstChild('templateNotificationTitle')
    local notificationContent = notificationItems:FindFirstChild('templateNotificationContentText')
    local notificationTimerBar = notificationItems:FindFirstChild('templateNotificationTimerBar')
    local notificationTimerBarInner = notificationTimerBar:FindFirstChild('templateNotificationTimerBarInner')
    
    notificationTitle.Text = title
    notificationContent.Text = content
    
    -- Set notification color based on type
    local colors = {
        info = Color3.fromRGB(59, 130, 246),
        success = Color3.fromRGB(34, 197, 94),
        warning = Color3.fromRGB(251, 146, 60),
        error = Color3.fromRGB(239, 68, 68)
    }
    
    local color = colors[type or 'info']
    notificationItems.BackgroundColor3 = color
    notificationTimerBar.BackgroundColor3 = color
    
    -- Close button
    local closeButton = notificationTitle:FindFirstChild('templateNotificationClose')
    closeButton.MouseButton1Click:Connect(function()
        library:RemoveNotification(notification)
    end)
    
    -- Auto-remove after duration
    if duration and duration > 0 then
        local startTime = tick()
        local connection
        connection = game:GetService('RunService').Heartbeat:Connect(function()
            local elapsed = tick() - startTime
            local remaining = math.max(0, duration - elapsed)
            local percentage = remaining / duration
            
            notificationTimerBarInner.Size = UDim2.new(percentage, 0, 1, 0)
            
            if remaining <= 0 then
                connection:Disconnect()
                library:RemoveNotification(notification)
            end
        end)
    end
    
    table.insert(notifications, notification)
    
    -- Animate in
    notification.Position = UDim2.new(1.5, 0, 0.5, 0)
    tween(notification, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.8244, 0, 0.88221, 0)
    })
    
    return notification
end

function library:RemoveNotification(notification)
    tween(notification, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Position = UDim2.new(1.5, 0, 0.5, 0)
    })
    
    game:GetService('Debris'):AddItem(notification, 0.3)
    
    for i, notif in pairs(notifications) do
        if notif == notification then
            table.remove(notifications, i)
            break
        end
    end
end

-- Window Dragging
uiElements['topFrame'].MouseButton1Down:Connect(function()
    dragging = true
    dragStart = game:GetService('UserInputService'):GetMouseLocation()
    startPos = uiElements['mainWindow'].Position
end)

uiElements['topFrame'].MouseButton1Up:Connect(function()
    dragging = false
end)

uiElements['topFrameClose'].MouseButton1Click:Connect(function()
    library:Toggle()
end)

uiElements['topFrameMinimize'].MouseButton1Click:Connect(function()
    library:Minimize()
end)

uiElements['topFrameMaximize'].MouseButton1Click:Connect(function()
    library:Maximize()
end)

game:GetService('UserInputService').InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        uiElements['mainWindow'].Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X, 
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
    end
end)

game:GetService('UserInputService').InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Dark overlay for dropdowns
uiElements['darkOverlay'].MouseButton1Click:Connect(function()
    uiElements['dropdownSelection'].Visible = false
    uiElements['darkOverlay'].Visible = false
end)

-- Library export
library.uiElements = uiElements
library.tabs = tabs
library.notifications = notifications

-- Set library module content
local libraryModule = uiElements['libraryModule']
local librarySource = "-- NatHub Library\n" ..
    "local library = " .. tostring(library) .. "\n" ..
    "return library"

libraryModule.Source = librarySource

return uiElements