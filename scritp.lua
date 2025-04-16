-- CONFIGURATION
local AimbotKey = Enum.KeyCode.E
local AimbotEnabled = false
local ESPEnabled = true

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- TOGGLE AIMBOT AVEC E
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == AimbotKey then
        AimbotEnabled = not AimbotEnabled
    end
end)

-- TROUVER CIBLE LA PLUS PROCHE DU CURSEUR
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

-- AIMBOT EXECUTION
RunService.Heartbeat:Connect(function()
    if AimbotEnabled then
        local target = getClosestTarget()

        if target and target.Character and target.Character:FindFirstChild("Head") then
            local head = target.Character.Head.Position
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, head)
        end
    end
end)

-- ========== ESP SYSTEM ========== --
local function createESP(player)
    local box = Drawing.new("Square")
    local nameTag = Drawing.new("Text")

    -- Paramètres visuels
    box.Thickness = 1
    box.Filled = false
    box.Color = Color3.fromRGB(255, 0, 0)
    box.Transparency = 1
    box.Visible = false

    nameTag.Color = Color3.new(1, 1, 1)
    nameTag.Size = 13
    nameTag.Outline = true
    nameTag.Center = true
    nameTag.Visible = false

    RunService.Heartbeat:Connect(function()
        if ESPEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Head") then
            local hrp = player.Character.HumanoidRootPart
            local head = player.Character.Head
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")

            if humanoid and humanoid.Health > 0 then
                local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)

                if onScreen then
                    local height = (Camera:WorldToViewportPoint(hrp.Position + Vector3.new(0, 3, 0)).Y -
                                    Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 2.5, 0)).Y)
                    local width = height / 2

                    -- Boîte
                    box.Size = Vector2.new(width, height)
                    box.Position = Vector2.new(pos.X - width / 2, pos.Y - height / 2)
                    box.Visible = true

                    -- Nom
                    nameTag.Position = Vector2.new(pos.X, pos.Y - height / 2 - 14)
                    nameTag.Text = player.Name
                    nameTag.Visible = true
                else
                    box.Visible = false
                    nameTag.Visible = false
                end
            else
                box.Visible = false
                nameTag.Visible = false
            end
        else
            box.Visible = false
            nameTag.Visible = false
        end
    end)
end

-- Initialiser ESP pour tous les joueurs
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        createESP(player)
    end
end

-- ESP pour les nouveaux joueurs
Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(function()
            wait(1)
            createESP(player)
        end)
    end
end)
