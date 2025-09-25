-- Window.lua
-- UI Window module (match Library.txt style & layout)
-- Usage (unchanged):
-- local Window = Library:CreateWindow({ Title = "...", Subtitle = "...", Icon = "rbxassetid://...", Size = UDim2.fromOffset(528,334), Resizeable = true, OnDestroy = function() end })

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local FONT = Font.new("rbxassetid://11702779517", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
local FONT_MED = Font.new("rbxassetid://11702779517", Enum.FontWeight.Medium, Enum.FontStyle.Normal)

local COLORS = {
	WindowBg      = Color3.fromRGB(37, 40, 47),
	ContentBg     = Color3.fromRGB(32, 35, 41),
	SidebarBg     = Color3.fromRGB(37, 40, 47),
	ObjectBg      = Color3.fromRGB(43, 46, 53),
	Stroke        = Color3.fromRGB(61, 61, 75),
	TopText       = Color3.fromRGB(197, 204, 219),
	TopDim        = Color3.fromRGB(135, 140, 150),
	StrokeSoft    = Color3.fromRGB(95, 95, 117),
	Scrollbar     = Color3.fromRGB(99, 106, 122),
}

local EASE_GLOBAL = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local EASE_OPEN   = TweenInfo.new(0.40, Enum.EasingStyle.Back,  Enum.EasingDirection.Out)
local EASE_CLOSE  = TweenInfo.new(0.40, Enum.EasingStyle.Back,  Enum.EasingDirection.In)

local function tween(o, p, info)
	return TweenService:Create(o, info or EASE_GLOBAL, p)
end

local function dragify(dragArea, root)
	local dragging, dragStart, startPos
	dragArea.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = root.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	UIS.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			root.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

local function makeIcon(id)
	local img = Instance.new("ImageButton")
	img.AutoButtonColor = false
	img.BackgroundTransparency = 1
	img.Image = id or ""
	img.Size = UDim2.fromOffset(25, 25)
	img.ImageColor3 = COLORS.TopText
	img.BorderSizePixel = 0
	return img
end

local Module = {}

function Module.new(opts)
	opts = opts or {}
	opts.Title = tostring(opts.Title or "Window")
	opts.Subtitle = tostring(opts.Subtitle or "")
	opts.Icon = tostring(opts.Icon or "")
	opts.Size = opts.Size or UDim2.fromOffset(528, 334)
	opts.Resizeable = (opts.Resizeable ~= false)
	opts.OnDestroy = typeof(opts.OnDestroy) == "function" and opts.OnDestroy or function() end

	-- ROOT
	local gui = Instance.new("ScreenGui")
	gui.Name = "NatHub"
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.ResetOnSpawn = false
	if syn and syn.protect_gui then
		syn.protect_gui(gui)
	end
	local ok = pcall(function() game:GetService("CoreGui"):GetChildren() end)
	if gethui then
		gui.Parent = gethui()
	elseif ok then
		gui.Parent = game:GetService("CoreGui")
	else
		gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
	end

	-- WINDOW
	local root = Instance.new("Frame")
	root.Name = "Window"
	root.BackgroundColor3 = COLORS.WindowBg
	root.Size = opts.Size
	root.Position = UDim2.new(0.5, 0, 0.5, 0)
	root.AnchorPoint = Vector2.new(0.5, 0.5)
	root.BorderSizePixel = 2
	root.BorderColor3 = COLORS.Stroke
	root.Parent = gui

	local rootCorner = Instance.new("UICorner", root)
	rootCorner.CornerRadius = UDim.new(0, 10)

	local rootStroke = Instance.new("UIStroke", root)
	rootStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	rootStroke.Transparency = 0.5
	rootStroke.Color = COLORS.StrokeSoft

	-- TOP BAR
	local top = Instance.new("Frame")
	top.Name = "TopFrame"
	top.BackgroundColor3 = COLORS.SidebarBg
	top.Size = UDim2.new(1, 0, 0, 35)
	top.Parent = root
	Instance.new("UICorner", top).CornerRadius = UDim.new(0, 6)

	local topBorder = Instance.new("Frame")
	topBorder.Name = "Border"
	topBorder.ZIndex = 2
	topBorder.BackgroundColor3 = COLORS.Stroke
	topBorder.Size = UDim2.new(1, 0, 0, 2)
	topBorder.Position = UDim2.new(0, 0, 1, 0)
	topBorder.BorderSizePixel = 0
	topBorder.Parent = top

	local icon = makeIcon(opts.Icon)
	icon.Name = "Icon"
	icon.Position = UDim2.new(0, 10, 0.5, 0)
	icon.AnchorPoint = Vector2.new(0, 0.5)
	icon.Parent = top
	local iconAR = Instance.new("UIAspectRatioConstraint", icon)

	local title = Instance.new("TextLabel")
	title.Name = "TextLabel"
	title.BackgroundTransparency = 1
	title.Size = UDim2.new(1, 0, 0, 16)
	title.Position = UDim2.new(0.5, 0, 0.5, -1)
	title.AnchorPoint = Vector2.new(0.5, 0.5)
	title.FontFace = FONT
	title.TextScaled = true
	title.Text = opts.Title
	title.TextColor3 = COLORS.TopText
	title.Parent = top

	local btnClose = makeIcon("rbxassetid://132453323679056")
	btnClose.Name = "Close"
	btnClose.Size = UDim2.fromOffset(20, 20)
	btnClose.Position = UDim2.new(1, -15, 0.5, 0)
	btnClose.AnchorPoint = Vector2.new(1, 0.5)
	btnClose.Parent = top

	local btnMax = makeIcon("rbxassetid://108285848026510")
	btnMax.Name = "Maximize"
	btnMax.Size = UDim2.fromOffset(15, 15)
	btnMax.Position = UDim2.new(1, -55, 0.5, 0)
	btnMax.AnchorPoint = Vector2.new(1, 0.5)
	btnMax.Parent = top

	local btnHide = makeIcon("rbxassetid://128209591224511")
	btnHide.Name = "Hide"
	btnHide.Size = UDim2.fromOffset(20, 20)
	btnHide.Position = UDim2.new(1, -90, 0.5, 0)
	btnHide.AnchorPoint = Vector2.new(1, 0.5)
	btnHide.Parent = top

	-- SIDEBAR
	local side = Instance.new("Frame")
	side.Name = "TabButtons"
	side.BackgroundColor3 = COLORS.SidebarBg
	side.Size = UDim2.new(0, 165, 1, -35)
	side.Position = UDim2.new(0, 0, 0, 35)
	side.Parent = root
	Instance.new("UICorner", side).CornerRadius = UDim.new(0, 6)

	local sideBorder = Instance.new("Frame")
	sideBorder.BackgroundColor3 = COLORS.Stroke
	sideBorder.Size = UDim2.new(0, 2, 1, 0)
	sideBorder.AnchorPoint = Vector2.new(1, 0)
	sideBorder.Position = UDim2.new(1, 0, 0, 0)
	sideBorder.ZIndex = 2
	sideBorder.BorderSizePixel = 0
	sideBorder.Name = "Border"
	sideBorder.Parent = side

	local lists = Instance.new("ScrollingFrame")
	lists.Name = "Lists"
	lists.Active = true
	lists.ScrollingDirection = Enum.ScrollingDirection.Y
	lists.AutomaticCanvasSize = Enum.AutomaticSize.Y
	lists.CanvasSize = UDim2.new(0,0,0,0)
	lists.ScrollBarThickness = 4
	lists.ScrollBarImageColor3 = COLORS.Scrollbar
	lists.BackgroundTransparency = 1
	lists.Size = UDim2.new(1, 0, 1, 0)
	lists.Parent = side

	local listsLayout = Instance.new("UIListLayout", lists)
	listsLayout.SortOrder = Enum.SortOrder.LayoutOrder

	local listsPad = Instance.new("UIPadding", lists)
	listsPad.PaddingTop = UDim.new(0, 8)

	-- TAB CONTAINER
	local tabs = Instance.new("Frame")
	tabs.Name = "Tabs"
	tabs.BackgroundColor3 = COLORS.ContentBg
	tabs.Size = UDim2.new(1, -165, 1, -35)
	tabs.Position = UDim2.new(0, 165, 0, 35)
	tabs.Parent = root
	Instance.new("UICorner", tabs).CornerRadius = UDim.new(0, 6)

	local emptyText = Instance.new("TextLabel")
	emptyText.Name = "NoObjectFoundText"
	emptyText.BackgroundTransparency = 1
	emptyText.Visible = false
	emptyText.Size = UDim2.new(1, 0, 0, 16)
	emptyText.Position = UDim2.new(0.5, 0, 0.45, 0)
	emptyText.AnchorPoint = Vector2.new(0.5, 0.5)
	emptyText.FontFace = FONT
	emptyText.TextScaled = true
	emptyText.Text = "This tab is empty :("
	emptyText.TextColor3 = COLORS.TopDim
	emptyText.Parent = tabs

	-- OVERLAY + DROPDOWN SELECTION PANEL
	local overlay = Instance.new("Frame")
	overlay.Name = "DarkOverlay"
	overlay.Visible = false
	overlay.BackgroundColor3 = Color3.new(0,0,0)
	overlay.BackgroundTransparency = 0.6
	overlay.Size = UDim2.fromScale(1,1)
	overlay.Parent = root
	Instance.new("UICorner", overlay).CornerRadius = UDim.new(0, 10)

	local dropSel = Instance.new("Frame")
	dropSel.Name = "DropdownSelection"
	dropSel.Visible = false
	dropSel.BackgroundColor3 = COLORS.ContentBg
	dropSel.AnchorPoint = Vector2.new(0.5, 0.5)
	dropSel.Position = UDim2.fromScale(0.5, 0.5)
	dropSel.Size = UDim2.new(0.7281, 0, 0.68367, 0)
	dropSel.Parent = root
	Instance.new("UICorner", dropSel).CornerRadius = UDim.new(0, 6)
	local dropSelStroke = Instance.new("UIStroke", dropSel)
	dropSelStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	dropSelStroke.Thickness = 1.5
	dropSelStroke.Color = COLORS.Stroke

	local dropTop = Instance.new("Frame")
	dropTop.Name = "TopBar"
	dropTop.BackgroundTransparency = 1
	dropTop.Size = UDim2.new(1, 0, 0, 50)
	dropTop.Parent = dropSel

	local searchBoxFrame = Instance.new("Frame")
	searchBoxFrame.Name = "BoxFrame"
	searchBoxFrame.BackgroundTransparency = 1
	searchBoxFrame.Size = UDim2.new(0, 120, 0, 25)
	searchBoxFrame.AnchorPoint = Vector2.new(1, 0.5)
	searchBoxFrame.Position = UDim2.new(1, -50, 0.5, 0)
	searchBoxFrame.Parent = dropTop

	local sbShadow = Instance.new("ImageLabel")
	sbShadow.Name = "DropShadow"
	sbShadow.BackgroundTransparency = 1
	sbShadow.Image = "rbxassetid://6014261993"
	sbShadow.ImageColor3 = Color3.new(0,0,0)
	sbShadow.ImageTransparency = 0.75
	sbShadow.ScaleType = Enum.ScaleType.Slice
	sbShadow.SliceCenter = Rect.new(49,49,450,450)
	sbShadow.AnchorPoint = Vector2.new(0.5,0.5)
	sbShadow.Size = UDim2.new(1, 30, 1, 30)
	sbShadow.Position = UDim2.new(0.5,0,0.5,0)
	sbShadow.ZIndex = 0
	sbShadow.Parent = searchBoxFrame

	local sbFrame = Instance.new("Frame")
	sbFrame.BackgroundColor3 = COLORS.ObjectBg
	sbFrame.AutomaticSize = Enum.AutomaticSize.Y
	sbFrame.Size = UDim2.new(1,0,1,0)
	sbFrame.Parent = searchBoxFrame
	Instance.new("UICorner", sbFrame).CornerRadius = UDim.new(0, 5)
	local sbStroke = Instance.new("UIStroke", sbFrame)
	sbStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	sbStroke.Thickness = 1.5
	sbStroke.Color = COLORS.Stroke

	local sb = Instance.new("TextBox")
	sb.BackgroundTransparency = 1
	sb.Size = UDim2.new(1, -25, 1, 0)
	sb.Text = ""
	sb.PlaceholderText = "Input here..."
	sb.TextSize = 14
	sb.TextColor3 = COLORS.TopText
	sb.TextXAlignment = Enum.TextXAlignment.Left
	sb.FontFace = FONT_MED
	sb.Parent = sbFrame
	local sbPad = Instance.new("UIPadding", sb)
	sbPad.PaddingTop = UDim.new(0,10)
	sbPad.PaddingBottom = UDim.new(0,10)
	sbPad.PaddingLeft = UDim.new(0,10)
	sbPad.PaddingRight = UDim.new(0,10)

	local sbClear = makeIcon("rbxassetid://86928976705683")
	sbClear.Name = "Clear"
	sbClear.Size = UDim2.fromOffset(15,15)
	sbClear.Position = UDim2.new(1, -5, 0.5, 0)
	sbClear.AnchorPoint = Vector2.new(1,0.5)
	sbClear.ImageColor3 = COLORS.TopText
	sbClear.Parent = sbFrame

	local dropClose = makeIcon("rbxassetid://132453323679056")
	dropClose.Name = "Close"
	dropClose.Size = UDim2.fromOffset(25,25)
	dropClose.Position = UDim2.new(1, -12, 0.5, 0)
	dropClose.AnchorPoint = Vector2.new(1,0.5)
	dropClose.Parent = dropTop

	local dropTitle = Instance.new("TextLabel")
	dropTitle.Name = "Title"
	dropTitle.BackgroundTransparency = 1
	dropTitle.Size = UDim2.new(0.5, 0, 0, 18)
	dropTitle.Position = UDim2.new(0, 12, 0.5, 0)
	dropTitle.AnchorPoint = Vector2.new(0,0.5)
	dropTitle.FontFace = FONT
	dropTitle.TextScaled = true
	dropTitle.TextXAlignment = Enum.TextXAlignment.Left
	dropTitle.Text = "Dropdown"
	dropTitle.TextColor3 = COLORS.TopText
	dropTitle.Parent = dropTop

	local dropFolders = Instance.new("Folder")
	dropFolders.Name = "Dropdowns"
	dropFolders.Parent = dropSel

	-- NOTIFICATION HOST (stub, visual parity)
	local notifHost = Instance.new("Frame")
	notifHost.Name = "NotificationFrame"
	notifHost.BackgroundTransparency = 1
	notifHost.Size = UDim2.fromScale(1,1)
	notifHost.Parent = root
	local notifList = Instance.new("Frame")
	notifList.Name = "NotificationList"
	notifList.BackgroundTransparency = 1
	notifList.AnchorPoint = Vector2.new(0.5,0)
	notifList.Size = UDim2.new(0,630,1,-35)
	notifList.Position = UDim2.new(1,0,0,35)
	notifList.ZIndex = 5
	notifList.Parent = notifHost
	local notifLayout = Instance.new("UIListLayout", notifList)
	notifLayout.Padding = UDim.new(0,12)
	local notifPad = Instance.new("UIPadding", notifList)
	notifPad.PaddingTop = UDim.new(0,10)
	notifPad.PaddingLeft = UDim.new(0,40)
	notifPad.PaddingRight = UDim.new(0,40)

	-- INTERNAL STATE
	local state = {
		_tabs = {},
		_activeTab = nil,
		_dropdownOpen = false,
		_dropdownCurrent = nil,
	}

	-- FUNCTIONS

	local function setEmptyHint()
		local t = state._activeTab and state._tabs[state._activeTab]
		if not t then emptyText.Visible = false return end
		local n = 0
		for _, child in ipairs(t.container:GetChildren()) do
			if child:IsA("GuiObject") then n += 1 end
		end
		emptyText.Visible = (n == 0)
	end

	local function selectTab(name)
		for n, info in pairs(state._tabs) do
			if n == name then
				state._activeTab = n
				info.container.Visible = true
				tween(info.button.Label, {Position = UDim2.new(0,57,0.5,0), Size = UDim2.new(0,88,0,16), TextTransparency = 0}, EASE_GLOBAL):Play()
				tween(info.button.Icon,   {Position = UDim2.new(0,25,0,18), ImageTransparency = 0}, EASE_GLOBAL):Play()
				tween(info.button.Bar,    {Size = UDim2.new(0,5,0,25), BackgroundTransparency = 0}, EASE_GLOBAL):Play()
			else
				info.container.Visible = false
				tween(info.button.Label, {Position = UDim2.new(0,42,0.5,0), Size = UDim2.new(0,103,0,16), TextTransparency = 0.5}, EASE_GLOBAL):Play()
				tween(info.button.Icon,   {Position = UDim2.new(0,12,0,18), ImageTransparency = 0.5}, EASE_GLOBAL):Play()
				tween(info.button.Bar,    {Size = UDim2.new(0,5,0,0), BackgroundTransparency = 1}, EASE_GLOBAL):Play()
			end
		end
		setEmptyHint()
	end

	local function createTabButton(name, iconId)
		local holder = Instance.new("ImageButton")
		holder.Name = "TabButton"
		holder.AutoButtonColor = false
		holder.BackgroundTransparency = 1
		holder.Selectable = false
		holder.Size = UDim2.new(1,0,0,36)
		holder.Parent = lists

		local bar = Instance.new("Frame")
		bar.Name = "Bar"
		bar.AnchorPoint = Vector2.new(0,0.5)
		bar.Position = UDim2.new(0,8,0,18)
		bar.Size = UDim2.new(0,5,0,0)
		bar.BackgroundColor3 = COLORS.TopText
		bar.Parent = holder
		local barCorner = Instance.new("UICorner", bar)
		barCorner.CornerRadius = UDim.new(0,100)

		local ic = makeIcon(iconId or "rbxassetid://113216930555884")
		ic.ImageTransparency = 0.5
		ic.Position = UDim2.new(0,6,0,18)
		ic.AnchorPoint = Vector2.new(0,0.5)
		ic.Size = UDim2.fromOffset(31,30)
		ic.Parent = holder
		Instance.new("UIAspectRatioConstraint", ic)

		local lbl = Instance.new("TextLabel")
		lbl.Name = "Label"
		lbl.BackgroundTransparency = 1
		lbl.Size = UDim2.new(0,103,0,16)
		lbl.Position = UDim2.new(0,42,0.5,0)
		lbl.AnchorPoint = Vector2.new(0,0.5)
		lbl.FontFace = FONT_MED
		lbl.TextXAlignment = Enum.TextXAlignment.Left
		lbl.TextScaled = true
		lbl.TextColor3 = COLORS.TopText
		lbl.TextTransparency = 0.5
		lbl.Text = name
		lbl.Parent = holder

		return holder, bar, ic, lbl
	end

	local function createTabContainer(name)
		local scroller = Instance.new("ScrollingFrame")
		scroller.Name = name
		scroller.Active = true
		scroller.ScrollingDirection = Enum.ScrollingDirection.Y
		scroller.AutomaticCanvasSize = Enum.AutomaticSize.Y
		scroller.CanvasSize = UDim2.new(0,0,0,0)
		scroller.BackgroundTransparency = 1
		scroller.ScrollBarThickness = 5
		scroller.ScrollBarImageColor3 = COLORS.Scrollbar
		scroller.Size = UDim2.fromScale(1,1)
		scroller.Visible = false
		scroller.Parent = tabs

		local layout = Instance.new("UIListLayout", scroller)
		layout.Padding = UDim.new(0,15)
		layout.SortOrder = Enum.SortOrder.LayoutOrder

		local pad = Instance.new("UIPadding", scroller)
		pad.PaddingTop = UDim.new(0,10)
		pad.PaddingBottom = UDim.new(0,10)
		pad.PaddingLeft = UDim.new(0,10)
		pad.PaddingRight = UDim.new(0,14)

		return scroller
	end

	-- PUBLIC API
	local API = {}

	function API:AddTab(tabOpts)
		tabOpts = tabOpts or {}
		local name = tostring(tabOpts.Title or "Tab")
		local iconId = tabOpts.Icon

		local btn, bar, ic, lbl = createTabButton(name, iconId)
		local container = createTabContainer(name)

		btn.MouseButton1Click:Connect(function()
			selectTab(name)
		end)

		local info = {
			button = {Holder = btn, Bar = bar, Icon = ic, Label = lbl},
			container = container,
		}
		state._tabs[name] = info

		if not state._activeTab then
			selectTab(name)
		else
			setEmptyHint()
		end

		return container -- return the ScrollingFrame for content injection
	end

	function API:OpenDropdown(titleText, folderNameToShow)
		state._dropdownCurrent = folderNameToShow
		dropTitle.Text = titleText or "Dropdown"
		dropSel.Visible = true
		overlay.Visible = true
		overlay.BackgroundTransparency = 1
		tween(overlay, {BackgroundTransparency = 0.6}, EASE_OPEN):Play()
		state._dropdownOpen = true
	end

	function API:CloseDropdown()
		if not state._dropdownOpen then return end
		local tw = tween(overlay, {BackgroundTransparency = 1}, EASE_CLOSE)
		tw.Completed:Once(function()
			overlay.Visible = false
			dropSel.Visible = false
		end)
		tw:Play()
		state._dropdownOpen = false
	end

	function API:GetGui()
		return gui
	end

	function API:GetRoot()
		return root
	end

	function API:Destroy()
		gui:Destroy()
		opts.OnDestroy()
	end

	-- INTERACTION (drag, buttons, resize)
	dragify(top, root)

	local isMax = false
	local cacheSize, cachePos = root.Size, root.Position
	btnMax.MouseButton1Click:Connect(function()
		isMax = not isMax
		if isMax then
			cacheSize, cachePos = root.Size, root.Position
			tween(root, {Size = UDim2.fromScale(0.95, 0.9), Position = UDim2.fromScale(0.5,0.5)}, EASE_GLOBAL):Play()
		else
			tween(root, {Size = cacheSize, Position = cachePos}, EASE_GLOBAL):Play()
		end
	end)

	btnHide.MouseButton1Click:Connect(function()
		tween(root, {Position = UDim2.new(root.Position.X.Scale, root.Position.X.Offset, 1.25, 0)}, EASE_GLOBAL):Play()
		task.delay(0.25, function()
			tween(root, {Position = UDim2.new(root.Position.X.Scale, root.Position.X.Offset, 0.5, 0)}, EASE_GLOBAL):Play()
		end)
	end)

	btnClose.MouseButton1Click:Connect(function()
		opts.OnDestroy()
		gui:Destroy()
	end)

	dropClose.MouseButton1Click:Connect(function()
		API:CloseDropdown()
	end)
	sbClear.MouseButton1Click:Connect(function()
		sb.Text = ""
	end)

	-- RESIZER (bottom-right)
	if opts.Resizeable then
		local resizer = Instance.new("Frame")
		resizer.AnchorPoint = Vector2.new(1,1)
		resizer.Size = UDim2.fromOffset(14,14)
		resizer.Position = UDim2.new(1,-2,1,-2)
		resizer.BackgroundTransparency = 1
		resizer.Parent = root

		local dragging, start, sSize
		resizer.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = true
				start = input.Position
				sSize = root.AbsoluteSize
				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						dragging = false
					end
				end)
			end
		end)
		UIS.InputChanged:Connect(function(input)
			if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
				local d = input.Position - start
				root.Size = UDim2.fromOffset(math.max(420, sSize.X + d.X), math.max(280, sSize.Y + d.Y))
			end
		end)
	end

	-- FINAL
	root.Visible = true

	return API
end

return Module