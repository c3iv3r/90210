-- Tab.lua
-- Private module: Tab system ala Library.txt
-- Integrasi penuh: Theme.lua (warna, gradient, animasi)
-- API:
--   local Tabs = Tab.new(parent, { BarHeight = 36, TabWidth = 120, Padding = 6 })
--   local t1 = Tabs:AddTab("Main")    --> returns { Name, Button, Page, Show(), Hide() }
--   local t2 = Tabs:AddTab("Settings")
--   Tabs:Select("Main")               --> by name / index / ref
--   Tabs:GetActive()                  --> returns tab ref or nil
--   Tabs:Remove("Settings")           --> hapus tab
--   Tabs:Rename("Main","Home")
--   Tabs:Destroy()

local Theme = require("Theme")

local Tab = {}
Tab.__index = Tab

-- ===== Utilities =====
local function asName(v)
	if typeof(v) == "string" then return v end
	if typeof(v) == "number" then return v end
	if type(v) == "table" and v.Name then return v.Name end
	return nil
end

local function makeTabButton(text, width, height)
	local btn = Instance.new("TextButton")
	btn.Name = text
	btn.Text = text
	btn.AutoButtonColor = false
	btn.BackgroundColor3 = Theme.colors.input
	btn.BorderSizePixel = 0
	btn.Size = UDim2.fromOffset(width, height)

	local corner = Instance.new("UICorner", btn)
	corner.CornerRadius = UDim.new(0, Theme.radius.input)

	local stroke = Instance.new("UIStroke", btn)
	stroke.Color = Theme.colors.stroke
	stroke.Thickness = 1

	btn.Font = Enum.Font.Gotham
	btn.TextSize = 13
	btn.TextColor3 = Theme.colors.text.normal
	btn.TextWrapped = true

	return btn, stroke
end

-- ===== Constructor =====
-- parent: Instance (container)
-- opts: { BarHeight:number?, TabWidth:number?, Padding:number? }
function Tab.new(parent, opts)
	opts = opts or {}
	local self = setmetatable({}, Tab)

	self._tabs = {}
	self._order = {}
	self._active = nil

	self._barHeight = tonumber(opts.BarHeight) or 36
	self._tabWidth  = tonumber(opts.TabWidth)  or 120
	self._padding   = tonumber(opts.Padding)   or 6

	-- ===== Root container =====
	local root = Instance.new("Frame")
	root.Name = "Tabs"
	root.BackgroundTransparency = 1
	root.Size = UDim2.fromScale(1,1)
	root.Parent = parent

	-- ===== TabBar (Scrolling) =====
	local barWrap = Instance.new("Frame")
	barWrap.Name = "TabBarWrap"
	barWrap.BackgroundTransparency = 1
	barWrap.Size = UDim2.new(1, 0, 0, self._barHeight + 12) -- +top/bot breathing
	barWrap.Parent = root

	local bar = Instance.new("ScrollingFrame")
	bar.Name = "TabBar"
	bar.Active = true
	bar.AutomaticCanvasSize = Enum.AutomaticSize.X
	bar.ScrollBarThickness = 4
	bar.ScrollingDirection = Enum.ScrollingDirection.X
	bar.BorderSizePixel = 0
	bar.BackgroundTransparency = 1
	bar.Size = UDim2.new(1, -24, 0, self._barHeight) -- margin 12 kiri/kanan
	bar.Position = UDim2.new(0, 12, 0, 6)
	bar.Parent = barWrap

	local layout = Instance.new("UIListLayout", bar)
	layout.FillDirection = Enum.FillDirection.Horizontal
	layout.Padding = UDim.new(0, self._padding)
	layout.SortOrder = Enum.SortOrder.LayoutOrder

	local pad = Instance.new("UIPadding", bar)
	pad.PaddingLeft = UDim.new(0, 0)
	pad.PaddingTop = UDim.new(0, 0)

	-- ===== Separator line (optional, ala Library.txt) =====
	local sep = Instance.new("Frame")
	sep.Name = "Separator"
	sep.BackgroundColor3 = Theme.colors.stroke
	sep.BorderSizePixel = 0
	sep.Position = UDim2.new(0, 12, 0, self._barHeight + 8)
	sep.Size = UDim2.new(1, -24, 0, 1)
	sep.Parent = root

	-- ===== Pages container =====
	local pages = Instance.new("Frame")
	pages.Name = "Pages"
	pages.BackgroundTransparency = 1
	pages.Position = UDim2.new(0, 12, 0, self._barHeight + 14)
	pages.Size = UDim2.new(1, -24, 1, -(self._barHeight + 20))
	pages.ClipsDescendants = true
	pages.Parent = root

	self._root = root
	self._bar = bar
	self._pages = pages

	-- ===== Styling helper =====
	local function paintTabButton(btn, stroke, state) -- state: "active"|"hover"|"normal"|"disabled"
		if state == "active" then
			Theme.paintSelected(btn, stroke)
			btn.TextColor3 = Theme.colors.text.onAcc
		elseif state == "hover" then
			Theme.paintHover(btn, stroke)
			btn.TextColor3 = Theme.colors.text.normal
		elseif state == "disabled" then
			Theme.paintNormal(btn, stroke)
			btn.BackgroundColor3 = Theme.colors.card
			btn.TextColor3 = Theme.colors.text.dim
		else
			Theme.paintNormal(btn, stroke)
			btn.BackgroundColor3 = Theme.colors.input
			btn.TextColor3 = Theme.colors.text.normal
		end
	end
	self._paintTabButton = paintTabButton

	-- ===== Public: AddTab =====
	function self:AddTab(name)
		assert(type(name) == "string" and #name > 0, "AddTab(name): name string wajib")

		-- Button
		local btn, stroke = makeTabButton(name, self._tabWidth, self._barHeight)
		btn.LayoutOrder = #self._order + 1
		btn.Parent = self._bar

		-- Page
		local page = Instance.new("Frame")
		page.Name = name
		page.BackgroundColor3 = Theme.colors.card
		page.BackgroundTransparency = 1
		page.BorderSizePixel = 0
		page.Visible = false
		page.Size = UDim2.fromScale(1,1)
		page.Parent = self._pages

		local pagePad = Instance.new("UIPadding", page)
		pagePad.PaddingTop = UDim.new(0, 8)
		pagePad.PaddingLeft = UDim.new(0, 0)
		pagePad.PaddingRight = UDim.new(0, 0)
		pagePad.PaddingBottom = UDim.new(0, 8)

		-- Hover/Active behaviors
		local hovering = false
		btn.MouseEnter:Connect(function()
			hovering = true
			if self._active ~= name then paintTabButton(btn, stroke, "hover") end
		end)
		btn.MouseLeave:Connect(function()
			hovering = false
			if self._active ~= name then paintTabButton(btn, stroke, "normal") end
		end)
		btn.MouseButton1Click:Connect(function()
			self:Select(name)
		end)

		-- Store
		local ref = {
			Name = name,
			Button = btn,
			ButtonStroke = stroke,
			Page = page,
			Show = function()
				page.Visible = true
			end,
			Hide = function()
				page.Visible = false
			end,
		}
		self._tabs[name] = ref
		table.insert(self._order, name)

		-- Initial paint
		paintTabButton(btn, stroke, "normal")

		-- Auto-select if first
		if not self._active then
			self:Select(name)
		end

		return ref
	end

	-- ===== Public: Select =====
	function self:Select(which)
		local key = asName(which)
		if key == nil then return end

		-- index support
		if typeof(key) == "number" then
			key = self._order[key]
		end
		if not key or not self._tabs[key] then return end

		if self._active == key then return end

		-- deactivate previous
		if self._active and self._tabs[self._active] then
			local prev = self._tabs[self._active]
			prev:Hide()
			self._paintTabButton(prev.Button, prev.ButtonStroke, "normal")
		end

		-- activate new
		self._active = key
		local cur = self._tabs[key]
		cur:Show()
		self._paintTabButton(cur.Button, cur.ButtonStroke, "active")

		-- simple reveal anim: small fade-in on page
		cur.Page.BackgroundTransparency = 1
		Theme.tween(cur.Page, { BackgroundTransparency = 1 }, Theme.tweening.fast) -- keep transparent (content frames handle their own bg)
	end

	-- ===== Public helpers =====
	function self:GetActive()
		return self._active and self._tabs[self._active] or nil
	end

	function self:Remove(which)
		local key = asName(which)
		if typeof(key) == "number" then key = self._order[key] end
		local ref = key and self._tabs[key]
		if not ref then return end

		-- If removing active, shift to neighbor
		local nextName = nil
		if self._active == key then
			-- find neighbor in order
			local idx = table.find(self._order, key)
			if idx then
				nextName = self._order[idx+1] or self._order[idx-1]
			end
		end

		-- destroy UI
		ref.Button:Destroy()
		ref.Page:Destroy()

		-- remove from tables
		self._tabs[key] = nil
		local i = table.find(self._order, key)
		if i then table.remove(self._order, i) end

		-- select neighbor
		if nextName then
			self:Select(nextName)
		else
			self._active = nil
		end
	end

	function self:Rename(oldName, newName)
		if type(oldName) ~= "string" or type(newName) ~= "string" or #newName == 0 then return end
		local ref = self._tabs[oldName]
		if not ref then return end
		if self._tabs[newName] then return end -- avoid conflict

		ref.Name = newName
		ref.Button.Name = newName
		ref.Button.Text = newName
		ref.Page.Name = newName

		self._tabs[newName] = ref
		self._tabs[oldName] = nil

		for i, n in ipairs(self._order) do
			if n == oldName then
				self._order[i] = newName
				break
			end
		end

		if self._active == oldName then
			self._active = newName
		end
	end

	function self:Destroy()
		for _, name in ipairs(self._order) do
			local ref = self._tabs[name]
			if ref then
				ref.Button:Destroy()
				ref.Page:Destroy()
			end
		end
		self._tabs = {}
		self._order = {}
		self._active = nil
		self._root:Destroy()
	end

	return self
end

return Tab

--[[local Tab = require(path.to.Tab)

local container = someParentFrame -- frame window kamu
local tabs = Tab.new(container, {
    BarHeight = 36,
    TabWidth  = 120,
    Padding   = 6,
})

local tMain = tabs:AddTab("Main")
local tMisc = tabs:AddTab("Misc")
local tAbout = tabs:AddTab("About")

-- Isi konten ke dalam page (Frame) masing-masing:
-- contoh:
-- local label = Instance.new("TextLabel")
-- label.Text = "Halo dari Main!"
-- label.Size = UDim2.new(1, 0, 0, 24)
-- label.Parent = tMain.Page

-- Pindah tab:
-- tabs:Select("Misc")    -- by name
-- tabs:Select(1)         -- by index
-- local active = tabs:GetActive()

-- Rename / Remove:
-- tabs:Rename("About", "Info")
-- tabs:Remove("Misc")]]