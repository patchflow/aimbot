-- Charger la bibliothèque UI
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/UI-Library/main/library.lua"))()

-- Créer la fenêtre principale du menu
local window = library:CreateWindow("Arsenal Cheat")

-- Créer les différents onglets (tabs)
local aimbotTab = window:CreateFolder("Aimbot")
local espTab = window:CreateFolder("ESP")
local miscTab = window:CreateFolder("Misc")

-- Variables pour chaque fonctionnalité
local aimbotEnabled = false
local espEnabled = false
local spinbotEnabled = false
local speedHackEnabled = false
local noRecoilEnabled = false
local hitboxExpanderEnabled = false

-- Aimbot
aimbotTab:Toggle("Enable Aimbot", function(value)
    aimbotEnabled = value
    if aimbotEnabled then
        -- Code pour activer l'Aimbot
    else
        -- Code pour désactiver l'Aimbot
    end
end)

aimbotTab:Slider("Aimbot FOV", {min = 10, max = 500, precise = true}, function(value)
    local aimbotFOV = value
    -- Code pour ajuster le FOV du Aimbot
end)

-- ESP
espTab:Toggle("Enable ESP", function(value)
    espEnabled = value
    if espEnabled then
        -- Code pour activer l'ESP
        loadstring(game:HttpGet("https://kiriot22.com/releases/ESP.lua"))()  -- Exemple de lien pour ESP
    else
        -- Code pour désactiver l'ESP
    end
end)

espTab:Toggle("Skeleton ESP", function(value)
    if value then
        -- Code pour activer Skeleton ESP
        print("Skeleton ESP activé")
    else
        -- Code pour désactiver Skeleton ESP
        print("Skeleton ESP désactivé")
    end
end)

-- Spinbot
miscTab:Toggle("Enable Spinbot", function(value)
    spinbotEnabled = value
    if spinbotEnabled then
        -- Code pour activer le Spinbot
        while spinbotEnabled do
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(360), 0)
            wait(0.1)
        end
    end
end)

-- Speed Hack
miscTab:Toggle("Speed Hack", function(value)
    speedHackEnabled = value
    if speedHackEnabled then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 50
    else
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end)

-- No Recoil
miscTab:Toggle("No Recoil", function(value)
    noRecoilEnabled = value
    if noRecoilEnabled then
        game:GetService("RunService").RenderStepped:Connect(function()
            for _, tool in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                if tool:IsA("Tool") then
                    tool.Recoil = 0
                end
            end
        end)
    end
end)

-- Expand Hitbox
miscTab:Toggle("Expand Hitbox", function(value)
    hitboxExpanderEnabled = value
    if hitboxExpanderEnabled then
        for _, player in pairs(game:GetService("Players"):GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player.Character then
                player.Character.Head.Size = Vector3.new(5, 5, 5)
            end
        end
    else
        for _, player in pairs(game:GetService("Players"):GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player.Character then
                player.Character.Head.Size = Vector3.new(1, 1, 1)
            end
        end
    end
end)

-- Initialiser la bibliothèque et afficher le GUI
library:Init()  -- Cette ligne est cruciale
