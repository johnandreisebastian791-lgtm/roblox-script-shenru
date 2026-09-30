-- MRTX | Shenru
-- dev: shenrukaidev • OWNER (verified)
-- target: Delta Executor (Android)

-- ======================================================
-- CLEANUP PREVIOUS RUN
-- ======================================================
if getgenv then
    local g = getgenv()
    if g.MRTX_Cleanup then
        pcall(g.MRTX_Cleanup)
        g.MRTX_Cleanup = nil
    end
end

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local lp = Players.LocalPlayer

print("[MRTX] booting...")

-- ======================================================
-- PARENT (PlayerGui direct — most compatible)
-- ======================================================
local parent = lp:WaitForChild("PlayerGui")
local old = parent:FindFirstChild("MRTX_Shenru")
if old then old:Destroy() end

local ACCENT   = Color3.fromRGB(140, 90, 240)
local ACCENT2  = Color3.fromRGB(120, 200, 255)
local BG       = Color3.fromRGB(14, 14, 18)
local BG2      = Color3.fromRGB(20, 20, 26)
local TITLE_BG = Color3.fromRGB(22, 22, 28)
local ROW_BG   = Color3.fromRGB(24, 24, 30)
local ROW_BG2  = Color3.fromRGB(20, 20, 26)

local gui = Instance.new("ScreenGui")
gui.Name = "MRTX_Shenru"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 999
gui.Enabled = true
gui.Parent = parent

local cleanup_fns = {}

-- ======================================================
-- MAIN WINDOW
-- ======================================================
local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, 260, 0, 330)
main.Position = UDim2.new(0.5, -130, 0.5, -165)
main.BackgroundColor3 = BG
main.BorderSizePixel = 0
main.Active = true
main.Selectable = true
main.ClipsDescendants = true
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

local mainStroke = Instance.new("UIStroke", main)
mainStroke.Color = ACCENT
mainStroke.Thickness = 1.2
mainStroke.Transparency = 0.4

local bgGrad = Instance.new("UIGradient", main)
bgGrad.Rotation = 90
bgGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, BG2),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 14)),
})

-- ======================================================
-- TITLE BAR
-- ======================================================
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 34)
titleBar.BackgroundColor3 = TITLE_BG
titleBar.BorderSizePixel = 0
titleBar.Active = true
titleBar.Selectable = true
titleBar.Parent = main
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 10)

local titleCover = Instance.new("Frame")
titleCover.Size = UDim2.new(1, 0, 0, 10)
titleCover.Position = UDim2.new(0, 0, 1, -10)
titleCover.BackgroundColor3 = TITLE_BG
titleCover.BorderSizePixel = 0
titleCover.Parent = titleBar

local strip = Instance.new("Frame")
strip.Size = UDim2.new(1, 0, 0, 2)
strip.Position = UDim2.new(0, 0, 1, -2)
strip.BackgroundColor3 = ACCENT
strip.BorderSizePixel = 0
strip.Parent = titleBar
local stripGrad = Instance.new("UIGradient", strip)
stripGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, ACCENT),
    ColorSequenceKeypoint.new(1, ACCENT2),
})

local brand = Instance.new("TextLabel")
brand.BackgroundTransparency = 1
brand.Position = UDim2.new(0, 12, 0, 0)
brand.Size = UDim2.new(0, 200, 1, 0)
brand.Font = Enum.Font.GothamBold
brand.Text = "MRTX | Shenru"
brand.TextColor3 = Color3.fromRGB(225, 218, 255)
brand.TextSize = 13
brand.TextXAlignment = Enum.TextXAlignment.Left
brand.Parent = titleBar

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 22, 0, 22)
minBtn.Position = UDim2.new(1, -28, 0.5, -11)
minBtn.BackgroundColor3 = Color3.fromRGB(34, 34, 44)
minBtn.Text = "–"
minBtn.TextColor3 = Color3.fromRGB(210, 210, 230)
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 16
minBtn.AutoButtonColor = false
minBtn.Active = true
minBtn.Selectable = true
minBtn.Parent = titleBar
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)

print("[MRTX] window + titlebar built")

-- ======================================================
-- DRAG (set up NOW, before anything else can fail)
-- ======================================================
local dragging, dragStart, startPos, blockDrag = false, nil, nil, false

local c1 = minBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        blockDrag = true
    end
end)

local c2 = minBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        blockDrag = false
    end
end)

local c3 = titleBar.InputBegan:Connect(function(input)
    if blockDrag then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
    end
end)

local c4 = titleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

local c5 = UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

table.insert(cleanup_fns, function() c1:Disconnect() end)
table.insert(cleanup_fns, function() c2:Disconnect() end)
table.insert(cleanup_fns, function() c3:Disconnect() end)
table.insert(cleanup_fns, function() c4:Disconnect() end)
table.insert(cleanup_fns, function() c5:Disconnect() end)

print("[MRTX] drag wired")

-- ======================================================
-- SIDEBAR
-- ======================================================
local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, 58, 1, -70)
sidebar.Position = UDim2.new(0, 8, 0, 44)
sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
sidebar.BorderSizePixel = 0
sidebar.Parent = main
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 8)

local sideStroke = Instance.new("UIStroke", sidebar)
sideStroke.Color = Color3.fromRGB(56, 56, 78)
sideStroke.Thickness = 1
sideStroke.Transparency = 0.5

-- ======================================================
-- CONTENT HOST
-- ======================================================
local contentHost = Instance.new("Frame")
contentHost.Size = UDim2.new(1, -74, 1, -70)
contentHost.Position = UDim2.new(0, 66, 0, 44)
contentHost.BackgroundTransparency = 1
contentHost.Parent = main

local pages = {}

local function make_page(name)
    local page = Instance.new("ScrollingFrame")
    page.Name = name
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 2
    page.ScrollBarImageColor3 = ACCENT
    page.ScrollBarImageTransparency = 0.4
    page.CanvasSize = UDim2.new(0, 0, 0, 300)
    page.Visible = false
    page.Parent = contentHost

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 6)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = page

    local pad = Instance.new("UIPadding")
    pad.PaddingBottom = UDim.new(0, 8)
    pad.Parent = page

    pages[name] = page
    return page
end

-- ======================================================
-- TAB BUTTONS
-- ======================================================
local tabButtons = {}
local activeTab = nil

local function set_tab(name)
    if activeTab == name then return end
    activeTab = name

    for n, page in pairs(pages) do
        page.Visible = (n == name)
    end

    for n, btn in pairs(tabButtons) do
        local isActive = (n == name)
        TweenService:Create(btn, TweenInfo.new(0.15), {
            BackgroundColor3 = isActive and Color3.fromRGB(45, 32, 80)
                or Color3.fromRGB(26, 26, 34),
            TextColor3 = isActive and Color3.fromRGB(240, 235, 255)
                or Color3.fromRGB(150, 150, 175),
        }):Play()
    end
end

local function make_tab_button(label, name, yPos)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(1, -10, 0, 34)
    btn.Position = UDim2.new(0, 5, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(26, 26, 34)
    btn.Text = label
    btn.TextColor3 = Color3.fromRGB(150, 150, 175)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.AutoButtonColor = false
    btn.Active = true
    btn.Selectable = true
    btn.Parent = sidebar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    btn.Activated:Connect(function() set_tab(name) end)
    tabButtons[name] = btn
    return btn
end

make_tab_button("Main", "Main",   8)
make_tab_button("Cmb",  "Combat", 48)
make_tab_button("Vis",  "Visual", 88)
make_tab_button("Msc",  "Misc",   128)

print("[MRTX] tabs created")

-- ======================================================
-- STATE
-- ======================================================
local state = {
    walkspeed = false, jumppower = false, infinite_jump = false,
    esp = false, fly = false, noclip = false,
}
local conns = {}
local highlights = {}
local values = { walkspeed = 32, jumppower = 100, fly_speed = 60 }

local function track(name, conn)
    if conns[name] then conns[name]:Disconnect() end
    conns[name] = conn
end

-- ======================================================
-- TOGGLE ROW
-- ======================================================
local function make_toggle(parent_page, text, key, on_enable, on_disable)
    local row = Instance.new("TextButton")
    row.Size = UDim2.new(1, 0, 0, 34)
    row.BackgroundColor3 = ROW_BG
    row.Text = ""
    row.AutoButtonColor = false
    row.Active = true
    row.Selectable = true
    row.Parent = parent_page
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)

    local rowGrad = Instance.new("UIGradient", row)
    rowGrad.Rotation = 90
    rowGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, ROW_BG),
        ColorSequenceKeypoint.new(1, ROW_BG2),
    })

    local stroke = Instance.new("UIStroke", row)
    stroke.Color = Color3.fromRGB(64, 64, 88)
    stroke.Thickness = 1
    stroke.Transparency = 0.45

    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 12, 0, 0)
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Font = Enum.Font.Gotham
    label.Text = text
    label.TextColor3 = Color3.fromRGB(210, 205, 235)
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row

    local pill = Instance.new("Frame")
    pill.Size = UDim2.new(0, 36, 0, 18)
    pill.Position = UDim2.new(1, -46, 0.5, -9)
    pill.BackgroundColor3 = Color3.fromRGB(42, 42, 54)
    pill.BorderSizePixel = 0
    pill.Parent = row
    Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = UDim2.new(0, 2, 0.5, -7)
    knob.BackgroundColor3 = Color3.fromRGB(170, 170, 185)
    knob.BorderSizePixel = 0
    knob.Parent = pill
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local function refresh()
        if state[key] then
            stroke.Color = ACCENT
            stroke.Transparency = 0.1
            TweenService:Create(pill, TweenInfo.new(0.16), {
                BackgroundColor3 = Color3.fromRGB(90, 60, 170)
            }):Play()
            TweenService:Create(knob, TweenInfo.new(0.16), {
                Position = UDim2.new(1, -16, 0.5, -7),
                BackgroundColor3 = Color3.fromRGB(230, 220, 255),
            }):Play()
        else
            stroke.Color = Color3.fromRGB(64, 64, 88)
            stroke.Transparency = 0.45
            TweenService:Create(pill, TweenInfo.new(0.16), {
                BackgroundColor3 = Color3.fromRGB(42, 42, 54)
            }):Play()
            TweenService:Create(knob, TweenInfo.new(0.16), {
                Position = UDim2.new(0, 2, 0.5, -7),
                BackgroundColor3 = Color3.fromRGB(170, 170, 185),
            }):Play()
        end
    end

    row.Activated:Connect(function()
        state[key] = not state[key]
        refresh()
        if state[key] then
            if on_enable then pcall(on_enable) end
        else
            if on_disable then pcall(on_disable) end
        end
    end)

    return row
end

-- ======================================================
-- SLIDER ROW
-- ======================================================
local function make_slider(parent_page, text, minV, maxV, defaultV, on_change)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 44)
    row.BackgroundColor3 = ROW_BG
    row.BorderSizePixel = 0
    row.Parent = parent_page
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)

    local rowGrad = Instance.new("UIGradient", row)
    rowGrad.Rotation = 90
    rowGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, ROW_BG),
        ColorSequenceKeypoint.new(1, ROW_BG2),
    })

    local stroke = Instance.new("UIStroke", row)
    stroke.Color = Color3.fromRGB(64, 64, 88)
    stroke.Thickness = 1
    stroke.Transparency = 0.45

    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 12, 0, 3)
    label.Size = UDim2.new(1, -70, 0, 16)
    label.Font = Enum.Font.Gotham
    label.Text = text
    label.TextColor3 = Color3.fromRGB(210, 205, 235)
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row

    local valueLbl = Instance.new("TextLabel")
    valueLbl.BackgroundTransparency = 1
    valueLbl.Position = UDim2.new(1, -56, 0, 3)
    valueLbl.Size = UDim2.new(0, 44, 0, 16)
    valueLbl.Font = Enum.Font.GothamBold
    valueLbl.Text = tostring(defaultV)
    valueLbl.TextColor3 = ACCENT2
    valueLbl.TextSize = 12
    valueLbl.TextXAlignment = Enum.TextXAlignment.Right
    valueLbl.Parent = row

    -- invisible full-row hitbox for easier touch
    local hitbox = Instance.new("TextButton")
    hitbox.Size = UDim2.new(1, 0, 0, 24)
    hitbox.Position = UDim2.new(0, 0, 1, -24)
    hitbox.BackgroundTransparency = 1
    hitbox.Text = ""
    hitbox.AutoButtonColor = false
    hitbox.Active = true
    hitbox.Selectable = true
    hitbox.Parent = row

    local track_ = Instance.new("Frame")
    track_.Size = UDim2.new(1, -24, 0, 6)
    track_.Position = UDim2.new(0, 12, 1, -18)
    track_.BackgroundColor3 = Color3.fromRGB(38, 38, 48)
    track_.BorderSizePixel = 0
    track_.Parent = row
    Instance.new("UICorner", track_).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((defaultV - minV) / (maxV - minV), 0, 1, 0)
    fill.BackgroundColor3 = ACCENT
    fill.BorderSizePixel = 0
    fill.Parent = track_
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local fillGrad = Instance.new("UIGradient", fill)
    fillGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, ACCENT),
        ColorSequenceKeypoint.new(1, ACCENT2),
    })

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.AnchorPoint = Vector2.new(0.5, 0.5)
    knob.Position = UDim2.new((defaultV - minV) / (maxV - minV), 0, 0.5, 0)
    knob.BackgroundColor3 = Color3.fromRGB(245, 240, 255)
    knob.BorderSizePixel = 0
    knob.Parent = track_
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
    local knobStroke = Instance.new("UIStroke", knob)
    knobStroke.Color = ACCENT
    knobStroke.Thickness = 1.5

    local dragging = false
    local currentV = defaultV

    local function update_from_x(x)
        local rel = (x - track_.AbsolutePosition.X) / track_.AbsoluteSize.X
        rel = math.clamp(rel, 0, 1)
        local val = math.floor(minV + rel * (maxV - minV) + 0.5)
        if val == currentV then return end
        currentV = val
        fill.Size = UDim2.new(rel, 0, 1, 0)
        knob.Position = UDim2.new(rel, 0, 0.5, 0)
        valueLbl.Text = tostring(val)
        if on_change then pcall(on_change, val) end
    end

    -- use the invisible hitbox so thumb taps anywhere on the row
    hitbox.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            update_from_x(input.Position.X)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
            update_from_x(input.Position.X)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    return row
end

-- ======================================================
-- SECTION HEADER
-- ======================================================
local function make_section(parent_page, title_text)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 16)
    row.BackgroundTransparency = 1
    row.Parent = parent_page

    local lbl = Instance.new("TextLabel")
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.Font = Enum.Font.GothamBold
    lbl.Text = string.upper(tostring(title_text))
    lbl.TextColor3 = Color3.fromRGB(130, 130, 160)
    lbl.TextSize = 10
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row
    return row
end

-- ======================================================
-- BUILD PAGES
-- ======================================================
local pageMain   = make_page("Main")
local pageCombat = make_page("Combat")
local pageVisual = make_page("Visual")
local pageMisc   = make_page("Misc")
print("[MRTX] pages created")

-- ---------------- MAIN ----------------
make_section(pageMain, "Movement")

make_toggle(pageMain, "WalkSpeed", "walkspeed",
    function()
        local c = lp.Character
        if c and c:FindFirstChildOfClass("Humanoid") then
            c.Humanoid.WalkSpeed = values.walkspeed
        end
    end,
    function()
        local c = lp.Character
        if c and c:FindFirstChildOfClass("Humanoid") then
            c.Humanoid.WalkSpeed = 16
        end
    end
)
make_slider(pageMain, "Speed Value", 16, 200, 32, function(v)
    values.walkspeed = v
    if state.walkspeed then
        local c = lp.Character
        if c and c:FindFirstChildOfClass("Humanoid") then c.Humanoid.WalkSpeed = v end
    end
end)

make_toggle(pageMain, "JumpPower", "jumppower",
    function()
        local c = lp.Character
        if c and c:FindFirstChildOfClass("Humanoid") then
            c.Humanoid.UseJumpPower = true
            c.Humanoid.JumpPower = values.jumppower
        end
    end,
    function()
        local c = lp.Character
        if c and c:FindFirstChildOfClass("Humanoid") then c.Humanoid.JumpPower = 50 end
    end
)
make_slider(pageMain, "Jump Value", 50, 300, 100, function(v)
    values.jumppower = v
    if state.jumppower then
        local c = lp.Character
        if c and c:FindFirstChildOfClass("Humanoid") then c.Humanoid.JumpPower = v end
    end
end)
print("[MRTX] Main page built")

-- ---------------- COMBAT ----------------
make_section(pageCombat, "Combat")

make_toggle(pageCombat, "Infinite Jump", "infinite_jump",
    function()
        track("inf_jump", UserInputService.JumpRequest:Connect(function()
            local c = lp.Character
            if c and c:FindFirstChildOfClass("Humanoid") then
                c.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end))
    end,
    function()
        if conns["inf_jump"] then conns["inf_jump"]:Disconnect() end
    end
)

local flyConn, flyVel, flyGyro

local function fly_enable()
    local c = lp.Character
    if not c then return end
    local hrp = c:FindFirstChild("HumanoidRootPart")
    local hum = c:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end

    for _, part in ipairs(c:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = false end
    end

    hum.PlatformStand = true
    pcall(function() hum:ChangeState(Enum.HumanoidStateType.Physics) end)

    flyVel = Instance.new("BodyVelocity")
    flyVel.Name = "MRTX_Fly_Vel"
    flyVel.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    flyVel.Velocity = Vector3.zero
    flyVel.Parent = hrp

    flyGyro = Instance.new("BodyGyro")
    flyGyro.Name = "MRTX_Fly_Gyro"
    flyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
    flyGyro.P = 3000
    flyGyro.D = 500
    flyGyro.CFrame = hrp.CFrame
    flyGyro.Parent = hrp

    flyConn = RunService.RenderStepped:Connect(function()
        if not state.fly or not flyVel or not flyVel.Parent then return end
        local cam = workspace.CurrentCamera
        local dir = hum.MoveDirection
        local move = dir * values.fly_speed
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            move = move + Vector3.new(0, values.fly_speed * 0.75, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl)
        or UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            move = move - Vector3.new(0, values.fly_speed * 0.75, 0)
        end
        flyVel.Velocity = move
        if flyGyro and flyGyro.Parent then
            local look = cam.CFrame.LookVector
            look = Vector3.new(look.X, 0, look.Z)
            if look.Magnitude > 0.01 then
                flyGyro.CFrame = CFrame.new(hrp.Position, hrp.Position + look)
            end
        end
    end)
end

local function fly_disable()
    if flyConn then flyConn:Disconnect() flyConn = nil end
    if flyVel then flyVel:Destroy() flyVel = nil end
    if flyGyro then flyGyro:Destroy() flyGyro = nil end

    local c = lp.Character
    if c then
        local hum = c:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.PlatformStand = false
            pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
        end
        for _, part in ipairs(c:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.CanCollide = true
            end
        end
    end
end

make_toggle(pageCombat, "Fly", "fly", fly_enable, fly_disable)
make_slider(pageCombat, "Fly Speed", 20, 200, 60, function(v)
    values.fly_speed = v
end)
print("[MRTX] Combat page built")

-- ---------------- VISUAL ----------------
make_section(pageVisual, "Visuals")

local function apply_esp(plr)
    if plr == lp then return end
    if plr.Character and not highlights[plr] then
        local hl = Instance.new("Highlight")
        hl.Name = "MRTX_ESP"
        hl.FillColor = ACCENT
        hl.OutlineColor = ACCENT2
        hl.FillTransparency = 0.55
        hl.OutlineTransparency = 0
        hl.Adornee = plr.Character
        hl.Parent = plr.Character
        highlights[plr] = hl
    end
end

local espConns = {}

make_toggle(pageVisual, "ESP (Highlight)", "esp",
    function()
        for _, plr in ipairs(Players:GetPlayers()) do apply_esp(plr) end
        table.insert(espConns, Players.PlayerAdded:Connect(function(plr)
            plr.CharacterAdded:Connect(function() task.wait(1); apply_esp(plr) end)
        end))
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= lp then
                table.insert(espConns, plr.CharacterAdded:Connect(function()
                    task.wait(1); apply_esp(plr)
                end))
            end
        end
    end,
    function()
        for _, hl in pairs(highlights) do hl:Destroy() end
        highlights = {}
        for _, cn in ipairs(espConns) do pcall(function() cn:Disconnect() end) end
        espConns = {}
    end
)
print("[MRTX] Visual page built")

-- ---------------- MISC ----------------
make_section(pageMisc, "Miscellaneous")

local noclipConn

make_toggle(pageMisc, "Noclip", "noclip",
    function()
        noclipConn = RunService.Stepped:Connect(function()
            if not state.noclip then return end
            local c = lp.Character
            if c then
                for _, part in ipairs(c:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end)
    end,
    function()
        if noclipConn then noclipConn:Disconnect() noclipConn = nil end
        if state.fly then return end
        local c = lp.Character
        if c then
            for _, part in ipairs(c:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = true end
            end
        end
    end
)
print("[MRTX] Misc page built")

set_tab("Main")
print("[MRTX] Main tab activated")

-- ======================================================
-- DEV CREDIT
-- ======================================================
local devRow = Instance.new("Frame")
devRow.Size = UDim2.new(1, -16, 0, 20)
devRow.Position = UDim2.new(0, 8, 1, -24)
devRow.BackgroundTransparency = 1
devRow.Parent = main

local devLabel = Instance.new("TextLabel")
devLabel.BackgroundTransparency = 1
devLabel.Position = UDim2.new(0, 0, 0, 1)
devLabel.Size = UDim2.new(0, 0, 0, 16)
devLabel.AutomaticSize = Enum.AutomaticSize.X
devLabel.Font = Enum.Font.Gotham
devLabel.Text = "shenrukaidev • OWNER"
devLabel.TextColor3 = Color3.fromRGB(175, 165, 205)
devLabel.TextSize = 11
devLabel.TextXAlignment = Enum.TextXAlignment.Left
devLabel.Parent = devRow

local badge = Instance.new("Frame")
badge.BackgroundColor3 = Color3.fromRGB(60, 120, 220)
badge.BorderSizePixel = 0
badge.Size = UDim2.new(0, 13, 0, 13)
badge.Position = UDim2.new(0, 0, 0.5, -6.5)
badge.Parent = devRow
Instance.new("UICorner", badge).CornerRadius = UDim.new(1, 0)
local badgeGrad = Instance.new("UIGradient", badge)
badgeGrad.Rotation = 90
badgeGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, ACCENT2),
    ColorSequenceKeypoint.new(1, ACCENT),
})
local badgeStroke = Instance.new("UIStroke", badge)
badgeStroke.Color = Color3.fromRGB(200, 220, 255)
badgeStroke.Thickness = 1
badgeStroke.Transparency = 0.3

local check = Instance.new("TextLabel")
check.BackgroundTransparency = 1
check.Size = UDim2.new(1, 0, 1, 0)
check.Font = Enum.Font.GothamBold
check.Text = "✓"
check.TextColor3 = Color3.fromRGB(255, 255, 255)
check.TextSize = 9
check.Parent = badge

local function reposition_badge()
    badge.Position = UDim2.new(0, devLabel.AbsoluteSize.X + 4, 0.5, -6.5)
end
devLabel:GetPropertyChangedSignal("AbsoluteSize"):Connect(reposition_badge)
task.defer(reposition_badge)

task.spawn(function()
    while badge and badge.Parent do
        TweenService:Create(badgeStroke, TweenInfo.new(1.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Transparency = 0.9, Color = Color3.fromRGB(180, 140, 255),
        }):Play()
        TweenService:Create(badge, TweenInfo.new(1.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            BackgroundColor3 = Color3.fromRGB(90, 60, 180),
        }):Play()
        task.wait(1.4)
        if not (badge and badge.Parent) then break end
        TweenService:Create(badgeStroke, TweenInfo.new(1.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Transparency = 0.3, Color = Color3.fromRGB(200, 220, 255),
        }):Play()
        TweenService:Create(badge, TweenInfo.new(1.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            BackgroundColor3 = Color3.fromRGB(60, 120, 220),
        }):Play()
        task.wait(1.4)
    end
end)

print("[MRTX] dev credit built")

-- ======================================================
-- RESTORE ORB + MINIMIZE
-- ======================================================
local restore = Instance.new("TextButton")
restore.Size = UDim2.new(0, 40, 0, 40)
restore.Position = UDim2.new(1, -52, 0, 70)
restore.BackgroundColor3 = BG
restore.Text = "M"
restore.TextColor3 = Color3.fromRGB(220, 210, 255)
restore.Font = Enum.Font.GothamBold
restore.TextSize = 18
restore.AutoButtonColor = false
restore.Active = true
restore.Selectable = true
restore.Visible = false
restore.Parent = gui
Instance.new("UICorner", restore).CornerRadius = UDim.new(0, 20)

local rStroke = Instance.new("UIStroke", restore)
rStroke.Color = ACCENT
rStroke.Thickness = 1.5
rStroke.Transparency = 0.3

local minimized = false

local function minimize()
    if minimized then return end
    minimized = true
    local t = TweenService:Create(main, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
        Size = UDim2.new(0, 0, 0, 0),
    })
    t:Play(); t.Completed:Wait()
    main.Visible = false
    main.Size = UDim2.new(0, 260, 0, 330)

    restore.Visible = true
    restore.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(restore, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 40, 0, 40),
    }):Play()
end

local function restore_window()
    if not minimized then return end
    minimized = false
    TweenService:Create(restore, TweenInfo.new(0.15), {
        Size = UDim2.new(0, 0, 0, 0),
    }):Play()
    task.wait(0.15)
    restore.Visible = false
    restore.Size = UDim2.new(0, 40, 0, 40)

    main.Visible = true
    main.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(main, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 260, 0, 330),
    }):Play()
end

minBtn.Activated:Connect(minimize)

local rDragging, rDragStart, rStartPos, rMoved = false, nil, nil, false

restore.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        rDragging = true; rMoved = false
        rDragStart = input.Position
        rStartPos = restore.Position
    end
end)
restore.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        rDragging = false
        if not rMoved then restore_window() end
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if rDragging and (input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - rDragStart
        if math.abs(delta.X) > 6 or math.abs(delta.Y) > 6 then rMoved = true end
        if rMoved then
            restore.Position = UDim2.new(
                rStartPos.X.Scale, rStartPos.X.Offset + delta.X,
                rStartPos.Y.Scale, rStartPos.Y.Offset + delta.Y
            )
        end
    end
end)

-- register cleanup so next run wipes this properly
if getgenv then
    getgenv().MRTX_Cleanup = function()
        for _, fn in ipairs(cleanup_fns) do pcall(fn) end
        if gui and gui.Parent then gui:Destroy() end
    end
end

print("[MRTX] fully loaded ✓")