-- Window.lua
-- Private module: Window ala Library.txt (draggable, minimize, close, optional resize)
-- Integrasi penuh: Theme.lua (warna, gradient, animasi)
-- API:
--   local Window = require(path.to.Window)
--   local win = Window.new({
--       Title = "UI Library",
--       Subtitle = nil,               -- optional teks kecil di topbar
--       Size = UDim2.fromOffset(560, 420),
--       Position = nil,               -- default: center of screen
--       Draggable = true,
--       Resizable = true,
--       Scrollable = true,
--       MinSize = Vector2.new(420, 260),
--       CanMinimize = true,
--       CanClose = true,
--       SaveKey = "main_window",     -- opsional: simpan pos/size di _G saat runtime
--       CloseOnDestroy = true,       -- destroy saat Close ditekan (default true)
--       OnClose = function() end,
--       OnMinimize = function(minimized) end,
--       OnMove = function(posUDim2) end,
--       OnResize = function(sizeUDim2) end,
--   })
--   win:GetBody() -> Instance (Frame/ScrollingFrame)
--   win:Show() :Hide() :Toggle()
--   win:Minimize() :Restore() :IsMinimized()
--   win:SetTitle(text) :SetSubtitle(textOrNil)
--   win:SetScrollable(bool)
--   win:Focus()  -- bring to front
--   win:Destroy()

local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local CoreGui          = game:GetService("CoreGui")

local Theme = require("Theme")

local Window = {}
Window.__index = Window

-- ===== Root (ScreenGui) untuk semua window =====
local ROOT_TAG = "LogicDev_WindowRoot"

local function buildRoot()
	local sg = Instance.new("ScreenGui")
	sg.Name = ROOT_TAG
	sg.ResetOnSpawn = false
	sg.IgnoreGuiInset = true
	sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	sg.Parent = (gethui and gethui()) or CoreGui
	return { Gui = sg, TopIndex = 100 }
end

local ROOT = _G.__ld_window_root
if not ROOT then
	ROOT = buildRoot()
	_G.__ld_window_root = ROOT
end

-- ===== Utils =====
local function viewportSize()
	local cam = workspace.CurrentCamera
	local v = cam and cam.ViewportSize or Vector2.new(1920, 1080)
	return v.X, v.Y
end

local function clamp(n, a, b)
	if n < a then return a end
	if n > b then return b end
	return n
end

local function setZRecursive(gui, z)
	if not gui then return end
	gui.ZIndex = z
	for _, c in ipairs(gui:GetChildren()) do
		if c:IsA("GuiObject") then
			setZRecursive(c, z)
		end
	end
end

local function centerPosition(sizeUD)
	local vw, vh = viewportSize()
	local w = sizeUD.X.Offset
	local h = sizeUD.Y.Offset
	local x = (vw - w) / 2
	local y = (vh - h) / 2
	return UDim2.fromOffset(x, y)
end

local function saveState(key, pos, size)
	if not key or key == "" then return end
	_G.__ld_window_state = _G.__ld_window_state or {}
	_G.__ld_window_state[key] = { Position = pos, Size = size }
end

local function loadState(key)
	if not key or key == "" then return nil end
	local st = _G.__ld_window_state and _G.__ld_window_state[key]
	return st
end

-- ===== Constructor =====
function Window.new(opts)
	opts = opts or {}
	local self = setmetatable({}, Window)

	self._titleTxt   = opts.Title or "Window"
	self._subtitle   = opts.Subtitle
	self._size       = opts.Size or UDim2.fromOffset(560, 420)
	self._pos        = opts.Position or nil
	self._draggable  = (opts.Draggable ~= false)
	self._resizable  = not not opts.Resizable
	self._scrollable = (opts.Scrollable ~= false)
	self._minSize    = opts.MinSize or Vector2.new(420, 260)
	self._canMin     = (opts.CanMinimize ~= false)
	self._canClose   = (opts.CanClose ~= false)
	self._saveKey    = opts.SaveKey
	self._closeDestroy = (opts.CloseOnDestroy ~= false)
	self._onClose    = (typeof(opts.OnClose) == "function") and opts.OnClose or function() end
	self._onMinimize = (typeof(opts.OnMinimize) == "function") and opts.OnMinimize or function() end
	self._onMove     = (typeof(opts.OnMove) == "function") and opts.OnMove or function() end
	self._onResize   = (typeof(opts.OnResize) == "function") and opts.OnResize or function() end

	-- restore state kalau ada
	local restored = loadState(self._saveKey)
	if restored then
		if restored.Size then self._size = restored.Size end
		if restored.Position then self._pos = restored.Position end
	end
	if not self._pos then
		self._pos = centerPosition(self._size)
	end

	-- ===== Window frame =====
	local win = Instance.new("Frame")
	win.Name = self._titleTxt
	win.BackgroundColor3 = Theme.colors.card
	win.BorderSizePixel = 0
	win.Size = self._size
	win.Position = self._pos
	win.Parent = ROOT.Gui

	local corner = Instance.new("UICorner", win)
	corner.CornerRadius = UDim.new(0, Theme.radius.popup)

	local stroke = Instance.new("UIStroke", win)
	stroke.Color = Theme.colors.stroke
	stroke.Thickness = 1.25

	-- stacking (bring to front)
	ROOT.TopIndex += 1
	setZRecursive(win, ROOT.TopIndex)

	-- ===== Topbar =====
	local top = Instance.new("Frame")
	top.Name = "TopBar"
	top.BackgroundColor3 = Theme.colors.input
	top.BorderSizePixel = 0
	top.Size = UDim2.new(1, -16, 0, (self._subtitle and 56 or 40))
	top.Position = UDim2.new(0, 8, 0, 8)
	top.Parent = win
	local topCorner = Instance.new("UICorner", top)
	topCorner.CornerRadius = UDim.new(0, Theme.radius.input)
	local topStroke = Instance.new("UIStroke", top)
	topStroke.Color = Theme.colors.stroke
	topStroke.Thickness = 1
	Theme.paintNormal(top, topStroke)

	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.BackgroundTransparency = 1
	title.Text = self._titleTxt
	title.TextColor3 = Theme.colors.text.title
	title.Font = Enum.Font.GothamSemibold
	title.TextSize = 16
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Position = UDim2.new(0, 12, 0, 4)
	title.Size = UDim2.new(1, -140, 0, 20)
	title.Parent = top

	local sub
	if self._subtitle then
		sub = Instance.new("TextLabel")
		sub.Name = "Subtitle"
		sub.BackgroundTransparency = 1
		sub.Text = tostring(self._subtitle)
		sub.TextColor3 = Theme.colors.text.dim
		sub.Font = Enum.Font.Gotham
		sub.TextSize = 13
		sub.TextXAlignment = Enum.TextXAlignment.Left
		sub.Position = UDim2.new(0, 12, 0, 24)
		sub.Size = UDim2.new(1, -140, 0, 18)
		sub.Parent = top
	end

	-- Buttons (Minimize, Close)
	local btnMin, btnClose

	if self._canMin then
		btnMin = Instance.new("TextButton")
		btnMin.Name = "Minimize"
		btnMin.AutoButtonColor = false
		btnMin.Text = "–"
		btnMin.TextSize = 18
		btnMin.Font = Enum.Font.Gotham
		btnMin.TextColor3 = Theme.colors.text.muted
		btnMin.BackgroundTransparency = 1
		btnMin.AnchorPoint = Vector2.new(1, 0.5)
		btnMin.Position = UDim2.new(1, -44, 0.5, 0)
		btnMin.Size = UDim2.fromOffset(24, 24)
		btnMin.Parent = top
	end

	if self._canClose then
		btnClose = Instance.new("TextButton")
		btnClose.Name = "Close"
		btnClose.AutoButtonColor = false
		btnClose.Text = "✕"
		btnClose.TextSize = 16
		btnClose.Font = Enum.Font.Gotham
		btnClose.TextColor3 = Theme.colors.text.muted
		btnClose.BackgroundTransparency = 1
		btnClose.AnchorPoint = Vector2.new(1, 0.5)
		btnClose.Position = UDim2.new(1, -14, 0.5, 0)
		btnClose.Size = UDim2.fromOffset(24, 24)
		btnClose.Parent = top
	end

	-- ===== Body =====
	local inset = 8
	local topH = (self._subtitle and 56 or 40)
	local body = self._scrollable and Instance.new("ScrollingFrame") or Instance.new("Frame")
	body.Name = "Body"
	body.BackgroundTransparency = 1
	body.BorderSizePixel = 0
	body.Position = UDim2.new(0, inset, 0, inset + topH + 4)
	body.Size = UDim2.new(1, -inset*2, 1, -(inset*2 + topH + 4))
	body.Parent = win

	if body:IsA("ScrollingFrame") then
		body.Active = true
		body.AutomaticCanvasSize = Enum.AutomaticSize.Y
		body.ScrollBarThickness = 4
		local lay = Instance.new("UIListLayout", body)
		lay.FillDirection = Enum.FillDirection.Vertical
		lay.Padding = UDim.new(0, 8)
		lay.SortOrder = Enum.SortOrder.LayoutOrder
	else
		local lay = Instance.new("UIListLayout", body)
		lay.FillDirection = Enum.FillDirection.Vertical
		lay.Padding = UDim.new(0, 8)
		lay.SortOrder = Enum.SortOrder.LayoutOrder
	end

	-- ===== Resizer =====
	local sizer
	if self._resizable then
		sizer = Instance.new("TextButton")
		sizer.Name = "Sizer"
		sizer.AutoButtonColor = false
		sizer.Text = ""
		sizer.BackgroundTransparency = 1
		sizer.AnchorPoint = Vector2.new(1, 1)
		sizer.Position = UDim2.new(1, -6, 1, -6)
		sizer.Size = UDim2.fromOffset(16, 16)
		sizer.Parent = win

		-- visual garis miring kecil (pakai label)
		local sl = Instance.new("TextLabel")
		sl.BackgroundTransparency = 1
		sl.Text = "◢"
		sl.TextColor3 = Theme.colors.text.dim
		sl.Font = Enum.Font.Gotham
		sl.TextSize = 14
		sl.Size = UDim2.fromScale(1,1)
		sl.Parent = sizer
	end

	-- ===== Refs & state =====
	self._win = win
	self._top = top
	self._topStroke = topStroke
	self._title = title
	self._subtitleLbl = sub
	self._btnMin = btnMin
	self._btnClose = btnClose
	self._body = body
	self._sizer = sizer

	self._minimized = false
	self._restoredSize = self._size

	-- ===== Focus handling (bring to front) =====
	local function focus()
		ROOT.TopIndex += 1
		setZRecursive(self._win, ROOT.TopIndex)
		Theme.paintSelected(self._top, self._topStroke)
		self._title.TextColor3 = Theme.colors.text.onAcc
		if self._subtitleLbl then self._subtitleLbl.TextColor3 = Theme.colors.text.onAcc end
	end

	local function unfocus()
		Theme.paintNormal(self._top, self._topStroke)
		self._title.TextColor3 = Theme.colors.text.title
		if self._subtitleLbl then self._subtitleLbl.TextColor3 = Theme.colors.text.dim end
	end

	self._win.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			focus()
		end
	end)

	-- ===== Dragging =====
	if self._draggable then
		local dragging = false
		local startPos, startMouse

		local function clampToScreen(posUD)
			local vw, vh = viewportSize()
			local w = self._win.AbsoluteSize.X
			local h = self._win.AbsoluteSize.Y
			local x = clamp(posUD.X.Offset, 4, vw - w - 4)
			local y = clamp(posUD.Y.Offset, 4, vh - h - 4)
			return UDim2.fromOffset(x, y)
		end

		self._top.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = true
				startPos = self._win.Position
				startMouse = input.Position
				Theme.paintHover(self._top, self._topStroke)
				focus()
			end
		end)

		UserInputService.InputChanged:Connect(function(input)
			if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
				local delta = input.Position - startMouse
				local newPos = UDim2.fromOffset(startPos.X.Offset + delta.X, startPos.Y.Offset + delta.Y)
				self._win.Position = clampToScreen(newPos)
				saveState(self._saveKey, self._win.Position, self._win.Size)
				self._onMove(self._win.Position)
			end
		end)

		UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = false
				Theme.paintSelected(self._top, self._topStroke) -- tetap active color
			end
		end)
	end

	-- ===== Resizing =====
	if self._resizable and self._sizer then
		local resizing = false
		local startSize, startMouse

		self._sizer.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				resizing = true
				startSize = self._win.Size
				startMouse = input.Position
				focus()
			end
		end)

		UserInputService.InputChanged:Connect(function(input)
			if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
				local delta = input.Position - startMouse
				local newW = clamp(startSize.X.Offset + delta.X, self._minSize.X, math.huge)
				local newH = clamp(startSize.Y.Offset + delta.Y, self._minSize.Y, math.huge)
				self._win.Size = UDim2.fromOffset(newW, newH)
				self._restoredSize = self._win.Size
				saveState(self._saveKey, self._win.Position, self._win.Size)
				self._onResize(self._win.Size)
			end
		end)

		UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				resizing = false
			end
		end)
	end

	-- ===== Buttons actions =====
	if self._btnMin then
		self._btnMin.MouseButton1Click:Connect(function()
			if self._minimized then
				self:Restore()
			else
				self:Minimize()
			end
		end)
	end

	if self._btnClose then
		self._btnClose.MouseButton1Click:Connect(function()
			local ok, err = pcall(self._onClose)
			if not ok then warn("[Window] OnClose error:", err) end
			if self._closeDestroy then
				self:Destroy()
			else
				self:Hide()
			end
		end)
	end

	-- ===== Show with gentle anim =====
	self._win.Visible = false
	self:Show()
	focus()

	return self
end

-- ===== Methods =====
function Window:GetBody()
	return self._body
end

function Window:SetTitle(t)
	self._titleTxt = t or self._titleTxt
	self._title.Text = self._titleTxt
	self._win.Name = self._titleTxt
end

function Window:SetSubtitle(t)
	self._subtitle = t
	if t and t ~= "" then
		if not self._subtitleLbl then
			self._subtitleLbl = Instance.new("TextLabel")
			self._subtitleLbl.Name = "Subtitle"
			self._subtitleLbl.BackgroundTransparency = 1
			self._subtitleLbl.TextColor3 = Theme.colors.text.dim
			self._subtitleLbl.Font = Enum.Font.Gotham
			self._subtitleLbl.TextSize = 13
			self._subtitleLbl.TextXAlignment = Enum.TextXAlignment.Left
			self._subtitleLbl.Position = UDim2.new(0, 12, 0, 24)
			self._subtitleLbl.Size = UDim2.new(1, -140, 0, 18)
			self._subtitleLbl.Parent = self._top
			self._top.Size = UDim2.new(1, -16, 0, 56)
		end
		self._subtitleLbl.Text = tostring(t)
	else
		if self._subtitleLbl then
			self._subtitleLbl:Destroy()
			self._subtitleLbl = nil
			self._top.Size = UDim2.new(1, -16, 0, 40)
		end
	end
end

function Window:SetScrollable(b)
	b = not not b
	if b == self._scrollable then return end
	self._scrollable = b

	local inset = 8
	local topH = (self._subtitleLbl and 56) or 40
	local old = self._body
	local kids = old:GetChildren()

	if b then
		local sc = Instance.new("ScrollingFrame")
		sc.Name = "Body"
		sc.Active = true
		sc.AutomaticCanvasSize = Enum.AutomaticSize.Y
		sc.ScrollBarThickness = 4
		sc.BackgroundTransparency = 1
		sc.BorderSizePixel = 0
		sc.Position = UDim2.new(0, inset, 0, inset + topH + 4)
		sc.Size = UDim2.new(1, -inset*2, 1, -(inset*2 + topH + 4))
		sc.Parent = self._win
		local lay = Instance.new("UIListLayout", sc)
		lay.FillDirection = Enum.FillDirection.Vertical
		lay.Padding = UDim.new(0, 8)
		lay.SortOrder = Enum.SortOrder.LayoutOrder
		self._body = sc
	else
		local fr = Instance.new("Frame")
		fr.Name = "Body"
		fr.BackgroundTransparency = 1
		fr.BorderSizePixel = 0
		fr.Position = UDim2.new(0, inset, 0, inset + topH + 4)
		fr.Size = UDim2.new(1, -inset*2, 1, -(inset*2 + topH + 4))
		fr.Parent = self._win
		local lay = Instance.new("UIListLayout", fr)
		lay.FillDirection = Enum.FillDirection.Vertical
		lay.Padding = UDim.new(0, 8)
		lay.SortOrder = Enum.SortOrder.LayoutOrder
		self._body = fr
	end

	for _, c in ipairs(kids) do
		if not c:IsA("UIListLayout") then
			c.Parent = self._body
		else
			c:Destroy()
		end
	end

	old:Destroy()
end

function Window:Show()
	if self._win.Visible then return end
	self._win.Visible = true
	Theme.popupIn(self._win)
end

function Window:Hide()
	if not self._win.Visible then return end
	Theme.popupOut(self._win, function()
		if self._win then self._win.Visible = false end
	end)
end

function Window:Toggle()
	if self._win.Visible then self:Hide() else self:Show() end
end

function Window:Minimize()
	if self._minimized then return end
	self._minimized = true
	self._restoredSize = self._win.Size
	local newH = (self._subtitleLbl and 56 or 40) + 16
	Theme.tween(self._win, { Size = UDim2.new(self._win.Size.X.Scale, self._win.Size.X.Offset, 0, newH) }, Theme.tweening.base)
	self._body.Visible = false
	if self._sizer then self._sizer.Visible = false end
	local ok, err = pcall(self._onMinimize, true); if not ok then warn("[Window] OnMinimize error:", err) end
end

function Window:Restore()
	if not self._minimized then return end
	self._minimized = false
	self._body.Visible = true
	if self._sizer then self._sizer.Visible = true end
	Theme.tween(self._win, { Size = self._restoredSize }, Theme.tweening.base)
	local ok, err = pcall(self._onMinimize, false); if not ok then warn("[Window] OnMinimize error:", err) end
end

function Window:IsMinimized()
	return self._minimized
end

function Window:Focus()
	ROOT.TopIndex += 1
	setZRecursive(self._win, ROOT.TopIndex)
end

function Window:Destroy()
	if self._win then
		self._win:Destroy()
		self._win = nil
	end
end

return Window

--[[local Window = require(path.to.Window)
local Section = require(path.to.Section)
local Button  = require(path.to.Button)

local win = Window.new({
    Title = "My Library",
    Subtitle = "v1.0",
    Size = UDim2.fromOffset(560, 420),
    Draggable = true,
    Resizable = true,
    Scrollable = true,
    SaveKey = "main_win",
    OnClose = function() print("Window closed") end,
})

-- Tambah konten
local body = win:GetBody()
local sec = Section.new(body, { Title = "Controls", DefaultOpen = true })
local btn = Button.new(sec:GetBody(), { Title = "Run", Callback = function() print("Run!") end })

-- Kontrol
-- win:Minimize(); win:Restore(); print(win:IsMinimized())
-- win:SetTitle("New Title"); win:SetSubtitle(nil)
-- win:SetScrollable(false)
-- win:Hide(); win:Show(); win:Toggle()
-- win:Focus()
-- win:Destroy()]]