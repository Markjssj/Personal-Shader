--[[
    Seiji's Imagination Shader (Realistic Final Version)
    Author: Markjssj
    Features: Realistic lighting stack (Bloom, SunRays, ColorCorrection, Sky),
              Smooth transitions, Adjustable sliders, Hide & Kill,
              Preview cinematic cycle.
--]]

-- Services
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Remove old UI and shaders
if CoreGui:FindFirstChild("SeijiShaderUI") then CoreGui.SeijiShaderUI:Destroy() end
for _, v in pairs(Lighting:GetChildren()) do
    if v:IsA("BloomEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("SunRaysEffect") or v:IsA("Sky") then
        v:Destroy()
    end
end

-- Lighting Reset
local function ResetLighting()
    Lighting.Brightness = 2
    Lighting.ClockTime = 14
    Lighting.FogEnd = 1000
    Lighting.FogColor = Color3.fromRGB(200, 200, 200)
    for _, v in pairs(Lighting:GetChildren()) do
        if v:IsA("BloomEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("SunRaysEffect") or v:IsA("Sky") then
            v:Destroy()
        end
    end
end

-- Intro
local function PlayIntro()
    local introGui = Instance.new("ScreenGui")
    introGui.Name = "SeijiIntro"
    introGui.Parent = CoreGui

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0.3, 0)
    label.Position = UDim2.new(0, 0, 0.35, 0)
    label.BackgroundTransparency = 1
    label.Text = "Seiji's Imagination"
    label.Font = Enum.Font.GothamBold
    label.TextColor3 = Color3.fromRGB(255, 180, 255)
    label.TextStrokeTransparency = 0
    label.TextScaled = true
    label.Parent = introGui

    local glowTween = TweenService:Create(label, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, -1, true), {TextStrokeTransparency = 0.5})
    glowTween:Play()

    task.wait(3)
    introGui:Destroy()
end
PlayIntro()

-- Create Shader Effects
local Bloom = Instance.new("BloomEffect", Lighting)
Bloom.Intensity = 0.4
Bloom.Size = 60
Bloom.Threshold = 0.2

local SunRays = Instance.new("SunRaysEffect", Lighting)
SunRays.Intensity = 0.05
SunRays.Spread = 0.3

local ColorCorrection = Instance.new("ColorCorrectionEffect", Lighting)
ColorCorrection.Saturation = 0
ColorCorrection.Contrast = 0.05

local Sky = Instance.new("Sky", Lighting)
Sky.SkyboxUp = "rbxassetid://196263782"
Sky.SkyboxDn = "rbxassetid://196263643"
Sky.SkyboxLf = "rbxassetid://196263721"
Sky.SkyboxRt = "rbxassetid://196263721"
Sky.SkyboxFt = "rbxassetid://196263721"
Sky.SkyboxBk = "rbxassetid://196263721"

-- Presets
local Presets = {
    Default = {Brightness=2, ClockTime=14, FogEnd=1000, FogColor=Color3.fromRGB(200,200,200), Sun=Color3.fromRGB(255,255,255)},
    Day = {Brightness=2.5, ClockTime=12, FogEnd=1100, FogColor=Color3.fromRGB(220,220,230), Sun=Color3.fromRGB(255,255,220)},
    Sunset = {Brightness=2.3, ClockTime=18.5, FogEnd=900, FogColor=Color3.fromRGB(255,180,120), Sun=Color3.fromRGB(255,200,140)},
    Night = {Brightness=1.6, ClockTime=20, FogEnd=800, FogColor=Color3.fromRGB(60,60,100), Sun=Color3.fromRGB(180,180,255)},
    Pink = {Brightness=2.2, ClockTime=16, FogEnd=950, FogColor=Color3.fromRGB(255,180,200), Sun=Color3.fromRGB(255,180,200)}
}
local CurrentPreset = "Default"

local function ApplyPreset(name)
    local preset = Presets[name]
    if not preset then return end
    TweenService:Create(Lighting, TweenInfo.new(1, Enum.EasingStyle.Quad), {
        Brightness = preset.Brightness,
        ClockTime = preset.ClockTime,
        FogEnd = preset.FogEnd,
        FogColor = preset.FogColor
    }):Play()
    SunRays.Intensity = 0.05
    SunRays.Color = preset.Sun
    CurrentPreset = name
end
ApplyPreset("Default")

-- UI
local UI = Instance.new("ScreenGui")
UI.Name = "SeijiShaderUI"
UI.Parent = CoreGui
UI.ResetOnSpawn = false

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 310, 0, 270)
Frame.Position = UDim2.new(0.5, -155, 0.5, -135)
Frame.BackgroundColor3 = Color3.fromRGB(25, 0, 40)
Frame.BackgroundTransparency = 0.15
Frame.Parent = UI
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)

local Handle = Instance.new("Frame")
Handle.Size = UDim2.new(1, 0, 0, 25)
Handle.BackgroundColor3 = Color3.fromRGB(60, 0, 100)
Handle.Parent = Frame
Instance.new("UICorner", Handle).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel")
Title.Text = "Seiji's Imagination"
Title.Size = UDim2.new(1, 0, 1, 0)
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

CycleBtn.MouseButton1Click:Connect(function()
    local order = {"Default", "Day", "Sunset", "Night", "Pink"}
    local nextIndex = (table.find(order, CurrentPreset) % #order) + 1
    ApplyPreset(order[nextIndex])
    CycleBtn.Text = "Current: " .. order[nextIndex]
end)

-- Preview Button
local PreviewBtn = Instance.new("TextButton")
PreviewBtn.Size = UDim2.new(0.9, 0, 0, 30)
PreviewBtn.Position = UDim2.new(0.05, 0, 0, 80)
PreviewBtn.Text = "Preview Cinematic"
PreviewBtn.BackgroundColor3 = Color3.fromRGB(100, 0, 160)
PreviewBtn.TextColor3 = Color3.new(1,1,1)
PreviewBtn.Font = Enum.Font.Gotham
PreviewBtn.TextScaled = true
PreviewBtn.Parent = Frame
Instance.new("UICorner", PreviewBtn).CornerRadius = UDim.new(0, 6)

PreviewBtn.MouseButton1Click:Connect(function()
    for _, mode in ipairs({"Day", "Sunset", "Night", "Pink"}) do
        ApplyPreset(mode)
        task.wait(2)
    end
    ApplyPreset("Default")
end)

-- Sliders
local function CreateSlider(name, min, max, default, posY, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(0.9, 0, 0, 40)
    sliderFrame.Position = UDim2.new(0.05, 0, 0, posY)
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Parent = Frame

    local label = Instance.new("TextLabel")
    label.Text = name .. ": " .. default
    label.Size = UDim2.new(1, 0, 0, 20)
    label.TextColor3 = Color3.new(1,1,1)
    label.BackgroundTransparency = 1
    label.TextScaled = true
    label.Parent = sliderFrame

    local slider = Instance.new("TextButton")
    slider.Size = UDim2.new(1, 0, 0, 10)
    slider.Position = UDim2.new(0, 0, 0, 25)
    slider.BackgroundColor3 = Color3.fromRGB(100, 0, 140)
    slider.Text = ""
    slider.AutoButtonColor = false
    slider.Parent = sliderFrame
    Instance.new("UICorner", slider).CornerRadius = UDim.new(0, 4)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 10, 0, 10)
    knob.Position = UDim2.new((default-min)/(max-min), -5, 0, 0)
    knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
    knob.Parent = slider
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1,0)

    local dragging = false
    slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local pos = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
            knob.Position = UDim2.new(pos, -5, 0, 0)
            local value = math.floor(min + (max-min)*pos)
            label.Text = name .. ": " .. value
            TweenService:Create(Lighting, TweenInfo.new(0.2), {[name == "Brightness" and "Brightness" or (name == "ClockTime" and "ClockTime" or "FogEnd")] = value}):Play()
            callback(value)
        end
    end)
end

CreateSlider("Brightness", 1, 5, Lighting.Brightness, 130, function(val)
    Lighting.Brightness = val
end)
CreateSlider("ClockTime", 0, 24, Lighting.ClockTime, 180, function(val)
    Lighting.ClockTime = val
end)
CreateSlider("FogEnd", 100, 2000, Lighting.FogEnd, 230, function(val)
    Lighting.FogEnd = val
end)

-- Kill Button
local KillBtn = Instance.new("TextButton")
KillBtn.Size = UDim2.new(0.9, 0, 0, 30)
KillBtn.Position = UDim2.new(0.05, 0, 1, -40)
KillBtn.Text = "Kill Shader"
KillBtn.BackgroundColor3 = Color3.fromRGB(120, 0, 40)
KillBtn.TextColor3 = Color3.new(1,1,1)
KillBtn.Font = Enum.Font.Gotham
KillBtn.TextScaled = true
KillBtn.Parent = Frame
Instance.new("UICorner", KillBtn).CornerRadius = UDim.new(0, 6)

KillBtn.MouseButton1Click:Connect(function()
    ResetLighting()
    UI:Destroy()
end)

-- Drag UI
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
