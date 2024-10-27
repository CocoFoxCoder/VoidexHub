-- Load Orion library
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

-- Create Main Window
local Window = OrionLib:MakeWindow({
    Name = "Voidex Hub Script Hub",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "VoidexHubConfigs",
    IntroEnabled = true,
    IntroText = "Welcome to Voidex Hub",
    Icon = "rbxassetid://76111062199140"
})

-- Toggle Visibility with Left Shift
local UserInputService = game:GetService("UserInputService")
local isVisible = true
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if input.KeyCode == Enum.KeyCode.LeftShift and not gameProcessedEvent then
        isVisible = not isVisible
        if isVisible then
            Window:Show()
        else
            Window:Hide()
        end
    end
end)

-- Main Tab with Core Features
local MainTab = Window:MakeTab({
    Name = "Core Features",
    Icon = "rbxassetid://6034996695",
    PremiumOnly = false
})

local CoreSection = MainTab:AddSection({
    Name = "Core Scripts"
})

-- Fast Punch Feature
CoreSection:AddButton({
    Name = "Fast Punch",
    Callback = function()
        local punchTool = game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Punch")
        if punchTool then
            punchTool.attackTime = 0
        end
    end
})

-- Reset Avatar Feature
CoreSection:AddButton({
    Name = "Reset Avatar",
    Callback = function()
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.Health = 0
        end
    end
})

-- Extra Features Tab
local ExtraTab = Window:MakeTab({
    Name = "Extras",
    Icon = "rbxassetid://6034996695",
    PremiumOnly = false
})

local ExtraSection = ExtraTab:AddSection({
    Name = "Extra Features"
})

-- Rejoin Button
ExtraSection:AddButton({
    Name = "Rejoin Game",
    Callback = function()
        local placeId = 3623096087
        game:GetService("TeleportService"):Teleport(placeId, game.Players.LocalPlayer)
    end
})

-- Speed Setting Text Box
ExtraSection:AddTextbox({
    Name = "Set Speed",
    Default = "16",
    TextDisappear = true,
    Callback = function(value)
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = tonumber(value) or 16
        end
    end
})

-- Autorebirth Functionality
local rebirthStopValues = {580, 980, 1480, 2780, 4480, 5480, 6580, 7780, 18980}
local targetRebirthValue = 580 -- Default target

-- Dropdown for selecting stop rebirth value
ExtraSection:AddDropdown({
    Name = "Select Rebirth Stop Value",
    Default = tostring(targetRebirthValue),
    Options = {"580", "980", "1480", "2780", "4480", "5480", "6580", "7780", "18980"},
    Callback = function(selected)
        targetRebirthValue = tonumber(selected)
    end
})

local rebirthActive = false

ExtraSection:AddToggle({
    Name = "Auto Rebirth",
    Default = false,
    Callback = function(state)
        rebirthActive = state
        while rebirthActive do
            local player = game.Players.LocalPlayer
            local currentRebirths = player.leaderstats.Rebirths.Value -- Adjust to your rebirth stat location

            if currentRebirths >= targetRebirthValue then
                rebirthActive = false
                print("Rebirth stopped at value:", currentRebirths)
            else
                game.ReplicatedStorage.rEvents.rebirthRemote:InvokeServer("rebirthRequest")
            end

            wait(1) -- Adjust wait time if necessary
        end
    end
})

-- Initialize Orion library
OrionLib:Init()
