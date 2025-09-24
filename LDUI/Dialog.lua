-- Dialog.lua
-- Private module: Modal Dialog ala Library.txt
-- Integrasi penuh: Theme.lua (warna, gradient, animasi)
-- Fitur:
--  - Overlay gelap (ScreenGui singleton)
--  - Panel center (Title, Close ✕)
--  - Body (Frame) untuk konten kustom + opsi Message (Text)
--  - Footer Buttons (primary/secondary/danger)
--  - ESC & backdrop-close opsional
--  - Popup anim in/out (Theme.popupIn / Theme.popupOut)
--
-- API cepat:
--   local Dialog = require(path.to.Dialog)
--   Dialog:Alert({ Title="Info", Message="Hello", ButtonText="OK" }, onOk?)
--   Dialog:Confirm({ Title="Confirm", Message="Yakin?" }, onYes?, onNo?)
--   Dialog:Prompt({ Title="Input", Message="Masukkan nama:", Placeholder="..." }, onSubmit?, onCancel?)
--
-- API builder:
--   local d = Dialog.new({
--       Title="Settings", Size=UDim2.fromOffset(520, 420),
--       CloseOnBackdrop=true, CloseOnEscape=true
--   })
--   local body = d:GetBody() -- isi komponenmu ke sini
--   d:SetButtons({
--       { Text="Cancel", Callback=function() d:Close() end },
--       { Text="Save",   Primary=true, Callback=function() ...; d:Close() end }
--   })
--   d:Open()  -- tampilkan
--   d:Close() -- tutup
--   d:Destroy()

local UserInputService = game:GetService("UserInputService")
local CoreGui          = game:GetService("CoreGui")

local Theme = require("Theme")

local Dialog = {}
Dialog.__index = Dialog

-- ===== Singleton Overlay =====
local OVERLAY_TAG = "LogicDev_DialogOverlay"

local function buildOverlay()
	local sg = Instance.new("ScreenGui")
	sg.Name = OVERLAY_TAG
	sg.ResetOnSpawn = false
	sg.IgnoreGuiInset = true
	sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	sg.Enabled = false
	sg.Parent = (gethui and gethui()) or CoreGui

	local backdrop = Instance.new("TextButton")
	backdrop.Name = "Backdrop"
	backdrop.AutoButtonColor = false
	backdrop.Text = ""
	backdrop.BackgroundColor3 = Theme.colors.overlay
	backdrop.BackgroundTransparency = 0.35
	backdrop.BorderSizePixel = 0
	backdrop.Size = UDim2.fromScale(1,1)
	backdrop.Parent = sg

	-- container untuk multi dialog (stack)
	local host = Instance.new("Frame")
	host.Name = "Host"
	host.BackgroundTransparency = 1
	host.Size = UDim2.fromScale(1,1)
	host.Parent = sg

	return {
		Gui = sg,
		Backdrop = backdrop,
		Host = host,
		_stack = 0,
	}
end

local OVERLAY = _G.__ld_dialog_overlay
if not OVERLAY then
	OVERLAY = buildOverlay()
	_G.__ld_dialog_overlay = OVERLAY
end

local function overlayShow()
	OVERLAY._stack += 1
	OVERLAY.Gui.Enabled = true
end

local function overlayHide()
	OVERLAY._stack = math.max(0, OVERLAY._stack - 1)
	if OVERLAY._stack == 0 then
		OVERLAY.Gui.Enabled = false
	end
end

-- ===== Button builder =====
local function makeButton(text, primary, danger)
	local btn = Instance.new("TextButton")
	btn.Name = text
	btn.AutoButtonColor = false
	btn.Text = text
	btn.BackgroundColor3 = Theme.colors.input
	btn.BorderSizePixel = 0
	btn.Size = UDim2.fromOffset(120, 30)

	local corner = Instance.new("UICorner", btn)
	corner.CornerRadius = UDim.new(0, Theme.radius.input)

	local stroke = Instance.new("UIStroke", btn)
	stroke.Color = Theme.colors.stroke
	stroke.Thickness = 1

	btn.Font = Enum.Font.Gotham
	btn.TextSize = 13
	btn.TextColor3 = Theme.colors.text.normal

	local function paint(state)
		if primary then
			-- primary = gradient biru OG saat normal (ala Library.txt)
			if state == "pressed" or state == "active" then
				Theme.paintSelected(btn, stroke)
				btn.TextColor3 = Theme.colors.text.onAcc
			elseif state == "hover" then
				Theme.paintHover(btn, stroke)
				btn.TextColor3 = Theme.colors.text.onAcc
			else
				Theme.paintSelected(btn, stroke)
				btn.TextColor3 = Theme.colors.text.onAcc
			end
		elseif danger then
			-- danger = base merah lembut + hover/press
			if state == "pressed" or state == "active" then
				Theme.tween(btn, { BackgroundColor3 = Color3.fromRGB(180, 70, 70) }, Theme.tweening.fast)
				stroke.Color = Color3.fromRGB(210, 100, 100)
				btn.TextColor3 = Color3.fromRGB(255, 240, 240)
			elseif state == "hover" then
				Theme.tween(btn, { BackgroundColor3 = Color3.fromRGB(150, 60, 60) }, Theme.tweening.fast)
				stroke.Color = Color3.fromRGB(200, 95, 95)
				btn.TextColor3 = Color3.fromRGB(255, 230, 230)
			else
				Theme.tween(btn, { BackgroundColor3 = Color3.fromRGB(132, 55, 55) }, Theme.tweening.fast)
				stroke.Color = Color3.fromRGB(180, 80, 80)
				btn.TextColor3 = Color3.fromRGB(255, 220, 220)
			end
		else
			-- secondary
			if state == "pressed" or state == "active" then
				Theme.paintSelected(btn, stroke)
				btn.TextColor3 = Theme.colors.text.onAcc
			elseif state == "hover" then
				Theme.paintHover(btn, stroke)
				btn.TextColor3 = Theme.colors.text.normal
			else
				Theme.paintNormal(btn, stroke)
				btn.BackgroundColor3 = Theme.colors.input
				btn.TextColor3 = Theme.colors.text.normal
			end
		end
	end

	paint("normal")

	local hovering = false
	btn.MouseEnter:Connect(function() hovering = true; paint("hover") end)
	btn.MouseLeave:Connect(function() hovering = false; paint("normal") end)
	btn.MouseButton1Down:Connect(function() paint("pressed") end)
	btn.MouseButton1Up:Connect(function() if hovering then paint("hover") else paint("normal") end end)

	return btn, stroke, paint
end

-- ===== Constructor =====
-- opts: { Title, Size:UDim2?, CloseOnBackdrop?, CloseOnEscape?, Message?, Rich? }
function Dialog.new(opts)
	opts = opts or {}
	local self = setmetatable({}, Dialog)

	self._titleTxt = opts.Title or "Dialog"
	self._size = opts.Size or UDim2.fromOffset(520, 420)
	self._closeBackdrop = (opts.CloseOnBackdrop == nil) and true or not not opts.CloseOnBackdrop
	self._closeEscape   = (opts.CloseOnEscape   == nil) and true or not not opts.CloseOnEscape
	self._message       = (opts.Message ~= nil) and tostring(opts.Message) or nil
	self._rich          = not not opts.Rich

	-- ===== Panel =====
	local panel = Instance.new("Frame")
	panel.Name = "Dialog"
	panel.AnchorPoint = Vector2.new(0.5, 0.5)
	panel.Position = UDim2.fromScale(0.5, 0.5)
	panel.Size = self._size
	panel.BackgroundColor3 = Theme.colors.card
	panel.BorderSizePixel = 0
	panel.Visible = false
	panel.Parent = OVERLAY.Host

	local corner = Instance.new("UICorner", panel)
	corner.CornerRadius = UDim.new(0, Theme.radius.popup)

	local stroke = Instance.new("UIStroke", panel)
	stroke.Color = Theme.colors.stroke
	stroke.Thickness = 1.25

	-- Topbar
	local top = Instance.new("Frame")
	top.Name = "TopBar"
	top.BackgroundTransparency = 1
	top.Size = UDim2.new(1, 0, 0, 56)
	top.Parent = panel

	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.BackgroundTransparency = 1
	title.Text = self._titleTxt
	title.TextColor3 = Theme.colors.text.title
	title.Font = Enum.Font.GothamSemibold
	title.TextSize = 18
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Position = UDim2.new(0, 16, 0, 0)
	title.Size = UDim2.new(1, -48, 1, 0)
	title.Parent = top

	local close = Instance.new("TextButton")
	close.Name = "Close"
	close.AutoButtonColor = false
	close.BackgroundTransparency = 1
	close.Text = "✕"
	close.TextColor3 = Theme.colors.text.muted
	close.Font = Enum.Font.Gotham
	close.TextSize = 16
	close.AnchorPoint = Vector2.new(1, 0.5)
	close.Position = UDim2.new(1, -14, 0.5, 0)
	close.Size = UDim2.fromOffset(28, 28)
	close.Parent = top

	-- Content area
	local content = Instance.new("Frame")
	content.Name = "Content"
	content.BackgroundTransparency = 1
	content.Position = UDim2.new(0, 16, 0, 64)
	content.Size = UDim2.new(1, -32, 1, -122) -- reserve footer 58px
	content.Parent = panel
	local pad = Instance.new("UIPadding", content)
	pad.PaddingTop = UDim.new(0, 2)

	-- Optional message (TextLabel)
	local msg
	if self._message ~= nil then
		msg = Instance.new("TextLabel")
		msg.Name = "Message"
		msg.BackgroundTransparency = 1
		msg.Text = self._message
		msg.RichText = self._rich
		msg.TextWrapped = true
		msg.TextXAlignment = Enum.TextXAlignment.Left
		msg.TextYAlignment = Enum.TextYAlignment.Top
		msg.TextColor3 = Theme.colors.text.normal
		msg.Font = Enum.Font.Gotham
		msg.TextSize = 14
		msg.Size = UDim2.new(1, 0, 1, 0)
		msg.Parent = content
	end

	-- Footer (buttons)
	local footer = Instance.new("Frame")
	footer.Name = "Footer"
	footer.BackgroundTransparency = 1
	footer.Size = UDim2.new(1, -32, 0, 50)
	footer.Position = UDim2.new(0, 16, 1, -58)
	footer.Parent = panel

	local flow = Instance.new("UIListLayout", footer)
	flow.FillDirection = Enum.FillDirection.Horizontal
	flow.HorizontalAlignment = Enum.HorizontalAlignment.Right
	flow.VerticalAlignment = Enum.VerticalAlignment.Center
	flow.Padding = UDim.new(0, 8)

	-- State refs
	self._panel = panel
	self._titleLbl = title
	self._closeBtn = close
	self._content = content
	self._footer = footer
	self._buttons = {}
	self._escConn = nil
	self._opened = false

	-- Close handlers
	self._closeBtn.MouseButton1Click:Connect(function()
		self:Close()
	end)

	if self._closeBackdrop then
		OVERLAY.Backdrop.MouseButton1Click:Connect(function()
			if self._opened then self:Close() end
		end)
	end

	return self
end

-- ===== Methods =====
function Dialog:GetBody()
	return self._content
end

function Dialog:SetTitle(t)
	self._titleTxt = t or self._titleTxt
	self._titleLbl.Text = self._titleTxt
end

function Dialog:SetSize(ud)
	if typeof(ud) == "UDim2" then
		self._panel.Size = ud
	end
end

-- buttons: array of { Text, Primary?, Danger?, Callback? }
function Dialog:SetButtons(buttons)
	-- clear old
	for _, b in ipairs(self._buttons) do
		if b.Button then b.Button:Destroy() end
	end
	self._buttons = {}

	for _, spec in ipairs(buttons or {}) do
		local text = tostring(spec.Text or "OK")
		local btn, _, _paint = makeButton(text, not not spec.Primary, not not spec.Danger)
		btn.Parent = self._footer
		local cb = spec.Callback
		btn.MouseButton1Click:Connect(function()
			if typeof(cb) == "function" then
				local ok, err = pcall(cb)
				if not ok then warn("[Dialog] Button callback error:", err) end
			end
		end)
		table.insert(self._buttons, { Button = btn, Paint = _paint })
	end
end

function Dialog:Open()
	if self._opened then return end
	self._opened = true
	overlayShow()
	self._panel.Visible = true
	Theme.popupIn(self._panel)

	-- ESC to close
	if self._closeEscape then
		self._escConn = UserInputService.InputBegan:Connect(function(input, gp)
			if gp then return end
			if input.KeyCode == Enum.KeyCode.Escape then
				self:Close()
			end
		end)
	end
end

function Dialog:Close()
	if not self._opened then return end
	self._opened = false
	Theme.popupOut(self._panel, function()
		self._panel.Visible = false
		overlayHide()
	end)
	if self._escConn then self._escConn:Disconnect(); self._escConn = nil end
end

function Dialog:Destroy()
	if self._escConn then self._escConn:Disconnect() end
	self._panel:Destroy()
end

-- ===== Presets =====
function Dialog:Alert(opts, onOk)
	opts = opts or {}
	local d = Dialog.new({
		Title = opts.Title or "Alert",
		Message = opts.Message or "",
		Rich = not not opts.Rich,
		CloseOnBackdrop = (opts.CloseOnBackdrop ~= false),
		CloseOnEscape = (opts.CloseOnEscape ~= false),
		Size = opts.Size or UDim2.fromOffset(420, 240),
	})
	d:SetButtons({
		{
			Text = opts.ButtonText or "OK",
			Primary = true,
			Callback = function()
				if typeof(onOk) == "function" then
					local ok, err = pcall(onOk)
					if not ok then warn("[Dialog.Alert] onOk error:", err) end
				end
				d:Close()
				d:Destroy()
			end
		}
	})
	d:Open()
	return d
end

function Dialog:Confirm(opts, onYes, onNo)
	opts = opts or {}
	local d = Dialog.new({
		Title = opts.Title or "Confirm",
		Message = opts.Message or "",
		Rich = not not opts.Rich,
		CloseOnBackdrop = (opts.CloseOnBackdrop ~= false),
		CloseOnEscape = (opts.CloseOnEscape ~= false),
		Size = opts.Size or UDim2.fromOffset(460, 260),
	})
	d:SetButtons({
		{
			Text = opts.NoText or "Cancel",
			Callback = function()
				if typeof(onNo) == "function" then
					local ok, err = pcall(onNo)
					if not ok then warn("[Dialog.Confirm] onNo error:", err) end
				end
				d:Close(); d:Destroy()
			end
		},
		{
			Text = opts.YesText or "Yes",
			Primary = true,
			Callback = function()
				if typeof(onYes) == "function" then
					local ok, err = pcall(onYes)
					if not ok then warn("[Dialog.Confirm] onYes error:", err) end
				end
				d:Close(); d:Destroy()
			end
		},
	})
	d:Open()
	return d
end

function Dialog:Prompt(opts, onSubmit, onCancel)
	opts = opts or {}
	local d = Dialog.new({
		Title = opts.Title or "Prompt",
		Message = opts.Message or "",
		Rich = not not opts.Rich,
		CloseOnBackdrop = (opts.CloseOnBackdrop ~= false),
		CloseOnEscape = (opts.CloseOnEscape ~= false),
		Size = opts.Size or UDim2.fromOffset(520, 280),
	})

	-- Input box kecil di content (gunakan Theme langsung)
	local tb = Instance.new("TextBox")
	tb.Name = "PromptInput"
	tb.ClearTextOnFocus = false
	tb.Text = tostring(opts.Default or "")
	tb.PlaceholderText = tostring(opts.Placeholder or "")
	tb.TextSize = 13
	tb.Font = Enum.Font.Gotham
	tb.TextColor3 = Theme.colors.text.normal
	tb.PlaceholderColor3 = Theme.colors.text.dim
	tb.BackgroundColor3 = Theme.colors.input
	tb.BorderSizePixel = 0
	tb.Size = UDim2.new(1, 0, 0, 30)
	tb.Parent = d:GetBody()
	local tbCorner = Instance.new("UICorner", tb)
	tbCorner.CornerRadius = UDim.new(0, Theme.radius.input)
	local tbStroke = Instance.new("UIStroke", tb)
	tbStroke.Color = Theme.colors.stroke
	tbStroke.Thickness = 1
	Theme.applyInputBox(tb, tbStroke)

	d:SetButtons({
		{
			Text = opts.CancelText or "Cancel",
			Callback = function()
				if typeof(onCancel) == "function" then
					local ok, err = pcall(onCancel, tb.Text)
					if not ok then warn("[Dialog.Prompt] onCancel error:", err) end
				end
				d:Close(); d:Destroy()
			end
		},
		{
			Text = opts.OkText or "OK",
			Primary = true,
			Callback = function()
				if typeof(onSubmit) == "function" then
					local ok, err = pcall(onSubmit, tb.Text)
					if not ok then warn("[Dialog.Prompt] onSubmit error:", err) end
				end
				d:Close(); d:Destroy()
			end
		},
	})

	d:Open()
	tb:CaptureFocus()
	return d
end

-- ===== Singleton export =====
local SINGLETON = _G.__ld_dialog_singleton
if not SINGLETON then
	SINGLETON = Dialog
	_G.__ld_dialog_singleton = SINGLETON
end

return SINGLETON

--[[local Dialog = require(path.to.Dialog)

-- Alert
Dialog:Alert({ Title="Info", Message="Config tersimpan." }, function()
    print("OK clicked")
end)

-- Confirm
Dialog:Confirm({ Title="Hapus Config", Message="Yakin hapus?" },
    function() print("Yes") end,
    function() print("No") end
)

-- Prompt
Dialog:Prompt({ Title="Webhook", Message="Masukkan URL:", Placeholder="https://..." },
    function(text) print("Submit:", text) end,
    function(text) print("Cancel:", text) end
)

-- Builder kustom
local d = Dialog.new({ Title="Settings", Size=UDim2.fromOffset(560, 420) })
local body = d:GetBody()
-- Taruh UI lain di 'body' (Section/Button/Toggle dll)
d:SetButtons({
    { Text="Close", Callback=function() d:Close(); d:Destroy() end },
    { Text="Save", Primary=true, Callback=function() print("Saved"); d:Close(); d:Destroy() end },
})
d:Open()]]