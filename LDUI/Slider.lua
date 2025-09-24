-- Slider.lua
-- Private module: Slider ala Library.txt
-- Integrasi penuh: Theme.lua (warna, gradient, animasi)
-- API:
--   Slider.new(parent, { Title, Desc, Min, Max, Default, Step, Format, Locked, Disabled, Callback })
--   :Set(value:number, silent:boolean?) :Get() -> number
--   :SetMinMax(min:number, max:number) :SetStep(step:number) :SetFormat(fn)
--   :SetTitle(text) :SetDesc(text)
--   :Lock() :Unlock() :Disable() :Enable()
--   :Destroy()

local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")

local Theme = require("Theme")

local Slider = {}
Slider.__index = Slider

-- ===== Utilities =====
local function clamp(v, a, b)
	if v < a then return a end
	if v > b then return b end
	return v
end

local function quantize(v, step)
	if not step or step <= 0 then return v end
	return math.floor((v/step) + 0.5) * step
end

local function getAbsRect(gui)
	local absPos, absSize = gui.AbsolutePosition, gui.AbsoluteSize
	return absPos.X, absPos.Y, absSize.X, absSize.Y
end

-- ===== Constructor =====
-- parent: Instance (container Frame)
-- opts: { Title, Desc, Min, Max, Default, Step, Format, Locked, Disabled, Callback }
function Slider.new(parent, opts)
	opts = opts or {}
	local self = setmetatable({}, Slider)

	self._titleTxt = opts.Title or "Slider"
	self._descTxt  = opts.Desc
	self._min      = tonumber(opts.Min) or 0
	self._max      = tonumber(opts.Max) or 100
	if self._max < self._min then self._max, self._min = self._min, self._max end

	self._step     = tonumber(opts.Step) or 1
	self._value    = tonumber(opts.Default) or self._min
	self._value    = clamp(quantize(self._value, self._step), self._min, self._max)

	self._format   = (typeof(opts.Format) == "function") and opts.Format or function(v) return tostring(v) end
	self._callback = (typeof(opts.Callback) == "function") and opts.Callback or function() end
	self._locked   = opts.Locked or opts.Lock or false
	self._disabled = opts.Disabled or false

	-- ===== Card (56px / 72px jika ada desc) =====
	local card = Instance.new("Frame")
	card.Name = self._titleTxt
	card.BackgroundColor3 = Theme.colors.card
	card.BorderSizePixel = 0
	card.Size = UDim2.new(1, 0, 0, self._descTxt and 72 or 56)
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
	title.Text = self._titleTxt
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
	desc.Text = self._descTxt or ""
	desc.Visible = self._descTxt and self._descTxt ~= ""
	desc.TextColor3 = Theme.colors.text.dim
	desc.Font = Enum.Font.Gotham
	desc.TextSize = 13
	desc.TextXAlignment = Enum.TextXAlignment.Left
	desc.TextWrapped = true
	desc.Position = UDim2.new(0, 12, 0, 28)
	desc.Size = UDim2.new(1, -24, 0, 18)
	desc.Parent = card

	-- ===== Track (bar), Fill, Knob, Value Label =====
	local track = Instance.new("Frame")
	track.Name = "Track"
	track.BackgroundColor3 = Theme.colors.input
	track.BorderSizePixel = 0
	track.AnchorPoint = Vector2.new(1, 0.5)
	track.Position = UDim2.new(1, -12, 0, self._descTxt and 36 or 28)
	track.Size = UDim2.fromOffset(220, 6)
	track.Parent = card
	local trackCorner = Instance.new("UICorner", track)
	trackCorner.CornerRadius = UDim.new(1, 3)
	local trackStroke = Instance.new("UIStroke", track)
	trackStroke.Color = Theme.colors.stroke
	trackStroke.Thickness = 1
	Theme.applyInputBox(track, trackStroke)

	local fill = Instance.new("Frame")
	fill.Name = "Fill"
	fill.BackgroundColor3 = Theme.colors.input
	fill.BorderSizePixel = 0
	fill.Size = UDim2.new(0, 0, 1, 0)
	fill.Parent = track
	local fillCorner = Instance.new("UICorner", fill)
	fillCorner.CornerRadius = UDim.new(1, 3)
	-- gradient biru OG pada fill saat aktif
	local g = Instance.new("UIGradient")
	g.Name = "ThemeGradient"
	g.Color = Theme.gradients.BlueOG.Color
	g.Transparency = Theme.gradients.BlueOG.Transparency
	g.Parent = fill

	local knob = Instance.new("Frame")
	knob.Name = "Knob"
	knob.Size = UDim2.fromOffset(14, 14)
	knob.AnchorPoint = Vector2.new(0.5, 0.5)
	knob.Position = UDim2.new(0, 0, 0.5, 0)
	knob.BackgroundColor3 = Color3.fromRGB(245, 248, 255)
	knob.BorderSizePixel = 0
	knob.Parent = track
	local knobCorner = Instance.new("UICorner", knob)
	knobCorner.CornerRadius = UDim.new(1, 0)
	local knobStroke = Instance.new("UIStroke", knob)
	knobStroke.Color = Color3.fromRGB(220, 228, 255)
	knobStroke.Thickness = 0.8

	local valueLabel = Instance.new("TextLabel")
	valueLabel.Name = "Value"
	valueLabel.BackgroundTransparency = 1
	valueLabel.Text = ""
	valueLabel.Font = Enum.Font.Gotham
	valueLabel.TextSize = 13
	valueLabel.TextXAlignment = Enum.TextXAlignment.Right
	valueLabel.TextColor3 = Theme.colors.text.normal
	valueLabel.AnchorPoint = Vector2.new(1, 0.5)
	valueLabel.Position = UDim2.new(1, -12, 0, self._descTxt and 18 or 8)
	valueLabel.Size = UDim2.fromOffset(220, 16)
	valueLabel.Parent = card

	-- ===== State refs =====
	self._card, self._stroke   = card, cardStroke
	self._title, self._desc    = title, desc
	self._track, self._fill    = track, fill
	self._knob, self._valLabel = knob, valueLabel
	self._trackStroke          = trackStroke

	-- ===== Painters =====
	local function paintDisabled()
		Theme.paintNormal(track, trackStroke)
		Theme.tween(track, { BackgroundColor3 = Theme.colors.card }, Theme.tweening.fast)
		valueLabel.TextColor3 = Theme.colors.text.dim
	end

	local function paintNormal()
		Theme.paintNormal(track, trackStroke)
		Theme.tween(track, { BackgroundColor3 = Theme.colors.input }, Theme.tweening.fast)
		valueLabel.TextColor3 = Theme.colors.text.normal
	end

	local function paintHover()
		Theme.paintHover(track, trackStroke)
	end

	local function ratioFromValue(v)
		if self._max == self._min then return 0 end
		return (v - self._min) / (self._max - self._min)
	end

	local function updateVisualByValue()
		local r = clamp(ratioFromValue(self._value), 0, 1)
		local w = math.floor(r * self._track.AbsoluteSize.X + 0.5)
		self._fill.Size = UDim2.new(0, w, 1, 0)
		self._knob.Position = UDim2.new(0, w, 0.5, 0)
		self._valLabel.Text = self._format(self._value)
	end

	local function applyInitial()
		updateVisualByValue()
		if self._disabled then paintDisabled() else paintNormal() end
	end

	applyInitial()

	-- ===== Interactions (drag) =====
	local hovering = false
	local dragging = false
	local dragConnMove, dragConnEnd

	local function setFromX(mouseX, silent)
		local tx, _, tw, _ = getAbsRect(self._track)
		local localX = clamp(mouseX - tx, 0, tw)
		local r = tw == 0 and 0 or (localX / tw)
		local nv = self._min + r * (self._max - self._min)
		nv = quantize(nv, self._step)
		nv = clamp(nv, self._min, self._max)
		if nv ~= self._value then
			self._value = nv
			updateVisualByValue()
			if not silent then
				local ok, err = pcall(self._callback, self._value)
				if not ok then warn("[Slider] Callback error:", err) end
			end
		else
			updateVisualByValue()
		end
	end

	local function beginDrag(input)
		if self._disabled or self._locked then return end
		dragging = true
		Theme.paintSelected(self._track, self._trackStroke) -- emphasize saat drag
		setFromX(input.Position.X, false)

		dragConnMove = UserInputService.InputChanged:Connect(function(changed)
			if changed.UserInputType == Enum.UserInputType.MouseMovement
			or changed.UserInputType == Enum.UserInputType.Touch then
				setFromX(changed.Position.X, false)
			end
		end)

		dragConnEnd = UserInputService.InputEnded:Connect(function(ended)
			if ended.UserInputType == Enum.UserInputType.MouseButton1
			or ended.UserInputType == Enum.UserInputType.Touch then
				dragging = false
				if hovering then paintHover() else paintNormal() end
				if dragConnMove then dragConnMove:Disconnect(); dragConnMove = nil end
				if dragConnEnd then dragConnEnd:Disconnect(); dragConnEnd = nil end
			end
		end)
	end

	self._track.InputBegan:Connect(function(input)
		if self._disabled or self._locked then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
			beginDrag(input)
		end
	end)

	self._knob.InputBegan:Connect(function(input)
		if self._disabled or self._locked then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then
			beginDrag(input)
		end
	end)

	self._track.MouseEnter:Connect(function()
		if self._disabled or self._locked then return end
		hovering = true
		if not dragging then paintHover() end
	end)

	self._track.MouseLeave:Connect(function()
		if self._disabled or self._locked then return end
		hovering = false
		if not dragging then paintNormal() end
	end)

	-- ===== Public API =====
	function self:Set(value, silent)
		local v = clamp(quantize(tonumber(value) or self._min, self._step), self._min, self._max)
		self._value = v
		updateVisualByValue()
		if not silent then
			local ok, err = pcall(self._callback, self._value)
			if not ok then warn("[Slider] Set() callback error:", err) end
		end
	end

	function self:Get()
		return self._value
	end

	function self:SetMinMax(minv, maxv)
		minv = tonumber(minv) or self._min
		maxv = tonumber(maxv) or self._max
		if maxv < minv then maxv, minv = minv, maxv end
		self._min, self._max = minv, maxv
		self:Set(self._value, true) -- clamp ulang tanpa callback
		updateVisualByValue()
	end

	function self:SetStep(step)
		step = tonumber(step) or self._step
		if step <= 0 then step = 1 end
		self._step = step
		self:Set(self._value, true)
	end

	function self:SetFormat(fn)
		if typeof(fn) == "function" then
			self._format = fn
			self._valLabel.Text = self._format(self._value)
		end
	end

	function self:SetTitle(newTitle)
		self._titleTxt = newTitle or self._titleTxt
		self._title.Text = self._titleTxt
		self._card.Name = self._titleTxt
	end

	function self:SetDesc(newDesc)
		self._descTxt = newDesc
		self._desc.Text = newDesc or ""
		self._desc.Visible = (newDesc and newDesc ~= "")
		self._card.Size = UDim2.new(1, 0, 0, self._desc.Visible and 72 or 56)
		self._track.Position = UDim2.new(1, -12, 0, self._desc.Visible and 36 or 28)
		self._valLabel.Position = UDim2.new(1, -12, 0, self._desc.Visible and 18 or 8)
	end

	function self:Lock()
		self._locked = true
	end

	function self:Unlock()
		self._locked = false
	end

	function self:Disable()
		self._disabled = true
		paintDisabled()
	end

	function self:Enable()
		self._disabled = false
		paintNormal()
	end

	function self:Destroy()
		if dragConnMove then dragConnMove:Disconnect() end
		if dragConnEnd  then dragConnEnd:Disconnect() end
		self._card:Destroy()
	end

	return self
end

return Slider

--[[local Slider = require(path.to.Slider)

local container = someParentFrame
local sld = Slider.new(container, {
    Title = "FOV",
    Desc = "Sesuaikan field of view",
    Min = 60, Max = 120, Default = 80,
    Step = 1,
    Format = function(v) return string.format("%d°", v) end,
    Callback = function(v)
        print("FOV:", v)
    end
})

-- Programatis:
-- sld:Set(100)                 -- set nilai
-- print(sld:Get())             -- ambil nilai
-- sld:SetMinMax(40, 140)       -- ubah rentang
-- sld:SetStep(5)               -- ubah step
-- sld:SetFormat(function(v) return string.format("%.1f x", v) end)
-- sld:Disable(); sld:Enable()
-- sld:Lock(); sld:Unlock()]]