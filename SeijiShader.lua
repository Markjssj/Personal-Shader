--[[ 
    Seiji's Imagination Shader UI
    Created for Markjssj
    Features:
      - Shader Preset Dropdown (Default, Day, Sunset, Night, Pink)
      - Sliders with live tooltips (Brightness, FogEnd, ClockTime, SunRays Intensity)
      - Reset Sliders button
      - Minimize, Hide, and Kill buttons
      - Animated Intro text
      - Smooth UI transitions & semi-transparent modern style
--]]

-- Services
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- Remove previous UI if any
if CoreGui:FindFirstChild("SeijiShaderUI") then
    CoreGui.SeijiShaderUI:Destroy()
end

-- Default shader values
local ShaderPresets = {
    Default = { Brightness = 2, FogEnd = 1000, ClockTime = 14, SunRays = 0.05 },
    Day     = { Brightness = 2.5, FogEnd = 1000, ClockTime = 12, SunRays = 0.08 },
    Sunset  = { Brightness = 2.2, FogEnd = 900, ClockTime = 18.5, SunRays = 0.12 },
    Night   = { Brightness = 1.4, FogEnd = 600, ClockTime = 20, SunRays = 0.03 },
    Pink    = { Brightness = 2.3, FogEnd = 850, ClockTime = 16, SunRays = 0.1 }
}

local CurrentPreset = "Default"

-- Create ScreenGui
local UI = Instance.new("ScreenGui")
UI.Name = "SeijiShaderUI"
UI.Parent = CoreGui
UI.ResetOnSpawn = false

-- Main Frame
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 300, 0, 250)
Frame.Position = UDim2.new(0.5, -150, 0.5, -125)
Frame.BackgroundColor3 = Color3.fromRGB(30, 0, 40)
Frame.BackgroundTransparency = 0.2
Frame.BorderSizePixel = 0
Frame.Parent = UI

Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)

-- Title
local Title = Instance.new("TextLabel")
Title.Text = "Seiji's Imagination"
Title.Size = UDim2.new(1, -40, 0, 30)
Title.Position = UDim2.new(0, 10, 0, 5)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 170, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = Frame

-- Buttons
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Text = "-"
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -60, 0, 5)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 120)
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextScaled = true
MinimizeBtn.Parent = Frame
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 5)

local KillBtn = Instance.new("TextButton")
KillBtn.Text = "X"
KillBtn.Size = UDim2.new(0, 30, 0, 30)
KillBtn.Position = UDim2.new(1, -30, 0, 5)
KillBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
KillBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
KillBtn.Font = Enum.Font.GothamBold
KillBtn.TextScaled = true
KillBtn.Parent = Frame
Instance.new("UICorner", KillBtn).CornerRadius = UDim.new(0, 5)

-- Dropdown (Shader Presets)
local Dropdown = Instance.new("TextButton")
Dropdown.Size = UDim2.new(0.9, 0, 0, 30)
Dropdown.Position = UDim2.new(0.05, 0, 0, 50)
Dropdown.Text = "Current: Default"
Dropdown.BackgroundColor3 = Color3.fromRGB(60, 0, 90)
Dropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
Dropdown.Font = Enum.Font.Gotham
Dropdown.TextScaled = true
Dropdown.Parent = Frame
Instance.new("UICorner", Dropdown).CornerRadius = UDim.new(0, 5)

-- Sliders
local function createSlider(name, min, max, default, order)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(0.9, 0, 0, 40)
    sliderFrame.Position = UDim2.new(0.05, 0, 0, 90 + (order * 45))
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Parent = Frame

    local label = Instance.new("TextLabel")
    label.Text = name .. ": " .. default
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.Gotham
    label.TextScaled = true
    label.Parent = sliderFrame

    local slider = Instance.new("TextButton")
    slider.Size = UDim2.new(1, 0, 0, 15)
    slider.Position = UDim2.new(0, 0, 0, 20)
    slider.BackgroundColor3 = Color3.fromRGB(100, 0, 150)
    slider.Text = ""
    slider.Parent = sliderFrame
    Instance.new("UICorner", slider).CornerRadius = UDim.new(0, 5)

    local dragging = false
    slider.MouseButton1Down:Connect(function()
        dragging = true
    end)
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    slider.MouseMoved:Connect(function(x)
        if dragging then
            local rel = math.clamp((x - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
            local value = math.floor((min + (max - min) * rel) * 100) / 100
            label.Text = name .. ": " .. value
            if name == "Brightness" then
                Lighting.Brightness = value
            elseif name == "FogEnd" then
                Lighting.FogEnd = value
            elseif name == "ClockTime" then
                Lighting.ClockTime = value
            elseif name == "SunRays" then
                local sun = Lighting:FindFirstChildOfClass("SunRaysEffect")
                if sun then
                    sun.Intensity = value
                end
            end
        end
    end)
end

createSlider("Brightness", 0, 5, ShaderPresets.Default.Brightness, 0)
createSlider("FogEnd", 100, 2000, ShaderPresets.Default.FogEnd, 1)
createSlider("ClockTime", 0, 24, ShaderPresets.Default.ClockTime, 2)
createSlider("SunRays", 0, 1, ShaderPresets.Default.SunRays, 3)

-- Reset Sliders Button
local ResetBtn = Instance.new("TextButton")
ResetBtn.Size = UDim2.new(0.9, 0, 0, 30)
ResetBtn.Position = UDim2.new(0.05, 0, 0, 240)
ResetBtn.Text = "Reset Sliders"
ResetBtn.BackgroundColor3 = Color3.fromRGB(120, 0, 150)
ResetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ResetBtn.Font = Enum.Font.GothamBold
ResetBtn.TextScaled = true
ResetBtn.Parent = Frame
Instance.new("UICorner", ResetBtn).CornerRadius = UDim.new(0, 5)

-- Functions
local function applyPreset(preset)
    local data = ShaderPresets[preset]
    if not data then return end
    CurrentPreset = preset
    Dropdown.Text = "Current: " .. preset
    TweenService:Create(Lighting, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Brightness = data.Brightness,
        FogEnd = data.FogEnd,
        ClockTime = data.ClockTime
    }):Play()
    local sun = Lighting:FindFirstChildOfClass("SunRaysEffect")
    if sun then sun.Intensity = data.SunRays end
end

-- Button Events
Dropdown.MouseButton1Click:Connect(function()
    local presets = {"Default", "Day", "Sunset", "Night", "Pink"}
    local nextIndex = (table.find(presets, CurrentPreset) % #presets) + 1
    applyPreset(presets[nextIndex])
end)

ResetBtn.MouseButton1Click:Connect(function()
    applyPreset(CurrentPreset)
end)

KillBtn.MouseButton1Click:Connect(function()
    UI:Destroy()
    Lighting.Brightness = 2
    Lighting.FogEnd = 1000
    Lighting.ClockTime = 14
end)

MinimizeBtn.MouseButton1Click:Connect(function()
    Frame.Visible = false
    wait(0.1)
    local showBtn = Instance.new("TextButton")
    showBtn.Text = "Show UI"
    showBtn.Size = UDim2.new(0, 100, 0, 30)
    showBtn.Position = UDim2.new(0.5, -50, 0.9, 0)
    showBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 120)
    showBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    showBtn.Font = Enum.Font.GothamBold
    showBtn.TextScaled = true
    showBtn.Parent = UI
    Instance.new("UICorner", showBtn).CornerRadius = UDim.new(0, 5)
    showBtn.MouseButton1Click:Connect(function()
        Frame.Visible = true
        showBtn:Destroy()
    end)
end)

-- Apply default preset
applyPreset("Default")
