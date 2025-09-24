-- Input.lua
-- Private module: Input/TextBox ala Library.txt
-- Integrasi penuh: Theme.lua (warna, gradient, animasi)
-- API:
--   local inp = Input.new(parent, {
--       Title       = "Username",
--       Desc        = "Masukkan nama",
--       Placeholder = "Type here…",
--       Default     = "",
--       Numeric     = false,     -- jika true: hanya angka (0-9 dan titik minus awal)
--       MaxLength   = nil,       -- number atau nil (unlimited)
--       Locked      = false,
--       Disabled    = false,
--       ClearButton = true,      -- tombol '×' di kanan
--       OnChanged   = function(text) end,
--       OnSubmit    = function(text) end, -- saat Enter
--   })
--   Methods:
--     :SetTitle(text) :SetDesc(text)
--     :SetText(text, silent?) :GetText() -> string
--     :SetPlaceholder(text) :Focus() :Blur()
--     :Lock() :Unlock() :Disable() :Enable()
--     :SetMaxLength(n) :SetNumeric(bool)
--     :Destroy()

local UserInputService = game:GetService("UserInputService")

local Theme = require("Theme")

local Input = {}
Input.__index = Input

-- ===== Utilities =====
local function sanitizeNumeric(str)
	-- izinkan: angka, satu titik, minus hanya di awal
	str = tostring(str or "")
	local neg = string.sub(str, 1, 1) == "-"
	-- buang minus selain awal
	str = (neg and "-" or "") .. string.gsub(neg and string.sub(str, 2) or str, "-", "")
	-- sisakan digit dan titik
	str = string.gsub(str, "[^%d%.%-]", "")
	-- kompres titik >1
	local before, after = string.match(str, "^%-?(%d*)%.?(.*)$")
	if before == nil then return neg and "-" or "" end
	local onlyDigitsAfter = string.gsub(after, "%.", "")
	local dot = (#after > 0 and string.find(after, "%.") and ".") or ""
	return (neg and "-" or "") .. (before or "") .. (dot ~= "" and "." or "") .. onlyDigitsAfter
end

local function clampLen(s, maxLen)
	if not maxLen or maxLen <= 0 then return s end
	if #s <= maxLen then return s end
	return string.sub(s, 1, maxLen)
end

-- ===== Constructor =====
-- parent: Instance (container)
-- opts: table (lihat API di atas)
function Input.new(parent, opts)
	opts = opts or {}
	local self = setmetatable({}, Input)

	self._titleTxt   = opts.Title or "Input"
	self._descTxt    = opts.Desc
	self._placeholder= opts.Placeholder or ""
	self._text       = tostring(opts.Default or "")
	self._numeric    = not not opts.Numeric
	self._maxLen     = tonumber(opts.MaxLength)
	self._locked     = opts.Locked or opts.Lock or false
	self._disabled   = opts.Disabled or false
	self._hasClear   = (opts.ClearButton == nil) and true or not not opts.ClearButton
	self._onChanged  = (typeof(opts.OnChanged) == "function") and opts.OnChanged or function() end
	self._onSubmit   = (typeof(opts.OnSubmit)  == "function") and opts.OnSubmit  or function() end

	-- ===== Card =====
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

	-- ===== Input box =====
	local box = Instance.new("TextBox")
	box.Name = "Input"
	box.ClearTextOnFocus = false
	box.Text = self._text
	box.PlaceholderText = self._placeholder
	box.TextTruncate = Enum.TextTruncate.None
	box.TextWrapped = false
	box.TextXAlignment = Enum.TextXAlignment.Left
	box.TextYAlignment = Enum.TextYAlignment.Center
	box.TextSize = 13
	box.Font = Enum.Font.Gotham
	box.TextColor3 = Theme.colors.text.normal
	box.PlaceholderColor3 = Theme.colors.text.dim
	box.BackgroundColor3 = Theme.colors.input
	box.BorderSizePixel = 0
	box.AnchorPoint = Vector2.new(1, 0.5)
	box.Position = UDim2.new(1, -12, 0, self._descTxt and 36 or 28)
	box.Size = UDim2.fromOffset(220, 28)
	box.Parent = card

	local boxCorner = Instance.new("UICorner", box)
	boxCorner.CornerRadius = UDim.new(0, Theme.radius.input)

	local boxStroke = Instance.new("UIStroke", box)
	boxStroke.Color = Theme.colors.stroke
	boxStroke.Thickness = 1
	Theme.applyInputBox(box, boxStroke)

	-- ===== Clear button (optional) =====
	local clearBtn
	if self._hasClear then
		clearBtn = Instance.new("TextButton")
		clearBtn.Name = "Clear"
		clearBtn.AutoButtonColor = false
		clearBtn.BackgroundTransparency = 1
		clearBtn.Text = "✕"
		clearBtn.Font = Enum.Font.Gotham
		clearBtn.TextSize = 14
		clearBtn.TextColor3 = Theme.colors.text.muted
		clearBtn.AnchorPoint = Vector2.new(1, 0.5)
		clearBtn.Position = UDim2.new(1, -8, 0.5, 0)
		clearBtn.Size = UDim2.fromOffset(16, 16)
		clearBtn.Parent = box
	end

	-- ===== State refs =====
	self._card, self._stroke = card, cardStroke
	self._title, self._desc  = title, desc
	self._box, self._boxStroke = box, boxStroke
	self._clearBtn = clearBtn

	-- ===== Painters =====
	local function paintDisabled()
		Theme.paintNormal(box, boxStroke)
		Theme.tween(box, { BackgroundColor3 = Theme.colors.card }, Theme.tweening.fast)
		box.TextColor3 = Theme.colors.text.dim
		box.PlaceholderColor3 = Theme.colors.text.dim
	end

	local function paintNormal()
		Theme.paintNormal(box, boxStroke)
		Theme.tween(box, { BackgroundColor3 = Theme.colors.input }, Theme.tweening.fast)
		box.TextColor3 = Theme.colors.text.normal
		box.PlaceholderColor3 = Theme.colors.text.dim
	end

	local function paintHover()
		Theme.paintHover(box, boxStroke)
	end

	local function paintFocus()
		Theme.paintSelected(box, boxStroke) -- gradient biru OG
	end

	-- initial state
	if self._disabled then paintDisabled() else paintNormal() end

	-- ===== Behavior =====
	local hovering = false
	local function canInteract()
		return not self._disabled and not self._locked
	end

	box.Focused:Connect(function()
		if not canInteract() then box:ReleaseFocus() return end
		paintFocus()
	end)

	box.FocusLost:Connect(function(enterPressed)
		if self._disabled then return end
		if enterPressed then
			local ok, err = pcall(self._onSubmit, box.Text)
			if not ok then warn("[Input] OnSubmit error:", err) end
		end
		if hovering then paintHover() else paintNormal() end
	end)

	box.MouseEnter:Connect(function()
		if not canInteract() then return end
		hovering = true
		if not box:IsFocused() then paintHover() end
	end)
	box.MouseLeave:Connect(function()
		if not canInteract() then return end
		hovering = false
		if not box:IsFocused() then paintNormal() end
	end)

	-- Text change filtering
	box:GetPropertyChangedSignal("Text"):Connect(function()
		local raw = box.Text or ""
		if self._numeric then
			raw = sanitizeNumeric(raw)
		end
		raw = clampLen(raw, self._maxLen)
		if raw ~= box.Text then
			-- menjaga caret di akhir saat koreksi
			local pos = #raw
			box.Text = raw
			if box.CursorPosition then
				box.CursorPosition = pos + 1
			end
		end
		self._text = raw
		local ok, err = pcall(self._onChanged, self._text)
		if not ok then warn("[Input] OnChanged error:", err) end
	end)

	-- Clear button
	if self._clearBtn then
		self._clearBtn.MouseButton1Click:Connect(function()
			if not canInteract() then return end
			box.Text = ""
		end)
	end

	-- ===== Public API =====
	function self:SetTitle(newTitle)
		self._titleTxt = newTitle or self._titleTxt
		self._title.Text = self._titleTxt
		self._card.Name  = self._titleTxt
	end

	function self:SetDesc(newDesc)
		self._descTxt = newDesc
		self._desc.Text = newDesc or ""
		self._desc.Visible = (newDesc and newDesc ~= "")
		self._card.Size = UDim2.new(1, 0, 0, self._desc.Visible and 72 or 56)
		self._box.Position = UDim2.new(1, -12, 0, self._desc.Visible and 36 or 28)
	end

	function self:SetText(text, silent)
		local s = tostring(text or "")
		if self._numeric then s = sanitizeNumeric(s) end
		s = clampLen(s, self._maxLen)
		self._text = s
		self._box.Text = s
		if not silent then
			local ok, err = pcall(self._onChanged, self._text)
			if not ok then warn("[Input] SetText OnChanged error:", err) end
		end
	end

	function self:GetText()
		return self._text
	end

	function self:SetPlaceholder(text)
		self._placeholder = tostring(text or "")
		self._box.PlaceholderText = self._placeholder
	end

	function self:Focus()
		if canInteract() then self._box:CaptureFocus() end
	end

	function self:Blur()
		self._box:ReleaseFocus()
	end

	function self:SetMaxLength(n)
		n = tonumber(n)
		self._maxLen = n
		if n and n > 0 then
			self:SetText(self._text, true)
		end
	end

	function self:SetNumeric(b)
		self._numeric = not not b
		self:SetText(self._text, true)
	end

	function self:Lock()
		self._locked = true
		self._box.Active = false
	end

	function self:Unlock()
		self._locked = false
		if not self._disabled then self._box.Active = true end
	end

	function self:Disable()
		self._disabled = true
		self._box.Active = false
		paintDisabled()
	end

	function self:Enable()
		self._disabled = false
		if not self._locked then self._box.Active = true end
		paintNormal()
	end

	function self:Destroy()
		self._card:Destroy()
	end

	return self
end

return Input

--[[local Input = require(path.to.Input)

local container = someParentFrame
local nameInput = Input.new(container, {
    Title = "Webhook URL",
    Desc = "Paste URL webhook Discord-mu",
    Placeholder = "https://discord.com/api/webhooks/...",
    Default = "",
    MaxLength = 500,
    ClearButton = true,
    OnChanged = function(text)
        print("Changed:", text)
    end,
    OnSubmit = function(text)
        print("Submit:", text)
    end,
})

-- Programatis:
-- nameInput:SetText("hello")
-- print(nameInput:GetText())
-- nameInput:SetPlaceholder("Type something…")
-- nameInput:SetNumeric(true)   -- jadi angka-only
-- nameInput:SetMaxLength(32)
-- nameInput:Disable(); nameInput:Enable()
-- nameInput:Lock();    nameInput:Unlock()
-- nameInput:Focus();   nameInput:Blur()]]