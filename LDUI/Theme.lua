-- Theme Module
local ThemeManager = {}

-- Default Theme (Dark)
local DefaultTheme = {
    -- Window Colors
    Window = {
        Background = Color3.fromRGB(37, 40, 47),
        Border = Color3.fromRGB(61, 61, 75),
        TopFrame = Color3.fromRGB(37, 40, 47),
        TabContent = Color3.fromRGB(32, 35, 41),
        Sidebar = Color3.fromRGB(37, 40, 47),
    },
    
    -- Text Colors
    Text = {
        Primary = Color3.fromRGB(197, 204, 219),
        Secondary = Color3.fromRGB(150, 155, 165),
        Disabled = Color3.fromRGB(75, 77, 83),
        Placeholder = Color3.fromRGB(140, 140, 140),
    },
    
    -- Text Transparency
    Transparency = {
        Primary = 0,
        Secondary = 0.3,  -- Added transparency for secondary text
        Disabled = 0.4,
        Placeholder = 0.5, -- Added transparency for placeholder
    },
    
    -- Element Colors
    Element = {
        Background = Color3.fromRGB(43, 46, 53),
        BackgroundDisabled = Color3.fromRGB(32, 35, 40),
        Border = Color3.fromRGB(61, 61, 75),
        BorderDisabled = Color3.fromRGB(47, 47, 58),
        -- Blue accent tetap sama untuk consistency
        Accent = Color3.fromRGB(10, 135, 213),
    },
    
    -- Toggle Colors
    Toggle = {
        Off = Color3.fromRGB(53, 56, 62),
        On = Color3.fromRGB(192, 209, 199),
        Ball = Color3.fromRGB(255, 255, 255),
    },
    
    -- Notification Colors
    Notification = {
        Background = Color3.fromRGB(37, 40, 47),
        Border = Color3.fromRGB(61, 61, 75),
    }
}

-- Light Theme Example
local LightTheme = {
    Window = {
        Background = Color3.fromRGB(248, 249, 250),
        Border = Color3.fromRGB(200, 205, 210),
        TopFrame = Color3.fromRGB(248, 249, 250),
        TabContent = Color3.fromRGB(255, 255, 255),
        Sidebar = Color3.fromRGB(245, 246, 247),
    },
    
    Text = {
        Primary = Color3.fromRGB(33, 37, 41),
        Secondary = Color3.fromRGB(108, 117, 125),
        Disabled = Color3.fromRGB(173, 181, 189),
        Placeholder = Color3.fromRGB(173, 181, 189),
    },
    
    Transparency = {
        Primary = 0,
        Secondary = 0.25,
        Disabled = 0.4,
        Placeholder = 0.5,
    },
    
    Element = {
        Background = Color3.fromRGB(255, 255, 255),
        BackgroundDisabled = Color3.fromRGB(233, 236, 239),
        Border = Color3.fromRGB(206, 212, 218),
        BorderDisabled = Color3.fromRGB(233, 236, 239),
        -- Accent sama biar consistency dengan original
        Accent = Color3.fromRGB(10, 135, 213),
    },
    
    Toggle = {
        Off = Color3.fromRGB(206, 212, 218),
        On = Color3.fromRGB(40, 167, 69),
        Ball = Color3.fromRGB(255, 255, 255),
    },
    
    Notification = {
        Background = Color3.fromRGB(255, 255, 255),
        Border = Color3.fromRGB(206, 212, 218),
    }
}


local CurrentTheme = DefaultTheme
local ThemeCallbacks = {}