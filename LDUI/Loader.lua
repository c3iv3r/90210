-- PackedLoader.lua
-- Single-file loader: ambil semua modul LDUI dari repo kamu, sekali loadstring.
-- Cukup edit BASE_URL ke folder LDUI (raw GitHub) kamu.

local HttpService = game:GetService("HttpService")

-- ====== KONFIG ======
local BASE_URL = "https://raw.githubusercontent.com/c3iv3r/90210/refs/heads/main/LDUI/" -- ganti sesuai repo kamu
local MODULES = {
	"Theme","Window","Tab","Section","Dropdown","Button","Input","Toggle",
	"Dialog","Popup","Divider", "OpenButton","Paragraph","Slider",
}

-- ====== Registry require/provide ======
local REG = {}
local function provide(name, loader) REG[name] = {loader=loader, value=nil, loaded=false} end
local function require_local(name)
	local m = REG[name]
	assert(m, "[PackedLoader] Module tidak ditemukan: "..tostring(name))
	if not m.loaded then m.value = m.loader(); m.loaded = true end
	return m.value
end

-- ====== Fetch & Patch ======
local function http_get(u)
	local ok, res = pcall(function() return game:HttpGet(u) end)
	assert(ok and type(res)=="string" and #res>0, "[PackedLoader] Gagal HttpGet: "..u)
	return res
end

local function patch_requires(src)
	-- Ubah require(script.Parent.X) -> require("X")
	src = src:gsub("require%s*%(%s*script%.Parent%.Theme%s*%)", "require(\"Theme\")")
	src = src:gsub("require%s*%(%s*script%.Parent%.([%w_]+)%s*%)", "require(\"%1\")")
	return src
end

-- ====== Registrasi semua modul (lazy) ======
for _, name in ipairs(MODULES) do
	provide(name, function()
		local url = BASE_URL .. name .. ".lua"
		local src = patch_requires(http_get(url))
		local chunk, err = loadstring(src, "="..name..".lua")
		assert(chunk, "[PackedLoader] loadstring error di "..name..": "..tostring(err))
		-- beri akses require lokal ke modul
		local env = setmetatable({ require = require_local }, { __index = getfenv() })
		setfenv(chunk, env)
		local exports = chunk()
		assert(exports ~= nil, "[PackedLoader] Modul "..name.." tidak me-return apa pun")
		return exports
	end)
end

-- ====== Build API setara Loader.lua ======
local Theme        = require_local("Theme")
local Window       = require_local("Window")
local Tab          = require_local("Tab")
local Section      = require_local("Section")
local Dropdown     = require_local("Dropdown")
local Button       = require_local("Button")
local Input        = require_local("Input")
local Toggle       = require_local("Toggle")
local Dialog       = require_local("Dialog")
local Popup        = require_local("Popup")
local Divider      = require_local("Divider")
local OpenButton   = require_local("OpenButton")
local Paragraph    = require_local("Paragraph")
local Slider       = require_local("Slider")

local UI = {
	Theme=Theme, Window=Window, Tab=Tab, Section=Section, Dropdown=Dropdown,
	Button=Button, Input=Input, Toggle=Toggle, Dialog=Dialog, Popup=Popup,
	Divider=Divider, OpenButton=OpenButton,
	Paragraph=Paragraph, Slider=Slider,

	NewWindow=function(opts) return Window.new(opts or {}) end,
	NewTab=function(parent, opts) return Tab.new(parent, opts or {}) end,
	NewSection=function(parent, opts) return Section.new(parent, opts or {}) end,
	NewDropdown=function(parent, opts) return Dropdown.new(parent, opts or {}) end,
	NewButton=function(parent, opts) return Button.new(parent, opts or {}) end,
	NewInput=function(parent, opts) return Input.new(parent, opts or {}) end,
	NewToggle=function(parent, opts) return Toggle.new(parent, opts or {}) end,
	NewSlider=function(parent, opts) return Slider.new(parent, opts or {}) end,
	NewParagraph=function(parent, opts) return Paragraph.new(parent, opts or {}) end,
	NewDivider=function(parent, textOrOpts) return Divider.new(parent, textOrOpts) end,
	NewDialog=function(opts) return Dialog.new(opts or {}) end,
	NewPopup=function(opts) return Popup.new(opts or {}) end,
	NewOpenButton=function(opts) return OpenButton.new(opts or {}) end,
}

return UI