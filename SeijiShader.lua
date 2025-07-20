--[[
    Seiji's Imagination - Realistic Shader Presets
    Author: Markjssj
    Features: Realistic Bloom, Color Correction, Skyboxes, Floating UI, Smooth Transitions
--]]

-- Services
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Clear old UI and effects
if CoreGui:FindFirstChild("SeijiShaderUI") then
    CoreGui.SeijiShaderUI:Destroy()
end
for _, effect in pairs(Lighting:GetChildren()) do
    if effect:IsA("BloomEffect") or effect:IsA("ColorCorrectionEffect") or effect:IsA("SunRaysEffect") or effect:IsA("Sky") then
        effect:Destroy()
    end
end

-- == EFFECT CREATOR ==
local function CreateEffects(preset)
    local bloom = Instance.new("BloomEffect")
    bloom.Intensity = preset.BloomIntensity
    bloom.Size = preset.BloomSize
    bloom.Threshold = preset.BloomThreshold
    bloom.Parent = Lighting

    local color = Instance.new("ColorCorrectionEffect")
    color.Saturation = preset.Saturation
    color.Contrast = preset.Contrast
    color.TintColor = preset.TintColor
    color.Parent = Lighting

    local rays = Instance.new("SunRaysEffect")
    rays.Intensity = preset.SunRays
    rays.Parent = Lighting

    local sky = Instance.new("Sky")
    sky.SkyboxBk = preset.SkyBk
    sky.SkyboxDn = preset.SkyDn
    sky.SkyboxFt = preset.SkyFt
    sky.SkyboxLf = preset.SkyLf
    sky.SkyboxRt = preset.SkyRt
    sky.SkyboxUp = preset.SkyUp
    sky.Parent = Lighting
end

-- == PRESETS ==
local Presets = {
    Default = {
        Brightness = 2,
        FogEnd = 1000,
        ClockTime = 14,
        FogColor = Color3.fromRGB(200, 200, 200),
        BloomIntensity = 0.1,
        BloomSize = 50,
        BloomThreshold = 0,
        Saturation = 0,
        Contrast = 0,
        TintColor = Color3.fromRGB(255, 255, 255),
        SunRays = 0.05,
        SkyBk = "rbxassetid://7018684000",
        SkyDn = "rbxassetid://7018684000",
        SkyFt = "rbxassetid://7018684000",
        SkyLf = "rbxassetid://7018684000",
        SkyRt = "rbxassetid://7018684000",
        SkyUp = "rbxassetid://7018684000"
    },
    Day = {
        Brightness = 2.5,
        FogEnd = 1100,
        ClockTime = 12,
        FogColor = Color3.fromRGB(220, 220, 230),
        BloomIntensity = 0.15,
        BloomSize = 60,
        BloomThreshold = 0.1,
        Saturation = 0.05,
        Contrast = 0.1,
        TintColor = Color3.fromRGB(255, 255, 255),
        SunRays = 0.08,
        SkyBk = "rbxassetid://169210090",
        SkyDn = "rbxassetid://169210108",
        SkyFt = "rbxassetid://169210121",
        SkyLf = "rbxassetid://169210133",
        SkyRt = "rbxassetid://169210143",
        SkyUp = "rbxassetid://169210149"
    },
    Sunset = {
        Brightness = 2.3,
        FogEnd = 900,
        ClockTime = 18.5,
        FogColor = Color3.fromRGB(255, 180, 120),
        BloomIntensity = 0.2,
        BloomSize = 70,
        BloomThreshold = 0.2,
        Saturation = 0.05,
        Contrast = 0.1,
        TintColor = Color3.fromRGB(255, 200, 180),
        SunRays = 0.15,
        SkyBk = "rbxassetid://323494035",
        SkyDn = "rbxassetid://323494368",
        SkyFt = "rbxassetid://323494130",
        SkyLf = "rbxassetid://323494252",
        SkyRt = "rbxassetid://323494067",
        SkyUp = "rbxassetid://323493360"
    },
    Night = {
        Brightness = 1.6,
        FogEnd = 800,
        ClockTime = 20,
        FogColor = Color3.fromRGB(60, 60, 100),
        BloomIntensity = 0.12,
        BloomSize = 40,
        BloomThreshold = 0.1,
        Saturation = -0.1,
        Contrast = 0.05,
        TintColor = Color3.fromRGB(200, 200, 255),
        SunRays = 0.04,
        SkyBk = "rbxassetid://7018689913",
        SkyDn = "rbxassetid://7018690156",
        SkyFt = "rbxassetid://7018690433",
        SkyLf = "rbxassetid://7018690653",
        SkyRt = "rbxassetid://7018690891",
        SkyUp = "rbxassetid://7018691152"
    },
    Pink = {
        Brightness = 2.2,
        FogEnd = 950,
        ClockTime = 16,
        FogColor = Color3.fromRGB(255, 180, 200),
        BloomIntensity = 0.18,
        BloomSize = 60,
        BloomThreshold = 0.15,
        Saturation = 0.1,
        Contrast = 0.05,
        TintColor = Color3.fromRGB(255, 210, 220),
        SunRays = 0.1,
        SkyBk = "rbxassetid://14245141994",
        SkyDn = "rbxassetid://14245141994",
        SkyFt = "rbxassetid://14245141994",
        SkyLf = "rbxassetid://14245141994",
        SkyRt = "rbxassetid://14245141994",
        SkyUp = "rbxassetid://14245141994"
    }
}

-- == APPLY PRESET ==
local CurrentPreset = "Default"
local function ApplyPreset(name)
    -- Remove old effects
    for _, effect in pairs(Lighting:GetChildren()) do
        if effect:IsA("BloomEffect") or effect:IsA("ColorCorrectionEffect") or effect:IsA("SunRaysEffect") or effect:IsA("Sky") then
            effect:Destroy()
        end
    end

    local preset = Presets[name]
    if not preset then return end

    TweenService:Create(Lighting, TweenInfo.new(0.8, Enum.EasingStyle.Quad), {
        Brightness = preset.Brightness,
        FogEnd = preset.FogEnd,
        FogColor = preset.FogColor,
        ClockTime = preset.ClockTime
    }):Play()

    CreateEffects(preset)
    CurrentPreset = name
end
ApplyPreset("Default")

-- == UI CREATION ==
local UI = Instance.new("ScreenGui")
UI.Name = "SeijiShaderUI"
UI.Parent = CoreGui
UI.ResetOnSpawn = false

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 250, 0, 220)
Frame.Position = UDim2.new(0.5, -125, 0.5, -110)
Frame.BackgroundColor3 = Color3.fromRGB(25, 0, 40)
Frame.BackgroundTransparency = 0.2
Frame.BorderSizePixel = 0
Frame.Parent = UI
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)

local Handle = Instance.new("Frame")
Handle.Size = UDim2.new(1, 0, 0, 25)
Handle.BackgroundColor3 = Color3.fromRGB(60, 0, 100)
Handle.Parent = Frame
Instance.new("UICorner", Handle).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel")
Title.Text = "Seiji's Imagination"
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 180, 255)
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true
Title.Parent = Handle

-- Cycle Button
local CycleBtn = Instance.new("TextButton")
CycleBtn.Size = UDim2.new(0.9, 0, 0, 30)
CycleBtn.Position = UDim2.new(0.05, 0, 0, 40)
CycleBtn.Text = "Current: Default"
CycleBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 120)
CycleBtn.TextColor3 = Color3.new(1,1,1)
CycleBtn.Font = Enum.Font.Gotham
CycleBtn.TextScaled = true
CycleBtn.Parent = Frame
Instance.new("UICorner", CycleBtn).CornerRadius = UDim.new(0, 6)

-- Cycle through presets
CycleBtn.MouseButton1Click:Connect(function()
    local order = {"Default","Day","Sunset","Night","Pink"}
    local nextIndex = (table.find(order, CurrentPreset) % #order) + 1
    ApplyPreset(order[nextIndex])
    CycleBtn.Text = "Current: " .. order[nextIndex]
end)

-- Dragging UI
local dragging, dragStart, startPos
Handle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        Frame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)
