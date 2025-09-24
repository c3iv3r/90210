-- Divider.lua
-- Private module: Divider / Separator ala Library.txt
-- Integrasi penuh: Theme.lua
-- Fitur:
--   - Garis tipis dengan warna stroke theme
--   - Opsional teks di tengah; label menimpa garis (background mengikuti card)
--   - Auto tinggi: pendek saat tanpa teks, sedikit lebih tinggi saat ada teks
-- API:
--   local Divider = require(path.to.Divider)
--   local d1 = Divider.new(parent)                -- tanpa teks
--   local d2 = Divider.new(parent, "Pemisah")     -- teks di tengah
--   -- atau pakai opsi:
--   local d3 = Divider.new(parent, { Text="Advanced", Thickness=1, Padding=8, Size=13, Uppercase=false })
--   -- Methods:
--   d2:SetText("Baru")  d2:GetText() -> string
--   d2:SetThickness(2)  d2:SetPadding(10)  d2:SetSize(14)  d2:SetUppercase(true/false)
--   d2:GetFrame() -> Frame (root)  d2:Destroy()

local Theme = require("Theme")

local Divider = {}
Divider.__index = Divider

-- ===== Utilities =====
local function toOptions(textOrOpts)
	if type(textOrOpts) == "table" then
		return textOrOpts
	else
		return { Text = textOrOpts }
	end
end

local function computeHeight(hasText)
	return hasText and 28 or 12
end

-- ===== Constructor =====
-- parent: Instance (container Frame)
-- textOrOpts: string? | table?
function Divider.new(parent, textOrOpts)
	local opts = toOptions(textOrOpts)
	local self = setmetatable({}, Divider)

	self._text      = (opts.Text ~= nil) and tostring(opts.Text) or ""
	self._thickness = tonumber(opts.Thickness) or 1
	self._padding   = tonumber(opts.Padding) or 8    -- horizontal padding label terhadap garis
	self._size      = tonumber(opts.Size) or 13      -- text size
	self._upper     = not not opts.Uppercase

	-- Root transparent holder
	local root = Instance.new("Frame")
	root.Name = "Divider"
	root.BackgroundTransparency = 1
	root.BorderSizePixel = 0
	root.Size = UDim2.new(1, 0, 0, computeHeight(self._text ~= ""))
	root.Parent = parent

	-- Garis utama
	local line = Instance.new("Frame")
	line.Name = "Line"
	line.BackgroundColor3 = Theme.colors.stroke
	line.BorderSizePixel = 0
	line.AnchorPoint = Vector2.new(0.5, 0.5)
	line.Position = UDim2.new(0.5, 0, 0.5, 0)
	line.Size = UDim2.new(1, 0, 0, self._thickness)
	line.Parent = root

	-- Label wrap (background mengikuti card untuk “memotong” garis di belakang)
	local labelWrap = Instance.new("Frame")
	labelWrap.Name = "LabelWrap"
	labelWrap.BackgroundColor3 = Theme.colors.card
	labelWrap.BorderSizePixel = 0
	labelWrap.AnchorPoint = Vector2.new(0.5, 0.5)
	labelWrap.Position = UDim2.new(0.5, 0, 0.5, 0)
	labelWrap.Visible = (self._text ~= "")
	labelWrap.Parent = root

	local labelCorner = Instance.new("UICorner", labelWrap)
	labelCorner.CornerRadius = UDim.new(0, 4)

	local labelStroke = Instance.new("UIStroke", labelWrap)
	labelStroke.Color = Theme.colors.card -- menyatu; tidak menambah garis baru
	labelStroke.Thickness = 0.5

	local padding = Instance.new("UIPadding", labelWrap)
	padding.PaddingLeft = UDim.new(0, self._padding)
	padding.PaddingRight = UDim.new(0, self._padding)
	padding.PaddingTop = UDim.new(0, 2)
	padding.PaddingBottom = UDim.new(0, 2)

	local label = Instance.new("TextLabel")
	label.Name = "Text"
	label.BackgroundTransparency = 1
	label.Text = (self._upper and string.upper(self._text) or self._text)
	label.TextColor3 = Theme.colors.text.dim
	label.Font = Enum.Font.Gotham
	label.TextSize = self._size
	label.TextXAlignment = Enum.TextXAlignment.Center
	label.TextYAlignment = Enum.TextYAlignment.Center
	label.AutomaticSize = Enum.AutomaticSize.XY
	label.Parent = labelWrap

	-- Ukuran labelWrap mengikuti text
	local function resizeLabelWrap()
		-- gunakan TextBounds untuk set Size, tapi kita biarkan AutomaticSize dari label, wrap mengikuti dengan padding
		local bounds = label.TextBounds
		labelWrap.Size = UDim2.fromOffset(bounds.X + (self._padding * 2), bounds.Y + 4)
	end

	-- Initial layout
	task.defer(resizeLabelWrap)

	-- Simpan refs
	self._root = root
	self._line = line
	self._labelWrap = labelWrap
	self._label = label

	-- ===== Painters / Updaters =====
	local function repaintHeight()
		self._root.Size = UDim2.new(1, 0, 0, computeHeight(self._text ~= ""))
	end

	-- ===== Public API =====
	function self:SetText(t)
		self._text = (t ~= nil) and tostring(t) or ""
		self._label.Text = (self._upper and string.upper(self._text) or self._text)
		self._labelWrap.Visible = (self._text ~= "")
		resizeLabelWrap()
		repaintHeight()
	end

	function self:GetText()
		return self._text
	end

	function self:SetThickness(px)
		local v = tonumber(px)
		if v and v > 0 then
			self._thickness = v
			self._line.Size = UDim2.new(1, 0, 0, self._thickness)
		end
	end

	function self:SetPadding(px)
		local v = tonumber(px)
		if v and v >= 0 then
			self._padding = v
			local pad = self._labelWrap:FindFirstChildOfClass("UIPadding")
			if pad then
				pad.PaddingLeft = UDim.new(0, self._padding)
				pad.PaddingRight = UDim.new(0, self._padding)
			end
			resizeLabelWrap()
		end
	end

	function self:SetSize(sz)
		local v = tonumber(sz)
		if v and v > 0 then
			self._size = v
			self._label.TextSize = v
			resizeLabelWrap()
		end
	end

	function self:SetUppercase(b)
		self._upper = not not b
		self._label.Text = (self._upper and string.upper(self._text) or self._text)
		resizeLabelWrap()
	end

	function self:GetFrame()
		return self._root
	end

	function self:Destroy()
		self._root:Destroy()
	end

	return self
end

return Divider

--[[local Divider = require(path.to.Divider)

local container = someParentFrame

-- Tanpa teks
local d1 = Divider.new(container)  -- sama seperti Divider()

-- Dengan teks di tengah
local d2 = Divider.new(container, "Pemisah")

-- Kustom:
local d3 = Divider.new(container, {
    Text = "ADVANCED",
    Thickness = 1,
    Padding = 10,
    Size = 12,
    Uppercase = true,
})

-- Ubah setelah dibuat:
-- d2:SetText("Section A")
-- d2:SetThickness(2)
-- d2:SetPadding(12)
-- d2:SetSize(14)
-- d2:SetUppercase(false)]]