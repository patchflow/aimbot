-- CONFIGURATION
local AimbotKey = Enum.KeyCode.E -- Touche d'activation
local AimbotEnabled = false

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- TOGGLE AVEC E
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == AimbotKey then
        AimbotEnabled = not AimbotEnabled
        print("[AIMBOT] " .. (AimbotEnabled and "✅ Activé" or "❌ Désactivé"))
    end
end)

-- FONCTION POUR TROUVER LA CIBLE LA PLUS PROCHE DU CURSEUR
local function getClosestTarget()
    local mouseLocation = UserInputService:GetMouseLocation()
    local closestPlayer = nil
    local closestDistance = math.huge

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local head = player.Character.Head
            local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)

            if onScreen then
                local distance = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(mouseLocation.X, mouseLocation.Y)).Magnitude
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")

                if humanoid and humanoid.Health > 0 and distance < closestDistance then
                    closestDistance = distance
                    closestPlayer = player
                end
            end
        end
    end

    return closestPlayer
end

-- EXECUTION DE L'AIMBOT
RunService.RenderStepped:Connect(function()
    if AimbotEnabled then
        local target = getClosestTarget()

        if target and target.Character and target.Character:FindFirstChild("Head") then
            local head = target.Character.Head.Position
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, head)
        end
    end
end)

print("[✔] Script Aimbot prêt. Appuie sur 'E' pour activer/désactiver.")
