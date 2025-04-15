--// CONFIG
local AimbotToggleKey = Enum.KeyCode.E
local AimbotEnabled = false

--// SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

--// ESP SETUP
local ESPs = {}

local function createESP(player)
    local box = Drawing.new("Square")
    box.Thickness = 1
    box.Color = Color3.fromRGB(255, 0, 0)
    box.Filled = false
    box.Visible = false

    local nameTag = Drawing.new("Text")
    nameTag.Size = 13
    nameTag.Center = true
    nameTag.Outline = true
    nameTag.Color = Color3.new(1, 1, 1)
    nameTag.Visible = false

    local distanceTag = Drawing.new("Text")
    distanceTag.Size = 12
    distanceTag.Center = true
    distanceTag.Outline = true
    distanceTag.Color = Color3.new(0, 1, 0)
    distanceTag.Visible = false

    return {
        Box = box,
        Name = nameTag,
        Distance = distanceTag,
        Player = player
    }
end

--// FONCTION : Joueur le plus proche du centre écran
local function getClosestToCenter()
    local closestPlayer = nil
    local shortestDistance = math.huge
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local head = player.Character.Head
            local pos, onScreen = Camera:WorldToViewportPoint(head.Position)

            if onScreen then
                local distance = (Vector2.new(pos.X, pos.Y) - screenCenter).Magnitude
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")

                if distance < shortestDistance and humanoid and humanoid.Health > 0 then
                    local rayParams = RaycastParams.new()
                    rayParams.FilterDescendantsInstances = {LocalPlayer.Character}
                    rayParams.FilterType = Enum.RaycastFilterType.Blacklist

                    local result = workspace:Raycast(Camera.CFrame.Position, (head.Position - Camera.CFrame.Position).Unit * 1000, rayParams)

                    if result and result.Instance:IsDescendantOf(player.Character) then
                        shortestDistance = distance
                        closestPlayer = player
                    end
                end
            end
        end
    end

    return closestPlayer
end

--// UPDATE ESP & AIMBOT
RunService.RenderStepped:Connect(function()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if not ESPs[player] then
                ESPs[player] = createESP(player)
            end

            local esp = ESPs[player]
            local hrp = player.Character.HumanoidRootPart
            local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)

            if onScreen then
                local distance = (Camera.CFrame.Position - hrp.Position).Magnitude

                esp.Box.Visible = true
                esp.Box.Size = Vector2.new(60, 80)
                esp.Box.Position = Vector2.new(pos.X - 30, pos.Y - 40)

                esp.Name.Visible = true
                esp.Name.Text = player.Name
                esp.Name.Position = Vector2.new(pos.X, pos.Y - 50)

                esp.Distance.Visible = true
                esp.Distance.Text = string.format("%.0f m", distance)
                esp.Distance.Position = Vector2.new(pos.X, pos.Y + 45)
            else
                esp.Box.Visible = false
                esp.Name.Visible = false
                esp.Distance.Visible = false
            end
        elseif ESPs[player] then
            ESPs[player].Box:Remove()
            ESPs[player].Name:Remove()
            ESPs[player].Distance:Remove()
            ESPs[player] = nil
        end
    end

    -- Aimbot actif
    if AimbotEnabled then
        local target = getClosestToCenter()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            local headPos = target.Character.Head.Position
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, headPos)
        end
    end
end)

--// TOGGLE AIMBOT
UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == AimbotToggleKey then
        AimbotEnabled = not AimbotEnabled
    end
end)
