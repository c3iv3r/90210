--// WindowModule.lua
-- Fokus code, siap pakai:
-- local Library = require(WindowModule)
-- local Window = Library:CreateWindow({
--     Title = "Title",
--     Subtitle = "Subtitle",
--     Icon = "settings", -- rbxassetid://... atau nama lucide (di-handle modul Icons jika ada)
--     Size = UDim2.fromOffset(580, 460),
--     Resizeable = false, -- atau true
--     ToggleKey = Enum.KeyCode.RightShift,
-- })

local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local RunService       = game:GetService("RunService")
local CoreGui          = game:GetService("CoreGui")

local Library = {}
Library.__index = Library

-- ========== UTIL ==========
local function isAssetId(str)
	return typeof(str) == "string" and (str:find("rbxassetid://") or str:find("^rbxasset://") or str:find("^rbxthumb://"))
end

local function resolveIcon(icon)
	-- rbxasset* langsung pakai
	if isAssetId(icon) then
		return icon, nil, nil
	end
	-- coba modul Icons (opsional)
	local ok, Icons = pcall(function()
		return rawget(getfenv(0), "Icons") or _G.Icons or Icons
	end)
	if ok and Icons then
		-- dukung API umum: Icons.GetAsset(name) -> string | {image, {ImageRectPosition=.., ImageRectSize=..}}
		if Icons.GetAsset then
			local ok2, res = pcall(Icons.GetAsset, icon)
			if ok2 and res then
				if typeof(res) == "string" then
					return res, nil, nil
				elseif typeof(res) == "table" then
					local image = res[1]
					local rect  = res[2]
					local off   = rect and rect.ImageRectPosition
					local size  = rect and rect.ImageRectSize
					return image, off, size
				end
			end
		end
		-- fallback lain (misal Icons.Icon(name) -> {image, rect})
		if Icons.Icon then
			local ok3, res = pcall(Icons.Icon, icon)
			if ok3 and res then
				local image = res[1]
				local rect  = res[2]
				local off   = rect and rect.ImageRectPosition
				local size  = rect and rect.ImageRectSize
				return image, off, size
			end
		end
	end
	return "", nil, nil
end

local function t(instance, goal, info)
	info = info or TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local tw = TweenService:Create(instance, info, goal)
	tw:Play()
	return tw
end

local function makeDraggable(dragHandle: Instance, root: Instance)
	local dragging = false
	local dragInput, mousePos, framePos

	local function update(input)
		local delta = input.Position - mousePos
		root.Position = UDim2.new(
			framePos.X.Scale, framePos.X.Offset + delta.X,
			framePos.Y.Scale, framePos.Y.Offset + delta.Y
		)
	end

	dragHandle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			mousePos = input.Position
			framePos = root.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	dragHandle.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			update(input)
		end
	end)

	local api = {}
	function api:SetAllowDragging(allow: boolean)
		dragging = dragging and allow
		dragHandle.Active = allow
		if dragHandle:IsA("GuiObject") then
			dragHandle.Selectable = allow
		end
	end
	return api
end

-- ========== ROOT GUI ==========
local RootGui do
	-- gunakan ScreenGui di CoreGui
	RootGui = Instance.new("ScreenGui")
	RootGui.Name = "LogicDev_UI"
	RootGui.ResetOnSpawn = false
	RootGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	RootGui.IgnoreGuiInset = false
	RootGui.Parent = CoreGui
end

-- ========== GLOBAL NOTIFY FALLBACK (jika tidak ada Window yang aktif) ==========
local GlobalNotifyList do
	GlobalNotifyList = Instance.new("Frame")
	GlobalNotifyList.Name = "NotificationList"
	GlobalNotifyList.BackgroundTransparency = 1
	GlobalNotifyList.Size = UDim2.new(0, 630, 1, 0)
	GlobalNotifyList.AnchorPoint = Vector2.new(1, 0)
	GlobalNotifyList.Position = UDim2.new(1, 0, 0, 0)
	GlobalNotifyList.ZIndex = 10
	GlobalNotifyList.Parent = RootGui

	local ui = Instance.new("UIListLayout", GlobalNotifyList)
	ui.SortOrder = Enum.SortOrder.LayoutOrder
	ui.Padding = UDim.new(0, 12)

	local pad = Instance.new("UIPadding", GlobalNotifyList)
	pad.PaddingTop = UDim.new(0, 10)
	pad.PaddingRight = UDim.new(0, 40)
	pad.PaddingLeft = UDim.new(0, 40)
	pad.PaddingBottom = UDim.new(0, 10)
end

-- ========== WINDOW TEMPLATE BUILDER ==========
local function buildWindow(opts)
	-- Container folder
	local folder = Instance.new("Folder")
	folder.Name = tostring(opts.Title or "Window")
	folder.Parent = RootGui

	-- FloatIcon (minimize badge)
	local floatIcon = Instance.new("CanvasGroup")
	floatIcon.Name = "FloatIcon"
	floatIcon.ZIndex = 12
	floatIcon.BackgroundColor3 = Color3.fromRGB(43, 46, 53)
	floatIcon.Size = UDim2.fromOffset(85, 45)
	floatIcon.AnchorPoint = Vector2.new(0.5, 0)
	floatIcon.Position = UDim2.new(0.5, 0, 0, 45)
	floatIcon.Parent = RootGui

	local fic = Instance.new("UICorner", floatIcon) fic.CornerRadius = UDim.new(0, 10)
	local fist = Instance.new("UIStroke", floatIcon)
	fist.Transparency = 0.5
	fist.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	fist.Thickness = 1.5
	fist.Color = Color3.fromRGB(95, 95, 117)

	local fpad = Instance.new("UIPadding", floatIcon)
	fpad.PaddingTop = UDim.new(0, 8)
	fpad.PaddingRight = UDim.new(0, 10)
	fpad.PaddingLeft = UDim.new(0, 10)
	fpad.PaddingBottom = UDim.new(0, 8)

	local fl = Instance.new("UIListLayout", floatIcon)
	fl.FillDirection = Enum.FillDirection.Horizontal
	fl.SortOrder = Enum.SortOrder.LayoutOrder
	fl.Padding = UDim.new(0, 8)
	fl.VerticalAlignment = Enum.VerticalAlignment.Center

	local fIcon = Instance.new("ImageButton")
	fIcon.Name = "Icon"
	fIcon.BackgroundTransparency = 1
	fIcon.AutoButtonColor = false
	fIcon.Size = UDim2.new(1, 0, 1, 0)
	fIcon.AnchorPoint = Vector2.new(0, 0.5)
	fIcon.Position = UDim2.new(0, 0, 0.5, 0)
	fIcon.Parent = floatIcon
	Instance.new("UIAspectRatioConstraint", fIcon)

	local fTitle = Instance.new("TextLabel")
	fTitle.Name = "TextLabel"
	fTitle.BackgroundTransparency = 1
	fTitle.TextScaled = true
	fTitle.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
	fTitle.TextColor3 = Color3.fromRGB(197, 204, 219)
	fTitle.Size = UDim2.fromOffset(74, 16)
	fTitle.AnchorPoint = Vector2.new(0.5, 0.5)
	fTitle.Position = UDim2.new(0.38615, 0, 0.53448, -1)
	fTitle.Parent = floatIcon

	local fOpen = Instance.new("ImageButton")
	fOpen.Name = "Open"
	fOpen.BackgroundTransparency = 1
	fOpen.AutoButtonColor = false
	fOpen.ImageColor3 = Color3.fromRGB(197, 204, 219)
	fOpen.Size = UDim2.fromOffset(20, 20)
	fOpen.AnchorPoint = Vector2.new(0, 0.5)
	fOpen.Position = UDim2.new(0, 128, 0.5, 0)
	fOpen.Parent = floatIcon
	Instance.new("UIAspectRatioConstraint", fOpen)
	Instance.new("UICorner", fOpen)

	-- Window root
	local window = Instance.new("Frame")
	window.Name = "Window"
	window.BackgroundColor3 = Color3.fromRGB(37, 40, 47)
	window.BorderSizePixel = 2
	window.BorderColor3 = Color3.fromRGB(61, 61, 75)
	window.AnchorPoint = Vector2.new(0.5, 0.5)
	window.Size = opts.Size or UDim2.fromOffset(528, 334)
	window.Position = UDim2.new(0.5, 0, 0.5, 0)
	window.Parent = folder
	Instance.new("UICorner", window).CornerRadius = UDim.new(0, 10)

	local winStroke = Instance.new("UIStroke", window)
	winStroke.Transparency = 0.5
	winStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	winStroke.Color = Color3.fromRGB(95, 95, 117)

	-- TopFrame
	local top = Instance.new("Frame")
	top.Name = "TopFrame"
	top.BackgroundColor3 = Color3.fromRGB(37, 40, 47)
	top.Size = UDim2.new(1, 0, 0, 35)
	top.ClipsDescendants = true
	top.Parent = window

	local topBorder = Instance.new("Frame", top)
	topBorder.Name = "Border"
	topBorder.BackgroundColor3 = Color3.fromRGB(61, 61, 75)
	topBorder.BorderSizePixel = 0
	topBorder.AnchorPoint = Vector2.new(0, 0.5)
	topBorder.Position = UDim2.new(0, 0, 1, 0)
	topBorder.Size = UDim2.new(1, 0, 0, 2)
	Instance.new("UICorner", top).CornerRadius = UDim.new(0, 6)

	local topIcon = Instance.new("ImageButton")
	topIcon.Name = "Icon"
	topIcon.BackgroundTransparency = 1
	topIcon.AutoButtonColor = false
	topIcon.Size = UDim2.fromOffset(25, 25)
	topIcon.AnchorPoint = Vector2.new(0, 0.5)
	topIcon.Position = UDim2.new(0, 10, 0.5, 0)
	topIcon.Parent = top
	Instance.new("UIAspectRatioConstraint", topIcon)

	local topTitle = Instance.new("TextLabel")
	topTitle.Name = "TextLabel"
	topTitle.BackgroundTransparency = 1
	topTitle.TextScaled = true
	topTitle.TextXAlignment = Enum.TextXAlignment.Center
	topTitle.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
	topTitle.TextColor3 = Color3.fromRGB(197, 204, 219)
	topTitle.Size = UDim2.new(1, 0, 0, 16)
	topTitle.AnchorPoint = Vector2.new(0.5, 0.5)
	topTitle.Position = UDim2.new(0.5, 0, 0.5, -1)
	topTitle.Parent = top

	local btnClose = Instance.new("ImageButton")
	btnClose.Name = "Close"
	btnClose.BackgroundTransparency = 1
	btnClose.ImageColor3 = Color3.fromRGB(197, 204, 219)
	btnClose.AnchorPoint = Vector2.new(1, 0.5)
	btnClose.Size = UDim2.fromOffset(20, 20)
	btnClose.Position = UDim2.new(1, -15, 0.5, 0)
	btnClose.Parent = top

	local btnHide = Instance.new("ImageButton")
	btnHide.Name = "Hide"
	btnHide.BackgroundTransparency = 1
	btnHide.ImageColor3 = Color3.fromRGB(197, 204, 219)
	btnHide.AnchorPoint = Vector2.new(1, 0.5)
	btnHide.Size = UDim2.fromOffset(20, 20)
	btnHide.Position = UDim2.new(1, -90, 0.5, 0)
	btnHide.Parent = top

	local btnMaximize = Instance.new("ImageButton")
	btnMaximize.Name = "Maximize"
	btnMaximize.BackgroundTransparency = 1
	btnMaximize.ImageColor3 = Color3.fromRGB(197, 204, 219)
	btnMaximize.AnchorPoint = Vector2.new(1, 0.5)
	btnMaximize.Size = UDim2.fromOffset(15, 15)
	btnMaximize.Position = UDim2.new(1, -55, 0.5, 0)
	btnMaximize.Parent = top

	-- Sidebar Tabs
	local tabButtons = Instance.new("Frame")
	tabButtons.Name = "TabButtons"
	tabButtons.BackgroundColor3 = Color3.fromRGB(37, 40, 47)
	tabButtons.BorderColor3 = Color3.fromRGB(61, 61, 75)
	tabButtons.Size = UDim2.new(0, 165, 1, -35)
	tabButtons.Position = UDim2.new(0, 0, 0, 35)
	tabButtons.SelectionGroup = true
	tabButtons.Parent = window

	local lists = Instance.new("ScrollingFrame", tabButtons)
	lists.Name = "Lists"
	lists.BackgroundTransparency = 1
	lists.Active = true
	lists.ScrollingDirection = Enum.ScrollingDirection.Y
	lists.CanvasSize = UDim2.new(0, 0, 0, 0)
	lists.AutomaticCanvasSize = Enum.AutomaticSize.Y
	lists.ScrollBarThickness = 4
	lists.Size = UDim2.new(1, 0, 1, 0)
	local ll = Instance.new("UIListLayout", lists)
	ll.SortOrder = Enum.SortOrder.LayoutOrder

	-- Tabs Area
	local tabs = Instance.new("Frame")
	tabs.Name = "Tabs"
	tabs.BackgroundColor3 = Color3.fromRGB(32, 35, 41)
	tabs.BorderColor3 = Color3.fromRGB(61, 61, 75)
	tabs.Size = UDim2.new(1, -165, 1, -35)
	tabs.Position = UDim2.new(0, 165, 0, 35)
	tabs.Parent = window
	Instance.new("UICorner", tabs).CornerRadius = UDim.new(0, 6)

	local antiL = Instance.new("Frame", tabs)
	antiL.Name = "AntiCornerLeft"
	antiL.Visible = false
	antiL.BackgroundColor3 = tabs.BackgroundColor3
	antiL.Size = UDim2.new(0, 5, 1, 0)

	local antiT = Instance.new("Frame", tabs)
	antiT.Name = "AntiCornerTop"
	antiT.BackgroundColor3 = tabs.BackgroundColor3
	antiT.Size = UDim2.new(1, 0, 0, 5)

	local emptyText = Instance.new("TextLabel", tabs)
	emptyText.Name = "NoObjectFoundText"
	emptyText.BackgroundTransparency = 1
	emptyText.Text = "This tab is empty :("
	emptyText.TextScaled = true
	emptyText.TextColor3 = Color3.fromRGB(135, 140, 150)
	emptyText.Size = UDim2.new(1, 0, 0, 16)
	emptyText.AnchorPoint = Vector2.new(0.5, 0.5)
	emptyText.Position = UDim2.new(0.5, 0, 0.45, 0)
	emptyText.Visible = false

	-- Notification area (inside window)
	local notifFrame = Instance.new("Frame", window)
	notifFrame.Name = "NotificationFrame"
	notifFrame.BackgroundTransparency = 1
	notifFrame.Size = UDim2.new(1, 0, 1, 0)
	local notifList = Instance.new("Frame", notifFrame)
	notifList.Name = "NotificationList"
	notifList.BackgroundTransparency = 1
	notifList.AnchorPoint = Vector2.new(0.5, 0)
	notifList.Position = UDim2.new(1, 0, 0, 35)
	notifList.Size = UDim2.new(0, 630, 1, -35)
	notifList.ZIndex = 5
	local nll = Instance.new("UIListLayout", notifList)
	nll.SortOrder = Enum.SortOrder.LayoutOrder
	nll.Padding = UDim.new(0, 12)

	-- Dark overlay
	local dark = Instance.new("Frame", window)
	dark.Name = "DarkOverlay"
	dark.BackgroundColor3 = Color3.new(0, 0, 0)
	dark.BackgroundTransparency = 0.6
	dark.Size = UDim2.new(1, 0, 1, 0)
	dark.Visible = false
	Instance.new("UICorner", dark).CornerRadius = UDim.new(0, 10)

	-- Icon & texts
	local icon, off, size = resolveIcon(opts.Icon)
	topIcon.Image = icon or ""
	if off and size then
		topIcon.ImageRectOffset = off
		topIcon.ImageRectSize  = size
	end

	fTitle.Text = tostring(opts.Title or "Window")

	if isAssetId(opts.Icon) then
		fIcon.Image = icon
	else
		local i2, off2, size2 = resolveIcon(opts.Icon)
		fIcon.Image = i2 or ""
		if off2 and size2 then
			fIcon.ImageRectOffset = off2
			fIcon.ImageRectSize  = size2
		end
	end

	local titleText = tostring(opts.Title or "")
	local subText   = tostring(opts.Subtitle or "")
	topTitle.Text   = subText ~= "" and (titleText .. " - " .. subText) or titleText

	-- glyphs (isi sesuai kebutuhan / ganti dengan asset id milikmu)
	btnClose.Image    = "rbxassetid://132453323679056"
	btnHide.Image     = "rbxassetid://128209591224511"
	btnMaximize.Image = "rbxassetid://108285848026510"
	fOpen.Image       = "rbxassetid://122219713887461"

	-- visible states
	window.Visible    = true
	floatIcon.Visible = false

	return {
		Folder = folder,
		Root   = window,
		Top    = top,
		TopIcon = topIcon,
		TopTitle = topTitle,
		BtnClose = btnClose,
		BtnHide  = btnHide,
		BtnMax   = btnMaximize,
		FloatIcon = floatIcon,
		FloatOpen = fOpen,
		FloatImage = fIcon,
		FloatText  = fTitle,
		TabButtons = tabButtons,
		TabList    = lists,
		Tabs       = tabs,
		EmptyText  = emptyText,
		NotifyList = notifList,
		DarkOverlay = dark,
	}
end

-- ========== PUBLIC API ==========
local OpenWindows = {}

function Library:CreateWindow(opts)
	opts = opts or {}
	opts.Resizeable = opts.Resizeable == nil and false or not not opts.Resizeable
	opts.Size = opts.Size or UDim2.fromOffset(580, 460)

	local ui = buildWindow(opts)

	-- Drag
	local dragApi = makeDraggable(ui.Top, ui.Root)
	dragApi:SetAllowDragging(true)

	-- Maximize/Restore
	local maximized = false
	local prevSize, prevPos = ui.Root.Size, ui.Root.Position

	ui.BtnMax.MouseButton1Click:Connect(function()
		if not opts.Resizeable then return end
		if not maximized then
			maximized = true
			dragApi:SetAllowDragging(false)
			prevSize, prevPos = ui.Root.Size, ui.Root.Position
			t(ui.Root, { Size = UDim2.new(1, 0, 1, 0) })
			t(ui.Root, { Position = UDim2.new(0.5, 0, 0.5, 0) })
			t(ui.Root:FindFirstChildOfClass("UICorner"), { CornerRadius = UDim.new(0, 0) })
		else
			maximized = false
			dragApi:SetAllowDragging(true)
			t(ui.Root, { Size = prevSize })
			t(ui.Root, { Position = prevPos })
			t(ui.Root:FindFirstChildOfClass("UICorner"), { CornerRadius = UDim.new(0, 10) })
		end
	end)

	-- Hide → FloatIcon
	local animBusy = false
	local function showWindow(force)
		if animBusy then return end
		animBusy = true
		ui.FloatIcon.Size = UDim2.fromOffset(0, 0)
		ui.FloatIcon.Visible = true
		ui.Root.Visible = true
		t(ui.FloatIcon, { Size = UDim2.new(0, 0, 0, 0) }):Play()
		t(ui.Root, { Size = opts.Size })
		task.delay(0.2, function()
			ui.TabButtons.Visible = true
			ui.Tabs.Visible = true
			ui.FloatIcon.Visible = false
			animBusy = false
		end)
	end
	local function hideWindow(force)
		if animBusy then return end
		animBusy = true
		local curSize = ui.Root.Size
		ui.TabButtons.Visible = false
		ui.Tabs.Visible = false
		ui.FloatIcon.Size = UDim2.fromOffset(0, 0)
		ui.FloatIcon.Visible = true
		t(ui.FloatIcon, { Size = UDim2.fromOffset(85, 45) })
		t(ui.Root, { Size = UDim2.fromOffset(0, 0) }):Completed:Wait()
		ui.Root.Visible = false
		animBusy = false
	end

	ui.BtnHide.MouseButton1Click:Connect(function()
		hideWindow(true)
	end)
	ui.FloatOpen.MouseButton1Click:Connect(function()
		showWindow(true)
	end)

	-- Close (destroy folder)
	ui.BtnClose.MouseButton1Click:Connect(function()
		if ui.Folder then ui.Folder:Destroy() end
	end)

	-- ToggleKey
	local toggleKey = opts.ToggleKey or Enum.KeyCode.RightShift
	UserInputService.InputBegan:Connect(function(input, gp)
		if gp then return end
		if input.KeyCode == toggleKey then
			if ui.Root.Visible then
				hideWindow()
			else
				showWindow()
			end
		end
	end)

	-- Tabs API (minimal)
	local WindowAPI = {}
	WindowAPI.__index = WindowAPI

	function WindowAPI:AddTab(tabName: string, tabIcon) -- return Tab object
		tabName = tostring(tabName or "Tab")

		-- Sidebar button
		local btnFrame = Instance.new("Frame")
		btnFrame.Name = "TabButton"
		btnFrame.BackgroundTransparency = 1
		btnFrame.Size = UDim2.new(1, 0, 0, 36)
		btnFrame.Parent = ui.TabList

		local sideBar = Instance.new("Frame", btnFrame)
		sideBar.Name = "Bar"
		sideBar.BackgroundColor3 = Color3.fromRGB(197, 204, 219)
		sideBar.AnchorPoint = Vector2.new(0, 0.5)
		sideBar.Position = UDim2.new(0, 8, 0, 18)
		sideBar.Size = UDim2.fromOffset(5, 25)
		local sbCorner = Instance.new("UICorner", sideBar); sbCorner.CornerRadius = UDim.new(0, 100)
		local sbGrad = Instance.new("UIGradient", sideBar); sbGrad.Enabled = false; sbGrad.Rotation = 90

		local ib = Instance.new("ImageButton", btnFrame)
		ib.BackgroundTransparency = 1
		ib.ImageColor3 = Color3.fromRGB(197, 204, 219)
		ib.AnchorPoint = Vector2.new(0, 0.5)
		ib.Position = UDim2.new(0, 21, 0, 18)
		ib.Size = UDim2.fromOffset(31, 30)
		Instance.new("UIAspectRatioConstraint", ib)

		if tabIcon ~= nil then
			if isAssetId(tabIcon) then
				ib.Image = tabIcon
			else
				local ti, toff, tsize = resolveIcon(tabIcon)
				ib.Image = ti or ""
				if toff and tsize then ib.ImageRectOffset = toff; ib.ImageRectSize = tsize end
			end
		else
			ib.Image = "rbxassetid://113216930555884"
		end

		local lbl = Instance.new("TextLabel", btnFrame)
		lbl.BackgroundTransparency = 1
		lbl.FontFace = Font.new("rbxassetid://11702779517", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
		lbl.TextColor3 = Color3.fromRGB(197, 204, 219)
		lbl.TextScaled = true
		lbl.TextXAlignment = Enum.TextXAlignment.Left
		lbl.Text = tabName
		lbl.AnchorPoint = Vector2.new(0, 0.5)
		lbl.Position = UDim2.new(0, 57, 0.5, 0)
		lbl.Size = UDim2.fromOffset(88, 16)

		-- Panel
		local panel = Instance.new("Frame", ui.Tabs)
		panel.Name = tabName
		panel.BackgroundTransparency = 1
		panel.Size = UDim2.fromScale(1, 1)
		panel.Visible = false

		-- simple switch
		local function activate()
			for _, child in ipairs(ui.Tabs:GetChildren()) do
				if child:IsA("Frame") and child ~= panel then
					child.Visible = false
				end
			end
			panel.Visible = true
			ui.EmptyText.Visible = #panel:GetChildren() == 0
		end
		ib.MouseButton1Click:Connect(activate)
		lbl.InputBegan:Connect(function(inp)
			if inp.UserInputType == Enum.UserInputType.MouseButton1 then activate() end
		end)

		-- default select first tab
		if #ui.Tabs:GetChildren() == 1 then
			activate()
		end

		local TabAPI = {}
		function TabAPI:GetContainer() return panel end
		function TabAPI:Show() panel.Visible = true end
		function TabAPI:Hide() panel.Visible = false end
		return setmetatable(TabAPI, {__tostring=function() return "Tab<"..tabName..">" end})
	end

	function WindowAPI:GetGui() return ui.Root end
	function WindowAPI:GetFolder() return ui.Folder end
	function WindowAPI:GetTabsContainer() return ui.Tabs end
	function WindowAPI:GetTabList() return ui.TabList end
	function WindowAPI:Show() ui.Root.Visible = true; ui.FloatIcon.Visible = false end
	function WindowAPI:Hide() ui.Root.Visible = false; ui.FloatIcon.Visible = true end
	function WindowAPI:Destroy() if ui.Folder then ui.Folder:Destroy() end end
	function WindowAPI:SetToggleKey(k)
		if typeof(k) == "EnumItem" and k.EnumType == Enum.KeyCode then
			opts.ToggleKey = k
		elseif typeof(k) == "string" then
			opts.ToggleKey = Enum.KeyCode[k]
		end
	end

	table.insert(OpenWindows, ui.Root)

	return setmetatable(WindowAPI, WindowAPI)
end

return Library