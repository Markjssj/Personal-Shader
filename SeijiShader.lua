--[[
    Seiji's Imagination - Final Version (Floating UI + Fixed Shaders)
    Author: Markjssj
--]]

-- Services
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Remove old UI
if CoreGui:FindFirstChild("SeijiShaderUI") then
    CoreGui.SeijiShaderUI:Destroy()
end

-- Shader Presets
local ShaderPresets = {
    Default = { Brightness = 2, FogEnd = 1000, ClockTime = 14, SunRays = 0.05, FogColor = Color3.fromRGB(200,200,200) },
    Day     = { Brightness = 2.5, FogEnd = 1000, ClockTime = 12, SunRays = 0.08, FogColor = Color3.fromRGB(220,220,230) },
    Sunset  = { Brightness = 2.2, FogEnd = 900,  ClockTime = 18.5, SunRays = 0.12, FogColor = Color3.fromRGB(255, 180, 120) },
    Night   = { Brightness = 1.4, FogEnd = 600,  ClockTime = 20, SunRays = 0.03, FogColor = Color3.fromRGB(60,60,100) },
    Pink    = { Brightness = 2.3, FogEnd = 850,  ClockTime = 16, SunRays = 0.1, FogColor = Color3.fromRGB(255,180,200) }
}
local CurrentPreset = "Default"

-- ScreenGui
local UI = Instance.new("ScreenGui")
UI.Name = "SeijiShaderUI"
UI.Parent = CoreGui
UI.ResetOnSpawn = false

-- Main Frame
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 250, 0, 260)
Frame.Position = UDim2.new(0.5, -125, 0.5, -130)
Frame.BackgroundColor3 = Color3.fromRGB(25, 0, 40)
Frame.BackgroundTransparency = 0.2
Frame.BorderSizePixel = 0
Frame.Parent = UI
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)

-- Drag Handle
local Handle = Instance.new("Frame")
Handle.Size = UDim2.new(1, 0, 0, 25)
Handle.BackgroundColor3 = Color3.fromRGB(60, 0, 100)
Handle.Parent = Frame
Instance.new("UICorner", Handle).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel")
Title.Text = "Seiji's Imagination"
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 180, 255)
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true
Title.Parent = Handle

-- Minimize & Kill Buttons
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Text = "-"
MinimizeBtn.Size = UDim2.new(0, 25, 0, 25)
MinimizeBtn.Position = UDim2.new(1, -50, 0, 0)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 120)
MinimizeBtn.TextColor3 = Color3.new(1,1,1)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextScaled = true
MinimizeBtn.Parent = Handle
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 5)

local KillBtn = Instance.new("TextButton")
KillBtn.Text = "X"
KillBtn.Size = UDim2.new(0, 25, 0, 25)
KillBtn.Position = UDim2.new(1, -25, 0, 0)
KillBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
KillBtn.TextColor3 = Color3.new(1,1,1)
KillBtn.Font = Enum.Font.GothamBold
KillBtn.TextScaled = true
KillBtn.Parent = Handle
Instance.new("UICorner", KillBtn).CornerRadius = UDim.new(0, 5)

-- Preset Dropdown
local Dropdown = Instance.new("TextButton")
Dropdown.Size = UDim2.new(0.9, 0, 0, 30)
Dropdown.Position = UDim2.new(0.05, 0, 0, 35)
Dropdown.Text = "Current: Default"
Dropdown.BackgroundColor3 = Color3.fromRGB(70, 0, 100)
Dropdown.TextColor3 = Color3.new(1,1,1)
Dropdown.Font = Enum.Font.Gotham
Dropdown.TextScaled = true
Dropdown.Parent = Frame
Instance.new("UICorner", Dropdown).CornerRadius = UDim.new(0, 6)

-- Slider Creator
local function createSlider(name, min, max, default, order)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(0.9, 0, 0, 40)
    sliderFrame.Position = UDim2.new(0.05, 0, 0, 70 + (order * 45))
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Parent = Frame

    local label = Instance.new("TextLabel")
    label.Text = name .. ": " .. default
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.Gotham
    label.TextScaled = true
    label.Parent = sliderFrame

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, 0, 0, 8)
    bar.Position = UDim2.new(0, 0, 0, 22)
    bar.BackgroundColor3 = Color3.fromRGB(120, 0, 150)
    bar.Parent = sliderFrame
    Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 4)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 12, 0, 16)
    knob.Position = UDim2.new((default - min)/(max-min), -6, 0, -4)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.Parent = bar
    Instance.new("UICorner", knob).CornerRadius = UDim.new(0, 4)

    local dragging = false
    knob.InputBegan:Connect(function(input)
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
            local rel = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
            knob.Position = UDim2.new(rel, -6, 0, -4)
            local val = math.floor((min + (max - min) * rel) * 100) / 100
            label.Text = name .. ": " .. val
            if name == "Brightness" then Lighting.Brightness = val end
            if name == "FogEnd" then Lighting.FogEnd = val end
            if name == "ClockTime" then Lighting.ClockTime = val end
            if name == "SunRays" then
                local sr = Lighting:FindFirstChildOfClass("SunRaysEffect")
                if sr then sr.Intensity = val end
            end
        end
    end)
end

-- Create Sliders
createSlider("Brightness", 0, 5, ShaderPresets.Default.Brightness, 0)
createSlider("FogEnd", 100, 2000, ShaderPresets.Default.FogEnd, 1)
createSlider("ClockTime", 0, 24, ShaderPresets.Default.ClockTime, 2)
createSlider("SunRays", 0, 1, ShaderPresets.Default.SunRays, 3)

-- Apply Preset
local function applyPreset(name)
    local data = ShaderPresets[name]
    if not data then return end
    CurrentPreset = name
    Dropdown.Text = "Current: " .. name
    TweenService:Create(Lighting, TweenInfo.new(0.7, Enum.EasingStyle.Quad), {
        Brightness = data.Brightness,
        FogEnd = data.FogEnd,
        ClockTime = data.ClockTime,
        FogColor = data.FogColor
    }):Play()
    local sr = Lighting:FindFirstChildOfClass("SunRaysEffect") or Instance.new("SunRaysEffect", Lighting)
    sr.Intensity = data.SunRays
end
applyPreset("Default")

-- Dropdown Cycling
Dropdown.MouseButton1Click:Connect(function()
    local order = {"Default","Day","Sunset","Night","Pink"}
    local nextIndex = (table.find(order, CurrentPreset) % #order) + 1
    applyPreset(order[nextIndex])
end)

-- Minimize & Kill
MinimizeBtn.MouseButton1Click:Connect(function()
    Frame.Visible = false
    local ShowBtn = Instance.new("TextButton")
    ShowBtn.Text = "Show UI"
    ShowBtn.Size = UDim2.new(0,100,0,30)
    ShowBtn.Position = UDim2.new(0.5,-50,0.9,0)
    ShowBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 120)
    ShowBtn.TextColor3 = Color3.new(1,1,1)
    ShowBtn.Font = Enum.Font.GothamBold
    ShowBtn.TextScaled = true
    ShowBtn.Parent = UI
    Instance.new("UICorner", ShowBtn).CornerRadius = UDim.new(0,5)
    ShowBtn.MouseButton1Click:Connect(function()
        Frame.Visible = true
        ShowBtn:Destroy()
    end)
end)

KillBtn.MouseButton1Click:Connect(function()
    UI:Destroy()
    Lighting.Brightness = 2
    Lighting.FogEnd = 1000
    Lighting.ClockTime = 14
end)

-- Dragging Logic
local dragging = false
local dragStart, startPos
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
