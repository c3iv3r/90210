-- Window.lua (patched 1:1 style Library.txt)
-- Requires: Theme.lua di folder yang sama
-- API ringkas:
--   local Window = require(...Window)
--   local win = Window.new({ Title="Noctis - Fish It - Dev", Size=UDim2.fromOffset(720,460) })
--   local tab = win:AddTab("Home", "rbxassetid://10734828463")  -- icon optional
--   tab.Frame.Parent.Visible = true -- otomatis handle saat dipilih
--   win:Minimize(); win:Restore(); win:Close()

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local ThemeOk, Theme = pcall(function() return require(script.Parent.Theme) end)
Theme = ThemeOk and Theme or {}

-- ====== Theme fallback (kalau Theme.lua belum lengkap) ======
local C = Theme.colors or {
    bg   = Color3.fromRGB(14,16,20),
    card = Color3.fromRGB(22,25,31),
    stroke = Color3.fromRGB(40,44,52),
    input = Color3.fromRGB(28,31,38),
    text = {
        title  = Color3.fromRGB(235,239,255),
        normal = Color3.fromRGB(210,215,230),
        dim    = Color3.fromRGB(150,155,170),
        onAcc  = Color3.fromRGB(255,255,255),
    },
    accent = Color3.fromRGB(88,140,255),
    accent2 = Color3.fromRGB(99,160,255),
    muted  = Color3.fromRGB(32,36,44),
}
local T = Theme.tweening or { base=0.18, fast=0.12, easingStyle=Enum.EasingStyle.Quint, easingDir=Enum.EasingDirection.Out }
local function tween(o,props,dur) if not o then return end
    local info = TweenInfo.new(dur or T.base, T.easingStyle, T.easingDir); TweenService:Create(o, info, props):Play()
end

local function mk(class, props, parent)
    local obj = Instance.new(class)
    if props then for k,v in pairs(props) do obj[k]=v end end
    if parent then obj.Parent = parent end
    return obj
end

local function uiStroke(parent, color, thickness)
    return mk("UIStroke", { Color = color or C.stroke, Thickness = thickness or 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, parent)
end

local function round(parent, r) return mk("UICorner", { CornerRadius = UDim.new(0, r or 10) }, parent) end

-- ========= Module =========
local Window = {}
Window.__index = Window

function Window.new(opts)
    opts = opts or {}
    local self = setmetatable({}, Window)

    -- ===== ScreenGui =====
    local gui = mk("ScreenGui", {
        Name = "NatHub",
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
    })
    -- hijack ke gethui/secure
    local okProtect = pcall(function() if protect_gui then protect_gui(gui) end end)
    if not okProtect then
        if gethui then gui.Parent = gethui()
        else gui.Parent = (RunService:IsStudio() and Players.LocalPlayer:WaitForChild("PlayerGui")) or game:GetService("CoreGui") end
    end
    self.Gui = gui

    -- ===== Drop Shadow =====
    local shadow = mk("ImageLabel", {
        Name="Shadow",
        BackgroundTransparency = 1,
        Image = "rbxassetid://7912134082", -- soft shadow
        ImageColor3 = Color3.fromRGB(0,0,0),
        ImageTransparency = 0.35,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(64,64,192,192),
        AnchorPoint = Vector2.new(0.5,0.5),
        Size = UDim2.fromOffset(740,480),
        Position = UDim2.fromScale(0.5,0.5),
        ZIndex = 0
    }, gui)

    -- ===== Window Root =====
    local root = mk("Frame", {
        Name = "Window",
        BackgroundColor3 = C.card,
        Size = opts.Size or UDim2.fromOffset(720,460),
        AnchorPoint = Vector2.new(0.5,0.5),
        Position = opts.Position or UDim2.fromScale(0.5,0.5),
        BorderSizePixel = 0,
        ZIndex = 1
    }, gui)
    round(root, 12); uiStroke(root, C.stroke, 1)

    -- sync shadow ke root
    local function syncShadow()
        shadow.Size = UDim2.new(0, root.AbsoluteSize.X+20, 0, root.AbsoluteSize.Y+20)
        shadow.Position = UDim2.new(0, root.AbsolutePosition.X + root.AbsoluteSize.X/2, 0, root.AbsolutePosition.Y + root.AbsoluteSize.Y/2)
    end
    root:GetPropertyChangedSignal("AbsoluteSize"):Connect(syncShadow)
    RunService.RenderStepped:Connect(syncShadow)

    -- ===== Topbar =====
    local topbar = mk("Frame", {
        Name = "Topbar",
        BackgroundColor3 = C.card,
        Size = UDim2.new(1,0,0,42),
        BorderSizePixel = 0,
        ZIndex = 2
    }, root)
    uiStroke(topbar, C.stroke, 1)
    round(topbar, 12)

    -- Logo kiri
    local logo = mk("ImageLabel", {
        Name="Logo",
        BackgroundTransparency=1,
        Size = UDim2.fromOffset(18,18),
        Position = UDim2.new(0,14,0.5,-9),
        Image = opts.Logo or "rbxassetid://17608657181", -- ganti kalau punya
        ImageColor3 = Color3.fromRGB(255,255,255),
        ZIndex = 3
    }, topbar)

    -- Title (center)
    local title = mk("TextLabel", {
        Name="Title",
        BackgroundTransparency=1,
        Size=UDim2.new(1,-160,1,0),
        Position=UDim2.new(0.5,-( (root.AbsoluteSize.X-160)/2 ),0,0),
        AnchorPoint = Vector2.new(0,0),
        Text = opts.Title or "Noctis - Fish It - Dev",
        TextColor3 = C.text and C.text.title or Color3.fromRGB(235,239,255),
        TextScaled = false,
        FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
        TextSize = 16,
        ZIndex = 3
    }, topbar)
    title.TextXAlignment = Enum.TextXAlignment.Center

    -- Minimize & Close (kanan)
    local btnClose = mk("TextButton", {
        Name="Close",
        BackgroundTransparency=1,
        Size = UDim2.fromOffset(34,34),
        Position = UDim2.new(1,-40,0.5,-17),
        Text = "✕",
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        TextColor3 = C.text and C.text.dim or Color3.fromRGB(200,205,220),
        ZIndex = 3
    }, topbar)

    local btnMini = mk("TextButton", {
        Name="Minimize",
        BackgroundTransparency=1,
        Size = UDim2.fromOffset(34,34),
        Position = UDim2.new(1,-80,0.5,-17),
        Text = "–",
        TextSize = 24,
        Font = Enum.Font.GothamBold,
        TextColor3 = C.text and C.text.dim or Color3.fromRGB(200,205,220),
        ZIndex = 3
    }, topbar)

    -- Hover effect
    local function hover(btn)
        btn.MouseEnter:Connect(function() tween(btn,{TextColor3=C.accent}, T.fast) end)
        btn.MouseLeave:Connect(function() tween(btn,{TextColor3=C.text and C.text.dim or Color3.fromRGB(200,205,220)}, T.fast) end)
    end; hover(btnClose); hover(btnMini)

    -- Dragging (topbar as handle)
    do
        local dragging, startPos, startInput
        topbar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
                dragging = true
                startInput = input
                startPos = Vector2.new(input.Position.X, input.Position.Y) - Vector2.new(root.AbsolutePosition.X, root.AbsolutePosition.Y)
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then dragging = false end
                end)
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
                local p = input.Position
                root.Position = UDim2.fromOffset(p.X - startPos.X, p.Y - startPos.Y)
            end
        end)
    end

    -- Minimize / Close
    self._isMin = false
    function self:Minimize()
        if self._isMin then return end
        self._isMin = true
        tween(root, { Size = UDim2.new(root.Size.X.Scale, root.Size.X.Offset, 0, 42) })
    end
    function self:Restore()
        if not self._isMin then return end
        self._isMin = false
        tween(root, { Size = opts.Size or UDim2.fromOffset(720,460) })
    end
    function self:IsMinimized() return self._isMin end
    btnMini.MouseButton1Click:Connect(function() if self._isMin then self:Restore() else self:Minimize() end end)
    btnClose.MouseButton1Click:Connect(function() self:Close() end)

    -- ===== Sidebar =====
    local side = mk("Frame", {
        Name="Sidebar",
        BackgroundTransparency=1,
        Size = UDim2.new(0, 180, 1, -42),
        Position = UDim2.new(0,0,0,42),
        ZIndex = 1,
        Parent = root
    })
    local sidePad = mk("UIPadding", { PaddingTop = UDim.new(0,8), PaddingLeft = UDim.new(0,10), PaddingRight = UDim.new(0,8) }, side)
    local sideList = mk("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0,8)
    }, side)

    -- ===== Body =====
    local body = mk("Frame", {
        Name="Body",
        BackgroundColor3 = C.bg,
        Size = UDim2.new(1,-180,1,-42),
        Position = UDim2.new(0,180,0,42),
        BorderSizePixel = 0,
        ZIndex = 1,
        Parent = root
    })
    round(body, 10); uiStroke(body, C.stroke, 1)

    -- API state
    self.Gui, self.Root, self.Topbar, self.Sidebar, self.Body = gui, root, topbar, side, body
    self._tabs = {}
    self._active = nil

    -- Public small setters
    function self:SetTitle(t) title.Text = t or "" end
    function self:SetSubtitle(_) end -- (nggak dipakai di style ini)
    function self:Show() self.Gui.Enabled = true end
    function self:Hide() self.Gui.Enabled = false end
    function self:Toggle() self.Gui.Enabled = not self.Gui.Enabled end
    function self:Focus() root.ZIndex += 1 end
    function self:GetBody() return self.Body end
    function self:Close() self.Gui:Destroy() end
    function self:Destroy() self:Close() end

    -- ===== Tab API =====
    function self:AddTab(name, icon)
        local btn = mk("TextButton", {
            Name = "Tab_"..name,
            AutoButtonColor = false,
            BackgroundColor3 = C.muted,
            Size = UDim2.new(1,-0,0,44),
            Text = "",
            Parent = side
        })
        round(btn, 10); uiStroke(btn, C.stroke, 1)

        local ic = mk("ImageLabel", {
            BackgroundTransparency=1,
            Size = UDim2.fromOffset(20,20),
            Position = UDim2.new(0,12,0.5,-10),
            Image = icon or "rbxassetid://10734828463", -- default icon
            ImageColor3 = C.text and C.text.normal or Color3.new(1,1,1),
            Parent = btn
        })
        local lb = mk("TextLabel", {
            BackgroundTransparency=1,
            AnchorPoint = Vector2.new(0,0.5),
            Position = UDim2.new(0,40,0.5,0),
            Size = UDim2.new(1,-52,1,-0),
            FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json"),
            Text = name,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextSize = 14,
            TextColor3 = C.text and C.text.normal or Color3.fromRGB(220,225,235),
            Parent = btn
        })

        -- tab page
        local page = mk("Frame", {
            Name = "Page_"..name,
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1,1),
            Visible = false,
            Parent = body
        })

        local function setActive(active)
            if active then
                tween(btn,{BackgroundColor3 = C.accent}, T.base)
                lb.TextColor3 = C.text and C.text.onAcc or Color3.new(1,1,1)
                ic.ImageColor3 = C.text and C.text.onAcc or Color3.new(1,1,1)
                page.Visible = true
                self._active = page
            else
                tween(btn,{BackgroundColor3 = C.muted}, T.base)
                lb.TextColor3 = C.text and C.text.normal or Color3.fromRGB(220,225,235)
                ic.ImageColor3 = C.text and C.text.normal or Color3.fromRGB(220,225,235)
                page.Visible = false
            end
        end

        btn.MouseButton1Click:Connect(function()
            for _,t in pairs(self._tabs) do setActive(false, t) end
            setActive(true)
        end)

        local tab = {
            Button = btn,
            Label = lb,
            Icon = ic,
            Frame = page,
            SetActive = setActive
        }
        table.insert(self._tabs, tab)
        if not self._active then btn:Activate() end
        return tab
    end

    -- initial shadow sync
    syncShadow()
    return self
end

return Window