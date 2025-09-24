-- Dropdown.lua
-- Private module: Dropdown ala Library.txt
-- Integrasi: Theme (warna, gradient, animasi)
-- src/element/dropdown.lua

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local Theme = require("Theme")

local Dropdown = {}
Dropdown.__index = Dropdown

-- ===== Utils =====
local function joinComma(list)
	if type(list) ~= "table" then return tostring(list or "") end
	local t = {}
	for _, v in ipairs(list) do table.insert(t, tostring(v)) end
	return table.concat(t, ", ")
end
local function uniqStrings(arr)
	local seen, out = {}, {}
	for _, v in ipairs(arr or {}) do
		if typeof(v) == "string" and not seen[v] then
			seen[v] = true; table.insert(out, v)
		end
	end
	return out
end

-- ===== Overlay (singleton) =====
local OVERLAY_TAG = "LogicDev_DropdownOverlay"

local function buildOverlay()
	local sg = Instance.new("ScreenGui")
	sg.Name = OVERLAY_TAG
	sg.ResetOnSpawn = false
	sg.IgnoreGuiInset = true
	sg.Enabled = false
	sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	sg.Parent = (gethui and gethui()) or CoreGui

	local dark = Instance.new("TextButton")
	dark.Name = "Backdrop"
	dark.AutoButtonColor = false
	dark.BackgroundColor3 = Theme.colors.overlay
	dark.BackgroundTransparency = 0.35
	dark.BorderSizePixel = 0
	dark.Text = ""
	dark.Size = UDim2.fromScale(1,1)
	dark.Parent = sg

	local panel = Instance.new("Frame")
	panel.Name = "Panel"
	panel.AnchorPoint = Vector2.new(0.5, 0.5)
	panel.Position = UDim2.fromScale(0.5, 0.5)
	panel.Size = UDim2.fromOffset(520, 420)
	panel.BackgroundColor3 = Theme.colors.card
	panel.BorderSizePixel = 0
	panel.Parent = sg

	local corner = Instance.new("UICorner", panel)
	corner.CornerRadius = UDim.new(0, Theme.radius.popup)

	local stroke = Instance.new("UIStroke", panel)
	stroke.Color = Theme.colors.stroke
	stroke.Thickness = 1.25

	local top = Instance.new("Frame")
	top.Name = "TopBar"
	top.BackgroundTransparency = 1
	top.Size = UDim2.new(1, 0, 0, 56)
	top.Parent = panel

	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.BackgroundTransparency = 1
	title.Text = "Dropdown"
	title.TextColor3 = Theme.colors.text.title
	title.Font = Enum.Font.GothamSemibold
	title.TextSize = 18
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Position = UDim2.new(0, 16, 0, 0)
	title.Size = UDim2.new(1, -32, 1, 0)
	title.Parent = top

	local close = Instance.new("TextButton")
	close.Name = "Close"
	close.AnchorPoint = Vector2.new(1, 0.5)
	close.Position = UDim2.new(1, -14, 0.5, 0)
	close.Size = UDim2.fromOffset(28, 28)
	close.AutoButtonColor = false
	close.BackgroundTransparency = 1
	close.Text = "✕"
	close.TextColor3 = Theme.colors.text.muted
	close.Font = Enum.Font.Gotham
	close.TextSize = 16
	close.Parent = top

	local searchBox = Instance.new("TextBox")
	searchBox.Name = "Search"
	searchBox.BackgroundColor3 = Theme.colors.input
	searchBox.TextColor3 = Theme.colors.text.normal
	searchBox.PlaceholderText = "Search…"
	searchBox.PlaceholderColor3 = Theme.colors.text.dim
	searchBox.Font = Enum.Font.Gotham
	searchBox.TextSize = 14
	searchBox.BorderSizePixel = 0
	searchBox.Position = UDim2.new(0, 16, 0, 64)
	searchBox.Size = UDim2.new(1, -32, 0, 34)
	searchBox.Parent = panel
	do
		local c = Instance.new("UICorner", searchBox)
		c.CornerRadius = UDim.new(0, Theme.radius.input)
		local s = Instance.new("UIStroke", searchBox)
		s.Color = Theme.colors.stroke
		s.Thickness = 1
		Theme.applyInputBox(searchBox, s)
	end

	local holder = Instance.new("Frame")
	holder.Name = "Lists"
	holder.Position = UDim2.new(0, 16, 0, 108)
	holder.Size = UDim2.new(1, -32, 1, -124)
	holder.BackgroundTransparency = 1
	holder.Parent = panel

	local function makeList(name)
		local sc = Instance.new("ScrollingFrame")
		sc.Name = name
		sc.Active = true
		sc.AutomaticCanvasSize = Enum.AutomaticSize.Y
		sc.ScrollBarThickness = 4
		sc.BorderSizePixel = 0
		sc.BackgroundTransparency = 1
		sc.Size = UDim2.fromScale(1,1)
		local lay = Instance.new("UIListLayout", sc)
		lay.Padding = UDim.new(0, 6)
		lay.SortOrder = Enum.SortOrder.LayoutOrder
		return sc
	end

	local listAll = makeList("DropdownItems")
	listAll.Parent = holder
	local listSearch = makeList("DropdownItemsSearch")
	listSearch.Visible = false
	listSearch.Parent = holder

	local overlay = {
		Gui = sg,
		Backdrop = dark,
		Panel = panel,
		Title = title,
		Close = close,
		Search = searchBox,
		ListAll = listAll,
		ListSearch = listSearch,
	}

	function overlay:Show(keyTitle)
		self.Title.Text = keyTitle or "Dropdown"
		self.Search.Text = ""
		self.ListSearch.Visible = false
		self.ListAll.Visible = true
		self.Gui.Enabled = true
		Theme.popupIn(self.Panel)
	end

	function overlay:Hide()
		Theme.popupOut(self.Panel, function()
			self.Gui.Enabled = false
		end)
	end

	close.MouseButton1Click:Connect(function() overlay:Hide() end)
	dark.MouseButton1Click:Connect(function() overlay:Hide() end)

	searchBox:GetPropertyChangedSignal("Text"):Connect(function()
		local q = string.lower(searchBox.Text or "")
		local useSearch = #q > 0
		overlay.ListAll.Visible = not useSearch
		overlay.ListSearch.Visible = useSearch
		-- per-dropdown akan isi listSearch sesuai q
	end)

	return overlay
end

local Overlay = _G.__ld_dropdown_overlay_instance
if not Overlay then
	Overlay = buildOverlay()
	_G.__ld_dropdown_overlay_instance = Overlay
end

-- ===== Item builder =====
local function makeItemButton(text)
	local btn = Instance.new("TextButton")
	btn.Name = text
	btn.AutoButtonColor = false
	btn.Text = ""
	btn.BackgroundColor3 = Theme.colors.item
	btn.BorderSizePixel = 0
	btn.Size = UDim2.new(1, 0, 0, 44)

	local corner = Instance.new("UICorner", btn)
	corner.CornerRadius = UDim.new(0, Theme.radius.item)

	local stroke = Instance.new("UIStroke", btn)
	stroke.Color = Theme.colors.stroke
	stroke.Thickness = 1

	local inner = Instance.new("Frame")
	inner.Name = "Frame"
	inner.BackgroundTransparency = 1
	inner.Size = UDim2.fromScale(1,1)
	inner.Parent = btn

	local t = Instance.new("TextLabel")
	t.Name = "Title"
	t.BackgroundTransparency = 1
	t.Text = text
	t.Font = Enum.Font.Gotham
	t.TextSize = 14
	t.TextColor3 = Theme.colors.text.normal
	t.TextXAlignment = Enum.TextXAlignment.Left
	t.Position = UDim2.new(0, 12, 0, 0)
	t.Size = UDim2.new(1, -24, 1, 0)
	t.Parent = inner

	return btn, inner, t, stroke
end

-- ===== Constructor =====
-- parent: Instance
-- opts: { Title, Desc, Multi, Values, Value, AllowNone, Locked, Callback }
function Dropdown.new(parent, opts)
	opts = opts or {}
	local self = setmetatable({}, Dropdown)

	self._locked     = opts.Locked or opts.Lock or false
	self._multi      = opts.Multi or false
	self._allowNone  = opts.AllowNone or false
	self._values     = uniqStrings(opts.Values or {})
	self._value      = self._multi and (opts.Value or {}) or (opts.Value or opts.Default)
	self._callback   = typeof(opts.Callback) == "function" and opts.Callback or function() end
	self._titleText  = opts.Title or "Dropdown"
	self._descText   = opts.Desc

	-- Card
	local card = Instance.new("Frame")
	card.Name = self._titleText
	card.BackgroundColor3 = Theme.colors.card
	card.BorderSizePixel = 0
	card.Size = UDim2.new(1, 0, 0, opts.Desc and 72 or 56)
	card.Parent = parent

	local cardCorner = Instance.new("UICorner", card)
	cardCorner.CornerRadius = UDim.new(0, Theme.radius.card)

	local cardStroke = Instance.new("UIStroke", card)
	cardStroke.Color = Theme.colors.stroke
	cardStroke.Thickness = 1
	Theme.applyCard(card, cardStroke)

	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.BackgroundTransparency = 1
	title.Text = self._titleText
	title.TextColor3 = Theme.colors.text.title
	title.Font = Enum.Font.GothamSemibold
	title.TextSize = 16
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Position = UDim2.new(0, 12, 0, 8)
	title.Size = UDim2.new(1, -24, 0, 18)
	title.Parent = card

	local desc = Instance.new("TextLabel")
	desc.Name = "Description"
	desc.BackgroundTransparency = 1
	desc.Text = self._descText or ""
	desc.Visible = self._descText and self._descText ~= ""
	desc.TextColor3 = Theme.colors.text.dim
	desc.Font = Enum.Font.Gotham
	desc.TextSize = 13
	desc.TextXAlignment = Enum.TextXAlignment.Left
	desc.TextWrapped = true
	desc.Position = UDim2.new(0, 12, 0, 28)
	desc.Size = UDim2.new(1, -24, 0, 18)
	desc.Parent = card

	local box = Instance.new("TextButton")
	box.Name = "Trigger"
	box.AutoButtonColor = false
	box.BackgroundColor3 = Theme.colors.input
	box.Text = ""
	box.BorderSizePixel = 0
	box.AnchorPoint = Vector2.new(1, 0.5)
	box.Position = UDim2.new(1, -12, 0, self._descText and 36 or 28)
	box.Size = UDim2.fromOffset(220, 28)
	box.Parent = card

	local boxCorner = Instance.new("UICorner", box)
	boxCorner.CornerRadius = UDim.new(0, Theme.radius.input)

	local boxStroke = Instance.new("UIStroke", box)
	boxStroke.Color = Theme.colors.stroke
	boxStroke.Thickness = 1
	Theme.applyInputBox(box, boxStroke)

	local boxLabel = Instance.new("TextLabel")
	boxLabel.Name = "Title"
	boxLabel.BackgroundTransparency = 1
	boxLabel.Text = ""
	boxLabel.Font = Enum.Font.Gotham
	boxLabel.TextSize = 13
	boxLabel.TextXAlignment = Enum.TextXAlignment.Left
	boxLabel.TextColor3 = Theme.colors.text.normal
	boxLabel.Position = UDim2.new(0, 10, 0, 0)
	boxLabel.Size = UDim2.new(1, -20, 1, 0)
	boxLabel.Parent = box

	local chev = Instance.new("TextLabel")
	chev.Name = "ClickIcon"
	chev.BackgroundTransparency = 1
	chev.AnchorPoint = Vector2.new(1, 0.5)
	chev.Position = UDim2.new(1, -8, 0.5, 0)
	chev.Size = UDim2.fromOffset(12, 16)
	chev.Text = "▾"
	chev.TextColor3 = Theme.colors.text.muted
	chev.Font = Enum.Font.Gotham
	chev.TextSize = 14
	chev.Parent = title

	self._card, self._stroke, self._box, self._boxLabel, self._chev, self._title, self._desc =
		card, cardStroke, box, boxLabel, chev, title, desc

	-- ===== Overlay list containers (per-dropdown) =====
	local listAll = Instance.new("Frame")
	listAll.Name = self._titleText
	listAll.BackgroundTransparency = 1
	listAll.Size = UDim2.fromScale(1,1)
	listAll.Visible = false

	local listAllScroller = Instance.new("ScrollingFrame")
	listAllScroller.Name = "DropdownItems"
	listAllScroller.Active = true
	listAllScroller.AutomaticCanvasSize = Enum.AutomaticSize.Y
	listAllScroller.ScrollBarThickness = 4
	listAllScroller.BackgroundTransparency = 1
	listAllScroller.Size = UDim2.fromScale(1,1)
	listAllScroller.Parent = listAll
	local layAll = Instance.new("UIListLayout", listAllScroller)
	layAll.Padding = UDim.new(0,6)
	layAll.SortOrder = Enum.SortOrder.LayoutOrder

	local listSearch = Instance.new("Frame")
	listSearch.Name = self._titleText .. "_Search"
	listSearch.BackgroundTransparency = 1
	listSearch.Size = UDim2.fromScale(1,1)
	listSearch.Visible = false

	local listSearchScroller = Instance.new("ScrollingFrame")
	listSearchScroller.Name = "DropdownItemsSearch"
	listSearchScroller.Active = true
	listSearchScroller.AutomaticCanvasSize = Enum.AutomaticSize.Y
	listSearchScroller.ScrollBarThickness = 4
	listSearchScroller.BackgroundTransparency = 1
	listSearchScroller.Size = UDim2.fromScale(1,1)
	listSearchScroller.Parent = listSearch
	local layS = Instance.new("UIListLayout", listSearchScroller)
	layS.Padding = UDim.new(0,6)
	layS.SortOrder = Enum.SortOrder.LayoutOrder

	listAll.Parent = Overlay.ListAll
	listSearch.Parent = Overlay.ListSearch

	-- ===== Core selection logic =====
	local current = self._multi and (table.clone(self._value) or {}) or self._value
	self._selected = current

	local function setBoxLabel(v)
		if self._multi then self._boxLabel.Text = joinComma(v or {}) else self._boxLabel.Text = v and tostring(v) or "" end
	end
	local function isSelected(val)
		if self._multi then return table.find(self._selected or {}, val) ~= nil else return self._selected == val end
	end
	local function chooseSingle(val)
		self._selected = val; setBoxLabel(val); self._callback(val)
	end
	local function toggleMulti(val)
		local idx = table.find(self._selected, val)
		if idx then
			if not self._allowNone and #self._selected == 1 then return end
			table.remove(self._selected, idx)
		else
			table.insert(self._selected, val)
		end
		setBoxLabel(self._selected); self._callback(self._selected)
	end

	local function paintButton(btn, sel)
		local label = btn.Frame and btn.Frame:FindFirstChild("Title")
		Theme.applyDropdownItem(btn, label, sel)
	end

	local function rebuild(values, resetSel)
		values = uniqStrings(values or self._values)
		self._values = values
		if resetSel then
			self._selected = self._multi and {} or nil
			setBoxLabel(self._selected)
		end
		for _, sc in ipairs({listAllScroller, listSearchScroller}) do
			for _, ch in ipairs(sc:GetChildren()) do if ch:IsA("GuiButton") then ch:Destroy() end end
		end

		for _, name in ipairs(values) do
			local btn = makeItemButton(name)
			btn[1].Parent = listAllScroller
			paintButton(btn[1], isSelected(name))
			btn[1].MouseEnter:Connect(function() if not isSelected(name) then Theme.paintHover(btn[1], btn[1]:FindFirstChildOfClass("UIStroke")) end end)
			btn[1].MouseLeave:Connect(function() paintButton(btn[1], isSelected(name)) end)
			btn[1].MouseButton1Click:Connect(function()
				if self._locked then return end
				if self._multi then
					toggleMulti(name)
					paintButton(btn[1], isSelected(name))
				else
					chooseSingle(name)
					for _, sib in ipairs(listAllScroller:GetChildren()) do
						if sib:IsA("GuiButton") then paintButton(sib, sib.Name == name) end
					end
				end
			end)
		end

		local function rebuildSearch(q)
			for _, ch in ipairs(listSearchScroller:GetChildren()) do if ch:IsA("GuiButton") then ch:Destroy() end end
			if not q or #q == 0 then return end
			local lq = string.lower(q)
			for _, name in ipairs(values) do
				if string.find(string.lower(name), lq, 1, true) then
					local btn = makeItemButton(name)
					btn[1].Parent = listSearchScroller
					paintButton(btn[1], isSelected(name))
					btn[1].MouseEnter:Connect(function() if not isSelected(name) then Theme.paintHover(btn[1], btn[1]:FindFirstChildOfClass("UIStroke")) end end)
					btn[1].MouseLeave:Connect(function() paintButton(btn[1], isSelected(name)) end)
					btn[1].MouseButton1Click:Connect(function()
						if self._locked then return end
						if self._multi then
							toggleMulti(name)
							paintButton(btn[1], isSelected(name))
						else
							chooseSingle(name)
							for _, sib in ipairs(listSearchScroller:GetChildren()) do
								if sib:IsA("GuiButton") then paintButton(sib, sib.Name == name) end
							end
						end
					end)
				end
			end
		end

		if self._searchConn then self._searchConn:Disconnect() end
		self._searchConn = Overlay.Search:GetPropertyChangedSignal("Text"):Connect(function()
			rebuildSearch(Overlay.Search.Text)
		end)

		setBoxLabel(self._selected)
	end

	rebuild(self._values, false)

	self._box.MouseButton1Click:Connect(function()
		if self._locked then return end
		Overlay:Show(self._titleText)
		for _, node in ipairs(Overlay.ListAll:GetChildren()) do
			if node:IsA("Frame") then node.Visible = (node == listAll) end
		end
		for _, node in ipairs(Overlay.ListSearch:GetChildren()) do
			if node:IsA("Frame") then node.Visible = (node == listSearch) end
		end
	end)

	if self._locked then
		self._box.Active = false
	end

	-- API
	function self:SetTitle(newTitle)
		self._titleText = newTitle or self._titleText
		self._title.Text = self._titleText
	end
	function self:SetDesc(newDesc)
		self._descText = newDesc
		self._desc.Text = newDesc or ""
		self._desc.Visible = (newDesc and newDesc ~= "")
		self._card.Size = UDim2.new(1, 0, 0, self._desc.Visible and 72 or 56)
	end
	function self:Refresh(newValues)
		rebuild(newValues, true)
	end
	function self:Select(v)
		if self._multi then
			self._selected = uniqStrings(v or {})
			setBoxLabel(self._selected); self._callback(self._selected)
			for _, b in ipairs(listAllScroller:GetChildren()) do if b:IsA("GuiButton") then paintButton(b, isSelected(b.Name)) end end
			for _, b in ipairs(listSearchScroller:GetChildren()) do if b:IsA("GuiButton") then paintButton(b, isSelected(b.Name)) end end
		else
			self._selected = v
			setBoxLabel(self._selected); self._callback(self._selected)
			for _, b in ipairs(listAllScroller:GetChildren()) do if b:IsA("GuiButton") then paintButton(b, b.Name == v) end end
			for _, b in ipairs(listSearchScroller:GetChildren()) do if b:IsA("GuiButton") then paintButton(b, b.Name == v) end end
		end
	end
	function self:GetValue() return self._selected end
	function self:Lock() self._locked = true; self._box.Active = false end
	function self:Unlock() self._locked = false; self._box.Active = true end
	function self:Destroy()
		if self._searchConn then self._searchConn:Disconnect() end
		self._card:Destroy()
		listAll:Destroy()
		listSearch:Destroy()
	end

	self:Select(self._selected)
	return self
end

return Dropdown

--[[local Dropdown = require(path.to.Dropdown)

local container = someParentFrame -- tempat naruh kartu dropdown
local dd = Dropdown.new(container, {
    Title = "Select Rarity",
    Desc = "Pilih tier ikan",
    Multi = true,
    Values = { "SECRET","Mythic","Legendary","Epic","Rare","Uncommon","Common" },
    Value  = { "Epic","Rare" },
    AllowNone = true,
    Callback = function(selected)
        print("Selected:", typeof(selected)=="table" and table.concat(selected,", ") or selected)
    end
})

-- Update judul/desc
-- dd:SetTitle("Rarity")
-- dd:SetDesc("Filter favorit")

-- Refresh isi list:
-- dd:Refresh({ "A","B","C" })

-- Pilih programatis:
-- dd:Select({ "Legendary","Epic" }) -- multi
-- dd:Select("Legendary")            -- single]]