-- Popup.lua
-- Private module: Popup/Popover ala Library.txt
-- Integrasi penuh: Theme.lua (warna, gradient, animasi)
-- API:
--   local Popup = require(path.to.Popup)
--   local p = Popup.new({
--       Title = "Options",            -- optional
--       Message = "Pilih aksi",       -- optional (bisa pakai konten kustom)
--       Rich = false,                 -- RichText utk Message
--       Size = UDim2.fromOffset(260, 140),
--       Anchor = someGuiObject,       -- dianjurkan
--       Placement = "Bottom",         -- "Top"|"Bottom"|"Left"|"Right"|"Auto"
--       Offset = 8,
--       CloseOnBackdrop = true,
--       CloseOnEscape = true,
--       AutoClose = 0,                -- detik; 0 = tidak auto-close
--   })
--   -- Konten kustom:
--   local body = p:GetBody()   -- parent-kan UI lain ke sini
--   p:Open()                   -- tampilkan
--   p:Close()                  -- tutup
--   p:Destroy()                -- hapus
--   -- Utility:
--   p:SetTitle("New Title")
--   p:SetMessage("New message", true)   -- true = rich
--   p:Attach(anchorGui)                 -- ganti anchor
--   p:SetPlacement("Top", 12)           -- dengan offset baru
--   p:SetSize(UDim2.fromOffset(280,160))

local UserInputService = game:GetService("UserInputService")
local CoreGui          = game:GetService("CoreGui")
local RunService       = game:GetService("RunService")

local Theme = require("Theme")

local Popup = {}
Popup.__index = Popup

-- ===== Singleton Overlay =====
local OVERLAY_TAG = "LogicDev_PopupOverlay"

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
	backdrop.BackgroundTransparency = 1 -- Popup: backdrop transparan (klik utk close)
	backdrop.BorderSizePixel = 0
	backdrop.Size = UDim2.fromScale(1,1)
	backdrop.Parent = sg

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

local OVERLAY = _G.__ld_popup_overlay
if not OVERLAY then
	OVERLAY = buildOverlay()
	_G.__ld_popup_overlay = OVERLAY
end

local function overlayShow()
	OVERLAY._stack = OVERLAY._stack + 1
	OVERLAY.Gui.Enabled = true
end
local function overlayHide()
	OVERLAY._stack = math.max(0, OVERLAY._stack - 1)
	if OVERLAY._stack == 0 then
		OVERLAY.Gui.Enabled = false
	end
end

-- ===== Arrow helper (kotak 45°) =====
local function makeArrow(parent)
	local arrow = Instance.new("Frame")
	arrow.Name = "Arrow"
	arrow.Size = UDim2.fromOffset(12, 12)
	arrow.AnchorPoint = Vector2.new(0.5, 0.5)
	arrow.BackgroundColor3 = Theme.colors.card
	arrow.BorderSizePixel = 0
	arrow.Rotation = 45
	arrow.Parent = parent

	local stroke = Instance.new("UIStroke", arrow)
	stroke.Color = Theme.colors.stroke
	stroke.Thickness = 1

	return arrow, stroke
end

-- ===== Placement calc =====
local function rectOf(gui)
	if not gui or not gui.AbsoluteSize then
		return 0,0,0,0
	end
	local p = gui.AbsolutePosition
	local s = gui.AbsoluteSize
	return p.X, p.Y, s.X, s.Y
end

local function viewportSize()
	local vps = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920,1080)
	return vps.X, vps.Y
end

local function computePosition(anchor, panelSize, placement, offset)
	local ax, ay, aw, ah = rectOf(anchor)
	local vw, vh = viewportSize()
	local pw = panelSize.X.Offset
	local ph = panelSize.Y.Offset

	local x = ax
	local y = ay + ah + offset

	if placement == "Top" then
		x = ax
		y = ay - ph - offset
	elseif placement == "Left" then
		x = ax - pw - offset
		y = ay + (ah - ph)/2
	elseif placement == "Right" then
		x = ax + aw + offset
		y = ay + (ah - ph)/2
	elseif placement == "Bottom" then
		x = ax
		y = ay + ah + offset
	elseif placement == "Auto" then
		-- Coba bawah, kalau mepet bawah pakai atas.
		if ay + ah + offset + ph <= vh - 8 then
			x = ax
			y = ay + ah + offset
			placement = "Bottom"
		elseif ay - offset - ph >= 8 then
			x = ax
			y = ay - ph - offset
			placement = "Top"
		else
			-- fallback kanan/kiri
			if ax + aw + offset + pw <= vw - 8 then
				x = ax + aw + offset
				y = ay + (ah - ph)/2
				placement = "Right"
			else
				x = ax - pw - offset
				y = ay + (ah - ph)/2
				placement = "Left"
			end
		end
	end

	-- Clamp sedikit supaya gak kepotong layar
	x = math.max(8, math.min(x, vw - pw - 8))
	y = math.max(8, math.min(y, vh - ph - 8))

	return UDim2.fromOffset(x, y), placement
end

-- ===== Constructor =====
function Popup.new(opts)
	opts = opts or {}
	local self = setmetatable({}, Popup)

	self._titleTxt = opts.Title or ""
	self._message  = opts.Message
	self._rich     = not not opts.Rich
	self._size     = opts.Size or UDim2.fromOffset(260, 140)
	self._anchor   = opts.Anchor
	self._placement= opts.Placement or "Auto"
	self._offset   = tonumber(opts.Offset) or 8
	self._closeBackdrop = (opts.CloseOnBackdrop == nil) and true or not not opts.CloseOnBackdrop
	self._closeEscape   = (opts.CloseOnEscape == nil) and true or not not opts.CloseOnEscape
	self._autoClose     = tonumber(opts.AutoClose) or 0

	-- Panel
	local panel = Instance.new("Frame")
	panel.Name = "Popup"
	panel.BackgroundColor3 = Theme.colors.card
	panel.BorderSizePixel = 0
	panel.Visible = false
	panel.Size = self._size
	panel.Parent = OVERLAY.Host

	local corner = Instance.new("UICorner", panel)
	corner.CornerRadius = UDim.new(0, Theme.radius.popup)

	local stroke = Instance.new("UIStroke", panel)
	stroke.Color = Theme.colors.stroke
	stroke.Thickness = 1

	-- Arrow
	local arrow, arrowStroke = makeArrow(panel)

	-- Header (optional)
	local top = Instance.new("Frame")
	top.Name = "Top"
	top.BackgroundTransparency = 1
	top.Size = UDim2.new(1, -24, 0, (self._titleTxt ~= "" and 28) or 0)
	top.Position = UDim2.new(0, 12, 0, 10)
	top.Visible = self._titleTxt ~= ""
	top.Parent = panel

	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.BackgroundTransparency = 1
	title.Text = self._titleTxt
	title.TextColor3 = Theme.colors.text.title
	title.Font = Enum.Font.GothamSemibold
	title.TextSize = 15
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Size = UDim2.new(1, 0, 1, 0)
	title.Parent = top

	-- Body
	local content = Instance.new("Frame")
	content.Name = "Body"
	content.BackgroundTransparency = 1
	local bodyYOffset = (self._titleTxt ~= "" and 40) or 12
	content.Position = UDim2.new(0, 12, 0, bodyYOffset)
	content.Size = UDim2.new(1, -24, 1, -bodyYOffset - 12)
	content.Parent = panel

	local msg
	if self._message ~= nil then
		msg = Instance.new("TextLabel")
		msg.Name = "Message"
		msg.BackgroundTransparency = 1
		msg.Text = tostring(self._message)
		msg.RichText = self._rich
		msg.TextWrapped = true
		msg.TextXAlignment = Enum.TextXAlignment.Left
		msg.TextYAlignment = Enum.TextYAlignment.Top
		msg.TextColor3 = Theme.colors.text.normal
		msg.Font = Enum.Font.Gotham
		msg.TextSize = 13
		msg.Size = UDim2.new(1, 0, 1, 0)
		msg.Parent = content
	end

	-- Refs
	self._panel = panel
	self._stroke = stroke
	self._arrow = arrow
	self._arrowStroke = arrowStroke
	self._titleBar = top
	self._titleLbl = title
	self._content = content
	self._msgLbl = msg

	self._opened = false
	self._escConn = nil
	self._heartbeatConn = nil
	self._autoCloseConn = nil

	-- Backdrop close
	if self._closeBackdrop then
		OVERLAY.Backdrop.MouseButton1Click:Connect(function()
			if self._opened then self:Close() end
		end)
	end

	return self
end

-- ===== Internal helpers =====
local function placeArrow(self, placement)
	local a = self._arrow
	local s = self._panel.Size
	local w = s.X.Offset
	local h = s.Y.Offset

	if placement == "Top" then
		a.Position = UDim2.fromOffset(w*0.5, h - 6)
	elseif placement == "Bottom" then
		a.Position = UDim2.fromOffset(w*0.5, 6)
	elseif placement == "Left" then
		a.Position = UDim2.fromOffset(w - 6, h*0.5)
	elseif placement == "Right" then
		a.Position = UDim2.fromOffset(6, h*0.5)
	else
		a.Visible = false
		return
	end
	a.Visible = true
end

local function updatePosition(self)
	if not self._anchor then return end
	local pos, finalPlacement = computePosition(self._anchor, self._panel.Size, self._placement, self._offset)
	self._panel.Position = pos
	placeArrow(self, finalPlacement)
end

-- ===== Public API =====
function Popup:GetBody()
	return self._content
end

function Popup:SetTitle(t)
	self._titleTxt = t or ""
	self._titleLbl.Text = self._titleTxt
	self._titleBar.Visible = (self._titleTxt ~= "")
	-- resize body area
	local bodyYOffset = (self._titleTxt ~= "" and 40) or 12
	self._content.Position = UDim2.new(0, 12, 0, bodyYOffset)
	self._content.Size = UDim2.new(1, -24, 1, -bodyYOffset - 12)
end

function Popup:SetMessage(text, rich)
	self._message = (text ~= nil) and tostring(text) or nil
	self._rich = not not rich
	if self._message ~= nil then
		if not self._msgLbl then
			self._msgLbl = Instance.new("TextLabel")
			self._msgLbl.Name = "Message"
			self._msgLbl.BackgroundTransparency = 1
			self._msgLbl.TextXAlignment = Enum.TextXAlignment.Left
			self._msgLbl.TextYAlignment = Enum.TextYAlignment.Top
			self._msgLbl.TextColor3 = Theme.colors.text.normal
			self._msgLbl.Font = Enum.Font.Gotham
			self._msgLbl.TextSize = 13
			self._msgLbl.Size = UDim2.new(1, 0, 1, 0)
			self._msgLbl.Parent = self._content
		end
		self._msgLbl.Text = self._message
		self._msgLbl.RichText = self._rich
	else
		if self._msgLbl then
			self._msgLbl:Destroy()
			self._msgLbl = nil
		end
	end
end

function Popup:SetSize(ud)
	if typeof(ud) == "UDim2" then
		self._size = ud
		self._panel.Size = ud
		updatePosition(self)
	end
end

function Popup:SetPlacement(where, offset)
	if type(where) == "string" then
		self._placement = where
	end
	if offset ~= nil then
		self._offset = tonumber(offset) or self._offset
	end
	updatePosition(self)
end

function Popup:Attach(anchorGui)
	self._anchor = anchorGui
	updatePosition(self)
end

function Popup:Open()
	if self._opened then return end
	self._opened = true
	overlayShow()

	-- temp set pos sebelum anim
	updatePosition(self)

	self._panel.Visible = true
	Theme.popupIn(self._panel)

	-- ESC
	if self._closeEscape then
		self._escConn = UserInputService.InputBegan:Connect(function(input, gp)
			if gp then return end
			if input.KeyCode == Enum.KeyCode.Escape then
				self:Close()
			end
		end)
	end

	-- Follow anchor (kalau bergerak)
	self._heartbeatConn = RunService.Heartbeat:Connect(function()
		if self._opened then
			updatePosition(self)
		end
	end)

	-- AutoClose
	if self._autoClose and self._autoClose > 0 then
		local start = os.clock()
		self._autoCloseConn = RunService.Heartbeat:Connect(function()
			if os.clock() - start >= self._autoClose then
				self:Close()
			end
		end)
	end
end

function Popup:Close()
	if not self._opened then return end
	self._opened = false
	Theme.popupOut(self._panel, function()
		self._panel.Visible = false
		overlayHide()
	end)
	if self._escConn then self._escConn:Disconnect(); self._escConn = nil end
	if self._heartbeatConn then self._heartbeatConn:Disconnect(); self._heartbeatConn = nil end
	if self._autoCloseConn then self._autoCloseConn:Disconnect(); self._autoCloseConn = nil end
end

function Popup:Destroy()
	if self._escConn then self._escConn:Disconnect() end
	if self._heartbeatConn then self._heartbeatConn:Disconnect() end
	if self._autoCloseConn then self._autoCloseConn:Disconnect() end
	self._panel:Destroy()
end

return Popup

--[[local Popup = require(path.to.Popup)
local Button = someButton -- anchor (GuiObject)

local pop = Popup.new({
    Title = "Quick Actions",
    Message = "Pilih salah satu aksi di bawah ini.",
    Size = UDim2.fromOffset(260, 140),
    Anchor = Button,
    Placement = "Bottom",
    Offset = 8,
    AutoClose = 0, -- 0 = no autoclose
})

-- Tambah konten kustom ke body:
local body = pop:GetBody()
local act = Instance.new("TextButton")
act.Text = "Do Something"
act.Size = UDim2.new(1, 0, 0, 28)
act.Parent = body
act.MouseButton1Click:Connect(function()
    print("Clicked!")
    pop:Close()
end)

-- Tampilkan
pop:Open()

-- Util:
-- pop:SetTitle("Options")
-- pop:SetMessage("<b>Bold</b> text", true)
-- pop:SetPlacement("Top", 12)
-- pop:SetSize(UDim2.fromOffset(300, 160))
-- pop:Attach(newAnchor)
-- pop:Close(); pop:Destroy()]]