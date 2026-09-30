-- MRTX | Shenru
-- dev: shenrukaidev • OWNER (verified)
-- target: Delta Executor (Android)

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local lp = Players.LocalPlayer

local function get_parent()
    if gethui then
        local ok, h = pcall(gethui)
        if ok and h then return h end
    end
    local ok, cg = pcall(function() return game:GetService("CoreGui") end)
    if ok and cg then return cg end
    return lp:WaitForChild("PlayerGui")
end

local parent = get_parent()
local old = parent:FindFirstChild("MRTX_Shenru")
if old then old:Destroy() end

local ACCENT = Color3.fromRGB(140, 90, 240)
local ACCENT2 = Color3.fromRGB(120, 200, 255)
local BG = Color3.fromRGB(16, 16, 20)
local BG2 = Color3.fromRGB(22, 22, 28)
local TITLE_BG = Color3.fromRGB(24, 24, 32)
local ROW_BG = Color3.fromRGB(26, 26, 34)

local gui = Instance.new("ScreenGui")
gui.Name = "MRTX_Shenru"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = parent

-- ======================================================
-- MAIN WINDOW  (260 x 320)
-- ======================================================
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 260, 0, 320)
main.Position = UDim2.new(0.5, -130, 0.5, -160)
main.BackgroundColor3 = BG
main.BorderSizePixel = 0
main.Active = true
main.ClipsDescendants = true
main.Parent = gui

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 8)

local mainStroke = Instance.new("UIStroke", main)
mainStroke.Color = ACCENT
mainStroke.Thickness = 1.2
mainStroke.Transparency = 0.35

local bgGrad = Instance.new("UIGradient", main)
bgGrad.Rotation = 90
bgGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, BG2),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 12, 16)),
})

-- ======================================================
-- TITLE BAR
-- ======================================================
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 32)
titleBar.BackgroundColor3 = TITLE_BG
titleBar.BorderSizePixel = 0
titleBar.Parent = main

Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 8)

local titleCover = Instance.new("Frame")
titleCover.Size = UDim2.new(1, 0, 0, 8)
titleCover.Position = UDim2.new(0, 0, 1, -8)
titleCover.BackgroundColor3 = TITLE_BG
titleCover.BorderSizePixel = 0
titleCover.Parent = titleBar

local brand = Instance.new("TextLabel")
brand.BackgroundTransparency = 1
brand.Position = UDim2.new(0, 10, 0, 0)
brand.Size = UDim2.new(0, 180, 1, 0)
brand.Font = Enum.Font.GothamBold
brand.Text = "MRTX | Shenru"
brand.TextColor3 = Color3.fromRGB(220, 210, 255)
brand.TextSize = 13
brand.TextXAlignment = Enum.TextXAlignment.Left
brand.Parent = titleBar

-- small status dot
local dot = Instance.new("Frame")
dot.Size = UDim2.new(0, 6, 0, 6)
dot.Position = UDim2.new(0, 184, 0.5, -3)
dot.BackgroundColor3 = ACCENT2
dot.BorderSizePixel = 0
dot.Parent = titleBar
Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

-- minimize
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 22, 0, 22)
minBtn.Position = UDim2.new(1, -28, 0.5, -11)
minBtn.BackgroundColor3 = Color3.fromRGB(32, 32, 42)
minBtn.Text = "–"
minBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 16
minBtn.AutoButtonColor = false
minBtn.Parent = titleBar
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 5)

-- ======================================================
-- TAB SIDEBAR
-- ======================================================
local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, 54, 1, -66)
sidebar.Position = UDim2.new(0, 8, 0, 40)
sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
sidebar.BorderSizePixel = 0
sidebar.Parent = main

Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 6)

local sideStroke = Instance.new("UIStroke", sidebar)
sideStroke.Color = Color3.fromRGB(60, 60, 85)
sideStroke.Thickness = 1
sideStroke.Transparency = 0.5

local sideLayout = Instance.new("UIListLayout")
sideLayout.Padding = UDim.new(0, 4)
sideLayout.SortOrder = Enum.SortOrder.LayoutOrder
sideLayout.Parent = sidebar

local sidePad = Instance.new("UIPadding")
sidePad.PaddingTop = UDim.new(0, 6)
sidePad.PaddingLeft = UDim.new(0, 4)
sidePad.PaddingRight = UDim.new(0, 4)
sidePad.Parent = sidebar

-- ======================================================
-- CONTENT (holds tab pages)
-- ======================================================
local contentHost = Instance.new("Frame")
contentHost.Name = "ContentHost"
contentHost.Size = UDim2.new(1, -70, 1, -66)
contentHost.Position = UDim2.new(0, 62, 0, 40)
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
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Visible = false
    page.Parent = contentHost

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 6)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = page

    local pad = Instance.new("UIPadding")
    pad.PaddingBottom = UDim.new(0, 6)
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
            BackgroundColor3 = isActive and ACCENT or Color3.fromRGB(28, 28, 36),
            BackgroundTransparency = isActive and 0.15 or 0,
        }):Play()
        TweenService:Create(btn.TextLabel, TweenInfo.new(0.15), {
            TextColor3 = isActive and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(160, 160, 185),
        }):Play()
    end
end

local function make_tab_button(label, name)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
    btn.Text = label
    btn.TextColor3 = Color3.fromRGB(160, 160, 185)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.AutoButtonColor = false
    btn.Parent = sidebar

    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)

    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = Color3.fromRGB(60, 60, 85)
    stroke.Thickness = 1
    stroke.Transparency = 0.6

    btn.Activated:Connect(function() set_tab(name) end)

    tabButtons[name] = btn
    return btn
end

-- ======================================================
-- FEATURE STATE
-- ======================================================
local state = {
    walkspeed = false,
    jumppower = false,
    infinite_jump = false,
    esp = false,
    fly = false,
    noclip = false,
}

local conns = {}
local highlights = {}
local values = {
    walkspeed = 32,
    jumppower = 100,
    fly_speed = 60,
}

local function track(name, conn)
    if conns[name] then conns[name]:Disconnect() end
    conns[name] = conn
end

-- ======================================================
-- TOGGLE ROW
-- ======================================================
local function make_toggle(parent, text, key, on_enable, on_disable)
    local row = Instance.new("TextButton")
    row.Size = UDim2.new(1, 0, 0, 32)
    row.BackgroundColor3 = ROW_BG
    row.Text = ""
    row.AutoButtonColor = false
    row.Parent = parent

    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)

    local stroke = Instance.new("UIStroke", row)
    stroke.Color = Color3.fromRGB(70, 70, 95)
    stroke.Thickness = 1
    stroke.Transparency = 0.4

    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Size = UDim2.new(1, -56, 1, 0)
    label.Font = Enum.Font.Gotham
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 195, 225)
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row

    local pill = Instance.new("Frame")
    pill.Size = UDim2.new(0, 34, 0, 18)
    pill.Position = UDim2.new(1, -44, 0.5, -9)
    pill.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    pill.BorderSizePixel = 0
    pill.Parent = row
    Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = UDim2.new(0, 2, 0.5, -7)
    knob.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
    knob.BorderSizePixel = 0
    knob.Parent = pill
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local function refresh()
        if state[key] then
            stroke.Color = ACCENT
            stroke.Transparency = 0.1
            TweenService:Create(pill, TweenInfo.new(0.15), {
                BackgroundColor3 = Color3.fromRGB(90, 60, 170)
            }):Play()
            TweenService:Create(knob, TweenInfo.new(0.15), {
                Position = UDim2.new(1, -16, 0.5, -7),
                BackgroundColor3 = Color3.fromRGB(220, 210, 255),
            }):Play()
        else
            stroke.Color = Color3.fromRGB(70, 70, 95)
            stroke.Transparency = 0.4
            TweenService:Create(pill, TweenInfo.new(0.15), {
                BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            }):Play()
            TweenService:Create(knob, TweenInfo.new(0.15), {
                Position = UDim2.new(0, 2, 0.5, -7),
                BackgroundColor3 = Color3.fromRGB(180, 180, 190),
            }):Play()
        end
    end

    row.Activated:Connect(function()
        state[key] = not state[key]
        refresh()
        if state[key] then
            if on_enable then on_enable() end
        else
            if on_disable then on_disable() end
        end
    end)

    return row
end

-- ======================================================
-- SLIDER ROW
-- ======================================================
local function make_slider(parent, text, minV, maxV, defaultV, on_change)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 42)
    row.BackgroundColor3 = ROW_BG
    row.BorderSizePixel = 0
    row.Parent = parent
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 6)

    local stroke = Instance.new("UIStroke", row)
    stroke.Color = Color3.fromRGB(70, 70, 95)
    stroke.Thickness = 1
    stroke.Transparency = 0.4

    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 10, 0, 2)
    label.Size = UDim2.new(1, -60, 0, 16)
    label.Font = Enum.Font.Gotham
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 195, 225)
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row

    local valueLbl = Instance.new("TextLabel")
    valueLbl.BackgroundTransparency = 1
    valueLbl.Position = UDim2.new(1, -50, 0, 2)
    valueLbl.Size = UDim2.new(0, 40, 0, 16)
    valueLbl.Font = Enum.Font.GothamBold
    valueLbl.Text = tostring(defaultV)
    valueLbl.TextColor3 = ACCENT2
    valueLbl.TextSize = 12
    valueLbl.TextXAlignment = Enum.TextXAlignment.Right
    valueLbl.Parent = row

    local track_ = Instance.new("Frame")
    track_.Size = UDim2.new(1, -20, 0, 8)
    track_.Position = UDim2.new(0, 10, 1, -16)
    track_.BackgroundColor3 = Color3.fromRGB(36, 36, 46)
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
    knob.BackgroundColor3 = Color3.fromRGB(240, 240, 255)
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
        if on_change then on_change(val) end
    end

    track_.InputBegan:Connect(function(input)
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

    return row, function() return currentV end
end

-- ======================================================
-- BUILD PAGES
-- ======================================================
local pageMain = make_page("Main")
local pageCombat = make_page("Combat")
local pageVisual = make_page("Visual")
local pageMisc = make_page("Misc")

make_tab_button("Main", "Main")
make_tab_button("Cmb", "Combat")
make_tab_button("Vis", "Visual")
make_tab_button("Msc", "Misc")

-- ---------------- MAIN PAGE ----------------
local ws_slider
make_toggle(pageMain, "WalkSpeed", "walkspeed",
    function()
        local char = lp.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char.Humanoid.WalkSpeed = values.walkspeed
        end
    end,
    function()
        local char = lp.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char.Humanoid.WalkSpeed = 16
        end
    end
)
_, _ = nil, nil
local wsRow, wsGet = make_slider(pageMain, "Speed Value", 16, 200, 32, function(v)
    values.walkspeed = v
    if state.walkspeed then
        local char = lp.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char.Humanoid.WalkSpeed = v
        end
    end
end)

make_toggle(pageMain, "JumpPower", "jumppower",
    function()
        local char = lp.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char.Humanoid.UseJumpPower = true
            char.Humanoid.JumpPower = values.jumppower
        end
    end,
    function()
        local char = lp.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char.Humanoid.JumpPower = 50
        end
    end
)
local jpRow = make_slider(pageMain, "Jump Value", 50, 300, 100, function(v)
    values.jumppower = v
    if state.jumppower then
        local char = lp.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char.Humanoid.JumpPower = v
        end
    end
end)

-- ---------------- COMBAT PAGE ----------------
make_toggle(pageCombat, "Infinite Jump", "infinite_jump",
    function()
        track("inf_jump", UserInputService.JumpRequest:Connect(function()
            local char = lp.Character
            if char and char:FindFirstChildOfClass("Humanoid") then
                char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end))
    end,
    function()
        if conns["inf_jump"] then conns["inf_jump"]:Disconnect() end
    end
)

make_toggle(pageCombat, "Fly", "fly",
    function()
        local char = lp.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end

        local bv = Instance.new("BodyVelocity")
        bv.Name = "MRTX_Fly"
        bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        bv.Velocity = Vector3.zero
        bv.Parent = hrp

        track("fly", RunService.RenderStepped:Connect(function()
            if not state.fly then return end
            local cam = workspace.CurrentCamera
            local dir = hum.MoveDirection
            -- MoveDirection is already world-space.
            -- camera-relative shaping only needed for vertical.
            local move = dir * values.fly_speed
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                move = move + Vector3.new(0, values.fly_speed * 0.66, 0)
            end
            bv.Velocity = move
        end))

        task.spawn(function()
            while state.fly and bv.Parent do task.wait(0.25) end
            if bv then bv:Destroy() end
        end)
    end,
    function()
        local char = lp.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local bv = hrp:FindFirstChild("MRTX_Fly")
                if bv then bv:Destroy() end
            end
        end
    end
)

make_slider(pageCombat, "Fly Speed", 20, 200, 60, function(v)
    values.fly_speed = v
end)

-- ---------------- VISUAL PAGE ----------------
local function apply_esp(plr)
    if plr == lp then return end
    if plr.Character and not highlights[plr] then
        local hl = Instance.new("Highlight")
        hl.Name = "MRTX_ESP"
        hl.FillColor = ACCENT
        hl.OutlineColor = ACCENT2
        hl.FillTransparency = 0.6
        hl.OutlineTransparency = 0
        hl.Adornee = plr.Character
        hl.Parent = plr.Character
        highlights[plr] = hl
    end
end

make_toggle(pageVisual, "ESP (Highlight)", "esp",
    function()
        for _, plr in ipairs(Players:GetPlayers()) do apply_esp(plr) end
        track("esp_added", Players.PlayerAdded:Connect(function(plr)
            plr.CharacterAdded:Connect(function() task.wait(1); apply_esp(plr) end)
        end))
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= lp then
                plr.CharacterAdded:Connect(function() task.wait(1); apply_esp(plr) end)
            end
        end
    end,
    function()
        for _, hl in pairs(highlights) do hl:Destroy() end
        highlights = {}
        if conns["esp_added"] then conns["esp_added"]:Disconnect() end
    end
)

-- ---------------- MISC PAGE ----------------
make_toggle(pageMisc, "Noclip", "noclip",
    function()
        track("noclip", RunService.Stepped:Connect(function()
            if not state.noclip then return end
            local char = lp.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end))
    end,
    function()
        if conns["noclip"] then conns["noclip"]:Disconnect() end
        local char = lp.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
)

-- activate first tab
set_tab("Main")

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
devLabel.TextColor3 = Color3.fromRGB(170, 160, 200)
devLabel.TextSize = 11
devLabel.TextXAlignment = Enum.TextXAlignment.Left
devLabel.Parent = devRow

local badge = Instance.new("Frame")
badge.BackgroundColor3 = Color3.fromRGB(60, 120, 220)
badge.BorderSizePixel = 0
badge.Size = UDim2.new(0, 14, 0, 14)
badge.Position = UDim2.new(0, 0, 0.5, -7)
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
    badge.Position = UDim2.new(0, devLabel.AbsoluteSize.X + 4, 0.5, -7)
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

-- ======================================================
-- DRAG
-- ======================================================
local dragging, dragStart, startPos, blockDrag = false, nil, nil, false

minBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then blockDrag = true end
end)
minBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then blockDrag = false end
end)

titleBar.InputBegan:Connect(function(input)
    if blockDrag then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
    end
end)
titleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

-- ======================================================
-- RESTORE ORB
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
restore.Visible = false
restore.Parent = gui
Instance.new("UICorner", restore).CornerRadius = UDim.new(0, 20)

local rStroke = Instance.new("UIStroke", restore)
rStroke.Color = ACCENT
rStroke.Thickness = 1.5
rStroke.Transparency = 0.3

-- ======================================================
-- MINIMIZE / RESTORE
-- ======================================================
local minimized = false

local function minimize()
    if minimized then return end
    minimized = true
    local t = TweenService:Create(main, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
        Size = UDim2.new(0, 0, 0, 0),
    })
    t:Play(); t.Completed:Wait()
    main.Visible = false
    main.Size = UDim2.new(0, 260, 0, 320)

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
        Size = UDim2.new(0, 260, 0, 320),
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