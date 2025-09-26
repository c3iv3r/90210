-- Init.lua  — Packed Loader w/ virtual require()
-- Load 2 modul (Window, Section) dari 1 folder repo GitHub
-- Return: Library table dgn :CreateWindow(opts)

local HttpGet = (syn and syn.request) and function(url)
    local r = syn.request({Url = url, Method = "GET"})
    if r.StatusCode ~= 200 then error("[Init] HTTP "..r.StatusCode.." for "..url) end
    return r.Body
end or function(url)
    return game:HttpGet(url)
end

-- ====== CONFIG: ganti ini ke folder raw repo kamu ======
local BASE = "https://raw.githubusercontent.com/c3iv3r/90210/refs/heads/main/LDUI/"
local SOURCES = {
    Window  = BASE .. "Button.lua",
    Section = BASE .. "Dialog.lua",
}
-- =======================================================

-- Safe fenv helpers
local _getfenv = getfenv or function() return _ENV end
local _setfenv = setfenv or function(fn, env)
    -- Luau fallback: bind env fields into upvalues
    local envUp = debug.getupvalue(fn, 1)
    if type(envUp) == "table" then for k,v in pairs(env) do envUp[k] = v end end
    return fn
end

-- ===== Module registry with virtual require =====
local Registry = {}
local Cache    = {}

local function fetch_source(name)
    local url = SOURCES[name]
    if not url then
        error(("[Init] Unknown module '%s' (no URL mapping)"):format(name))
    end
    return HttpGet(url), url
end

local function compile(name, src)
    local chunk, err = loadstring(src, "="..name)
    if not chunk then error(("[Init] compile error in %s: %s"):format(name, err)) end
    -- per-module environment inherits caller env
    local env = setmetatable({require = function(n) return Registry.require(n) end}, {__index = _getfenv()})
    _setfenv(chunk, env)
    return chunk
end

Registry.require = function(name)
    if Cache[name] ~= nil then return Cache[name] end
    local src, url = fetch_source(name)
    local chunk = compile(name, src)
    local ok, ret = pcall(chunk)
    if not ok then
        error(("[Init] runtime error in %s (%s): %s"):format(name, tostring(url), tostring(ret)))
    end
    Cache[name] = (ret == nil and true or ret) -- allow modules that return true
    return Cache[name]
end

-- ===== Facade: Library =====
local Library = {}
Library.__index = Library

-- CreateWindow: prefer Window.new(opts) -> Window.CreateWindow(opts) -> call table as fn
function Library:CreateWindow(opts)
    local Window = Registry.require("Window")
    local ctor = (type(Window) == "table" and (Window.new or Window.CreateWindow)) or Window
    if type(ctor) ~= "function" then
        error("[Init] 'Window' module must expose .new(opts) or .CreateWindow(opts) or be a callable")
    end
    local win = ctor(opts)
    -- Optional: attach Section factory so Window/Tab can use if needed
    win.__SectionModule = function() return Registry.require("Section") end
    return win
end

-- (Opsional) expose raw modules kalau kamu mau akses langsung:
function Library.Require(name) return Registry.require(name) end

return setmetatable({}, { __index = Library })