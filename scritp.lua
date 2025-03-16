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
local silentAimEnabled = false
local espEnabled = false
local spinbotEnabled = false
local speedHackEnabled = false
local noRecoilEnabled = false
local hitboxExpanderEnabled = false
local aimbotFOV = 90  -- Valeur initiale pour le FOV de l'Aimbot

-- Aimbot
aimbotTab:Toggle("Enable Aimbot", function(value)
    aimbotEnabled = value
    if aimbotEnabled then
        print("Aimbot activé")
        -- Code pour activer l'Aimbot
    else
        print("Aimbot désactivé")
        -- Code pour désactiver l'Aimbot
    end
end)

aimbotTab:Slider("Aimbot FOV", {min = 10, max = 500, precise = true}, function(value)
    aimbotFOV = value
    print("FOV Aimbot réglé sur " .. value)
    -- Code pour ajuster le FOV du Aimbot
end)

-- Silent Aim
aimbotTab:Toggle("Enable Silent Aim", function(value)
    silentAimEnabled = value
    if silentAimEnabled then
        print("Silent Aim activé")
        -- Code pour activer le Silent Aim
    else
        print("Silent Aim désactivé")
        -- Code pour désactiver le Silent Aim
    end
end)

-- ESP
espTab:Toggle("Enable ESP", function(value)
    espEnabled = value
    if espEnabled then
        print("ESP activé")
        -- Code pour activer l'ESP
        loadstring(game:HttpGet("https://kiriot22.com/releases/ESP.lua"))()  -- Exemple de lien pour ESP
    else
        print("ESP désactivé")
        -- Code pour désactiver l'ESP
    end
end)

espTab:Toggle("Skeleton ESP", function(value)
    if value then
        print("Skeleton ESP activé")
        -- Code pour activer Skeleton ESP
    else
        print("Skeleton ESP désactivé")
        -- Code pour désactiver Skeleton ESP
    end
end)

-- Spinbot
miscTab:Toggle("Enable Spinbot", function(value)
    spinbotEnabled = value
    if spinbotEnabled then
        print("Spinbot activé")
        -- Code pour activer le Spinbot
        while spinbotEnabled do
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(360), 0)
            wait(0.1)
        end
    else
        print("Spinbot désactivé")
    end
end)

-- Speed Hack
miscTab:Toggle("Speed Hack", function(value)
    speedHackEnabled = value
    if speedHackEnabled then
        print("Speed Hack activé")
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 50
    else
        print("Speed Hack désactivé")
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end)

-- No Recoil
miscTab:Toggle("No Recoil", function(value)
    noRecoilEnabled = value
    if noRecoilEnabled then
        print("No Recoil activé")
        game:GetService("RunService").RenderStepped:Connect(function()
            for _, tool in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                if tool:IsA("Tool") then
                    tool.Recoil = 0
                end
            end
        end)
    else
        print("No Recoil désactivé")
    end
end)

-- Expand Hitbox
miscTab:Toggle("Expand Hitbox", function(value)
    hitboxExpanderEnabled = value
    if hitboxExpanderEnabled then
        print("Expansion de hitbox activée")
        for _, player in pairs(game:GetService("Players"):GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player.Character then
                player.Character.Head.Size = Vector3.new(5, 5, 5)
            end
        end
    else
        print("Expansion de hitbox désactivée")
        for _, player in pairs(game:GetService("Players"):GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player.Character then
                player.Character.Head.Size = Vector3.new(1, 1, 1)
            end
        end
    end
end)

-- Silent Aim Fonctionnalité
if silentAimEnabled then
    game:GetService("RunService").Heartbeat:Connect(function()
        if aimbotEnabled and silentAimEnabled then
            local player = game.Players.LocalPlayer
            local character = player.Character
            local mouse = player:GetMouse()

            -- Calculer la position de la cible
            local target = nil
            local closestDist = math.huge
            for _, v in pairs(game.Players:GetPlayers()) do
                if v.Character and v.Character:FindFirstChild("Head") and v ~= player then
                    local dist = (v.Character.Head.Position - character.Head.Position).Magnitude
                    if dist < aimbotFOV and dist < closestDist then
                        target = v
                        closestDist = dist
                    end
                end
            end

            -- Si une cible est trouvée, diriger le tir
            if target then
                local targetPosition = target.Character.Head.Position
                local direction = (targetPosition - character.HumanoidRootPart.Position).unit
                game:GetService("ReplicatedStorage").FireServer(game:GetService("Players").LocalPlayer.Character:WaitForChild("Gun"), direction)
            end
        end
    end)
end

-- Initialiser la bibliothèque
library:Init()
