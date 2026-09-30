-- MRTX | Shenru
-- dev: shenrukaidev • OWNER (verified)
-- target: Delta Executor (Android)

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local lp = Players.LocalPlayer

-- ---------- safe parent ----------
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

-- ---------- root ----------
local gui = Instance.new("ScreenGui")
gui.Name = "MRTX_Shenru"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = parent

-- ======================================================
-- MAIN WINDOW
-- ======================================================
local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, 320, 0, 400)
main.Position = UDim2.new(0.5, -160, 0.5, -200)
main.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
main.BorderSizePixel = 0
main.Active = true
main.ClipsDescendants = true
main.Parent = gui

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

local mainStroke = Instance.new("UIStroke", main)
mainStroke.Color = Color3.fromRGB(110, 70, 210)
mainStroke.Thickness = 1.5
mainStroke.Transparency = 0.35

local bgGrad = Instance.new("UIGradient", main)
bgGrad.Rotation = 90
bgGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(22, 22, 28)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(14, 14, 18)),
})

-- ======================================================
-- TITLE BAR
-- ======================================================
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 38)
titleBar.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
titleBar.BorderSizePixel = 0
titleBar.Parent = main

Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 10)

local titleCover = Instance.new("Frame")
titleCover.Size = UDim2.new(1, 0, 0, 10)
titleCover.Position = UDim2.new(0, 0, 1, -10)
titleCover.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
titleCover.BorderSizePixel = 0
titleCover.Parent = titleBar

local brand = Instance.new("TextLabel")
brand.BackgroundTransparency = 1
brand.Position = UDim2.new(0, 12, 0, 0)
brand.Size = UDim2.new(0, 220, 1, 0)
brand.Font = Enum.Font.GothamBold
brand.Text = "MRTX | Shenru"
brand.TextColor3 = Color3.fromRGB(220, 210, 255)
brand.TextSize = 15
brand.TextXAlignment = Enum.TextXAlignment.Left
brand.Parent = titleBar

-- ======================================================
-- MINIMIZE BUTTON
-- ======================================================
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 26, 0, 26)
minBtn.Position = UDim2.new(1, -36, 0.5, -13)
minBtn.BackgroundColor3 = Color3.fromRGB(32, 32, 42)
minBtn.Text = "–"
minBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 18
minBtn.AutoButtonColor = false
minBtn.Parent = titleBar

Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)

local minStroke = Instance.new("UIStroke", minBtn)
minStroke.Color = Color3.fromRGB(90, 70, 160)
minStroke.Thickness = 1
minStroke.Transparency = 0.4

-- ======================================================
-- SCROLL CONTENT
-- ======================================================
local content = Instance.new("ScrollingFrame")
content.Name = "Content"
content.Size = UDim2.new(1, -20, 1, -80)
content.Position = UDim2.new(0, 10, 0, 44)
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.ScrollBarThickness = 3
content.ScrollBarImageColor3 = Color3.fromRGB(110, 70, 210)
content.CanvasSize = UDim2.new(0, 0, 0, 0)
content.AutomaticCanvasSize = Enum.AutomaticSize.Y
content.Parent = main

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 8)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = content

local listPad = Instance.new("UIPadding")
listPad.PaddingBottom = UDim.new(0, 6)
listPad.Parent = content

-- ======================================================
-- FEATURE STATE
-- ======================================================
local state = {
    walkspeed = false,
    jumppower = false,
    infinite_jump = false,
    esp = false,
    fly = false,
}

local conns = {}
local highlights = {}

local function track(name, conn)
    if conns[name] then conns[name]:Disconnect() end
    conns[name] = conn
end

-- ======================================================
-- TOGGLE ROW HELPER
-- ======================================================
local function make_toggle(text, key, on_enable, on_disable)
    local row = Instance.new("TextButton")
    row.Name = key
    row.Size = UDim2.new(1, 0, 0, 38)
    row.BackgroundColor3 = Color3.fromRGB(26, 26, 34)
    row.Text = ""
    row.AutoButtonColor = false
    row.Parent = content

    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)

    local stroke = Instance.new("UIStroke", row)
    stroke.Color = Color3.fromRGB(80, 80, 110)
    stroke.Thickness = 1
    stroke.Transparency = 0.4

    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 12, 0, 0)
    label.Size = UDim2.new(1, -70, 1, 0)
    label.Font = Enum.Font.Gotham
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 195, 225)
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row

    local pill = Instance.new("Frame")
    pill.Size = UDim2.new(0, 40, 0, 20)
    pill.Position = UDim2.new(1, -52, 0.5, -10)
    pill.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    pill.BorderSizePixel = 0
    pill.Parent = row

    Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 16, 0, 16)
    knob.Position = UDim2.new(0, 2, 0.5, -8)
    knob.BackgroundColor3 = Color3.fromRGB(180, 180, 190)
    knob.BorderSizePixel = 0
    knob.Parent = pill

    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local function refresh()
        if state[key] then
            stroke.Color = Color3.fromRGB(140, 90, 240)
            stroke.Transparency = 0.1
            TweenService:Create(pill, TweenInfo.new(0.18), {
                BackgroundColor3 = Color3.fromRGB(90, 60, 170)
            }):Play()
            TweenService:Create(knob, TweenInfo.new(0.18), {
                Position = UDim2.new(1, -18, 0.5, -8),
                BackgroundColor3 = Color3.fromRGB(220, 210, 255),
            }):Play()
        else
            stroke.Color = Color3.fromRGB(80, 80, 110)
            stroke.Transparency = 0.4
            TweenService:Create(pill, TweenInfo.new(0.18), {
                BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            }):Play()
            TweenService:Create(knob, TweenInfo.new(0.18), {
                Position = UDim2.new(0, 2, 0.5, -8),
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
-- FEATURE IMPLEMENTATIONS
-- ======================================================

-- walkspeed
make_toggle("WalkSpeed [32]", "walkspeed",
    function()
        local char = lp.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char.Humanoid.WalkSpeed = 32
        end
    end,
    function()
        local char = lp.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char.Humanoid.WalkSpeed = 16
        end
    end
)

-- jumppower
make_toggle("JumpPower [100]", "jumppower",
    function()
        local char = lp.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char.Humanoid.UseJumpPower = true
            char.Humanoid.JumpPower = 100
        end
    end,
    function()
        local char = lp.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char.Humanoid.JumpPower = 50
        end
    end
)

-- infinite jump
make_toggle("Infinite Jump", "infinite_jump",
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

-- esp (basic highlight)
local function apply_esp(plr)
    if plr == lp then return end
    if plr.Character and not highlights[plr] then
        local hl = Instance.new("Highlight")
        hl.Name = "MRTX_ESP"
        hl.FillColor = Color3.fromRGB(180, 90, 255)
        hl.OutlineColor = Color3.fromRGB(120, 200, 255)
        hl.FillTransparency = 0.6
        hl.OutlineTransparency = 0
        hl.Adornee = plr.Character
        hl.Parent = plr.Character
        highlights[plr] = hl
    end
end

local function remove_esp(plr)
    if highlights[plr] then
        highlights[plr]:Destroy()
        highlights[plr] = nil
    end
end

make_toggle("ESP (Highlight)", "esp",
    function()
        for _, plr in ipairs(Players:GetPlayers()) do apply_esp(plr) end
        track("esp_added", Players.PlayerAdded:Connect(apply_esp))
        track("esp_char", Players.PlayerAdded:Connect(function(plr)
            plr.CharacterAdded:Connect(function() task.wait(1); apply_esp(plr) end)
        end))
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr.Character then
                plr.CharacterAdded:Connect(function() task.wait(1); apply_esp(plr) end)
            end
        end
    end,
    function()
        for plr, hl in pairs(highlights) do
            hl:Destroy()
        end
        highlights = {}
        if conns["esp_added"] then conns["esp_added"]:Disconnect() end
        if conns["esp_char"] then conns["esp_char"]:Disconnect() end
    end
)

-- fly
local function fly_loop()
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
        local move = Vector3.zero
        local dir = hum.MoveDirection
        move = cam.CFrame:VectorToWorldSpace(
            Vector3.new(dir.X, 0, dir.Z) * 60
        )
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            move = move + Vector3.new(0, 40, 0)
        end
        bv.Velocity = move
    end))

    -- cleanup when fly is disabled
    task.spawn(function()
        while state.fly and bv.Parent do task.wait(0.3) end
        if bv then bv:Destroy() end
    end)
end

make_toggle("Fly [Space=up]", "fly",
    function()
        fly_loop()
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

-- ======================================================
-- DEV CREDIT (bottom of main, outside scroller)
-- ======================================================
local devRow = Instance.new("Frame")
devRow.Name = "DevRow"
devRow.Size = UDim2.new(1, -20, 0, 26)
devRow.Position = UDim2.new(0, 10, 1, -32)
devRow.BackgroundTransparency = 1
devRow.Parent = main

-- label with automatic sizing so badge sits right next to it
local devLabel = Instance.new("TextLabel")
devLabel.BackgroundTransparency = 1
devLabel.Position = UDim2.new(0, 0, 0.5, -9)
devLabel.Size = UDim2.new(0, 0, 0, 18)
devLabel.AutomaticSize = Enum.AutomaticSize.X
devLabel.Font = Enum.Font.Gotham
devLabel.Text = "shenrukaidev • OWNER"
devLabel.TextColor3 = Color3.fromRGB(170, 160, 200)
devLabel.TextSize = 12
devLabel.TextXAlignment = Enum.TextXAlignment.Left
devLabel.Parent = devRow

-- circular verified badge, positioned right after label with 4px gap
local badge = Instance.new("Frame")
badge.Name = "Verified"
badge.BackgroundColor3 = Color3.fromRGB(60, 120, 220)
badge.BorderSizePixel = 0
badge.Size = UDim2.new(0, 16, 0, 16)
badge.Position = UDim2.new(0, 0, 0.5, -8)
badge.Parent = devRow

Instance.new("UICorner", badge).CornerRadius = UDim.new(1, 0)

local badgeGrad = Instance.new("UIGradient", badge)
badgeGrad.Rotation = 90
badgeGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 200, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(160, 100, 255)),
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
check.TextSize = 11
check.Parent = badge

-- glue badge to right of label whenever label resizes
local function reposition_badge()
    badge.Position = UDim2.new(0, devLabel.AbsoluteSize.X + 4, 0.5, -8)
end
devLabel:GetPropertyChangedSignal("AbsoluteSize"):Connect(reposition_badge)
task.defer(reposition_badge)

-- glow pulse on the badge
task.spawn(function()
    while badge and badge.Parent do
        TweenService:Create(badgeStroke, TweenInfo.new(1.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Transparency = 0.9,
            Color = Color3.fromRGB(180, 140, 255),
        }):Play()
        TweenService:Create(badge, TweenInfo.new(1.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            BackgroundColor3 = Color3.fromRGB(90, 60, 180),
        }):Play()
        task.wait(1.4)
        if not (badge and badge.Parent) then break end
        TweenService:Create(badgeStroke, TweenInfo.new(1.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Transparency = 0.3,
            Color = Color3.fromRGB(200, 220, 255),
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
    or input.UserInputType == Enum.UserInputType.Touch then
        blockDrag = true
    end
end)
minBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        blockDrag = false
    end
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
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
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
restore.Name = "Restore"
restore.Size = UDim2.new(0, 46, 0, 46)
restore.Position = UDim2.new(1, -60, 0, 80)
restore.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
restore.Text = "M"
restore.TextColor3 = Color3.fromRGB(220, 210, 255)
restore.Font = Enum.Font.GothamBold
restore.TextSize = 20
restore.AutoButtonColor = false
restore.Visible = false
restore.Parent = gui

Instance.new("UICorner", restore).CornerRadius = UDim.new(0, 23)

local rStroke = Instance.new("UIStroke", restore)
rStroke.Color = Color3.fromRGB(110, 70, 210)
rStroke.Thickness = 1.5
rStroke.Transparency = 0.3

local rGrad = Instance.new("UIGradient", restore)
rGrad.Rotation = 90
rGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(32, 32, 42)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 28)),
})

-- ======================================================
-- MINIMIZE / RESTORE
-- ======================================================
local minimized = false

local function minimize()
    if minimized then return end
    minimized = true

    local t = TweenService:Create(main, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 0, 0, 0),
    })
    t:Play()
    t.Completed:Wait()

    main.Visible = false
    main.Size = UDim2.new(0, 320, 0, 400)

    restore.Visible = true
    restore.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(restore, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 46, 0, 46),
    }):Play()
end

local function restore_window()
    if not minimized then return end
    minimized = false

    TweenService:Create(restore, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 0, 0, 0),
    }):Play()
    task.wait(0.18)
    restore.Visible = false
    restore.Size = UDim2.new(0, 46, 0, 46)

    main.Visible = true
    main.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(main, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 320, 0, 400),
    }):Play()
end

minBtn.Activated:Connect(minimize)

-- ======================================================
-- RESTORE ORB DRAG + TAP
-- ======================================================
local rDragging, rDragStart, rStartPos, rMoved = false, nil, nil, false

restore.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        rDragging = true
        rMoved = false
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