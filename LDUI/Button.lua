-- Button.lua
-- Private module: Button ala Library.txt
-- Integrasi penuh: Theme.lua (warna, gradient, animasi)
-- API: Button.new(parent, { Title, Desc, Locked, Disabled, Callback })
--      :SetTitle(text) :SetDesc(text) :Lock() :Unlock() :Enable() :Disable()
--      :Click() :Destroy()

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local Theme = require("Theme")

local Button = {}
Button.__index = Button

-- ===== Utilities =====
local function makeIconLabel(parent)
	-- Placeholder icon (opsional, biar 1:1 feel topbar/click icon style)
	local lbl = Instance.new("TextLabel")
	lbl.Name = "ClickIcon"
	lbl.BackgroundTransparency = 1
	lbl.AnchorPoint = Vector2.new(1, 0.5)
	lbl.Position = UDim2.new(1, -8, 0.5, 0)
	lbl.Size = UDim2.fromOffset(12, 16)
	lbl.Text = "›"
	lbl.TextColor3 = Theme.colors.text.muted
	lbl.Font = Enum.Font.Gotham
	lbl.TextSize = 14
	lbl.Parent = parent
	return lbl
end

-- ===== Constructor =====
-- parent: Instance (container)
-- opts: { Title, Desc, Locked, Disabled, Callback }
function Button.new(parent, opts)
	opts = opts or {}
	local self = setmetatable({}, Button)

	self._locked   = opts.Locked or opts.Lock or false
	self._disabled = opts.Disabled or false
	self._titleTxt = opts.Title or "Button"
	self._descTxt  = opts.Desc
	self._callback = typeof(opts.Callback) == "function" and opts.Callback or function() end

	-- ===== Card (seperti di Library.txt, 56px tinggi; 72px jika ada desc) =====
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

	-- ===== Actual Button Area =====
	local btn = Instance.new("TextButton")
	btn.Name = "Action"
	btn.AutoButtonColor = false
	btn.Text = ""
	btn.BackgroundColor3 = Theme.colors.input
	btn.BorderSizePixel = 0
	btn.AnchorPoint = Vector2.new(1, 0.5)
	btn.Position = UDim2.new(1, -12, 0, self._descTxt and 36 or 28)
	btn.Size = UDim2.fromOffset(220, 28)
	btn.Parent = card

	local btnCorner = Instance.new("UICorner", btn)
	btnCorner.CornerRadius = UDim.new(0, Theme.radius.input)

	local btnStroke = Instance.new("UIStroke", btn)
	btnStroke.Color = Theme.colors.stroke
	btnStroke.Thickness = 1
	Theme.applyInputBox(btn, btnStroke)

	local btnLabel = Instance.new("TextLabel")
	btnLabel.Name = "Label"
	btnLabel.BackgroundTransparency = 1
	btnLabel.Text = self._titleTxt
	btnLabel.Font = Enum.Font.Gotham
	btnLabel.TextSize = 13
	btnLabel.TextXAlignment = Enum.TextXAlignment.Left
	btnLabel.TextColor3 = Theme.colors.text.normal
	btnLabel.Position = UDim2.new(0, 10, 0, 0)
	btnLabel.Size = UDim2.new(1, -20, 1, 0)
	btnLabel.Parent = btn

	-- Chevron/icon di kanan title (card), mirip style library
	local chevron = makeIconLabel(title)

	-- ===== State Refs =====
	self._card, self._stroke, self._btn, self._btnStroke, self._btnLabel, self._title, self._desc, self._chev =
		card, cardStroke, btn, btnStroke, btnLabel, title, desc, chevron

	-- ===== State Painting =====
	local function paintDisabled()
		Theme.paintNormal(btn, btnStroke)
		Theme.setText(btnLabel, Theme.colors.text.dim)
		btn.AutoButtonColor = false
		btn.Active = false
	end

	local function paintLocked()
		Theme.paintNormal(btn, btnStroke)
		Theme.setText(btnLabel, Theme.colors.text.dim)
		btn.AutoButtonColor = false
		btn.Active = false
	end

	local function paintNormal()
		Theme.paintNormal(btn, btnStroke)
		Theme.setText(btnLabel, Theme.colors.text.normal)
		btn.Active = true
	end

	local function applyInitial()
		if self._disabled then
			paintDisabled()
		elseif self._locked then
			paintLocked()
		else
			paintNormal()
		end
	end

	applyInitial()

	-- ===== Interactions =====
	local hovering = false
	btn.MouseEnter:Connect(function()
		if self._disabled or self._locked then return end
		hovering = true
		Theme.paintHover(btn, btnStroke)
	end)

	btn.MouseLeave:Connect(function()
		if self._disabled or self._locked then return end
		hovering = false
		Theme.paintNormal(btn, btnStroke)
	end)

	local clickDebounce = false
	btn.MouseButton1Down:Connect(function()
		if self._disabled or self._locked then return end
		Theme.paintSelected(btn, btnStroke) -- pressed gradient biru OG
	end)

	btn.MouseButton1Up:Connect(function()
		if self._disabled or self._locked then return end
		-- Kembali ke hover/normal sesuai posisi kursor
		if hovering then
			Theme.paintHover(btn, btnStroke)
		else
			Theme.paintNormal(btn, btnStroke)
		end
	end)

	btn.MouseButton1Click:Connect(function()
		if self._disabled or self._locked then return end
		if clickDebounce then return end
		clickDebounce = true
		-- Flash selected singkat biar “click feel” kerasa
		Theme.paintSelected(btn, btnStroke)
		task.delay(Theme.tweening.fast, function()
			if hovering then Theme.paintHover(btn, btnStroke) else Theme.paintNormal(btn, btnStroke) end
		end)
		-- Callback aman
		local ok, err = pcall(self._callback)
		if not ok then warn("[Button] Callback error:", err) end
		clickDebounce = false
	end)

	-- ===== Public API =====
	function self:SetTitle(newTitle)
		self._titleTxt = newTitle or self._titleTxt
		self._title.Text = self._titleTxt
		self._btnLabel.Text = self._titleTxt
	end

	function self:SetDesc(newDesc)
		self._descTxt = newDesc
		self._desc.Text = newDesc or ""
		self._desc.Visible = (newDesc and newDesc ~= "")
		self._card.Size = UDim2.new(1, 0, 0, self._desc.Visible and 72 or 56)
		-- Reposition tombol jika perlu
		self._btn.Position = UDim2.new(1, -12, 0, self._desc.Visible and 36 or 28)
	end

	function self:Lock()
		self._locked = true
		paintLocked()
	end

	function self:Unlock()
		self._locked = false
		if not self._disabled then paintNormal() end
	end

	function self:Disable()
		self._disabled = true
		paintDisabled()
	end

	function self:Enable()
		self._disabled = false
		if not self._locked then paintNormal() end
	end

	-- Trigger programatis (respect disabled/locked)
	function self:Click()
		if self._disabled or self._locked then return end
		local ok, err = pcall(self._callback)
		if not ok then warn("[Button] Programmatic Click error:", err) end
	end

	function self:Destroy()
		self._card:Destroy()
	end

	return self
end

return Button

--[[local Button = require(path.to.Button)

local container = someParentFrame
local btn = Button.new(container, {
    Title = "Run",
    Desc = "Jalankan fitur sekarang",
    Callback = function()
        print("Clicked!")
    end
})

-- Update teks
-- btn:SetTitle("Execute")
-- btn:SetDesc("Mulai proses")

-- Lock / Unlock
-- btn:Lock()
-- btn:Unlock()

-- Enable / Disable
-- btn:Disable()
-- btn:Enable()

-- Trigger programatis
-- btn:Click()]]