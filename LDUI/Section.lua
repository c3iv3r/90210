-- Section.lua
-- Private module: Section ala Library.txt
-- Integrasi penuh: Theme.lua (warna, gradient, animasi)
-- Fitur:
--   - Header judul + optional desc
--   - Bisa collapse/expand (default diatur)
--   - Konten auto-layout (AutomaticSize.Y)
-- API:
--   local sec = Section.new(parent, { Title, Desc, Collapsible=true, DefaultOpen=true })
--   sec:SetTitle(text) sec:SetDesc(text)
--   sec:Expand() sec:Collapse() sec:Toggle() sec:IsOpen() -> bool
--   sec:GetBody() -> Frame (tempat taruh controls)
--   sec:Add(child:Instance) -- helper, auto-parent ke Body
--   sec:AddSeparator(height?) -- garis tipis di Body
--   sec:Destroy()

local RunService = game:GetService("RunService")
local Theme = require("Theme")

local Section = {}
Section.__index = Section

-- ===== Utilities =====
local function mkSeparator(parent, h)
	local sep = Instance.new("Frame")
	sep.Name = "Separator"
	sep.BackgroundColor3 = Theme.colors.stroke
	sep.BorderSizePixel = 0
	sep.Size = UDim2.new(1, 0, 0, h or 1)
	sep.Parent = parent
	return sep
end

local function makeChevron(parent)
	local lbl = Instance.new("TextLabel")
	lbl.Name = "Chevron"
	lbl.BackgroundTransparency = 1
	lbl.AnchorPoint = Vector2.new(1, 0.5)
	lbl.Position = UDim2.new(1, -10, 0.5, 0)
	lbl.Size = UDim2.fromOffset(14, 16)
	lbl.Text = "▾"
	lbl.TextColor3 = Theme.colors.text.muted
	lbl.Font = Enum.Font.Gotham
	lbl.TextSize = 14
	lbl.Parent = parent
	return lbl
end

-- Compute target height from content (UIListLayout.AbsoluteContentSize)
local function getContentHeight(holder, layout, pad)
	pad = pad or 0
	local size = layout and layout.AbsoluteContentSize or Vector2.zero
	return math.max(0, size.Y + pad)
end

-- ===== Constructor =====
-- parent: Instance container
-- opts: { Title, Desc, Collapsible:boolean?, DefaultOpen:boolean? }
function Section.new(parent, opts)
	opts = opts or {}
	local self = setmetatable({}, Section)

	self._titleTxt   = opts.Title or "Section"
	self._descTxt    = opts.Desc
	self._collapsible = (opts.Collapsible == nil) and true or not not opts.Collapsible
	self._isOpen     = (opts.DefaultOpen == nil) and true or not not opts.DefaultOpen

	-- ===== Root card =====
	local card = Instance.new("Frame")
	card.Name = self._titleTxt
	card.BackgroundColor3 = Theme.colors.card
	card.BorderSizePixel = 0
	card.AutomaticSize = Enum.AutomaticSize.Y
	card.Size = UDim2.new(1, 0, 0, 56) -- minimal tinggi saat header saja
	card.Parent = parent

	local cardCorner = Instance.new("UICorner", card)
	cardCorner.CornerRadius = UDim.new(0, Theme.radius.card)

	local cardStroke = Instance.new("UIStroke", card)
	cardStroke.Color = Theme.colors.stroke
	cardStroke.Thickness = 1
	Theme.applyCard(card, cardStroke)

	local padding = Instance.new("UIPadding", card)
	padding.PaddingLeft = UDim.new(0, 12)
	padding.PaddingRight = UDim.new(0, 12)
	padding.PaddingTop = UDim.new(0, 8)
	padding.PaddingBottom = UDim.new(0, 8)

	local stack = Instance.new("UIListLayout", card)
	stack.FillDirection = Enum.FillDirection.Vertical
	stack.SortOrder = Enum.SortOrder.LayoutOrder
	stack.Padding = UDim.new(0, 8)

	-- ===== Header =====
	local header = Instance.new("TextButton")
	header.Name = "Header"
	header.AutoButtonColor = false
	header.Text = ""
	header.BackgroundColor3 = Theme.colors.input
	header.BorderSizePixel = 0
	header.Size = UDim2.new(1, 0, 0, (self._descTxt and self._descTxt ~= "") and 44 or 32)
	header.LayoutOrder = 1
	header.Parent = card

	local headCorner = Instance.new("UICorner", header)
	headCorner.CornerRadius = UDim.new(0, Theme.radius.input)

	local headStroke = Instance.new("UIStroke", header)
	headStroke.Color = Theme.colors.stroke
	headStroke.Thickness = 1

	local headPad = Instance.new("UIPadding", header)
	headPad.PaddingLeft = UDim.new(0, 10)
	headPad.PaddingRight = UDim.new(0, 28) -- space untuk chevron

	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.BackgroundTransparency = 1
	title.Text = self._titleTxt
	title.TextColor3 = Theme.colors.text.title
	title.Font = Enum.Font.GothamSemibold
	title.TextSize = 15
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Size = UDim2.new(1, -10, 0, (self._descTxt and self._descTxt ~= "") and 20 or 28)
	title.Position = UDim2.new(0, 0, 0, 0)
	title.Parent = header

	local desc = Instance.new("TextLabel")
	desc.Name = "Description"
	desc.BackgroundTransparency = 1
	desc.Text = self._descTxt or ""
	desc.Visible = self._descTxt and self._descTxt ~= ""
	desc.TextColor3 = Theme.colors.text.dim
	desc.Font = Enum.Font.Gotham
	desc.TextSize = 13
	desc.TextXAlignment = Enum.TextXAlignment.Left
	desc.TextWrapped = true
	desc.Size = UDim2.new(1, -10, 0, 18)
	desc.Position = UDim2.new(0, 0, 0, 22)
	desc.Parent = header

	local chev = makeChevron(header)

	-- initial paint header
	Theme.paintNormal(header, headStroke)

	-- ===== Body (content holder) =====
	local bodyWrap = Instance.new("Frame")
	bodyWrap.Name = "BodyWrap"
	bodyWrap.BackgroundTransparency = 1
	bodyWrap.BorderSizePixel = 0
	bodyWrap.ClipsDescendants = true
	bodyWrap.AutomaticSize = Enum.AutomaticSize.Y
	bodyWrap.Size = UDim2.new(1, 0, 0, 0)
	bodyWrap.LayoutOrder = 2
	bodyWrap.Parent = card

	local bodyPadOut = Instance.new("UIPadding", bodyWrap)
	bodyPadOut.PaddingTop = UDim.new(0, 2)

	local body = Instance.new("Frame")
	body.Name = "Body"
	body.BackgroundTransparency = 1
	body.BorderSizePixel = 0
	body.AutomaticSize = Enum.AutomaticSize.Y
	body.Size = UDim2.new(1, 0, 0, 0)
	body.Parent = bodyWrap

	local bodyPad = Instance.new("UIPadding", body)
	bodyPad.PaddingTop = UDim.new(0, 2)
	bodyPad.PaddingBottom = UDim.new(0, 2)

	local list = Instance.new("UIListLayout", body)
	list.FillDirection = Enum.FillDirection.Vertical
	list.SortOrder = Enum.SortOrder.LayoutOrder
	list.Padding = UDim.new(0, 8)

	-- ===== State refs =====
	self._card, self._cardStroke = card, cardStroke
	self._header, self._headStroke = header, headStroke
	self._title, self._desc = title, desc
	self._chev = chev
	self._bodyWrap, self._body, self._list = bodyWrap, body, list

	-- ===== Behaviors =====
	local hovering = false

	local function rotateChevron(isOpen)
		self._chev.Rotation = isOpen and 0 or -90
	end

	local function paintHeader(state)
		if state == "active" then
			Theme.paintSelected(self._header, self._headStroke)
			self._title.TextColor3 = Theme.colors.text.onAcc
			self._desc.TextColor3  = Theme.colors.text.onAcc
		elseif state == "hover" then
			Theme.paintHover(self._header, self._headStroke)
			self._title.TextColor3 = Theme.colors.text.normal
			self._desc.TextColor3  = Theme.colors.text.normal
		else
			Theme.paintNormal(self._header, self._headStroke)
			self._header.BackgroundColor3 = Theme.colors.input
			self._title.TextColor3 = Theme.colors.text.title
			self._desc.TextColor3  = Theme.colors.text.dim
		end
	end

	local function setOpen(open, animate)
		self._isOpen = open and true or false
		rotateChevron(self._isOpen)

		-- ukuran body target
		local targetH = 0
		if self._isOpen then
			targetH = getContentHeight(self._body, self._list, 6)
		end

		if animate then
			Theme.tween(self._bodyWrap, { Size = UDim2.new(1, 0, 0, targetH) }, Theme.tweening.base)
			paintHeader(self._isOpen and "active" or (hovering and "hover" or "normal"))
		else
			self._bodyWrap.Size = UDim2.new(1, 0, 0, targetH)
			paintHeader(self._isOpen and "active" or "normal")
		end
	end

	-- build initial state
	self._bodyWrap.Size = UDim2.new(1, 0, 0, 0)
	rotateChevron(self._isOpen)
	-- tunggu satu frame agar AbsoluteContentSize valid
	RunService.Heartbeat:Wait()
	setOpen(self._isOpen, false)

	-- update tinggi saat konten berubah
	self._list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		if self._isOpen then
			local h = getContentHeight(self._body, self._list, 6)
			Theme.tween(self._bodyWrap, { Size = UDim2.new(1, 0, 0, h) }, Theme.tweening.fast)
		end
	end)

	-- header interactions (jika collapsible)
	if self._collapsible then
		self._header.MouseEnter:Connect(function()
			hovering = true
			if self._isOpen then
				paintHeader("active")
			else
				paintHeader("hover")
			end
		end)

		self._header.MouseLeave:Connect(function()
			hovering = false
			if self._isOpen then
				paintHeader("active")
			else
				paintHeader("normal")
			end
		end)

		self._header.MouseButton1Down:Connect(function()
			if self._isOpen then
				paintHeader("active") -- tetap aktif
			else
				Theme.paintSelected(self._header, self._headStroke) -- press glow
			end
		end)

		self._header.MouseButton1Up:Connect(function()
			if self._isOpen then
				paintHeader("active")
			else
				if hovering then paintHeader("hover") else paintHeader("normal") end
			end
		end)

		self._header.MouseButton1Click:Connect(function()
			self:Toggle()
		end)
	else
		-- non-collapsible: header tampil normal
		self._header.Active = false
		paintHeader("normal")
	end

	-- ===== Public API =====
	function self:SetTitle(text)
		self._titleTxt = text or self._titleTxt
		self._title.Text = self._titleTxt
		self._card.Name = self._titleTxt
	end

	function self:SetDesc(text)
		self._descTxt = text
		self._desc.Text = text or ""
		self._desc.Visible = (text and text ~= "")
		self._header.Size = UDim2.new(1, 0, 0, (self._desc.Visible and 44) or 32)
	end

	function self:Expand() setOpen(true, true) end
	function self:Collapse() setOpen(false, true) end
	function self:Toggle() setOpen(not self._isOpen, true) end
	function self:IsOpen() return self._isOpen end

	function self:GetBody() return self._body end

	function self:Add(child)
		if typeof(child) == "Instance" then
			child.Parent = self._body
		end
	end

	function self:AddSeparator(h)
		return mkSeparator(self._body, h)
	end

	function self:Destroy()
		self._card:Destroy()
	end

	return self
end

return Section

--[[local Section = require(path.to.Section)

local container = someParentFrame
local sec = Section.new(container, {
    Title = "Gameplay",
    Desc = "Pengaturan umum fitur",
    Collapsible = true,
    DefaultOpen = true,
})

-- Taruh komponen di dalam section:
-- local Button = require(path.to.Button)
-- local Toggle = require(path.to.Toggle)
-- local btn = Button.new(sec:GetBody(), { Title = "Run", Callback = function() print("run") end })
-- local tgl = Toggle.new(sec:GetBody(), { Title = "Auto Fish", Default = false, Callback = function(s) print(s) end })

-- Control:
-- sec:Collapse()
-- sec:Expand()
-- sec:Toggle()]]