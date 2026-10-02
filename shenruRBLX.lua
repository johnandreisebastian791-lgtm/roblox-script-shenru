--[[
    MRTX | SHENRU
    Universal Roblox exploit script
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local Config = {
    ESP = {
        Enabled = false,
        Boxes = true,
        Names = true,
        Distance = true,
        Health = true,
        Tracers = false,
        TeamCheck = true,
        MaxDistance = 2000,
        BoxColor = Color3.fromRGB(255, 50, 80),
        NameColor = Color3.fromRGB(255, 255, 255),
        TracerColor = Color3.fromRGB(255, 50, 80),
    },
    Aimbot = {
        Enabled = false,
        TeamCheck = true,
        FOV = 120,
        Smoothness = 0.25,
        Prediction = 0.12,
        TargetPart = "Head",
        ShowFOV = true,
        FOVColor = Color3.fromRGB(255, 50, 80),
        Key = Enum.UserInputType.MouseButton2,
    },
    Movement = {
        Speed = false,
        SpeedValue = 50,
        Fly = false,
        FlySpeed = 60,
        Noclip = false,
        InfiniteJump = false,
    },
    Visuals = {
        Fullbright = false,
        NoFog = false,
    },
    Misc = {
        ClickTP = false,
        ClickTPKey = Enum.KeyCode.T,
    }
}

local ESPObjects = {}
local DrawingObjects = {}
local Flying = false
local BodyVelocity, BodyGyro
local FOVCircle
local UI = { Open = true, Tabs = {}, CurrentTab = "Combat", Hitboxes = {} }
local UIElements = {}
local Dragging = false
local DragOffset = Vector2.zero
local WindowPos = Vector2.new(80, 80)
local WindowSize = Vector2.new(420, 380)

local function IsAlive(plr)
    local char = plr.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    return hum and hum.Health > 0
end

local function GetClosestPlayer()
    local closest, dist = nil, Config.Aimbot.FOV
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr \~= LocalPlayer and IsAlive(plr) then
            if Config.Aimbot.TeamCheck and plr.Team == LocalPlayer.Team then continue end
            local part = plr.Character:FindFirstChild(Config.Aimbot.TargetPart) or plr.Character:FindFirstChild("HumanoidRootPart")
            if part then
                local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local mag = (Vector2.new(pos.X, pos.Y) - screenCenter).Magnitude
                    if mag < dist then
                        dist = mag
                        closest = part
                    end
                end
            end
        end
    end
    return closest
end

local function CreateDrawing(class, props)
    local obj = Drawing.new(class)
    for k, v in pairs(props or {}) do
        obj[k] = v
    end
    table.insert(DrawingObjects, obj)
    return obj
end

local function CreateESP(plr)
    if ESPObjects[plr] then return end
    local box = CreateDrawing("Square", { Thickness = 1, Filled = false, Visible = false, Color = Config.ESP.BoxColor })
    local name = CreateDrawing("Text", { Size = 14, Center = true, Outline = true, Visible = false, Color = Config.ESP.NameColor })
    local dist = CreateDrawing("Text", { Size = 12, Center = true, Outline = true, Visible = false, Color = Color3.fromRGB(200, 200, 200) })
    local healthBar = CreateDrawing("Square", { Thickness = 1, Filled = true, Visible = false, Color = Color3.fromRGB(0, 255, 80) })
    local healthOutline = CreateDrawing("Square", { Thickness = 1, Filled = false, Visible = false, Color = Color3.fromRGB(0, 0, 0) })
    local tracer = CreateDrawing("Line", { Thickness = 1, Visible = false, Color = Config.ESP.TracerColor })
    ESPObjects[plr] = { Box = box, Name = name, Dist = dist, HealthBar = healthBar, HealthOutline = healthOutline, Tracer = tracer }
end

local function RemoveESP(plr)
    local data = ESPObjects[plr]
    if not data then return end
    for _, obj in pairs(data) do
        pcall(function() obj:Remove() end)
    end
    ESPObjects[plr] = nil
end

local function UpdateESP()
    for plr, data in pairs(ESPObjects) do
        if not plr.Parent or not IsAlive(plr) then
            for _, obj in pairs(data) do obj.Visible = false end
            continue
        end
        if Config.ESP.TeamCheck and plr.Team == LocalPlayer.Team then
            for _, obj in pairs(data) do obj.Visible = false end
            continue
        end
        local char = plr.Character
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then
            for _, obj in pairs(data) do obj.Visible = false end
            continue
        end
        local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
        local distance = (root.Position - Camera.CFrame.Position).Magnitude
        if not onScreen or distance > Config.ESP.MaxDistance or not Config.ESP.Enabled then
            for _, obj in pairs(data) do obj.Visible = false end
            continue
        end
        local top = Camera:WorldToViewportPoint(root.Position + Vector3.new(0, 3.2, 0))
        local bottom = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3.0, 0))
        local height = math.abs(top.Y - bottom.Y)
        local width = height * 0.55
        local x, y = pos.X, pos.Y
        data.Box.Visible = Config.ESP.Boxes
        data.Box.Size = Vector2.new(width, height)
        data.Box.Position = Vector2.new(x - width / 2, y - height / 2)
        data.Box.Color = Config.ESP.BoxColor
        data.Name.Visible = Config.ESP.Names
        data.Name.Text = plr.Name
        data.Name.Position = Vector2.new(x, y - height / 2 - 16)
        data.Dist.Visible = Config.ESP.Distance
        data.Dist.Text = string.format("[%dm]", math.floor(distance))
        data.Dist.Position = Vector2.new(x, y + height / 2 + 2)
        local hpRatio = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
        data.HealthOutline.Visible = Config.ESP.Health
        data.HealthOutline.Size = Vector2.new(3, height)
        data.HealthOutline.Position = Vector2.new(x - width / 2 - 6, y - height / 2)
        data.HealthBar.Visible = Config.ESP.Health
        data.HealthBar.Size = Vector2.new(2, height * hpRatio)
        data.HealthBar.Position = Vector2.new(x - width / 2 - 5.5, y - height / 2 + height * (1 - hpRatio))
        data.HealthBar.Color = Color3.fromRGB(255 * (1 - hpRatio), 255 * hpRatio, 40)
        data.Tracer.Visible = Config.ESP.Tracers
        data.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
        data.Tracer.To = Vector2.new(x, y + height / 2)
        data.Tracer.Color = Config.ESP.TracerColor
    end
end

local function AimbotLoop()
    if not Config.Aimbot.Enabled then return end
    local held = UserInputService:IsMouseButtonPressed(Config.Aimbot.Key)
    if not held then return end
    local target = GetClosestPlayer()
    if not target then return end
    local velocity = target.AssemblyLinearVelocity or Vector3.zero
    local predicted = target.Position + (velocity * Config.Aimbot.Prediction)
    local camCF = Camera.CFrame
    Camera.CFrame = camCF:Lerp(CFrame.new(camCF.Position, predicted), Config.Aimbot.Smoothness)
end

local function ToggleFly(state)
    Flying = state
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return end
    if Flying then
        BodyVelocity = Instance.new("BodyVelocity")
        BodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        BodyVelocity.Velocity = Vector3.zero
        BodyVelocity.Parent = root
        BodyGyro = Instance.new("BodyGyro")
        BodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        BodyGyro.P = 9e4
        BodyGyro.Parent = root
        hum.PlatformStand = true
    else
        if BodyVelocity then BodyVelocity:Destroy() end
        if BodyGyro then BodyGyro:Destroy() end
        BodyVelocity, BodyGyro = nil, nil
        hum.PlatformStand = false
    end
end

local function FlyLoop()
    if not Flying or not BodyVelocity or not BodyGyro then return end
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    BodyGyro.CFrame = Camera.CFrame
    local dir = Vector3.zero
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += Camera.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= Camera.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= Camera.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += Camera.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0, 1, 0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0, 1, 0) end
    BodyVelocity.Velocity = dir.Magnitude > 0 and dir.Unit * Config.Movement.FlySpeed or Vector3.zero
end

local function SpeedLoop()
    if not Config.Movement.Speed then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = Config.Movement.SpeedValue end
end

local function NoclipLoop()
    if not Config.Movement.Noclip then return end
    local char = LocalPlayer.Character
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = false end
    end
end

local function ApplyFullbright()
    if Config.Visuals.Fullbright then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    end
end

local function ApplyNoFog()
    if Config.Visuals.NoFog then
        Lighting.FogEnd = 100000
        Lighting.FogStart = 0
    end
end

local function MakeRect(pos, size, color, filled, transparency)
    local r = CreateDrawing("Square", {
        Position = pos,
        Size = size,
        Color = color,
        Filled = filled \~= false,
        Thickness = 1,
        Transparency = transparency or 1,
        Visible = true,
        ZIndex = 2,
    })
    return r
end

local function MakeText(pos, text, size, color, center)
    local t = CreateDrawing("Text", {
        Position = pos,
        Text = text,
        Size = size or 14,
        Color = color or Color3.fromRGB(240, 240, 240),
        Center = center or false,
        Outline = true,
        OutlineColor = Color3.fromRGB(0, 0, 0),
        Visible = true,
        ZIndex = 3,
    })
    return t
end

local function RebuildUI()
    for _, obj in ipairs(UIElements) do
        pcall(function() obj:Remove() end)
    end
    table.clear(UIElements)
    if not UI.Open then return end

    local bg = MakeRect(WindowPos, WindowSize, Color3.fromRGB(18, 18, 22), true, 0.92)
    local accent = MakeRect(WindowPos, Vector2.new(WindowSize.X, 3), Color3.fromRGB(255, 45, 85), true, 1)
    local title = MakeText(WindowPos + Vector2.new(12, 12), "MRTX  |  SHENRU", 18, Color3.fromRGB(255, 255, 255))
    local sub = MakeText(WindowPos + Vector2.new(12, 34), "basic build  •  universal", 12, Color3.fromRGB(140, 140, 150))
    table.insert(UIElements, bg)
    table.insert(UIElements, accent)
    table.insert(UIElements, title)
    table.insert(UIElements, sub)

    local tabs = { "Combat", "Visuals", "Movement", "Misc" }
    local tabW = 90
    for i, name in ipairs(tabs) do
        local x = WindowPos.X + 12 + (i - 1) * (tabW + 6)
        local y = WindowPos.Y + 58
        local active = UI.CurrentTab == name
        local tabBg = MakeRect(Vector2.new(x, y), Vector2.new(tabW, 26), active and Color3.fromRGB(255, 45, 85) or Color3.fromRGB(32, 32, 38), true, 1)
        local tabTxt = MakeText(Vector2.new(x + tabW / 2, y + 5), name, 13, active and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 190), true)
        table.insert(UIElements, tabBg)
        table.insert(UIElements, tabTxt)
        UI.Tabs[name] = { Pos = Vector2.new(x, y), Size = Vector2.new(tabW, 26) }
    end

    local contentY = WindowPos.Y + 100
    local leftX = WindowPos.X + 18

    local function Toggle(label, state, yOff)
        local y = contentY + yOff
        local box = MakeRect(Vector2.new(leftX, y), Vector2.new(16, 16), state and Color3.fromRGB(255, 45, 85) or Color3.fromRGB(45, 45, 52), true, 1)
        local txt = MakeText(Vector2.new(leftX + 24, y - 1), label, 14, Color3.fromRGB(230, 230, 235))
        table.insert(UIElements, box)
        table.insert(UIElements, txt)
        return { Pos = Vector2.new(leftX, y), Size = Vector2.new(200, 18) }
    end

    local function Slider(label, value, min, max, yOff)
        local y = contentY + yOff
        local txt = MakeText(Vector2.new(leftX, y), string.format("%s  [%.0f]", label, value), 13, Color3.fromRGB(200, 200, 210))
        local track = MakeRect(Vector2.new(leftX, y + 20), Vector2.new(220, 6), Color3.fromRGB(40, 40, 48), true, 1)
        local ratio = (value - min) / (max - min)
        local fill = MakeRect(Vector2.new(leftX, y + 20), Vector2.new(220 * ratio, 6), Color3.fromRGB(255, 45, 85), true, 1)
        table.insert(UIElements, txt)
        table.insert(UIElements, track)
        table.insert(UIElements, fill)
        return { Pos = Vector2.new(leftX, y + 18), Size = Vector2.new(220, 12), Min = min, Max = max }
    end

    UI.Hitboxes = {}
    if UI.CurrentTab == "Combat" then
        UI.Hitboxes.Aimbot = Toggle("Aimbot", Config.Aimbot.Enabled, 0)
        UI.Hitboxes.TeamCheckA = Toggle("Team Check", Config.Aimbot.TeamCheck, 28)
        UI.Hitboxes.ShowFOV = Toggle("Show FOV", Config.Aimbot.ShowFOV, 56)
        UI.Hitboxes.FOV = Slider("FOV Size", Config.Aimbot.FOV, 40, 400, 90)
        UI.Hitboxes.Smooth = Slider("Smoothness", Config.Aimbot.Smoothness * 100, 1, 100, 140)
        UI.Hitboxes.Pred = Slider("Prediction", Config.Aimbot.Prediction * 100, 0, 50, 190)
    elseif UI.CurrentTab == "Visuals" then
        UI.Hitboxes.ESP = Toggle("ESP Master", Config.ESP.Enabled, 0)
        UI.Hitboxes.Boxes = Toggle("Boxes", Config.ESP.Boxes, 28)
        UI.Hitboxes.Names = Toggle("Names", Config.ESP.Names, 56)
        UI.Hitboxes.Distance = Toggle("Distance", Config.ESP.Distance, 84)
        UI.Hitboxes.Health = Toggle("Health Bar", Config.ESP.Health, 112)
        UI.Hitboxes.Tracers = Toggle("Tracers", Config.ESP.Tracers, 140)
        UI.Hitboxes.TeamCheckE = Toggle("Team Check", Config.ESP.TeamCheck, 168)
        UI.Hitboxes.Fullbright = Toggle("Fullbright", Config.Visuals.Fullbright, 210)
        UI.Hitboxes.NoFog = Toggle("No Fog", Config.Visuals.NoFog, 238)
    elseif UI.CurrentTab == "Movement" then
        UI.Hitboxes.Speed = Toggle("Speed", Config.Movement.Speed, 0)
        UI.Hitboxes.SpeedVal = Slider("Speed Value", Config.Movement.SpeedValue, 16, 200, 30)
        UI.Hitboxes.Fly = Toggle("Fly", Config.Movement.Fly, 90)
        UI.Hitboxes.FlySpeed = Slider("Fly Speed", Config.Movement.FlySpeed, 20, 200, 120)
        UI.Hitboxes.Noclip = Toggle("Noclip", Config.Movement.Noclip, 180)
        UI.Hitboxes.InfJump = Toggle("Infinite Jump", Config.Movement.InfiniteJump, 208)
    elseif UI.CurrentTab == "Misc" then
        UI.Hitboxes.ClickTP = Toggle("Click TP (T)", Config.Misc.ClickTP, 0)
        local info = MakeText(Vector2.new(leftX, contentY + 50), "Right-click = aimbot hold", 12, Color3.fromRGB(150, 150, 160))
        local info2 = MakeText(Vector2.new(leftX, contentY + 70), "Insert = toggle UI", 12, Color3.fromRGB(150, 150, 160))
        local info3 = MakeText(Vector2.new(leftX, contentY + 90), "MRTX | SHENRU  •  basic build", 12, Color3.fromRGB(120, 120, 130))
        table.insert(UIElements, info)
        table.insert(UIElements, info2)
        table.insert(UIElements, info3)
    end
end

local function IsInBox(pos, box)
    return pos.X >= box.Pos.X and pos.X <= box.Pos.X + box.Size.X
        and pos.Y >= box.Pos.Y and pos.Y <= box.Pos.Y + box.Size.Y
end

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        UI.Open = not UI.Open
        RebuildUI()
        return
    end
    if input.KeyCode == Enum.KeyCode.Space and Config.Movement.InfiniteJump then
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
    if input.KeyCode == Config.Misc.ClickTPKey and Config.Misc.ClickTP then
        if Mouse.Hit then
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root then root.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3, 0)) end
        end
    end
    if input.UserInputType == Enum.UserInputType.MouseButton1 and UI.Open then
        local mPos = UserInputService:GetMouseLocation()
        if mPos.X >= WindowPos.X and mPos.X <= WindowPos.X + WindowSize.X
            and mPos.Y >= WindowPos.Y and mPos.Y <= WindowPos.Y + 50 then
            Dragging = true
            DragOffset = mPos - WindowPos
            return
        end
        for name, box in pairs(UI.Tabs) do
            if IsInBox(mPos, box) then
                UI.CurrentTab = name
                RebuildUI()
                return
            end
        end
        local hits = UI.Hitboxes or {}
        if hits.Aimbot and IsInBox(mPos, hits.Aimbot) then Config.Aimbot.Enabled = not Config.Aimbot.Enabled RebuildUI() end
        if hits.TeamCheckA and IsInBox(mPos, hits.TeamCheckA) then Config.Aimbot.TeamCheck = not Config.Aimbot.TeamCheck RebuildUI() end
        if hits.ShowFOV and IsInBox(mPos, hits.ShowFOV) then Config.Aimbot.ShowFOV = not Config.Aimbot.ShowFOV RebuildUI() end
        if hits.ESP and IsInBox(mPos, hits.ESP) then Config.ESP.Enabled = not Config.ESP.Enabled RebuildUI() end
        if hits.Boxes and IsInBox(mPos, hits.Boxes) then Config.ESP.Boxes = not Config.ESP.Boxes RebuildUI() end
        if hits.Names and IsInBox(mPos, hits.Names) then Config.ESP.Names = not Config.ESP.Names RebuildUI() end
        if hits.Distance and IsInBox(mPos, hits.Distance) then Config.ESP.Distance = not Config.ESP.Distance RebuildUI() end
        if hits.Health and IsInBox(mPos, hits.Health) then Config.ESP.Health = not Config.ESP.Health RebuildUI() end
        if hits.Tracers and IsInBox(mPos, hits.Tracers) then Config.ESP.Tracers = not Config.ESP.Tracers RebuildUI() end
        if hits.TeamCheckE and IsInBox(mPos, hits.TeamCheckE) then Config.ESP.TeamCheck = not Config.ESP.TeamCheck RebuildUI() end
        if hits.Fullbright and IsInBox(mPos, hits.Fullbright) then Config.Visuals.Fullbright = not Config.Visuals.Fullbright ApplyFullbright() RebuildUI() end
        if hits.NoFog and IsInBox(mPos, hits.NoFog) then Config.Visuals.NoFog = not Config.Visuals.NoFog ApplyNoFog() RebuildUI() end
        if hits.Speed and IsInBox(mPos, hits.Speed) then Config.Movement.Speed = not Config.Movement.Speed RebuildUI() end
        if hits.Fly and IsInBox(mPos, hits.Fly) then Config.Movement.Fly = not Config.Movement.Fly ToggleFly(Config.Movement.Fly) RebuildUI() end
        if hits.Noclip and IsInBox(mPos, hits.Noclip) then Config.Movement.Noclip = not Config.Movement.Noclip RebuildUI() end
        if hits.InfJump and IsInBox(mPos, hits.InfJump) then Config.Movement.InfiniteJump = not Config.Movement.InfiniteJump RebuildUI() end
        if hits.ClickTP and IsInBox(mPos, hits.ClickTP) then Config.Misc.ClickTP = not Config.Misc.ClickTP RebuildUI() end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        Dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and Dragging then
        WindowPos = UserInputService:GetMouseLocation() - DragOffset
        RebuildUI()
    end
end)

FOVCircle = CreateDrawing("Circle", {
    Thickness = 1,
    NumSides = 64,
    Radius = Config.Aimbot.FOV,
    Filled = false,
    Visible = false,
    Color = Config.Aimbot.FOVColor,
    ZIndex = 1,
})

RunService.RenderStepped:Connect(function()
    UpdateESP()
    AimbotLoop()
    FlyLoop()
    SpeedLoop()
    NoclipLoop()
    if FOVCircle then
        FOVCircle.Visible = Config.Aimbot.Enabled and Config.Aimbot.ShowFOV
        FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        FOVCircle.Radius = Config.Aimbot.FOV
        FOVCircle.Color = Config.Aimbot.FOVColor
    end
end)

for _, plr in ipairs(Players:GetPlayers()) do
    if plr \~= LocalPlayer then CreateESP(plr) end
end
Players.PlayerAdded:Connect(function(plr) CreateESP(plr) end)
Players.PlayerRemoving:Connect(function(plr) RemoveESP(plr) end)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    if Config.Movement.Fly then ToggleFly(true) end
end)

RebuildUI()
print("[MRTX | SHENRU] loaded  •  Insert to toggle UI")