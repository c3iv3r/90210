-- OpenButton.lua
-- Private module: OpenButton ala Library.txt (versi icon)
-- Integrasi penuh: Theme.lua (warna, gradient, animasi)
-- Bedanya: berbentuk icon bulat (kecil) bukan memanjang.
--
-- API:
--   local OpenButton = require(path.to.OpenButton)
--   local ob = OpenButton.new({
--       Icon = "≡",                    -- teks/icon (default "☰")
--       Position = UDim2.new(0, 16, 0, 16), -- posisi layar (default kiri atas)
--       Size = UDim2.fromOffset(36, 36),    -- ukuran icon
--       Corner = 18,                  -- radius (default 18 untuk bulat)
--       Tooltip = "Open Menu",        -- optional tooltip (hover)
--       Callback = function() ... end -- dipanggil saat klik
--   })
--   ob:SetIcon("⚙")   ob:SetTooltip("Settings")
--   ob:Lock() ob:Unlock() ob:Disable() ob:Enable()
--   ob:Destroy()

local CoreGui = game:GetService("CoreGui")
local Theme   = require("Theme")

local OpenButton = {}
OpenButton.__index = OpenButton

-- ===== Tooltip helper (simple) =====
local function makeTooltip(parent, text)
	if not text or text == "" then return nil end
	local tip = Instance.new("TextLabel")
	tip.Name = "Tooltip"
	tip.BackgroundColor3 = Theme.colors.card
	tip.TextColor3 = Theme.colors.text.normal
	tip.Text = text
	tip.TextSize = 12
	tip.Font = Enum.Font.Gotham
	tip.Visible = false
	tip.AutomaticSize = Enum.AutomaticSize.XY
	tip.BorderSizePixel = 0
	tip.ZIndex = 50
	tip.Parent = parent

	local pad = Instance.new("UIPadding", tip)
	pad.PaddingLeft = UDim.new(0, 6)
	pad.PaddingRight = UDim.new(0, 6)
	pad.PaddingTop = UDim.new(0, 2)
	pad.PaddingBottom = UDim.new(0, 2)

	local corner = Instance.new("UICorner", tip)
	corner.CornerRadius = UDim.new(0, 6)

	local stroke = Instance.new("UIStroke", tip)
	stroke.Color = Theme.colors.stroke
	stroke.Thickness = 1

	return tip
end

-- ===== Constructor =====
function OpenButton.new(opts)
	opts = opts or {}
	local self = setmetatable({}, OpenButton)

	self._iconTxt = opts.Icon or "☰"
	self._pos     = opts.Position or UDim2.new(0, 16, 0, 16)
	self._size    = opts.Size or UDim2.fromOffset(36, 36)
	self._corner  = tonumber(opts.Corner) or 18
	self._tooltipTxt = opts.Tooltip or ""
	self._callback   = (typeof(opts.Callback) == "function") and opts.Callback or function() end
	self._locked   = opts.Locked or false
	self._disabled = opts.Disabled or false

	-- Root button
	local btn = Instance.new("TextButton")
	btn.Name = "OpenButton"
	btn.AutoButtonColor = false
	btn.Text = self._iconTxt
	btn.TextSize = 16
	btn.Font = Enum.Font.GothamBold
	btn.TextColor3 = Theme.colors.text.normal
	btn.BackgroundColor3 = Theme.colors.input
	btn.Size = self._size
	btn.Position = self._pos
	btn.AnchorPoint = Vector2.new(0, 0)
	btn.BorderSizePixel = 0
	btn.Active = true
	btn.Parent = (gethui and gethui()) or CoreGui

	local corner = Instance.new("UICorner", btn)
	corner.CornerRadius = UDim.new(0, self._corner)

	local stroke = Instance.new("UIStroke", btn)
	stroke.Color = Theme.colors.stroke
	stroke.Thickness = 1
	Theme.applyInputBox(btn, stroke)

	-- Tooltip
	local tooltip = makeTooltip(btn, self._tooltipTxt)

	-- State refs
	self._btn, self._stroke, self._tooltip = btn, stroke, tooltip
	self._hovering = false

	-- Painters
	local function paintDisabled()
		Theme.paintNormal(btn, stroke)
		btn.TextColor3 = Theme.colors.text.dim
	end
	local function paintNormal()
		Theme.paintNormal(btn, stroke)
		btn.BackgroundColor3 = Theme.colors.input
		btn.TextColor3 = Theme.colors.text.normal
	end
	local function paintHover()
		Theme.paintHover(btn, stroke)
	end
	local function paintActive()
		Theme.paintSelected(btn, stroke)
		btn.TextColor3 = Theme.colors.text.onAcc
	end

	-- initial
	if self._disabled then paintDisabled() else paintNormal() end

	-- Interactions
	btn.MouseEnter:Connect(function()
		if self._disabled or self._locked then return end
		self._hovering = true
		if self._tooltip then
			self._tooltip.Visible = true
			self._tooltip.Position = UDim2.new(0.5, 0, 0, -28)
			self._tooltip.AnchorPoint = Vector2.new(0.5,1)
		end
		if not btn:IsDescendantOf(nil) then
			if not btn:IsFocused() then paintHover() end
		end
	end)

	btn.MouseLeave:Connect(function()
		if self._disabled or self._locked then return end
		self._hovering = false
		if self._tooltip then self._tooltip.Visible = false end
		if not btn:IsFocused() then paintNormal() end
	end)

	btn.MouseButton1Down:Connect(function()
		if self._disabled or self._locked then return end
		paintActive()
	end)
	btn.MouseButton1Up:Connect(function()
		if self._disabled or self._locked then return end
		if self._hovering then paintHover() else paintNormal() end
	end)

	btn.MouseButton1Click:Connect(function()
		if self._disabled or self._locked then return end
		local ok, err = pcall(self._callback)
		if not ok then warn("[OpenButton] Callback error:", err) end
	end)

	-- API
	function self:SetIcon(txt)
		self._iconTxt = tostring(txt or "")
		self._btn.Text = self._iconTxt
	end

	function self:SetTooltip(txt)
		self._tooltipTxt = tostring(txt or "")
		if self._tooltip then
			self._tooltip.Text = self._tooltipTxt
			self._tooltip.Visible = false
		end
	end

	function self:Lock()
		self._locked = true
		self._btn.Active = false
	end

	function self:Unlock()
		self._locked = false
		if not self._disabled then self._btn.Active = true end
	end

	function self:Disable()
		self._disabled = true
		self._btn.Active = false
		paintDisabled()
	end

	function self:Enable()
		self._disabled = false
		if not self._locked then self._btn.Active = true end
		paintNormal()
	end

	function self:Destroy()
		self._btn:Destroy()
	end

	return self
end

return OpenButton

--[[local OpenButton = require(path.to.OpenButton)

-- Buat open button di pojok kiri atas
local ob = OpenButton.new({
    Icon = "☰", -- bisa ganti ke ⚙ ≡ atau lainnya
    Position = UDim2.new(0, 16, 0, 16),
    Tooltip = "Open Menu",
    Callback = function()
        print("Open clicked!")
    end
})

-- API:
-- ob:SetIcon("⚙")
-- ob:SetTooltip("Settings")
-- ob:Lock(); ob:Unlock()
-- ob:Disable(); ob:Enable()
-- ob:Destroy()]]