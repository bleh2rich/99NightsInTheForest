-- I went mentally insane spending 3 hours making an insanely long complicated system and luarmor started shitting itself so I just wrote this real quick and made some quick ass GUI in studios for now + server authority is releasing soon so who cares at this point
if workspace:FindFirstChild("Teleporter3") then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Script Blocked",
        Text = "Please join a game before executing this script.",
        Duration = 5,
        Button1 = "OK"
    })
    
    return
end
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 350, 0, 150)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -75)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BorderSizePixel = 0

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 8)
uiCorner.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Parent = mainFrame
titleLabel.Size = UDim2.new(1, -20, 0, 50)
titleLabel.Position = UDim2.new(0.5, -165, 0, 10)
titleLabel.BackgroundTransparency = 1
titleLabel.Font = Enum.Font.SourceSans
titleLabel.Text = "Both are free, premiums key system is longer, but more features! VELOCITY RECOMMENDED FOR PC"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.TextWrapped = true

local regularButton = Instance.new("TextButton")
regularButton.Parent = mainFrame
regularButton.Size = UDim2.new(0, 150, 0, 50)
regularButton.Position = UDim2.new(0.5, -165, 1, -60)
regularButton.BackgroundColor3 = Color3.fromRGB(80, 120, 180)
regularButton.Font = Enum.Font.SourceSansBold
regularButton.Text = "Regular"
regularButton.TextColor3 = Color3.fromRGB(255, 255, 255)
regularButton.TextSize = 20

local regularCorner = Instance.new("UICorner")
regularCorner.CornerRadius = UDim.new(0, 6)
regularCorner.Parent = regularButton

local premiumButton = Instance.new("TextButton")
premiumButton.Parent = mainFrame
premiumButton.Size = UDim2.new(0, 150, 0, 50)
premiumButton.Position = UDim2.new(0.5, 5, 1, -60)
premiumButton.BackgroundColor3 = Color3.fromRGB(230, 180, 80)
premiumButton.Font = Enum.Font.SourceSansBold
premiumButton.Text = "Premium"
premiumButton.TextColor3 = Color3.fromRGB(255, 255, 255)
premiumButton.TextSize = 20

local premiumCorner = Instance.new("UICorner")
premiumCorner.CornerRadius = UDim.new(0, 6)
premiumCorner.Parent = premiumButton

regularButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
    task.spawn(function()
        loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/0c76b329bcae8b4134c5cbe433082e8a.lua"))()
    end)
end)

premiumButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
    task.spawn(function()
        loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/ab2b686887cbae9b3cd20705d42d646c.lua"))()
    end)
end)
