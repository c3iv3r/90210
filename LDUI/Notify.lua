-- Notification.lua
-- Private module: Notification/Notify ala Library.txt
-- Integrasi penuh: Theme.lua (warna, gradient, animasi)
-- API:
--   local Notify = require(path.to.Notification)
--   Notify:Notify({ Title="Saved", Message="Config tersimpan", Type="Success", Duration=3 })
--   Notify:Info(msg, duration?) / :Success(...) / :Warning(...) / :Error(...)
--   Notify:SetMaxVisible(n) / :Clear()

local TweenService = game:GetService("TweenService")
local CoreGui      = game:GetService("CoreGui")

local Theme = require("Theme")

local Notification = {}
Notification.__index = Notification

-- ====== Singleton root (pojok kanan atas) ======
local ROOT_TAG = "LogicDev_Notifications"

local function buildRoot()
	local sg = Instance.new("ScreenGui")
	sg.Name = ROOT_TAG
	sg.ResetOnSpawn = false
	sg.IgnoreGuiInset = false
	sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	sg.Parent = (gethui and gethui()) or CoreGui

	local holder = Instance.new("Frame")
	holder.Name = "Holder"
	holder.AnchorPoint = Vector2.new(1, 0)
	holder.Position = UDim2.new(1, -14, 0, 14)
	holder.BackgroundTransparency = 1
	holder.Size = UDim2.fromOffset(360, 600)
	holder.ClipsDescendants = false
	holder.Parent = sg

	local layout = Instance.new("UIListLayout", holder)
	layout.FillDirection = Enum.FillDirection.Vertical
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	layout.VerticalAlignment = Enum.VerticalAlignment.Top
	layout.Padding = UDim.new(0, 8)
	layout.SortOrder = Enum.SortOrder.LayoutOrder

	return { Gui = sg, Holder = holder, Layout = layout }
end

local ROOT = _G.__ld_notify_root
if not ROOT then
	ROOT = buildRoot()
	_G.__ld_notify_root = ROOT
end

-- ====== Palet tipe ======
local TYPE_DEF = {
	Info = {
		-- Biru OG (gradient) untuk header strip
		strip = Color3.fromRGB(80, 164, 255),
		icon  = "ℹ",
	},
	Success = {
		strip = Color3.fromRGB(88, 199, 122),
		icon  = "✓",
	},
	Warning = {
		strip = Color3.fromRGB(245, 188, 87),
		icon  = "!",
	},
	Error = {
		strip = Color3.fromRGB(235, 99, 99),
		icon  = "×",
	},
}

local function clamp(n, a, b)
	if n < a then return a end
	if n > b then return b end
	return n
end

-- ====== Toast builder ======
local function makeToast(opts)
	opts = opts or {}
	local titleTxt  = tostring(opts.Title or "")
	local message   = tostring(opts.Message or "")
	local tname     = TYPE_DEF[opts.Type] and opts.Type or "Info"
	local tdef      = TYPE_DEF[tname]
	local duration  = tonumber(opts.Duration) or 3

	-- Root card
	local card = Instance.new("Frame")
	card.Name = "Toast_" .. tname
	card.BackgroundColor3 = Theme.colors.card
	card.BorderSizePixel = 0
	card.Size = UDim2.new(1, 0, 0, message ~= "" and 76 or 56)
	card.ClipsDescendants = true

	local corner = Instance.new("UICorner", card)
	corner.CornerRadius = UDim.new(0, Theme.radius.card)

	local stroke = Instance.new("UIStroke", card)
	stroke.Color = Theme.colors.stroke
	stroke.Thickness = 1
	Theme.applyCard(card, stroke)

	local pad = Instance.new("UIPadding", card)
	pad.PaddingLeft = UDim.new(0, 12)
	pad.PaddingRight = UDim.new(0, 12)
	pad.PaddingTop = UDim.new(0, 8)
	pad.PaddingBottom = UDim.new(0, 8)

	-- Strip kiri (accent by type)
	local strip = Instance.new("Frame")
	strip.Name = "Strip"
	strip.BackgroundColor3 = tdef.strip
	strip.BorderSizePixel = 0
	strip.Size = UDim2.new(0, 4, 1, 0)
	strip.Position = UDim2.new(0, -4, 0, 0) -- start di luar untuk slide kecil
	strip.Parent = card
	Theme.tween(strip, { Position = UDim2.new(0, 0, 0, 0) }, Theme.tweening.fast)

	-- Ikon & judul
	local icon = Instance.new("TextLabel")
	icon.Name = "Icon"
	icon.BackgroundTransparency = 1
	icon.Text = tdef.icon
	icon.TextColor3 = Theme.colors.text.dim
	icon.Font = Enum.Font.Gotham
	icon.TextSize = 14
	icon.Size = UDim2.fromOffset(18, 18)
	icon.Position = UDim2.new(0, 8, 0, 8)
	icon.Parent = card

	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.BackgroundTransparency = 1
	title.Text = titleTxt ~= "" and titleTxt or tname
	title.TextColor3 = Theme.colors.text.title
	title.Font = Enum.Font.GothamSemibold
	title.TextSize = 15
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Position = UDim2.new(0, 28, 0, 6)
	title.Size = UDim2.new(1, -56, 0, 18)
	title.Parent = card

	local close = Instance.new("TextButton")
	close.Name = "Close"
	close.AutoButtonColor = false
	close.BackgroundTransparency = 1
	close.Text = "✕"
	close.TextColor3 = Theme.colors.text.muted
	close.Font = Enum.Font.Gotham
	close.TextSize = 14
	close.AnchorPoint = Vector2.new(1, 0)
	close.Position = UDim2.new(1, -6, 0, 6)
	close.Size = UDim2.fromOffset(18, 18)
	close.Parent = card

	local msg = Instance.new("TextLabel")
	msg.Name = "Message"
	msg.BackgroundTransparency = 1
	msg.Text = message
	msg.TextWrapped = true
	msg.TextXAlignment = Enum.TextXAlignment.Left
	msg.TextYAlignment = Enum.TextYAlignment.Top
	msg.TextColor3 = Theme.colors.text.normal
	msg.Font = Enum.Font.Gotham
	msg.TextSize = 13
	msg.Position = UDim2.new(0, 8, 0, 28)
	msg.Size = UDim2.new(1, -16, 0, message ~= "" ? 36 : 0) -- placeholder; auto height not needed
	msg.Parent = card

	-- Progress (bottom bar)
	local prog = Instance.new("Frame")
	prog.Name = "Progress"
	prog.BackgroundColor3 = tdef.strip
	prog.BorderSizePixel = 0
	prog.Size = UDim2.new(1, 0, 0, 2)
	prog.Position = UDim2.new(0, 0, 1, -2)
	prog.Parent = card
	local progFill = Instance.new("Frame")
	progFill.Name = "Fill"
	progFill.BackgroundColor3 = Theme.colors.input
	progFill.BackgroundTransparency = 0.25
	progFill.BorderSizePixel = 0
	progFill.Size = UDim2.new(1, 0, 1, 0)
	progFill.Parent = prog

	-- Hover effects
	local hovering = false
	card.MouseEnter:Connect(function()
		hovering = true
		Theme.paintHover(card, stroke)
	end)
	card.MouseLeave:Connect(function()
		hovering = false
		Theme.paintNormal(card, stroke)
	end)

	return {
		Card = card,
		Stroke = stroke,
		Progress = progFill,
		Close = close,
		Duration = duration,
	}
end

-- ====== Core object ======
function Notification.new()
	local self = setmetatable({}, Notification)
	self._root = ROOT
	self._maxVisible = 4
	self._queue = {}
	self._active = {}
	return self
end

-- internal: layout slide-in/out
local function slideIn(card)
	card.Parent = ROOT.Holder
	card.Position = UDim2.new(1, 360, 0, 0)
	card.Visible = true
	Theme.tween(card, { Position = UDim2.new(0, 0, 0, 0) }, Theme.tweening.base)
end

local function slideOut(card, onDone)
	local t = Theme.tween(card, { Position = UDim2.new(1, 360, 0, 0), BackgroundTransparency = 1 }, Theme.tweening.base)
	if t then
		t.Completed:Connect(function()
			if typeof(onDone) == "function" then onDone() end
			card:Destroy()
		end)
	else
		if typeof(onDone) == "function" then onDone() end
		card:Destroy()
	end
end

function Notification:_spawn(opts)
	local toast = makeToast(opts)
	toast.Card.LayoutOrder = os.clock() * 1000

	slideIn(toast.Card)

	-- auto progress
	local alive = true
	local total = clamp(toast.Duration, 1, 60)
	toast.Progress.Size = UDim2.new(1, 0, 1, 0)
	local start = os.clock()

	local hb; hb = game:GetService("RunService").Heartbeat:Connect(function()
		if not alive then hb:Disconnect() return end
		local dt = os.clock() - start
		local r = 1 - (dt / total)
		if r <= 0 then
			alive = false
			hb:Disconnect()
			slideOut(toast.Card)
		else
			toast.Progress.Size = UDim2.new(r, 0, 1, 0)
		end
	end)

	toast.Close.MouseButton1Click:Connect(function()
		if alive then alive = false end
		if hb then hb:Disconnect() end
		slideOut(toast.Card)
	end)

	return toast
end

-- ensure capacity: keep at most max visible; older slide out
function Notification:_enforceLimit()
	local children = {}
	for _, c in ipairs(self._root.Holder:GetChildren()) do
		if c:IsA("Frame") and c.Name:match("^Toast_") then
			table.insert(children, c)
		end
	end
	table.sort(children, function(a,b) return a.LayoutOrder < b.LayoutOrder end)
	while #children > self._maxVisible do
		local c = table.remove(children, 1)
		if c then slideOut(c) end
	end
end

-- ====== Public API ======
function Notification:SetMaxVisible(n)
	self._maxVisible = clamp(tonumber(n) or 4, 1, 10)
	self:_enforceLimit()
end

function Notification:Clear()
	for _, c in ipairs(self._root.Holder:GetChildren()) do
		if c:IsA("Frame") and c.Name:match("^Toast_") then
			c:Destroy()
		end
	end
end

function Notification:Notify(opts)
	opts = opts or {}
	self:_enforceLimit()
	return self:_spawn(opts)
end

function Notification:Info(text, duration)
	return self:Notify({ Title = "Info", Message = tostring(text or ""), Type = "Info", Duration = duration or 3 })
end
function Notification:Success(text, duration)
	return self:Notify({ Title = "Success", Message = tostring(text or ""), Type = "Success", Duration = duration or 3 })
end
function Notification:Warning(text, duration)
	return self:Notify({ Title = "Warning", Message = tostring(text or ""), Type = "Warning", Duration = duration or 3 })
end
function Notification:Error(text, duration)
	return self:Notify({ Title = "Error", Message = tostring(text or ""), Type = "Error", Duration = duration or 3 })
end

-- ====== Singleton export ======
local SINGLETON = _G.__ld_notify_singleton
if not SINGLETON then
	SINGLETON = Notification.new()
	_G.__ld_notify_singleton = SINGLETON
end

return SINGLETON

--[[local Notify = require(path.to.Notification)

-- Basic
Notify:Success("Config tersimpan!", 3)
Notify:Info("Memuat data...")
Notify:Warning("Koneksi tidak stabil", 4)
Notify:Error("Gagal mengirim data", 5)

-- Kustom:
Notify:Notify({
    Title = "Webhook",
    Message = "Webhook berhasil diuji.",
    Type = "Success",     -- "Info" | "Success" | "Warning" | "Error"
    Duration = 3,
})

-- Opsi global:
-- Notify:SetMaxVisible(5)
-- Notify:Clear()]]