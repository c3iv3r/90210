-- Theme.lua
-- Satu modul untuk: palet warna, gradient, dan animasi (pengganti ParityTheme + EngineState)
-- src/utils/theme.lua
local TweenService = game:GetService("TweenService")

local Theme = {}

-- ===== Palet & Preset =====
Theme.colors = {
    bg        = Color3.fromRGB(14, 16, 20),
    card      = Color3.fromRGB(22, 25, 31),
    stroke    = Color3.fromRGB(40, 44, 52),
    input     = Color3.fromRGB(28, 31, 38),
    item      = Color3.fromRGB(28, 31, 38),
    text      = {
        title  = Color3.fromRGB(235, 239, 255),
        normal = Color3.fromRGB(210, 214, 230),
        dim    = Color3.fromRGB(150, 156, 175),
        muted  = Color3.fromRGB(120, 128, 148),
        onAcc  = Color3.fromRGB(255, 255, 255),
    },
    overlay   = Color3.fromRGB(0,0,0),
}

-- Gradient biru “OG” untuk state selected / button pressed
Theme.gradients = {
    BlueOG = {
        -- urutan ColorSequenceKeypoint (pos, color)
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.00, Color3.fromRGB(41, 127, 255)),
            ColorSequenceKeypoint.new(1.00, Color3.fromRGB(26, 197, 255)),
        }),
        Transparency = NumberSequence.new(0),
        Rotation = 0,
    },
    Subtle = {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.00, Color3.fromRGB(36, 41, 54)),
            ColorSequenceKeypoint.new(1.00, Color3.fromRGB(28, 31, 38)),
        }),
        Transparency = NumberSequence.new(0),
        Rotation = 0,
    }
}

-- Stroke (garis tepi) ketika selected
Theme.accentStroke = Color3.fromRGB(64, 162, 255)

-- Radius standar
Theme.radius = {
    card = 8,
    input = 6,
    item = 6,
    popup = 10,
}

-- ===== Durasi & Easing =====
Theme.tweening = {
    base = 0.18,
    fast = 0.12,
    easingStyle = Enum.EasingStyle.Quint,
    easingDir   = Enum.EasingDirection.Out,
}

-- ===== Helpers Tween =====
function Theme.tween(obj, props, dur, style, dir)
    if not obj then return end
    local info = TweenInfo.new(
        dur or Theme.tweening.base,
        style or Theme.tweening.easingStyle,
        dir or Theme.tweening.easingDir
    )
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

-- Tambah UIGradient ke object (Frame/TextButton)
local function ensureGradient(guiObject, preset)
    local g = guiObject:FindFirstChildOfClass("UIGradient")
    if not g then
        g = Instance.new("UIGradient")
        g.Name = "ThemeGradient"
        g.Parent = guiObject
    end
    g.Color = preset.Color
    g.Transparency = preset.Transparency
    g.Rotation = preset.Rotation or 0
    return g
end

-- Hapus gradient kalau ada
local function clearGradient(guiObject)
    local g = guiObject:FindFirstChild("ThemeGradient")
    if g then g:Destroy() end
end

-- ===== State Painters (Button/Item) =====
-- Normal state (tanpa gradient)
function Theme.paintNormal(guiObject, strokeObj)
    clearGradient(guiObject)
    Theme.tween(guiObject, { BackgroundColor3 = Theme.colors.item }, Theme.tweening.fast)
    if strokeObj then
        Theme.tween(strokeObj, { Color = Theme.colors.stroke, Thickness = 1 }, Theme.tweening.fast)
    end
end

-- Hover (subtle)
function Theme.paintHover(guiObject, strokeObj)
    ensureGradient(guiObject, Theme.gradients.Subtle)
    if strokeObj then Theme.tween(strokeObj, { Color = Theme.colors.stroke, Thickness = 1.25 }, Theme.tweening.fast) end
end

-- Pressed / Selected (gradient biru OG)
function Theme.paintSelected(guiObject, strokeObj)
    ensureGradient(guiObject, Theme.gradients.BlueOG)
    if strokeObj then Theme.tween(strokeObj, { Color = Theme.accentStroke, Thickness = 1.5 }, Theme.tweening.fast) end
end

-- ===== Text helpers =====
function Theme.setText(label, color3)
    if label then Theme.tween(label, { TextColor3 = color3 }, Theme.tweening.fast) end
end

-- Catatan: Roblox belum dukung gradient langsung ke isi teks; biasanya pakai trik.
-- Di sini kita sediakan API stub untuk konsistensi; default-nya fallback ke warna putih.
function Theme.applyTextGradient(label, _presetName)
    Theme.setText(label, Theme.colors.text.onAcc)
end

-- ===== Popup animation =====
function Theme.popupIn(panel)
    local size0 = panel.Size
    panel.Size = UDim2.fromOffset(size0.X.Offset, size0.Y.Offset - 36)
    Theme.tween(panel, { Size = size0 }, Theme.tweening.base)
end

function Theme.popupOut(panel, onDone)
    local size0 = panel.Size
    local t = Theme.tween(panel, { Size = UDim2.fromOffset(size0.X.Offset, size0.Y.Offset - 36) }, Theme.tweening.fast)
    if t then
        t.Completed:Connect(function()
            if typeof(onDone) == "function" then onDone() end
        end)
    else
        if typeof(onDone) == "function" then onDone() end
    end
end

-- ===== Convenience apply untuk komponen input =====
function Theme.applyInputBox(box, stroke)
    Theme.tween(box, { BackgroundColor3 = Theme.colors.input }, Theme.tweening.fast)
    if stroke then Theme.tween(stroke, { Color = Theme.colors.stroke }, Theme.tweening.fast) end
end

function Theme.applyCard(frame, stroke)
    Theme.tween(frame, { BackgroundColor3 = Theme.colors.card }, Theme.tweening.fast)
    if stroke then Theme.tween(stroke, { Color = Theme.colors.stroke }, Theme.tweening.fast) end
end

-- Untuk item dropdown: selected / normal
function Theme.applyDropdownItem(btn, label, isSelected)
    local stroke = btn:FindFirstChildOfClass("UIStroke")
    if isSelected then
        Theme.paintSelected(btn, stroke)
        Theme.setText(label, Theme.colors.text.onAcc)
    else
        Theme.paintNormal(btn, stroke)
        Theme.setText(label, Theme.colors.text.normal)
    end
end

return Theme