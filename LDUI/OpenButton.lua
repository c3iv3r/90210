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
    DropdownFrame.BackgroundColor3 = CurrentTheme.ElementBackground
    DropdownFrame.Selectable = false
    DropdownFrame.AutomaticSize = Enum.AutomaticSize.Y
    DropdownFrame.Size = UDim2.new(1, 0, 0, 28)
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
    DropdownStroke.Color = CurrentTheme.ElementStroke
    DropdownStroke.Parent = DropdownFrame

    local DropdownPadding = Instance.new("UIPadding")
    DropdownPadding.PaddingTop = UDim.new(0, 6)
    DropdownPadding.PaddingRight = UDim.new(0, 8)
    DropdownPadding.PaddingLeft = UDim.new(0, 8)
    DropdownPadding.PaddingBottom = UDim.new(0, 6)
    DropdownPadding.Parent = DropdownFrame

    local DropdownLayout = Instance.new("UIListLayout")
    DropdownLayout.Padding = UDim.new(0, 3)
    DropdownLayout.SortOrder = Enum.SortOrder.LayoutOrder
    DropdownLayout.Parent = DropdownFrame

    -- Title Label
    local DropdownTitle = Instance.new("TextLabel")
    DropdownTitle.TextWrapped = true
    DropdownTitle.BorderSizePixel = 0
    DropdownTitle.TextSize = 14
    DropdownTitle.TextXAlignment = Enum.TextXAlignment.Left
    DropdownTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    DropdownTitle.Font = Enum.Font.GothamBold
    DropdownTitle.TextColor3 = Color3.fromRGB(197, 204, 219)
    DropdownTitle.BackgroundTransparency = 1
    DropdownTitle.Size = UDim2.new(1, 0, 0, 15)
    DropdownTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
    DropdownTitle.Text = DropdownData.Title
    DropdownTitle.Name = "Title"
    DropdownTitle.Position = UDim2.new(0.03135, 0, 0, 0)
    DropdownTitle.Parent = DropdownFrame

-- Value Display
local ValueDisplay = Instance.new("ImageButton")
ValueDisplay.Active = false
ValueDisplay.BorderSizePixel = 0
ValueDisplay.BackgroundTransparency = 1
ValueDisplay.Selectable = false
ValueDisplay.ZIndex = 0
ValueDisplay.AnchorPoint = Vector2.new(1, 0.5)
ValueDisplay.Size = UDim2.new(0, 80, 0, 20)  -- Fixed width
ValueDisplay.Name = "BoxFrame"
ValueDisplay.Position = UDim2.new(1, -5, 0.5, 0)
ValueDisplay.Parent = DropdownTitle

-- Value Display Shadow
local ValueShadow = Instance.new("ImageLabel")
ValueShadow.Interactable = false
ValueShadow.ZIndex = 0
ValueShadow.BorderSizePixel = 0
ValueShadow.SliceCenter = Rect.new(49, 49, 450, 450)
ValueShadow.ScaleType = Enum.ScaleType.Slice
ValueShadow.ImageTransparency = 0.75
ValueShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
ValueShadow.AnchorPoint = Vector2.new(0.5, 0.5)
ValueShadow.Image = "rbxassetid://6014261993"
ValueShadow.Size = UDim2.new(1, 30, 1, 30)
ValueShadow.Visible = false  -- Shadow visible
ValueShadow.BackgroundTransparency = 1
ValueShadow.Name = "DropShadow"
ValueShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
ValueShadow.Parent = ValueDisplay

-- Value Display Button
local ValueButton = Instance.new("ImageButton")
ValueButton.BorderSizePixel = 0
ValueButton.AutoButtonColor = false
ValueButton.BackgroundColor3 = CurrentTheme.TabContentBackground
ValueButton.Selectable = false
ValueButton.AnchorPoint = Vector2.new(0.5, 0.5)
ValueButton.Size = UDim2.new(1, 0, 1, 0)  -- Full size, no AutomaticSize
ValueButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
ValueButton.Name = "Trigger"
ValueButton.Position = UDim2.new(0.5, 0, 0.5, 0)
ValueButton.Parent = ValueDisplay

local ValueCorner = Instance.new("UICorner")
ValueCorner.CornerRadius = UDim.new(0, 0)
ValueCorner.Parent = ValueButton

local ValueStroke = Instance.new("UIStroke")
ValueStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ValueStroke.Thickness = 1
ValueStroke.Color = CurrentTheme.TabContentBackground
ValueStroke.Parent = ValueButton

local ValueLayout = Instance.new("UIListLayout")
ValueLayout.Padding = UDim.new(0, 5)
ValueLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
ValueLayout.VerticalAlignment = Enum.VerticalAlignment.Center
ValueLayout.SortOrder = Enum.SortOrder.LayoutOrder
ValueLayout.Parent = ValueButton

local ValueLabel = Instance.new("TextLabel")
ValueLabel.TextWrapped = false
ValueLabel.Interactable = false
ValueLabel.BorderSizePixel = 0
ValueLabel.TextSize = 12
ValueLabel.TextScaled = false
ValueLabel.TextTruncate = Enum.TextTruncate.AtEnd
ValueLabel.TextXAlignment = Enum.TextXAlignment.Left
ValueLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ValueLabel.Font = Enum.Font.GothamBold
ValueLabel.TextColor3 = Color3.fromRGB(197, 204, 219)
ValueLabel.BackgroundTransparency = 1
ValueLabel.AnchorPoint = Vector2.new(0, 0)
ValueLabel.Size = UDim2.new(1, -10, 0, 14)
ValueLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
ValueLabel.Text = ""
ValueLabel.Name = "Title"
ValueLabel.Position = UDim2.new(0, 0, 0, 0)
ValueLabel.Parent = ValueButton

-- Arrow Icon
local ArrowIcon = Instance.new("ImageLabel")
ArrowIcon.BorderSizePixel = 0
ArrowIcon.BackgroundTransparency = 1
ArrowIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ArrowIcon.ImageColor3 = Color3.fromRGB(197, 204, 219)
ArrowIcon.AnchorPoint = Vector2.new(1, 0.5)
ArrowIcon.Image = "rbxassetid://120292618616139"  -- Arrow down icon
ArrowIcon.Size = UDim2.new(0, 12, 0, 12)
ArrowIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
ArrowIcon.Name = "Arrow"
ArrowIcon.Position = UDim2.new(1, -3, 0.5, 0)
ArrowIcon.Rotation = 90
ArrowIcon.Parent = ValueDisplay
    
local ValuePadding = Instance.new("UIPadding")
ValuePadding.PaddingRight = UDim.new(0, 5)
ValuePadding.PaddingLeft = UDim.new(0, 3)
ValuePadding.Parent = ValueButton


    -- Description Label (if provided)
    local DescriptionLabel = nil
    if DropdownData.Desc and DropdownData.Desc ~= "" then
        DescriptionLabel = Instance.new("TextLabel")
        DescriptionLabel.TextWrapped = true
        DescriptionLabel.Interactable = false
        DescriptionLabel.BorderSizePixel = 0
        DescriptionLabel.TextSize = 12
        DescriptionLabel.TextTransparency = 0.5
        DescriptionLabel.TextXAlignment = Enum.TextXAlignment.Left
        DescriptionLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        DescriptionLabel.Font = Enum.Font.GothamBold
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
    local CloseDropdown = nil

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
    local displayText = FormatValueText(CurrentValue)
    
    -- Cek apakah ada value atau tidak
    if DropdownData.Multi then
        if type(CurrentValue) == "table" and #CurrentValue > 0 then
            ValueLabel.Text = displayText
            ValueLabel.TextColor3 = Color3.fromRGB(197, 204, 219)
        else
            ValueLabel.Text = "Select..." -- Placeholder manual
            ValueLabel.TextColor3 = Color3.fromRGB(140, 140, 140) -- Warna abu seperti placeholder
        end
    else
        if CurrentValue and CurrentValue ~= "" then
            ValueLabel.Text = displayText
            ValueLabel.TextColor3 = Color3.fromRGB(197, 204, 219)
        else
            ValueLabel.Text = "Select..." -- Placeholder manual
            ValueLabel.TextColor3 = Color3.fromRGB(140, 140, 140) -- Warna abu seperti placeholder
        end
    end
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

    -- Adjustment untuk CreateGlobalDropdownSystem()

local function CreateGlobalDropdownSystem()
    if GlobalDropdownSystem then return end

    local window = parent
    while window and window.Name ~= "Window" do
        window = window.Parent
    end

    if not window then return end

    -- Dark overlay
    DarkOverlay = Instance.new("TextButton")
    DarkOverlay.Visible = false
    DarkOverlay.BorderSizePixel = 0
    DarkOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    DarkOverlay.Size = UDim2.new(1, 0, 1, 0)
    DarkOverlay.BorderColor3 = Color3.fromRGB(0, 0, 0)
    DarkOverlay.Name = "DarkOverlay"
    DarkOverlay.BackgroundTransparency = 0.6
    DarkOverlay.Text = ""
    DarkOverlay.Active = true
    DarkOverlay.AutoButtonColor = false
    DarkOverlay.ZIndex = 50
    DarkOverlay.Parent = window

    local OverlayCorner = Instance.new("UICorner")
    OverlayCorner.CornerRadius = UDim.new(0, 10)
    OverlayCorner.Parent = DarkOverlay

    -- Popup
    DropdownPopup = Instance.new("Frame")
    DropdownPopup.Visible = false
    DropdownPopup.BorderSizePixel = 0
    DropdownPopup.BackgroundColor3 = CurrentTheme.TabContentBackground
    DropdownPopup.AnchorPoint = Vector2.new(1, 0)
    DropdownPopup.ClipsDescendants = true
    DropdownPopup.Size = UDim2.new(0, 140, 1, -70)
    DropdownPopup.Position = UDim2.new(1, -10, 0, 35)  -- Posisi final
    DropdownPopup.BorderColor3 = CurrentTheme.ElementStroke
    DropdownPopup.Name = "DropdownSelection"
    DropdownPopup.ZIndex = 51
    DropdownPopup.Parent = window

    local PopupCorner = Instance.new("UICorner")
    PopupCorner.CornerRadius = UDim.new(0, 6)
    PopupCorner.Parent = DropdownPopup

    local PopupStroke = Instance.new("UIStroke")
    PopupStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    PopupStroke.Thickness = 1.5
    PopupStroke.Color = CurrentTheme.ElementStroke
    PopupStroke.Parent = DropdownPopup

    -- Header (TANPA CLOSE BUTTON, hanya search)
    local PopupHeader = Instance.new("Frame")
    PopupHeader.BorderSizePixel = 0
    PopupHeader.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    PopupHeader.Size = UDim2.new(1, 0, 0, 40)  -- Lebih kecil
    PopupHeader.Position = UDim2.new(0, 0, 0, 0)
    PopupHeader.BorderColor3 = Color3.fromRGB(0, 0, 0)
    PopupHeader.Name = "TopBar"
    PopupHeader.BackgroundTransparency = 1
    PopupHeader.Parent = DropdownPopup

    local HeaderPadding = Instance.new("UIPadding")
    HeaderPadding.PaddingTop = UDim.new(0, 8)
    HeaderPadding.PaddingRight = UDim.new(0, 10)
    HeaderPadding.PaddingLeft = UDim.new(0, 10)
    HeaderPadding.PaddingBottom = UDim.new(0, 8)
    HeaderPadding.Parent = PopupHeader

    -- Search box (full width)
    local SearchFrame = Instance.new("Frame")
    SearchFrame.BorderSizePixel = 0
    SearchFrame.Size = UDim2.new(1, 0, 1, 0)
    SearchFrame.Name = "BoxFrame"
    SearchFrame.BackgroundTransparency = 1
    SearchFrame.Parent = PopupHeader

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

    local SearchContainer = Instance.new("Frame")
    SearchContainer.BorderSizePixel = 0
    SearchContainer.BackgroundColor3 = CurrentTheme.ElementBackground
    SearchContainer.Size = UDim2.new(1, 0, 1, 0)
    SearchContainer.BorderColor3 = Color3.fromRGB(0, 0, 0)
    SearchContainer.Parent = SearchFrame

    local SearchCorner = Instance.new("UICorner")
    SearchCorner.CornerRadius = UDim.new(0, 5)
    SearchCorner.Parent = SearchContainer

    local SearchStroke = Instance.new("UIStroke")
    SearchStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    SearchStroke.Thickness = 1.5
    SearchStroke.Color = CurrentTheme.ElementStroke
    SearchStroke.Parent = SearchContainer

    SearchBox = Instance.new("TextBox")
    SearchBox.TextXAlignment = Enum.TextXAlignment.Left
    SearchBox.BorderSizePixel = 0
    SearchBox.TextWrapped = false
    SearchBox.TextTruncate = Enum.TextTruncate.AtEnd
    SearchBox.TextSize = 11
    SearchBox.TextColor3 = Color3.fromRGB(197, 204, 219)
    SearchBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SearchBox.Font = Enum.Font.GothamBold
    SearchBox.ClipsDescendants = true
    SearchBox.PlaceholderText = "Search..."
    SearchBox.Size = UDim2.new(1, -28, 1, 0)
    SearchBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
    SearchBox.Text = ""
    SearchBox.BackgroundTransparency = 1
    SearchBox.Parent = SearchContainer

    local SearchPadding = Instance.new("UIPadding")
    SearchPadding.PaddingTop = UDim.new(0, 5)
    SearchPadding.PaddingRight = UDim.new(0, 5)
    SearchPadding.PaddingLeft = UDim.new(0, 6)
    SearchPadding.PaddingBottom = UDim.new(0, 5)
    SearchPadding.Parent = SearchBox

    local SearchIcon = Instance.new("ImageButton")
    SearchIcon.BorderSizePixel = 0
    SearchIcon.BackgroundTransparency = 1
    SearchIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SearchIcon.ImageColor3 = Color3.fromRGB(197, 204, 219)
    SearchIcon.AnchorPoint = Vector2.new(1, 0.5)
    SearchIcon.Image = "rbxassetid://86928976705683"
    SearchIcon.Size = UDim2.new(0, 14, 0, 14)
    SearchIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
    SearchIcon.Position = UDim2.new(1, -6, 0.5, 0)
    SearchIcon.Parent = SearchContainer

    -- Dropdowns folder
    local DropdownsFolder = Instance.new("Folder")
    DropdownsFolder.Name = "Dropdowns"
    DropdownsFolder.Parent = DropdownPopup

    local DropdownContainer = Instance.new("Folder")
    DropdownContainer.Name = DropdownData.Title
    DropdownContainer.Parent = DropdownsFolder

    -- Main list
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
    PopupList.Size = UDim2.new(1, 0, 1, -40)  -- Adjust for smaller header
    PopupList.ScrollBarImageColor3 = Color3.fromRGB(99, 106, 122)
    PopupList.Position = UDim2.new(0, 0, 0, 40)
    PopupList.BorderColor3 = Color3.fromRGB(0, 0, 0)
    PopupList.ScrollBarThickness = 5
    PopupList.BackgroundTransparency = 1
    PopupList.Parent = DropdownContainer

    -- Search list
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
    PopupListSearch.Size = UDim2.new(1, 0, 1, -40)
    PopupListSearch.ScrollBarImageColor3 = Color3.fromRGB(99, 106, 122)
    PopupListSearch.Position = UDim2.new(0, 0, 0, 40)
    PopupListSearch.BorderColor3 = Color3.fromRGB(0, 0, 0)
    PopupListSearch.ScrollBarThickness = 5
    PopupListSearch.BackgroundTransparency = 1
    PopupListSearch.Parent = DropdownContainer

    local ListLayout = Instance.new("UIListLayout")
    ListLayout.Padding = UDim.new(0, 4)
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Parent = PopupList

    local ListPadding = Instance.new("UIPadding")
    ListPadding.PaddingTop = UDim.new(0, 6)
    ListPadding.PaddingRight = UDim.new(0, 6)
    ListPadding.PaddingLeft = UDim.new(0, 6)
    ListPadding.PaddingBottom = UDim.new(0, 6)
    ListPadding.Parent = PopupList

    local SearchListLayout = Instance.new("UIListLayout")
    SearchListLayout.Padding = UDim.new(0, 4)
    SearchListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SearchListLayout.Parent = PopupListSearch

    local SearchListPadding = Instance.new("UIPadding")
    SearchListPadding.PaddingTop = UDim.new(0, 6)
    SearchListPadding.PaddingRight = UDim.new(0, 6)
    SearchListPadding.PaddingLeft = UDim.new(0, 6)
    SearchListPadding.PaddingBottom = UDim.new(0, 6)
    SearchListPadding.Parent = PopupListSearch

    local function SetPopupZIndex()
        for _, child in pairs(DropdownPopup:GetDescendants()) do
            if child:IsA("GuiObject") then
                child.ZIndex = 51
            end
        end
    end
    SetPopupZIndex()

    DarkOverlay.MouseButton1Click:Connect(function()
        CloseDropdown()
    end)

    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local searchText = SearchBox.Text
        if string.gsub(searchText, " ", "") ~= "" then
            PopupList.Visible = false
            PopupListSearch.Visible = true
            
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
        SearchBox = SearchBox,
        CurrentDropdown = nil
    }
end

    local function CreateDropdownItem(value, targetList)
    local ItemButton = Instance.new("ImageButton")
    ItemButton.BorderSizePixel = 0
    ItemButton.AutoButtonColor = false
    ItemButton.Visible = false
    ItemButton.BackgroundColor3 = CurrentTheme.SectionBackground
    ItemButton.Selectable = false
    ItemButton.AutomaticSize = Enum.AutomaticSize.Y
    ItemButton.Size = UDim2.new(1, 0, 0, 25)
    ItemButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ItemButton.Name = tostring(value)
    ItemButton.Position = UDim2.new(0, 0, 0.384, 0)
    ItemButton.Parent = targetList

    local ItemCorner = Instance.new("UICorner")
    ItemCorner.CornerRadius = UDim.new(0, 0)
    ItemCorner.Parent = ItemButton

    local ItemFrame = Instance.new("Frame")
    ItemFrame.BorderSizePixel = 0
    ItemFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ItemFrame.AutomaticSize = Enum.AutomaticSize.Y
    ItemFrame.Size = UDim2.new(1, 0, 0, 28)
    ItemFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ItemFrame.BackgroundTransparency = 1
    ItemFrame.Parent = ItemButton

    local ItemLayout = Instance.new("UIListLayout")
    ItemLayout.Padding = UDim.new(0, 3)
    ItemLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ItemLayout.Parent = ItemFrame

    local ItemPadding = Instance.new("UIPadding")
    ItemPadding.PaddingTop = UDim.new(0, 8)
    ItemPadding.PaddingRight = UDim.new(0, 0)
    ItemPadding.PaddingLeft = UDim.new(0, 15)  -- Beri space untuk bar
    ItemPadding.PaddingBottom = UDim.new(0, 0)
    ItemPadding.Parent = ItemFrame

    local ItemTitle = Instance.new("TextLabel")
    ItemTitle.TextWrapped = true
    ItemTitle.Interactable = false
    ItemTitle.BorderSizePixel = 0
    ItemTitle.TextSize = 12
    ItemTitle.TextXAlignment = Enum.TextXAlignment.Left
    ItemTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ItemTitle.Font = Enum.Font.GothamBold
    ItemTitle.TextColor3 = Color3.fromRGB(197, 204, 219)
    ItemTitle.BackgroundTransparency = 1
    ItemTitle.Size = UDim2.new(1, 0, 0, 13)
    ItemTitle.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ItemTitle.Text = tostring(value)
    ItemTitle.Name = "Title"
    ItemTitle.Parent = ItemFrame

    local ItemDescription = Instance.new("TextLabel")
    ItemDescription.TextWrapped = true
    ItemDescription.Interactable = false
    ItemDescription.BorderSizePixel = 0
    ItemDescription.TextSize = 11
    ItemDescription.TextXAlignment = Enum.TextXAlignment.Left
    ItemDescription.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ItemDescription.Font = Enum.Font.GothamBold
    ItemDescription.TextColor3 = Color3.fromRGB(197, 204, 219)
    ItemDescription.BackgroundTransparency = 1
    ItemDescription.Size = UDim2.new(1, 0, 0, 11)
    ItemDescription.Visible = false
    ItemDescription.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ItemDescription.Text = ""
    ItemDescription.LayoutOrder = 1
    ItemDescription.AutomaticSize = Enum.AutomaticSize.Y
    ItemDescription.Name = "Description"
    ItemDescription.Parent = ItemFrame

    local ItemStroke = Instance.new("UIStroke")
    ItemStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    ItemStroke.Thickness = 1
    ItemStroke.Color = CurrentTheme.ElementStroke
    ItemStroke.Parent = ItemButton

    -- Bar indicator (seperti tab bar)
    local ItemBar = Instance.new("Frame")
    ItemBar.BorderSizePixel = 0
    ItemBar.BackgroundColor3 = CurrentTheme.AccentPrimary
    ItemBar.AnchorPoint = Vector2.new(0, 0.5)
    ItemBar.Size = UDim2.new(0, 3, 0, 0)  -- Start with 0 height
    ItemBar.Position = UDim2.new(0, 8, 0.5, 0)
    ItemBar.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ItemBar.Name = "Bar"
    ItemBar.BackgroundTransparency = 1
    ItemBar.Parent = ItemButton

    local ItemBarCorner = Instance.new("UICorner")
    ItemBarCorner.CornerRadius = UDim.new(0, 100)
    ItemBarCorner.Parent = ItemBar

    local ItemFrameCorner = Instance.new("UICorner")
    ItemFrameCorner.CornerRadius = UDim.new(0, 6)
    ItemFrameCorner.Parent = ItemFrame

    ItemButton.Visible = true

        --[[-- Item gradients (matching OGLIB style)
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
        GetRandomGradient(ItemFrame)]]

        -- Update visual based on selection
       local function UpdateItemVisual()
        local isSelected = false
        if DropdownData.Multi then
            isSelected = table.find(CurrentValue, value) ~= nil
        else
            isSelected = CurrentValue == value
        end

        if isSelected then
            -- Active state (seperti active tab)
            CreateTween(ItemTitle, {
                TextTransparency = 0,
                TextColor3 = Color3.fromRGB(197, 204, 219)
            }, AnimationConfig.Global)
            CreateTween(ItemDescription, {
                TextTransparency = 0
            }, AnimationConfig.Global)
            CreateTween(ItemBar, {
                Size = UDim2.new(0, 3, 0, 15),  -- Bar muncul
                BackgroundTransparency = 0
            }, AnimationConfig.Global)
        else
            -- Inactive state (seperti inactive tab)
            CreateTween(ItemTitle, {
                TextTransparency = 0.5,
                TextColor3 = Color3.fromRGB(197, 204, 219)
            }, AnimationConfig.Global)
            CreateTween(ItemDescription, {
                TextTransparency = 0.5
            }, AnimationConfig.Global)
            CreateTween(ItemBar, {
                Size = UDim2.new(0, 3, 0, 0),  -- Bar hilang
                BackgroundTransparency = 1
            }, AnimationConfig.Global)
        end
    end

        -- Item click handler
        ItemButton.MouseButton1Click:Connect(function()
        if not DropdownData.Locked then
            if DropdownData.Multi then
                local index = table.find(CurrentValue, value)
                if index then
                    if not DropdownData.AllowNone and #CurrentValue == 1 then
                        return
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
            UpdateItemVisual()
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

    GlobalDropdownSystem.CurrentDropdown = DropdownData.Title
    GlobalDropdownSystem.SearchBox.Text = ""
    
    PopupList.Visible = true
    PopupListSearch.Visible = false

    RefreshDropdownItems()
    
    -- Simple fade in (NO POSITION ANIMATION)
    GlobalDropdownSystem.Overlay.BackgroundTransparency = 1
    GlobalDropdownSystem.Overlay.Visible = true
    GlobalDropdownSystem.Popup.BackgroundTransparency = 1
    GlobalDropdownSystem.Popup.Visible = true
    
    -- Single smooth tween
    CreateTween(GlobalDropdownSystem.Overlay, {BackgroundTransparency = 0.6}, {Duration = 0.2})
    CreateTween(GlobalDropdownSystem.Popup, {BackgroundTransparency = 0}, {Duration = 0.2})
    
    IsDropdownOpen = true
end

function CloseDropdown()
    if not GlobalDropdownSystem then return end
    
    -- Simple fade out (NO POSITION ANIMATION)
    local overlayTween = CreateTween(GlobalDropdownSystem.Overlay, {BackgroundTransparency = 1}, {Duration = 0.15})
    CreateTween(GlobalDropdownSystem.Popup, {BackgroundTransparency = 1}, {Duration = 0.15})
    
    overlayTween.Completed:Wait()
    GlobalDropdownSystem.Overlay.Visible = false
    GlobalDropdownSystem.Popup.Visible = false
    
    IsDropdownOpen = false
    GlobalDropdownSystem.CurrentDropdown = nil
end

    -- Handle hover effects (matching OGLIB)
    DropdownFrame.MouseEnter:Connect(function()
        if not DropdownData.Locked then
            CreateTween(DropdownStroke, {Color = CurrentTheme.ElementStroke}, AnimationConfig.Global)
        end
    end)

    DropdownFrame.MouseLeave:Connect(function()
        if not DropdownData.Locked then
            CreateTween(DropdownStroke, {Color = CurrentTheme.ElementStroke}, AnimationConfig.Global)
        end
    end)

    -- Apply locked state
    if DropdownData.Locked then
        DropdownStroke.Color = Color3.fromRGB(47, 47, 58)
        DropdownFrame.BackgroundColor3 = CurrentTheme.TabContentBackground
        DropdownTitle.TextColor3 = Color3.fromRGB(75, 77, 83)
        if DescriptionLabel then
            DescriptionLabel.TextColor3 = Color3.fromRGB(75, 77, 83)
        end
        ValueButton.BackgroundColor3 = CurrentTheme.TabContentBackground
        ValueStroke.Color = Color3.fromRGB(47, 47, 58)
        ValueLabel.TextColor3 = Color3.fromRGB(75, 77, 83)
        DropdownFrame.Active = false
        DropdownFrame.Interactable = false
    end

    -- Update initial display
    UpdateValueDisplay()

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
            DescriptionLabel.TextSize = 12
            DescriptionLabel.TextXAlignment = Enum.TextXAlignment.Left
            DescriptionLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            DescriptionLabel.Font = Enum.Font.GothamBold
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
        CreateTween(DropdownFrame, {BackgroundColor3 = CurrentTheme.TabContentBackground}, AnimationConfig.Global)
        CreateTween(DropdownTitle, {TextColor3 = Color3.fromRGB(75, 77, 83)}, AnimationConfig.Global)
        if DescriptionLabel then
            CreateTween(DescriptionLabel, {TextColor3 = Color3.fromRGB(75, 77, 83)}, AnimationConfig.Global)
        end
        CreateTween(ValueButton, {BackgroundColor3 = CurrentTheme.TabContentBackground}, AnimationConfig.Global)
        CreateTween(ValueStroke, {Color = Color3.fromRGB(47, 47, 58)}, AnimationConfig.Global)
        CreateTween(ValueLabel, {TextColor3 = Color3.fromRGB(75, 77, 83)}, AnimationConfig.Global)
        DropdownFrame.Active = false
        DropdownFrame.Interactable = false
    end

    function DropdownMethods:Unlock()
        DropdownData.Locked = false
        CreateTween(DropdownStroke, {Color = CurrentTheme.ElementStroke}, AnimationConfig.Global)
        CreateTween(DropdownFrame, {BackgroundColor3 = CurrentTheme.ElementBackground}, AnimationConfig.Global)
        CreateTween(DropdownTitle, {TextColor3 = Color3.fromRGB(196, 203, 218)}, AnimationConfig.Global)
        if DescriptionLabel then
            CreateTween(DescriptionLabel, {TextColor3 = Color3.fromRGB(196, 203, 218)}, AnimationConfig.Global)
        end
        CreateTween(ValueButton, {BackgroundColor3 = CurrentTheme.ElementBackground}, AnimationConfig.Global)
        CreateTween(ValueStroke, {Color = CurrentTheme.ElementStroke}, AnimationConfig.Global)
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