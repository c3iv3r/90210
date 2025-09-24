-- Toggle.lua
-- Private module: Toggle ala Library.txt
-- Integrasi penuh: Theme.lua (warna, gradient, animasi)
-- API:
--   Toggle.new(parent, { Title, Desc, Default, Locked, Disabled, Callback })
--   :SetTitle(text) :SetDesc(text)
--   :Set(state:boolean, silent:boolean?) :Get() -> boolean :Toggle()
--   :Lock() :Unlock() :Disable() :Enable()
--   :Destroy()

local Theme = require("Theme")

local Toggle = {}
Toggle.__index = Toggle

-- ===== Utilities =====
local function clamp01(x) return x and (x and (x > 1 and 1 or (x < 0 and 0 or x))) end

-- ===== Constructor =====
-- parent: Instance (container Frame)
-- opts: { Title, Desc, Default, Locked, Disabled, Callback }
function Toggle.new(parent, opts)
	opts = opts or {}
	local self = setmetatable({}, Toggle)

	self._locked   = opts.Locked or opts.Lock or false
	self._disabled = opts.Disabled or false
	self._titleTxt = opts.Title or "Toggle"
	self._descTxt  = opts.Desc
	self._state    = opts.Default and true or false
	self._callback = typeof(opts.Callback) == "function" and opts.Callback or function() end

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

	-- ===== Switch (track + knob) =====
	local track = Instance.new("TextButton")
	track.Name = "Switch"
	track.AutoButtonColor = false
	track.Text = ""
	track.BackgroundColor3 = Theme.colors.input
	track.BorderSizePixel = 0
	track.AnchorPoint = Vector2.new(1, 0.5)
	track.Position = UDim2.new(1, -12, 0, self._descTxt and 36 or 28)
	track.Size = UDim2.fromOffset(48, 28)
	track.Parent = card

	local trackCorner = Instance.new("UICorner", track)
	trackCorner.CornerRadius = UDim.new(1, 12)

	local trackStroke = Instance.new("UIStroke", track)
	trackStroke.Color = Theme.colors.stroke
	trackStroke.Thickness = 1

	local knob = Instance.new("Frame")
	knob.Name = "Knob"
	knob.Size = UDim2.fromOffset(22, 22)
	knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	knob.BorderSizePixel = 0
	knob.AnchorPoint = Vector2.new(0, 0.5)
	knob.Position = UDim2.new(0, 3, 0.5, 0)
	knob.Parent = track
	local knobCorner = Instance.new("UICorner", knob)
	knobCorner.CornerRadius = UDim.new(1, 0)
	local knobShadow = Instance.new("UIStroke", knob)
	knobShadow.Color = Color3.fromRGB(230, 235, 255)
	knobShadow.Thickness = 0.5

	-- ===== State refs =====
	self._card, self._stroke = card, cardStroke
	self._title, self._desc = title, desc
	self._track, self._trackStroke, self._knob = track, trackStroke, knob

	-- ===== Painters =====
	local function paintOFF()
		-- track OFF = normal box + no gradient
		Theme.paintNormal(track, trackStroke)
		Theme.tween(track, { BackgroundColor3 = Theme.colors.input }, Theme.tweening.fast)
		Theme.setText(nil, nil) -- noop
		-- knob ke kiri
		Theme.tween(knob, { Position = UDim2.new(0, 3, 0.5, 0), BackgroundColor3 = Color3.fromRGB(255,255,255) }, Theme.tweening.base)
	end

	local function paintHOVER()
		-- hanya efek halus di track jika OFF dan tidak disabled/locked
		if not self._state then
			Theme.paintHover(track, trackStroke)
		end
	end

	local function paintON()
		-- track ON = gradient biru OG
		Theme.paintSelected(track, trackStroke)
		-- knob ke kanan + sedikit tint
		Theme.tween(knob, { Position = UDim2.new(1, -25, 0.5, 0), BackgroundColor3 = Color3.fromRGB(247,250,255) }, Theme.tweening.base)
	end

	local function paintDISABLED()
		Theme.paintNormal(track, trackStroke)
		Theme.tween(track, { BackgroundColor3 = Theme.colors.card }, Theme.tweening.fast)
		Theme.tween(knob, { BackgroundColor3 = Color3.fromRGB(220, 224, 236) }, Theme.tweening.fast)
	end

	local function applyVisualByState()
		if self._disabled then
			paintDISABLED()
		else
			if self._state then paintON() else paintOFF() end
		end
	end

	-- awal
	applyVisualByState()

	-- ===== Interactions =====
	local hovering = false

	track.MouseEnter:Connect(function()
		if self._disabled or self._locked then return end
		hovering = true
		if not self._state then paintHOVER() end
	end)

	track.MouseLeave:Connect(function()
		if self._disabled or self._locked then return end
		hovering = false
		if self._state then paintON() else paintOFF() end
	end)

	track.MouseButton1Down:Connect(function()
		if self._disabled or self._locked then return end
		-- press glow halus (tanpa ubah state dulu)
		if not self._state then Theme.paintHover(track, trackStroke) end
	end)

	track.MouseButton1Up:Connect(function()
		if self._disabled or self._locked then return end
		if self._state then paintON() else
			if hovering then paintHOVER() else paintOFF() end
		end
	end)

	local clickDebounce = false
	track.MouseButton1Click:Connect(function()
		if self._disabled or self._locked then return end
		if clickDebounce then return end
		clickDebounce = true
		self._state = not self._state
		if self._state then paintON() else paintOFF() end
		-- flash kecil untuk feedback
		task.delay(Theme.tweening.fast, function()
			if not self._state and hovering then paintHOVER() end
		end)
		-- callback aman
		local ok, err = pcall(self._callback, self._state)
		if not ok then warn("[Toggle] Callback error:", err) end
		clickDebounce = false
	end)

	-- ===== Public API =====
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
	end

	-- Set state secara programatis
	-- silent=true untuk tidak memanggil Callback
	function self:Set(state, silent)
		self._state = state and true or false
		applyVisualByState()
		if not silent then
			local ok, err = pcall(self._callback, self._state)
			if not ok then warn("[Toggle] Set() callback error:", err) end
		end
	end

	function self:Get()
		return self._state
	end

	function self:Toggle()
		self:Set(not self._state)
	end

	function self:Lock()
		self._locked = true
		self._track.Active = false
	end

	function self:Unlock()
		self._locked = false
		if not self._disabled then self._track.Active = true end
	end

	function self:Disable()
		self._disabled = true
		self._track.Active = false
		paintDISABLED()
	end

	function self:Enable()
		self._disabled = false
		if not self._locked then self._track.Active = true end
		applyVisualByState()
	end

	function self:Destroy()
		self._card:Destroy()
	end

	return self
end

return Toggle

--[[local Toggle = require(path.to.Toggle)

local container = someParentFrame
local tgl = Toggle.new(container, {
    Title = "Auto Fish",
    Desc = "Otomatis lempar pancing saat ready",
    Default = false,
    Callback = function(state)
        print("Auto Fish:", state and "ON" or "OFF")
    end
})

-- Programatis:
-- tgl:Set(true)            -- nyalain
-- print(tgl:Get())         -- true/false
-- tgl:Toggle()             -- switch
-- tgl:Disable(); tgl:Enable()
-- tgl:Lock(); tgl:Unlock()]]