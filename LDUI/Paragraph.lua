-- Paragraph.lua
-- Private module: Paragraph ala Library.txt
-- Integrasi penuh: Theme.lua (warna, stroke, anim)
-- API:
--   local p = Paragraph.new(parent, {
--       Text = "Lorem ipsum...",
--       Rich = false,            -- gunakan RichText
--       Align = "Left",          -- "Left" | "Center" | "Right"
--       Wrap  = true,            -- TextWrapped
--       Size  = 13,              -- TextSize (number)
--       Selectable = false,      -- TextSelectable
--   })
--   p:SetText(str)        p:GetText() -> string
--   p:SetRich(bool)       p:SetAlign("Left"/"Center"/"Right")
--   p:SetWrap(bool)       p:SetSize(number)
--   p:SetColor(Color3?)   -- override warna; nil = kembali ke theme
--   p:Destroy()

local RunService = game:GetService("RunService")
local Theme = require("Theme")

local Paragraph = {}
Paragraph.__index = Paragraph

-- Map string -> Enum.TextXAlignment
local ALIGN_MAP = {
	Left = Enum.TextXAlignment.Left,
	Center = Enum.TextXAlignment.Center,
	Right = Enum.TextXAlignment.Right,
}

-- ===== Constructor =====
-- parent: Instance container (Frame)
-- opts: table (lihat API di atas)
function Paragraph.new(parent, opts)
	opts = opts or {}
	local self = setmetatable({}, Paragraph)

	self._text       = (opts.Text ~= nil) and tostring(opts.Text) or "Paragraph"
	self._rich       = not not opts.Rich
	self._wrap       = (opts.Wrap == nil) and true or not not opts.Wrap
	self._alignStr   = (type(opts.Align) == "string" and ALIGN_MAP[opts.Align]) and opts.Align or "Left"
	self._align      = ALIGN_MAP[self._alignStr] or Enum.TextXAlignment.Left
	self._size       = tonumber(opts.Size) or 13
	self._selectable = not not opts.Selectable
	self._color      = nil -- override; nil => theme

	-- ===== Card (container) =====
	local card = Instance.new("Frame")
	card.Name = "Paragraph"
	card.BackgroundColor3 = Theme.colors.card
	card.BorderSizePixel = 0
	card.AutomaticSize = Enum.AutomaticSize.Y
	card.Size = UDim2.new(1, 0, 0, 44) -- minimum
	card.Parent = parent

	local cardCorner = Instance.new("UICorner", card)
	cardCorner.CornerRadius = UDim.new(0, Theme.radius.card)

	local cardStroke = Instance.new("UIStroke", card)
	cardStroke.Color = Theme.colors.stroke
	cardStroke.Thickness = 1
	Theme.applyCard(card, cardStroke)

	local padding = Instance.new("UIPadding", card)
	padding.PaddingLeft   = UDim.new(0, 12)
	padding.PaddingRight  = UDim.new(0, 12)
	padding.PaddingTop    = UDim.new(0, 10)
	padding.PaddingBottom = UDim.new(0, 10)

	-- ===== Text node =====
	local text = Instance.new("TextLabel")
	text.Name = "Text"
	text.BackgroundTransparency = 1
	text.Text = self._text
	text.RichText = self._rich
	text.TextWrapped = self._wrap
	text.TextXAlignment = self._align
	text.TextYAlignment = Enum.TextYAlignment.Top
	text.TextSize = self._size
	text.Font = Enum.Font.Gotham
	text.TextColor3 = Theme.colors.text.normal
	text.AutoLocalize = false
	text.AutomaticSize = Enum.AutomaticSize.Y
	text.Size = UDim2.new(1, 0, 0, 0)
	text.Parent = card

	-- Allow selection (optional)
	if text.SetTextSelectable then
		text:SetTextSelectable(self._selectable)
	else
		-- Fallback engine (abaikan jika tidak ada API)
		text.TextEditable = false
	end

	-- ===== State refs =====
	self._card = card
	self._stroke = cardStroke
	self._textLbl = text

	-- ===== Helpers =====
	local function applyColor()
		if self._color then
			self._textLbl.TextColor3 = self._color
		else
			self._textLbl.TextColor3 = Theme.colors.text.normal
		end
	end

	local function repaintSmooth()
		-- Animasi halus sedikit saat update panjang teks
		Theme.tween(self._textLbl, { TextTransparency = 0 }, Theme.tweening.fast)
		applyColor()
	end

	-- initial paint
	applyColor()
	repaintSmooth()

	-- ===== Public API =====
	function self:SetText(str)
		self._text = tostring(str or "")
		self._textLbl.Text = self._text
		repaintSmooth()
	end

	function self:GetText()
		return self._text
	end

	function self:SetRich(boolVal)
		self._rich = not not boolVal
		self._textLbl.RichText = self._rich
	end

	function self:SetAlign(where)
		local a = ALIGN_MAP[where or ""]
		if a then
			self._alignStr = where
			self._align = a
			self._textLbl.TextXAlignment = a
		end
	end

	function self:SetWrap(boolVal)
		self._wrap = not not boolVal
		self._textLbl.TextWrapped = self._wrap
	end

	function self:SetSize(n)
		local sz = tonumber(n)
		if sz and sz > 0 then
			self._size = sz
			self._textLbl.TextSize = sz
		end
	end

	function self:SetColor(c3)
		-- c3: Color3 atau nil (kembalikan ke theme)
		if typeof(c3) == "Color3" then
			self._color = c3
		else
			self._color = nil
		end
		applyColor()
	end

	function self:Destroy()
		self._card:Destroy()
	end

	return self
end

return Paragraph

--[[local Paragraph = require(path.to.Paragraph)

local container = someParentFrame

local p = Paragraph.new(container, {
    Text = "Ini adalah paragraf penjelasan fitur.\n<b>RichText</b> bisa dinyalakan.",
    Rich = true,
    Align = "Left",
    Wrap = true,
    Size = 13,
})

-- Update properti:
-- p:SetText("Teks baru <i>dengan rich</i> markup")
-- p:SetRich(true)
-- p:SetAlign("Center")   -- "Left" | "Center" | "Right"
-- p:SetWrap(false)
-- p:SetSize(14)
-- p:SetColor(Color3.fromRGB(180, 200, 255))  -- custom warna; p:SetColor(nil) untuk balik ke theme]]